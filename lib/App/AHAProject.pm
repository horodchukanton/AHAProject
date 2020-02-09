package App::AHAProject;
use strict;
use warnings FATAL => 'all';

use parent 'Exporter';

our @EXPORT = ':all';

use File::Spec;
use Cwd;

our $base_dir = $ENV{DISTRACKER_DATADIR} || File::Spec->catfile(Cwd::abs_path(), "./data");
die "Failed to open the data directory ($base_dir)" unless (-e "$base_dir" || mkdir "$base_dir");

sub new {
    my ($class, %params) = @_;
    my $self = { %params };
    bless $self, $class;
    return $self;
}

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
    opendir(my $dh, $base_dir) or die "Failed to open $base_dir";
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