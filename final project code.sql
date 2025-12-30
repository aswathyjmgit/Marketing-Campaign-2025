SELECT COUNT(*) AS total_events 
FROM `ad events org`;

Select e.Event_id,e.Ad_id,e.User_id,e.Date,e.Time,e.Time_of_day,e.Event_type,
a.Ad_id,a.Campaign_id,a.Ad_platform,a.Ad_type,a.Target_gender,a.Target_age_group,a.Target_interests,
c.campaign_id,
    c.name AS campaign_name,
    c.start_date,
    c.end_date,
    c.total_budget,
 u.user_gender,
    u.user_age,
    u.country,
    u.location,
    u.interests AS user_interests from  `ad events org` e
Join `ads_org` a on a.Ad_id=e.Ad_id
join `Campaigns org` c on c.Campaign_id=a.Campaign_id
join `users_org` u on e.User_id=u.user_id;

select a.Ad_platform, 
sum(e.Event_type='Impression') as impressions,
sum(e.Event_type='Click') as clicks,
SUM(e.event_type = 'comment') AS comments,
    SUM(e.Event_type = 'share') AS shares,
    SUM(e.Event_type = 'purchase') AS purchases,
    SUM(e.Event_type='Click')/Nullif (sum(e.Event_type='Impression'),0) as CTR,
     SUM(e.Event_type='purchase')/Nullif (sum(e.Event_type='Click'),0) as purchase_rate FROM `ad events org` e
join `ads_org` a on a.Ad_id=e.Ad_id
group by a.Ad_platform;
?*-----ranking by ads engagement score*/

select e.Ad_id,
sum(e.Event_type='Impression') as impressions,
sum(e.Event_type='Click') as clicks,
SUM(e.event_type = 'comment') AS comments,
    SUM(e.Event_type = 'share') AS shares,
    SUM(e.Event_type = 'purchase') AS purchases,
   ( sum(e.Event_type='Impression') *1+
sum(e.Event_type='Click')  *2+
SUM(e.event_type = 'comment') *3+
    SUM(e.Event_type = 'share') *4+
    SUM(e.Event_type = 'purchase') *5) as engagement_score,
    Rank() over( order by 
      ( sum(e.Event_type='Impression') *1+
sum(e.Event_type='Click')  *2+
SUM(e.event_type = 'comment') *3+
    SUM(e.Event_type = 'share') *4+
    SUM(e.Event_type = 'purchase') *5) desc) as engagement_rank 
    from `ad events org` e
    group by e.Ad_id;


/*-------daily activity summary----*/
select date,
count(*) as total_events,
sum(e.Event_type='Impression') as impressions,
sum(e.Event_type='Click') as clicks,
SUM(e.event_type = 'comment') AS comments,
    SUM(e.Event_type = 'share') AS shares,
    SUM(e.Event_type = 'purchase') AS purchases
    from `ad events org` e
    group by date
    order by date;
   
    

