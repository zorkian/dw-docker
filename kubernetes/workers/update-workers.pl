#!/usr/bin/perl

use strict;
use v5.10;

my %workers = (
    # Name                MinCt, MaxCt, Memory, MilliCpu, TgtCpu
    'esn-process-sub' => [    5,    60,  '300M',  '500m',    70  ],
);

my $template;
{
    local $/ = undef;
    open FILE, "<worker.yaml.template" or die;
    $template = <FILE>;
    close FILE;
}

foreach my $worker (keys %workers) {
    my ($min, $max, $mem, $cpu, $util) = @{$workers{$worker}};

    my $yaml = $template;
    $yaml =~ s/\$WORKER/$worker/g;
    $yaml =~ s/\$MIN_REPLICAS/$min/g;
    $yaml =~ s/\$MAX_REPLICAS/$max/g;
    $yaml =~ s/\$CPU_REQUEST/$cpu/g;
    $yaml =~ s/\$MEMORY_REQUEST/$mem/g;
    $yaml =~ s/\$TARGET_UTILIZATION/$util/g;

    open FILE, ">generated/$worker.yaml" or die;
    print FILE $yaml;
    close FILE;
}
