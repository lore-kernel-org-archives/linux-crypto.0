From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/3] crypto: AF_ALG - AEAD memory handling fixes
Date: Thu, 10 Nov 2016 04:30:38 +0100
Message-ID: <3302668.EORF2jai5r@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: mathew.j.martineau@linux.intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50834 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753988AbcKJDd4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Nov 2016 22:33:56 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

The first patch is unchanged compared to a previous submission to the
mailing list. It is rolled into this patch set to have a common reference
for the AEAD user space interface changes. Therefore, please disregard
the old patch submission.

The third patch should go into stable as this fixes a kernel crash that
is present in current kernel versions.

The patch set can be tested with the HEAD branch of libkcapi found at [1].
If the patch set is accepted, the development branch will be released as
0.13.0.

[1] https://github.com/smuellerDD/libkcapi

Stephan Mueller (3):
  crypto: AF_ALG - fix AEAD tag memory handling
  crypto: AF_ALG - disregard AAD buffer space for output
  crypto: AF_ALG - fix AEAD AIO handling of zero buffer

 crypto/algif_aead.c | 215 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 166 insertions(+), 49 deletions(-)

-- 
2.7.4
