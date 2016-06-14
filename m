From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2 0/4] crypto: CTR DRBG - performance improvements
Date: Tue, 14 Jun 2016 07:33:48 +0200
Message-ID: <1842774.dgV8IOeQEu@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36448 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbcFNFgY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jun 2016 01:36:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The following patch set is aimed to increase the performance of the CTR
DRBG, especially when assembler implementations of the CTR AES mode are
available.

The patch set increases the performance by 10% for random numbers of 16 bytes
and reaches 450% for random numbers reaching 4096 bytes (larger random
numbers will even have more performance gains). The performance gains were
measured when using ctr-aes-aesni.

Note, when using the C implementation of the CTR mode (cipher/ctr.c), the
performance of the CTR DRBG is slightly worse than it is now, but still it
is much faster than the Hash or HMAC DRBGs.

The patch set is CAVS tested.

Changes v2:
* the alignment patch is updated to use the alignment of the underlying TFM

Stephan Mueller (4):
  crypto: CTR DRBG - use CTR AES instead of ECB AES
  crypto: DRBG - use aligned buffers
  crypto: CTR DRBG - use full CTR AES for update
  crypto: CTR DRBG - avoid duplicate maintenance of key

 crypto/Kconfig        |   1 +
 crypto/drbg.c         | 252 +++++++++++++++++++++++++++++++++-----------------
 include/crypto/drbg.h |  12 +++
 3 files changed, 181 insertions(+), 84 deletions(-)

-- 
2.5.5
