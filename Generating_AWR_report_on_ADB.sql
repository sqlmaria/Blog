-- Get the list of snap_ids for this database on this instance (remember its a RAC database)
 
DECLARE
 db_id NUMBER;
 inst_id NUMBER;
 
 BEGIN
   dbms_output.enable(1000000);
   SELECT dbid INTO db_id FROM v$database;
   SELECT instance_number INTO inst_id FROM v$instance;
 
   FOR v_rec IN (SELECT snap_id, begin_interval_time, end_interval_time
              FROM   dba_hist_snapshot
              WHERE  dbid = db_id
              AND    instance_number = inst_id
              ORDER BY snap_id DESC) LOOP
 
   dbms_output.put_line(' | ' ||v_rec.snap_id || ' | ' ||v_rec.begin_interval_time  || ' | ' ||v_rec.end_interval_time);
   END LOOP;
END;
 
-- Generate the AWR report for the SNAP_IDs provided by the user
 
DECLARE
  db_id NUMBER;
  inst_id NUMBER;
  start_id NUMBER;
  end_id NUMBER;
 
 BEGIN
   dbms_output.enable(1000000);
   SELECT dbid INTO db_id FROM v$database;
   SELECT instance_number INTO inst_id FROM v$instance;
   start_id := &enter_start_id;
   end_id := &enter_end_id;
 
   FOR v_awr IN (SELECT output
              FROM   TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_HTML(db_id,inst_id,start_id,end_id))) LOOP
 
   dbms_output.put_line(v_awr.output);
   END LOOP;
END;
/
