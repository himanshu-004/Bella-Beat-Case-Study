### daily_activity ###

CREATE TABLE Public."daily_activity" (
	id VARCHAR(50),
	Activity_Date Date,
	Total_Steps float,
	Total_Distance float,
	Tracker_Distance float,
	Logged_Activities_Distance float,
	Very_Active_Distance float,
	Moderately_Active_Distance float,
	Light_Active_Distance float,
	Sedentary_Active_Distance float,
	Very_Active_Minutes INTEGER,
	Fairly_Active_Minutes INTEGER,
	Lightly_Active_Minutes INTEGER,
	Sedentary_Minutes INTEGER,
	Calories INTEGER
)



COPY Public."daily_activity" FROM 'D:\Data Analytics Projects\bellabeat case study\Fitabase Data 4.12.16-5.12.16\dailyActivity_merged.csv' DELIMITER ',' CSV HEADER; 



### hourly_calories ###

CREATE TABLE Public."hourly_calories" (
	
	id VARCHAR(50),
	Activity DATE,
	Hours TIME,
	Calories INTEGER

)

SELECT * FROM hourly_calories

COPY Public."hourly_calories" FROM 'D:\Data Analytics Projects\bellabeat case study\Fitabase Data 4.12.16-5.12.16\hourlyCalories_merged.csv' DELIMITER ',' CSV HEADER;



### sleep_day ### 

CREATE TABLE Public."sleep_data" (
	id VARCHAR(50),
	Sleep_Day DATE,
	Total_Sleep_Records INTEGER,
	Total_Minutes_Asleep INTEGER,
	Total_Time_InBed INTEGER
)

SELECT * FROM sleep_day

COPY Public."sleep_day" FROM 'D:\Data Analytics Projects\bellabeat case study\Fitabase Data 4.12.16-5.12.16\sleepDay_merged.csv' DELIMITER ',' CSV HEADER;



### weight_log_info ###

CREATE TABLE Public."weight_log_info" (
	id VARCHAR(50),
	Date DATE,
	Hour TIME,
	WeightKg FLOAT,
	Weight_Pounds FLOAT,
	Fat INTEGER,
	BMI FLOAT,
	IsManual_Report BOOL,
	LogId VARCHAR(50)

)

SELECT * FROM weight_log_info

COPY Public."weight_log_info" FROM 'D:\Data Analytics Projects\bellabeat case study\Fitabase Data 4.12.16-5.12.16\weightLogInfo_merged.csv' DELIMITER ',' CSV HEADER;
