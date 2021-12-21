Runs basic WordPress fixes which include: <br>
* resets **.htaccess** to the default one and renames the existing one to **.htaccess+current date**
* removes any **.htaccess** files inside the wp-admin folder and renames to **.htaccess+current date**
* checks and reports for any deny rules both in the main directory and wp-admin
* resets permissions to default (644 for files, 755 for directories)
* clears cache
<br><br>*Note: Needs to be run inside the WordPress directory you want to make the changes*
---
### Usage

```bash
./wpfixme.sh
```

### Options

| Option | Action |
|:------:|:------:|
|-r      |Reverses **.htaccess** changes|
|-d      |Deletes script|

### Example

```
Koce@gnldm1001.siteground.biz in ~/public_html:./wpfixme.sh
Begin .htaccess for main WordPress directory fix
.htaccess found
Copying Done
Old .htaccess lines:  11
New .htaccess lines:  11
No deny rules found
---------------------------
Begin .htaccess for admin WordPress directory fix
.htaccess not found
---------------------------
Begin reset of permissions
Permissions reset
---------------------------
Begin cache clear
Success: The cache was flushed.
Success: Cache Successfully Purged
Warning: Rewrite rules are empty, possibly because of a missing permalink_structure option. Use 'wp rewrite list' to verify, or 'wp rewrite structure' to update permalink_structure.
Success: The cache was flushed.
Success: Cache Successfully Purged
Warning: Some rewrite rules may be missing because plugins and themes weren't loaded.
Warning: Rewrite rules are empty, possibly because of a missing permalink_structure option. Use 'wp rewrite list' to verify, or 'wp rewrite structure' to update permalink_structure.
Success: No expired transients found.
Warning: Transients are stored in an external object cache, and this command only deletes those stored in the database. You must flush the cache to delete all transients.
Cache succesfully cleared
---------------------------
```

