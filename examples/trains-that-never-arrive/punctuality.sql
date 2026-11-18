-- Long-distance trains (ICE, IC, EC, ECE), every stop with a planned arrival, October 2026.
-- A stop is on time under 6 minutes late (DB: "Anteil pünktlicher Halte an allen Unterwegs- und Endhalten").
-- One run = one ride id on one service day (the ride id repeats every day).
create view s as
select * from (
  select train_line_ride_id || '@' || cast(cast(coalesce(arrival_planned_time, departure_planned_time) - interval 4 hour as date) as varchar) ride,
         train_line_station_num pos, arrival_is_canceled ac, arrival_planned_time,
         date_diff('second', arrival_planned_time, coalesce(arrival_change_time, arrival_planned_time)) / 60.0 adelay,
         -- planned minutes since the run left its first station (for the relative delay)
         date_diff('second', min(coalesce(departure_planned_time, arrival_planned_time)) over (partition by train_line_ride_id || '@' ||
           cast(cast(coalesce(arrival_planned_time, departure_planned_time) - interval 4 hour as date) as varchar)), arrival_planned_time) / 60.0 elapsed
  from read_parquet(getvariable('data'))
  where train_type in ('ICE', 'IC', 'EC', 'ECE')
    and coalesce(is_additional_stop, false) = false and coalesce(is_replacement_train, false) = false)
where arrival_planned_time is not null;
create view r as
select ride, max(pos) lastpos, max(case when not ac then pos end) lastserved, bool_and(ac) allc from s group by ride;
create view cut as select * from r where not allc and lastserved < lastpos;
create view imp as
select s.*, case when cut.ride is not null and s.pos > cut.lastserved then ls.adelay end carried,
       case when cut.ride is not null and s.pos > cut.lastserved and ls.elapsed > 0 then ls.adelay / ls.elapsed * s.elapsed end relative
from s left join cut on cut.ride = s.ride left join s ls on ls.ride = cut.ride and ls.pos = cut.lastserved;
select 'stops' metric, count(*)::double value from s
union all select 'cancelled share', avg(ac::int) from s
union all select 'on time, cancelled left out', avg(case when not ac then (adelay < 6)::int end) from s
union all select 'on time, cancelled counted late', avg(case when ac then 0 else (adelay < 6)::int end) from s
union all select 'runs', count(*) from r
union all select 'runs cut short', count(*) from cut
union all select 'runs fully cancelled', count(*) from r where allc
union all select 'cut short: median delay at last stop served', median(s.adelay) from cut join s on s.ride = cut.ride and s.pos = cut.lastserved
union all select 'cut short: share 30+ min at last stop served', avg((s.adelay >= 30)::int) from cut join s on s.ride = cut.ride and s.pos = cut.lastserved
union all select 'reached the end: median delay at final stop', median(s.adelay) from r join s on s.ride = r.ride and s.pos = r.lastpos where not r.allc and r.lastserved = r.lastpos
union all select 'reached the end: share 30+ min at final stop', avg((s.adelay >= 30)::int) from r join s on s.ride = r.ride and s.pos = r.lastpos where not r.allc and r.lastserved = r.lastpos
union all select 'on time, cut runs carried on with their delay',
  avg(case when not s.ac then (s.adelay < 6)::int when cut.ride is not null and s.pos > cut.lastserved then (ls.adelay < 6)::int end)
  from s left join cut on cut.ride = s.ride left join s ls on ls.ride = cut.ride and ls.pos = cut.lastserved
-- delay at every stop with a planned arrival, three ways to fill the stops a cut-short run never reached
-- (fully cancelled runs and other cancelled stops stay out in all three):
--   left out | the delay it had at its last stop served | the same RELATIVE delay (delay / planned minutes since departure)
union all select 'mean delay, left out', avg(case when not s.ac then s.adelay end) from imp s
union all select 'median delay, left out', median(case when not s.ac then s.adelay end) from imp s
union all select 'mean delay, last delay carried on', avg(coalesce(case when not s.ac then s.adelay end, s.carried)) from imp s
union all select 'median delay, last delay carried on', median(coalesce(case when not s.ac then s.adelay end, s.carried)) from imp s
union all select 'mean delay, relative delay carried on', avg(coalesce(case when not s.ac then s.adelay end, s.relative)) from imp s
union all select 'median delay, relative delay carried on', median(coalesce(case when not s.ac then s.adelay end, s.relative)) from imp s
union all select 'on time, relative delay carried on', avg(case when not s.ac then (s.adelay < 6)::int when s.relative is not null then (s.relative < 6)::int end) from imp s;
