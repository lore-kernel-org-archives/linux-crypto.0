From: David Howells <dhowells@redhat.com>
Subject: [GIT PULL] ASN.1 fixes
Date: Wed, 05 Aug 2015 14:26:09 +0100
Message-ID: <9148.1438781169@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: marcel@holtmann.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org, dhowells@redhat.com,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org,
	keyrings@linux-nfs.org
To: jmorris@namei.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-ID: <9147.1438781169.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi James,

Can you pull these fixes for the ASN.1 compiler and decoder into the
security/next tree and also pass them onto Linus for immediate inclusion?

I've checked that the bugs fixed can't be used to compromise a system, so I
think they're survivable, but all the same, it's best if they're fixed
immediately (if I'm wrong, there's the possibility of handing memcpy() a
NULL pointer).

Here can be found a pair of programs to take BER/DER-encoded X.509 and
PKCS#7 and turn it into text which can be edited and turn the edited text
back into BER.  This allows the ASN.1 to be butchered in interesting ways.

	http://people.redhat.com/dhowells/asn1encode.c
	http://people.redhat.com/dhowells/asn1decode.c

David
---

The following changes since commit 52721d9d3334c1cb1f76219a161084094ec634dc:

  Linux 4.2-rc3 (2015-07-19 14:45:02 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/asn1-fixes-20150805

for you to fetch changes up to 233ce79db4b23a174bcf30bde5d6ad913d5f46d3:

  ASN.1: Handle 'ANY OPTIONAL' in grammar (2015-08-05 13:38:07 +0100)

----------------------------------------------------------------
ASN.1 fixes

----------------------------------------------------------------
David Howells (4):
      ASN.1: Fix handling of CHOICE in ASN.1 compiler
      ASN.1: Fix actions on CHOICE elements with IMPLICIT tags
      ASN.1: Fix non-match detection failure on data overrun
      ASN.1: Handle 'ANY OPTIONAL' in grammar

 include/linux/asn1_ber_bytecode.h | 16 +++++++++++-----
 lib/asn1_decoder.c                | 27 +++++++++++++++++++++++----
 scripts/asn1_compiler.c           | 23 ++++++++++++++---------
 3 files changed, 48 insertions(+), 18 deletions(-)
