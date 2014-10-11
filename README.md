snowflakeApp
============

Core Data Modules
============
Mostly standard stuff. I'm storing all the id's as string even though they are integers
in case we move the backend storage that uses a GUID.

the raw_* properties are part of the data retreived from the server but not used by the app.
For example, the report will be mapped to the trail it's associated with and can access it directly via report.trail.
I'm keeping raw_trail_id around just in case.

Third Party Libraries
============

Magical Record - This library adds convenience functions that make Core Data much nicer to work with