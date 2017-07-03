
use strict;
use warnings;

use Getopt::Long;

my $server = 'meseeks'; #= "0.0.0.0"; # Use this variable to set the remote server (where the logs will be copied)
my $directory = "./testData"; # Use this variable to set the directory where the log files will be copied from (defaults to the current directory)
my $remoteDirectory = "~/logs";
my $user = "pgrenon";
my $args = GetOptions("server|s=s" => \$server, "directory|d=s" => \$directory, "remoteDirectory|r=s" => \$remoteDirectory, "user|u=s" => \$user, "help|s" => \&usage) or die ("Error in command line arguments");

if (!$server) {
	print "No remote server given. Exiting...\n";
	exit(1);
}

sub usage {
	my $usage = <<'END';
Usage:
	log-parser --server <Remote Server> [--directory --remoteDirectory] [--help]

	where:
		--directory is the local log directory
		--remoteDirectory is the remote log directory
		--help prints this usage information
END
print $usage;
exit(0);
}

# ASSUMPTION: logs will be rolled into logs that are archived by the earliest hour in the log, not the latest, meaning there will be logs from 00-23
# Example: the log from 1 PM to 2 PM will be stored as YYYY_MM_DD_13
my $currentDate=`date +%Y_%m_%d`;
chomp $currentDate;

opendir (my $handler, $directory) || die "Unable to open directory $directory: $!";
while (readdir $handler) {
	my $logfile = $_;
	if ($logfile =~ /$currentDate\_1[89]/ || $logfile =~ /$currentDate\_2[0]/) {
			# ASSUMPTION: ssh keys have already been exchanged with the remote host (for the current user) and the key is contained under id_rsa
			# ASSUMPTION: the remote directory exists
			system ("scp -i ~/.ssh/id_rsa $directory/$logfile $user\@$server:$remoteDirectory/$logfile");
	}
}

closedir $handler;
