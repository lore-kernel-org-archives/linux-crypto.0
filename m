From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 15/15] crypto: algif_rng - Remove obsolete const-removal cast
Date: Mon, 20 Apr 2015 13:39:18 +0800
Message-ID: <E1Yk4QQ-0004sR-Kb@gondolin.me.apana.org.au>
References: <20150420053515.GA18444@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38947 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295AbbDTFjX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Apr 2015 01:39:23 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yk4QS-0003Hm-5v
	for <linux-crypto@vger.kernel.org>; Mon, 20 Apr 2015 15:39:20 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that crypto_rng_reset takes a const argument, we no longer
need to cast away the const qualifier.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/algif_rng.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
index a346173..2a6c59c 100644
--- a/crypto/algif_rng.c
+++ b/crypto/algif_rng.c
@@ -164,7 +164,7 @@ static int rng_setkey(void *private, const u8 *seed, unsigned int seedlen)
 	 * Check whether seedlen is of sufficient size is done in RNG
 	 * implementations.
 	 */
-	return crypto_rng_reset(private, (u8 *)seed, seedlen);
+	return crypto_rng_reset(private, seed, seedlen);
 }
 
 static const struct af_alg_type algif_type_rng = {
