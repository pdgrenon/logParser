
use strict;
use warnings;



my $fileNameBase = `date +%Y_%m_%d`;
chomp ($fileNameBase);

for (my $i = 0; $i <= 23; $i++ ) {
	my $fileName = $fileNameBase;
	# prepend a zero to the single digits
	$fileName .= ($i < 10 ? "_0".$i : "_".$i);
	print "$fileName\n";
	open (my $fileHandle, '>', $fileName);
	print $fileHandle <<'END';
127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "GET /apache_pb.gif HTTP/1.0" 200 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "POST /apache_pb.gif HTTP/1.0" 330 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "PUT /apache_pb.gif HTTP/1.0" 404 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
127.0.0.1 - frank [10/Oct/2000:13:55:36 -0700] "DELETE /apache_pb.gif HTTP/1.0" 500 2326 "http://www.example.com/start.html" "Mozilla/4.08 [en] (Win98; I ;Nav)"
END

	close $fileHandle;
}
