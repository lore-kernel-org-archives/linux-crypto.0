From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/8] crypto: aead - Do not set cra_type for new style instances
Date: Sat, 23 May 2015 15:41:53 +0800
Message-ID: <E1Yw449-0003sk-IB@gondolin.me.apana.org.au>
References: <20150523074058.GA14781@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:42383 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218AbbEWHl5 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 23 May 2015 03:41:57 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1Yw449-000338-VQ
	for <linux-crypto@vger.kernel.org>; Sat, 23 May 2015 17:41:54 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The function aead_geniv_alloc currently sets cra_type even for
new style instances.  This is unnecessary and may hide bugs such
as when our caller uses crypto_register_instance instead of the
correct aead_register_instance.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index a6385bd..070e4b9 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -468,12 +468,10 @@ struct aead_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	    CRYPTO_MAX_ALG_NAME)
 		goto err_drop_alg;
 
-	inst->alg.base.cra_flags = CRYPTO_ALG_TYPE_AEAD;
-	inst->alg.base.cra_flags |= alg->base.cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = alg->base.cra_priority;
 	inst->alg.base.cra_blocksize = alg->base.cra_blocksize;
 	inst->alg.base.cra_alignmask = alg->base.cra_alignmask;
-	inst->alg.base.cra_type = &crypto_new_aead_type;
 
 	inst->alg.ivsize = ivsize;
 	inst->alg.maxauthsize = maxauthsize;
