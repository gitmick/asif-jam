"""01-db-rules.py <data-2026-10.parquet>  ->  stops.parquet, db-rules.csv

Deutsche Bahn's rule: punctuality is the share of stops, along the way and at the end, reached less than
six minutes late. A cancelled stop has no arrival, so it has no delay: it is left out.
Long-distance trains (ICE, IC, EC, ECE), every stop with a planned arrival, October 2026.
One run = one ride id on one service day (the ride id repeats every day).
stops.parquet keeps every stop with what the next steps need; db-rules.csv holds the numbers by the rule.
"""
import csv, sys, duckdb
c = duckdb.connect()
c.execute("set threads = 1")   # one thread: the same bytes on every run
c.execute("set variable data = ?", [sys.argv[1]])
c.execute("""
create table s as select * from (
  select train_line_ride_id || '@' || cast(cast(coalesce(arrival_planned_time, departure_planned_time) - interval 4 hour as date) as varchar) run,
         train_line_station_num pos, coalesce(arrival_is_canceled, false) cancelled, arrival_planned_time,
         date_diff('second', arrival_planned_time, coalesce(arrival_change_time, arrival_planned_time)) / 60.0 delay_min,
         date_diff('second', min(coalesce(departure_planned_time, arrival_planned_time)) over (partition by train_line_ride_id || '@' ||
           cast(cast(coalesce(arrival_planned_time, departure_planned_time) - interval 4 hour as date) as varchar)), arrival_planned_time) / 60.0 elapsed_min
  from read_parquet(getvariable('data'))
  where train_type in ('ICE', 'IC', 'EC', 'ECE')
    and coalesce(is_additional_stop, false) = false and coalesce(is_replacement_train, false) = false)
where arrival_planned_time is not null""")
c.execute("""
create table stops as
with r as (select run, max(pos) last_pos, max(case when not cancelled then pos end) last_served, bool_and(cancelled) all_cancelled from s group by run)
select s.run, s.pos, s.cancelled, case when s.cancelled then null else s.delay_min end delay_min, s.elapsed_min,
       r.last_served, case when r.all_cancelled then 'fully cancelled' when r.last_served < r.last_pos then 'ended early' else 'reached the end' end run_kind
from s join r using (run) order by s.run, s.pos""")
c.execute("copy stops to 'stops.parquet' (format parquet, compression zstd)")
rows = c.execute("""
with runs as (select distinct run, run_kind, last_served from stops),
     last as (select st.run, st.run_kind, st.delay_min from stops st join runs using (run) where st.pos = runs.last_served)
select 'stops', count(*) from stops
union all select 'cancelled stops', sum(cancelled::int) from stops
union all select 'on time (share, cancelled left out)', avg(case when not cancelled then (delay_min < 6)::int end) from stops
union all select 'mean delay (min, cancelled left out)', avg(delay_min) from stops
union all select 'runs', count(*) from runs
union all select 'runs ended early', count(*) from runs where run_kind = 'ended early'
union all select 'runs fully cancelled', count(*) from runs where run_kind = 'fully cancelled'
union all select 'ended early: median delay at last stop served', median(delay_min) from last where run_kind = 'ended early'
union all select 'reached the end: median delay at final stop', median(delay_min) from last where run_kind = 'reached the end'
""").fetchall()
with open("db-rules.csv", "w", newline="") as f:
    w = csv.writer(f); w.writerow(["metric", "value"])
    for m, v in rows: w.writerow([m, round(float(v), 4)])
