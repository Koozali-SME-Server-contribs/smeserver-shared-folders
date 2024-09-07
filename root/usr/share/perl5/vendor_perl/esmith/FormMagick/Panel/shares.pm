#!/usr/bin/perl -w 

#
# $Id: shares.pm,v 1.8 2005/09/06 05:49:52 apc Exp $
#

package    esmith::FormMagick::Panel::shares;

use strict;

use esmith::FormMagick;
use esmith::AccountsDB;
use esmith::ConfigDB;
use esmith::DomainsDB;
use esmith::cgi;
use esmith::util;
use File::Path;
use File::Basename;
use Exporter;
use Carp;

our @ISA = qw(esmith::FormMagick Exporter);

our @EXPORT = qw(
    print_share_table
    print_share_name_field
    print_encryption_fields
    print_pydio_fields
    acl_list
    smbAccess_list
    httpAccess_list
    max_share_name_length
    handle_shares
    remove_share
    print_save_or_add_button
    wherenext
    print_custom_button
    print_section_bar
);

our $VERSION = sprintf '%d.%03d', q$Revision: 1.8 $ =~ /: (\d+).(\d+)/;

our $a = esmith::AccountsDB->open();
our $c = esmith::ConfigDB->open();

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
    my $name        = $self->localise('NAME');
    my $description = $self->localise('DESCRIPTION');
    my $modify      = $self->localise('MODIFY');
    my $perm        = $self->localise('PERMISSIONS');
    my $remove      = $self->localise('REMOVE');
    my $action_h    = $self->localise('ACTION');
    my @shares = $a->get_all_by_prop(type => 'share');

    unless ( scalar @shares ) {
        print $q->Tr($q->td($self->localise('NO_SHARES')));
        return "";
    }

    print $q->start_table({-CLASS => "sme-border"}),"\n";
    print $q->Tr (
                  esmith::cgi::genSmallCell($q, $name,"header"),
                  esmith::cgi::genSmallCell($q, $description,"header"),
                  esmith::cgi::genSmallCell($q, $action_h,"header", 3)
          ),"\n";

    my $scriptname = basename($0);

    foreach my $share (@shares) {
        my $sharename = $share->key();
        my $sharedesc = $share->prop('Name');
        next if (($share->prop('Hide') || 'no') eq 'yes');
        my $removable = $share->prop('Removable') || 'yes';

        my $href = "shares?page=;page_stack=;wherenext=";

        my $actionModify =  $q->a({href => "${href}CreateModify&action=modify&name=$sharename"},$modify)
                      . '&nbsp;';

        my $actionPerm =  $q->a({href => "${href}Permissions&name=$sharename"},$perm)
                      . '&nbsp;';

        my $actionRemove .= ($removable ne 'no') ? $q->a({href => "${href}Remove&name=$sharename&description=$sharedesc"}, $remove) 
                  . '&nbsp' : '';

        print $q->Tr (
            esmith::cgi::genSmallCell($q, $sharename,"normal"),
            esmith::cgi::genSmallCell($q, $sharedesc,"normal"),
            esmith::cgi::genSmallCell($q, $actionPerm,"normal"),
            esmith::cgi::genSmallCell($q, $actionModify,"normal"),
            esmith::cgi::genSmallCell($q, $actionRemove,"normal")
        );
    }

    print $q->end_table,"\n";

    return "";
}


sub print_custom_button{
    my ($self,$desc,$url) = @_;
    my $q = $self->{cgi};
    $url = "shares?page=0&page_stack=&Next=Next&wherenext=" . $url;
        
    print "  <tr>\n    <td colspan='2'>\n";
    print $q->p($q->a({href => $url, -class => "button-like"},
                      $self->localise($desc)));
    print qq(</tr>\n);
    return undef;
}

sub print_share_to_remove{
    my $self = shift;  
    my $q = $self->{cgi};
    my $sharename = $q->param('name');
    my $desc = $q->param('description');

    print $q->Tr(
            $q->td(
            { -class => 'sme-noborders-label' },
            $self->localise('NAME')
            ),
        $q->td( { -class => 'sme-noborders-content' }, $sharename )
      ), "\n";
    print $q->Tr(
        $q->td(
            { -class => 'sme-noborders-label' },
            $self->localise('DESCRIPTION')
        ), 
        $q->td( { -class => 'sme-noborders-content' }, $desc )
      ), "\n";

    print $q->table(
        { -width => '100%' },
        $q->Tr(
            $q->th(
                { -class => 'sme-layout' },
                $q->submit(
                    -name  => 'cancel',
                    -value => $self->localise('CANCEL')
                ),
                ' ',
                $q->submit(
                    -name  => 'remove',
                    -value => $self->localise('REMOVE')
                )
            )
        )
    ), "\n";

    # Clear these values to prevent collisions when the page reloads.
    $q->delete("cancel");
    $q->delete("remove");

    return undef;
}


sub print_share_name_field {
    my $self = shift;
    my $q = $self->{cgi};
    my $in = $q->param('name') || '';
    my $action = $q->param('action') || '';
    my $maxLength = $c->get('maxShareNameLength')->value || '12';

    # Set default value

    $q->param(-name=>'encryption',-value=>'disabled');
    $q->param(-name=>'inactivity',-value=>'30');
    $q->param(-name=>'smbaccess',-value=>'browseable');
    $q->param(-name=>'recyclebin',-value=>'disabled');
    $q->param(-name=>'retention',-value=>'unlimited');
    $q->param(-name=>'httpaccess',-value=>'none');
    $q->param(-name=>'webdav',-value=>'disabled');
    $q->param(-name=>'requireSSL',-value=>'disabled');
    $q->param(-name=>'indexes',-value=>'disabled');
    $q->param(-name=>'dynamic',-value=>'disabled');

    print qq(<tr><td colspan="2">) . $self->localise('NAME_FIELD_DESC',
        {maxLength => $maxLength }) . qq(</td></tr>);
    print qq(<tr><td class="sme-noborders-label">) . 
        $self->localise('NAME_LABEL') . qq(</td>\n);
    if ($action eq 'modify' and $in) {
        print qq(
            <td class="sme-noborders-content">$in 
            <input type="hidden" name="name" value="$in">
            <input type="hidden" name="action" value="modify">
            </td>
        );

        # Read the values for each field from the accounts db and store
        # them in the cgi object so our form will have the correct 
        # info displayed.
        my $rec = $a->get($in);
        if ($rec)
        {
            $q->param(-name=>'description',-value=>
                $rec->prop('Name'));
            $q->param(-name=>'encryption',-value=>
                ($rec->prop('Encryption') || 'disabled'));
            $q->param(-name=>'inactivity',-value=>
                ($rec->prop('InactivityTimeOut') || '30'));
            $q->param(-name=>'smbaccess',-value=>
                ($rec->prop('smbAccess') || 'enabled'));
	    $q->param(-name=>'recyclebin',-value=>
                ($rec->prop('RecycleBin') || 'disabled'));
	    $q->param(-name=>'retention',-value=>
                ($rec->prop('RecycleBinRetention') || 'unlimited'));
	    $q->param(-name=>'httpaccess',-value=>
                ($rec->prop('httpAccess') || 'none'));
	    $q->param(-name=>'webdav',-value=>
                ($rec->prop('WebDav') || 'disabled'));
	    $q->param(-name=>'requireSSL',-value=>
                ($rec->prop('RequireSSL') || 'enabled'));
	    $q->param(-name=>'indexes',-value=>
                ($rec->prop('Indexes') || 'enabled'));
	    $q->param(-name=>'dynamic',-value=>
                ($rec->prop('DynamicContent') || 'disabled'));
        }
    }
    else {
        print qq(
            <td><input type="text" name="name" value="$in">
            <input type="hidden" name="action" value="create">
            </td>
        );
    }

    print qq(</tr>\n);
    return undef;

}

# If EncFS is available, print encryptions options
sub print_encryption_fields {
    my $self = shift;
    my $q = $self->{cgi};

    return undef unless(system('rpm -q fuse-encfs 2>&1 > /dev/null') == 0);

    my $encryption = $q->param('encryption') || 'disabled';
    my $action = $q->param('action') || '';

    my $sharename = $q->param('name') || '';

    return undef if ($action eq 'modify' && $encryption ne 'enabled');

    my $inactivity = (($sharename ne '') && ($a->get($sharename))) ?
        ($a->get($sharename)->prop('InactivityTimeOut') || '30'):'30';

    print_section_bar();

    print qq(<tr><td colspan="2">) . $self->localise('DESC_ENCRYPTION') . qq(</td></tr>);
    print qq(<tr><td class="sme-noborders-label">) .
        $self->localise('LABEL_ENCRYPTION') . qq(</td>\n);

    if ($action eq 'modify') {
        print qq(
            <td class="sme-noborders-content">) . $self->localise(uc($encryption)) . qq(
            <input type="hidden" name="encryption" value="$encryption">
            </td>
        );
    }
    else {
        print qq(
            <td class="sme-noborders-content"><SELECT NAME="encryption" TYPE="select"> 
              <OPTION VALUE="disabled">) . $self->localise('DISABLED') .
              qq(<OPTION VALUE="enabled">) . $self->localise('ENABLED') .
            qq(</SELECT></td> 
        );
        print qq(<tr><td colspan="2">) . $self->localise('DESC_PASSWORD') . qq(</td></tr>);
        print qq(<tr><td class="sme-noborders-label">) .
        $self->localise('LABEL_PASSWORD') . qq(</td>\n);
        print qq(
            <td><input type="password" name="password" value="">
            </td>
        );
        print qq(<tr><td class="sme-noborders-label">) .
        $self->localise('LABEL_PASSWORD2') . qq(</td>\n);
        print qq(
            <td><input type="password" name="password2" value="">
            </td>
        );
    }

    print qq(<tr><td colspan="2">) . $self->localise('DESC_INACTIVITY') . qq(</td></tr>);
    print qq(<tr><td class="sme-noborders-label">) .
        $self->localise('INACTIVITY') . qq(</td>\n);
    print qq(
        <td><input type="text" name="inactivity" value="$inactivity">
        </td>
    );

    print qq(</tr>\n);

    return undef;
}

# If pydio is enabled:
sub print_pydio_fields {
    my $self = shift;
    my $pydio = $c->get('pydio') || return undef;
    if (($pydio->prop('status') || 'disabled') eq 'enabled'){
        print_section_bar();
        my ($enabled,$disabled) = ('','');
        my $sharename = $self->{cgi}->param('name') || '';
        my $share = $a->get($sharename);
        # If share exists and Pydio is enabled
        if ($share){
            if (($share->prop('Pydio') || 'disabled') eq 'enabled'){
                $enabled = ' SELECTED';
            }
        }
        else {
            $disabled = ' SELECTED';
        }
        print qq(<tr><td colspan="2">) . $self->localise('DESC_PYDIO') . qq(</td></tr>);
        print qq(<tr><td class="sme-noborders-label">) .
            $self->localise('LABEL_PYDIO') . qq(</td>\n);
        print qq(
            <td class="sme-noborders-content"><SELECT NAME="pydio" TYPE="select"> 
              <OPTION VALUE="disabled"$disabled>) . $self->localise('DISABLED') .
              qq(<OPTION VALUE="enabled"$enabled>) . $self->localise('ENABLED') .
            qq(</SELECT></td> 
        );
    }
    return undef;
}

# Print a table of users and groups
# having read only or read/write access
sub acl_list () {
    my $self = shift;
    my $q = $self->{cgi};
    my $sharename = $q->param('name');
    my $out = '';

    my $share = $a->get($sharename);
    return $self->error('SHARE_NOT_FOUND') unless ($share);

    my $desc = $share->prop('Name') || $sharename;
    my $WriteGroups = $share->prop('WriteGroups') || '';
    my $ReadGroups = $share->prop('ReadGroups') || '';
    my $WriteUsers = $share->prop('WriteUsers') || '';
    my $ReadUsers = $share->prop('ReadUsers') || '';
    my $manualPerm =  $share->prop('ManualPermissions') || 'no';

    if (($manualPerm eq 'yes') || ($manualPerm eq 'enabled') || ($manualPerm eq 'ntacl')){
        $out .= $self->localise('MANUAL_PERMS');
    }

    my %WriteGroups;
    my %ReadGroups;
    my %WriteUsers;
    my %ReadUsers;
    
    foreach my $group ( split ( /[,;]/, $WriteGroups ) ) {
        $WriteGroups{$group} = 1;
    }
    foreach my $group ( split ( /[,;]/, $ReadGroups ) ) {
        $ReadGroups{$group} = 1;
    }
    foreach my $user ( split ( /[,;]/, $WriteUsers ) ) {
        $WriteUsers{$user} = 1;
    }
    foreach my $user ( split ( /[,;]/, $ReadUsers ) ) {
        $ReadUsers{$user} = 1;
    }

    my @shared = "shared";
    my @groups = sort { $a->key() cmp $b->key() } $a->groups();
    my @users = sort { $a->key() cmp $b->key() } $a->users();

    $out .= qq(<tr><td class="sme-noborders-label">) .
        $self->localise('NAME_LABEL') . qq(</td>\n);
    $out .=  qq(<td class="sme-noborders-content">$sharename</td>);
    $out .= qq(<tr><td class="sme-noborders-label">) .
        $self->localise('DESCRIPTION') . qq(</td>\n);
    $out .=  qq(<td class="sme-noborders-content">$desc</td>);

    $out .= "<tr><td class=\"sme-noborders-label\">" .
        $self->localise('PERMISSIONS') .
        "</td><td>\n".
        $q->start_table({-class => "sme-border"})."\n".
        $q->Tr(
            esmith::cgi::genSmallCell($q, $self->localise('GROUPS'),"header"),
            esmith::cgi::genSmallCell($q, $self->localise('DESCRIPTION'),"header"),
            esmith::cgi::genSmallCell($q, $self->localise('WRITE_PERM'),"header"),
            esmith::cgi::genSmallCell($q, $self->localise('READ_PERM'),"header")
        );

    foreach my $shared (@shared) {
        my $write = "";
        my $read = "";
        my $name = "shared";
        my $desc = "Everyone";
        if ( $WriteGroups{$name} ) {
            $write = "checked";
        }
        if ( $ReadGroups{$name} ) {
            $read = "checked";
        }

        $out .= $q->Tr(
            esmith::cgi::genSmallCell($q, $name, "normal"),
            esmith::cgi::genSmallCell($q, $desc, "normal"),

            esmith::cgi::genSmallCell($q,"<input type=\"checkbox\""
                                       . " name=\"writegroup\""
                                       . " $write value=\"$name\">", "normal"),
            esmith::cgi::genSmallCell($q,"<input type=\"checkbox\""
                                       . " name=\"readgroup\""
                                       . " $read value=\"$name\">", "normal")
            );
    }

    foreach my $group (@groups) {
        my $write = "";
        my $read = "";
        my $name = $group->key();
        my $desc = $group->prop('Description');
        if ( $WriteGroups{$name} ) {
            $write = "checked";
        }
        if ( $ReadGroups{$name} ) {
            $read = "checked";
        }

        $out .= $q->Tr(
            esmith::cgi::genSmallCell($q, $name, "normal"),
            esmith::cgi::genSmallCell($q, $desc, "normal"),

            esmith::cgi::genSmallCell($q,"<input type=\"checkbox\""
                                       . " name=\"writegroup\""
                                       . " $write value=\"$name\">", "normal"),
            esmith::cgi::genSmallCell($q,"<input type=\"checkbox\""
                                       . " name=\"readgroup\""
                                       . " $read value=\"$name\">", "normal")
            );
    }

    $out .= $q->Tr(
            esmith::cgi::genSmallCell($q, $self->localise('USERS'),"header"),
            esmith::cgi::genSmallCell($q, $self->localise('DESCRIPTION'),"header"),
            esmith::cgi::genSmallCell($q, $self->localise('WRITE_PERM'),"header"),
            esmith::cgi::genSmallCell($q, $self->localise('READ_PERM'),"header")
    );

    foreach my $user (@users) {
        my $write = "";
        my $read = "";
        my $name = $user->key();
        my $desc = $user->prop('FirstName') . ' ' . $user->prop('LastName');
        if ( $WriteUsers{$name} ) {
            $write = "checked";
        }
        if ( $ReadUsers{$name} ) {
            $read = "checked";
        }

        $out .= $q->Tr(
            esmith::cgi::genSmallCell($q, $name, "normal"),
            esmith::cgi::genSmallCell($q, $desc, "normal"),

            esmith::cgi::genSmallCell($q,"<input type=\"checkbox\""
                                       . " name=\"writeuser\""
                                       . " $write value=\"$name\">", "normal"),
            esmith::cgi::genSmallCell($q,"<input type=\"checkbox\""
                                       . " name=\"readuser\""
                                       . " $read value=\"$name\">", "normal")
        );
    }

    $out .= "</table></td></tr>\n";
    return $out;
}

# Print a section bar
sub print_section_bar{
        my $self = shift;
        print "  <tr>\n    <td colspan='2'>\n";
        print "<hr class=\"sectionbar\"/>\n";
        return undef;
}


# Returns the hash of public access settings for showing in the smb
# access drop down list.

sub smbAccess_list {
    return {
        'none'              => 'NONE',
        'browseable'        => 'ENABLED_BROWSEABLE',
        'non-browseable'    => 'ENABLED_NON_BROWSEABLE',
    };
}


# Returns the hash of public access settings for showing in the http
# access drop down list.

sub httpAccess_list {
    return {
        'none'             => 'NONE',
        'local'            => 'LOCAL_NETWORK_NO_PASSWORD',
        'local-pw'         => 'LOCAL_NETWORK_PASSWORD',
        'global'           => 'ENTIRE_INTERNET_NO_PASSWORD',
        'global-pw'        => 'ENTIRE_INTERNET_PASSWORD',
        'global-pw-remote' => 'ENTIRE_INTERNET_PASSWORD_REMOTE'
    };
}

# VALIDATION ROUTINES


# Checks the length of a given share name against the maximum set in the
# maxShareNameLength record of the configuration database.  Defaults to a
# maximum length of the maxShareNameLength set in the config db.

sub max_share_name_length {
    my ($self, $data) = @_;
    $c->reload();
    my $max = $c->get('maxShareNameLength')->value || '12';

    if (length($data) <= $max) {
        return "OK";
    }
    else {
        return $self->localise("MAX_SHARE_NAME_LENGTH_ERROR",
            {acctName => $data, 
             maxShareNameLength => $max, 
             maxLength => $max});
    }
}

# Call the create or modify routine

sub handle_shares {
    my $self = shift;
    my $q = $self->{cgi};
    my $action = $q->param("action") || '';

    if ($action eq "create") {
        $self->create_share();
    }
    else {
        $self->modify_share();
    }
}

# Print save or add button

sub print_save_or_add_button {
    my $self = shift;

    my $action = $self->cgi->param("action") || '';
    if ($action eq "modify") {
        $self->print_button("SAVE");
    }
    else {
        $self->print_button("ADD");
    }

}

# Create a new shared folder

sub create_share {
    my $self = shift;
    my $q = $self->{cgi};
    my $name = $q->param('name');
    my $encryption = $q->param('encryption') || 'disabled';
    my $password = $q->param('password');
    my $password2 = $q->param('password2');

    my $msg = $self->validate_name($name);

    unless ($msg eq "OK") {
        return $self->error($msg);
    }

    $msg = $self->max_share_name_length($name);

    unless ($msg eq "OK") {
        return $self->error($msg);
    }

    $msg = $self->conflict_check($name);
    unless ($msg eq "OK") {
        return $self->error($msg);
    }

    $msg = ($encryption eq 'enabled') ? $self->confirm_password($password,$password2) : 'OK';
    unless ($msg eq "OK") {
        return $self->error($msg);
    }

    if (my $acct = $a->new_record($name, {
        Name                => $q->param('description'),
        Encryption          => $encryption,
        InactivityTimeOut   => ($q->param('inactivity') || ''),
        RecycleBin          => $q->param('recyclebin'),
        RecycleBinRetention => $q->param('retention'),
        smbAccess           => $q->param('smbaccess'),
        httpAccess          => $q->param('httpaccess'),
        WebDav              => $q->param('webdav'),
        Pydio               => ($q->param('pydio') || 'disabled'),
        RequireSSL          => $q->param('requireSSL'),
        Indexes             => $q->param('indexes'),
        DynamicContent      => $q->param('dynamic'),
        type                => 'share',
        }) ) {
        # Untaint $name before use in system()
        $name =~ /(.+)/; $name = $1;

        if ($encryption eq 'enabled') {
            my $source = '/home/e-smith/files/shares/' . $name . '/.store';
            my $dest = '/home/e-smith/files/shares/' . $name . '/files';
            File::Path::mkpath ($source);
            mkdir $dest;
            open(DIR, "| /usr/bin/encfs -S --public -o nonempty,umask=000 $source $dest > /dev/null 2>&1");
            print DIR "\n$password";
            close DIR;
            $self->error("ERROR_WITH_ENCRYPTION") unless(
                system("/bin/fusermount -uz $dest") == 0
            );
        }

        if (system ("/sbin/e-smith/signal-event", "share-create", $name) == 0) {
            $self->success("SUCCESSFULLY_CREATED_SHARE", "Permissions");
        }
        else {
            $self->error("ERROR_WHILE_CREATING_SHARE");
        }
    }
    else {
        $self->error('CANT_CREATE_SHARE');
    }
}

# Modify a share.
# This sub shares a lot of code with create share
# It should be merged
sub modify_share {
    my $self = shift;
    my $q = $self->{cgi};
    my $name = $q->param('name');
    my $acct = $a->get($name);

    return $self->error('CANT_FIND_SHARE') unless($acct && $acct->prop('type') eq 'share');

    $acct->merge_props(
        Name                => $q->param('description'),
        InactivityTimeOut   => ($q->param('inactivity') || ''),
        RecycleBin          => $q->param('recyclebin'),
        RecycleBinRetention => $q->param('retention'),
        smbAccess           => $q->param('smbaccess'),
        httpAccess          => $q->param('httpaccess'),
        WebDav              => $q->param('webdav'),
        Pydio               => ($q->param('pydio') || 'disabled'),
        RequireSSL          => $q->param('requireSSL'),
        Indexes	            => $q->param('indexes'),
        DynamicContent      => $q->param('dynamic'),
    );

    # Untaint $name before use in system()
    $name =~ /(.+)/; $name = $1;
    if (system ("/sbin/e-smith/signal-event", "share-modify", $name) == 0) {
        $self->success("SUCCESSFULLY_MODIFIED_SHARE");
    }
    else {
        $self->error("ERROR_WHILE_MODIFYING_SHARE");
    }
    return undef;
}

sub modify_perm {
    my $self = shift;
    my $q = $self->{cgi};
    my $name = $q->param('name');
    my $acct = $a->get($name);

    return $self->error('CANT_FIND_SHARE') unless($acct && $acct->prop('type') eq 'share');

    my $encryption = $acct->prop('Encryption') || 'disabled';

    my $WriteGroups = join(",", $q->param('writegroup'));
    my $WriteUsers = join(",", $q->param('writeuser'));

    my @CleanReadGroups = ();
    my @CleanReadUsers = ();

    # EncFS doesn't expose underlying ACLs
    # So, just remove any read only groups
    # Read Only is not supported with encryption
    if ($encryption ne 'enabled'){
        # No need to have read access if write is already granted
        foreach my $group ($q->param('readgroup')){
            push (@CleanReadGroups, $group) unless (grep { $_ eq $group } $q->param('writegroup'));
        }
        foreach my $user ($q->param('readuser')){
            push (@CleanReadUsers, $user) unless (grep { $_ eq $user } $q->param('writeuser'));
        }
    }
    my $ReadGroups = join(",",@CleanReadGroups);
    my $ReadUsers = join(",",@CleanReadUsers);

    $acct->merge_props(
        WriteGroups => $WriteGroups,
        ReadGroups  => $ReadGroups,
        WriteUsers  => $WriteUsers,
        ReadUsers   => $ReadUsers,
    );

    # Untaint $name before use in system()
    $name =~ /(.+)/; $name = $1;
    if (system ("/sbin/e-smith/signal-event", "share-modify", $name) == 0) {
        $self->success("SUCCESSFULLY_MODIFIED_SHARE");
    }
    else {
        $self->error("ERROR_WHILE_MODIFYING_SHARE");
    }
    return undef;
}

# Remove a share
sub remove_share {
    my $self = shift;
    my $q = $self->{cgi};
    my $name = $q->param('name');
    my $acct = $a->get($name);
    return $self->error('CANCELED','First') if ($q->param('cancel'));
    return $self->error('CANT_FIND_SHARE') unless ($acct && $acct->prop('type') eq 'share');

    # Untaint $name before use in system()
    $name =~ /(.+)/; $name = $1;
    my $encryption = $acct->prop('Encryption') || 'disabled';
    my $mountstatus = `/bin/mount | grep /home/e-smith/files/shares/$name/ | grep -c fuse`;
    chomp($mountstatus);

    if (($encryption eq 'enabled') && ($mountstatus eq '1')){
        $self->error("ERROR_ENCRYPTED_ENABLED");
        return undef;
    }

    $acct->set_prop('type', 'share-deleted');

    if (system ("/sbin/e-smith/signal-event", "share-delete", $name) == 0) {
        $self->success("SUCCESSFULLY_DELETED_SHARE");
        $acct->delete();
    } 
    else {
        $self->error("ERROR_WHILE_DELETING_SHARE");
    }
    return undef;
}

# Check the proposed name for clashes with existing pseudonyms or other 
# accounts of any type.

sub conflict_check {
    my ($self, $name) = @_;
    my $rec = $a->get($name);

    my $type;
    if (defined $rec){
	my $type = $rec->prop('type');
	if ($type eq "pseudonym"){
            my $acct = $rec->prop("Account");
	    my $acct_type = $a->get($acct)->prop('type');

	    return $self->localise('ACCT_CLASHES_WITH_PSEUDONYM',
		{acctName => $name, acctType => $acct_type, acct => $acct});
	}
    }
    elsif (defined getpwnam($name) || defined getgrnam($name)){
        $type = 'system';
    }
    else{
        # No account record and no account
        return 'OK';
    }
    return $self->localise('ACCOUNT_EXISTS',
        {acctName => $name, acctType => $type});
}

# Checks that the name supplied does not contain any unacceptable chars.
# Returns OK on success or a localised error message otherwise.
sub validate_name {
    my ($self, $acctName) = @_;

    unless ($acctName =~ /^([a-z0-9][\_\.\-a-z0-9]*)\$?$/){
        return $self->localise('ACCT_NAME_HAS_INVALID_CHARS',
                             {acctName => $acctName});
    }
    return "OK";
}

# Check if inactivity is a number
sub validate_inactivity {
    my ($self, $inac) = @_;

    unless ($inac =~ /^\d+$/){   
        return $self->localise('INVALID_INACTIVITY',
                             {inactivity => $inac});
    }
    return "OK";
}

# Check if both passwords match
# and are more than 8 chars
sub confirm_password {

    my ($self, $pass1, $pass2) = @_;

    return 'OK' if ($self->{cgi}->param('encryption') eq 'disabled');

    my @num = split(//,$pass1);
    unless (scalar (@num) >= 8){
       return $self->localise('PASSWORD_TOO_SHORT');
    }

    unless ($pass1 eq $pass2){
        return $self->localise('PASSWORD_MISMATCH');
    }
    return 'OK';
}

1;

