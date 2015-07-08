From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4/14] crypto: cryptd - Propagate new AEAD implementation flag
Date: Thu, 09 Jul 2015 07:17:19 +0800
Message-ID: <E1ZCyad-0007YA-Kt@gondolin.me.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:53676 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbbGHXRY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:17:24 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZCyaf-0005E3-AN
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2015 09:17:21 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch allows the CRYPTO_ALG_AEAD_NEW flag to be propagated.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/cryptd.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 2f833dc..360ee85 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -176,10 +176,9 @@ static inline void cryptd_check_internal(struct rtattr **tb, u32 *type,
 	algt = crypto_get_attr_type(tb);
 	if (IS_ERR(algt))
 		return;
-	if ((algt->type & CRYPTO_ALG_INTERNAL))
-		*type |= CRYPTO_ALG_INTERNAL;
-	if ((algt->mask & CRYPTO_ALG_INTERNAL))
-		*mask |= CRYPTO_ALG_INTERNAL;
+
+	*type |= algt->type & (CRYPTO_ALG_INTERNAL | CRYPTO_ALG_AEAD_NEW);
+	*mask |= algt->mask & (CRYPTO_ALG_INTERNAL | CRYPTO_ALG_AEAD_NEW);
 }
 
 static int cryptd_blkcipher_setkey(struct crypto_ablkcipher *parent,
@@ -806,7 +805,9 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 		goto out_drop_aead;
 
 	inst->alg.base.cra_flags = CRYPTO_ALG_ASYNC |
-				   (alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
+				   (alg->base.cra_flags &
+				    (CRYPTO_ALG_INTERNAL |
+				     CRYPTO_ALG_AEAD_NEW));
 	inst->alg.base.cra_ctxsize = sizeof(struct cryptd_aead_ctx);
 
 	inst->alg.ivsize = crypto_aead_alg_ivsize(alg);
