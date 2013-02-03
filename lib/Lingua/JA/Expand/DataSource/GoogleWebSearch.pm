package Lingua::JA::Expand::DataSource::GoogleWebSearch;
use strict;
use warnings;
use base qw(Lingua::JA::Expand::DataSource);
use Carp;
use Web::Scraper::LibXML;
use URI;


sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);
    $self->_prepare;
    return $self;
}

sub extract_text {
    my $self     = shift;
    my $word_ref = shift;
    my $result = $self->raw_data($word_ref);

    if (my $error_msg = $result->{Error}->{Messagse}){
        carp("$error_msg");
    } 

    my $text;
    if (ref $result eq 'HASH') {
        my $all = @{ $result->{title} };
        for my $cnt (0 .. ($all -1)) { 
            $text .= $result->{title}->[$cnt] if $result->{title}->[$cnt];
            $text .= ' ';
            $text .= $result->{st}->[$cnt] if $result->{st}->[$cnt];
            $text .= ' ';
        }
    }

    return \$text;
}

sub raw_data {
    my $self = shift;
    if ( @_ > 0 ) {
        my $word_ref = shift;
        $$word_ref =~ s/([^\w ])/'%'.unpack('H2', $1)/eg;
        $$word_ref =~ tr/ /+/;
        my $url = $self->{url} . $$word_ref;
        my $uri = URI->new($url);
        my $scraper = scraper {
            process 'h3.r', 'title[]' => 'TEXT';
            process '.st',  'st[]' => 'TEXT';
        };
        my $result;
        eval{ $result = $scraper->scrape($uri); };
        return { Error => { Message => $@} } if $@;

        return $result;
    }
}

sub _prepare {
    my $self                 = shift;
    $self->{url}
            = 'http://www.google.co.jp/search?'
            . 'num=20&as_qdr=all&as_occt=any&lr=lang_ja&safe=off'
            . '&q=';
}

1;

__END__

=head1 NAME

Lingua::JA::Expand::DataSource::GoogleWebSearch - DataSource depend on Google Web Search

=head1 SYNOPSIS

  use Lingua::JA::Expand::DataSource::GoogleWebSearch;

  my %conf = (
  );
  my $datasource = Lingua::JA::Expand::DataSource::GoogleWebSearch->new(\%conf);
  my $text_ref   = $datasource->extract_text(\$word);

=head1 DESCRIPTION

Lingua::JA::Expand::DataSource::GoogleWebSearch is DataSource depend on Google Web Search

=head1 METHODS

=head2 new()

=head2 extract_text()

=head2 raw_data()

=head1 AUTHOR

Munenori Sugimura E<lt>clicktx@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

L<Lingua::JA::Expand> L<Web::Scraper>

=cut

