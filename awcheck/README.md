Script designed to check and report statistics which works with the awstats inside the Site Tools system. It works with any directory location so you can run it whenever convenient

---
### Usage:
Firstly select the desired installation and after that select the desired date from which to report the statistics.

### Example:
```bash
baseos | u450-hfisk9ohgmtt@gnldm1081.siteground.biz:~$ bash awcheck.sh 
Awstats Checker ver 1.0
--------------------------
[1]mushymyce.com
[2]staging2.mushymyce.com
Please select installation to read:
1
Avaiable Dates
[1]11 2021
[2]09 2021
[3]12 2021
[4]04 2021
[5]10 2021
[6]07 2021
[7]06 2021
[8]03 2021
[9]05 2021
[10]08 2021
Please select stat file to read:
3
--------------------------
Top 10 Highest Number of Visits per IP:
4536 79.100.188.**
3127 89.215.164.***
1106 46.10.14.***
698 87.243.106.***
688 94.158.24.**
687 37.63.19.**
670 79.100.43.***
617 82.35.156.***
583 91.148.153.***
575 130.204.151.***
--------------------------
Numbers of errors:
2 201
3 204
92 206
2597 301
533 302
71 400
4 401
24 403
1445 404
2 405
297 499
1 500
43 503
--------------------------
 Top 10 most visited pages:
5410 /
989 /wp-admin/admin-ajax.php
801 /cart/
720 /wp-content/themes/storefront/assets/fonts/fa-solid-900.woff2
479 /wp-json/wc-admin/options
479 /shop/
477 /wp-json/wc-analytics/admin/notes
143 /product-category/december-new-stuff/
139 /product/peaches-long-sleeve/
138 /product/peaches-long-sleeve/image/gif

```