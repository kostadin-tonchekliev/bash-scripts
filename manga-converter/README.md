Manga converter designed to work with the HakuNero downloader and Calibre converter.
Features:
* detects downloaded mangas
* allows converting each chapter into a separate file or into a single one
* automatically moves them into their own locations
* various security measure preventing user error
---
### Usage
```bash
./converter.sh
```

### Example
```
Koce@ ~/Desktop/scripts/manga-converter:bash converter.sh
Converter script v2
Choose name:
[1]Ane Naru Mono
[2]Jujutsu Kaisen
[3]Kimetsu no Yaiba
[4]Naruto
4
Would you like to compress all of them in one file? y/n
n
Current chapter: Chapter001-007
[+]Done
Current chapter: Chapter008-017
[+]Done
Current chapter: Chapter028-036
[+]Done
Current chapter: Chapter037-045
[+]Done
Current chapter: Chapter46
[+]Done
Current chapter: Chapter47
[+]Done
Current chapter: Chapter48
[+]Done
Would you like to move the converted data? y/n
y
```