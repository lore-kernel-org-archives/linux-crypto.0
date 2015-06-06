From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH] crypto: drbg - decrease verbosity
Date: Sat, 06 Jun 2015 04:20:35 +0200
Message-ID: <7507652.XDRqQzIvs8@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46096 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbbFFCUj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Jun 2015 22:20:39 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When compiling the DRBG statically into the kernel, the testmgr
allocation of the DRBG may be done at a time the Jitter RNG is
not available. The testmgr instantiates a number of DRBGs for performing
testing which may cause a flurry of logs about unavailable Jitter RNG.
Note, the Jitter RNG is not needed for the testmgr operation anyways.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 7339cc5..3fed67e 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1279,7 +1279,7 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
 	if(IS_ERR(drbg->jent))
 	{
-		pr_info("DRBG: could not allocate Jitter RNG handle for seeding\n");
+		pr_devel("DRBG: could not allocate Jitter RNG handle for seeding\n");
 		/*
 		 * As the Jitter RNG is a module that may not be present, we
 		 * continue with the operation and do not fully tie the DRBG
-- 
2.4.2
