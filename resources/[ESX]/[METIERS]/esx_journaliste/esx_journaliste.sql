SET @job_name = 'journaliste';
SET @society_name = 'society_journaliste';
SET @job_Name_Caps = 'journaliste';

INSERT INTO `addon_account` (name, label, shared) VALUES
  (@society_name, @job_Name_Caps, 1);

INSERT INTO `addon_inventory` (name, label, shared) VALUES
  (@society_name, @job_Name_Caps, 1);

INSERT INTO `datastore` (name, label, shared) VALUES 
    (@society_name, @job_Name_Caps, 1);

INSERT INTO `jobs` (name, label, whitelisted) VALUES
  (@job_name, @job_Name_Caps, 1);

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
  (@job_name, 0, 'stagiaire', 'Stagiaire', 550, '{}', '{}'),
  (@job_name, 1, 'reporter', 'Reporter', 650, '{}', '{}'),
  (@job_name, 2, 'investigator', 'Enqu�teur', 750, '{}', '{}'),
  (@job_name, 3, 'boss', "R�dac' chef", 950, '{}', '{}');