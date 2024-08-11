:-encoding(utf8).

% カレンダー calendarList
calendar(1, '2024-07-01', 'Monday').
calendar(2, '2024-07-02', 'Tuesday').
calendar(3, '2024-07-03', 'Wednesday').
calendar(4, '2024-07-04', 'Thursday').
calendar(5, '2024-07-05', 'Friday').
calendar(6, '2024-07-06', 'Saturday').
calendar(7, '2024-07-07', 'Sunday').
calendar(8, '2024-07-08', 'Monday').
calendar(9, '2024-07-09', 'Tuesday').
calendar(10, '2024-07-10', 'Wednesday').
calendar(11, '2024-07-11', 'Thursday').
calendar(12, '2024-07-12', 'Friday').
calendar(13, '2024-07-13', 'Saturday').
calendar(14, '2024-07-14', 'Sunday').
calendar(15, '2024-07-15', 'Monday').
calendar(16, '2024-07-16', 'Tuesday').
calendar(17, '2024-07-17', 'Wednesday').
calendar(18, '2024-07-18', 'Thursday').
calendar(19, '2024-07-19', 'Friday').
calendar(20, '2024-07-20', 'Saturday').
calendar(21, '2024-07-21', 'Sunday').
calendar(22, '2024-07-22', 'Monday').
calendar(23, '2024-07-23', 'Tuesday').
calendar(24, '2024-07-24', 'Wednesday').
calendar(25, '2024-07-25', 'Thursday').
calendar(26, '2024-07-26', 'Friday').
calendar(27, '2024-07-27', 'Saturday').
calendar(28, '2024-07-28', 'Sunday').
calendar(29, '2024-07-29', 'Monday').
calendar(30, '2024-07-30', 'Tuesday').
calendar(31, '2024-07-31', 'Wednesday').

calendar(1, '2024-08-01', 'Thursday').
calendar(2, '2024-08-02', 'Friday').
calendar(3, '2024-08-03', 'Saturday').
calendar(4, '2024-08-04', 'Sunday').
calendar(5, '2024-08-05', 'Monday').
calendar(6, '2024-08-06', 'Tuesday').
calendar(7, '2024-08-07', 'Wednesday').
calendar(8, '2024-08-08', 'Thursday').
calendar(9, '2024-08-09', 'Friday').
calendar(10, '2024-08-10', 'Saturday').
calendar(11, '2024-08-11', 'Sunday').
calendar(12, '2024-08-12', 'Monday').
calendar(13, '2024-08-13', 'Tuesday').
calendar(14, '2024-08-14', 'Wednesday').
calendar(15, '2024-08-15', 'Thursday').
calendar(16, '2024-08-16', 'Friday').
calendar(17, '2024-08-17', 'Saturday').
calendar(18, '2024-08-18', 'Sunday').
calendar(19, '2024-08-19', 'Monday').
calendar(20, '2024-08-20', 'Tuesday').
calendar(21, '2024-08-21', 'Wednesday').
calendar(22, '2024-08-22', 'Thursday').
calendar(23, '2024-08-23', 'Friday').
calendar(24, '2024-08-24', 'Saturday').
calendar(25, '2024-08-25', 'Sunday').
calendar(26, '2024-08-26', 'Monday').
calendar(27, '2024-08-27', 'Tuesday').
calendar(28, '2024-08-28', 'Wednesday').
calendar(29, '2024-08-29', 'Thursday').
calendar(30, '2024-08-30', 'Friday').
calendar(31, '2024-08-31', 'Saturday').

calendar(1, '2024-09-01', 'Sunday').
calendar(2, '2024-09-02', 'Monday').
calendar(3, '2024-09-03', 'Tuesday').
calendar(4, '2024-09-04', 'Wednesday').
calendar(5, '2024-09-05', 'Thursday').
calendar(6, '2024-09-06', 'Friday').
calendar(7, '2024-09-07', 'Saturday').
calendar(8, '2024-09-08', 'Sunday').
calendar(9, '2024-09-09', 'Monday').
calendar(10, '2024-09-10', 'Tuesday').
calendar(11, '2024-09-11', 'Wednesday').
calendar(12, '2024-09-12', 'Thursday').
calendar(13, '2024-09-13', 'Friday').
calendar(14, '2024-09-14', 'Saturday').
calendar(15, '2024-09-15', 'Sunday').
calendar(16, '2024-09-16', 'Monday').
calendar(17, '2024-09-17', 'Tuesday').
calendar(18, '2024-09-18', 'Wednesday').
calendar(19, '2024-09-19', 'Thursday').
calendar(20, '2024-09-20', 'Friday').
calendar(21, '2024-09-21', 'Saturday').
calendar(22, '2024-09-22', 'Sunday').
calendar(23, '2024-09-23', 'Monday').
calendar(24, '2024-09-24', 'Tuesday').
calendar(25, '2024-09-25', 'Wednesday').
calendar(26, '2024-09-26', 'Thursday').
calendar(27, '2024-09-27', 'Friday').
calendar(28, '2024-09-28', 'Saturday').
calendar(29, '2024-09-29', 'Sunday').
calendar(30, '2024-09-30', 'Monday').

% 当番フロア dutyFloorList
duty_floor('clean_floor1', 'clean').
duty_floor('clean_floor2', 'clean').

% 職員 staffList
staff(1, 'Alice', 'treaner').
staff(2, 'Bob', 'expert').
staff(3, 'Charlie', 'treaner').
staff(4, 'David', 'treaner').
staff(5, 'Eve', 'expert').
staff(6, 'Frank', 'treaner').
staff(7, 'Grace', 'treaner').
staff(8, 'Hannah', 'treaner').
staff(9, 'Ivan', 'treaner').
staff(10, 'Judy', 'treaner').

% 職員当番 staffDutyList
staff_duty('Alice', 'clean').
staff_duty('Charlie', 'clean').
staff_duty('David', 'clean').
staff_duty('Eve', 'clean').
staff_duty('Grace', 'clean').
staff_duty('Ivan', 'clean').
staff_duty('Judy', 'clean').


% 先月分の当番割り振り(職員CD,日付,当番フロア) pastScheduleList
past_Schedule('Alice', '2024-08-12', 'clean_floor1').
past_Schedule('Charlie', '2024-08-14', 'clean_floor1').
past_Schedule('David', '2024-08-16', 'clean_floor1').
past_Schedule('Grace', '2024-08-16', 'clean_floor2').
past_Schedule('Hannah', '2024-08-16', 'clean_floor2').
past_Schedule('Ivan', '2024-08-16', 'clean_floor2').

% 当月の当番割り振り(職員CD,日付,当番フロア) targetScheduleList
% ここに当番フロア曜日の内容を反映するためそれらのデータは不要
taget_Schedule('', '2024-09-02', 'clean_floor1').
taget_Schedule('', '2024-09-04', 'clean_floor1').
taget_Schedule('', '2024-09-06', 'clean_floor1').
taget_Schedule('', '2024-09-02', 'clean_floor2').
taget_Schedule('', '2024-09-04', 'clean_floor2').
taget_Schedule('', '2024-09-06', 'clean_floor2').