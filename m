Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70FA1A5B91
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 10:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744455447; cv=none; b=iMTxkV+UiVW/hAoRYJlGz6y/jCWRDpVmBqYG3wa+pFpNv1LSaz6iB3OyZ4IvO3v3y97Cl0uSsQoHHqA9SPWR72Ju+0Uch1zNekmWGIAgzbkfNMwzewRD40quCJlC+vN6zFZbFl7Vz/REe7EAB2ulX5OkrRoyPpULhu0XcmOJugk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744455447; c=relaxed/simple;
	bh=k6+SjRG37S53lEwB05RhSvAxUeTpw3PzILhb7t5TnnU=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=qUi+aQDyqG4V7LbHdDTHgNoAInWoOa8q7BmbZoZdXFALA1lTlgwlxE/DOyQ3BH06PaoXK28xlRuJIwOW1zyJU51kGjlPFGH6DpPU9zJ2RpAGdAlkuIA4RY1pKWpRyYnPY2pbXvPV/mum2aqRirQavyRDUaArzn0dTh78L7L5Wr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=AjmGFhE3; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="AjmGFhE3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=td/SuIyG8JRnrEC+a5l5TfO7hFYWZKV28xmSGmMz0e8=; b=AjmGFhE3/slgAjYj96OvCVazqV
	vio1T6hb0fhgpBpeOUJYSQDHxRVd62t4jb6yn32RG6qb1JsxGrZBLgJ/olHSKaJJTr+SgIfTBJrCd
	YnS3fppQu9IjIYlr+NWH8X7T2jNbeI9P6+fd4h+wAVCnP4aPkRKSX4TnbFuePhATifnILxy8yN3oU
	8ufQFBxG/qvmv2XoV64jwxkrn2Gq1xYHRj0wtZVWxdg7fTO7rFswGrqKhf0Y7OhDhksfz7859qsQt
	ufxsq1i+pFmuorAL3+tyY3ZR397PFlKR0P/IkoAkXtbyhqySWxWOLi4hcTI1/JaOjHcBwHXwO4jls
	WrpfYLeg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3YY3-00F5JW-37;
	Sat, 12 Apr 2025 18:57:21 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 18:57:19 +0800
Date: Sat, 12 Apr 2025 18:57:19 +0800
Message-Id: <120d42816e45cc1dcd172a50927736010731b29d.1744455146.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744455146.git.herbert@gondor.apana.org.au>
References: <cover.1744455146.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/8] crypto: hash - Add HASH_REQUEST_ON_STACK
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Allow any ahash to be used with a stack request, with optional
dynamic allocation when async is needed.  The intended usage is:

	HASH_REQUEST_ON_STACK(req, tfm);

	...
	err = crypto_ahash_digest(req);
	/* The request cannot complete synchronously. */
	if (err == -EAGAIN) {
		/* This will not fail. */
		req = HASH_REQUEST_CLONE(req, gfp);

		/* Redo operation. */
		err = crypto_ahash_digest(req);
	}

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c                 | 106 +++++++++++++++++++++++++++++++--
 include/crypto/hash.h          |  54 +++++++++++++----
 include/crypto/internal/hash.h |  26 +++++++-
 3 files changed, 171 insertions(+), 15 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 7c9c0931197f..7a74092323b9 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -300,6 +300,8 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 		int err;
 
 		err = alg->setkey(tfm, key, keylen);
+		if (!err && ahash_is_async(tfm))
+			err = crypto_ahash_setkey(tfm->fb, key, keylen);
 		if (unlikely(err)) {
 			ahash_set_needkey(tfm, alg);
 			return err;
@@ -473,6 +475,8 @@ int crypto_ahash_init(struct ahash_request *req)
 		return crypto_shash_init(prepare_shash_desc(req, tfm));
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
+	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
+		return -EAGAIN;
 	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->init);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_init);
@@ -520,6 +524,8 @@ int crypto_ahash_update(struct ahash_request *req)
 
 	if (likely(tfm->using_shash))
 		return shash_ahash_update(req, ahash_request_ctx(req));
+	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
+		return -EAGAIN;
 	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->update);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_update);
@@ -530,6 +536,8 @@ int crypto_ahash_final(struct ahash_request *req)
 
 	if (likely(tfm->using_shash))
 		return crypto_shash_final(ahash_request_ctx(req), req->result);
+	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
+		return -EAGAIN;
 	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->final);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_final);
@@ -540,6 +548,8 @@ int crypto_ahash_finup(struct ahash_request *req)
 
 	if (likely(tfm->using_shash))
 		return shash_ahash_finup(req, ahash_request_ctx(req));
+	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
+		return -EAGAIN;
 	if (!crypto_ahash_alg(tfm)->finup ||
 	    (!crypto_ahash_req_chain(tfm) && ahash_request_isvirt(req)))
 		return ahash_def_finup(req);
@@ -611,6 +621,8 @@ int crypto_ahash_digest(struct ahash_request *req)
 
 	if (likely(tfm->using_shash))
 		return shash_ahash_digest(req, prepare_shash_desc(req, tfm));
+	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
+		return -EAGAIN;
 	if (!crypto_ahash_req_chain(tfm) && ahash_request_isvirt(req))
 		return ahash_def_digest(req);
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
@@ -714,26 +726,63 @@ static void crypto_ahash_exit_tfm(struct crypto_tfm *tfm)
 	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
 
-	alg->exit_tfm(hash);
+	if (alg->exit_tfm)
+		alg->exit_tfm(hash);
+	else if (tfm->__crt_alg->cra_exit)
+		tfm->__crt_alg->cra_exit(tfm);
+
+	if (ahash_is_async(hash))
+		crypto_free_ahash(hash->fb);
 }
 
 static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 {
 	struct crypto_ahash *hash = __crypto_ahash_cast(tfm);
 	struct ahash_alg *alg = crypto_ahash_alg(hash);
+	struct crypto_ahash *fb = NULL;
+	int err;
 
 	crypto_ahash_set_statesize(hash, alg->halg.statesize);
 	crypto_ahash_set_reqsize(hash, crypto_tfm_alg_reqsize(tfm));
 
+	hash->fb = hash;
+
 	if (tfm->__crt_alg->cra_type == &crypto_shash_type)
 		return crypto_init_ahash_using_shash(tfm);
 
+	if (ahash_is_async(hash)) {
+		fb = crypto_alloc_ahash(crypto_ahash_alg_name(hash),
+					0, CRYPTO_ALG_ASYNC);
+		if (IS_ERR(fb))
+			return PTR_ERR(fb);
+
+		hash->fb = fb;
+	}
+
 	ahash_set_needkey(hash, alg);
 
-	if (alg->exit_tfm)
-		tfm->exit = crypto_ahash_exit_tfm;
+	tfm->exit = crypto_ahash_exit_tfm;
 
-	return alg->init_tfm ? alg->init_tfm(hash) : 0;
+	if (!alg->init_tfm) {
+		if (!tfm->__crt_alg->cra_init)
+			return 0;
+
+		err = tfm->__crt_alg->cra_init(tfm);
+		if (err)
+			goto out_free_sync_hash;
+
+		return 0;
+	}
+
+	err = alg->init_tfm(hash);
+	if (err)
+		goto out_free_sync_hash;
+
+	return 0;
+
+out_free_sync_hash:
+	crypto_free_ahash(fb);
+	return err;
 }
 
 static unsigned int crypto_ahash_extsize(struct crypto_alg *alg)
@@ -970,5 +1019,54 @@ int ahash_register_instance(struct crypto_template *tmpl,
 }
 EXPORT_SYMBOL_GPL(ahash_register_instance);
 
+void ahash_request_free(struct ahash_request *req)
+{
+	if (unlikely(!req))
+		return;
+
+	if (!ahash_req_on_stack(req)) {
+		kfree(req);
+		return;
+	}
+
+	ahash_request_zero(req);
+}
+EXPORT_SYMBOL_GPL(ahash_request_free);
+
+int crypto_hash_digest(struct crypto_ahash *tfm, const u8 *data,
+		       unsigned int len, u8 *out)
+{
+	HASH_REQUEST_ON_STACK(req, tfm->fb);
+	int err;
+
+	ahash_request_set_callback(req, 0, NULL, NULL);
+	ahash_request_set_virt(req, data, out, len);
+	err = crypto_ahash_digest(req);
+
+	ahash_request_zero(req);
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(crypto_hash_digest);
+
+struct ahash_request *ahash_request_clone(struct ahash_request *req,
+					  size_t total, gfp_t gfp)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ahash_request *nreq;
+
+	nreq = kmalloc(total, gfp);
+	if (!nreq) {
+		ahash_request_set_tfm(req, tfm->fb);
+		req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
+		return req;
+	}
+
+	memcpy(nreq, req, total);
+	ahash_request_set_tfm(req, tfm);
+	return req;
+}
+EXPORT_SYMBOL_GPL(ahash_request_clone);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 87518cf3b2d8..b00ea8407f9c 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -16,6 +16,9 @@
 /* Set this bit for virtual address instead of SG list. */
 #define CRYPTO_AHASH_REQ_VIRT	0x00000001
 
+#define CRYPTO_AHASH_REQ_PRIVATE \
+	CRYPTO_AHASH_REQ_VIRT
+
 struct crypto_ahash;
 
 /**
@@ -167,12 +170,22 @@ struct shash_desc {
  * containing a 'struct sha3_state'.
  */
 #define HASH_MAX_DESCSIZE	(sizeof(struct shash_desc) + 360)
+#define MAX_SYNC_HASH_REQSIZE	HASH_MAX_DESCSIZE
 
 #define SHASH_DESC_ON_STACK(shash, ctx)					     \
 	char __##shash##_desc[sizeof(struct shash_desc) + HASH_MAX_DESCSIZE] \
 		__aligned(__alignof__(struct shash_desc));		     \
 	struct shash_desc *shash = (struct shash_desc *)__##shash##_desc
 
+#define HASH_REQUEST_ON_STACK(name, _tfm) \
+	char __##name##_req[sizeof(struct ahash_request) + \
+			    MAX_SYNC_HASH_REQSIZE] CRYPTO_MINALIGN_ATTR; \
+	struct ahash_request *name = \
+		ahash_request_on_stack_init(__##name##_req, (_tfm))
+
+#define HASH_REQUEST_CLONE(name, gfp) \
+	hash_request_clone(name, sizeof(__##name##_req), gfp)
+
 /**
  * struct shash_alg - synchronous message digest definition
  * @init: see struct ahash_alg
@@ -231,6 +244,7 @@ struct crypto_ahash {
 	bool using_shash; /* Underlying algorithm is shash, not ahash */
 	unsigned int statesize;
 	unsigned int reqsize;
+	struct crypto_ahash *fb;
 	struct crypto_tfm base;
 };
 
@@ -248,6 +262,11 @@ struct crypto_shash {
  * CRYPTO_ALG_TYPE_SKCIPHER API applies here as well.
  */
 
+static inline bool ahash_req_on_stack(struct ahash_request *req)
+{
+	return crypto_req_on_stack(&req->base);
+}
+
 static inline struct crypto_ahash *__crypto_ahash_cast(struct crypto_tfm *tfm)
 {
 	return container_of(tfm, struct crypto_ahash, base);
@@ -544,7 +563,7 @@ int crypto_ahash_update(struct ahash_request *req);
 static inline void ahash_request_set_tfm(struct ahash_request *req,
 					 struct crypto_ahash *tfm)
 {
-	req->base.tfm = crypto_ahash_tfm(tfm);
+	crypto_request_set_tfm(&req->base, crypto_ahash_tfm(tfm));
 }
 
 /**
@@ -578,9 +597,12 @@ static inline struct ahash_request *ahash_request_alloc_noprof(
  * ahash_request_free() - zeroize and free the request data structure
  * @req: request data structure cipher handle to be freed
  */
-static inline void ahash_request_free(struct ahash_request *req)
+void ahash_request_free(struct ahash_request *req);
+
+static inline void ahash_request_zero(struct ahash_request *req)
 {
-	kfree_sensitive(req);
+	memzero_explicit(req, sizeof(*req) +
+			      crypto_ahash_reqsize(crypto_ahash_reqtfm(req)));
 }
 
 static inline struct ahash_request *ahash_request_cast(
@@ -619,13 +641,9 @@ static inline void ahash_request_set_callback(struct ahash_request *req,
 					      crypto_completion_t compl,
 					      void *data)
 {
-	u32 keep = CRYPTO_AHASH_REQ_VIRT;
-
-	req->base.complete = compl;
-	req->base.data = data;
-	flags &= ~keep;
-	req->base.flags &= keep;
-	req->base.flags |= flags;
+	flags &= ~CRYPTO_AHASH_REQ_PRIVATE;
+	flags |= req->base.flags & CRYPTO_AHASH_REQ_PRIVATE;
+	crypto_request_set_callback(&req->base, flags, compl, data);
 }
 
 /**
@@ -870,6 +888,9 @@ int crypto_shash_digest(struct shash_desc *desc, const u8 *data,
 int crypto_shash_tfm_digest(struct crypto_shash *tfm, const u8 *data,
 			    unsigned int len, u8 *out);
 
+int crypto_hash_digest(struct crypto_ahash *tfm, const u8 *data,
+		       unsigned int len, u8 *out);
+
 /**
  * crypto_shash_export() - extract operational state for message digest
  * @desc: reference to the operational state handle whose state is exported
@@ -980,4 +1001,17 @@ static inline bool ahash_is_async(struct crypto_ahash *tfm)
 	return crypto_tfm_is_async(&tfm->base);
 }
 
+static inline struct ahash_request *ahash_request_on_stack_init(
+	char *buf, struct crypto_ahash *tfm)
+{
+	struct ahash_request *req = (void *)buf;
+
+	ahash_request_set_tfm(req, tfm);
+	req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
+	return req;
+}
+
+struct ahash_request *ahash_request_clone(struct ahash_request *req,
+					  size_t total, gfp_t gfp);
+
 #endif	/* _CRYPTO_HASH_H */
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index e2a1fac38610..45c728ac2621 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -11,6 +11,12 @@
 #include <crypto/algapi.h>
 #include <crypto/hash.h>
 
+#define HASH_FBREQ_ON_STACK(name, req) \
+        char __##name##_req[sizeof(struct ahash_request) + \
+                            MAX_SYNC_HASH_REQSIZE] CRYPTO_MINALIGN_ATTR; \
+        struct ahash_request *name = ahash_fbreq_on_stack_init( \
+                __##name##_req, (req))
+
 struct ahash_request;
 
 struct ahash_instance {
@@ -187,7 +193,7 @@ static inline void ahash_request_complete(struct ahash_request *req, int err)
 
 static inline u32 ahash_request_flags(struct ahash_request *req)
 {
-	return req->base.flags;
+	return crypto_request_flags(&req->base) & ~CRYPTO_AHASH_REQ_PRIVATE;
 }
 
 static inline struct crypto_ahash *crypto_spawn_ahash(
@@ -257,5 +263,23 @@ static inline bool crypto_ahash_req_chain(struct crypto_ahash *tfm)
 	return crypto_tfm_req_chain(&tfm->base);
 }
 
+static inline struct ahash_request *ahash_fbreq_on_stack_init(
+	char *buf, struct ahash_request *old)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(old);
+	struct ahash_request *req = (void *)buf;
+
+	ahash_request_set_tfm(req, tfm->fb);
+	req->base.flags = CRYPTO_TFM_REQ_ON_STACK;
+	ahash_request_set_callback(req, ahash_request_flags(old), NULL, NULL);
+	req->base.flags &= ~CRYPTO_AHASH_REQ_PRIVATE;
+	req->base.flags |= old->base.flags & CRYPTO_AHASH_REQ_PRIVATE;
+	req->src = old->src;
+	req->result = old->result;
+	req->nbytes = old->nbytes;
+
+	return req;
+}
+
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
-- 
2.39.5

