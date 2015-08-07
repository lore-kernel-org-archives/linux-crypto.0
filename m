From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 1/4] ASN.1: Fix handling of CHOICE in ASN.1 compiler
Date: Fri, 07 Aug 2015 01:20:47 +0100
Message-ID: <13905.1438906847@warthog.procyon.org.uk>
References: <alpine.LRH.2.20.1508061142580.11873@namei.org> <20150805131810.8933.59566.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, marcel@holtmann.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, dwmw2@infradead.org
To: James Morris <jmorris@namei.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbbHGAUx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Aug 2015 20:20:53 -0400
In-Reply-To: <alpine.LRH.2.20.1508061142580.11873@namei.org>
Content-ID: <13904.1438906847.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

James Morris <jmorris@namei.org> wrote:

> It's pretty late in the -rc cycle.

If you'd rather just pull the patches into your next tree, and wait for the
next merge window, I'm okay with this.  I've rebased my asn1-fixes branch on
your next branch and created a new tag there:

	asn1-fixes-20150806

The old tag is still extant if you'd rather pull that.  There are no other
changes to the two sets of commits.

David
---
The following changes since commit 730daa164e7c7e31c08fab940549f4acc3329432:

  Yama: remove needless CONFIG_SECURITY_YAMA_STACKED (2015-07-28 13:18:19 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/asn1-fixes-20150806

for you to fetch changes up to 1e04d986c8de3b85748addf24e04f165836ff8a0:

  ASN.1: Handle 'ANY OPTIONAL' in grammar (2015-08-06 12:59:07 +0100)

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
