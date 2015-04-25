From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2] SP800-38F / RFC3394 key wrapping
Date: Sun, 26 Apr 2015 00:07:31 +0200
Message-ID: <1515730.LIeS5qas5m@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34500 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbbDYWJZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Apr 2015 18:09:25 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Please note that this patch will conflict with the DRBG patch for
additional seeding sent earlier today. Both add test vectors in
testmgr.c between the existing hmac() and lrw() due to the ordering
requirements of testmgr.c.

Changes v2:
* Turn kw() into a blkcipher as suggested by Herbert Xu.
* Drop the support for user provided IV to initialize encrypt or
  for performing the verify step during decrypt.

Stephan Mueller (1):
  crypto: add key wrapping block chaining mode

 crypto/Kconfig   |   7 +
 crypto/Makefile  |   1 +
 crypto/keywrap.c | 502 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.c |  25 +++
 crypto/testmgr.h |  41 +++++
 5 files changed, 576 insertions(+)
 create mode 100644 crypto/keywrap.c

-- 
2.1.0
