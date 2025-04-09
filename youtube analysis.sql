
-- Video Performance Analysis

--1. Video with the Highest Engagement Rate
SELECT TOP 1 video_id, title, 
       (likes + dislikes + comment_count) * 1.0 / views AS engagement_rate
FROM YoutubeData
WHERE views > 0
ORDER BY engagement_rate DESC;

--2 Top 5 Trending Videos by Likes-to-Views Ratio
SELECT TOP 5 video_id, title, 
       (likes * 1.0 / views) AS likes_to_views_ratio
FROM YoutubeData
WHERE views > 0
ORDER BY likes_to_views_ratio DESC;

--3 Controversial Videos (Like-to-Dislike Ratio Below 90%)
SELECT video_id, title, 
       (likes * 1.0 / NULLIF(dislikes, 0)) AS like_dislike_ratio
FROM YoutubeData
WHERE dislikes > 0
AND (likes * 1.0 / NULLIF(dislikes, 0)) < 0.90
ORDER BY like_dislike_ratio ASC;

--4 Category with the Highest Average Watch Time
SELECT category_id, 
       AVG(likes + comment_count) AS avg_watch_time
FROM YoutubeData
GROUP BY category_id
ORDER BY avg_watch_time DESC;

--5 Videos Trending in Multiple Countries
SELECT video_id, COUNT(DISTINCT publish_country) AS trending_countries
FROM YoutubeData
GROUP BY video_id
HAVING COUNT(DISTINCT publish_country) > 1
ORDER BY trending_countries DESC;

-- Content Trends & Insights

--6. Most Common Words in Video Titles
SELECT TOP 15 word, COUNT(*) AS frequency
FROM (SELECT value AS word 
      FROM YoutubeData 
      CROSS APPLY STRING_SPLIT(title, ' ')) AS WordList
GROUP BY word
ORDER BY frequency DESC;

--7 Category with the Most Viral Videos (Views > 10M)
SELECT category_id, COUNT(*) AS viral_video_count
FROM YoutubeData
WHERE views > 10000000
GROUP BY category_id
ORDER BY viral_video_count DESC;

--8 Day of the Week with the Most Views
SELECT DATENAME(WEEKDAY, trending_date) AS day_of_week, 
       SUM(views) AS total_views
FROM YoutubeData
GROUP BY DATENAME(WEEKDAY, trending_date)
ORDER BY total_views DESC;


--9 Month with the Highest Uploads
SELECT DATENAME(MONTH, trending_date) AS month_name, 
       COUNT(*) AS uploads
FROM YoutubeData
GROUP BY DATENAME(MONTH, trending_date), DATEPART(MONTH, trending_date)
ORDER BY uploads DESC;


--10 Most Frequently Used Tags
SELECT TOP 10 tag, COUNT(*) AS tag_count
FROM (SELECT value AS tag 
      FROM YoutubeData 
      CROSS APPLY STRING_SPLIT(tags, '|')) AS TagList
GROUP BY tag
ORDER BY tag_count DESC;

-- Creator Performance & Growth

--11 Creators with the Highest Average Views per Video
SELECT channel_title, AVG(views) AS avg_views
FROM YoutubeData
GROUP BY channel_title
ORDER BY avg_views DESC;

--12 Creators with the Highest Engagement (Likes + Dislikes + Comments)
SELECT channel_title, 
       AVG(likes + dislikes + comment_count) AS avg_engagement
FROM YoutubeData
GROUP BY channel_title
ORDER BY avg_engagement DESC;

--13 Unique Creators with at Least One Trending Video
SELECT COUNT(DISTINCT channel_title) AS unique_creators
FROM YoutubeData;

--14  Fastest-Growing Creators (Views in Shortest Trending Time)
SELECT channel_title, SUM(views) AS total_views, 
       COUNT(DISTINCT trending_date) AS trending_days
FROM YoutubeData
GROUP BY channel_title
HAVING COUNT(DISTINCT trending_date) < 10
ORDER BY total_views DESC;

--15 Creators with Low Dislike-to-Like Ratio
SELECT channel_title, AVG(dislikes * 1.0 / NULLIF(likes, 0)) AS dislike_ratio
FROM YoutubeData
WHERE likes > 0
GROUP BY channel_title
HAVING AVG(dislikes * 1.0 / likes) < 0.05
ORDER BY dislike_ratio ASC;


--Category & Region-Based Analysis

 --16 Best Performing Categories by Country
 SELECT publish_country, category_id, SUM(views) AS total_views
FROM YoutubeData
GROUP BY publish_country, category_id
ORDER BY publish_country, total_views DESC;

--17 Comparing Popularity of Categories in Two Countries
SELECT category_id, 
       SUM(CASE WHEN publish_country = 'US' THEN views ELSE 0 END) AS US_views,
       SUM(CASE WHEN publish_country = 'canada' THEN views ELSE 0 END) AS Canada_views
FROM YoutubeData
GROUP BY category_id
ORDER BY US_views DESC, Canada_views DESC;

 --18 Categories with the Highest Comment Engagement

 SELECT category_id, AVG(comment_count * 1.0 / NULLIF(views, 0)) AS comment_ratio
FROM YoutubeData
WHERE views > 0
GROUP BY category_id
ORDER BY comment_ratio DESC;

--19 Categories with High Dislikes (>10% of Likes)
SELECT category_id, COUNT(*) AS negative_reception_count
FROM YoutubeData
WHERE dislikes > 0 AND (dislikes * 1.0 / NULLIF(likes, 0)) > 0.10
GROUP BY category_id
ORDER BY negative_reception_count DESC;

