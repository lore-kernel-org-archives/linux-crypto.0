From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/14] crypto: aead - Propagate new AEAD implementation flag for IV generators
Date: Thu, 09 Jul 2015 07:17:23 +0800
Message-ID: <E1ZCyah-0007Z7-PP@gondolin.me.apana.org.au>
References: <20150708231330.GA28797@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44779 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbbGHXR1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Jul 2015 19:17:27 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1ZCyai-0005Ef-Jc
	for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2015 09:17:24 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch allows the CRYPTO_ALG_AEAD_NEW flag to be propagated.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index 8cd45a7..1a5b118 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -604,7 +604,7 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 		return ERR_CAST(algt);
 
 	if ((algt->type ^ (CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_GENIV)) &
-	    algt->mask)
+	    algt->mask & ~CRYPTO_ALG_AEAD_NEW)
 		return ERR_PTR(-EINVAL);
 
 	name = crypto_attr_alg_name(tb[1]);
@@ -683,7 +683,8 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_drop_alg;
 
-	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags &
+				   (CRYPTO_ALG_ASYNC | CRYPTO_ALG_AEAD_NEW);
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
