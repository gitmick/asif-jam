"""03-impute-relative.py stops.parquet  ->  impute-relative.csv

A run that ended early never reached its last stops. Fill each of those stops with the same RELATIVE
delay the train had at the last stop it served: delay / planned minutes since it left its first station,
times the planned minutes to the missing stop. If it was 10 % late there, it is 10 % late at the end.
Other cancelled stops, and fully cancelled runs, stay left out.
"""
import csv, sys, duckdb
c = duckdb.connect()
c.execute("set variable stops = ?", [sys.argv[1]])
rows = c.execute("""
with st as (select * from read_parquet(getvariable('stops'))),
     filled as (select st.*, case when st.run_kind = 'ended early' and st.pos > st.last_served and ls.elapsed_min > 0 then ls.delay_min / ls.elapsed_min * st.elapsed_min end imputed
                from st left join st ls on ls.run = st.run and ls.pos = st.last_served),
     v as (select coalesce(delay_min, imputed) d, imputed from filled)
select 'stops filled', count(imputed) from v
union all select 'mean delay of the filled stops (min)', avg(imputed) from v
union all select 'mean delay (min)', avg(d) from v
union all select 'on time (share)', avg((d < 6)::int) from v where d is not null
""").fetchall()
with open("impute-relative.csv", "w", newline="") as f:
    w = csv.writer(f); w.writerow(["metric", "value"])
    for m, v in rows: w.writerow([m, round(float(v), 4)])
