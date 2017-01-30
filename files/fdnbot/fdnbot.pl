#!/usr/bin/perl

package Bot;
use Mail::Sendmail;
use MIME::Base64;
use MIME::Words qw(encode_mimewords);
use base qw(Bot::BasicBot);
use warnings;
use strict;
use utf8;

if(@ARGV && ! -w "$ARGV[0]" || !@ARGV) {
	if(@ARGV) {
		print "ERREUR: $ARGV[0] est inexistant ou non-inscriptible.\n";
	} else {
		print "USAGE: $0 fichier-a-ecrire\n";
	}

	exit 1;
}

my $nick = "fdnAlertBot";
my $server = "irc.geeknode.org";
my $chan = "#fdn";
my $flag = "[ALERT]";
my $url = "https://fdn.ldn-fai.net";
my $git = "git clone https://code.ffdn.org/ldn/puppet.git";
my $subscribe = "https://listes.ldn-fai.net/cgi-bin/mailman/listinfo/fdn";

my $mail_support = 'support@fdn.fr';
my $mail_liste = 'fdn@listes.ldn-fai.net';
my $mail_from = 'fdnAlertBot <fdnAlertBot@ldn-fai.net>';
my $mail_subject = "[ALERTE FDN]";

my $isacc = 0;
my $file = $ARGV[0];
my $bot;

sub said {
	my $self = shift;
	my $message = shift;

	return undef unless $message->{"address"};

	if($message->{"address"} eq $nick || $message->{"address"} eq "msg") {
		if($message->{"body"} =~ m/\br(?:e|é)ponse\b/i) {
			$self->reply($message, "42.");

		} elsif($message->{"body"} =~ m/\b(?:drapeau|flag|tag)\b/i) {
			$self->reply($message, $flag);

		} elsif($message->{"body"} =~ m/\b(?:url|adresse)\b/i) {
			$self->reply($message, $url);

		} elsif($message->{"body"} =~ m/\b(?:git|svn|source)\b/i) {
			$self->reply($message, $git);

		} elsif($message->{"body"} =~ m/\bliste\b/i) {
			$self->reply($message, "$mail_liste ($subscribe)");

		} elsif($message->{"body"} =~ m/\bmerci\b/i) {
			$self->reply($message, "De rien.");

		} else {
			$self->reply($message, "Pour signaler un problème, ajouter $flag à la suite "
				."du /topic, suivi d'un court descriptif. Ce dernier sera reporté sur "
				."<$url>, qui sera mis à jour chaque fois qu'il changera. Retirer $flag "
				."du /topic vide la page, ce qui signale la fin du problème.");
		}
	}
}

sub topic {
	my $self = shift;
	my $args = shift;

	my %mail = (
		From => $mail_from,
		To => $mail_liste,
		Cc => $mail_support
	);

	if($args->{"topic"}) {
		if($args->{"topic"} =~ /\Q$flag\E\s*(.+)$/i) {

			my $msg = $1;
			$mail{"Message"} = $msg;
			utf8::decode($msg);

			open(OUT, ">$file");
			binmode(OUT, ":utf8");
			print OUT "$msg";
			close(OUT);

			if($isacc) {
				$mail{"Subject"} = "$mail_subject Mise à jour de l'intitulé du problème";

				$bot->emote(
					channel => $chan,
					body => "a bien actualisé le problème sur $url (et prévenu le support + $mail_liste)"
				);

			} else {
				$isacc = 1;
				$mail{"Subject"} = "$mail_subject Nouveau problème déclaré";

				$bot->emote(
					channel => $chan,
					body => "a bien reporté le problème sur $url (et prévenu le support + $mail_liste)"
				);
			}

			sendemail(\%mail) or die $Mail::Sendmail::error;

		} elsif($isacc) {
			$isacc = 0;

			$mail{"Subject"} = "$mail_subject Problème résolu";
			$mail{"Message"} = "Fin de l'alerte.";

			open(OUT, ">$file");
			print OUT "";
			close(OUT);

			$bot->emote(
				channel => $chan,
				body => "a bien pris en compte la fin du problème sur $url (et prévenu le support + $mail_liste)"
			);

			sendemail(\%mail) or die $Mail::Sendmail::error;
		}
	}
}

sub sendemail {
	my $mail = shift;
	my %mail = %{$mail};

	utf8::encode($mail{"Subject"});

	$mail{"Subject"} = encode_mimewords($mail{"Subject"}, Charset => "utf-8", Encoding => "Q");
	$mail{"Message"} = encode_base64($mail{"Message"});
	$mail{"Content-Type"} = 'text/plain; charset="utf-8"';
	$mail{"Content-Transfer-Encoding"} = "base64";

	sendmail(%mail) or die $Mail::Sendmail::error;
}

$bot = Bot->new(
	server => $server,
	port => "6667",
	channels => [$chan],
	nick => $nick,
	alt_nicks => ["${nick}_"],
	username => $nick,
	name => $url
);

$bot->run();

exit 0;
