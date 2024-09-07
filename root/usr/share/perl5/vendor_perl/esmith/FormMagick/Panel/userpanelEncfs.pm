#!/usr/bin/perl -w 

package    esmith::FormMagick::Panel::userpanelEncfs;

use strict;

use esmith::FormMagick;
use esmith::AccountsDB;
use esmith::ConfigDB;
use esmith::cgi;
use esmith::util;
use File::Basename;
use Exporter;
use Carp;

our @ISA = qw(esmith::FormMagick Exporter);

our @EXPORT = qw(
    print_share_table
    mount_encfs
    umount_encfs
);

our $accountdb = esmith::AccountsDB->open();
our $user = $ENV{'REMOTE_USER'};
$user = $1 if ($user =~ /^([a-z][\-a-z0-9]*)$/);
our @usergroups = $accountdb->user_group_list($user);

*wherenext = \&CGI::FormMagick::wherenext;

sub new 
{
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self = esmith::FormMagick::new($class);
    $self->{calling_package} = (caller)[0];

    return $self;
}

sub print_share_table {
    my $self = shift;
    my $q = $self->{cgi};
    my @shares = $accountdb->get_all_by_prop(type => 'share');
    my @encfs = ();

    foreach (@shares){
        my @sharegroups = split(/[,;]/, ($_->prop('WriteGroups') || '') .','. ($_->prop('ReadGroups') || ''));
        my @shareusers = split(/[,;]/, ($_->prop('WriteUsers') || '') .','. ($_->prop('ReadUsers') || ''));
        @sharegroups = keys %{{ map { $_ => 1 } @sharegroups }};

        my %count = ();
        my @intersection = ();
        foreach my $element (@sharegroups, @usergroups) { $count{$element}++ }
        foreach my $element (keys %count) {
            push @intersection, $element if ($count{$element} > 1);
        }

        # Only display the share in the list if encryption is enabled
        # and the user has at least read access
        if ((($_->prop('Encryption') || 'disabled') eq 'enabled') &&
            ((scalar @intersection > 0 ) || (grep { $_ eq $user} @shareusers) || ($user eq 'admin'))){
            push @encfs, $_;
        }
    }
    unless ( scalar @encfs )
    {
        print $q->Tr($q->td($self->localise('NO_ENCRYPTED_SHARE')));
        return "";
    }

    print $q->start_table({-CLASS => "sme-border"}),"\n";
    print $q->Tr (
                  esmith::cgi::genSmallCell($q, $self->localise('NAME'),"header"),
                  esmith::cgi::genSmallCell($q, $self->localise('DESCRIPTION'),"header"),
                  esmith::cgi::genSmallCell($q, $self->localise('STATUS'),"header"),
                  esmith::cgi::genSmallCell($q, $self->localise('ACTION'),"header", 3)
          ),"\n";

    my $scriptname = basename($0);

    foreach my $i (@encfs)
    {
        my $sharename = $i->key();
        my $sharedesc = $i->prop('Name');

        my $mountstatus = `/bin/mount | /bin/grep /home/e-smith/files/shares/$sharename/ | grep -c fuse`;
        chomp($mountstatus);
        my $sharestatus = ($mountstatus eq '1') ? $self->localise('MOUNTED') : $self->localise('NOT_MOUNTED');

        my $href = "$scriptname?page=;page_stack=;wherenext=";

        my $actionMount =  $q->a({href => "${href}Mount&name=$sharename"},$self->localise('MOUNT'))
                      . '&nbsp;';

        my $actionUmount .= $q->a({href => "${href}Umount&name=$sharename"}, $self->localise('UMOUNT'))
                  . '&nbsp';

        my $action = ($mountstatus eq '1') ? $actionUmount : $actionMount;

        print $q->Tr (
            esmith::cgi::genSmallCell($q, $sharename,"normal"),
            esmith::cgi::genSmallCell($q, $sharedesc,"normal"),
            esmith::cgi::genSmallCell($q, $sharestatus,"normal"),
            esmith::cgi::genSmallCell($q, $action,"normal")
        );
    }

    print $q->end_table,"\n";

    return "";
}

sub mount_encfs {
    my $fm = shift;
    my $pass = $fm->{cgi}->param('password');
    my $share = $fm->{cgi}->param('name');
    my $rec = $accountdb->get($share);
    my $timeout = $rec->prop('InactivityTimeOut') || '30';
    $timeout = '30' unless ($timeout =~ m/\d+/);
    my $recycle = $rec->prop('RecycleBin') || 'disabled';
    my $recycledir = $rec->prop('RecycleBinDir') || 'Recycle Bin';
    my $source = "/home/e-smith/files/shares/$share/.store";
    my $dest = "/home/e-smith/files/shares/$share/files";
    $pass =~ s/([;<>\*\|`&\$!#\(\)\[\]\{\}:'"])/\\$1/g;
    $pass = $1 if ( $pass =~ /(.*)/ );

    unless ( system("echo $pass | /usr/bin/encfs -i $timeout -S --public -o nonempty,umask=000 $source $dest > /dev/null 2>&1") == 0){
        $fm->error('ERROR_MOUNTING');
        return undef;
    }

    if ( !-e $dest . '/' . $recycledir && $recycle eq 'enabled'){
        unless(mkdir $dest . '/' . $recycledir){
            $fm->error('ERROR_MOUNTING');
        }
    }

    $fm->success('SUCCESS');
}

sub umount_encfs {
    my $fm = shift;
    my $share = $fm->{cgi}->param('name');

    unless ( system("/bin/fusermount -uz /home/e-smith/files/shares/$share/files > /dev/null 2>&1") == 0){
        $fm->error('ERROR_UMOUNTING');
        return undef;
    }

    $fm->success('SUCCESS');
}

1;

