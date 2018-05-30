package AppointmentHandler;


use DBI;
use strict;

my $driver = "SQLite";
my $database = "appointments.db";
my $table_appointments = "appointments";
my $dsn = "DBI:$driver:dbname=$database";
my $userid = "";
my $password = "";
my $dbh;


sub conn {
   $dbh = DBI->connect($dsn, $userid, $password, { RaiseError => 1 }) 
   or die $DBI::errstr;
}

sub disconnect {
   $dbh->disconnect();
}

sub processResult {
   
   #read first argument
   my $res = $_[0];
   my $success_text = $_[1];
   
   if($res < 0) {
      return $DBI::errstr;
   } else {
      return "$success_text\n";
   }
}

sub create_table {
   conn();
   
   my $create_table = qq( CREATE TABLE IF NOT EXISTS $table_appointments ( id INTEGER PRIMARY KEY AUTOINCREMENT,
                                                   datetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                                   description TEXT
                                                  );
                      );

   my $result = $dbh->do($create_table);

   disconnect();
   
   return processResult($result, "Table created successfully");
}

sub findAll {
    conn();
    
	  my $searchTextLike = "%".$_[0]."%";
	
    my $find_all = "SELECT id, datetime, description FROM $table_appointments WHERE description LIKE ? ORDER BY datetime";
    my $prep = $dbh->prepare($find_all);
    my $result = $prep->execute($searchTextLike) or die $DBI::errstr;
    
    my @appointments;
    while(my @row = $prep->fetchrow_array()) {
       push(@appointments, { "id" => $row[0], "datetime" => $row[1], "description" => $row[2]});
    }
    
    disconnect();
    
	my $rt = processResult($result, "Retrieved successfully");
	
    return @appointments;
}

sub createOne {
    conn();
    my $app = $_[0];
    my $create_app = "INSERT INTO $table_appointments (datetime, description) VALUES ( ?, ? );";
    my $prep = $dbh->prepare($create_app);
	my $result = $prep->execute($app->{"datetime"}, $app->{"description"}) or die $DBI::errstr;
    
    disconnect();
    
    return processResult($result, "Appointment created successfully");
}

create_table();

1;
