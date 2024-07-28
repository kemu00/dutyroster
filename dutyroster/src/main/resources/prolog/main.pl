:- consult('staff.pl').

:- use_module(calcDate).

all_members([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).

% Cleaningは毎日
target_day(X) :- calendar(_, X, _).

% 全日付
all_target_days(Days) :- findall(Day, target_day(Day), Days).




% 過去日付
get_previous_duty_assignment(Staff, X) :- 
    previous_duty_assignment(Staff, X, 'Cleaning').

% 過去全日付
all_previous_days(Staff, Days) :- findall(Day, get_previous_duty_assignment(Staff, Day), Days).

% メンバーと当番の日付の条件をチェック
valid_assignment(Staff, Day, Duty) :-
    all_previous_days(Staff, PrevDays),
    write('preDayu: '), write(PrevDays), nl,
    date_max_list(PrevDays, PrevDay),
    date_difference(PrevDay, Day, Diff),
    write('PrevDay: '), write(PrevDay), nl,
    write('Day: '), write(Day), nl,
    write('diff: '), write(Diff), nl,
    Diff > 20.

% 各メンバーに当番を割り当てる
assign_duty_to_members([], _, _, Schedule).
assign_duty_to_members([Day|Days], Members, Duty, NewMembers) :-
    select(Member, Members, NewMembers),
    valid_assignment(Member, Day, Duty),
    append(NewMembers, [Member], NewMembers),
    write('set: '), write(NewMembers), nl,
    assign_duty_to_members(Days, NewMembers, Duty, Schedule).

% 当番の割り当て
assign_duties :-
    all_members(Members),
    all_target_days(TargetDays),
    write('member: '), write(Members), nl,
    write('calendar: '), write(TargetDays), nl,
    assign_duty_to_members(TargetDays, Members, 'Cleaning', AssignedMembers),
    write('kekka: '), write(AssignedMembers).