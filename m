From: David Howells <dhowells@redhat.com>
Subject: [GIT PULL] Move cert handling to certs/ directory
Date: Mon, 24 Aug 2015 13:51:52 +0100
Message-ID: <29947.1440420712@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	dwmw2@infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, keyrings@vger.kernel.org
To: jmorris@namei.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbbHXMwA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Aug 2015 08:52:00 -0400
Content-ID: <29946.1440420712.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi James,

Sorry for the late request, but can you pull this please?  It's a set of
commits that puts a bit of polish on the previous module signing patches.
It moves the certificate handling to its own directory rather than sharing
in the kernel/ directory.  It then moves key generation into the certs/
directory rather than doing it in the root.

This allows us to simplify the kernel/Makefile and slightly simplify the
new certs/Makefile.  It also keeps the various generated files in the same
place to make them easier to find and clean up.

David
---
The following changes since commit 0e38c35815f50e5a347977d76fb5eb4c3bf020b5:

  Merge branch 'smack-for-4.3' of https://github.com/cschaufler/smack-next into next (2015-08-14 17:35:10 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/modsign-pkcs7-20150814

for you to fetch changes up to 3ee550f12c1529a023f71c9b5becb3351911047b:

  modsign: Handle signing key in source tree (2015-08-14 16:32:52 +0100)

----------------------------------------------------------------
Module signing with PKCS#7

----------------------------------------------------------------
David Howells (1):
      Move certificate handling to its own directory

David Woodhouse (2):
      modsign: Use if_changed rule for extracting cert from module signing key
      modsign: Handle signing key in source tree

 Documentation/module-signing.txt        |  18 ++--
 MAINTAINERS                             |   9 ++
 Makefile                                |   9 +-
 certs/Kconfig                           |  42 ++++++++++
 certs/Makefile                          |  94 +++++++++++++++++++++
 {kernel => certs}/system_certificates.S |   4 +-
 {kernel => certs}/system_keyring.c      |   0
 crypto/Kconfig                          |   1 +
 init/Kconfig                            |  39 ---------
 kernel/Makefile                         | 143 --------------------------------
 scripts/Kbuild.include                  |  51 ++++++++++++
 11 files changed, 212 insertions(+), 198 deletions(-)
 create mode 100644 certs/Kconfig
 create mode 100644 certs/Makefile
 rename {kernel => certs}/system_certificates.S (86%)
 rename {kernel => certs}/system_keyring.c (100%)
