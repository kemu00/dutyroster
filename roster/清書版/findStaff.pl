:- module(findStaff, [
    find_eligible_staff/4   % +StaffList, +PastList, +DutyFloor, -EligibleStaff
]).

:- encoding(utf8).
:- consult('prologData.pl').
:- use_module(calcDate).

% 適格な職員を選定（先月に割り振りがない職員を優先、割り振りがある場合は最も遠い人を選ぶ）
% StaffList(Name): 割り当て対象の職員のリスト。
% PastList(Name, Date, DutyFloor): 過去の割り当てスケジュールのリスト。
% DutyFloor: 当番フロア名。
% EligibleStaff(Name): 的確な職員。
find_eligible_staff(StaffList, PastList, DutyFloor, EligibleStaff) :-
    % 当番を担当可能な職員のみの職員リストを作成
    include(available_duty(DutyFloor), StaffList, AvailableStaffList),

    % 今月に割り振りがある職員を候補から削除
    target_schedule_list(TargetList),
    exclude(has_recent(TargetList), AvailableStaffList, NoDutyStaffList),
    write('登録可能な職員リスト：'), write(AvailableStaffList), nl,
    % 先月の割り振りがない職員を優先
    exclude(has_recent(PastList), NoDutyStaffList, NewNoDutyStaffList),
    write('今月先月割り振りがない職員リスト：'), write(NewNoDutyStaffList), nl,
    (NewNoDutyStaffList \= [] ->
        member(EligibleStaff, NewNoDutyStaffList)
    ;
        % 先月に割り振りがある職員の中で最も遠い人を選ぶ
        findall(Name-Days, (member(Name, NoDutyStaffList), duty_days_since_last(Name, PastList, Days)), StaffDays),
        sort(2, @>=, StaffDays, SortedStaffDays),
        pairs_keys(SortedStaffDays, EligibleStaffList),
        member(EligibleStaff, EligibleStaffList)
    ).

% 職員がその当番を担当可能かチェック(必須)
available_duty(DutyFloor, Staff) :-
    duty_floor(DutyFloor, Duty),
    staff_duty(Staff, Duty).

% 対象期間内に割り振りがあるかチェック(優先度:高)
has_recent(ScheduleList, Name) :-
    member((Name, _, _), ScheduleList).

% 対象期間内に同じ当番の割り振りがあるかチェック(優先度:高)
has_recent_dutyFloor(ScheduleList, Name, DutyFloor) :-
    duty_floor(DutyFloor, Duty),
    member((Name, _, ScheduleDutyFloor), ScheduleList),
    duty_floor(ScheduleDutyFloor, Duty).

% 最近の当番履歴を持つかチェック(優先度:中)
recently_assigned(DutyFloor, PastList, Name) :-
    member((Name, _, DutyFloor), PastList).

% 最も遠い日付の職員を見つける(優先度:低)
duty_days_since_last(Name, PastList, Days) :-
    % 過去の割り振り日を見つける
    findall(Date, member((Name, Date, _), PastList), Dates),
    % 現在の日付からの経過日数を計算
    max_member(LastDate, Dates),
    date_difference('2024-09-01', LastDate, Days).
