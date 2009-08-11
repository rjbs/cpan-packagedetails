#!/usr/bin/perl
use strict;
use warnings;

use Test::More 'no_plan';

use File::Spec::Functions;

my $class  = 'CPAN::PackageDetails';
my $method = 'check_file';

use_ok( $class );
can_ok( $class, $method );

my @files =  map { [ $_, 1 ] } glob( catfile( qw( corpus good *.gz ) ) );
push @files, map { [ $_, 0 ] } glob( catfile( qw( corpus bad *.gz )  ) );

diag( "Going to test " . @files . " files " );

my $cpan_path = catfile( qw(corpus cpan) );

foreach my $pair ( @files )
	{
	my( $file, $expected ) = @$pair;
	
	my $result = eval { $class->$method( $file, $cpan_path ) };
	my $at = $@;
	# diag( "$file had an error: [$at]" ) if $at;
	
	is( !! $result, !! $expected, 
		$expected ?
			"The good 02packages.details.gz [$file] checks out!"
				:
			"The bad 02packages.details.gz [$file] doesn't check out!"
		);
		
	is( ! length $at, !! $expected,
		$expected ?
			"The good 02packages.details.gz [$file] doesn't die!"
				:
			"The bad 02packages.details.gz [$file] dies!"
		);
			
	}
	
