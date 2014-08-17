From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 2/8] DRBG: kzfree does not need a check for NULL pointer
Date: Sun, 17 Aug 2014 17:37:59 +0200
Message-ID: <1765645.hacb5qoKH5@myon.chronox.de>
References: <7044529.FG2KhbPc9P@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53654 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbaHQPpc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Aug 2014 11:45:32 -0400
Received: from myon.chronox.de
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S2DA> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 17 Aug 2014 17:45:00 +0200
In-Reply-To: <7044529.FG2KhbPc9P@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The kzfree function already performs the NULL pointer check. Therefore,
the DRBG code does not need to implement such check.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 73d21e5..8a95ca8 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1153,8 +1153,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	drbg->reseed_ctr = 1;
 
 out:
-	if (entropy)
-		kzfree(entropy);
+	kzfree(entropy);
 	return ret;
 }
 
@@ -1163,19 +1162,15 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 {
 	if (!drbg)
 		return;
-	if (drbg->V)
-		kzfree(drbg->V);
+	kzfree(drbg->V);
 	drbg->V = NULL;
-	if (drbg->C)
-		kzfree(drbg->C);
+	kzfree(drbg->C);
 	drbg->C = NULL;
-	if (drbg->scratchpad)
-		kzfree(drbg->scratchpad);
+	kzfree(drbg->scratchpad);
 	drbg->scratchpad = NULL;
 	drbg->reseed_ctr = 0;
 #ifdef CONFIG_CRYPTO_FIPS
-	if (drbg->prev)
-		kzfree(drbg->prev);
+	kzfree(drbg->prev);
 	drbg->prev = NULL;
 	drbg->fips_primed = false;
 #endif
@@ -1295,8 +1290,7 @@ static int drbg_make_shadow(struct drbg_state *drbg, struct drbg_state **shadow)
 	return 0;
 
 err:
-	if (tmp)
-		kzfree(tmp);
+	kzfree(tmp);
 	return ret;
 }
 
-- 
1.9.3
