use strict;
use warnings;
use Lingua::JA::Expand::DataSource::GoogleWebSearch;
use Test::More tests => 1;


my $datasource = Lingua::JA::Expand::DataSource::GoogleWebSearch->new();

isa_ok($datasource, 'Lingua::JA::Expand::DataSource::GoogleWebSearch');


