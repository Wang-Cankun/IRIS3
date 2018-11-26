#!/usr/bin/perl
if(@ARGV!=3){
        die("Usage: send_finish_mail.pl <job_id> <to_email> <message_file>\n")
}


use Mail::Sendmail qw(sendmail %mailcfg);

my $job_id=shift;
my $email=shift;
my $message_file=shift;
open FILE,"$message_file" or die "Can not open file: $message_file\n";
my @lines=<FILE>;
close FILE;
my $message=join("",@lines);

my %mail = ( To      => $email,
			 Bcc     => 'flykun0620@gmail.com',
             From    => 'IRIS3 <no-reply@bmbl.sdstate.edu>',
             Subject => "Information from Job $job_id on IRIS3",'Content-Type' => 'text/html',
             Message => $message
           );
sendmail(%mail) or die $Mail::Sendmail::error;