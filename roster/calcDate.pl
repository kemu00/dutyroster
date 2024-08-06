:- module(calcDate,
          [ date_difference/3,          % +Date1, +Date2, ?Diff
            date_max_list/2                  % +DateList, -MaxDate
          ]).
:- use_module(library(date)).

% 日付の差を計算する
date_difference(Date1, Date2, Difference) :-
    parse_time(Date1, iso_8601, Timestamp1),
    parse_time(Date2, iso_8601, Timestamp2),
    DifferenceInSeconds is abs(Timestamp1 - Timestamp2),
    Difference is round(DifferenceInSeconds / 86400). % 86400秒 = 1日

% 最大の日付を返す
date_max(Date1, Date2, MaxDate) :-
    parse_time(Date1, iso_8601, Timestamp1),
    parse_time(Date2, iso_8601, Timestamp2),
    MaxTimestamp is max(Timestamp1, Timestamp2),
    stamp_date_time(MaxTimestamp, DateTime, 'UTC'),
    date_time_value(year, DateTime, Year),
    date_time_value(month, DateTime, Month),
    date_time_value(day, DateTime, Day),
    format(atom(MaxDate), '~d-~|~`0t~d~2+-~|~`0t~d~2+', [Year, Month, Day]).

% 数値のリストから最大値を見つけるメソッド
date_max_list([H|T], Max) :-
    date_max_list(T, H, Max).

% ヘルパーメソッド: リストが空になったときの最大値
date_max_list([], Max, Max).

% ヘルパーメソッド: リストを順に処理し、最大値を更新
date_max_list([H|T], Acc, Max) :-
    date_max(H, Acc, NewAcc),
    date_max_list(T, NewAcc, Max).