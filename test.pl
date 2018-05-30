#!perl -w

use warnings;
use strict;
use CGI;
use db_manager;
use Time::Piece;
use Time::ParseDate;
use DateTime::Format::Strptime;
use JSON;

sub validateFields {
	my $regexDate = "^\\d{2}/\\d{2}/\\d{4}\$";
	my $regexTime = "^\\d{2}:\\d{2}\$";
	
	my $date = $_[0];
	my $time = $_[1];
	my $desc = $_[2];

	if(! defined $date || ! defined $time || ! defined $desc 
			|| $date eq "" || $time eq "" || $desc eq "") { # check empty field
		return "Some mandatory field is empty";
	} 
	
	if($date !~ $regexDate || $time !~ $regexTime) { # check date and time patterns
		return "Invalid format. Should be date -> mm/dd/yyyy and time -> hh:mm";
	}
	
	if( isValidDateTime($date, "mm/dd/yyyy") == 0 || isValidDateTime($time, "hh:mm") == 0 ) {
		return "Invalid date/time";
	}
	
	return "";
}

sub isValidDateTime {
	my %options;
	# param pattern for validation
	push(@{$options{"VALIDATE"}}, $_[1]);
	# param $date or $time
	my $seconds = parsedate($_[0], %options);
	
	if(! defined $seconds) {
		return 0;
	}
	return 1;
}

my $q = CGI->new();
my $requestType = $ENV{"REQUEST_METHOD"};

print $q->header(-type => 'application/json;charset=UTF-8');

if($requestType eq "GET") {

    my @result = db_manager::findAll($q->param("searchText"));
    my @response;
    foreach (@result) {
		my $datetime = $_->{"datetime"};
        my $date = localtime($datetime)->strftime('%m/%d/%Y');
        my $time = localtime($datetime)->strftime('%H:%M');

        push(@response, {"date" => "$date", "time" => "$time", "description" => $_->{"description"} });
    }
    my $json_text = encode_json \@response;
	print $json_text;

} elsif($requestType eq "POST") {
    my $date = $q->param("date");
    my $time = $q->param("time");
    my $desc = $q->param("desc");
    
	my %response;
	my $errorText = validateFields($date, $time, $desc);
		
	if(length $errorText == 0) {
		my $datetime =$date." ".$time;
		
		my $parser = DateTime::Format::Strptime->new( 
			pattern => '%m/%d/%Y %H:%M',
			time_zone => 'local'
		);
		my $dt = $parser->parse_datetime( $datetime );
		
		my $result = db_manager::createOne( { "datetime" => $dt->epoch,
								 "description" => $desc } );
		
		
	}
	
	%response = ("error" => $errorText);
	my $json = encode_json \%response;
	print $json;
}





