From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/28] crypto: authenc - Consider ahash ASYNC bit
Date: Wed, 29 Jun 2016 18:03:46 +0800
Message-ID: <E1bICLS-0006qw-2H@gondolin.me.apana.org.au>
References: <20160629100223.GA26260@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41489 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbcF2KDt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:03:49 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bICLS-0005Er-6V
	for <linux-crypto@vger.kernel.org>; Wed, 29 Jun 2016 20:03:46 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

As it is, if you get an async ahash with a sync skcipher you'll
end up with a sync authenc, which is wrong.

This patch fixes it by considering the ASYNC bit from ahash as
well.

It also fixes a little bug where if a sync version of authenc
is requested we may still end up using an async ahash.

Neither of them should have any effect as none of the authenc
users can request for a sync authenc.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c    |    6 ++++--
 crypto/authencesn.c |    6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index 55a354d..f22b2e7 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -397,7 +397,8 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 		return -EINVAL;
 
 	auth = ahash_attr_alg(tb[1], CRYPTO_ALG_TYPE_HASH,
-			       CRYPTO_ALG_TYPE_AHASH_MASK);
+			      CRYPTO_ALG_TYPE_AHASH_MASK |
+			      crypto_requires_sync(algt->type, algt->mask));
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
 
@@ -443,7 +444,8 @@ static int crypto_authenc_create(struct crypto_template *tmpl,
 		     enc->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_drop_enc;
 
-	inst->alg.base.cra_flags = enc->cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = (auth_base->cra_flags | enc->cra_flags) &
+				   CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = enc->cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->cra_blocksize;
diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index 0c04688..0662b18 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -413,7 +413,8 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 		return -EINVAL;
 
 	auth = ahash_attr_alg(tb[1], CRYPTO_ALG_TYPE_HASH,
-			       CRYPTO_ALG_TYPE_AHASH_MASK);
+			      CRYPTO_ALG_TYPE_AHASH_MASK |
+			      crypto_requires_sync(algt->type, algt->mask));
 	if (IS_ERR(auth))
 		return PTR_ERR(auth);
 
@@ -456,7 +457,8 @@ static int crypto_authenc_esn_create(struct crypto_template *tmpl,
 		     enc->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_drop_enc;
 
-	inst->alg.base.cra_flags = enc->cra_flags & CRYPTO_ALG_ASYNC;
+	inst->alg.base.cra_flags = (auth_base->cra_flags | enc->cra_flags) &
+				   CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = enc->cra_priority * 10 +
 				      auth_base->cra_priority;
 	inst->alg.base.cra_blocksize = enc->cra_blocksize;
