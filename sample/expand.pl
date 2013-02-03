#!/usr/bin/env perl

package MyExpand;

use base qw(Lingua::JA::Expand);

# Method overriding.
sub datasource {
    my $self = shift;
    $self->_class_loader( datasource => 'DataSource::GoogleWebSearch' );
}


package Main;

use strict;
use warnings;
use lib '../lib';
# use MyExpand;

loop();

sub loop {
    print "Input keyword: ";
    my $keyword = <STDIN>;
    # my $exp     = Lingua::JA::Expand->new(%conf);
    my $exp     = MyExpand->new();
    my $result  = $exp->expand($keyword);
	exit if !$result;
    print "-" x 100, "\n";
    for ( sort { $result->{$b} <=> $result->{$a} } keys %$result ) {
        print sprintf( "%0.5f", $result->{$_} ), "\t", $_, "\n";
    }
    print "\n";
    loop();
}