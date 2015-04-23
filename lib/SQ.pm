package SQ;
use Mojo::Base 'Mojolicious';

use SQ::Helper::Main;

sub startup {
    my $self = shift;

    warn __PACKAGE__ . " Starting\n" if $self->mode eq 'development';

    my $config = $self->plugin('Config');
    $self->plugin('SQ::Helper::Main');
    $self->plugin(mail => $config->{mail});

    my $r = $self->routes;

    $r->get('/')->to('main#welcome');
    $r->post('/contact')->to('main#contact')->name('sq.contact');
}

1;
