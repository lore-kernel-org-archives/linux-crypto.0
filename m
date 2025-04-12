Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C1D18A6AB
	for <linux-crypto@vger.kernel.org>; Sat, 12 Apr 2025 05:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744436226; cv=none; b=ERNStjBEb/BNzI43Ac/n1svv7YFtvVvTWgxgL+ehC+3D9mDCzB+pwDkAVpbZ6pNNbFMb976XdsRMpwzZru47z4z0UX9ny7rVAZtXY4lbIBfO8Vj2wKL/I/hiTe5UXb4j/yFFw6+PPLnMIgZZ7FaRe0bA6FYrevvmIT3k28ILkOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744436226; c=relaxed/simple;
	bh=G6C82Kw1Dh4VEDtNJxXKxCXyne9F8mq0VhyYLt54lbQ=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=EQuL8faMcP27ovHg+S7vyksaBfhRWMD4+2WenKz8d5CbpT8ZSfgsICueOoapxRRgZdtxa+gvHMlLr/I7nKCqh3DMvGH2psRtY6/O7lv5WUQFxNl6VNNU5SG9vlM2L4p5Yxz0xIaHT53KFPudFxtCt7Z8s3W+HorPpHhjEuIF1TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Z2OpGvyi; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Z2OpGvyi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2+A4qIZ9a7AP5iMn8DYFKjQo4oC/0ldAMvxtcnbogik=; b=Z2OpGvyiZzV6t7A1ITJRrKlEs0
	lBTIlYApo8im8zvQT9j+oxBz7xS24QsTwtAISSPCAzuwK4uhKYsn07Yz7ltBXzLDOh4Q1OPfuab7m
	4tnPBRutwZCMMZ7DgI+RvfELI7ccwmm//IAwAXOoqP1t90ZN9u9YmT2RmqHGICN/NyKm4N/BPtclW
	dCqur9FNw+Dt8dA0pFm0v/r2odisrc7UUFinuhH0U4yUToPucgp6G9Gl7P0OP12V+DLjHJ1pIY5hc
	thrRrLWaZF53a2Wh8nsTnBBwtuwxDaaLOGucT3PySxIlCsd1hmv+hX/Zj8cUR29ncFdGz9LB9mKgG
	LrE7kggA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u3TY4-00F2t2-0v;
	Sat, 12 Apr 2025 13:37:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 12 Apr 2025 13:37:00 +0800
Date: Sat, 12 Apr 2025 13:37:00 +0800
Message-Id: <53ec0d6bc62d861becb775609239da6921213612.1744436095.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1744436095.git.herbert@gondor.apana.org.au>
References: <cover.1744436095.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 5/5] crypto: ahash - Remove request chaining
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
 crypto/ahash.c                 | 169 +++++++--------------------------
 include/crypto/algapi.h        |   5 -
 include/crypto/hash.h          |  12 ---
 include/crypto/internal/hash.h |   5 -
 include/linux/crypto.h         |  15 ---
 5 files changed, 32 insertions(+), 174 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 7ed88f8bedeb..e87427c4b09d 100644
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
@@ -313,21 +310,17 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
-static bool ahash_request_hasvirt(struct ahash_request *req)
-{
-	return ahash_request_isvirt(req);
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
 
@@ -346,10 +339,9 @@ static int ahash_reqchain_virt(struct ahash_save_req_state *state,
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
@@ -365,64 +357,12 @@ static int ahash_reqchain_finish(struct ahash_request *req0,
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
@@ -442,7 +382,7 @@ static void ahash_reqchain_done(void *data, int err)
 	data = state->data;
 
 	if (err == -EINPROGRESS) {
-		if (!list_empty(&state->head) || state->offset < state->nbytes)
+		if (state->offset < state->nbytes)
 			return;
 		goto notify;
 	}
@@ -467,21 +407,14 @@ static int ahash_do_req_chain(struct ahash_request *req,
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
@@ -493,12 +426,10 @@ static int ahash_do_req_chain(struct ahash_request *req,
 		state = req->base.data;
 	}
 
-	state->op = op;
-	state->cur = req;
+	state->update = update;
 	state->page = page;
 	state->offset = 0;
 	state->nbytes = 0;
-	INIT_LIST_HEAD(&state->head);
 
 	if (page)
 		sg_init_one(&state->sg, page, PAGE_SIZE);
@@ -519,16 +450,18 @@ static int ahash_do_req_chain(struct ahash_request *req,
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
+out:
 	return err;
 }
 
@@ -536,17 +469,10 @@ int crypto_ahash_init(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash)) {
-		int err;
-
-		err = crypto_shash_init(prepare_shash_desc(req, tfm));
-		req->base.err = err;
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
@@ -555,15 +481,11 @@ static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
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
 
@@ -596,14 +518,8 @@ int crypto_ahash_update(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash)) {
-		int err;
-
-		err = shash_ahash_update(req, ahash_request_ctx(req));
-		req->base.err = err;
-		return err;
-	}
-
+	if (likely(tfm->using_shash))
+		return shash_ahash_update(req, ahash_request_ctx(req));
 	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->update);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_update);
@@ -612,14 +528,8 @@ int crypto_ahash_final(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash)) {
-		int err;
-
-		err = crypto_shash_final(ahash_request_ctx(req), req->result);
-		req->base.err = err;
-		return err;
-	}
-
+	if (likely(tfm->using_shash))
+		return crypto_shash_final(ahash_request_ctx(req), req->result);
 	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->final);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_final);
@@ -628,18 +538,11 @@ int crypto_ahash_finup(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash)) {
-		int err;
-
-		err = shash_ahash_finup(req, ahash_request_ctx(req));
-		req->base.err = err;
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
@@ -706,20 +609,12 @@ int crypto_ahash_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash)) {
-		int err;
-
-		err = shash_ahash_digest(req, prepare_shash_desc(req, tfm));
-		req->base.err = err;
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
index a13e2de3c9b4..113a5835e586 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -630,7 +630,6 @@ static inline void ahash_request_set_callback(struct ahash_request *req,
 	flags &= ~keep;
 	req->base.flags &= keep;
 	req->base.flags |= flags;
-	crypto_reqchain_init(&req->base);
 }
 
 /**
@@ -679,12 +678,6 @@ static inline void ahash_request_set_virt(struct ahash_request *req,
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
@@ -986,11 +979,6 @@ static inline void shash_desc_zero(struct shash_desc *desc)
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
index 052ac7924af3..e2a1fac38610 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -247,11 +247,6 @@ static inline struct crypto_shash *__crypto_shash_cast(struct crypto_tfm *tfm)
 	return container_of(tfm, struct crypto_shash, base);
 }
 
-static inline bool ahash_request_chained(struct ahash_request *req)
-{
-	return false;
-}
-
 static inline bool ahash_request_isvirt(struct ahash_request *req)
 {
 	return req->base.flags & CRYPTO_AHASH_REQ_VIRT;
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index f87f124ddc18..52525444eb8c 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -14,7 +14,6 @@
 
 #include <linux/completion.h>
 #include <linux/errno.h>
-#include <linux/list.h>
 #include <linux/refcount.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -188,7 +187,6 @@ struct crypto_async_request {
 	struct crypto_tfm *tfm;
 
 	u32 flags;
-	int err;
 };
 
 /**
@@ -482,19 +480,6 @@ static inline unsigned int crypto_tfm_ctx_alignment(void)
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

