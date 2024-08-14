:- encoding(utf8).
:- use_module(calcDate).
:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).


% 当月のカレンダーのリストを取得
target_schedule_list(TargetList) :-
    findall((Name,Date, DutyFloor), target_schedule_list(Name, Date, DutyFloor), TargetList).

% 職員のリストを取得
staff_list(StaffList) :-
    findall(Name, staff(_, Name, _), StaffList).

% 過去の当番履歴を取得
past_schedule_list(PastList) :-
    findall((Name, Date, DutyFloor), past_Schedule(Name, Date, DutyFloor), PastList).

% JSONからデータを取り込む
assign_schedule(Dict) :-
    TargetList = Dict.targetScheduleList,
    StaffList = Dict.staffList,
    PastList = Dict.pastScheduleList,
    StaffDutyList = Dict.staffDutyList,
    DutyFloorList = Dict.dutyFloorList,
    convert_to_tuples_target_schedule(TargetList),
    convert_to_tuples_schedule(PastList, TuplePastList),
    convert_to_tuples_staff(StaffList, TupleStaffList),
    convert_to_tuples_staff_duty(StaffDutyList),
    convert_to_tuples_duty_floor(DutyFloorList),
    % write('TargetList: '), write(TargetList), nl,
    % write('StaffList: '), write(StaffList), nl,
    % write('PastList: '), write(PastList), nl,
    % write('StaffDutyList: '), write(TupleStaffDutyList), nl,
    % write('DutyFloorList: '), write(TupleDutyFloorList), nl,
    target_schedule_list(TargetListTmp),
    % write('TargetList: '), write(TargetListTmp), nl,
    assign(TargetListTmp, TupleStaffList, TuplePastList).

% targetScheduleList をタプルのリストに変換する
convert_to_tuples_target_schedule([]).
convert_to_tuples_target_schedule([Dict | Rest]) :-
    CalendarYmd = Dict.calendarYmd,
    DutyFloorCd = Dict.dutyFloorCd,
    StaffCd = Dict.staffCd,
    assert(target_schedule_list(StaffCd, CalendarYmd, DutyFloorCd)),
    convert_to_tuples_target_schedule(Rest).

% pastScheduleList をタプルのリストに変換する
convert_to_tuples_schedule([], []).
convert_to_tuples_schedule([Dict | Rest], [(StaffCd, CalendarYmd, DutyFloorCd) | RestTuples]) :-
    CalendarYmd = Dict.calendarYmd,
    DutyFloorCd = Dict.dutyFloorCd,
    StaffCd = Dict.staffCd,
    convert_to_tuples_schedule(Rest, RestTuples).

% staffList をタプルのリストに変換する
convert_to_tuples_staff([], []).
convert_to_tuples_staff([Dict | Rest], [(StaffCd) | RestTuples]) :-
    StaffCd = Dict.staffCd,
    convert_to_tuples_staff(Rest, RestTuples).

% staffDutyList をタプルのリストに変換する
convert_to_tuples_staff_duty([]).
convert_to_tuples_staff_duty([Dict | Rest]) :-
    Dict.targetFlg = 1,
    StaffCd = Dict.staffCd,
    DutyCd = Dict.dutyCd,
    assert(staff_duty(StaffCd, DutyCd)),
    convert_to_tuples_staff_duty(Rest)
    ;
    convert_to_tuples_staff_duty(Rest).

% staffDutyList をタプルのリストに変換する
convert_to_tuples_duty_floor([]).
convert_to_tuples_duty_floor([Dict | Rest]) :-
    DutyFloorCd = Dict.dutyFloorCd,
    DutyCd = Dict.dutyCd,
    assert(duty_floor(DutyFloorCd, DutyCd)),
    convert_to_tuples_duty_floor(Rest).

% 割り振り処理
% TargetList(Name, Date, DutyFloor): 割り当て対象のスケジュールのリスト。
% StaffList(Name): 割り当て対象の職員のリスト。
% PastList(Name, Date, DutyFloor): 過去の割り当てスケジュールのリスト。
assign([], _, _).
assign([(StaffCd, CalendarYmd, DutyFloorCd)|Rest], StaffList, PastList) :-
    write('到達t: '), nl,
    find_eligible_staff(StaffList, PastList, DutyFloorCd, EligibleStaff),
    % select(EligibleStaff, StaffList, NewStaffList),
    update_schedule(EligibleStaff, CalendarYmd, DutyFloorCd),
    assign(Rest, StaffList, PastList), !.

% 当番のスケジュールを更新
update_schedule(StaffCd, CalendarYmd, DutyFloorCd) :-
    retract(target_schedule_list(_, CalendarYmd, DutyFloorCd)),
    write('test2：'),
    assert(target_schedule_list(StaffCd, CalendarYmd, DutyFloorCd)),
    write('更新：'), write(StaffCd), write(CalendarYmd), write(DutyFloorCd), nl, !.

% 適格な職員を選定（先月に割り振りがない職員を優先、割り振りがある場合は最も遠い人を選ぶ）
% StaffList(Name): 割り当て対象の職員のリスト。
% PastList(Name, Date, DutyFloor): 過去の割り当てスケジュールのリスト。
% DutyFloor: 当番フロア名。
% EligibleStaff(Name): 的確な職員。
find_eligible_staff(StaffList, PastList, DutyFloor, EligibleStaff) :-
    % 当番を担当可能な職員のみの職員リストを作成
    write('職員リスト：'), write(StaffList), nl,
    exclude(available_duty(DutyFloor), StaffList, AvailableStaffList),
    write('登録可能な職員リスト：'), write(AvailableStaffList), nl,
    % 今月に同じ当番の割り振りがある職員を候補から削除
    target_schedule_list(TargetList),
    exclude(recently_assigned(DutyFloor, TargetList), AvailableStaffList, NoDutyStaffList), !,
    write('登録可能な職員リスト：'), write(NoDutyStaffList), nl,
    % 先月の割り振りがない職員を優先
    exclude(recently_assigned(DutyFloor, PastList), NoDutyStaffList, NewNoDutyStaffList),
    write('先月割り振りがない職員リスト：'), write(NewNoDutyStaffList), nl,
    (NewNoDutyStaffList \= [] ->
        member(EligibleStaff, NewNoDutyStaffList)
    ;
        % 先月に割り振りがある職員の中で最も遠い人を選ぶ
        findall(Name-Days, (member(Name, NoDutyStaffList), duty_days_since_last(Name, PastList, Days)), StaffDays),
        sort(2, @>=, StaffDays, SortedStaffDays),
        pairs_keys(SortedStaffDays, EligibleStaffList),
        member(EligibleStaff, EligibleStaffList)
    ),
    write(EligibleStaff),nl.

% 職員がその当番を担当可能かチェック(必須)
available_duty(DutyFloor, Staff) :-
    duty_floor(DutyFloor, Duty),
    \+ staff_duty(Staff, Duty).

% 対象期間内に割り振りがあるかチェック(優先度:高)
has_recent(ScheduleList, Name) :-
    member((Name, _, _), ScheduleList).

% 対象期間内に同じ当番の割り振りがあるかチェック(優先度:高)
has_recent_dutyFloor(ScheduleList, DutyFloor, Name) :-
    duty_floor(DutyFloor, Duty),
    member((Name, _, ScheduleDutyFloor), ScheduleList),
    duty_floor(ScheduleDutyFloor, Duty).

% 最近の当番履歴を持つかチェック(優先度:中)
recently_assigned(DutyFloor, PastList, StaffCd) :-
    member((StaffCd, _, DutyFloor), PastList).

% 最も遠い日付の職員を見つける(優先度:低)
duty_days_since_last(StaffCd, PastList, Days) :-
    % 過去の割り振り日を見つける
    findall(CalendarYmd, member((StaffCd, CalendarYmd, _), PastList), Dates),
    % 現在の日付からの経過日数を計算
    max_member(LastDate, Dates),
    date_difference('2024-09-01', LastDate, Days).

% JSONファイルを読み込み、辞書として返す
load_json(FilePath, Dict) :-
    open(FilePath, read, Stream, [encoding(utf8)]),
    json_read_dict(Stream, Dict),
    close(Stream).

% Prologの事実をJSON用の構造に変換
facts_to_json(Facts, JSON) :-
    findall(_{staffCd: StaffCd, calendarYmd: CalendarYmd, dutyFloorCd:DutyFloorCd}, target_schedule_list(StaffCd, CalendarYmd, DutyFloorCd), FactsList),
    JSON = json(FactsList).

write_json(File) :-
    findall(
        json{ calendarYmd: CalendarYmd, dutyFloorCd: DutyFloorCd, staffCd: StaffCd },
        target_schedule_list(StaffCd, CalendarYmd, DutyFloorCd),
        List
    ),
    json_write_file(File, json{ targetScheduleList: List }).

% JSONデータをファイルに書き出す
json_write_file(FileName, JSON) :-
    open(FileName, write, Stream),
    json_write(Stream, JSON),
    close(Stream).

% 実行例
start(Path) :-  
    load_json(Path, Dict),
    % writeln(Dict),
    assign_schedule(Dict),
    findall((Name, Date, DutyFloor), target_schedule_list(Name, Date, DutyFloor), Result),
    write_json('./outputSample.json'),
    write(Result), nl.