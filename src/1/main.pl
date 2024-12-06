#!/usr/bin/env perl

use strict;
use warnings;

sub read_input {
	my ($file) = @_;
	print "[INFO] Reading the $file file\n";
	open (my $fh, "<", $file) or die "[Error] Can't open file $file: $!\n";
	
	my (@left, @right);
	while (my $line = <$fh>) {
		if ($line =~ /(\d+)\s*\b.*?\b\s*(\d+)/) {
			push @left, $1;
			push @right, $2;
		}
	}
	close($fh);
	print "[INFO] Left column: @left\n";
    print "[INFO] Right column: @right\n";
	print "[INFO] Concluded reading the input for $file\n";
	(\@left, \@right);
};

sub remove_duplicates {
	my @input = @_;
	my %seen;
	grep !$seen{$_}++, @input;
}

sub solve_for_files {
	my @files = @_;
	foreach(@files) {
		my ($left_r, $right_r) = &read_input($_);
		print "[INFO] Processing input for $_\n";
		my @left = sort { $a <=> $b } @$left_r;
		print "[INFO] Sorted left list: @left\n";
		my @right = sort { $a <=> $b } @$right_r;
		print "[INFO] Sorted right list: @right\n";
		
		my $total;
		for my $i (0..$#left) {
			$total += abs ($left[$i] - $right[$i]);
		}
		
	 	print "[Result] The result for the first task computed on file $_ is $total\n";

		@left = @$left_r;
		@right = @$right_r;
		my %tmp;
		foreach (@right) {
			++$tmp{$_};
		}

		$total = 0;
		foreach(@left) {
			$total += $tmp{$_} * $_;
		}
	 	print "[Result] The result for the second task computed on file $_ is $total\n";
	}
}

&solve_for_files(@ARGV);
