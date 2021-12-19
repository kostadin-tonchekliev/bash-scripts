Script designed to run a WhoIs check on given domain and report information based on it. Usefull for checking additonal information about certain domain or debugging domain issues
<br >*Note: Currently works only with top level domains, .com/.net/etc.*
---
### Usage
```bash
./domcheck.sh domain.ltd
```
### Example
```bash
Koce@ ~:./domcheck.sh google.com
Domain: google.com
--------------------------------
Expiration Date: 2028-09-14
--------------------------------
Registrar:  MarkMonitor Inc.
--------------------------------
Domain Status: clientDeleteProhibited
Domain Status: clientTransferProhibited
--------------------------------
DNSSEC: unsigned
DNSSEC: unsigned
--------------------------------
NameServer: ns1.google.com
NameServer: ns2.google.com
NameServer: ns3.google.com
NameServer: ns4.google.com
```