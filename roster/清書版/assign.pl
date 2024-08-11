:- module(assign, [ assign/3 ]). % +TargetList, +StaffList, +PastList

:- encoding(utf8).
:- consult('prologData.pl').
:- use_module(findStaff).


% 割り振り処理
% TargetList(Name, Date, DutyFloor): 割り当て対象のスケジュールのリスト。
% StaffList(Name): 割り当て対象の職員のリスト。
% PastList(Name, Date, DutyFloor): 過去の割り当てスケジュールのリスト。
assign([], _, _).
assign([(Name, Date, DutyFloor)|Rest], StaffList, PastList) :-
    find_eligible_staff(StaffList, PastList, DutyFloor, EligibleStaff),
    update_schedule(EligibleStaff, Date, DutyFloor),
    assign(Rest, StaffList, PastList).

% 当番のスケジュールを更新
update_schedule(Name, Date, DutyFloor) :-
    retract(target_Schedule(_, Date, DutyFloor)),
    assert(target_Schedule(Name, Date, DutyFloor)),
    write('更新：'), write(Name), write(Date), write(DutyFloor), nl.
