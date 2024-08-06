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

% リストが空であるかどうかを判定する述語
is_empty_list([]).

% メンバーと当番の日付の条件をチェック
valid_assignment(Staff, Day, Duty) :-
    all_previous_days(Staff, PrevDays),(

%    write('preDayu: '), write(PrevDays), nl,
    date_max_list(PrevDays, PrevDay),
    date_difference(PrevDay, Day, Diff),
%    write('PrevDay: '), write(PrevDay), nl,
%    write('Day: '), write(Day), nl,
%    write('diff: '), write(Diff), nl,
    Diff > 25 ; is_empty_list(PrevDays)).
%    \+ member(Staff, AssignedMembers).

% 各メンバーに当番を割り当てる
assign_duty_to_members([], _, _, Schedule).
assign_duty_to_members([Day|Days], Members, Duty, NewMembers) :-
    
    valid_assignment(Member, Day, Duty),
    select(Member, Members, NewMembers),
    % append(NewMembers, [Member], NewMembers),
    write('set: '), write(NewMembers), nl,
    assign_duty_to_members(Days, Members, Duty, NewMembers).

% 条件を満たす全ての組み合わせをリストにする
hiduke_tansaku([], _, _).
% 条件が満たされた場合
hiduke_tansaku([Day|Days], Members, [(Day, Member)|Combinations]) :-
    staff_tansaku(Day, Members),
    hiduke_tansaku(Days, Members, Combinations).
% 条件が満たされなかった場合
% eligible_combinations([Day|Days], [Member|Members], AssignedMembers, Combinations) :-
%    \+ valid_assignment(Member, Day, 'cleaning', AssignedMembers),
%    eligible_combinations(Days, Members, AssignedMembers, Combinations).
    
% 条件を満たすまで別の職員を探索する
staff_tansaku(_, []).
staff_tansaku(Day, [Member|Members]) :-
    valid_assignment(Member, Day, 'cleaning'),
    write('set: '), write(Member), nl.

staff_tansaku(Day, [Member|Members]) :-
    \+ valid_assignment(Member, Day, 'cleaning'),
    write('inmember: '), write(Members), nl,
    staff_tansaku(Day, Members).



% 当番の割り当て
assign_duties :-
    all_members(Members),
    all_target_days(TargetDays),
    write('member: '), write(Members), nl,
    write('calendar: '), write(TargetDays), nl,
    % assign_duty_to_members(TargetDays, Members, 'Cleaning', AssignedMembers),
    % findall(Combination, hiduke_tansaku(TargetDays, Members, Combination), Combinations),
    hiduke_tansaku(TargetDays, Members, Combinations),
    write('kekka: '), write(Combinations).