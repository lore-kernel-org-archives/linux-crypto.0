From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v7 4/6] compile the DRBG code
Date: Wed, 21 May 2014 06:21:14 +0200
Message-ID: <2138378.5TuudT6B6t@myon.chronox.de>
References: <16102625.1uoi9eJz6k@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: aquini@redhat.com, jeremy.wayne.powell@gmail.com,
	clemens@ladisch.de, pwalten@au1.ibm.com, joe@perches.com
To: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:50055 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbaEUEcI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 21 May 2014 00:32:08 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <SFB> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Wed, 21 May 2014 06:31:38 +0200
In-Reply-To: <16102625.1uoi9eJz6k@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Makefile b/crypto/Makefile
index 38e64231..bfa94fa 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -92,6 +92,7 @@ obj-$(CONFIG_CRYPTO_842) += 842.o
 obj-$(CONFIG_CRYPTO_RNG2) += rng.o
 obj-$(CONFIG_CRYPTO_RNG2) += krng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) += ansi_cprng.o
+obj-$(CONFIG_CRYTPO_DRBG) += drbg.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
-- 
1.9.0
