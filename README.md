
20/DEC/2024

* Modules

1. Sales
2. Return
3. Collection
...............................

* Functionalities

1. Adding Sales,return separately
2. Separate tables for return and sales
3. Stock management is added
4. Both online and offline settings included(check settingstable in locally stored table ,set_code: APP_DB_METHOD) ie,
online => Access data directly from server and upload directly to server on final save of sale,return,collection,
offline=> Access data from local database in phone which downloaded previously from server. Final save to local database, upload manually when network available

..............................................................

* Printing Method

-->generate pdf and tested with imin printer on 19/dec/24

................................................................
* plugins:

pdf: ^3.10.4
printing: ^5.11.0

