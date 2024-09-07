package SrvMngr::Controller::Shared_folders;

#----------------------------------------------------------------------
# heading     : Collaboration
# description : Shared Folders
# navigation  : 2000 2600
#
# name   : shared_foldersget, 	method : get,   		url : /shared_folders,     	ctlact : Shared_folders#main
# name   : shared_folderss,		method : post,   		url : /shared_folders,		ctlact : Shared_folders#do_save
# name   : shared_foldersc,		method : get,  			url : /shared_foldersc,		ctlact : Shared_folders#do_create_modify
# name   : shared_foldersc,		method : post,  		url : /shared_foldersc,		ctlact : Shared_folders#do_create_modify
# name   : shared_foldersd, 	method : get,  			url : /shared_foldersd,		ctlact : Shared_folders#do_delete
# name   : shared_foldersp, 	method : get,   		url : /shared_foldersp,		ctlact : Shared_folders#do_permissions
# name   : shared_folderse, 	method : get,   		url : /shared_folderse,		ctlact : Shared_folders#do_encrypt
# routes : end
#
# Documentation : https://wiki.contribs.org/SharedFolders
#----------------------------------------------------------------------

use strict;
use warnings;
use Mojo::Base 'Mojolicious::Controller';

use Locale::gettext;
use SrvMngr::I18N;
use SrvMngr qw(theme_list init_session);

use Data::Dumper;
use esmith::util;
use esmith::HostsDB;
use esmith::AccountsDB;

our $db  = esmith::ConfigDB->open();
our $adb = esmith::AccountsDB->open();

our $user = 'admin';
#$ENV{'REMOTE_USER'};
$user = $1 if ( $user =~ /^([a-z][\-a-z0-9]*)$/ );
our @usergroups = $adb->user_group_list($user);

use constant FALSE => 0;
use constant TRUE  => 1;

my %shf_datas = ();

sub main {
    #
    # Main Panel
    #
    my $c = shift;
    $c->app->log->info( $c->log_req );
    $shf_datas{first} = 'shf_FIRSTPAGE_DESC';
    do_display($c);
}

sub do_display {
    my $c                = shift;
    my $title            = $c->l('shf_FORM_TITLE');
    my $modul            = '';
    my @shares           = get_all_shares($c);
    my @encryptedfolders = get_all_encrypted_shares($c);
    $shf_datas{trt} = 'LIST';

    $c->stash(
        title            => $title,
        modul            => $modul,
        shf_datas        => \%shf_datas,
        sharedfolders    => \@shares,
        encryptedfolders => \@encryptedfolders,
        empty            => ( scalar @shares == 0 ),
        emptye           => ( scalar @encryptedfolders == 0 )
    );

    $c->render( template => 'shared_folders' );
}

sub get_all_shares {
    my $c        = shift;
    my @sharesdb = $adb->get_all_by_prop( type => 'share' );
    my @shares   = ();
    foreach my $sharerec (@sharesdb) {
        next if ( ( $sharerec->prop('Hide') || 'no' ) eq 'yes' );
        my $removable = $sharerec->prop('Removable') || 'yes';
        my %row       = (
            "Name"        => $sharerec->key,
            "Description" => $sharerec->prop("Name"),
            "Removeable"  => $removable
        );
        push( @shares, \%row );
    }
    return @shares;
}

sub get_all_encrypted_shares {

    my $c      = shift;
    my @shares = $adb->get_all_by_prop( type => 'share' );
    my @encfs  = ();
    foreach (@shares) {
        my @sharegroups = split( /[,;]/,
                ( $_->prop('WriteGroups') || '' ) . ','
              . ( $_->prop('ReadGroups')  || '' ) );
        my @shareusers = split( /[,;]/,
                ( $_->prop('WriteUsers') || '' ) . ','
              . ( $_->prop('ReadUsers')  || '' ) );
        @sharegroups = keys %{ { map { $_ => 1 } @sharegroups } };

        my %count        = ();
        my @intersection = ();
        foreach my $element ( @sharegroups, @usergroups ) { $count{$element}++ }
        foreach my $element ( keys %count ) {
            push @intersection, $element if ( $count{$element} > 1 );
        }

        # Only display the share in the list if encryption is enabled
        # and the user has at least read access
        if (
            ( ( $_->prop('Encryption') || 'disabled' ) eq 'enabled' )
            && (   ( scalar @intersection > 0 )
                || ( grep { $_ eq $user } @shareusers )
                || ( $user eq 'admin' ) )
          )
        {
            push @encfs, $_;
        }
    }
    unless ( scalar @encfs > 0 ) {
        return ();
    }

    my @encrypted_shares = ();
    foreach my $i (@encfs) {
        my $sharename = $i->key();
        my $sharedesc = $i->prop('Name');

        my $mountstatus =
`/bin/mount | /bin/grep /home/e-smith/files/shares/$sharename/ | grep -c fuse`;
        chomp($mountstatus);
        my $sharestatus =
          ( $mountstatus eq '1' )
          ? $c->l('shf_ENCRYPT_MOUNTED')
          : $c->l('shf_ENCRYPT_NOT_MOUNTED');

        my $actionMount = "shf_ENCRYPT_MOUNT"
          ; #$q->a({href => "${href}Mount&name=$sharename"},$self->localise('MOUNT')). '&nbsp;';

        my $actionUmount = 'shf_ENCRYPT_UNMOUNT'
          ; #$q->a({href => "${href}Umount&name=$sharename"}, $self->localise('UMOUNT')). '&nbsp';

        my $action = ( $mountstatus eq '1' ) ? $actionUmount : $actionMount;

        my %row = (
            "Name"        => $sharename,
            "Description" => $sharedesc,
            "Status"      => $sharestatus,
            "Action"      => $action
        );
        push( @encrypted_shares, \%row );
    }
    return @encrypted_shares;
}

sub do_encrypt {
    #
    # Enable/disable encrypt share clicked
    #
    my $c = shift;
    $c->app->log->info( $c->log_req );
    my $title = $c->l('shf_main_title');
    my $modul = '';
    my $mode  = $c->param("mode");

    #etc....

    do_display($c);    #If no errors
}

sub do_save {
    #
    # Save pressed
    #
    my $c = shift;
    $c->app->log->info( $c->log_req );

    my $title = $c->l('shf_main_title');
    my $modul = '';
    my $mode  = $c->param("mode");

    #etc....
    if ( $mode = "DEL" ) {
        my $name = $c->param("name");
        my $msg  = remove_share( $c, $name );
        if ( $msg eq "ok" ) {
            $shf_datas{success} = "shf_SUCCESSFULLY_DELETED_SHARE";
        }
        else {
            $shf_datas{error} = $msg;
        }
    }
    do_display($c);

}

sub do_delete {
    #
    # Delete/Remove clicked
    #
    my $c = shift;
    $c->app->log->info( $c->log_req );

    my $title = $c->l('shf_REMOVE_TITLE');
    my $modul = '';

    #etc.....
    $shf_datas{trt} = 'DEL';
    $c->stash(
        title     => $title,
        modul     => $modul,
        shf_datas => \%shf_datas,
    );
    $c->render( template => 'shared_folders' );
}

sub do_create_modify {
    #
    # Delete/Remove clicked
    #
    my $c = shift;
    $c->app->log->info( $c->log_req );

    my $title = $c->l('shf_create_modify_title');
    my $modul = '';
    my $empty;

    #Selection options
    $shf_datas{disable_enable} =
      [ [ $c->l(''), 'disabled' ], [ $c->l(''), 'enabled' ] ];
    $shf_datas{recyclebin} = [
        [ $c->l('shf_DISABLED'),           'disabled' ],
        [ $c->l('shf_DONT_KEEP_VERSIONS'), 'enabled' ],
        [ $c->l('shf_KEEP_VERSIONS'),      'keep-versions' ]
    ];
    $shf_datas{SMBaccess} = [
        [ $c->l('shf_ENABLED_BROWSEABLE'),     'browseable' ],
        [ $c->l('shf_ENABLED_NON_BROWSEABLE'), 'non-browseable' ],
        [ 'No access',                         'none' ]
    ];
    $shf_datas{webaccess} = [
        [ $c->l('shf_ENTIRE_INTERNET_NO_PASSWORD'),     'global' ],
        [ $c->l('shf_ENTIRE_INTERNET_PASSWORD'),        'global-pw' ],
        [ $c->l('shf_ENTIRE_INTERNET_PASSWORD_REMOTE'), 'global-pw-remote' ],
        [ $c->l('shf_LOCAL_NETWORK_NO_PASSWORD'),       'local' ],
        [ $c->l('shf_LOCAL_NETWORK_PASSWORD'),          'local-pw' ],
        [ $c->l('shf_NO_ACCESS'),                       'None' ]
    ];
    $shf_datas{retention} = [
        [ $c->l('shf_UNLIMITED'),  'unlimited' ],
        [ $c->l('shf_ONE_WEEK'),   7 ],
        [ $c->l('shf_ONE_MONTH'),  30 ],
        [ $c->l('shf_SIX_MONTHS'), 180 ],
        [ $c->l('shf_ONE_YEAR'),   365 ]
    ];
    my $name = $c->param("name") || '';
    my @params = ();
    if ($name ne ''){
		my $namedb = $adb->get($name);
		my @params = ('SMBaccess' => $namedb->get_value("SMBaccess") || '',
				 );
	}
				 
	$shf_datas{param_details} = \@params;

    #etc.....

    $shf_datas{trt} = 'CR_MOD';
    $c->stash(
        title     => $title,
        modul     => $modul,
        shf_datas => \%shf_datas,
        empty     => $empty
    );
    $c->render( template => 'shared_folders' );
}

sub do_permisssions {
    #
    # Delete/Remove clicked
    #
    my $c = shift;
    $c->app->log->info( $c->log_req );

    my $title = $c->l('shf_permissions_title');
    my $modul = '';

    #etc.....

    $shf_datas{trt} = 'PERM';
    $c->stash(
        title     => $title,
        modul     => $modul,
        shf_datas => \%shf_datas,
    );
    $c->render( template => 'shared_folders' );
}

# Remove a share
sub remove_share {
    my $c    = shift;
    my $name = shift;
    my $acct = $adb->get($name);

    #return $self->error('CANCELED','First') if ($c->param('cancel'));
    return 'shf_CANT_FIND_SHARE'
      unless ( $acct && $acct->prop('type') eq 'share' );

    # Untaint $name before use in system()
    $name =~ /(.+)/;
    $name = $1;
    my $encryption = $acct->prop('Encryption') || 'disabled';
    my $mountstatus =
      `/bin/mount | grep /home/e-smith/files/shares/$name/ | grep -c fuse`;
    chomp($mountstatus);

    if ( ( $encryption eq 'enabled' ) && ( $mountstatus eq '1' ) ) {
        return "shf_ERROR_ENCRYPTED_ENABLED";
    }
    $acct->set_prop( 'type', 'share-deleted' );
    if ( system( "/sbin/e-smith/signal-event", "share-delete", $name ) == 0 ) {
        $acct->delete();
    }
    else {
        return "shf_ERROR_WHILE_DELETING_SHARE";
    }
    return "ok";
}

1;
