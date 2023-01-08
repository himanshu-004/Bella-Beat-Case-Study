### daily_activity intial cleaning ###
SELECT * FROM daily_activity

SELECT DISTINCT * FROM daily_activity
### No duplicate are found

SELECT LENGTH(id) FROM daily_activity
### id length is 10

SELECT COUNT(*) FROM daily_activity
WHERE LENGTH(id) > 10 AND LENGTH(id) < 10
### No id found which is greater or less then 10

SELECT MIN(activity_date) FROM daily_activity
### start date 2016-04-12

SELECT MAX(activity_date) FROM daily_activity
### end date 2016-05-12

SELECT COUNT(total_steps) FROM daily_activity
WHERE total_steps = 0
### 77 records where found which have total steps zero

SELECT id,activity_date AS date, COUNT(total_steps) AS count_0 FROM daily_activity
WHERE total_steps = 0
GROUP BY id, date
### dates, where the total_steps count is 0


### daily activity cleaned data ###

WITH daily_activities AS (
	SELECT id,
	       to_char(activity_date, 'Day') AS day, 
	       to_char(activity_date, 'Month') AS month,
	       total_steps,
	       total_distance,
	       tracker_distance,
	       logged_activities_distance,
	       very_active_distance,
	       moderately_active_distance,
	       light_active_distance,
	       sedentary_active_distance,
	       very_active_minutes,
	       fairly_active_minutes,
	       lightly_active_minutes,  
	       sedentary_minutes,
	       calories
	FROM daily_activity
	    
),

per_day_avgsteps AS (
	SELECT day, CAST(AVG(total_steps) AS DECIMAL(10,2)) AS avg_steps
	FROM daily_activities
	GROUP BY day
),

avg_total_distance AS (
	SELECT day, CAST(AVG(total_distance) AS DECIMAL(10,2)) AS total_dis_inkm
	FROM daily_activities
      GROUP BY day
	
),

avg_calories_burn AS (
      SELECT day, CAST(AVG(calories) AS  DECIMAL(10,2)) AS per_day_calories
	FROM daily_activities
	GROUP BY day

),

avg_active_minutes AS (
	SELECT day, CAST(AVG(very_active_minutes) AS DECIMAL(10,2)) AS avg_time
	FROM daily_activities
	GROUP BY day
),

calories_vs_all_minutes AS (
      SELECT day, calories, very_active_minutes, fairly_active_minutes,
	lightly_active_minutes, sedentary_minutes
	FROM daily_activities

),

calories_vs_all_distance AS (
      SELECT day, calories, total_distance, very_active_distance,
	moderately_active_distance, light_active_distance,
	sedentary_active_distance
	FROM daily_activities
	
	
),

calories_vs_steps AS (
    SELECT day,total_steps, calories 
    FROM daily_activities

)

SELECT * FROM calories_vs_steps


### sleep data vs daily activity ####



-- finding and removing dublicates 

SELECT *, COUNT(*) 
FROM sleep_data
GROUP BY Id, sleep_day, Total_Sleep_Records, Total_Time_InBed, Total_Minutes_Asleep
HAVING count(*) > 1
## 3 dublicates where found

-- creating table and adding Distinct values

CREATE TABLE Public."sleep_info" (
	id VARCHAR(50),
	Sleep_Day DATE,
	Total_Sleep_Records INTEGER,
	Total_Minutes_Asleep INTEGER,
	Total_Time_InBed INTEGER
)

INSERT INTO Public."sleep_info"
SELECT DISTINCT * FROM Public."sleep_data"


-- average amount sleep per day of week

SELECT 
     to_char(sleep_day, 'Day') AS day, 
     CAST(AVG(Total_time_inbed)/60 AS DECIMAL(10,2)) AS in_hoursofsleep 
FROM sleep_info
GROUP BY day
ORDER BY in_hoursofsleep DESC

-- time take to fall sleep and avg amount of time asleep

SELECT  
     to_char(sleep_day, 'Day') AS day, 
     CAST(AVG(total_minutes_asleep)/60 AS decimal(10,2)) AS asleep_time_inhours,
     CAST(AVG(total_time_inbed - total_minutes_asleep) AS DECIMAL(10,0)) AS time_takento_fallsleep_inmins
FROM sleep_info
GROUP BY day
ORDER BY asleep_time_inhours DESC

-- time in bed vs all minutes

SELECT 
       sd.total_time_inbed,
	 da.sedentary_minutes,
	 da.lightly_active_minutes,
	 da.fairly_active_minutes,
	 da.very_active_minutes	 
FROM daily_activity da
INNER JOIN sleep_info sd 
ON da.id = sd.id AND da.activity_date = sd.sleep_day


-- total steps vs sleep in mins

SELECT 
      da.id,to_char(sd.sleep_day, 'Day') AS day, da.total_steps,
      sd.total_time_inbed/60 AS sleep_taken 
FROM daily_activity da
INNER JOIN sleep_info sd 
ON da.id = sd.id AND da.activity_date = sd.sleep_day

-- total distance vs sleep in hour

SELECT     
	da.id,to_char(sd.sleep_day, 'Day') AS day, CAST(da.total_distance AS DECIMAL(10,1)) AS distance_travel_inkm,
      sd.total_time_inbed/60 AS sleep_taken
FROM daily_activity da
INNER JOIN sleep_info sd 
ON da.id = sd.id AND da.activity_date = sd.sleep_day


-- sleep_takenin_hours vs calories burn

SELECT 
     da.id,to_char(sd.sleep_day, 'Day') AS day, sd.total_time_inbed/60 AS sleep_in_hours , 
     da.calories
FROM daily_activity da
INNER JOIN sleep_info sd 
ON da.id = sd.id AND da.activity_date = sd.sleep_day


-- asleep_in_hours vs calories burn

SELECT  
    da.id,to_char(sd.sleep_day, 'Day') AS day, sd.total_minutes_asleep/60 AS asleep_in_hours, 
    da.calories
FROM daily_activity da
INNER JOIN sleep_info sd 
ON da.id = sd.id AND da.activity_date = sd.sleep_day


### weight_log_info ###


SELECT DISTINCT id FROM weight_log_info
### 8 distinct records where found ###

-- body_mass_index

SELECT id,CAST(AVG(weightkg) AS DECIMAL(10,2)),
   CASE 
        WHEN BMI < 18.5 THEN 'underweight'
	  WHEN BMI BETWEEN 18.5 AND 24.9 THEN 'normal or Healthy Weight'
	  WHEN BMI BETWEEN 25.0 AND 29.9 THEN 'overweight'
	  WHEN BMI >= 30.0 THEN 'obesity'	  
   END AS body_mass_index
   
FROM weight_log_info
GROUP BY id, body_mass_index


-- ismanual report

SELECT 
    ismanual_report, 
    count(*) AS report_count 
FROM weight_log_info
GROUP BY ismanual_report


### hourly_calories ###

-- avg calories burn every hr

SELECT 
     CAST(AVG(calories) AS DECIMAL(10,2)) AS avg_cal_per_hr, hours 
FROM hourly_calories
GROUP BY hours
ORDER BY hours
