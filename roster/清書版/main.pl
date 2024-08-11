:- encoding(utf8).
:- consult('prologData.pl').
:- use_module(assign).

% データを初期化
init :-
    retractall(target_Schedule(_, _, _)),
    assert(target_Schedule('', '2024-09-02', 'clean_floor1')),
    assert(target_Schedule('', '2024-09-04', 'clean_floor1')),
    assert(target_Schedule('', '2024-09-06', 'clean_floor1')),
    assert(target_Schedule('', '2024-09-02', 'clean_floor2')),
    assert(target_Schedule('', '2024-09-04', 'clean_floor2')),
    assert(target_Schedule('', '2024-09-06', 'clean_floor2')).

% 当月のカレンダーのリストを取得
target_schedule_list(TargetList) :-
    findall((Name,Date, DutyFloor), target_Schedule(Name, Date, DutyFloor), TargetList).

% 職員のリストを取得
staff_list(StaffList) :-
    findall(Name, staff(_, Name, _), StaffList).

% 過去の当番履歴を取得
past_schedule_list(PastList) :-
    findall((Name, Date, DutyFloor), past_Schedule(Name, Date, DutyFloor), PastList).

% 割り振りルール
assign_schedule :-
    target_schedule_list(TargetList),
    staff_list(StaffList),
    past_schedule_list(PastList),
    write('TargetList: '), write(TargetList), nl,
    write('StaffList: '), write(StaffList), nl,
    write('PastList: '), write(PastList), nl,
    assign(TargetList, StaffList, PastList).

% 実行例
:-  init,
    assign_schedule,
    findall((Name, Date, DutyFloor), target_Schedule(Name, Date, DutyFloor), Result),
    write(Result), nl.
