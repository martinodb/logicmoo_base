
:- module(kb,[]).
%:- set_prolog_flag(write_attributes,portray).
:- listing(ls).

:- use_module(library(must_trace)).
% :- use_module(library(loop_check)).
:- use_module(library(logicmoo_typesystem)).
:- use_module(library(logicmoo_clif)).

kb:real_static.
kbi:real.
%:- module(kb).
:- '$set_source_module'(kb).
:- make.

:- fav_debug.

% =================
% Cute and Lazy
% =================


memberchk_eq(X, [Y|Ys]) :- (   X == Y ->  true ;   memberchk_eq(X, Ys)).
subtract_eq([],_,[],[]).
subtract_eq([X|Xs],Ys,L,[X|Intersect]) :-   memberchk_eq(X,Ys),subtract_eq(Xs,Ys,L,Intersect).
subtract_eq([X|Xs],Ys,[X|T],Intersect) :-   subtract_eq(Xs,Ys,T,Intersect).

% :- abolish(user:portray/1).
:- dynamic(user:portray/1).
:- multifile(user:portray/1).



make_identity(I):- make_type(identityPred:I/2).

make_type(Info):- make_type0(Info).
make_type0(T:F/A):-!,functor(P,F,A),make_type0(T:P).
make_type0(T:FA):- functor(FA,F,A),functor(P,F,A), assert_kbi( (P:- kb:call(T,P))),ain(baseKB:safe_wrap(baseKB,F,A,T)).
make_type0(F):- atom(F),!,make_type0(head_call:F/1).
make_type0(P):-make_type0(head_call:P).


exists:attr_portray_hook(Attr,Var):- one_portray_hook(Var,exists(Var,Attr)).


:- module_transparent(user:portray_var_hook/1).
:- multifile(user:portray_var_hook/1).
:- dynamic(user:portray_var_hook/1).

user:portray_var_hook(Var) :- 
 current_prolog_flag(write_attributes,portray),
 attvar(Var),
 get_attr(Var,exists,Val),
  current_prolog_flag(write_attributes,Was),
  setup_call_cleanup(set_prolog_flag(write_attributes,ignore),
    writeq({exists(Var,Val)}),
    set_prolog_flag(write_attributes,Was)),!.


add_dom_differentFromAll(Ex,DisjExs):- add_dom_list_val(dif,differentFromAll,Ex,DisjExs).


add_dom_list_val(_,_,_,[]):- !.
add_dom_list_val(Pred1,_,X,[Y]):- atom(Pred1), X==Y -> true;P=..[Pred1,X,Y],add_dom(X,P). 
add_dom_list_val(Pred1,Pred,X,FreeVars):- list_to_set(FreeVars,FreeVarSet),FreeVars\==FreeVarSet,!,
  add_dom_list_val(Pred1,Pred,X,FreeVarSet).
add_dom_list_val(_Pred,Pred,X,FreeVars):- P=..[Pred,X,FreeVars],add_dom(X,P).

one_portray_hook(Var,Attr):-
  locally(set_prolog_flag(write_attributes,ignore),
  ((setup_call_cleanup(set_prolog_flag(write_attributes,ignore),
  ((subst(Attr,Var,SName,Disp),!,
  get_var_name(Var,Name),
   (atomic(Name)->SName=Name;SName=self),
   format('~p',[Disp]))),
   set_prolog_flag(write_attributes,portray))))).

:- dynamic(identityPred/1).

visit_exs(P,P,_,In,In):- \+ compound(P),!.

visit_exs(ex(X,P),InnerP,FreeVars,In,Out):- append(In,[X],Mid),   
 add_dom_list_val(skFArg,skFArgs,X,FreeVars),
 visit_exs(P,InnerP,[X|FreeVars],Mid,Out),!,
 add_dom(X,exists(X,InnerP)).
visit_exs(all(X,P),InnerP,FreeVars,In,Out):- append(In,[X],Mid),
  visit_exs(P,InnerP,[X|FreeVars],Mid,Out),!.
visit_exs(P,POut,FreeVars,In,Rest):-arg(_,P,PP),compound(PP),!,P=..[F|ARGS],get_ex_quants_l(FreeVars,ARGS,ARGSO,In,Rest),POut=..[F|ARGSO].
visit_exs(P,P,_,In,In).

assert_kbi(P):- must(kbi:assert_if_new(P)).

get_ex_quants_l(_,[],[],IO,IO).  
get_ex_quants_l(FreeVars,[X|ARGS],[Y|ARGSO],In,Rest):-
  visit_exs(X,Y,FreeVars,In,M),
  get_ex_quants_l(FreeVars,ARGS,ARGSO,M,Rest).

unify_two(AN,AttrX,V):- nonvar(V),!, (V='$VAR'(_)->true;throw(unify_two(AN,AttrX,V))).
unify_two(AN,AttrX,V):- get_attr(V,AN,OAttr),!,OAttr=@=AttrX,!. % ,show_call(OAttr=@=AttrX).
unify_two(AN,AttrX,V):- put_attr(V,AN,AttrX).

exists:attr_unify_hook(Ex,V):- unify_two(exists,Ex,V).
v:attr_unify_hook(Ex,V):- unify_two(exists,Ex,V). % trace, (var(V)->unify_two(v,Ex,V);(throw("!bindingOf " : Ex=V))).

kbi:bindingOf(Ex,V):- Ex==V,!.
kbi:bindingOf(Ex,V):- var(V),!,freeze(V,assign_ex(Ex,V)).
kbi:bindingOf(Ex,V):- get_attr(Ex,v,V0)->V0=@=V;put_attr(Ex,v,V).


assign_ex(Ex,V):- kbi:bindingOf(Ex,V).

reify((P,Q)):-!,reify(P),reify(Q).
reify(P):- query_ex(P).



% ex(P):- compound(P),P=..[_,I], (var(I)-> freeze(I,from_ex(P)) ; fail).

existential_var(Var,_):- nonvar(Var),!.
existential_var(Var,_):- attvar(Var),!.
existential_var(Var,P):- put_attr(Var,exists,P),!.


solve_ex(Var,_Vs,_Head,P,BodyList):- 
  existential_var(Var,P), 
  maplist(kb:bless_with,BodyList), maplist(kb:body_call,BodyList).

bless_with(P):- ground(P),!.
bless_with(P):- bless(P).

% body_call(P):- recorded(kbi,P).
body_call(P):- ground(P),!,kbi:loop_check(P).
body_call(P):- bless(P).


is_recorded(A):- recorded(kbi,A),nop(sanity(\+cyclic_term(A))).

% WORDED head_call(P):- (kbi:clause(can_bless(P),Body)*->Body; ((fail,kb:bless(P)))),is_recorded(P).

head_call(P):- is_recorded(P).
% head_call(P):- bless(P),(kbi:clause(existing(P),Body)*->Body; true),ignore(is_recorded(P)).

bless(P):-ground(P),!.
bless(P):- 
 (get_ev(P,Attvars,Univ)),
   (Univ == [] -> true ;
       maplist(add_constraint_ex(bless_ex,P),Univ)),
   (Attvars == [] -> true ;
        maplist(add_constraint_ex(bless_ex,P),Attvars)),
 nop(Attvars == [] -> true ;
      maplist(add_constraint_ex(bless_ex2,P),Attvars)).

% add_constraint_ex(_Call,_P,_V):-!,fail.
add_constraint_ex(_,P,V):- \+ contains_var(V,P),!.
add_constraint_ex(Call,P,V):-freeze(V,call(Call,V,P)).

get_ev(P,Annotated,Plain):- 
    term_variables(P,Vars),
    term_attvars(P,Annotated),
    subtract_eq(Vars,Annotated,Plain).

labling_ex(P):- copy_term(P,PP,Residuals),maplist(call,Residuals),P=PP.


bless_ex2(_X,P):- \+ ground(P).
bless_ex(X, P):- nonvar(X)->call(P); true.

query_ex(P):- ignore(show_failure(P)).
% query_ex(P):- is_recorded(P),recorded(complete,P).

minus_vars(Head,Minus,Dif):-
   term_variables(Head,HeadVars),
   term_variables(Minus,BodyVars),
   subtract_eq(HeadVars,BodyVars,Dif).


%===
%create_ex(_,Lit1,_):- ground(Lit1),!.
%create_ex(X,Lit1,BodyLits,Prop,DisjExs):- \+ contains_var(X,Lit1),assert_if_new((gen_out(Lit1):- ensure_sneezed(X,Lit1,BodyLits,Prop,[]))),fail.
%===
do_create_cl(Lit1,BodyLits,Prop):-   
   (current_predicate(_,Lit1)->true;make_type(Lit1)),   
   term_variables(Lit1,AllHeadVars),
   maplist(add_dom_rev(Lit1),AllHeadVars),
   term_variables(BodyLits,AllBodyVars),
   subtract_eq(AllHeadVars,AllBodyVars,UniqeHead,Intersect),
   subtract_eq(AllBodyVars,AllHeadVars,UniqeBody,_BodyIntersect),
   create_ex(Lit1,Prop,UniqeHead,Intersect,UniqeBody,BodyLits),
   recorda_if_new(Lit1).


create_ex(Lit1,Prop,UniqeHead,Intersect,UniqeBody,BodyLits):-
   recorda_if_new(Lit1,head_body(Lit1,BodyLits,UniqeHead,Intersect,UniqeBody,Prop)).

comingle_vars(QuantsList,NewP):- 
   maplist(add_all_differnt(QuantsList,NewP),QuantsList).

add_all_differnt(QuantsList,_NewP,Ex):-
    delete_eq(QuantsList,Ex,DisjExs),
    add_dom_differentFromAll(Ex,DisjExs).

recorda_if_new(K,Lit1):- functor(Lit1,F,A),functor(Lit0,F,A),recorded(K,Lit0),Lit0=@=Lit1,!,wdmsg(skip_recorda(Lit0=@=Lit1)).
recorda_if_new(K,Lit1):- show_call(recorda(K,Lit1)).

recorda_if_new(Lit1):- recorda_if_new(kbi,Lit1). 


assert_ex((P -> Q)):- !, assert_kbi(Q:-head_call(P)).
assert_ex(reduced(P)):- !, recorda_if_new(P).


assert_ex(quanted(QuantsList,NewP)):-
  comingle_vars(QuantsList,NewP),
  conjuncts_to_list(NewP,Lits),!,
  forall(select(Lit1,Lits,BodyLits),
   (nop(recorda_if_new(Lit1)),
     assert_ex(create_cl(Lit1,BodyLits,NewP)))).

assert_ex(create_cl(Lit1,BodyLits,NewP)):- !,  
  do_create_cl(Lit1,BodyLits,NewP).

assert_ex(P):- visit_exs(P,NewP,[],[],QuantsList),   
    (QuantsList \== [] 
     -> assert_ex(quanted(QuantsList,NewP));
     NewP\==P -> assert_ex(reduced(NewP));
     assert_ex(reduced(NewP))).


                                    
% import_ex(F/A):-kbi:current_predicate(_,kbi:F/A),!, kbi:export(kbi:F/A), kb:import(kbi:F/A).
import_ex(F/A):-kb:export(kb:F/A),system:import(kb:F/A), kbi:import(kb:F/A).

disp_ex(X):-fmt9(X).

lr:- notrace((listing(kbi:_),
  doall((current_key(K),recorded(K,P),
    locally(set_prolog_flag(write_attributes,portray),wdmsg(P)))))).


:- kb:export(kb:import_ex/1).
:- kbi:import(kb:import_ex/1).
:- import_ex(make_type/1).
:- import_ex(assert_ex/1).
:- import_ex(disp_ex/1).
:- import_ex(is_recorded/1).
:- import_ex(lr/0).

:- fixup_exports.

% =================
% example
% =================



:- if(false).
:- '$set_source_module'('$attvar').
:- abolish('system':portray_attvar/1).
:- abolish('$attvar':portray_attvar/1).
:- asserta((user:portray(V):- notrace((attvar(V),catch(portray_av(V),_,fail))),!)).
portray_av(Var):- notrace((get_attr(Var,exists,Attr),one_portray_hook(Var,exists(Var,Attr)))),!.
portray_av(Var):- get_attrs(Var,att(N,Attr,_)),one_portray_hook(Var,N:Attr),!.
'$attvar':portray_attvar(Var) :- (notrace((kb:portray_av(Var)))),!.
'$attvar':portray_attvar(Var) :- 
 '$attvar':((write('{'),
    get_attrs(Var, Attr),
    portray_attrs(Attr, Var),write('}'))).
:- public('$attvar':portray_attvar/1).
:- '$attvar':export('$attvar':portray_attvar/1).
:- '$set_source_module'(kb).

:- '$set_source_module'(kbi).
:- set_prolog_flag(write_attributes,ignore).
:- endif.

:- '$set_source_module'(kbi).
:- set_prolog_flag(write_attributes,portray).


% :- make_type(god).
:- make_type(female).
:- make_type(male).
:- make_identity(bindingOf).
:- make_type(loves/2).


% :- rtrace,trace.
% :- assert_ex(male(joe)).


:- ((assert_ex((
 ex(God,
    ex(Mary,
   (   female(Mary),
       bindingOf(Mary,true),
       god(God),
       bindingOf(God,god),
       loves(Mary,God)))))))).

:- assert_ex(
  all(Child,
    ex(Mother,
   (   child(Child),
       female(Mother),
       bindingOf(Child,childOf(Mother)),       
       mother(Child,Mother))))).

:- assert_ex(ex(Child,child(Child))).

:- (assert_ex(
  ex(Mary,
    ex(John,
   (   female(Mary),
       bindingOf(Mary,true),
       male(John),
       bindingOf(John,0),
       loves(John,Mary)))))).

% ?- female(Whom).

%:- trace,t2.

:- module(kbi).
:- lr.

:- set_prolog_flag(write_attributes,ignore).




