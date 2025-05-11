Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6F71A071C
	for <linux-crypto@vger.kernel.org>; Sun, 11 May 2025 09:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746954582; cv=none; b=Ptrci5wzwpQtZ6TFCVKk+c/ZOZuW9x068Eo588d6/7zq9JiUrBmRdHzZ7XYPagnW3S0ODey66znOEiPZ/kHSO35QTrMyGOtrJObd/74NEItcJeLMaXDj4RtukQF3QosPdwW1A2GXmhevRwBNmkVR9rVvhtKsLtornOjBJxjJnLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746954582; c=relaxed/simple;
	bh=7RWIFAdLpLUXd9c9azgbUcH9L10rU1zq22KXIOeXFps=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To; b=OX1frAz0Bpc81akYj5/SJVI0wVnd2reAeZPRlQRP9mYNq9qKO3SFIfC4agS5Ljv2N2c/71GcHUDR1F0kiQekvKYGPtUP0t4sjVq6i7L/6C9i/YALukygRmagyLBPwHsDLSKfmoYxCY6d7hIRlN3dBHZr0GVIpRZejcELjqDEXQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ZT5nOl4V; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ZT5nOl4V"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=To:Subject:From:References:In-Reply-To:Message-Id:Date:Sender:
	Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zqVCHLCYjfcDLrsLvFci0otuclYMrxZijjW8uPf6XPc=; b=ZT5nOl4VgwXENy30EiQi318Ovv
	JhpZj90sylblps0C5VZOZkYfdChT8cqnPQOQrWibAEyvOAOz+VHYKfB2R+RmNd00HrwnoL1VNvXqY
	cqKS8bK7ejXUK4g7VtIcULfyiv89LTW2NP2zEfzGtFXaBz1c6+XiTkOXx4vabAZr1FHQd8Fyogx4T
	ubxCGbefEYFdGWiq5ccclTI4ZafyULJnBjQSok0oINDYTNpRxe1SLRa759f25OFr9p5xYg60aL6Ab
	e50MSvHs1D32gpkywMNe0JkiqJr17vxeLPzyfeOj04nBgAg3EBYIIuP0sO8hsVi5BVXBPQ/c9BZMq
	2/DRED/g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uE2gf-005CPA-2p;
	Sun, 11 May 2025 17:09:34 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 11 May 2025 17:09:33 +0800
Date: Sun, 11 May 2025 17:09:33 +0800
Message-Id: <666d67cb9fb48d968a5bb37533386468e474ecce.1746954402.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1746954402.git.herbert@gondor.apana.org.au>
References: <cover.1746954402.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 2/6] crypto: ahash - Handle partial blocks in API
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

Provide an option to handle the partial blocks in the ahash API.
Almost every hash algorithm has a block size and are only able
to hash partial blocks on finalisation.

As a first step disable virtual address support for algorithms
with state sizes larger than HASH_MAX_STATESIZE.  This is OK as
virtual addresses are currently only used on synchronous fallbacks.

This means ahash_do_req_chain only needs to handle synchronous
fallbacks, removing the complexities of saving the request state.

Also move the saved request state into the ahash_request object
as nesting is no longer possible.

Add a scatterlist to ahash_request to store the partial block.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c        | 543 ++++++++++++++++++++----------------------
 include/crypto/hash.h |  12 +-
 2 files changed, 266 insertions(+), 289 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 344bf1b43e71..c474aad88f68 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -12,11 +12,13 @@
  * Copyright (c) 2008 Loc Ho <lho@amcc.com>
  */
 
+#include <crypto/scatterwalk.h>
 #include <linux/cryptouser.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/seq_file.h>
 #include <linux/string.h>
@@ -40,24 +42,47 @@ struct crypto_hash_walk {
 	struct scatterlist *sg;
 };
 
-struct ahash_save_req_state {
-	struct ahash_request *req0;
-	crypto_completion_t compl;
-	void *data;
-	struct scatterlist sg;
-	const u8 *src;
-	u8 *page;
-	unsigned int offset;
-	unsigned int nbytes;
-	bool update;
-};
-
-static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt);
-static void ahash_restore_req(struct ahash_request *req);
-static void ahash_def_finup_done1(void *data, int err);
-static int ahash_def_finup_finish1(struct ahash_request *req, int err);
 static int ahash_def_finup(struct ahash_request *req);
 
+static inline bool crypto_ahash_block_only(struct crypto_ahash *tfm)
+{
+	return crypto_ahash_alg(tfm)->halg.base.cra_flags &
+	       CRYPTO_AHASH_ALG_BLOCK_ONLY;
+}
+
+static inline bool crypto_ahash_final_nonzero(struct crypto_ahash *tfm)
+{
+	return crypto_ahash_alg(tfm)->halg.base.cra_flags &
+	       CRYPTO_AHASH_ALG_FINAL_NONZERO;
+}
+
+static inline bool crypto_ahash_need_fallback(struct crypto_ahash *tfm)
+{
+	return crypto_ahash_alg(tfm)->halg.base.cra_flags &
+	       CRYPTO_ALG_NEED_FALLBACK;
+}
+
+static inline void ahash_op_done(void *data, int err,
+				 int (*finish)(struct ahash_request *, int))
+{
+	struct ahash_request *areq = data;
+	crypto_completion_t compl;
+
+	compl = areq->saved_complete;
+	data = areq->saved_data;
+	if (err == -EINPROGRESS)
+		goto out;
+
+	areq->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	err = finish(areq, err);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		return;
+
+out:
+	compl(data, err);
+}
+
 static int hash_walk_next(struct crypto_hash_walk *walk)
 {
 	unsigned int offset = walk->offset;
@@ -298,7 +323,7 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 		int err;
 
 		err = alg->setkey(tfm, key, keylen);
-		if (!err && ahash_is_async(tfm))
+		if (!err && crypto_ahash_need_fallback(tfm))
 			err = crypto_ahash_setkey(crypto_ahash_fb(tfm),
 						  key, keylen);
 		if (unlikely(err)) {
@@ -311,159 +336,47 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
-static int ahash_reqchain_virt(struct ahash_save_req_state *state,
-			       int err, u32 mask)
-{
-	struct ahash_request *req = state->req0;
-	struct crypto_ahash *tfm;
-
-	tfm = crypto_ahash_reqtfm(req);
-
-	for (;;) {
-		unsigned len = state->nbytes;
-
-		if (!state->offset)
-			break;
-
-		if (state->offset == len || err) {
-			u8 *result = req->result;
-
-			ahash_request_set_virt(req, state->src, result, len);
-			state->offset = 0;
-			break;
-		}
-
-		len -= state->offset;
-
-		len = min(PAGE_SIZE, len);
-		memcpy(state->page, state->src + state->offset, len);
-		state->offset += len;
-		req->nbytes = len;
-
-		err = crypto_ahash_alg(tfm)->update(req);
-		if (err == -EINPROGRESS) {
-			if (state->offset < state->nbytes)
-				err = -EBUSY;
-			break;
-		}
-
-		if (err == -EBUSY)
-			break;
-	}
-
-	return err;
-}
-
-static int ahash_reqchain_finish(struct ahash_request *req0,
-				 struct ahash_save_req_state *state,
-				 int err, u32 mask)
-{
-	u8 *page;
-
-	err = ahash_reqchain_virt(state, err, mask);
-	if (err == -EINPROGRESS || err == -EBUSY)
-		goto out;
-
-	page = state->page;
-	if (page) {
-		memset(page, 0, PAGE_SIZE);
-		free_page((unsigned long)page);
-	}
-	ahash_restore_req(req0);
-
-out:
-	return err;
-}
-
-static void ahash_reqchain_done(void *data, int err)
-{
-	struct ahash_save_req_state *state = data;
-	crypto_completion_t compl = state->compl;
-
-	data = state->data;
-
-	if (err == -EINPROGRESS) {
-		if (state->offset < state->nbytes)
-			return;
-		goto notify;
-	}
-
-	err = ahash_reqchain_finish(state->req0, state, err,
-				    CRYPTO_TFM_REQ_MAY_BACKLOG);
-	if (err == -EBUSY)
-		return;
-
-notify:
-	compl(data, err);
-}
-
 static int ahash_do_req_chain(struct ahash_request *req,
-			      int (*op)(struct ahash_request *req))
+			      int (*const *op)(struct ahash_request *req))
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	bool update = op == crypto_ahash_alg(tfm)->update;
-	struct ahash_save_req_state *state;
-	struct ahash_save_req_state state0;
-	u8 *page = NULL;
 	int err;
 
-	if (crypto_ahash_req_virt(tfm) ||
-	    !update || !ahash_request_isvirt(req))
-		return op(req);
+	if (crypto_ahash_req_virt(tfm) || !ahash_request_isvirt(req))
+		return (*op)(req);
 
-	if (update && ahash_request_isvirt(req)) {
-		page = (void *)__get_free_page(GFP_ATOMIC);
-		err = -ENOMEM;
-		if (!page)
-			goto out;
-	}
+	if (crypto_ahash_statesize(tfm) > HASH_MAX_STATESIZE)
+		return -ENOSYS;
 
-	state = &state0;
-	if (ahash_is_async(tfm)) {
-		err = ahash_save_req(req, ahash_reqchain_done);
-		if (err)
-			goto out_free_page;
+	{
+		u8 state[HASH_MAX_STATESIZE];
 
-		state = req->base.data;
-	}
+		if (op == &crypto_ahash_alg(tfm)->digest) {
+			ahash_request_set_tfm(req, crypto_ahash_fb(tfm));
+			err = crypto_ahash_digest(req);
+			goto out_no_state;
+		}
 
-	state->update = update;
-	state->page = page;
-	state->offset = 0;
-	state->nbytes = 0;
+		err = crypto_ahash_export(req, state);
+		ahash_request_set_tfm(req, crypto_ahash_fb(tfm));
+		err = err ?: crypto_ahash_import(req, state);
 
-	if (page)
-		sg_init_one(&state->sg, page, PAGE_SIZE);
+		if (op == &crypto_ahash_alg(tfm)->finup) {
+			err = err ?: crypto_ahash_finup(req);
+			goto out_no_state;
+		}
 
-	if (update && ahash_request_isvirt(req) && req->nbytes) {
-		unsigned len = req->nbytes;
-		u8 *result = req->result;
+		err = err ?:
+		      crypto_ahash_update(req) ?:
+		      crypto_ahash_export(req, state);
 
-		state->src = req->svirt;
-		state->nbytes = len;
+		ahash_request_set_tfm(req, tfm);
+		return err ?: crypto_ahash_import(req, state);
 
-		len = min(PAGE_SIZE, len);
-
-		memcpy(page, req->svirt, len);
-		state->offset = len;
-
-		ahash_request_set_crypt(req, &state->sg, result, len);
-	}
-
-	err = op(req);
-	if (err == -EINPROGRESS || err == -EBUSY) {
-		if (state->offset < state->nbytes)
-			err = -EBUSY;
+out_no_state:
+		ahash_request_set_tfm(req, tfm);
 		return err;
 	}
-
-	return ahash_reqchain_finish(req, state, err, ~0);
-
-out_free_page:
-	free_page((unsigned long)page);
-
-out:
-	return err;
 }
 
 int crypto_ahash_init(struct ahash_request *req)
@@ -476,144 +389,191 @@ int crypto_ahash_init(struct ahash_request *req)
 		return -ENOKEY;
 	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
 		return -EAGAIN;
-	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->init);
+	if (crypto_ahash_block_only(tfm)) {
+		u8 *buf = ahash_request_ctx(req);
+
+		buf += crypto_ahash_reqsize(tfm) - 1;
+		*buf = 0;
+	}
+	return crypto_ahash_alg(tfm)->init(req);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_init);
 
-static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
+static void ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ahash_save_req_state *state;
-
-	if (!ahash_is_async(tfm))
-		return 0;
-
-	state = kmalloc(sizeof(*state), GFP_ATOMIC);
-	if (!state)
-		return -ENOMEM;
-
-	state->compl = req->base.complete;
-	state->data = req->base.data;
+	req->saved_complete = req->base.complete;
+	req->saved_data = req->base.data;
 	req->base.complete = cplt;
-	req->base.data = state;
-	state->req0 = req;
-
-	return 0;
+	req->base.data = req;
 }
 
 static void ahash_restore_req(struct ahash_request *req)
 {
-	struct ahash_save_req_state *state;
-	struct crypto_ahash *tfm;
+	req->base.complete = req->saved_complete;
+	req->base.data = req->saved_data;
+}
 
-	tfm = crypto_ahash_reqtfm(req);
-	if (!ahash_is_async(tfm))
-		return;
+static int ahash_update_finish(struct ahash_request *req, int err)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	bool nonzero = crypto_ahash_final_nonzero(tfm);
+	int bs = crypto_ahash_blocksize(tfm);
+	u8 *blenp = ahash_request_ctx(req);
+	int blen;
+	u8 *buf;
 
-	state = req->base.data;
+	blenp += crypto_ahash_reqsize(tfm) - 1;
+	blen = *blenp;
+	buf = blenp - bs;
 
-	req->base.complete = state->compl;
-	req->base.data = state->data;
-	kfree(state);
+	if (blen) {
+		req->src = req->sg_head + 1;
+		if (sg_is_chain(req->src))
+			req->src = sg_chain_ptr(req->src);
+	}
+
+	req->nbytes += nonzero - blen;
+
+	blen = err < 0 ? 0 : err + nonzero;
+	if (ahash_request_isvirt(req))
+		memcpy(buf, req->svirt + req->nbytes - blen, blen);
+	else
+		memcpy_from_sglist(buf, req->src, req->nbytes - blen, blen);
+	*blenp = blen;
+
+	ahash_restore_req(req);
+
+	return err;
+}
+
+static void ahash_update_done(void *data, int err)
+{
+	ahash_op_done(data, err, ahash_update_finish);
 }
 
 int crypto_ahash_update(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	bool nonzero = crypto_ahash_final_nonzero(tfm);
+	int bs = crypto_ahash_blocksize(tfm);
+	u8 *blenp = ahash_request_ctx(req);
+	int blen, err;
+	u8 *buf;
 
 	if (likely(tfm->using_shash))
 		return shash_ahash_update(req, ahash_request_ctx(req));
 	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
 		return -EAGAIN;
-	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->update);
+	if (!crypto_ahash_block_only(tfm))
+		return ahash_do_req_chain(req, &crypto_ahash_alg(tfm)->update);
+
+	blenp += crypto_ahash_reqsize(tfm) - 1;
+	blen = *blenp;
+	buf = blenp - bs;
+
+	if (blen + req->nbytes < bs + nonzero) {
+		if (ahash_request_isvirt(req))
+			memcpy(buf + blen, req->svirt, req->nbytes);
+		else
+			memcpy_from_sglist(buf + blen, req->src, 0,
+					   req->nbytes);
+
+		*blenp += req->nbytes;
+		return 0;
+	}
+
+	if (blen) {
+		memset(req->sg_head, 0, sizeof(req->sg_head[0]));
+		sg_set_buf(req->sg_head, buf, blen);
+		if (req->src != req->sg_head + 1)
+			sg_chain(req->sg_head, 2, req->src);
+		req->src = req->sg_head;
+		req->nbytes += blen;
+	}
+	req->nbytes -= nonzero;
+
+	ahash_save_req(req, ahash_update_done);
+
+	err = ahash_do_req_chain(req, &crypto_ahash_alg(tfm)->update);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		return err;
+
+	return ahash_update_finish(req, err);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_update);
 
-int crypto_ahash_final(struct ahash_request *req)
+static int ahash_finup_finish(struct ahash_request *req, int err)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	u8 *blenp = ahash_request_ctx(req);
+	int blen;
 
-	if (likely(tfm->using_shash))
-		return crypto_shash_final(ahash_request_ctx(req), req->result);
-	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
-		return -EAGAIN;
-	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->final);
+	blenp += crypto_ahash_reqsize(tfm) - 1;
+	blen = *blenp;
+
+	if (blen) {
+		if (sg_is_last(req->src))
+			req->src = NULL;
+		else {
+			req->src = req->sg_head + 1;
+			if (sg_is_chain(req->src))
+				req->src = sg_chain_ptr(req->src);
+		}
+		req->nbytes -= blen;
+	}
+
+	ahash_restore_req(req);
+
+	return err;
+}
+
+static void ahash_finup_done(void *data, int err)
+{
+	ahash_op_done(data, err, ahash_finup_finish);
 }
-EXPORT_SYMBOL_GPL(crypto_ahash_final);
 
 int crypto_ahash_finup(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	int bs = crypto_ahash_blocksize(tfm);
+	u8 *blenp = ahash_request_ctx(req);
+	int blen, err;
+	u8 *buf;
 
 	if (likely(tfm->using_shash))
 		return shash_ahash_finup(req, ahash_request_ctx(req));
 	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
 		return -EAGAIN;
-	if (!crypto_ahash_alg(tfm)->finup ||
-	    (!crypto_ahash_req_virt(tfm) && ahash_request_isvirt(req)))
+	if (!crypto_ahash_alg(tfm)->finup)
 		return ahash_def_finup(req);
-	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->finup);
+	if (!crypto_ahash_block_only(tfm))
+		return ahash_do_req_chain(req, &crypto_ahash_alg(tfm)->finup);
+
+	blenp += crypto_ahash_reqsize(tfm) - 1;
+	blen = *blenp;
+	buf = blenp - bs;
+
+	if (blen) {
+		memset(req->sg_head, 0, sizeof(req->sg_head[0]));
+		sg_set_buf(req->sg_head, buf, blen);
+		if (!req->src)
+			sg_mark_end(req->sg_head);
+		else if (req->src != req->sg_head + 1)
+			sg_chain(req->sg_head, 2, req->src);
+		req->src = req->sg_head;
+		req->nbytes += blen;
+	}
+
+	ahash_save_req(req, ahash_finup_done);
+
+	err = ahash_do_req_chain(req, &crypto_ahash_alg(tfm)->finup);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		return err;
+
+	return ahash_finup_finish(req, err);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_finup);
 
-static int ahash_def_digest_finish(struct ahash_request *req, int err)
-{
-	struct crypto_ahash *tfm;
-
-	if (err)
-		goto out;
-
-	tfm = crypto_ahash_reqtfm(req);
-	if (ahash_is_async(tfm))
-		req->base.complete = ahash_def_finup_done1;
-
-	err = crypto_ahash_update(req);
-	if (err == -EINPROGRESS || err == -EBUSY)
-		return err;
-
-	return ahash_def_finup_finish1(req, err);
-
-out:
-	ahash_restore_req(req);
-	return err;
-}
-
-static void ahash_def_digest_done(void *data, int err)
-{
-	struct ahash_save_req_state *state0 = data;
-	struct ahash_save_req_state state;
-	struct ahash_request *areq;
-
-	state = *state0;
-	areq = state.req0;
-	if (err == -EINPROGRESS)
-		goto out;
-
-	areq->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	err = ahash_def_digest_finish(areq, err);
-	if (err == -EINPROGRESS || err == -EBUSY)
-		return;
-
-out:
-	state.compl(state.data, err);
-}
-
-static int ahash_def_digest(struct ahash_request *req)
-{
-	int err;
-
-	err = ahash_save_req(req, ahash_def_digest_done);
-	if (err)
-		return err;
-
-	err = crypto_ahash_init(req);
-	if (err == -EINPROGRESS || err == -EBUSY)
-		return err;
-
-	return ahash_def_digest_finish(req, err);
-}
-
 int crypto_ahash_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -622,18 +582,15 @@ int crypto_ahash_digest(struct ahash_request *req)
 		return shash_ahash_digest(req, prepare_shash_desc(req, tfm));
 	if (ahash_req_on_stack(req) && ahash_is_async(tfm))
 		return -EAGAIN;
-	if (!crypto_ahash_req_virt(tfm) && ahash_request_isvirt(req))
-		return ahash_def_digest(req);
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
-	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->digest);
+	return ahash_do_req_chain(req, &crypto_ahash_alg(tfm)->digest);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_digest);
 
 static void ahash_def_finup_done2(void *data, int err)
 {
-	struct ahash_save_req_state *state = data;
-	struct ahash_request *areq = state->req0;
+	struct ahash_request *areq = data;
 
 	if (err == -EINPROGRESS)
 		return;
@@ -644,14 +601,10 @@ static void ahash_def_finup_done2(void *data, int err)
 
 static int ahash_def_finup_finish1(struct ahash_request *req, int err)
 {
-	struct crypto_ahash *tfm;
-
 	if (err)
 		goto out;
 
-	tfm = crypto_ahash_reqtfm(req);
-	if (ahash_is_async(tfm))
-		req->base.complete = ahash_def_finup_done2;
+	req->base.complete = ahash_def_finup_done2;
 
 	err = crypto_ahash_final(req);
 	if (err == -EINPROGRESS || err == -EBUSY)
@@ -664,32 +617,14 @@ static int ahash_def_finup_finish1(struct ahash_request *req, int err)
 
 static void ahash_def_finup_done1(void *data, int err)
 {
-	struct ahash_save_req_state *state0 = data;
-	struct ahash_save_req_state state;
-	struct ahash_request *areq;
-
-	state = *state0;
-	areq = state.req0;
-	if (err == -EINPROGRESS)
-		goto out;
-
-	areq->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	err = ahash_def_finup_finish1(areq, err);
-	if (err == -EINPROGRESS || err == -EBUSY)
-		return;
-
-out:
-	state.compl(state.data, err);
+	ahash_op_done(data, err, ahash_def_finup_finish1);
 }
 
 static int ahash_def_finup(struct ahash_request *req)
 {
 	int err;
 
-	err = ahash_save_req(req, ahash_def_finup_done1);
-	if (err)
-		return err;
+	ahash_save_req(req, ahash_def_finup_done1);
 
 	err = crypto_ahash_update(req);
 	if (err == -EINPROGRESS || err == -EBUSY)
@@ -714,6 +649,14 @@ int crypto_ahash_export(struct ahash_request *req, void *out)
 
 	if (likely(tfm->using_shash))
 		return crypto_shash_export(ahash_request_ctx(req), out);
+	if (crypto_ahash_block_only(tfm)) {
+		unsigned int plen = crypto_ahash_blocksize(tfm) + 1;
+		unsigned int reqsize = crypto_ahash_reqsize(tfm);
+		unsigned int ss = crypto_ahash_statesize(tfm);
+		u8 *buf = ahash_request_ctx(req);
+
+		memcpy(out + ss - plen, buf + reqsize - plen, plen);
+	}
 	return crypto_ahash_alg(tfm)->export(req, out);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_export);
@@ -737,8 +680,12 @@ int crypto_ahash_import(struct ahash_request *req, const void *in)
 
 	if (likely(tfm->using_shash))
 		return crypto_shash_import(prepare_shash_desc(req, tfm), in);
-	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
-		return -ENOKEY;
+	if (crypto_ahash_block_only(tfm)) {
+		unsigned int reqsize = crypto_ahash_reqsize(tfm);
+		u8 *buf = ahash_request_ctx(req);
+
+		buf[reqsize - 1] = 0;
+	}
 	return crypto_ahash_import_core(req, in);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_import);
@@ -753,7 +700,7 @@ static void crypto_ahash_exit_tfm(struct crypto_tfm *tfm)
 	else if (tfm->__crt_alg->cra_exit)
 		tfm->__crt_alg->cra_exit(tfm);
 
-	if (ahash_is_async(hash))
+	if (crypto_ahash_need_fallback(hash))
 		crypto_free_ahash(crypto_ahash_fb(hash));
 }
 
@@ -770,9 +717,14 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 	if (tfm->__crt_alg->cra_type == &crypto_shash_type)
 		return crypto_init_ahash_using_shash(tfm);
 
-	if (ahash_is_async(hash)) {
+	if (crypto_ahash_need_fallback(hash)) {
+		unsigned int block_only = crypto_ahash_block_only(hash) ?
+					  CRYPTO_AHASH_ALG_BLOCK_ONLY : 0;
+
 		fb = crypto_alloc_ahash(crypto_ahash_alg_name(hash),
-					0, CRYPTO_ALG_ASYNC);
+					CRYPTO_ALG_REQ_VIRT | block_only,
+					CRYPTO_ALG_ASYNC |
+					CRYPTO_ALG_REQ_VIRT | block_only);
 		if (IS_ERR(fb))
 			return PTR_ERR(fb);
 
@@ -797,6 +749,10 @@ static int crypto_ahash_init_tfm(struct crypto_tfm *tfm)
 				     MAX_SYNC_HASH_REQSIZE)
 		goto out_exit_tfm;
 
+	BUILD_BUG_ON(HASH_MAX_DESCSIZE > MAX_SYNC_HASH_REQSIZE);
+	if (crypto_ahash_reqsize(hash) < HASH_MAX_DESCSIZE)
+		crypto_ahash_set_reqsize(hash, HASH_MAX_DESCSIZE);
+
 	return 0;
 
 out_exit_tfm:
@@ -941,7 +897,7 @@ struct crypto_ahash *crypto_clone_ahash(struct crypto_ahash *hash)
 		return nhash;
 	}
 
-	if (ahash_is_async(hash)) {
+	if (crypto_ahash_need_fallback(hash)) {
 		fb = crypto_clone_ahash(crypto_ahash_fb(hash));
 		err = PTR_ERR(fb);
 		if (IS_ERR(fb))
@@ -993,9 +949,22 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	base->cra_type = &crypto_ahash_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_AHASH;
 
+	if ((base->cra_flags ^ CRYPTO_ALG_REQ_VIRT) &
+	    (CRYPTO_ALG_ASYNC | CRYPTO_ALG_REQ_VIRT))
+		base->cra_flags |= CRYPTO_ALG_NEED_FALLBACK;
+
 	if (!alg->setkey)
 		alg->setkey = ahash_nosetkey;
 
+	if (base->cra_flags & CRYPTO_AHASH_ALG_BLOCK_ONLY) {
+		BUILD_BUG_ON(MAX_ALGAPI_BLOCKSIZE >= 256);
+		if (!alg->finup)
+			return -EINVAL;
+
+		base->cra_reqsize += base->cra_blocksize + 1;
+		alg->halg.statesize += base->cra_blocksize + 1;
+	}
+
 	return 0;
 }
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 9fc9daaaaab4..540e09ff395d 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -8,8 +8,8 @@
 #ifndef _CRYPTO_HASH_H
 #define _CRYPTO_HASH_H
 
-#include <linux/atomic.h>
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 
@@ -65,6 +65,10 @@ struct ahash_request {
 	};
 	u8 *result;
 
+	struct scatterlist sg_head[2];
+	crypto_completion_t saved_complete;
+	void *saved_data;
+
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
@@ -478,7 +482,11 @@ int crypto_ahash_finup(struct ahash_request *req);
  * -EBUSY	if queue is full and request should be resubmitted later;
  * other < 0	if an error occurred
  */
-int crypto_ahash_final(struct ahash_request *req);
+static inline int crypto_ahash_final(struct ahash_request *req)
+{
+	req->nbytes = 0;
+	return crypto_ahash_finup(req);
+}
 
 /**
  * crypto_ahash_digest() - calculate message digest for a buffer
-- 
2.39.5

