package SQ::Controller::Main;
use Mojo::Base 'Mojolicious::Controller';
use Mojo::Util;


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
sub contact {
    my $c = shift;

    my $validation = $c->validation;
    $validation->required('email')->like(qr{^.+@.+[.].+});
    $validation->required('message');
    return $c->render(template => 'main/welcome') if $validation->has_error;

    my $message = Mojo::Util::xml_escape($c->param('message'));
    $message =~ s{\n}{<br \\>\n}g;
    $c->mail(
        from        => $c->sq->email_decorated($c->sq->trimmed_param('email'), $c->sq->trimmed_param('name')),
        to          => $c->sq->email_to($c->app->config->{email_addresses}->{contact_form}),
        template    => 'email/contact_form',
        info        => {message => $message},
    );
    $c->flash(msg => 'message-sent');
    $c->redirect_to('/');
}

1;

