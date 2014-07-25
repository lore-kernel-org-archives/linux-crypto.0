From: David Howells <dhowells@redhat.com>
Subject: [GIT PULL] Keyrings: PKCS#7 fixup
Date: Fri, 25 Jul 2014 13:30:48 +0100
Message-ID: <22574.1406291448@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
	mimi.e.zohar@gmail.com, Dmitry Kasatkin <d.kasatkin@samsung.com>,
	vgoyal@redhat.com, keyrings@linux-nfs.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: James Morris <jmorris@namei.org>, sfr@canb.auug.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-ID: <22573.1406291448.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi James,

Here's a fixup for the problem that Stephen spotted.

David
---
The following changes since commit 633706a2ee81637be37b6bc02c5336950cc163b5:

  Merge branch 'keys-fixes' into keys-next (2014-07-22 21:55:45 +0100)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-next-20140725

for you to fetch changes up to 8f3438ccea149647ad1849651d1e14c7b8b85e63:

  PKCS#7: Missing inclusion of linux/err.h (2014-07-25 11:33:53 +0100)

----------------------------------------------------------------
(from the branch description for keys-next local branch)

Keyrings for linux-next
Keyrings patches

----------------------------------------------------------------
David Howells (1):
      PKCS#7: Missing inclusion of linux/err.h

 crypto/asymmetric_keys/pkcs7_key_type.c | 1 +
 1 file changed, 1 insertion(+)
