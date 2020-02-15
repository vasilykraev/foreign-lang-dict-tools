Helpful scripts for working with lang tools, like anki or online language learning services, like memrise.

`memrise-export.js` - script for exporting words from memrise course to CSV (with some techincal ids, and mark for ignored words). Run in console tab in DevTools. Tested with Chrome v.58+

`make-own-dictionary.sh` - bash script, which download word definition and pronunciation, just put list of interested words into `list.txt` file and run the script. Folders `mp3` and `json` will be created automatically, and as result you also get the `words.txt` file with word and definition (tab separated, ready to upload into memrise).