:- module(logicmoo_repl,[]).
/*
 Basic startup

*/

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD WEB HOOKS AND LOGTALK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- whenever_flag_permits(load_network,with_no_mpred_expansions(user:ensure_loaded(logicmoo_webbot))).
:- set_module(baseKB:class(development)).
:- set_prolog_flag(access_level,system).

:- set_prolog_flag(toplevel_print_anon,true).
% :- set_prolog_flag(toplevel_print_factorized,true).
% :- set_prolog_flag(toplevel_mode,recursive).

:- if(\+ current_module(baseKB)).
:- set_prolog_flag(logicmoo_qsave,true).
:- else.
:- set_prolog_flag(logicmoo_qsave,false).
:- endif.



%:- '$set_source_module'(baseKB).
%:- '$set_typein_module'(baseKB).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INIT BASIC FORWARD CHAINING SUPPORT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

:- baseKB:ensure_loaded(library(pfc_lib)).

init_mud_server:- ensure_loaded(library(prologmud_sample_games/run_mud_server)).

run_mud_server:- consult(library(prologmud_sample_games/run_mud_server)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [Optionaly] Load the EXTRA Logicmoo WWW System
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% forward chaining state browser
:- if(exists_source(library(xlisting_web))).
:- ensure_loaded(library(xlisting_web)).
:- endif.

:- during_boot(add_history_ideas).

%:- '$set_source_module'(baseKB).
%:- '$set_typein_module'(baseKB).

:- set_prolog_flag(do_renames,restore).
:- use_module(library(gvar_syntax)).
:- user:use_module(library(dif)).

:- baseKB:import(dif:dif/2).
:- baseKB:export(dif:dif/2).
:- catch(quietly(nodebugx(if_file_exists(baseKB:use_module(library(prolog_predicate))))),E,dmsg(E)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% These are probly loaded by other modules
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%:- ensure_loaded(library(multivar)).
%:- ensure_loaded(library(udt)).
%:- ensure_loaded(library(atts)).
%:- use_module(library(persistency)).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [Optionaly] Load the EXTRA Logicmoo WWW System
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% :- baseKB:ensure_loaded(library(xlisting_web)).
% :- if_file_exists(ensure_loaded(library(logicmoo/logicmoo_run_pldoc))).
% :- if_file_exists(ensure_loaded(library(logicmoo/logicmoo_run_swish))).

% :- after_boot(during_net_boot(kill_unsafe_preds)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% BINA48 Code!!!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%:- load_library_system(daydream).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INIT LOGICMOO (AUTOEXEC)  Load the infernce engine
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- set_prolog_flag(do_renames,restore).
:- baseKB:ensure_loaded(library(pfc_lib)).
:- set_prolog_flag(do_renames,restore).

% :- ls.

:- load_library_system(logicmoo_lib).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SETUP SANITY TEST EXTENSIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
decl_kb_shared_tests:-
 % sanity(listing((kb_global)/1)),
 kb_global(baseKB:sanity_test/0),
 kb_global(baseKB:regression_test/0),
 kb_global(baseKB:feature_test/0),
 kb_global(baseKB:(
        baseKB:feature_test/0,
        baseKB:mud_test/2,
        baseKB:regression_test/0,
        baseKB:sanity_test/0,
        baseKB:agent_call_command/2,
        action_info/2,
        type_action_info/3)).

:- decl_kb_shared_tests.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ONE SANITY TEST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
system:iRR7_test:-
 baseKB:(
    ain(isa(iRR7,tRR)),
    ain(genls(tRR,tRRP)),
    (\+ tRRP(iRR7) -> (xlisting(iRR7),xlisting(tRRP)) ; true),
    must( isa(iRR7,tRR) ),
    must( isa(iRR7,tRRP) ),
    must( tRRP(iRR7) )).

% :- iRR7_test.

:- after_boot_sanity_test(iRR7_test).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% KIF READER SANITY TESTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

show_kif(Str):- sanity(must(input_to_forms_debug(Str,sumo_to_pdkb))).


:- add_history((input_to_forms("
(=> (disjointDecomposition ?CLASS @ROW) (forall (?ITEM1 ?ITEM2) 
  (=> (and (inList ?ITEM1 (ListFn @ROW)) (inList ?ITEM2 (ListFn @ROW)) (not (equal ?ITEM1 ?ITEM2))) 
   (disjoint ?ITEM1 ?ITEM2))))"
  ,O,Vs),!,wdmsg(O+Vs))).

/*
:- must(input_to_forms("(=> (disjointDecomposition ?CLASS @ROW) (forall (?ITEM1 ?ITEM2) (=> (and (inList ?ITEM1 (ListFn @ROW)) (inList ?ITEM2 (ListFn @ROW)) (not (equal ?ITEM1 ?ITEM2))) (disjoint ?ITEM1 ?ITEM2))))",O,Vs)),!,wdmsg(O+Vs).
:- must(((input_to_forms("(=> (disjointDecomposition ?CLASS @ROW) (forall (?ITEM1 ?ITEM2) (=> (and (inList ?ITEM1 (ListFn @ROW)) (inList ?ITEM2 (ListFn @ROW)) (not (equal ?ITEM1 ?ITEM2))) (disjoint ?ITEM1 ?ITEM2))))",O,Vs)),!,wdmsg(O+Vs))).
:- must(input_to_forms_debug("(=> (disjointDecomposition ?CLASS @ROW) (forall (?ITEM1 ?ITEM2) (=> (and (inList ?ITEM1 (ListFn @ROW)) (inList ?ITEM2 (ListFn @ROW)) (not (equal ?ITEM1 ?ITEM2))) (disjoint ?ITEM1 ?ITEM2))))",sumo_to_pdkb)).
*/
:- show_kif("(=> (disjointDecomposition ?CLASS @ROW) (forall (?ITEM1 ?ITEM2) (=> (and (inList ?ITEM1 (ListFn @ROW)) (inList ?ITEM2 (ListFn @ROW)) (not (equal ?ITEM1 ?ITEM2))) (disjoint ?ITEM1 ?ITEM2))))").
:- show_kif("(=> (isa ?NUMBER ImaginaryNumber) (exists (?REAL) (and (isa ?REAL RealNumber) (equal ?NUMBER (MultiplicationFn ?REAL (SquareRootFn -1))))))").
:- show_kif("(=> (isa ?PROCESS DualObjectProcess) (exists (?OBJ1 ?OBJ2) (and (patient ?PROCESS ?OBJ1) (patient ?PROCESS ?OBJ2) (not (equal ?OBJ1 ?OBJ2)))))").
:- show_kif("(=> (contraryAttribute @ROW) (=> (inList ?ELEMENT (ListFn @ROW)) (isa ?ELEMENT Attribute)))").
:- show_kif("(=> (and (contraryAttribute @ROW1) (identicalListItems (ListFn @ROW1) (ListFn @ROW2))) (contraryAttribute @ROW2))").
:- show_kif("(=> (contraryAttribute @ROW) (forall (?ATTR1 ?ATTR2) (=> (and (equal ?ATTR1 (ListOrderFn (ListFn @ROW) ?NUMBER1)) (equal ?ATTR2 (ListOrderFn (ListFn @ROW) ?NUMBER2)) (not (equal ?NUMBER1 ?NUMBER2))) (=> (property ?OBJ ?ATTR1) (not (property ?OBJ ?ATTR2))))))").
:- show_kif("(=> (equal ?NUMBER (MultiplicationFn 1 ?NUMBER)) (equal (MeasureFn ?NUMBER CelsiusDegree) (MeasureFn (DivisionFn (SubtractionFn ?NUMBER 32) 1.8) FahrenheitDegree)))").
:- show_kif("(DivisionFn (SubtractionFn ?NUMBER 32) 1.8 #C(1.2 9))").


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LOAD LOGICMOO KB EXTENSIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
:- check_clause_counts.

% :- load_library_system(library(logicmoo_lib)).
% :- load_library_system(logicmoo(logicmoo_plarkc)).

:- after_boot((set_prolog_flag(pfc_booted,true))).

:- nb_setval('$oo_stack',[]).
:- b_setval('$oo_stack',[]).

%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QSAVE LM_REPL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% {flatTrans(G)}==>{listing(G/2)}.
:- if(current_prolog_flag(logicmoo_qsave,true)).
:- baseKB:qsave_lm(lm_repl).
:- endif.

:- set_prolog_flag(access_level,system).
:- if(false).
:- statistics.
:- endif.



