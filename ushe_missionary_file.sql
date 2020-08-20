/*
 This script prepares the missionary submission file to USHE
 Run against PROD DB
 */

--Fall 2019
      SELECT 3671 AS m_inst,
             CAST(b.spriden_last_name AS VARCHAR2(60)) AS m_last,
             CAST(b.spriden_first_name AS VARCHAR2(15)) AS m_first,
             CAST(b.spriden_mi AS VARCHAR2(15)) AS m_middle,
             TO_CHAR(c.spbpers_birth_date,'YYYYMMDD') AS m_birth_dt,
             TO_CHAR(d.stvterm_end_date, 'YYYYMMDD') AS m_start_dt,
             TO_CHAR(TO_DATE('08-31-2020', 'MM-DD-YYYY'), 'YYYYMMDD') AS m_end_dt,
             a.s_banner_id AS m_banner_id
        FROM students03 a
   INNER JOIN spriden b on b.spriden_pidm = a.dsc_pidm
   INNER JOIN spbpers c on c.spbpers_pidm = a.dsc_pidm
   INNER JOIN stvterm d on d.stvterm_code = a.banner_term
       WHERE dsc_term_code = '201943'
         AND spriden_change_ind IS NULL
         AND s_pt_ft IN ('F', 'P')
         AND (s_entry_action IN ('FF', 'FH') OR (EXISTS(SELECT 'Y'
                                                          FROM students03 a1
                                                         WHERE a1.dsc_pidm = a.dsc_pidm
                                                           AND a1.dsc_term_code = substr(a.dsc_term_code, 1, 4) || '3E' -- The Summer previous to that Fall.
                                                           AND a1.s_entry_action IN ('FF', 'FH', 'HS') -- If they were HS in Summer, and FH the next Fall, I assume they should have been labeled FH.
                                                    ) AND (s_entry_action = 'CS')))