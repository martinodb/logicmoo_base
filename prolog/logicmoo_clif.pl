:- module(logicmoo_clif,[]).

/** <module> logicmoo_plarkc - special module hooks into the logicmoo engine allow
   clif syntax to be recocogized via our CycL/KIF handlers 
 
 Logicmoo Project: A LarKC Server written in Prolog
 Maintainer: Douglas Miles
 Dec 13, 2035

 ?- ensure_loaded(library(logicmoo_clif)).

:- set_prolog_flag(verbose_autoload,true).
*/


:- set_fileAssertMt(baseKB).

:- set_defaultAssertMt(baseKB).

:- set_prolog_flag_until_eof(retry_undefine,false).

:- user:use_module(library(logicmoo_util_common)).

:- dynamic   user:file_search_path/2.
:- multifile user:file_search_path/2.
:- prolog_load_context(directory,Dir),
   DirFor = library,
   during_boot((( \+ user:file_search_path(DirFor,Dir)) ->asserta(user:file_search_path(DirFor,Dir));true)),!.

:- '$set_source_module'(baseKB).

:- asserta_new(user:file_search_path(logicmoo,library('logicmoo/.'))).
:- asserta_new(user:file_search_path(logicmoo,library('.'))).

% :- add_library_search_path('./logicmoo/common_logic/',[ 'common_*.pl']).


:- reexport(library('logicmoo/common_logic/common_logic_utils.pl')).
:- reexport(library('logicmoo/common_logic/common_logic_boxlog.pl')).
:- reexport(library('logicmoo/common_logic/common_logic_modal.pl')).
:- reexport(library('logicmoo/common_logic/common_logic_exists.pl')).
:- reexport(library('logicmoo/common_logic/common_logic_compiler.pl')). 
:- reexport(library('logicmoo/common_logic/common_logic_kb_hooks.pl')).
:- reexport(library('logicmoo/common_logic/common_logic_loader.pl')).
:- reexport(library('logicmoo/common_logic/common_logic_theorist.pl')).
:- reexport(library('logicmoo/common_logic/common_logic_reordering.pl')).
:- reexport(library('logicmoo/common_logic/common_logic_snark.pl')). 
:- reexport(system:library('logicmoo/common_logic/common_logic_sanity.pl')).

:- ensure_loaded(baseKB:library('logicmoo/common_logic/common_logic_clif.pfc')).

% 

really_load_clif_file(Found, Options):-
  dmsg(really_load_clif_file(Found, Options)),
  fail.

maybe_load_clif_file(Found, Options):- 
  atom(Found),exists_file(Found),!,
  file_name_extension(_,Ext,Found),
  memberchk(Ext,['.clif','.ikl','.kif','.lbase']),!,
  really_load_clif_file(Found, Options).
  
maybe_load_clif_file(Spec, Options):- 
  notrace(absolute_file_name(Spec,Found,[extensions(['.clif','.ikl','.kif',
  %'.lisp',
  '.lbase']),access(read),expand(true),solutions(all)])),
  exists_file(Found),!,
  really_load_clif_file(Found, Options).

:- fixup_exports.

:- dynamic user:prolog_load_file/2.
:- multifile user:prolog_load_file/2.
:- use_module(library(must_trace)).
user:prolog_load_file(Spec, Options):- maybe_load_clif_file(Spec, Options),!.

:- kif_compile.





end_of_file.
end_of_file.
end_of_file.
end_of_file.
end_of_file.



end_of_file.
end_of_file.
end_of_file.
end_of_file.
end_of_file.



end_of_file.
end_of_file.
end_of_file.
end_of_file.
end_of_file.



end_of_file.
end_of_file.
end_of_file.
end_of_file.
end_of_file.



/*


*/


/*
:- add_library_search_path('./pfc2.0/',[ 'mpred_*.pl']).
:- add_library_search_path('./logicmoo/',[ '*.pl']).
%:- add_library_search_path('./logicmoo/pttp/',[ 'dbase_i_mpred_*.pl']).
%:- add_library_search_path('./logicmoo/../',[ 'logicmoo_*.pl']).
%:- must(add_library_search_path('./logicmoo/mpred_online/',[ '*.pl'])).

*/

%:- system:initialization(use_listing_vars).


%:- add_import_module(baseKB,system,end).
%:- initialization(maybe_add_import_module(baseKB,system,end)).
% :- with_umt(baseKB,baseKB:use_module(baseKB:logicmoo_base)).

:-export(checkKB:m1/0).

/*  Provides a prolog database replacement that uses an interpretation of KIF
%
%  t/N
%  hybridRule/2
%  
%
% Logicmoo Project PrologMUD: A MUD server written in Prolog
% Maintainer: Douglas Miles
% Dec 13, 2035
%
*/
%= Compute normal forms for SHOIQ formulae.
%= Skolemize SHOI<Q> formula.
%=
%= Copyright (C) 1999 Anthony A. Aaby <aabyan@wwc.edu>
%= Copyright (C) 2006-2007 Stasinos Konstantopoulos <stasinos@users.sourceforge.net>
%= Douglas R. Miles <logicmoo@gmail.com>
%=
%= This program is free software; you can redistribute it and/or modify
%= it under the terms of the GNU General Public License as published by
%= the Free Software Foundation; either version 2 of the License, or
%= (at your option) any later version.
%=
%= This program is distributed in the hope that it will be useful,
%= but WITHOUT ANY WARRANTY; without even the implied warranty of
%= MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%= GNU General Public License for more details.
%=
%= You should have received a copy of the GNU General Public License along
%= with this program; if not, write to the Free Software Foundation, Inc.,
%= 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
%=
%= FORMULA SYNTAX
%=
%= not(A)
%= &(F, F)
%= v(F, F)
%= '=>'(F, F)
%= '<=>'(F, F)
%=    all(X,A)
%=    exists(X,A)
%=    atleast(X,N,A)
%=    atmost(X,N,A)



end_of_file.


:- system:reexport(library(logicmoo_lib)).

:- include(logicmoo(mpred/'mpred_header.pi')).

% SWI Prolog modules do not export operators by default
% so they must be explicitly placed in the user namespace

:-
 op(1199,fx,('==>')), 
 op(1190,xfx,('::::')),
 op(1180,xfx,('==>')),
 op(1170,xfx,'<==>'),  
 op(1160,xfx,('<-')),
 op(1150,xfx,'=>'),
 op(1140,xfx,'<='),
 op(1130,xfx,'<=>'), 
 op(600,yfx,'&'), 
 op(600,yfx,'v'),
 op(350,xfx,'xor'),
 op(300,fx,'~'),
 op(300,fx,'-').

:- if( \+ op(_,_,(user:kb_shared))).
% :- op(1150,fx,(user:kb_shared)).
:- endif.



:- was_dynamic(kif_pred_head/1).
:- style_check(-singleton).

kif_pred_head(P):- var(P),!,isa(F,prologKIF),arity(F,A),functor(P,F,A).
kif_pred_head(P):- get_functor(P,F,_),isa(F,prologKIF).
kif_pred_head(P):- get_functor(P,F,_),isa(F,prologPTTP).


:- was_dynamic(pttp_pred_head/1).

pttp_pred_head(P):- var(P),isa(F,prologPTTP),arity(F,A),functor(P,F,A).
pttp_pred_head(P):- get_functor(P,F,_),isa(F,prologPTTP).

% :- kb_shared(kify_comment/1).


pttp_listens_to_head(_OP,P):- pttp_pred_head(P).

pttp_listens_to_stub(prologPTTP).
pttp_listens_to_stub(prologKIF).


baseKB:mpred_provide_setup(Op,H):- provide_kif_op(Op,H).

% OPHOOK ASSERT
provide_kif_op(clause(assert,How),(HeadBody)):- 
   pttp_listens_to_head(clause(assert,How),HeadBody),
   why_to_id(provide_kif_op,(HeadBody),ID),
   kif_add_boxes1(ID,(HeadBody)).

% OPHOOK CALL
provide_kif_op(call(How),Head):- 
  pttp_listens_to_head(call(How),Head),
  pttp_call(Head).

% OPHOOK CLAUSES
provide_kif_op(clauses(How),(Head:- Body)):- 
   pttp_listens_to_head(clauses(How),Head),
   baseKB:mpred_provide_storage_clauses(Head,Body,_Why).

% OPHOOK 
provide_kif_op(OP,(HeadBody)):- 
   pttp_listens_to_head(OP,HeadBody),
   kif_process(OP,HeadBody).


:- multifile(baseKB:mpred_provide_storage_clauses/3).
% CLAUSES HOOK 
baseKB:mpred_provide_storage_clauses(H,B,wid3(IDWhy)):- wid(IDWhy,_,(H:- B)).
baseKB:mpred_provide_storage_clauses(H,true,wid3(IDWhy)):- wid(IDWhy,_,(H)),!,compound(H),not(functor(H,':-',2)).


% REGISTER HOOK
baseKB:mpred_provide_setup(OP,HeadIn,StubType,RESULT):-  pttp_listens_to_stub(StubType),!,
   get_pifunctor3(HeadIn,Head,F),
      assert_if_new(isa(F,prologPTTP)),
         ensure_universal_stub(Head),
         RESULT = declared(pttp_listens_to_head(OP,Head)).


/*

:- was_dynamic(baseKB:int_proven_t/10).

int_proven_t(P, X, Y, E, F, A, B, C, G, D):- t(P,X,Y),
        test_and_decrement_search_cost(A, 0, B),
        C=[H, [true_t(P, X, Y), D, E, F]|I],
        G=[H|I].


:- was_dynamic(baseKB:int_assumed_t/10).
int_assumed_t(P, X, Y, E, F, A, B, C, G, D):- t(P,X,Y),
        test_and_decrement_search_cost(A, 0, B),
        C=[H, [assumed_t(P, X, Y), D, E, F]|I],
        G=[H|I].



*/

:- fixup_exports.

:- kif_compile.
