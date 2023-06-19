\c host_agent


SELECT host_id, cpu_idle, memory_free 
FROM host_usage
GROUP BY host_id, cpu_idle, memory_free
ORDER BY memory_free DESC;

CREATE FUNCTION round5(ts timestamp) RETURNS timestamp AS
$$
BEGIN
    RETURN date_trunc('hour', ts) + date_part('minute', ts):: int / 5 * interval '5 min';
END;
$$
    LANGUAGE PLPGSQL;


SELECT host_id, timestamp, round5(timestamp)
FROM host_usage;


\q
