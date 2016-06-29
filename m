From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 4/8] crypto: rsa-pkcs1pad - Require hash to be present
Date: Wed, 29 Jun 2016 18:29:16 +0800
Message-ID: <E1bICk8-000734-5d@gondolin.me.apana.org.au>
References: <20160629102649.GA26987@gondor.apana.org.au>
To: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	Stephan Mueller <smueller@chronox.de>,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	Denis Kenzior <denkenz@gmail.com>,
	Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:33947 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbcF2K3T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Jun 2016 06:29:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The only user of rsa-pkcs1pad always uses the hash so there is
no reason to support the case of not having a hash.

This patch also changes the digest info lookup so that it is
only done once during template instantiation rather than on each
operation.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/rsa-pkcs1pad.c |   83 ++++++++++++++++++--------------------------------
 1 file changed, 30 insertions(+), 53 deletions(-)

diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index ead8dc0..5c1c78e 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -92,13 +92,12 @@ static const struct rsa_asn1_template *rsa_lookup_asn1(const char *name)
 
 struct pkcs1pad_ctx {
 	struct crypto_akcipher *child;
-	const char *hash_name;
 	unsigned int key_size;
 };
 
 struct pkcs1pad_inst_ctx {
 	struct crypto_akcipher_spawn spawn;
-	const char *hash_name;
+	const struct rsa_asn1_template *digest_info;
 };
 
 struct pkcs1pad_request {
@@ -416,20 +415,16 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
-	const struct rsa_asn1_template *digest_info = NULL;
+	struct akcipher_instance *inst = akcipher_alg_instance(tfm);
+	struct pkcs1pad_inst_ctx *ictx = akcipher_instance_ctx(inst);
+	const struct rsa_asn1_template *digest_info = ictx->digest_info;
 	int err;
 	unsigned int ps_end, digest_size = 0;
 
 	if (!ctx->key_size)
 		return -EINVAL;
 
-	if (ctx->hash_name) {
-		digest_info = rsa_lookup_asn1(ctx->hash_name);
-		if (!digest_info)
-			return -EINVAL;
-
-		digest_size = digest_info->size;
-	}
+	digest_size = digest_info->size;
 
 	if (req->src_len + digest_size > ctx->key_size - 11)
 		return -EOVERFLOW;
@@ -462,10 +457,8 @@ static int pkcs1pad_sign(struct akcipher_request *req)
 	memset(req_ctx->in_buf + 1, 0xff, ps_end - 1);
 	req_ctx->in_buf[ps_end] = 0x00;
 
-	if (digest_info) {
-		memcpy(req_ctx->in_buf + ps_end + 1, digest_info->data,
-		       digest_info->size);
-	}
+	memcpy(req_ctx->in_buf + ps_end + 1, digest_info->data,
+	       digest_info->size);
 
 	pkcs1pad_sg_set_buf(req_ctx->in_sg, req_ctx->in_buf,
 			ctx->key_size - 1 - req->src_len, req->src);
@@ -499,7 +492,9 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
 	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct pkcs1pad_request *req_ctx = akcipher_request_ctx(req);
-	const struct rsa_asn1_template *digest_info;
+	struct akcipher_instance *inst = akcipher_alg_instance(tfm);
+	struct pkcs1pad_inst_ctx *ictx = akcipher_instance_ctx(inst);
+	const struct rsa_asn1_template *digest_info = ictx->digest_info;
 	unsigned int pos;
 
 	if (err == -EOVERFLOW)
@@ -527,17 +522,11 @@ static int pkcs1pad_verify_complete(struct akcipher_request *req, int err)
 		goto done;
 	pos++;
 
-	if (ctx->hash_name) {
-		digest_info = rsa_lookup_asn1(ctx->hash_name);
-		if (!digest_info)
-			goto done;
+	if (memcmp(req_ctx->out_buf + pos, digest_info->data,
+		   digest_info->size))
+		goto done;
 
-		if (memcmp(req_ctx->out_buf + pos, digest_info->data,
-			   digest_info->size))
-			goto done;
-
-		pos += digest_info->size;
-	}
+	pos += digest_info->size;
 
 	err = 0;
 
@@ -626,12 +615,11 @@ static int pkcs1pad_init_tfm(struct crypto_akcipher *tfm)
 	struct pkcs1pad_ctx *ctx = akcipher_tfm_ctx(tfm);
 	struct crypto_akcipher *child_tfm;
 
-	child_tfm = crypto_spawn_akcipher(akcipher_instance_ctx(inst));
+	child_tfm = crypto_spawn_akcipher(&ictx->spawn);
 	if (IS_ERR(child_tfm))
 		return PTR_ERR(child_tfm);
 
 	ctx->child = child_tfm;
-	ctx->hash_name = ictx->hash_name;
 	return 0;
 }
 
@@ -648,12 +636,12 @@ static void pkcs1pad_free(struct akcipher_instance *inst)
 	struct crypto_akcipher_spawn *spawn = &ctx->spawn;
 
 	crypto_drop_akcipher(spawn);
-	kfree(ctx->hash_name);
 	kfree(inst);
 }
 
 static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 {
+	const struct rsa_asn1_template *digest_info;
 	struct crypto_attr_type *algt;
 	struct akcipher_instance *inst;
 	struct pkcs1pad_inst_ctx *ctx;
@@ -676,7 +664,11 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	hash_name = crypto_attr_alg_name(tb[2]);
 	if (IS_ERR(hash_name))
-		hash_name = NULL;
+		return PTR_ERR(hash_name);
+
+	digest_info = rsa_lookup_asn1(hash_name);
+	if (!digest_info)
+		return -EINVAL;
 
 	inst = kzalloc(sizeof(*inst) + sizeof(*ctx), GFP_KERNEL);
 	if (!inst)
@@ -684,7 +676,7 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	ctx = akcipher_instance_ctx(inst);
 	spawn = &ctx->spawn;
-	ctx->hash_name = hash_name ? kstrdup(hash_name, GFP_KERNEL) : NULL;
+	ctx->digest_info = digest_info;
 
 	crypto_set_spawn(&spawn->base, akcipher_crypto_instance(inst));
 	err = crypto_grab_akcipher(spawn, rsa_alg_name, 0,
@@ -696,27 +688,14 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = -ENAMETOOLONG;
 
-	if (!hash_name) {
-		if (snprintf(inst->alg.base.cra_name,
-			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s)",
-			     rsa_alg->base.cra_name) >=
-					CRYPTO_MAX_ALG_NAME ||
-		    snprintf(inst->alg.base.cra_driver_name,
-			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s)",
-			     rsa_alg->base.cra_driver_name) >=
-					CRYPTO_MAX_ALG_NAME)
+	if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
+		     "pkcs1pad(%s,%s)", rsa_alg->base.cra_name, hash_name) >=
+	    CRYPTO_MAX_ALG_NAME ||
+	    snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
+		     "pkcs1pad(%s,%s)",
+		     rsa_alg->base.cra_driver_name, hash_name) >=
+	    CRYPTO_MAX_ALG_NAME)
 		goto out_drop_alg;
-	} else {
-		if (snprintf(inst->alg.base.cra_name,
-			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s,%s)",
-			     rsa_alg->base.cra_name, hash_name) >=
-				CRYPTO_MAX_ALG_NAME ||
-		    snprintf(inst->alg.base.cra_driver_name,
-			     CRYPTO_MAX_ALG_NAME, "pkcs1pad(%s,%s)",
-			     rsa_alg->base.cra_driver_name, hash_name) >=
-					CRYPTO_MAX_ALG_NAME)
-		goto out_free_hash;
-	}
 
 	inst->alg.base.cra_flags = rsa_alg->base.cra_flags & CRYPTO_ALG_ASYNC;
 	inst->alg.base.cra_priority = rsa_alg->base.cra_priority;
@@ -738,12 +717,10 @@ static int pkcs1pad_create(struct crypto_template *tmpl, struct rtattr **tb)
 
 	err = akcipher_register_instance(tmpl, inst);
 	if (err)
-		goto out_free_hash;
+		goto out_drop_alg;
 
 	return 0;
 
-out_free_hash:
-	kfree(ctx->hash_name);
 out_drop_alg:
 	crypto_drop_akcipher(spawn);
 out_free_inst:
