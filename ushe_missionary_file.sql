/*
 Missionary Submission File to USHE
 Run against PROD DB
 */
WITH cohorts AS (SELECT a.dsc_pidm,
                        SUBSTR(dsc_term_code, 0, 5) || '0' AS sgrchrt_term_code_eff,
                        CASE
                           /* 201943 */
                           WHEN dsc_term_code = '201943' AND s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201940'
                           WHEN dsc_term_code = '201943' AND s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201940'
                           WHEN dsc_term_code = '201943' AND s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201940'
                           WHEN dsc_term_code = '201943' AND s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201940'
                           /* 201443 */
                           WHEN dsc_term_code = '201443' AND s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201440'
                           WHEN dsc_term_code = '201443' AND s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201440'
                           WHEN dsc_term_code = '201443' AND s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201440'
                           WHEN dsc_term_code = '201443' AND s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201440'
                           /* 201243 */
                           WHEN dsc_term_code = '201243' AND s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201240'
                           WHEN dsc_term_code = '201243' AND s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201240'
                           WHEN dsc_term_code = '201243' AND s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201240'
                           WHEN dsc_term_code = '201243' AND s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201240'
                           /* 201343 */
                           WHEN dsc_term_code = '201343' AND s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'FTFB201340'
                           WHEN dsc_term_code = '201343' AND s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'FTPB201340'
                           WHEN dsc_term_code = '201343' AND s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'FTFO201340'
                           WHEN dsc_term_code = '201343' AND s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'FTPO201340'
                           END AS sgrchrt_chrt_code
                   FROM students03 a
                  WHERE dsc_term_code IN ('201943', '201443', '201343', '201243')
                    AND s_pt_ft IN ('F', 'P')
                    AND (s_entry_action IN ('FF', 'FH') OR (EXISTS(SELECT 'Y'
                                                                     FROM students03 a1
                                                                    WHERE a1.dsc_pidm = a.dsc_pidm
                                                                      AND a1.dsc_term_code = substr(a.dsc_term_code, 1, 4) || '3E' -- The Summer previous to that Fall.
                                                                      AND a1.s_entry_action IN ('FF', 'FH', 'HS') -- If they were HS in Summer, and FH the next Fall, I assume they should have been labeled FH.
                                                               ) AND (s_entry_action = 'CS')))

                  UNION

                  /* Transfers */
                  SELECT dsc_pidm AS sgrchrt_pidm,
                         SUBSTR(dsc_term_code, 0, 5) || '0' AS sgrchrt_term_code_eff,
                        CASE
                           WHEN dsc_term_code = '201243' AND s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB201240'
                           WHEN dsc_term_code = '201243' AND s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB201240'
                           WHEN dsc_term_code = '201243' AND s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO201240'
                           WHEN dsc_term_code = '201243' AND s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO201240'
                           /* 201343 */
                           WHEN dsc_term_code = '201343' AND s_pt_ft = 'F' AND s_deg_intent = '4' THEN 'TUFB201340'
                           WHEN dsc_term_code = '201343' AND s_pt_ft = 'P' AND s_deg_intent = '4' THEN 'TUPB201340'
                           WHEN dsc_term_code = '201343' AND s_pt_ft = 'F' AND s_deg_intent != '4' THEN 'TUFO201340'
                           WHEN dsc_term_code = '201343' AND s_pt_ft = 'P' AND s_deg_intent != '4' THEN 'TUPO201340'
                           END AS sgrchrt_chrt_code
                 FROM students03 a
                WHERE dsc_term_code IN ('201243', '201343')
                  AND s_pt_ft IN ('F', 'P')
                  AND (s_entry_action = 'TU' OR (EXISTS(SELECT 'Y'
                                                          FROM students03 a1
                                                         WHERE a1.dsc_pidm = a.dsc_pidm
                                                           AND a1.dsc_term_code = substr(a.dsc_term_code, 1, 4) || '3E' -- The Summer previous to that Fall.
                                                           AND a1.s_entry_action = 'TU' -- If they were TU in Summer, and something else the next Fall, I assume they should have been labeled TU.
                                                    ) AND (s_entry_action != 'HS')))

                  UNION

                  /* SPRING */
                  SELECT dsc_pidm AS sgrchrt_pidm,
                         SUBSTR(dsc_term_code, 0, 5) || '0' AS sgrchrt_term_code_eff,
                         CASE
                            WHEN dsc_term_code = '201323' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFB201320'
                            WHEN dsc_term_code = '201323' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTFO201320'
                            WHEN dsc_term_code = '201323' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPB201320'
                            WHEN dsc_term_code = '201323' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action IN ('FF', 'FH') THEN 'FTPO201320'
                            WHEN dsc_term_code = '201323' AND s_pt_ft = 'F' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUFB201320'
                            WHEN dsc_term_code = '201323' AND s_pt_ft = 'F' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUFO201320'
                            WHEN dsc_term_code = '201323' AND s_pt_ft = 'P' AND s_deg_intent = '4' AND s_entry_action = 'TU' THEN 'TUPB201320'
                            WHEN dsc_term_code = '201323' AND s_pt_ft = 'P' AND s_deg_intent != '4' AND s_entry_action = 'TU' THEN 'TUPO201320'
                            END AS sgrchrt_chrt_code
                   FROM students03 a
                  WHERE dsc_term_code = '201323'
                    AND s_pt_ft IN ('F', 'P')
                    AND s_entry_action IN ('FF', 'FH', 'TU')
   )

/* USHE Submission Query */

      SELECT DISTINCT
            3671 AS m_inst,
            b.spriden_last_name AS m_last,
            b.spriden_first_name AS m_first,
            b.spriden_mi AS m_middle,
            TO_CHAR(c.spbpers_birth_date, 'YYYYMMDD') AS m_birth_dt,
            TO_CHAR(MIN(d.stvterm_end_date), 'YYYYMMDD') AS m_start_dt, /* oldest term end date */
            TO_CHAR(TO_DATE('08-31-2020', 'MM-DD-YYYY'), 'YYYYMMDD') AS m_end_dt,
            b.spriden_id AS m_banner_id
        FROM cohorts a
  INNER JOIN spriden b
          ON b.spriden_pidm = a.dsc_pidm
  INNER JOIN spbpers c
          ON c.spbpers_pidm = a.dsc_pidm
  INNER JOIN stvterm d
          ON d.stvterm_code = a.sgrchrt_term_code_eff
       WHERE b.spriden_change_ind IS NULL
    GROUP BY
            b.spriden_last_name ,
            b.spriden_first_name,
            b.spriden_mi,
            TO_CHAR(c.spbpers_birth_date, 'YYYYMMDD'),
            TO_CHAR(TO_DATE('08-31-2020', 'MM-DD-YYYY'), 'YYYYMMDD'),
            b.spriden_id
    ;


