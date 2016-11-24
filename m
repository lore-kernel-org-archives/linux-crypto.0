From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/2] KEYS: Fixes [ver #3]
Date: Thu, 24 Nov 2016 13:22:55 +0000
Message-ID: <147999377574.9697.16315343355948647181.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
To: jmorris@namei.org
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Hi James,

Can you pull these patches please and pass them on to Linus?  They include
the following:

 (1) Fix mpi_powm()'s handling of a number with a zero exponent [CVE-2016-8650].

 (2) Fix double free in X.509 error handling.

Ver #3:

 - Integrate my and Andrey's patches for mpi_powm() and use mpi_resize()
   instead of RESIZE_IF_NEEDED() - the latter adds a duplicate check into
   the execution path of a trivial case we don't normally expect to be
   taken.

Ver #2:

 - Use RESIZE_IF_NEEDED() to conditionally resize the result rather than
   manually doing this.

The patches can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-fixes

Tagged thusly:

	git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git
	keys-fixes-20161124-3

David
---
Andrey Ryabinin (2):
      X.509: Fix double free in x509_cert_parse()
      mpi: Fix NULL ptr dereference in mpi_powm()


 crypto/asymmetric_keys/x509_cert_parser.c |    1 -
 lib/mpi/mpi-pow.c                         |    7 ++++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

