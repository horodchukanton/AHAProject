package Distracker;
use strict;
use warnings FATAL => 'all';

use FindBin '$Bin';
our $Bin;

my $base_dir = $ENV{DISTRACKER_DATADIR} || "$Bin/data";

sub save_values {
    my ($id, $values) = @_;
    my $time = localtime();

    if (!(-e "$base_dir/$id" || mkdir "$base_dir/$id")) {
        die "No directory and failed to create ($id)\n";
    }

    my $temperature = $values->{temp};
    my $humidity = $values->{humidity};

    open(my $fh, '>>', "$base_dir/$id/last.txt") or die "Failed to open file $id";
    print $fh "$time;$temperature;$humidity\n";

    return 1;
}

sub get_sensors {
    opendir(my $dh, $base_dir) or die "Failed to open $main::base_dir";
    my @dirs = ();
    while (my $dir = readdir($dh)) {
        next if ($dir =~ /\.{1,2}/);
        push(@dirs, $dir);
    }
    closedir($dh);

    return @{[ map {{ id => $_, name => $_ }} @dirs ]};
}

sub read_values {
    my ($id) = @_;

    my @values = ();

    my $last_name = "$base_dir/$id/last.txt";
    if (-e $last_name) {
        open(my $fh, '<', $last_name) or die "Failed to open dir $last_name\n";
        push @values, readline($fh);
        close($fh);
    }

    return @values;
}

1;