# $Id: smeserver-shared-folders.spec,v 1.13 2024/03/20 12:01:05 terryfage Exp $
# Authority: vip-ire
# Name: Daniel Berteaud

Summary: sme server shared folders module
%define name smeserver-shared-folders
Name: %{name}
%define version 11.0.0
%define release 6
Version: %{version}
Release: %{release}%{?dist}
License: GPL
Group: Networking/Daemons
Source: %{name}-%{version}.tar.xz

BuildRoot: /var/tmp/%{name}-%{version}-%{release}-buildroot
BuildArchitectures: noarch
Requires: smeserver-base >= 4.13.15-76
Requires: perl(CGI::FormMagick)
Requires: smeserver-formmagick >= 1.4.0-12
Requires: smeserver-apache >= 2.6.0-19
Requires: smeserver-mod_dav
Requires: acl
Requires: smeserver-rsyncd
BuildRequires: perl
BuildRequires: smeserver-devtools >= 1.11.0-03
AutoReqProv: no

%description
This module allows you to create network shares
with more flexibility than ibays as it supports ACLs

%changelog
* Thu Nov 13 2025 Vasarhelyi Zsolt <zsoltv@koozali.org> 11.0.0-6.sme
- Createlinks cleanup, fix multiple rpm owners [SME: 12252]

* Thu Oct 30 2025 Vasarhelyi Zsolt <zsoltv@koozali.org> 11.0.0-5.sme
- Update templates.metadata for current php-fpm versions [SME: 12252]

* Wed Oct 29 2025 Vasarhelyi Zsolt <zsoltv@koozali.org> 11.0.0-4.sme
- Remove rsyncd and require smeserver-rsyncd [SME: 12252]

* Mon Oct 06 2025 Brian Read <brianr@koozali.org> 11.0.0-3.sme
- Add UTF8 and avoid potential DB caching problems [SME: 13209]

* Sat Oct 04 2025 Brian Read <brianr@koozali.org> 11.0.0-2.sme
- Delete en.pm and create .lex file if needed [SME: 13214]

* Thu May 22 2025 Brian Read <brianr@koozali.org> 11.0.0-1.sme
- Add SM2 panel - WIP [SME: 13011]

* Sun Sep 08 2024 fix-e-smith-pkg.sh by Trevor Batley <trevor@batley.id.au> 0.3-25.sme
- Fix e-smith references in smeserver-shared-folders [SME: 12732]

* Sat Sep 07 2024 cvs2git.sh aka Brian Read <brianr@koozali.org> 0.3-24.sme
- Roll up patches and move to git repo [SME: 12338]

* Sat Sep 07 2024 BogusDateBot
- Eliminated rpmbuild "bogus date" warnings due to inconsistent weekday,
  by assuming the date is correct and changing the weekday.

* Wed Mar 20 2024 Zsolt Vasarhelyi <vasarhelyizsolt@hotmail.com> 0.3-23.sme
- NFR: have samba audit off by default for shared-folders  [SME: 12515]

* Wed Feb 28 2024 Zsolt Vasarhelyi <vasarhelyizsolt@hotmail.com> 0.3-22.sme
-  NFR Add everyone group to groups list in shared folder's permissions [SME: 12477]
   fix createlinks - httpd updated to httpd-e-smith like all others in rpm

* Tue Feb 27 2024 Zsolt Vasarhelyi <vasarhelyizsolt@hotmail.com> 0.3-21.sme
- Corrected wrong patch Update  - No write access for admin in shared folder [SME: 12119]
  fixed previous build error using old patch (Terry Fage)

* Tue Feb 27 2024 Zsolt Vasarhelyi <vasarhelyizsolt@hotmail.com> 0.3-20.sme
- Updated patch 15 - No write access for admin in shared folder [SME: 12119]
  with this patch admin has write access both before and after saving permissions

* Thu Feb 22 2024 Zsolt Vasarhelyi <vasarhelyizsolt@hotmail.com> 0.3-19.sme
- No write access for admin in shared folder [SME: 12119]
  with this patch admin has write access both before and after saving permissions

* Mon Aug 01 2022 Jean-Philippe Pialasse <tests@pialasse.com> 0.3-18.sme
- update to httpd 2.4 access syntax [SME: 12060]
  removed compat lines, added requires e-smith-apache >= 2.6.0-19

* Mon Jul 25 2022 Jean-Philippe Pialasse <tests@pialasse.com> 0.3-17.sme
- update to httpd 2.4 access syntax [SME: 12060]

* Mon Jul 25 2022 Jean-Philippe Pialasse <tests@pialasse.com> 0.3-16.sme
- merge php-fpm code [SME: 11523]

* Mon Aug 23 2021 Terry Fage <terry.fage@gmail.com> 0.3-11.sme
- apply locale 2021-08-23 patch

* Thu Apr 01 2021 Brian Read <brianr@bjsystems.co.uk> 0.3-14.sme
- Add Update event to createlinks [SME: 10997]

* Thu Apr 01 2021 BogusDateBot
- Eliminated rpmbuild "bogus date" warnings due to inconsistent weekday,
  by assuming the date is correct and changing the weekday.
  Thu Mar 26 2010 --> Thu Mar 25 2010 or Fri Mar 26 2010 or Thu Apr 01 2010 or ....
  Wed Nov 26 2010 --> Wed Nov 24 2010 or Fri Nov 26 2010 or Wed Dec 01 2010 or ....

* Wed Dec 02 2020 Brian Read <brianr@bjsystems.co.uk> 0.3-13.sme
- Add AutoReqProv no to spec file [SME: 10997]

* Sat Aug 01 2020 Brian Read <brianr@bjsystems.co.uk> 0.3-12.sme
- Incomplete update to new Servee Manager Mojolicious framework [SME:10997]

* Sat Dec 07 2019 SME Translation Server <translations@contribs.org> 0.3-11.sme
- apply locale 2019-12-07 patch

* Thu Jul 13 2017 Daniel Berteaud <daniel@firewall-services.com> 0.3-10.sme
- Missing \n in httpd templates when using mod_fastcgi

* Thu Jul 13 2017 Daniel Berteaud <daniel@firewall-services.com> 0.3-9.sme
- Add support for php fpm (but don't require it yet)

* Fri Dec 18 2015 Daniel Berteaud <daniel@firewall-services.com> 0.3-8.sme
- Apply locale 2015-12-18 patch
- Add veto files directive support

* Tue Feb 17 2015 Daniel Berteaud <daniel@firewall-services.com> 0.3-7.sme
- Apply lcoale 2015-02-17 patch

* Thu Dec 18 2014 Daniel Berteaud <daniel@firewall-services.com> 0.3-6.sme
- Handle ext4 [SME: 8730]

* Mon Jun 23 2014 Daniel Berteaud <daniel@firewall-services.com> 0.3-5.sme
- Fix basic auth on EL6

* Mon Jan 13 2014 Daniel Berteaud <daniel@firewall-services.com> 0.3-4.sme
- Add a missing CR in smb.conf templates

* Mon Nov 25 2013 Daniel Berteaud <daniel@firewall-services.com> 0.3-3.sme
- Dump ACL and extended attributes in /home/e-smith/db/shares if
  ManualPermissions is set

* Tue Nov 12 2013 Daniel Berteaud <daniel@firewall-services.com> 0.3-2.sme
- Remove expand link for fstab in post-upgrade

* Mon Nov 11 2013 Daniel Berteaud <daniel@firewall-services.com> 0.3-1.sme
- Rebuild for SME9

* Tue Oct 29 2013 Daniel Berteaud <daniel@firewall-services.com> 0.1-83.sme
- apply locale 2013-10-29 patch

* Tue Oct 22 2013 Daniel Berteaud <daniel@firewall-services.com> 0.1-82.sme
- Rename ajaxplorer to pydio

* Thu Oct 17 2013 Daniel Berteaud <daniel@firewall-services.com> 0.1-81.sme
- Add NT ACL support

* Sun Jul 14 2013 JP Pialasse <tests@pialasse.com> 0.1-80.sme
- apply locale 2013-07-14 patch

* Sat Oct 20 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-79.sme
- Enhance samba audit

* Thu Oct 18 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-78.sme
- Allow share names ending with dollar
  (windows can, and it might be needed for migrations)

* Wed Oct 17 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-77.sme
- Allow share names starting with numbers (there's no reason to deny it)

* Thu Oct 11 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-76.sme
- Look at users ACL for encrypted shares list
- Apply locale 2012-10-11 patch

* Fri Aug 24 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-75.sme
- add possibility to hide shares and to mark them non removable

* Thu Aug 23 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-74.sme
- Enable FTP access

* Fri Jul 20 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-73.sme
- Apply locale 2012-07-20 patch

* Tue Jun 19 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-72.sme
- Explicitly set www acl so web access works even when only individual users
  have ACLs

* Fri May 18 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-71.sme
- Don't disable unix extension in share scope

* Fri Apr 20 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-70.sme
- Display permission form after creation
- Display share name and desc in permission form

* Tue Mar 20 2012 SME Translation Server <translations@contribs.org> 0.1-69.el6
- apply locale 2012-03-20 patch

* Sun Mar 11 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-68.sme
- Enable webdav even when no auth is required
  (but auth will still be required for write operations)

* Thu Mar 01 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-67.sme
- Add rsyncd support

* Sat Feb 18 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-66.sme
- Fix bg locale

* Sat Feb 18 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-65.sme
- Fix root ACL for users
- Apply locale 2012-02-18 patch

* Sat Feb 18 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-64.sme
- In http access, remove ro users from rw list
- templates cleanup

* Fri Feb 17 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-63.sme
- Replace fr with correct en-us locale for USERS entry

* Mon Feb 13 2012 Daniel Berteaud <daniel@firewall-services.com> 0.1-62.sme
- Code cleanup
- Move ACL configuration in a separated page
- User level ACL support

* Thu Dec 15 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-61.sme
- Hide Recycle Bin dir if recycle is disabled

* Wed Nov 30 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-60.sme
- Fix Ajaxplorer field display when the form has an error

* Tue Nov 08 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-59.sme
- Stop removing exec perm
- use --physical for setfacl (don't follow symlinks)

* Mon Nov 07 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-58.sme
- Add wide links samba option

* Thu Nov 03 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-57.sme
- Use recursive setfacl command (should greatly speedup share modification)

* Tue Oct 18 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-56.sme
- Apply locale 2011-10-18 patch
- Enable FollowSymLinks if AllowOverride is set to All

* Thu Sep 01 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-55.sme
- Fix share creation when encfs is not installed

* Thu Aug 04 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-54.sme
- Don't check password length when encryption is disabled

* Mon Jul 18 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-53.sme
- Fix encrypted share list

* Wed Jul 13 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-52.sme
- Fix panel when ajaxplorer is not installed

* Fri Jul 08 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-51.sme
- Fix modification of unencrypted shares

* Tue Jul 05 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-50.sme
- Apply locale 2011-07-05 patch

* Tue Jul 05 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-49.sme
- Make encryption support optional
- Sanitize password field in userpanelEncfs
- Prevent deletion of mounted, encrypted shares

* Wed Jun 29 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-48.sme
- Enable samba auditing

* Tue Jun 28 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-47.sme
- Fix Ajaxplorer fields on share creation

* Tue Jun 28 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-46.sme
- Change the way ajaxplorer is integrated (add a new config section)

* Mon Jun 27 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-45.sme
- Add support for ajaxplorer

* Wed Jun 22 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-44.sme
- Set read only permissions on top dir of each share

* Tue Jun 14 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-43.sme
- Don't check password field if encryption is disabled

* Tue May 17 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-42.sme
- Add missing INACTIVITY entry in locale
- Apply locale 2011-05-17 patch

* Mon May 16 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-41.sme
- apply locale 2011-05-16 patch

* Fri May 06 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-40.sme
- Support encryption using EncFS

* Wed Apr 27 2011 SME Translation Server <translations@contribs.org> 0.1-39.sme
- apply locale 2011-04-27 patch

* Tue Apr 05 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-38.sme
- Fix removing empty directories in recycles

* Wed Mar 30 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-37.sme
- expand httpd.conf and restart apache on group-modify

* Tue Mar 29 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-36.sme
- Deduplicate writer user list in apache configuration
- Always grant web access to user admin

* Tue Jan 25 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-35.sme
- Fix setting ACLs on files starting with a dash [SME: 6500]

* Mon Jan 03 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-34.sme
- Apply locale 2011-01-03 patch

* Mon Jan 03 2011 Daniel Berteaud <daniel@firewall-services.com> 0.1-33.sme
- New prop PHPAllowUrlFopen

* Wed Dec 15 2010  Daniel Berteaud <daniel@firewall-services.com> 0.1-32.sme
- Print the group table when ManualPermissions is enabled
- Fix a warning in httpd.conf templates
- Use www as group owner of the root dir if httpAccess is enabled

* Fri Dec 10 2010 Daniel Berteaud <daniel@firewall-services.com> 0.1-31.sme
- Add new prop AliasOnPrimary to toggle alias on the system domain

* Thu Dec 2 2010 Daniel Berteaud <daniel@firewall-services.com> 0.1-30.sme
- Fix purge script

* Tue Nov 30 2010 Daniel Berteaud <daniel@firewall-services.com> 0.1-29.sme
- apply locale 2010-11-30 patch

* Tue Nov 30 2010 Shad L. Lords <slords@mail.com> 0.1-28.sme
- Fix orig file removal the correct way

* Mon Nov 29 2010  Daniel B. <daniel@firewall-services.com> 0.1-27.sme
- Remove .orig file

* Fri Nov 26 2010 Daniel B. <daniel@firewall-services.com> 0.1-26.sme
  Wed Nov 26 2010 --> Wed Nov 24 2010 or Fri Nov 26 2010 or Wed Dec 01 2010 or ....
- Add webdav support
- add recycle purge support (with configurable retention time)

* Thu Nov 25 2010 Daniel B. <daniel@firewall-services.com> 0.1-25.sme
- Fix excludes separator for samba recyle bin [SME: 6379]
- Recycle bin directory can be configured (RecycleBinDir prop)
- Create the recyle bin directory if enabled
- Fix defaults ACL on dir (fix issues with recycle bin)

* Wed Oct 20 2010 Daniel B. <daniel@firewall-services.com> 0.1-24.sme
- Fix permission on group delete
- apply local 2010-10-20 patch

* Mon Jul 19 2010 Daniel B. <daniel@firewall-services.com> 0.1-23.sme
- apply locale 2010-07-19 patch

* Tue Jul 06 2010 Daniel B. <daniel@firewall-services.com> 0.1-22.sme
- correct typos in en-us locale [SME: 6103]
- apply locale 2010-07-06 patch

* Sun May 23 2010 SME Translation Server <translations@contribs.org> 0.1-21.sme
- apply locale 2010-05-23 patch

* Fri Mar 26 2010 Daniel B. <daniel@firewall-services.com> 0.1-20.sme
  Thu Mar 26 2010 --> Thu Mar 25 2010 or Fri Mar 26 2010 or Thu Apr 01 2010 or ....
- apply locale 2010-03-26 patch (fix navigation-conf)

* Thu Mar 25 2010 Daniel B. <daniel@firewall-services.com> 0.1-19.sme
- apply locale 2010-03-25 patch

* Mon Mar 15 2010 Daniel B. <daniel@firewall-services.com> 0.1-18.sme
- really apply manual_permissions patch

* Mon Mar 08 2010 Daniel B. <daniel@firewall-services.com> 0.1-17.sme
- Add an option to allow manual permissions (ManualPermissions)
- remove unused .orig file
- Exec CGI in cgi-bin directories

* Tue Mar 02 2010 SME Translation Server <translations@contribs.org> 0.1-16.sme
- apply locale 2010-03-02 patch

* Tue Nov 17 2009 Daniel B. <daniel@firewall-services.com> 0.1-15.sme
- apply locale 2009-11-17 patch

* Tue Oct 27 2009 SME Translation Server <translations@contribs.org> 0.1-14.sme
- apply locale 2009-10-27 patch

* Wed Oct 21 2009 Daniel B. <daniel@firewall-services.com> 0.1-13.sme
- apply locale 2009-10-21 patch

* Tue Oct 20 2009 Daniel B. <daniel@firewall-services.com> 0.1-12.sme
- apply locale 2009-10-20 patch

* Tue Sep 29 2009 Daniel B. <daniel@firewall-services.com> 0.1-11.sme
- apply locale 2009-09-28 patch

* Mon Aug 24 2009 SME Translation Server <translations@contribs.org> 0.1-10.sme
- apply locale 2009-08-24 patch

* Wed Jul 22 2009 Daniel B. <daniel@firewall-services.com> 0.1-9.sme
- Apply locale 2009-07-22 patch

* Mon Jun 15 2009 Daniel B. <daniel@firewall-services.com> [0.1-8]
- Apply locale 2009-06-15 patch

* Mon May 25 2009 Daniel B. <daniel@firewall-services.com> [0.1-7]
- Include hosts/networks defined in $externalSSLAccess for local access
  (httpAccess)

* Mon May 25 2009 Daniel B. <daniel@firewall-services.com> [0.1-6]
- Apply locale 2009-05-25 patch

* Thu May 21 2009 Daniel B. <daniel@firewall-services.com> [0.1-5]
- Add an empty template-begin for smb.conf template
- Add locale 2009-05-21 patch (en-us)

* Thu May 21 2009 Daniel B. <daniel@firewall-services.com> [0.1-4]
- apply locale 2009-05-21 patch

* Wed May 20 2009 SME Translation Server <translations@contribs.org> 0.1-3.sme
- apply locale 2009-05-20 patch

* Wed May 13 2009 Daniel B. <daniel@firewall-services.com> [0.1-2]
- add http access, with some options in the panel
- present the keepversion option of the recylcebin in the panel
- changes in db keys
- remove some descriptions in the panel
- optimization in share-modify to limit the time needed
  to reset permissions

* Tue May 05 2009 Daniel B. <daniel@firewall-services.com> [0.1-1]
- Add locale patch 2009-05-05

* Tue Apr 28 2009 Daniel B. <daniel@firewall-services.com> [0.1-0.beta3]
- Add acl option in fstab via the template system
  (just like usrquota and grpquota)

* Thu Apr 16 2009 Daniel B. <daniel@firewall-services.com> [0.1-0.beta2]
- Rename spec file

* Wed Apr 08 2009 Daniel B. <daniel@firewall-services.com> [0.1-0.beta1]
- Rename maxIbayNameLength to maxShareNameLength

* Wed Apr 08 2009 Daniel B. <daniel@firewall-services.com> [0.1-0.beta0]
- Initial release.

%prep
%setup

%pre

%post

%build
# Force creation of potentially empty directories
mkdir -p root/etc/e-smith/web/{common,functions}
mkdir -p root/etc/e-smith/web/panels/manager/{cgi-bin,common,html}
mkdir -p root/home/e-smith/files/shares
mkdir -p root/home/e-smith/db/shares

perl createlinks

%install
rm -rf $RPM_BUILD_ROOT
(cd root   ; find . -depth -print | cpio -dump $RPM_BUILD_ROOT)
/sbin/e-smith/genfilelist $RPM_BUILD_ROOT \
    --file /etc/cron.daily/purge-shares-recycle 'attr(0755,root,root)' \
    --file /etc/sysconfig/modules/fuse.modules 'attr(0755,root,root)' \
    --dir /home/e-smith/db/shares 'attr(0750,root,root)' \
    > %{name}-%{version}-%{release}-filelist
echo "%doc COPYING"          >> %{name}-%{version}-%{release}-filelist

%clean 
rm -rf $RPM_BUILD_ROOT

%files -f %{name}-%{version}-%{release}-filelist
%defattr(-,root,root)
