/* 
% ===================================================================
% File 'common_logic_sanity.pl'
% Purpose: Emulation of OpenCyc for SWI-Prolog
% Maintainer: Douglas Miles
% Contact: $Author: dmiles $@users.sourceforge.net ;
% Version: 'interface.pl' 1.0.0
% Revision:  $Revision: 1.9 $
% Revised At:   $Date: 2002/06/27 14:13:20 $
% ===================================================================
% File used as storage place for all predicates which make us more like Cyc
% special module hooks into the logicmoo engine allow
% syntax to be recocogized via our CycL/KIF handlers 
%
% Dec 13, 2035
% Douglas Miles
*/

% File: /opt/PrologMUD/pack/logicmoo_base/prolog/logicmoo/plarkc/common_logic_sanity.pl
:- module(common_logic_sanity,[test_boxlog/1,test_boxlog/2,test_defunctionalize/1]).       

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

:- ensure_loaded(library(logicmoo_snark)).

% test_boxlog(P,BoxLog):-logicmoo_motel:kif_to_motelog(P,BoxLog),!.

test_boxlog(P,BoxLog):- kif_to_boxlog(P,BoxLog).

test_defunctionalize(I):-defunctionalize(I,O),wdmsg(O).

test_boxlog(P):- fmt(:- test_boxlog(P)), b_implode_varnames(P),nl,nl,test_boxlog(P,O),nl,nl,(is_list(O)->maplist(wdmsg,O);wdmsgl(O)).


% ================
% all rooms have a door
% ================
:- test_boxlog(all(R,implies(room(R),exists(D,and(door(D),has(R,D)))))).

% door(D) :-
%       room(R),
%       skolem(D, skIsDoorInUnkArg2ofHas_1Fn(R)).
% ~room(R) :-
%       \+ ( 
%            door(D)
%          ).
% ~room(R) :-
%       \+ ( 
%            has(R, D)
%          ).
% has(R, D) :-
%       room(R),
%       skolem(D, skIsDoorInUnkArg2ofHas_1Fn(R)).

% ================
% For joe to eat the food it must be possible that the food is food and joe can eat it
% ================
:- test_boxlog(poss(&(eats(joe,X),food(X)))=>(eats(joe,X),food(X))).

% eats(joe,X) :-
%       \+ ~eats(joe,X),
%       \+ ~food(X).
% food(X) :-
%       \+ ~eats(joe,X),
%       \+ ~food(X).


% ================================================
%  Organized Groups of prolog programmers have prolog programmers as members
% ================================================

:- test_boxlog(implies(and(isa(M,tGroupedPrologOrganization),hasMembers(M,A)), isa(A,tClazzPrologPerson))).
/*
 ~hasMembers(_11164,_11142):- \+ (isa(_11164,tGroupedPrologOrganization),isa(_11142,tClazzPrologPerson))
 ~isa(_11540,tGroupedPrologOrganization):- \+ (hasMembers(_11540,_11518),isa(_11518,tClazzPrologPerson))
 isa(_11874,tClazzPrologPerson):-isa(_11896,tGroupedPrologOrganization),hasMembers(_11896,_11874)
*/

% ================================================
% Those competeing in watersports may not wear shoes
% ================================================
:- test_boxlog( =>(isa(ATH,tAgent),implies(and(isa(COMP,actAquaticSportsEvent),
  competingAgents(COMP,ATH)),holdsIn(COMP,all(CLOTHING,not(and(isa(CLOTHING,tObjectShoe),wearsClothing(ATH,CLOTHING)))))))).
/*
 ~competingAgents(_20514,_20492):- ~holdsIn(_20514,v(~isa(_20470,tObjectShoe),~wearsClothing(_20492,_20470))),isa(_20514,actAquaticSportsEvent),isa(_20492,tAgent)
 ~isa(_20902,tAgent):- ~holdsIn(_20858,v(~isa(_20880,tObjectShoe),~wearsClothing(_20902,_20880))),isa(_20858,actAquaticSportsEvent),competingAgents(_20858,_20902)
 ~isa(_21272,actAquaticSportsEvent):- ~holdsIn(_21272,v(~isa(_21250,tObjectShoe),~wearsClothing(_21228,_21250))),competingAgents(_21272,_21228),isa(_21228,tAgent)
 holdsIn(_21612,v(~isa(_21634,tObjectShoe),~wearsClothing(_21590,_21634))):-isa(_21612,actAquaticSportsEvent),competingAgents(_21612,_21590),isa(_21590,tAgent)
*/
% ~occuring(COMP) :-
%       isa(ATH, tAgent),
%       isa(COMP, actAquaticSportsEvent),
%       competingAgents(COMP, ATH),
%       isa(CLOTHING, tObjectShoe),
%       wearsClothing(ATH, CLOTHING).
% ~competingAgents(COMP, ATH) :-
%       isa(ATH, tAgent),
%       isa(COMP, actAquaticSportsEvent),
%       occuring(COMP),
%       isa(CLOTHING, tObjectShoe),
%       wearsClothing(ATH, CLOTHING).
% ~isa(CLOTHING, tObjectShoe) :-
%       isa(ATH, tAgent),
%       isa(COMP, actAquaticSportsEvent),
%       competingAgents(COMP, ATH),
%       occuring(COMP),
%       wearsClothing(ATH, CLOTHING).
% ~isa(COMP, actAquaticSportsEvent) :-
%       isa(ATH, tAgent),
%       competingAgents(COMP, ATH),
%       occuring(COMP),
%       isa(CLOTHING, tObjectShoe),
%       wearsClothing(ATH, CLOTHING).
% ~isa(ATH, tAgent) :-
%       isa(COMP, actAquaticSportsEvent),
%       competingAgents(COMP, ATH),
%       occuring(COMP),
%       isa(CLOTHING, tObjectShoe),
%       wearsClothing(ATH, CLOTHING).
% ~wearsClothing(ATH, CLOTHING) :-
%       isa(ATH, tAgent),
%       isa(COMP, actAquaticSportsEvent),
%       competingAgents(COMP, ATH),
%       occuring(COMP),
%       isa(CLOTHING, tObjectShoe).

% ====================================================================
% When sightgseeing is occuring .. there is a tourist present
% ====================================================================
:- test_boxlog(implies(and(isa(Act,actSightseeing),performedBy(Person,Act)),holdsIn(Act,isa(Person,mobTourist)))).

/* OLD
 ~isa(_11704,actSightseeing):- \+ (performedBy(_11704,_11682),holdsIn(_11704,isa(_11682,mobTourist)))
 ~performedBy(_12092,_12070):- \+ (isa(_12092,actSightseeing),holdsIn(_12092,isa(_12070,mobTourist)))
 holdsIn(_12442,isa(_12420,mobTourist)):-isa(_12442,actSightseeing),performedBy(_12442,_12420)

*/
% ~occuring(Act) :-
%       \+ ( isa(Act, actSightseeing),
%            naf(~performedBy(Person, Act)),
%            isa(Y, mobTourist)
%          ).
% ~isa(Act, actSightseeing) :-
%       \+ ( performedBy(Person, Act),
%            naf(~occuring(Act)),
%            isa(Y, mobTourist)
%          ).
% ~performedBy(Person, Act) :-
%       \+ ( isa(Act, actSightseeing),
%            naf(~occuring(Act)),
%            isa(Y, mobTourist)
%          ).
% isa(Y, mobTourist) :-
%       isa(Act, actSightseeing),
%       performedBy(Person, Act),
%       occuring(Act).


% ====================================================================
% All rooms have a door (Odd syntax issue)
% ====================================================================

:- test_boxlog(all(R,room(R) => exists(D, and([door(D) , has(R,D)])))).

% door(D) :-
%       room(R),
%       skolem(D, skIsDoorInUnkArg2ofHas_2Fn(R)),
%       \+ ~has(R, D).
% ~room(R) :-
%       \+ ( has(R, D),
%            door(D)
%          ).
% has(R, D) :-
%       room(R),
%       skolem(D, skIsDoorInUnkArg2ofHas_2Fn(R)),
%       \+ ~door(D).




% ====================================================================
% No one whom pays taxes in North america can be a dependant of another in the same year
% ====================================================================
:- test_boxlog(or(
  holdsIn(YEAR, isa(PERSON, nartR(tClazzCitizenFn, iGroup_UnitedStatesOfAmerica))),
  holdsIn(YEAR, isa(PERSON, nartR(mobTaxResidentsFn, iGroup_Canada))), 
  holdsIn(YEAR, isa(PERSON, nartR(mobTaxResidentsFn, iMexico))), 
  holdsIn(YEAR, isa(PERSON, nartR(mobTaxResidentsFn, iGroup_UnitedStatesOfAmerica))), 
  forbiddenToDoWrt(iCW_USIncomeTax, SUPPORTER, claimsAsDependent(YEAR, SUPPORTER, _SUPPORTEE)))).


% ~occuring(YEAR) :-
%       ~isa(PERSON, nartR(tClazzCitizenFn, iGroup_UnitedStatesOfAmerica)),
%       ~isa(PERSON, nartR(mobTaxResidentsFn, iGroup_Canada)),
%       \+ ( ( forbiddenToDoWrt(iCW_USIncomeTax,
%                               SUPPORTER,
%                               claimsAsDependent(YEAR, SUPPORTER, SUPPORTEE)),
%              isa(PERSON,
%                  nartR(mobTaxResidentsFn, iGroup_UnitedStatesOfAmerica))
%            ),
%            isa(PERSON, nartR(mobTaxResidentsFn, iMexico))
%          ).
% isa(PERSON, nartR(mobTaxResidentsFn, iGroup_UnitedStatesOfAmerica)) :-
%       occuring(YEAR),
%       ~isa(PERSON, nartR(tClazzCitizenFn, iGroup_UnitedStatesOfAmerica)),
%       ~isa(PERSON, nartR(mobTaxResidentsFn, iGroup_Canada)),
%       ~isa(PERSON, nartR(mobTaxResidentsFn, iMexico)),
%       \+ ~forbiddenToDoWrt(iCW_USIncomeTax, SUPPORTER, claimsAsDependent(YEAR, SUPPORTER, SUPPORTEE)).
% isa(PERSON, nartR(mobTaxResidentsFn, iMexico)) :-
%       occuring(YEAR),
%       ~isa(PERSON, nartR(tClazzCitizenFn, iGroup_UnitedStatesOfAmerica)),
%       ~isa(PERSON, nartR(mobTaxResidentsFn, iGroup_Canada)),
%       ~isa(PERSON, nartR(mobTaxResidentsFn, iGroup_UnitedStatesOfAmerica)),
%       \+ ~forbiddenToDoWrt(iCW_USIncomeTax, SUPPORTER, claimsAsDependent(YEAR, SUPPORTER, SUPPORTEE)).
% isa(PERSON, nartR(mobTaxResidentsFn, iGroup_Canada)) :-
%       occuring(YEAR),
%       ~isa(PERSON, nartR(tClazzCitizenFn, iGroup_UnitedStatesOfAmerica)),
%       ~isa(PERSON, nartR(mobTaxResidentsFn, iMexico)),
%       ~isa(PERSON, nartR(mobTaxResidentsFn, iGroup_UnitedStatesOfAmerica)),
%       \+ ~forbiddenToDoWrt(iCW_USIncomeTax, SUPPORTER, claimsAsDependent(YEAR, SUPPORTER, SUPPORTEE)).
% isa(PERSON, nartR(tClazzCitizenFn, iGroup_UnitedStatesOfAmerica)) :-
%       occuring(YEAR),
%       ~isa(PERSON, nartR(mobTaxResidentsFn, iGroup_Canada)),
%       ~isa(PERSON, nartR(mobTaxResidentsFn, iMexico)),
%       ~isa(PERSON, nartR(mobTaxResidentsFn, iGroup_UnitedStatesOfAmerica)),
%       \+ ~forbiddenToDoWrt(iCW_USIncomeTax, SUPPORTER, claimsAsDependent(YEAR, SUPPORTER, SUPPORTEE)).
% forbiddenToDoWrt(iCW_USIncomeTax, SUPPORTER, claimsAsDependent(YEAR, SUPPORTER, SUPPORTEE)) :-
%       occuring(YEAR),
%       ~isa(PERSON, nartR(tClazzCitizenFn, iGroup_UnitedStatesOfAmerica)),
%       ~isa(PERSON, nartR(mobTaxResidentsFn, iGroup_Canada)),
%       ~isa(PERSON, nartR(mobTaxResidentsFn, iMexico)),
%       \+ ~isa(PERSON, nartR(mobTaxResidentsFn, iGroup_UnitedStatesOfAmerica)).


% ====================================================================
% Something is human or male
% ====================================================================
:- test_boxlog(human(X) v male(X)).
% human(_19658) :-
%       ~male(_19658).
% male(_23530) :-
%       ~human(_23530).

% ====================================================================
% Something is human and male
% ====================================================================

% BAD!! these need co-mingled!
:- test_boxlog((human(X) & male(X))).

% human(_21936).
% male(_24006).




% ========
% Co-mingled!
% ========
:- P= (human(X) & male(X)) ,test_boxlog(poss(P) => P).

% human(X) :-
%       \+ ~human(X),
%       \+ ~male(X).
% male(X) :-
%       \+ ~human(X),
%       \+ ~male(X).




% ====================================================================
% Nothing is both human and male
% ====================================================================
:- test_boxlog(~ (human(X) & male(X))).

% ~human(_830) :-
%       male(_830).
% ~male(_904) :-
%       human(_904).

% ====================================================================
% There exists something not evil
% ====================================================================
:- test_boxlog(exists(X,~evil(X))).

% ~evil(_788{sk = ...}) :-
%       skolem(_788{sk = ...}, skIsIn_8Fn).

% ====================================================================
% There exists something evil
% ====================================================================
:- test_boxlog(exists(X,evil(X))).
% evil(_788{sk = ...}) :-
%       skolem(_788{sk = ...}, skIsIn_9Fn).

% ====================================================================
% When a man exists there will be a god
% ====================================================================
:- test_boxlog(exists(X,man(X)) => exists(G,god(G))).
% god(_866{sk = ...}) :-
%       man(_1082),
%       skolem(_866{sk = ...}, skIsGodIn_1Fn(_1082)).
% ~man(_2276) :-
%       \+ ( skolem(_896{sk = ...}, skIsGodIn_1Fn(_2276)),
%            god(_896{sk = ...})
%          ).

% this would be better though if 
% god(_866{sk = ...}) :-
%       \= \+ (man(_1082)),
%       skolem(_866{sk = ...}, skIsGodIn_1Fn).
% ~man(_2276) :-
%       \+ god(_896).


% ====================================================================
% When two men exists there will be a god
% ====================================================================
:- test_boxlog(atleast(2,X,man(X))=>exists(G,god(G))).

% god(_1298{sk = ...}) :-
%       skolem(_1358{sk = ...}, skIsManIn_1Fn(_10978, _1298{sk = ...})),
%       ~man(_1358{sk = ...}),
%       skolem(_1298{sk = ...}, skIsGodIn_2Fn(_10978)).
% god(_3110{sk = ...}) :-
%       man(_11144),
%       man(_11166),
%       skolem(_3110{sk = ...}, skIsGodIn_2Fn(_11166)).
% man(_2204{sk = ...}) :-
%       skolem(_2204{sk = ...}, skIsManIn_1Fn(_11314, _2224{sk = ...})),
%       skolem(_2224{sk = ...}, skIsGodIn_2Fn(_11314)),
%       \+ ~god(_2224{sk = ...}).
% ~man(_11494) :-
%       \+ ( man(_11516),
%            naf(~skolem(_4090{sk = ...}, skIsGodIn_2Fn(_11494))),
%            god(_4090{sk = ...})
%          ).
% ~man(_11656) :-
%       \+ ( man(_11678),
%            naf(~skolem(_4504{sk = ...}, skIsGodIn_2Fn(_11678))),
%            god(_4504{sk = ...})
%          ).


% OR?


% god(G) :-
%       skolem(_1316_sk, skIsManIn_1Fn(X, G)),
%       ~man(_1316_sk),
%       skolem(G, skIsGodIn_1Fn(X)).
% god(G) :-
%       man(_2720),
%       ~equals(_2742, X),
%       man(X),
%       skolem(G, skIsGodIn_1Fn(X)).
% man(_1342_sk) :-
%       skolem(_1342_sk, skIsManIn_1Fn(X, G)),
%       skolem(G, skIsGodIn_1Fn(X)),
%       \+ ~god(G).
% naf(~equals(_3108, X)) :-
%       man(_3148),
%       man(X),
%       skolem(G, skIsGodIn_1Fn(X)),
%       \+ ~god(G).
% ~man(X) :-
%       man(_3330),
%       \+ ( \+ ~ (~equals(_3352, X)),
%            naf(~skolem(G, skIsGodIn_1Fn(X))),
%            god(G)
%          ).
% ~man(_3544) :-
%       ~equals(_3566, X),
%       \+ ( man(X),
%            naf(~skolem(G, skIsGodIn_1Fn(X))),
%            god(G)
%          ).
% ~equals(_1478_sk, X) :-
%       \+ ( skolem(G, skIsGodIn_1Fn(X)),
%            god(G)
%          ).


 % ====================================================================
 % A person holding a bird is performing bird holding
 % ====================================================================

:- test_boxlog(implies(
  and(isa(HOLD, actHoldingAnObject), objectActedOn(HOLD, BIRD), isa(BIRD, tClazzBird), 
                performedBy(HOLD, PER), isa(PER, mobPerson)), 
  holdsIn(HOLD, onPhysical(BIRD, PER))), O),maplist(wdmsg,O).

% ~occuring(_2056) :-
%       isa(_2056, actHoldingAnObject),
%       objectActedOn(_2056, _2078),
%       isa(_2078, tClazzBird),
%       \+ ( performedBy(_2056, _2100),
%            naf(~isa(_2100, mobPerson)),
%            onPhysical(_2078, _2100)
%          ).
% ~isa(_2260, mobPerson) :-
%       isa(_2282, actHoldingAnObject),
%       objectActedOn(_2282, _2304),
%       isa(_2304, tClazzBird),
%       \+ ( performedBy(_2282, _2260),
%            naf(~occuring(_2282)),
%            onPhysical(_2304, _2260)
%          ).
% ~isa(_2520, tClazzBird) :-
%       isa(_2542, actHoldingAnObject),
%       objectActedOn(_2542, _2520),
%       performedBy(_2542, _2564),
%       \+ ( isa(_2564, mobPerson),
%            naf(~occuring(_2542)),
%            onPhysical(_2520, _2564)
%          ).
% ~isa(_2752, actHoldingAnObject) :-
%       objectActedOn(_2752, _2774),
%       isa(_2774, tClazzBird),
%       performedBy(_2752, _2796),
%       \+ ( isa(_2796, mobPerson),
%            naf(~occuring(_2752)),
%            onPhysical(_2774, _2796)
%          ).
% ~objectActedOn(_2984, _3006) :-
%       isa(_2984, actHoldingAnObject),
%       isa(_3006, tClazzBird),
%       performedBy(_2984, _3028),
%       \+ ( isa(_3028, mobPerson),
%            naf(~occuring(_2984)),
%            onPhysical(_3006, _3028)
%          ).
% ~performedBy(_3190, _3212) :-
%       isa(_3190, actHoldingAnObject),
%       objectActedOn(_3190, _3234),
%       isa(_3234, tClazzBird),
%       \+ ( isa(_3212, mobPerson),
%            naf(~occuring(_3190)),
%            onPhysical(_3234, _3212)
%          ).
% onPhysical(_3396, _3418) :-
%       isa(_3440, actHoldingAnObject),
%       objectActedOn(_3440, _3396),
%       isa(_3396, tClazzBird),
%       performedBy(_3440, _3418),
%       isa(_3418, mobPerson),
%       occuring(_3440).




:- test_boxlog(sourceSchemaObjectID(SOURCE, SCHEMA, uU(uSourceSchemaObjectFn, SOURCE, SCHEMA, ID), ID)).
% ~mudEquals(_1236{???UUUSOURCESCHEMAOBJECTFN1}, uU(uSourceSchemaObjectFn, _2438, _2460, _2482)) :-
%       ~sourceSchemaObjectID(_2438, _2460, _1280{???UUUSOURCESCHEMAOBJECTFN1}, _2482).
% sourceSchemaObjectID(_2614, _2636, UUUSOURCESCHEMAOBJECTFN1_VAR, _2658) :-
%       mudEquals(_1006{???UUUSOURCESCHEMAOBJECTFN1},
%                 uU(uSourceSchemaObjectFn, _2614, _2636, _2658)).


:- test_boxlog(sourceSchemaObjectID(SOURCE, SCHEMA, THING, uU(uSourceSchemaObjectIDFn, SOURCE, SCHEMA, THING))).
% ~mudEquals(_886{???UUUSOURCESCHEMAOBJECTIDFN1}, uU(uSourceSchemaObjectIDFn, _1072, _1094, _1116)) :-
%       ~sourceSchemaObjectID(_1072, _1094, _1116, _906{???UUUSOURCESCHEMAOBJECTIDFN1}).
% sourceSchemaObjectID(_1248, _1270, _1292, UUUSOURCESCHEMAOBJECTIDFN1_VAR) :-
%       mudEquals(_868{???UUUSOURCESCHEMAOBJECTIDFN1},
%                 uU(uSourceSchemaObjectIDFn, _1248, _1270, _1292)).



:- test_defunctionalize(implies(isa(YEAR, tClazzCalendarYear), temporallyFinishedBy(YEAR, uU(iTimeOf_SecondFn, 59, uU(iTimeOf_MinuteFn, 59, uU(iTimeOf_HourFn, 23, uU(iTimeOf_DayFn, 31, uU(iTimeOf_MonthFn, vDecember, YEAR)))))))).

% =>(mudEquals(UUITIMEOF_SECONDFN1_VAR, uU(iTimeOf_SecondFn, 59, UUITIMEOF_MINUTEFN1_VAR)), =>(mudEquals(UUITIMEOF_MINUTEFN1_VAR, uU(iTimeOf_MinuteFn, 59, UUITIMEOF_HOURFN1_VAR)), =>(mudEquals(UUITIMEOF_HOURFN1_VAR, uU(iTimeOf_HourFn, 23, UUITIMEOF_DAYFN1_VAR)), =>(mudEquals(UUITIMEOF_DAYFN1_VAR, uU(iTimeOf_DayFn, 31, UUITIMEOF_MONTHFN1_VAR)), =>(mudEquals(UUITIMEOF_MONTHFN1_VAR, uU(iTimeOf_MonthFn, vDecember, _200)), implies(isa(_200, tClazzCalendarYear), temporallyFinishedBy(_200, UUITIMEOF_SECONDFN1_VAR))))))).
