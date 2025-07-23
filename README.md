# Ads Performance Dashboard

This project presents an advertising performance dashboard built in **Tableau Public**, based on enriched data from **Facebook Ads** and **Google Ads**. SQL joins were executed via **DBeaver** to combine campaign and ad set level data, enabling deeper analysis.

## 🎯 Project Goals

- Merge advertising data from Facebook Ads and Google Ads
- Calculate key marketing metrics
- Visualize insights through Tableau Public dashboard

## 📊 Key Metrics Displayed

- **CPC** – Cost Per Click (SUM(cost)/SUM(clicks))
- **CPM** – Cost Per 1000 Impressions
- **CTR** – Click-Through Rate
- **ROMI** – Return on Marketing Investment
- Total Spend and Revenue
- Conversions per Campaign
- Monthly Trends by Campaign Name

## 🧩 SQL Data Preparation

Using **DBeaver**, we enriched and joined ad data from Facebook and Google sources using:
- `campaign_name`
- `adset_name`

This approach allowed for a cleaner and more reliable dataset, compared to relying on UTM parameters.

## 🖼️ Dashboard Preview

![Dashboard Screenshot](screenshots/dashboard_view.png)

## 🛠 SQL Query Preview

![SQL Query Screenshot](screenshots/sql_join.png)

## ▶️ Video Demonstration

Watch the project demo on YouTube:  
👉 [https://youtu.be/gkC3pP_tc1w](https://youtu.be/iWqqd7ZRQrI?si=ymnR-uqnI3U2n1rK)

## 🔗 Tableau Public Dashboard

👉 [View Tableau Dashboard](https://public.tableau.com/views/final_DA_17525341835200/Dashboard1?:language=en-US&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## 🛠 Technologies Used

- **PostgreSQL** – SQL joins and data preparation  
- **DBeaver** – SQL execution  
- **Tableau Public** – Dashboard creation  
- **GitHub** – Project hosting and documentation  

## 📦 Folder Structure

