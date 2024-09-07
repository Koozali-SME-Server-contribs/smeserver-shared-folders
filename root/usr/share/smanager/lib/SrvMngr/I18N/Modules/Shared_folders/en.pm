package SrvMngr::I18N::Modules::Shared_folders::en;
use strict;
use warnings;
use utf8;
use Mojo::Base 'SrvMngr::I18N';

use SrvMngr::I18N::Modules::General::en;

my %lexicon = (

'shf_title' => 'Shared Folders',
'shf_FORM_TITLE' => '   Create, modify, or remove shared folders',
'shf_FIRSTPAGE_DESC' => '   You can remove any shared folder by clicking on the corresponding command next to the shared folder.',
'shf_ADD_TITLE' => '   Create or modify a shared folder',
'shf_NAME_FIELD_DESC' => '   The share name should contain only lower-case letters, numbers, periods, hyphens and underscores, and should start with a lower-case letter. For example "johnson", "intra", and "cust3.prj12" are all valid names, but "3associates", "John Smith" and "Bus!Partner" are not. The name is limited to [_1] characters.',
'shf_NAME_LABEL' => '   Shared folder name',
'shf_REMOVE_TITLE' => '   Remove shared folder',
'shf_REMOVE_DESC' => '   
       You are about to remove the following shared folder<br>
       All files belonging to this shared folder will be deleted.<br>
       Are you sure you wish to remove it ?<br>
   ',
'shf_ERROR_WHILE_CREATING_SHARE' => '   An error occurred while creating the shared folder.',
'shf_SUCCESSFULLY_CREATED_SHARE' => '   Successfully created shared folder.',
'shf_NO_SHARES' => '   There are no shared folders currently configured.',
'shf_CANT_FIND_SHARE' => '   Can\'t find account for [_1] (does it exist?)',
'shf_CANT_CREATE_SHARE' => '   Can\'t create new account for [_1] (does it already exist?)',
'shf_ERROR_WHILE_MODIFYING_SHARE' => '   An error occurred while modifying the shared folder.',
'shf_SUCCESSFULLY_MODIFIED_SHARE' => '   Successfully modified shared folder.',
'shf_SUCCESSFULLY_DELETED_SHARE' => '   Successfully deleted shared folder.',
'shf_ERROR_WHILE_DELETING_SHARE' => '   An error occurred while deleting the share.',
'shf_Shares' => 
'Shares',
'shf_INVALID_SHARE_DESCRIPTION' => 
'Error: unexpected or missing characters in share description',
'shf_ACCT_NAME_HAS_INVALID_CHARS' => 
'The shared folder name "[_1]" contains invalid characters. Shared folder names must start with a lower case letter and contain only lower case letters, numbers, and hyphens.',
'shf_MAX_SHARE_NAME_LENGTH_ERROR' => '   The shared folder name "[_1]" is too long. The maximum is [_1] characters.',
'shf_ACCT_CLASHES_WITH_PSEUDONYM' => '   
   The account "[_1]" clashes with pseudonym details for [_2] account "[_3]". <p>[_2] is a pseudonym for [_1].</p>
   ',
'shf_ACCOUNT_EXISTS' => '   The account "[_1]" is an existing [_2] account.',
'shf_LABEL_ADD_SHARE_BUTTON' => '   Create a new shared folder',
'shf_DESC_PERMISSIONS' => '   You can use this matrix to define groups and users access permissions.',
'shf_DESC_SMB_SETTINGS' => '   The following settings control the access of this shared folder from the local network, using the SMB/CIFS protocol. ',
'shf_LABEL_SMB_ACCESS' => '   SMB Access',
'shf_LABEL_RECYCLEBIN' => '   Recycle bin',
'shf_LABEL_RETENTION' => '   Retention time',
'shf_UNLIMITED' => '   unlimited',
'shf_ONE_WEEK' => '   one week',
'shf_ONE_MONTH' => '   one month',
'shf_SIX_MONTHS' => '   six months',
'shf_ONE_YEAR' => '   one year',
'shf_DESC_HTTP_SETTINGS' => '   The following settings control the access of this shared folder using the HTTP/HTTPS protocol.',
'shf_LABEL_HTTP_ACCESS' => '   Web Access',
'shf_LABEL_WEBDAV' => '   WebDav support',
'shf_LABEL_REQUIRE_SSL' => '   Force secure connections',
'shf_LABEL_INDEXES' => '   Indexes',
'shf_LABEL_DYNAMIC_CONTENT' => '   Dynamic content execution (PHP, CGI, SSI)',
'shf_LOCAL_NETWORK_NO_PASSWORD' => 'Local network (no password required)',
'shf_LOCAL_NETWORK_PASSWORD' => 'Local network (password required)',
'shf_ENTIRE_INTERNET_NO_PASSWORD' => 'Entire Internet (no password required)',
'shf_ENTIRE_INTERNET_PASSWORD' => 'Entire Internet (password required)',
'shf_ENTIRE_INTERNET_PASSWORD_REMOTE' => 'Entire Internet (password required outside local network)',
'shf_NONE' => 'No access',
'shf_ENABLED_BROWSEABLE' => 'Enabled, browseable',
'shf_ENABLED_NON_BROWSEABLE' => 'Enabled, hidden',
'shf_DONT_KEEP_VERSIONS' => 'Enabled, keep only the latest version',
'shf_KEEP_VERSIONS' => 'Enabled, keep a copy of all versions',
'shf_PERMISSIONS' => '   Permissions',
'shf_WRITE_PERM' => '   Read / Write',
'shf_READ_PERM' => '   Read Only',
'shf_ENABLED' => '   enabled',
'shf_DISABLED' => '   disabled',
'shf_YES' => '   yes',
'shf_NO' => '   no',
'shf_NAME' => 'Name',
'shf_DESCRIPTION' => 'Description',
'shf_ACTION' => '   Action',
'shf_MODIFY' => '   Modify',
'shf_REMOVE' => '   Remove',
'shf_CANCELED' => '   Cancelled',
'shf_MANUAL_PERMS' => '   <span style="color:red">Permissions on this shared folder are managed manually, modifications will only affect web access if a password is required.</span><br><br>',
'shf_DESC_ENCRYPTION' => '   The followings options let you protect your data. If encryption is enabled, the data will never be stored in clear text on the server. Your share will either be "available" (data will appear as clear text, encryption/decryption is done on the fly), or protected (only the ciphered data is available on the server). Encryption can only be set at shared folder creation time. Also, read only groups are not supported with encrypted shared folders. If you enable encryption, only members of groups with read/write privileges will be able to access this share.',
'shf_LABEL_ENCRYPTION' => '   Encryption',
'shf_DESC_PASSWORD' => '   You need to choose a password to protect your data. This password must be at least 8 characters long. Do not loose this password. If you forget it, your data will be lost because there\'s no way to recover it.',
'shf_LABEL_PASSWORD' => '   Password',
'shf_LABEL_PASSWORD2' => '   Password (confirmation)',
'shf_DESC_INACTIVITY' => '   To provide additional security, you can set an inactivity time out (in minutes). When the data is available, if nobody access it for this period of time, the data will go back to protected mode automatically.',
'shf_INACTIVITY' => '   Inactivity timeout',
'shf_ERROR_WITH_ENCRYPTION' => '   An error occured while performing initial folder encryption',
'shf_ERROR_ENCRYPTED_ENABLED' => '   This shared folder is encrypted and access is enabled. You have to put it in protected mode before removing it',
'shf_INVALID_INACTIVITY' => '   Inactivity value must be numbers only',
'shf_PASSWORD_MISMATCH' => '   Passwords don\'t match',
'shf_PASSWORD_TOO_SHORT' => '   Password is too short, please use at least 8 characters',
'shf_DESC_PYDIO' => '   The following settings control the access of this shared folder with the web based file manager Pydio (formerly AjaXplorer)',
'shf_LABEL_PYDIO' => '   Pydio Access',
'shf_TITLE_PERMISSIONS' => '   Access right management',
'shf_USERS' => 'Users',

'shf_ENCRYPT_FORM_TITLE' => 'Shared Folders Encryption',
'shf_ENCRYPT_Shared Folders Encryption' => 'Shared Folders Encryption',
'shf_ENCRYPT_FIRSTPAGE_DESC' =>'This panel lets you enable encrypted shared folder access.',
'shf_ENCRYPT_STATUS' => 'Status',
'shf_ENCRYPT_MOUNTED' => 'Enabled',
'shf_ENCRYPT_NOT_MOUNTED' => 'Protected',
'shf_ENCRYPT_MOUNT' =>'Enable',
'shf_ENCRYPT_UMOUNT' => 'Protect',
'shf_ENCRYPT_ERROR_MOUNTING' => 'An error occured. Check that you have the correct password.',
'shf_ENCRYPT_UMOUNT_DESC' => 'Are you sure you want to protect this shared folder ? Once protected, the content won\'t be accessible until re-enabled with the associated password.',
'shf_ENCRYPT_MOUNT_DESC' => 'You have to enter the password to make this folder\'s content available.',
'shf_ENCRYPT_LABEL_MOUNT_PASSWORD' => 'Password',
'shf_ENCRYPT_VALIDATE' => 'Validate',
'shf_ENCRYPT_NO_ENCRYPTED_SHARE' => 'No encrypted share configured',

);

our %Lexicon = (
	%{ SrvMngr::I18N::Modules::General::en::Lexicon },
	%lexicon
);


1;

