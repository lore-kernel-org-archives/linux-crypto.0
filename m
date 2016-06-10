From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/4] crypto: CTR DRBG - performance improvements
Date: Fri, 10 Jun 2016 07:55:42 +0200
Message-ID: <3932580.AnntHTzK82@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:36234 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbcFJF7T (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jun 2016 01:59:19 -0400
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

Stephan Mueller (4):
  crypto: CTR DRBG - use CTR AES instead of ECB AES
  crypto: DRBG - use aligned buffers
  crypto: CTR DRBG - use full CTR AES for update
  crypto: CTR DRBG - avoid duplicate maintenance of key

 crypto/Kconfig        |   1 +
 crypto/drbg.c         | 233 ++++++++++++++++++++++++++++++++++----------------
 include/crypto/drbg.h |  12 +++
 3 files changed, 172 insertions(+), 74 deletions(-)

-- 
2.5.5
