/*
 Missionary Submission File to USHE
 Run against PROD DB
 */

WITH cohorts AS (SELECT a.sgrchrt_pidm AS pidm,
                        sgrchrt_term_code_eff,
                        b.stvterm_desc AS term,
                        sgrchrt_chrt_code
                   FROM sgrchrt a
                        LEFT JOIN stvterm b
                        ON b.stvterm_code = a.sgrchrt_term_code_eff
                  WHERE b.stvterm_desc IN ('Fall 2013', 'Spring 2014', 'Fall 2014', 'Spring 2015')
                    AND (sgrchrt_chrt_code LIKE 'FT%' OR sgrchrt_chrt_code LIKE 'TU%'))

/* USHE Submission Query */
      SELECT DISTINCT
             3671 AS m_inst,
             CAST(b.spriden_last_name AS varchar(60)) AS m_last,
             CAST(b.spriden_first_name AS varchar(15)) m_first,
             CAST(b.spriden_mi AS varchar(15)) AS m_middle,
             TO_CHAR(c.spbpers_birth_date, 'YYYYMMDD') AS m_birth_dt,
             /* oldest term end date */
             TO_CHAR(MIN(d.stvterm_end_date), 'YYYYMMDD') AS m_start_dt,
             TO_CHAR(TO_DATE('01-31-2021', 'MM-DD-YYYY'), 'YYYYMMDD') AS m_end_dt,
             'D' || b.spriden_id AS m_banner_id
        FROM cohorts a
  INNER JOIN spriden b
          ON b.spriden_pidm = a.pidm
  INNER JOIN spbpers c
          ON c.spbpers_pidm = a.pidm
  INNER JOIN stvterm d
          ON d.stvterm_code = a.sgrchrt_term_code_eff
       WHERE b.spriden_change_ind IS NULL
    GROUP BY b.spriden_last_name,
             b.spriden_first_name,
             b.spriden_mi,
             TO_CHAR(c.spbpers_birth_date, 'YYYYMMDD'),
             TO_CHAR(TO_DATE('08-31-2020', 'MM-DD-YYYY'), 'YYYYMMDD'),
             b.spriden_id;

