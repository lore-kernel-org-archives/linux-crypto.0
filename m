Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12F1F19DF9A
	for <linux-crypto@vger.kernel.org>; Mon,  7 Apr 2025 09:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744018426; cv=none; b=UTCI+C4PKBPaE5MI2HwyOuqOMDC6ou+lADCnv8yLKJBsP3Zdy/YLN/azOrQNCNAC3KSSpkRdCp4e0oeskVLTQcLPfA92I/Y6iVnWqAmszr3gn7F7iUm+0ErfIL/5c4MCV9THBGvdr+ubYJiOccO+KdB3jQKo/e9zVaVuDPHWWqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744018426; c=relaxed/simple;
	bh=odyL3C9wA8E7qINZ/+vO7tziBqUYQqHnS98RDlWKI8E=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=HXyV9+nvBsP8On15EJpglgW4VPUxSUTA4AYYXAX95JB0cK3It+NXKyQF7Wapoxy4SQ3D5BqOpYsYk+aQjWzeHOb2Qmh8aF8Swlxolux60L/tSjbhPId1s8ohtyGApHc8gCI7hMIu0xEyi4Xetfbw1E0SeC7meMm5MWVIEQ8X08k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=VIyE4ijK; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="VIyE4ijK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MzP1LkTIkZkgNnHmfXNWcFmbYwe9XiGvcvszdgkt2Sc=; b=VIyE4ijKpWn+FEvLzB/0GV5kzs
	MyeToAaT7Eq0wGGJEjiRX3piwXphWp3dA7MJbquEBdooScsy/0zqPc0xNOCmD0i94G6S5mp/c0Vny
	OlrWPKzqXWYsXauFxETi6njJ71cNLZPAfYSqod/qF6helewF5zebbBpSuwqrjbjG6dxaeFG7PpoCz
	vfqTYJqkNBQ1Q5KHehWkXZmwU5VaPRdKhncjtUT+IQiz9NJsX2ATSZaHXuLnhiNwP8LASuQAKieGs
	lqYZWlDE0YjnaTRCbk41aCey6ytGaGSP/KBezf38XYVMfMxLFSOkGs52sbfQefiZqXhPpfpvjx0MS
	2mZ501Rw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1irK-00DR0w-3D;
	Mon, 07 Apr 2025 17:33:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 17:33:38 +0800
Date: Mon, 07 Apr 2025 17:33:38 +0800
Message-Id: <06daa1eefa3db0c992dbbd532df9bf82b5c1b508.1744018301.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744018301.git.herbert@gondor.apana.org.au>
References: <cover.1744018301.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/5] crypto: ahash - Remove request chaining
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Request chaining requires the user to do too much book keeping.
Remove it from ahash.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c                 | 234 +++++----------------------------
 include/crypto/algapi.h        |   5 -
 include/crypto/hash.h          |  12 --
 include/crypto/internal/hash.h |   5 -
 include/linux/crypto.h         |  15 ---
 5 files changed, 32 insertions(+), 239 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 9f57b925b116..079216180ad1 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -43,10 +43,7 @@ struct crypto_hash_walk {
 };
 
 struct ahash_save_req_state {
-	struct list_head head;
 	struct ahash_request *req0;
-	struct ahash_request *cur;
-	int (*op)(struct ahash_request *req);
 	crypto_completion_t compl;
 	void *data;
 	struct scatterlist sg;
@@ -54,9 +51,9 @@ struct ahash_save_req_state {
 	u8 *page;
 	unsigned int offset;
 	unsigned int nbytes;
+	bool update;
 };
 
-static void ahash_reqchain_done(void *data, int err);
 static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt);
 static void ahash_restore_req(struct ahash_request *req);
 static void ahash_def_finup_done1(void *data, int err);
@@ -313,30 +310,17 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
-static bool ahash_request_hasvirt(struct ahash_request *req)
-{
-	struct ahash_request *r2;
-
-	if (ahash_request_isvirt(req))
-		return true;
-
-	list_for_each_entry(r2, &req->base.list, base.list)
-		if (ahash_request_isvirt(r2))
-			return true;
-
-	return false;
-}
-
 static int ahash_reqchain_virt(struct ahash_save_req_state *state,
 			       int err, u32 mask)
 {
-	struct ahash_request *req = state->cur;
+	struct ahash_request *req = state->req0;
+	struct crypto_ahash *tfm;
+
+	tfm = crypto_ahash_reqtfm(req);
 
 	for (;;) {
 		unsigned len = state->nbytes;
 
-		req->base.err = err;
-
 		if (!state->offset)
 			break;
 
@@ -355,10 +339,9 @@ static int ahash_reqchain_virt(struct ahash_save_req_state *state,
 		state->offset += len;
 		req->nbytes = len;
 
-		err = state->op(req);
+		err = crypto_ahash_alg(tfm)->update(req);
 		if (err == -EINPROGRESS) {
-			if (!list_empty(&state->head) ||
-			    state->offset < state->nbytes)
+			if (state->offset < state->nbytes)
 				err = -EBUSY;
 			break;
 		}
@@ -374,64 +357,12 @@ static int ahash_reqchain_finish(struct ahash_request *req0,
 				 struct ahash_save_req_state *state,
 				 int err, u32 mask)
 {
-	struct ahash_request *req = state->cur;
-	struct crypto_ahash *tfm;
-	struct ahash_request *n;
-	bool update;
 	u8 *page;
 
 	err = ahash_reqchain_virt(state, err, mask);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		goto out;
 
-	if (req != req0)
-		list_add_tail(&req->base.list, &req0->base.list);
-
-	tfm = crypto_ahash_reqtfm(req);
-	update = state->op == crypto_ahash_alg(tfm)->update;
-
-	list_for_each_entry_safe(req, n, &state->head, base.list) {
-		list_del_init(&req->base.list);
-
-		req->base.flags &= mask;
-		req->base.complete = ahash_reqchain_done;
-		req->base.data = state;
-		state->cur = req;
-
-		if (update && ahash_request_isvirt(req) && req->nbytes) {
-			unsigned len = req->nbytes;
-			u8 *result = req->result;
-
-			state->src = req->svirt;
-			state->nbytes = len;
-
-			len = min(PAGE_SIZE, len);
-
-			memcpy(state->page, req->svirt, len);
-			state->offset = len;
-
-			ahash_request_set_crypt(req, &state->sg, result, len);
-		}
-
-		err = state->op(req);
-
-		if (err == -EINPROGRESS) {
-			if (!list_empty(&state->head) ||
-			    state->offset < state->nbytes)
-				err = -EBUSY;
-			goto out;
-		}
-
-		if (err == -EBUSY)
-			goto out;
-
-		err = ahash_reqchain_virt(state, err, mask);
-		if (err == -EINPROGRESS || err == -EBUSY)
-			goto out;
-
-		list_add_tail(&req->base.list, &req0->base.list);
-	}
-
 	page = state->page;
 	if (page) {
 		memset(page, 0, PAGE_SIZE);
@@ -451,7 +382,7 @@ static void ahash_reqchain_done(void *data, int err)
 	data = state->data;
 
 	if (err == -EINPROGRESS) {
-		if (!list_empty(&state->head) || state->offset < state->nbytes)
+		if (state->offset < state->nbytes)
 			return;
 		goto notify;
 	}
@@ -472,26 +403,18 @@ static int ahash_do_req_chain(struct ahash_request *req,
 	bool update = op == crypto_ahash_alg(tfm)->update;
 	struct ahash_save_req_state *state;
 	struct ahash_save_req_state state0;
-	struct ahash_request *r2;
 	u8 *page = NULL;
 	int err;
 
 	if (crypto_ahash_req_chain(tfm) ||
-	    (!ahash_request_chained(req) &&
-	     (!update || !ahash_request_isvirt(req))))
+	    !update || !ahash_request_isvirt(req))
 		return op(req);
 
-	if (update && ahash_request_hasvirt(req)) {
-		gfp_t gfp;
-		u32 flags;
-
-		flags = ahash_request_flags(req);
-		gfp = (flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
-		      GFP_KERNEL : GFP_ATOMIC;
-		page = (void *)__get_free_page(gfp);
+	if (update && ahash_request_isvirt(req)) {
+		page = (void *)__get_free_page(GFP_ATOMIC);
 		err = -ENOMEM;
 		if (!page)
-			goto out_set_chain;
+			goto out;
 	}
 
 	state = &state0;
@@ -503,13 +426,10 @@ static int ahash_do_req_chain(struct ahash_request *req,
 		state = req->base.data;
 	}
 
-	state->op = op;
-	state->cur = req;
+	state->update = update;
 	state->page = page;
 	state->offset = 0;
 	state->nbytes = 0;
-	INIT_LIST_HEAD(&state->head);
-	list_splice_init(&req->base.list, &state->head);
 
 	if (page)
 		sg_init_one(&state->sg, page, PAGE_SIZE);
@@ -530,19 +450,18 @@ static int ahash_do_req_chain(struct ahash_request *req,
 	}
 
 	err = op(req);
-	if (err == -EBUSY || err == -EINPROGRESS)
-		return -EBUSY;
+	if (err == -EINPROGRESS || err == -EBUSY) {
+		if (state->offset < state->nbytes)
+			err = -EBUSY;
+		return err;
+	}
 
 	return ahash_reqchain_finish(req, state, err, ~0);
 
 out_free_page:
 	free_page((unsigned long)page);
 
-out_set_chain:
-	req->base.err = err;
-	list_for_each_entry(r2, &req->base.list, base.list)
-		r2->base.err = err;
-
+out:
 	return err;
 }
 
@@ -550,26 +469,10 @@ int crypto_ahash_init(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash)) {
-		struct ahash_request *r2;
-		int err;
-
-		err = crypto_shash_init(prepare_shash_desc(req, tfm));
-		req->base.err = err;
-
-		list_for_each_entry(r2, &req->base.list, base.list) {
-			struct shash_desc *desc;
-
-			desc = prepare_shash_desc(r2, tfm);
-			r2->base.err = crypto_shash_init(desc);
-		}
-
-		return err;
-	}
-
+	if (likely(tfm->using_shash))
+		return crypto_shash_init(prepare_shash_desc(req, tfm));
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
-
 	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->init);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_init);
@@ -578,15 +481,11 @@ static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct ahash_save_req_state *state;
-	gfp_t gfp;
-	u32 flags;
 
 	if (!ahash_is_async(tfm))
 		return 0;
 
-	flags = ahash_request_flags(req);
-	gfp = (flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?  GFP_KERNEL : GFP_ATOMIC;
-	state = kmalloc(sizeof(*state), gfp);
+	state = kmalloc(sizeof(*state), GFP_ATOMIC);
 	if (!state)
 		return -ENOMEM;
 
@@ -619,23 +518,8 @@ int crypto_ahash_update(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash)) {
-		struct ahash_request *r2;
-		int err;
-
-		err = shash_ahash_update(req, ahash_request_ctx(req));
-		req->base.err = err;
-
-		list_for_each_entry(r2, &req->base.list, base.list) {
-			struct shash_desc *desc;
-
-			desc = ahash_request_ctx(r2);
-			r2->base.err = shash_ahash_update(r2, desc);
-		}
-
-		return err;
-	}
-
+	if (likely(tfm->using_shash))
+		return shash_ahash_update(req, ahash_request_ctx(req));
 	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->update);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_update);
@@ -644,23 +528,8 @@ int crypto_ahash_final(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash)) {
-		struct ahash_request *r2;
-		int err;
-
-		err = crypto_shash_final(ahash_request_ctx(req), req->result);
-		req->base.err = err;
-
-		list_for_each_entry(r2, &req->base.list, base.list) {
-			struct shash_desc *desc;
-
-			desc = ahash_request_ctx(r2);
-			r2->base.err = crypto_shash_final(desc, r2->result);
-		}
-
-		return err;
-	}
-
+	if (likely(tfm->using_shash))
+		return crypto_shash_final(ahash_request_ctx(req), req->result);
 	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->final);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_final);
@@ -669,27 +538,11 @@ int crypto_ahash_finup(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash)) {
-		struct ahash_request *r2;
-		int err;
-
-		err = shash_ahash_finup(req, ahash_request_ctx(req));
-		req->base.err = err;
-
-		list_for_each_entry(r2, &req->base.list, base.list) {
-			struct shash_desc *desc;
-
-			desc = ahash_request_ctx(r2);
-			r2->base.err = shash_ahash_finup(r2, desc);
-		}
-
-		return err;
-	}
-
+	if (likely(tfm->using_shash))
+		return shash_ahash_finup(req, ahash_request_ctx(req));
 	if (!crypto_ahash_alg(tfm)->finup ||
-	    (!crypto_ahash_req_chain(tfm) && ahash_request_hasvirt(req)))
+	    (!crypto_ahash_req_chain(tfm) && ahash_request_isvirt(req)))
 		return ahash_def_finup(req);
-
 	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->finup);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_finup);
@@ -756,29 +609,12 @@ int crypto_ahash_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash)) {
-		struct ahash_request *r2;
-		int err;
-
-		err = shash_ahash_digest(req, prepare_shash_desc(req, tfm));
-		req->base.err = err;
-
-		list_for_each_entry(r2, &req->base.list, base.list) {
-			struct shash_desc *desc;
-
-			desc = prepare_shash_desc(r2, tfm);
-			r2->base.err = shash_ahash_digest(r2, desc);
-		}
-
-		return err;
-	}
-
-	if (!crypto_ahash_req_chain(tfm) && ahash_request_hasvirt(req))
+	if (likely(tfm->using_shash))
+		return shash_ahash_digest(req, prepare_shash_desc(req, tfm));
+	if (!crypto_ahash_req_chain(tfm) && ahash_request_isvirt(req))
 		return ahash_def_digest(req);
-
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
-
 	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->digest);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_digest);
@@ -1135,15 +971,9 @@ EXPORT_SYMBOL_GPL(ahash_register_instance);
 
 void ahash_request_free(struct ahash_request *req)
 {
-	struct ahash_request *tmp;
-	struct ahash_request *r2;
-
 	if (unlikely(!req))
 		return;
 
-	list_for_each_entry_safe(r2, tmp, &req->base.list, base.list)
-		kfree_sensitive(r2);
-
 	kfree_sensitive(req);
 }
 EXPORT_SYMBOL_GPL(ahash_request_free);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 03b7eca8af9a..ede622ecefa8 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -267,11 +267,6 @@ static inline u32 crypto_tfm_alg_type(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
 }
 
-static inline bool crypto_request_chained(struct crypto_async_request *req)
-{
-	return !list_empty(&req->list);
-}
-
 static inline bool crypto_tfm_req_chain(struct crypto_tfm *tfm)
 {
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_CHAIN;
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index b987904afdba..c14a3a90613f 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -626,7 +626,6 @@ static inline void ahash_request_set_callback(struct ahash_request *req,
 	flags &= ~keep;
 	req->base.flags &= keep;
 	req->base.flags |= flags;
-	crypto_reqchain_init(&req->base);
 }
 
 /**
@@ -675,12 +674,6 @@ static inline void ahash_request_set_virt(struct ahash_request *req,
 	req->base.flags |= CRYPTO_AHASH_REQ_VIRT;
 }
 
-static inline void ahash_request_chain(struct ahash_request *req,
-				       struct ahash_request *head)
-{
-	crypto_request_chain(&req->base, &head->base);
-}
-
 /**
  * DOC: Synchronous Message Digest API
  *
@@ -982,11 +975,6 @@ static inline void shash_desc_zero(struct shash_desc *desc)
 			 sizeof(*desc) + crypto_shash_descsize(desc->tfm));
 }
 
-static inline int ahash_request_err(struct ahash_request *req)
-{
-	return req->base.err;
-}
-
 static inline bool ahash_is_async(struct crypto_ahash *tfm)
 {
 	return crypto_tfm_is_async(&tfm->base);
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 485e22cf517e..e2a1fac38610 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -247,11 +247,6 @@ static inline struct crypto_shash *__crypto_shash_cast(struct crypto_tfm *tfm)
 	return container_of(tfm, struct crypto_shash, base);
 }
 
-static inline bool ahash_request_chained(struct ahash_request *req)
-{
-	return crypto_request_chained(&req->base);
-}
-
 static inline bool ahash_request_isvirt(struct ahash_request *req)
 {
 	return req->base.flags & CRYPTO_AHASH_REQ_VIRT;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 1e3809d28abd..dd817f56ff0c 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -14,7 +14,6 @@
 
 #include <linux/completion.h>
 #include <linux/errno.h>
-#include <linux/list.h>
 #include <linux/refcount.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -179,7 +178,6 @@ struct crypto_async_request {
 	struct crypto_tfm *tfm;
 
 	u32 flags;
-	int err;
 };
 
 /**
@@ -473,19 +471,6 @@ static inline unsigned int crypto_tfm_ctx_alignment(void)
 	return __alignof__(tfm->__crt_ctx);
 }
 
-static inline void crypto_reqchain_init(struct crypto_async_request *req)
-{
-	req->err = -EINPROGRESS;
-	INIT_LIST_HEAD(&req->list);
-}
-
-static inline void crypto_request_chain(struct crypto_async_request *req,
-					struct crypto_async_request *head)
-{
-	req->err = -EINPROGRESS;
-	list_add_tail(&req->list, &head->list);
-}
-
 static inline bool crypto_tfm_is_async(struct crypto_tfm *tfm)
 {
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC;
-- 
2.39.5

