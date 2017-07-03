
use strict;
use warnings;



my $fileNameBase = `date +%Y_%m_%d`;
chomp ($fileNameBase);

my $currentHour = `date +%H`;
my $currentMinute = `date +%M`;
my $currentSecond = `date +%S`;
chomp ($currentHour);
chomp ($currentMinute);
chomp ($currentSecond);

sub subtractMinutes ($$) {
	my $minutes = shift;
	my $minutesToSubtract = shift;
	$minutes -= $minutesToSubtract;
	if ($minutes < 0 ){
		return 0
	}
	return $minutes;
}


my $now = "$currentHour:$currentMinute:$currentSecond";
my $fiveMinutesAgo = "$currentHour:".subtractMinutes($currentMinute, 5).":$currentSecond";
my $tenMinutesAgo = "$currentHour:".subtractMinutes($currentMinute, 10).":$currentSecond";
my $fifteenMinutesAgo = "$currentHour:".subtractMinutes($currentMinute, 15).":$currentSecond";

for (my $i = 0; $i <= 23; $i++ ) {
	my $fileName = $fileNameBase;
	# prepend a zero to the single digits
	$fileName .= ($i < 10 ? "_0".$i : "_".$i);
	open (my $fileHandle, '>', $fileName);
	print $fileHandle <<"END";
127.0.0.1 - frank [10/Oct/2000:$now -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
127.0.0.1 - frank [10/Oct/2000:$now -0700] "POST /apache_pb.gif HTTP/1.0" 330 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
127.0.0.1 - frank [10/Oct/2000:$now -0700] "PUT /apache_pb.gif HTTP/1.0" 404 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
127.0.0.1 - frank [10/Oct/2000:$now -0700] "DELETE /apache_pb.gif HTTP/1.0" 500 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
127.0.0.1 - frank [10/Oct/2000:$fiveMinutesAgo -0700] "DELETE /apache_pb.gif HTTP/1.0" 500 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
127.0.0.1 - frank [10/Oct/2000:$tenMinutesAgo -0700] "DELETE /apache_pb.gif HTTP/1.0" 500 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
127.0.0.1 - frank [10/Oct/2000:$fifteenMinutesAgo -0700] "DELETE /apache_pb.gif HTTP/1.0" 500 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
END

	close $fileHandle;
}
