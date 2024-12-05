#!/usr/bin/env perl
use strict;
use warnings;

sub check_report {
	my @data = @_;

	my $is_increasing = $data[1] > $data[0] ? 1 : 0;
	for my $i (1..$#data) {
		my $dist = $data[$i] - $data[$i-1];
		return 0 if abs($dist) < 1 || abs($dist) > 3;

		if($is_increasing) {
			return 0 if $dist <= 0;
		} else {
			return 0 if $dist >= 0;
		}
	}
	1
}

sub check_report_v2 {
	my @data = @_;

	my sub is_safe {
		my @seq = @_;
		my $is_increasing = $seq[1] > $seq[0] ? 1 : 0;

		for my $i (1 .. $#seq) {
			my $dist = $seq[$i] - $seq[$i - 1];

			return 0 if abs($dist) < 1 || abs($dist) > 3;

			if ($is_increasing) {
				return 0 if $dist <= 0;
			} else {
				return 0 if $dist >= 0;
			}
		}
		return 1;
	}
	return 1 if is_safe(@data);

	for my $i (0 .. $#data) {
		my @modified = @data;
		splice(@modified, $i, 1);
		return 1 if is_safe(@modified);
	}

	return 0;
}
sub first {
	my $safe_reports;
	while(<>) {
		chomp;
		$safe_reports += check_report(split(" ", $_));
	}
	print "[Result] There are $safe_reports safe reports in the given file\n";
}

sub second {
	my $safe_reports;
	while(<>) {
		chomp;
		$safe_reports += check_report_v2(split(" ", $_));
	}
	print "[Result] There are $safe_reports safe reports in the given file\n";
}

&second;
