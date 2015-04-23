package SQ::Helper::Main;
use Mojo::Base 'Mojolicious::Plugin';

sub register {
    my $c = shift;
    my($app) = @_;

    # Email address decorated with name if given
    $app->helper(
        'sq.email_decorated' => sub {
            my $c = shift;
            my($email, $name) = @_;

            $email = " <$email>" if $name;
            return ($name // '') . $email;
        }
    );

    # Email address to send email to
    $app->helper(
        'sq.email_to' => sub {
            my $c = shift;
            my($email, $name) = @_;

            $name ||= '';
            if($c->app->mode eq 'development') {
                $name .= " (Was to: $email)";
                $email = $c->app->config->{test}->{email};
            }
            return $c->sq->email_decorated($email, $name);
        }
    );

    # Trimmed CGI parameter
    $app->helper(
        'sq.trimmed_param' => sub {
            my $c = shift;
            my($param) = @_;

            my $value = $c->param($param);
            $value =~ s{^\s+|\s+$}{}g if defined $value;
            return $value;
        }
    );

}

1;

