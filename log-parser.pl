
use strict;
use warnings;

use Getopt::Long;

my $directory = './testData';
my $args = GetOptions("directory|d=s" => \$directory);
# ASSUMPTION: logs will be rolled into logs that are archived by the earliest hour in the log, not the latest, meaning there will be logs from 00-23
# Example: the log from 1 PM to 2 PM will be stored as YYYY_MM_DD_13

# ASSUMPTION: This doesn't need precision down to the milliseconds/nanoseconds
my $currentTime=`date +%Y_%m_%d_%H_%M_%S`;
chomp $currentTime;
my(@regexMatch) = $currentTime =~ /(.*_.*_.*_.*)_(.*)_(.*)/;

my $currentHour = $regexMatch[0];
my $secondCount = ($regexMatch[1] * 60 + $regexMatch[2]);
my $tenMinutesAgo = $secondCount - 600;
if ($tenMinutesAgo < 0){
	$tenMinutesAgo = 0;
}
print "ten minutes ago: $tenMinutesAgo\n";

opendir (my $dirHandle, $directory) || die "Unable to open directory $directory: $!";
while (readdir $dirHandle) {
	my $logfile = $_;
		if ( $logfile =~ $currentHour ) {
			open (my $fileHandle, '<', "$directory/$logfile") or die "Unable to open file, $!";
			while (<$fileHandle>) {
				my $line = $_;
				my @fields = split(/ /,$line);
				# Grab the minutes and seconds from the time field
				my(@fieldsMatch) = $fields[3] =~ /.*\d\d\d\d:\d\d:(\d\d):(\d\d)/;
				my $lineTime = ($fieldsMatch[0]*60 + $fieldsMatch[1]);
				print "line time: $lineTime\n";
				if ($lineTime >= $tenMinutesAgo ) {
						if( $fields[8] == '500') {
							print "$line";
						}
				}
			}
			close $fileHandle;
		}
}

closedir $dirHandle;
