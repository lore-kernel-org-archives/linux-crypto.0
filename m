From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/3] [CRYPTO] all: Add crypto_require_sync to fix ASYNC mask calculation
Date: Fri, 14 Dec 2007 22:46:33 +0800
Message-ID: <E1J3Bo9-0004wN-00@gondolin.me.apana.org.au>
References: <20071214144317.GA18890@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4865 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753228AbXLNOqh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Dec 2007 09:46:37 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J3BoA-000589-F8
	for <linux-crypto@vger.kernel.org>; Sat, 15 Dec 2007 01:46:34 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] all: Add crypto_require_sync to fix ASYNC mask calculation

Previously the user-requested ASYNC mask was calculated as

	(type ^ CRYPTO_ALG_ASYNC) & mask

This is incorrect as bits in the mask other than CRYPTO_ALG_ASYNC may
be included in the result.  The correct expression is

	(type ^ CRYPTO_ALG_ASYNC) & mask & CRYPTO_ALG_ASYNC

This patch introduces the function crypto_require_sync to do this and
changes all the spots that did the calculation by hand to call it.

This patch also changes authenc to set its ASYNC status depending on
the ASYNC status of the underlying skcipher.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/aead.c           |    2 +-
 crypto/authenc.c        |    7 ++++---
 crypto/blkcipher.c      |    2 +-
 crypto/ccm.c            |    6 +++---
 crypto/chainiv.c        |    3 +--
 crypto/gcm.c            |    4 ++--
 include/crypto/algapi.h |    9 +++++++++
 7 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/crypto/aead.c b/crypto/aead.c
index c43fa81..4a62ea7 100644
--- a/crypto/aead.c
+++ b/crypto/aead.c
@@ -239,7 +239,7 @@ struct crypto_instance *aead_geniv_alloc(struct crypto_template *tmpl,
 	spawn = crypto_instance_ctx(inst);
 
 	/* Ignore async algorithms if necessary. */
-	mask |= (algt->type ^ CRYPTO_ALG_ASYNC) & algt->mask;
+	mask |= crypto_requires_sync(algt->type, algt->mask);
 
 	crypto_set_aead_spawn(spawn, inst);
 	err = crypto_grab_nivaead(spawn, name, type, mask);
diff --git a/crypto/authenc.c b/crypto/authenc.c
index caa0853..ed8ac5a 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -400,8 +400,8 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 
 	crypto_set_skcipher_spawn(&ctx->enc, inst);
 	err = crypto_grab_skcipher(&ctx->enc, enc_name, 0,
-				   (algt->type ^ CRYPTO_ALG_ASYNC) &
-				   algt->mask);
+				   crypto_requires_sync(algt->type,
+							algt->mask));
 	if (err)
 		goto err_drop_auth;
 
@@ -418,7 +418,8 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 		     enc->cra_driver_name) >= CRYPTO_MAX_ALG_NAME)
 		goto err_drop_enc;
 
-	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD | CRYPTO_ALG_ASYNC;
+	inst->alg.cra_flags = CRYPTO_ALG_TYPE_AEAD;
+	inst->alg.cra_flags |= enc->cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.cra_priority = enc->cra_priority * 10 + auth->cra_priority;
 	inst->alg.cra_blocksize = enc->cra_blocksize;
 	inst->alg.cra_alignmask = auth->cra_alignmask | enc->cra_alignmask;
diff --git a/crypto/blkcipher.c b/crypto/blkcipher.c
index 88407e5..4a7e65c 100644
--- a/crypto/blkcipher.c
+++ b/crypto/blkcipher.c
@@ -576,7 +576,7 @@ struct crypto_instance *skcipher_geniv_alloc(struct crypto_template *tmpl,
 	spawn = crypto_instance_ctx(inst);
 
 	/* Ignore async algorithms if necessary. */
-	mask |= (algt->type ^ CRYPTO_ALG_ASYNC) & algt->mask;
+	mask |= crypto_requires_sync(algt->type, algt->mask);
 
 	crypto_set_skcipher_spawn(spawn, inst);
 	err = crypto_grab_nivcipher(spawn, name, type, mask);
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 44eff9e..7ca2519 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -494,8 +494,8 @@ static struct crypto_instance *crypto_ccm_alloc_common(struct rtattr **tb,
 
 	crypto_set_skcipher_spawn(&ictx->ctr, inst);
 	err = crypto_grab_skcipher(&ictx->ctr, ctr_name, 0,
-				   (algt->type ^ CRYPTO_ALG_ASYNC) &
-				   algt->mask);
+				   crypto_requires_sync(algt->type,
+							algt->mask));
 	if (err)
 		goto err_drop_cipher;
 
@@ -744,7 +744,7 @@ static struct crypto_instance *crypto_rfc4309_alloc(struct rtattr **tb)
 	spawn = crypto_instance_ctx(inst);
 	crypto_set_aead_spawn(spawn, inst);
 	err = crypto_grab_aead(spawn, ccm_name, 0,
-			       (algt->type ^ CRYPTO_ALG_ASYNC) & algt->mask);
+			       crypto_requires_sync(algt->type, algt->mask));
 	if (err)
 		goto out_free_inst;
 
diff --git a/crypto/chainiv.c b/crypto/chainiv.c
index 0bdb212..d17fa04 100644
--- a/crypto/chainiv.c
+++ b/crypto/chainiv.c
@@ -289,8 +289,7 @@ static struct crypto_instance *chainiv_alloc(struct rtattr **tb)
 
 	inst->alg.cra_ctxsize = sizeof(struct chainiv_ctx);
 
-	if (!((algt->type ^ CRYPTO_ALG_ASYNC) & algt->mask &
-	      CRYPTO_ALG_ASYNC)) {
+	if (!crypto_requires_sync(algt->type, algt->mask)) {
 		inst->alg.cra_flags |= CRYPTO_ALG_ASYNC;
 
 		inst->alg.cra_ablkcipher.givencrypt =
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 6c08587..6f23f02 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -469,8 +469,8 @@ static struct crypto_instance *crypto_gcm_alloc_common(struct rtattr **tb,
 	ctx = crypto_instance_ctx(inst);
 	crypto_set_skcipher_spawn(&ctx->ctr, inst);
 	err = crypto_grab_skcipher(&ctx->ctr, ctr_name, 0,
-				   (algt->type ^ CRYPTO_ALG_ASYNC) &
-				   algt->mask);
+				   crypto_requires_sync(algt->type,
+							algt->mask));
 	if (err)
 		goto err_free_inst;
 
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index e4e3792..60d06e7 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -305,5 +305,14 @@ static inline struct crypto_alg *crypto_get_attr_alg(struct rtattr **tb,
 	return crypto_attr_alg(tb[1], type, mask);
 }
 
+/*
+ * Returns CRYPTO_ALG_ASYNC if type/mask requires the use of sync algorithms.
+ * Otherwise returns zero.
+ */
+static inline int crypto_requires_sync(u32 type, u32 mask)
+{
+	return (type ^ CRYPTO_ALG_ASYNC) & mask & CRYPTO_ALG_ASYNC;
+}
+
 #endif	/* _CRYPTO_ALGAPI_H */
 
