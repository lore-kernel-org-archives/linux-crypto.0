Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B035F19D8BC
	for <linux-crypto@vger.kernel.org>; Mon,  5 May 2025 12:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746448378; cv=none; b=RtLOrBOzd0VJ0VoUEc6+URXf4wtG6ZhRLxcw+4JTNOntMbELqBvH5w0b/AZ2ObYUvIzNJOuGelB5I7SaeHEPmvP+/T3FbNs/tFlIv7wfWw89NhhIpcB9NjPYT6TNzZ4J9TmXqsYNN8jAwvFdW/QrmjdZOFBPhuzh/NIwuRdFqA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746448378; c=relaxed/simple;
	bh=lNocnCYF2AWOvURZmMCNj2y0E1NhG0V416Lfm6Yv/gU=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=U3KnJdtWF/t71YaOJ5CGubFNaHVcO40BejNcIeSuDQygfO/RhCW+tdEZ/oxkklXj1gA8lkRhqSIE391bZqm0itQDIRxcaYVzIyH67kPjIyuOTkggIdmTGOhN9cXWf5GG66mdS+IZV58I/zOs0n4/8kR2YMdlx5wSSW/JzOtI0Jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gLinxCU8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gLinxCU8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=N88lLH6gcdrw0kWSh2Sy2mKFUyXffOkdByVyHMrf4Tk=; b=gLinxCU86jEC66OM9KGSJfS8ai
	mvSmm4185QeRYuidEIJV6pIIxQ5CxCEFKRWYx27GR1W5Q5x6/Irq9JHaex4oPRoZJAuUJnKAAvneZ
	Z1dYwa3UQrq4GrSKlCysGFFtaQ7bMXFHz/dfODUZQZ4koYCQ0KBOV/vtOf0bIX0aETV83VnGT+Yx3
	47KgWtk5fjcXVw5aaZS1Wi9dctf1rZi/EpKikVqJaqZklBUSa6OWe70REycrraPzB8jzAnBHtzaeX
	6xpPCjveFfvYzh6+syPurdYtStChOqkTqHWOOeKlqbdPJuoqFuzhPI7ooEdvqtpfT7hU7piLM/sxX
	MNhfHiMA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uBv07-003YOa-2B;
	Mon, 05 May 2025 20:32:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 05 May 2025 20:32:51 +0800
Date: Mon, 05 May 2025 20:32:51 +0800
Message-Id: <f67cc874594fd2cc873667530c83e239ae09db81.1746448291.git.herbert@gondor.apana.org.au>
In-Reply-To: <1bdf0bc9343ad20885076a17c5c720acfd4a2547.1746448291.git.herbert@gondor.apana.org.au>
References: <1bdf0bc9343ad20885076a17c5c720acfd4a2547.1746448291.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6/6] crypto: hmac - Add ahash support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Add ahash support to hmac so that drivers that can't do hmac in
hardware do not have to implement duplicate copies of hmac.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c                 |  10 +-
 crypto/hmac.c                  | 318 +++++++++++++++++++++++++++++++--
 include/crypto/hash.h          |   3 +-
 include/crypto/internal/hash.h |   9 +
 4 files changed, 326 insertions(+), 14 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index ec246cc37619..ae3eac5c7c97 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -845,7 +845,7 @@ int crypto_has_ahash(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_has_ahash);
 
-static bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
+bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
 {
 	struct crypto_alg *alg = &halg->base;
 
@@ -854,6 +854,7 @@ static bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg)
 
 	return __crypto_ahash_alg(alg)->setkey != ahash_nosetkey;
 }
+EXPORT_SYMBOL_GPL(crypto_hash_alg_has_setkey);
 
 struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *hash)
 {
@@ -1060,5 +1061,12 @@ int crypto_hash_digest(struct crypto_ahash *tfm, const u8 *data,
 }
 EXPORT_SYMBOL_GPL(crypto_hash_digest);
 
+void ahash_free_singlespawn_instance(struct ahash_instance *inst)
+{
+	crypto_drop_spawn(ahash_instance_ctx(inst));
+	kfree(inst);
+}
+EXPORT_SYMBOL_GPL(ahash_free_singlespawn_instance);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 4517e04bfbaa..c9c635e48250 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -26,6 +26,12 @@ struct hmac_ctx {
 	u8 pads[];
 };
 
+struct ahash_hmac_ctx {
+	struct crypto_ahash *hash;
+	/* Contains 'u8 ipad[statesize];', then 'u8 opad[statesize];' */
+	u8 pads[];
+};
+
 static int hmac_setkey(struct crypto_shash *parent,
 		       const u8 *inkey, unsigned int keylen)
 {
@@ -157,21 +163,17 @@ static void hmac_exit_tfm(struct crypto_shash *parent)
 	crypto_free_shash(tctx->hash);
 }
 
-static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
+static int hmac_create_shash(struct crypto_template *tmpl, struct rtattr **tb,
+			     u32 mask)
 {
 	struct shash_instance *inst;
 	struct crypto_shash_spawn *spawn;
 	struct crypto_alg *alg;
 	struct shash_alg *salg;
-	u32 mask;
 	int err;
 	int ds;
 	int ss;
 
-	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SHASH, &mask);
-	if (err)
-		return err;
-
 	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
 	if (!inst)
 		return -ENOMEM;
@@ -226,20 +228,312 @@ static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	return err;
 }
 
-static struct crypto_template hmac_tmpl = {
-	.name = "hmac",
-	.create = hmac_create,
-	.module = THIS_MODULE,
+static int hmac_setkey_ahash(struct crypto_ahash *parent,
+			     const u8 *inkey, unsigned int keylen)
+{
+	struct ahash_hmac_ctx *tctx = crypto_ahash_ctx(parent);
+	struct crypto_ahash *fb = crypto_ahash_fb(tctx->hash);
+	int ds = crypto_ahash_digestsize(parent);
+	int bs = crypto_ahash_blocksize(parent);
+	int ss = crypto_ahash_statesize(parent);
+	HASH_REQUEST_ON_STACK(req, fb);
+	u8 *opad = &tctx->pads[ss];
+	u8 *ipad = &tctx->pads[0];
+	int err, i;
+
+	if (fips_enabled && (keylen < 112 / 8))
+		return -EINVAL;
+
+	ahash_request_set_callback(req, 0, NULL, NULL);
+
+	if (keylen > bs) {
+		ahash_request_set_virt(req, inkey, ipad, keylen);
+		err = crypto_ahash_digest(req);
+		if (err)
+			goto out_zero_req;
+
+		keylen = ds;
+	} else
+		memcpy(ipad, inkey, keylen);
+
+	memset(ipad + keylen, 0, bs - keylen);
+	memcpy(opad, ipad, bs);
+
+	for (i = 0; i < bs; i++) {
+		ipad[i] ^= HMAC_IPAD_VALUE;
+		opad[i] ^= HMAC_OPAD_VALUE;
+	}
+
+	ahash_request_set_virt(req, ipad, NULL, bs);
+	err = crypto_ahash_init(req) ?:
+	      crypto_ahash_update(req) ?:
+	      crypto_ahash_export(req, ipad);
+
+	ahash_request_set_virt(req, opad, NULL, bs);
+	err = err ?:
+	      crypto_ahash_init(req) ?:
+	      crypto_ahash_update(req) ?:
+	      crypto_ahash_export(req, opad);
+
+out_zero_req:
+	HASH_REQUEST_ZERO(req);
+	return err;
+}
+
+static int hmac_export_ahash(struct ahash_request *preq, void *out)
+{
+	return crypto_ahash_export(ahash_request_ctx(preq), out);
+}
+
+static int hmac_import_ahash(struct ahash_request *preq, const void *in)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(preq);
+	struct ahash_hmac_ctx *tctx = crypto_ahash_ctx(tfm);
+	struct ahash_request *req = ahash_request_ctx(preq);
+
+	ahash_request_set_tfm(req, tctx->hash);
+	return crypto_ahash_import(req, in);
+}
+
+static int hmac_init_ahash(struct ahash_request *preq)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(preq);
+	struct ahash_hmac_ctx *tctx = crypto_ahash_ctx(tfm);
+
+	return hmac_import_ahash(preq, &tctx->pads[0]);
+}
+
+static int hmac_update_ahash(struct ahash_request *preq)
+{
+	struct ahash_request *req = ahash_request_ctx(preq);
+
+	ahash_request_set_callback(req, ahash_request_flags(preq),
+				   preq->base.complete, preq->base.data);
+	if (ahash_request_isvirt(preq))
+		ahash_request_set_virt(req, preq->svirt, NULL, preq->nbytes);
+	else
+		ahash_request_set_crypt(req, preq->src, NULL, preq->nbytes);
+	return crypto_ahash_update(req);
+}
+
+static int hmac_finup_finish(struct ahash_request *preq, unsigned int mask)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(preq);
+	struct ahash_request *req = ahash_request_ctx(preq);
+	struct ahash_hmac_ctx *tctx = crypto_ahash_ctx(tfm);
+	int ds = crypto_ahash_digestsize(tfm);
+	int ss = crypto_ahash_statesize(tfm);
+	const u8 *opad = &tctx->pads[ss];
+
+	ahash_request_set_callback(req, ahash_request_flags(preq) & ~mask,
+				   preq->base.complete, preq->base.data);
+	ahash_request_set_virt(req, preq->result, preq->result, ds);
+	return crypto_ahash_import(req, opad) ?:
+	       crypto_ahash_finup(req);
+
+}
+
+static void hmac_finup_done(void *data, int err)
+{
+	struct ahash_request *preq = data;
+
+	if (err)
+		goto out;
+
+	err = hmac_finup_finish(preq, CRYPTO_TFM_REQ_MAY_SLEEP);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		return;
+
+out:
+	ahash_request_complete(preq, err);
+}
+
+static int hmac_finup_ahash(struct ahash_request *preq)
+{
+	struct ahash_request *req = ahash_request_ctx(preq);
+
+	ahash_request_set_callback(req, ahash_request_flags(preq),
+				   hmac_finup_done, preq);
+	if (ahash_request_isvirt(preq))
+		ahash_request_set_virt(req, preq->svirt, preq->result,
+				       preq->nbytes);
+	else
+		ahash_request_set_crypt(req, preq->src, preq->result,
+					preq->nbytes);
+	return crypto_ahash_finup(req) ?:
+	       hmac_finup_finish(preq, 0);
+}
+
+static int hmac_digest_ahash(struct ahash_request *preq)
+{
+	return hmac_init_ahash(preq) ?:
+	       hmac_finup_ahash(preq);
+}
+
+static int hmac_init_ahash_tfm(struct crypto_ahash *parent)
+{
+	struct ahash_instance *inst = ahash_alg_instance(parent);
+	struct ahash_hmac_ctx *tctx = crypto_ahash_ctx(parent);
+	struct crypto_ahash *hash;
+
+	hash = crypto_spawn_ahash(ahash_instance_ctx(inst));
+	if (IS_ERR(hash))
+		return PTR_ERR(hash);
+
+	if (crypto_ahash_reqsize(parent) < sizeof(struct ahash_request) +
+					   crypto_ahash_reqsize(hash))
+		return -EINVAL;
+
+	tctx->hash = hash;
+	return 0;
+}
+
+static int hmac_clone_ahash_tfm(struct crypto_ahash *dst,
+				struct crypto_ahash *src)
+{
+	struct ahash_hmac_ctx *sctx = crypto_ahash_ctx(src);
+	struct ahash_hmac_ctx *dctx = crypto_ahash_ctx(dst);
+	struct crypto_ahash *hash;
+
+	hash = crypto_clone_ahash(sctx->hash);
+	if (IS_ERR(hash))
+		return PTR_ERR(hash);
+
+	dctx->hash = hash;
+	return 0;
+}
+
+static void hmac_exit_ahash_tfm(struct crypto_ahash *parent)
+{
+	struct ahash_hmac_ctx *tctx = crypto_ahash_ctx(parent);
+
+	crypto_free_ahash(tctx->hash);
+}
+
+static int __hmac_create_ahash(struct crypto_template *tmpl,
+			       struct rtattr **tb, u32 mask)
+{
+	struct crypto_ahash_spawn *spawn;
+	struct ahash_instance *inst;
+	struct crypto_alg *alg;
+	struct hash_alg_common *halg;
+	int ds, ss, err;
+
+	inst = kzalloc(sizeof(*inst) + sizeof(*spawn), GFP_KERNEL);
+	if (!inst)
+		return -ENOMEM;
+	spawn = ahash_instance_ctx(inst);
+
+	err = crypto_grab_ahash(spawn, ahash_crypto_instance(inst),
+				crypto_attr_alg_name(tb[1]), 0, mask);
+	if (err)
+		goto err_free_inst;
+	halg = crypto_spawn_ahash_alg(spawn);
+	alg = &halg->base;
+
+	/* The underlying hash algorithm must not require a key */
+	err = -EINVAL;
+	if (crypto_hash_alg_needs_key(halg))
+		goto err_free_inst;
+
+	ds = halg->digestsize;
+	ss = halg->statesize;
+	if (ds > alg->cra_blocksize || ss < alg->cra_blocksize)
+		goto err_free_inst;
+
+	err = crypto_inst_setname(ahash_crypto_instance(inst), "hmac",
+				  "hmac-ahash", alg);
+	if (err)
+		goto err_free_inst;
+
+	inst->alg.halg.base.cra_flags = alg->cra_flags &
+					CRYPTO_ALG_INHERITED_FLAGS;
+	inst->alg.halg.base.cra_flags |= CRYPTO_ALG_REQ_VIRT;
+	inst->alg.halg.base.cra_priority = alg->cra_priority + 100;
+	inst->alg.halg.base.cra_blocksize = alg->cra_blocksize;
+	inst->alg.halg.base.cra_ctxsize = sizeof(struct ahash_hmac_ctx) +
+					  (ss * 2);
+	inst->alg.halg.base.cra_reqsize = sizeof(struct ahash_request) +
+					  alg->cra_reqsize;
+
+	inst->alg.halg.digestsize = ds;
+	inst->alg.halg.statesize = ss;
+	inst->alg.init = hmac_init_ahash;
+	inst->alg.update = hmac_update_ahash;
+	inst->alg.finup = hmac_finup_ahash;
+	inst->alg.digest = hmac_digest_ahash;
+	inst->alg.export = hmac_export_ahash;
+	inst->alg.import = hmac_import_ahash;
+	inst->alg.setkey = hmac_setkey_ahash;
+	inst->alg.init_tfm = hmac_init_ahash_tfm;
+	inst->alg.clone_tfm = hmac_clone_ahash_tfm;
+	inst->alg.exit_tfm = hmac_exit_ahash_tfm;
+
+	inst->free = ahash_free_singlespawn_instance;
+
+	err = ahash_register_instance(tmpl, inst);
+	if (err) {
+err_free_inst:
+		ahash_free_singlespawn_instance(inst);
+	}
+	return err;
+}
+
+static int hmac_create(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	struct crypto_attr_type *algt;
+	u32 mask;
+
+	algt = crypto_get_attr_type(tb);
+	if (IS_ERR(algt))
+		return PTR_ERR(algt);
+
+	mask = crypto_algt_inherited_mask(algt);
+
+	if (!((algt->type ^ CRYPTO_ALG_TYPE_AHASH) &
+	      algt->mask & CRYPTO_ALG_TYPE_MASK))
+		return __hmac_create_ahash(tmpl, tb, mask);
+
+	if ((algt->type ^ CRYPTO_ALG_TYPE_SHASH) &
+	    algt->mask & CRYPTO_ALG_TYPE_MASK)
+		return -EINVAL;
+
+	return hmac_create_shash(tmpl, tb, mask);
+}
+
+static int hmac_create_ahash(struct crypto_template *tmpl, struct rtattr **tb)
+{
+	u32 mask;
+	int err;
+
+	err = crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_AHASH, &mask);
+	if (err)
+		return err == -EINVAL ? -ENOENT : err;
+
+	return __hmac_create_ahash(tmpl, tb, mask);
+}
+
+static struct crypto_template hmac_tmpls[] = {
+	{
+		.name = "hmac",
+		.create = hmac_create,
+		.module = THIS_MODULE,
+	},
+	{
+		.name = "hmac-ahash",
+		.create = hmac_create_ahash,
+		.module = THIS_MODULE,
+	},
 };
 
 static int __init hmac_module_init(void)
 {
-	return crypto_register_template(&hmac_tmpl);
+	return crypto_register_templates(hmac_tmpls, ARRAY_SIZE(hmac_tmpls));
 }
 
 static void __exit hmac_module_exit(void)
 {
-	crypto_unregister_template(&hmac_tmpl);
+	crypto_unregister_templates(hmac_tmpls, ARRAY_SIZE(hmac_tmpls));
 }
 
 module_init(hmac_module_init);
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 540e09ff395d..2d982995dd12 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -179,7 +179,8 @@ struct shash_desc {
  * containing a 'struct s390_sha_ctx'.
  */
 #define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
-#define MAX_SYNC_HASH_REQSIZE	HASH_MAX_DESCSIZE
+#define MAX_SYNC_HASH_REQSIZE	(sizeof(struct ahash_request) + \
+				 HASH_MAX_DESCSIZE)
 
 #define SHASH_DESC_ON_STACK(shash, ctx)					     \
 	char __##shash##_desc[sizeof(struct shash_desc) + HASH_MAX_DESCSIZE] \
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index ef5ea75ac5c8..519e2de4bfba 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -64,6 +64,7 @@ int crypto_register_ahashes(struct ahash_alg *algs, int count);
 void crypto_unregister_ahashes(struct ahash_alg *algs, int count);
 int ahash_register_instance(struct crypto_template *tmpl,
 			    struct ahash_instance *inst);
+void ahash_free_singlespawn_instance(struct ahash_instance *inst);
 
 int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
 		    unsigned int keylen);
@@ -73,12 +74,20 @@ static inline bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
 	return alg->setkey != shash_no_setkey;
 }
 
+bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg);
+
 static inline bool crypto_shash_alg_needs_key(struct shash_alg *alg)
 {
 	return crypto_shash_alg_has_setkey(alg) &&
 		!(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY);
 }
 
+static inline bool crypto_hash_alg_needs_key(struct hash_alg_common *alg)
+{
+	return crypto_hash_alg_has_setkey(alg) &&
+		!(alg->base.cra_flags & CRYPTO_ALG_OPTIONAL_KEY);
+}
+
 int crypto_grab_ahash(struct crypto_ahash_spawn *spawn,
 		      struct crypto_instance *inst,
 		      const char *name, u32 type, u32 mask);
-- 
2.39.5

