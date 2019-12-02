#!/usr/bin/perl

use strict;
use v5.10;

my %workers = (
    # Name                MinCt, MaxCt, Memory, MilliCpu, TgtCpu
    'esn-process-sub' => [    5,    60,  '300M',  '500m',    70  ],
);
