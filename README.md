# effective-dollop
Web application for appointment handling. It works through perl-cgi. 
PERL 
JSON 
SQLite 
JQuery 
HTML

# System requirements (developed and tested with):
- perl 5, version 12, subversion 3 (v5.12.3)
- apache 2.4

# Installation manual:
- [Download & Install Perl](https://www.perl.org/get.html)
- Make sure **perl** and **cpan** commands have been added to the ENVIRONMENT PATH (you should be able to execute **perl** and **cpan** from OS CLI)
- Time::Parse module installation. Enter **cpan** CLI. Put there **notest install Time::ParseDate.**
- DateTime::Format::Strptime module installation. Enter **cpan** CLI. Put there **notest install DateTime::Format::Strptime.**
- [Download & Install Apache 2.4](https://httpd.apache.org/download.cgi)
- [Configure Apche to permit CGI](https://httpd.apache.org/docs/2.4/howto/cgi.html)
- Put file **test.pl** and **lib** folder and **appointments.db** into **_${APACHE_ROOT}/cgi-bin_** folder 
( e.g.for Windows "C:\Apache24\cgi-bin\" )
- Put **index.html** and **js** folder into **_${APACHE_ROOT}/htdocs_** folder
( e.g for Windows "C:\Apache24\htdocs\" )
- Run Apache Server
- Open according URL in Web browser
