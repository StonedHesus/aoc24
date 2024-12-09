#!/usr/bin/env perl
use strict;
use warnings;

our $KEY; 
our $REVERSED_KEY;
our $KEY_LEN;

sub first {
	my @data = @_;
	my $total;
	foreach (@data) {
		my $line = $_;
		# Horizontal, normal and reversed order
		while ($line =~ /$KEY|$REVERSED_KEY/g) {
			++$total;
			pos($line) = (pos($line) || 0) - $KEY_LEN + 1;
		}
	}
	my $rows = $#data + 1;
	my $cols = length($data[0]);
	for my $i (0 .. $rows) {
		for my $j (0 .. $cols - 1) {

			if ($rows - $i >= $KEY_LEN) {
				my $vertical_str;
				foreach (0 .. $KEY_LEN - 1) {
					$vertical_str .= substr($data[$i + $_], $j, 1);
				}
				# Vertical, normal and reversed order
				if ($vertical_str =~ /$KEY|$REVERSED_KEY/) {
					++$total;
				} 
			}
			if ($rows - $i >= $KEY_LEN && $j <= $cols - $KEY_LEN) {
				my $diagonal_str;
				foreach (0 .. $KEY_LEN - 1) {
					$diagonal_str .= substr($data[$i + $_], $j + $_, 1);
				}
				# Diagonal, normal and reversed order
				if ($diagonal_str =~ /$KEY|$REVERSED_KEY/) {
					++$total;
				} 
			}

			if ($rows - $i >= $KEY_LEN && $j >= $KEY_LEN - 1) {
				my $anti_diag_str;
				for (0 .. $KEY_LEN - 1) {
					$anti_diag_str .= substr($data[$i + $_], $j - $_, 1);
				}
				# Anti-diagonal, normal and reversed order
				if ($anti_diag_str =~ /$KEY|$REVERSED_KEY/) {
					++$total;
				} 
			}
		}
	}
	$total;
}

sub second {
	my @data = @_;
	my $total;
	my $rows = scalar @data;
	my $cols = length($data[0]);

	my @search_pattern_diag_x = (0, 1, 2);
	my @search_pattern_diag_y = (0, 1, 2);

	my @search_pattern_anti_diag_x = (2, 1, 0);
	my @search_pattern_anti_diag_y = (0, 1, 2);

	for my $i (0 .. $rows - $KEY_LEN) {
		for my $j (0 .. $cols - $KEY_LEN) {
			my $diag = "";
			my $anti_diag = "";

			foreach my $p (0 .. $#search_pattern_diag_x) {
				$diag .= substr($data[$i + $search_pattern_anti_diag_y[$p]], $j + $search_pattern_diag_x[$p], 1);
			}

			if ($diag =~ /$KEY|$REVERSED_KEY/) {
				foreach my $p (0 .. $#search_pattern_anti_diag_x) {
					$anti_diag .= substr($data[$i + $search_pattern_anti_diag_y[$p]], 
						$j + $search_pattern_anti_diag_x[$p], 1);
				}

				# Check anti-diagonal match
				if ($anti_diag =~ /$KEY|$REVERSED_KEY/) {
					++$total;
				}
			}
		}
	}
	$total;
}

sub main {
	my $key = shift @ARGV;
	$KEY = uc($key) || "XMAS";
	$REVERSED_KEY = reverse $KEY;
	$KEY_LEN = length($KEY);

	my @lines;
	while (<>) {
		chomp;
		push @lines, $_;
	}
	#my $first;
	#$first = &first(@lines);
	#print "[Result] The result for the first task is: $first\n";

	my $second;
	$second = &second(@lines);
	print "[Result] The result for the second task is: $second\n";
}

&main;
