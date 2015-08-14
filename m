From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/3] Move cert handling to certs/ directory
Date: Fri, 14 Aug 2015 16:56:50 +0100
Message-ID: <20150814155650.23941.76513.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
	dwmw2@infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: keyrings@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Here's a set of patches that moves the certificate handling to its own
directory rather than sharing in the kernel/ directory.  We then move key
generation into the certs/ directory rather than doing it in the root.

This allows us to simplify the kernel/Makefile and slightly simplify the
new certs/Makefile.  It also keeps the various generated files in the same
place to make them easier to find and clean up.

The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=modsign-pkcs7

and are tagged with:

	modsign-pkcs7-20150814

David
---
David Howells (1):
      Move certificate handling to its own directory

David Woodhouse (2):
      modsign: Use if_changed rule for extracting cert from module signing key
      modsign: Handle signing key in source tree


 Documentation/module-signing.txt |   18 ++--
 MAINTAINERS                      |    9 ++
 Makefile                         |    9 +-
 certs/Kconfig                    |   42 ++++++++++
 certs/Makefile                   |   94 +++++++++++++++++++++++
 certs/system_certificates.S      |   23 ++++++
 certs/system_keyring.c           |  157 ++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig                   |    1 
 init/Kconfig                     |   39 ---------
 kernel/Makefile                  |  143 -----------------------------------
 kernel/system_certificates.S     |   23 ------
 kernel/system_keyring.c          |  157 --------------------------------------
 scripts/Kbuild.include           |   51 ++++++++++++
 13 files changed, 390 insertions(+), 376 deletions(-)
 create mode 100644 certs/Kconfig
 create mode 100644 certs/Makefile
 create mode 100644 certs/system_certificates.S
 create mode 100644 certs/system_keyring.c
 delete mode 100644 kernel/system_certificates.S
 delete mode 100644 kernel/system_keyring.c
