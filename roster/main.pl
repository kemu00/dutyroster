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
    all_previous_days(Staff, PrevDays),
    write('chstaff: '),write(Staff),
    write('chdaay: '),write(Day),
    (
        date_max_list(PrevDays, PrevDay),
        date_difference(PrevDay, Day, Diff),
        Diff > 25
        ;
        is_empty_list(PrevDays)
    ),
    write('de4: '),write(Diff)
    .


% 条件を満たす全ての組み合わせをリストにする
hiduke_tansaku([], _, []).
% 条件が満たされた場合
hiduke_tansaku([Day|Days], Members, [(Day, Member)|Combinations]) :-
    staff_tansaku(Day, Members, Member),
    write('de5: '), 
    select(Member, Members, NewMembers),
    write('de6: '), 
    hiduke_tansaku(Days, NewMembers, Combinations).
    
% 条件を満たすまで別の職員を探索する
staff_tansaku(_, [], assignedMember).
staff_tansaku(Day, [Member|_], Membera) :-
    valid_assignment(Member, Day, 'cleaning'),
    write('set: '), write(Member), nl,
    !.
staff_tansaku(Day, [_|Members], assignedMember) :-
    \+ valid_assignment(Member, Day, 'cleaning'),
    write('de3: '), 
    staff_tansaku(Day, Members, assignedMember).



% 当番の割り当て
assign_duties :-
    all_members(Members),
    all_target_days(TargetDays),
    write('member: '), write(Members), nl,
    write('calendar: '), write(TargetDays), nl,
    hiduke_tansaku(TargetDays, Members, Combinations),
    write('kekka: '), write(Combinations).