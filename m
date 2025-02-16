Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5C2175AB
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 03:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739675248; cv=none; b=Ploq8YfaJdhsTEWZV5A67//7uI4k8HSlzhJctlsKxnMpVoH55Pzeb53WNwbYf2D6AmabXbC+N0XvlPP5GRtLKJ8uTo2TfG96lHaN0n5+5/gtXUBZJsh4fSR4ZeMFf+aJnaTjUZiXo1vEizjcv88wJ/gVHh8cJqbxgeLI7J+/kX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739675248; c=relaxed/simple;
	bh=jziEbKrec9WOhZrx0dFqsFfkh1pNtoP0LbvwYTOBMvY=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=jxz7Xds6XmeB/tNtAtvEvwmv477MWakqgkeo1K1oxUzBZbaaXNT6MtqVawNpjsg0ysfI1gF2hF9o08doi3oQS801hgP2hrVnKnm7tfwcAGtQLLXM0PTIShOztzHhh4M1ExJLrfQyKMIWJGTuEV+W4xQ2rgRdlUfltkcKdf9aZ0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=A2Mox/6f; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="A2Mox/6f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=R9WGgoI571EuXd+Go6pmbGvnFR8S8xYvN+howKR/nUo=; b=A2Mox/6fj4GuinuUTNUMoG0qDK
	WD6mcanaE7lETcvsjydpqddIhOeo22PjpXIHf+cuhasqy51SLDyuEGLAYjWkLOHch/0oEEYVQzNoP
	xp3EgIetNB3fmKLWFygwMOweFuBQv5f3ETn6OZfha8iqMLys+yOitmASQOYoi3oa9dF42x1KejSFZ
	aWY1xxK3ZwDq/gn1yhODLseBWgyUsIWTijp/5FFfaCQpG3jh3JE2Yr8CqTKKlcA5SSowRV+Op/xdL
	DnLnhCnmJxnK4wfYVkIsXw3fUDSFkkJNQ6S3gLt8dQ4n2MB3zVWSRrltSfqIIBLcJMb6OddymoHzs
	g2g4jGhA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjUnB-000gYK-1C;
	Sun, 16 Feb 2025 11:07:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 11:07:22 +0800
Date: Sun, 16 Feb 2025 11:07:22 +0800
Message-Id: <2a7e040e93d8f2646131645289e63ce48e1ab182.1739674648.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1739674648.git.herbert@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 05/11] crypto: ahash - Add virtual address support
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This patch adds virtual address support to ahash.  Virtual addresses
were previously only supported through shash.  The user may choose
to use virtual addresses with ahash by calling ahash_request_set_virt
instead of ahash_request_set_crypt.

The API will take care of translating this to an SG list if necessary,
unless the algorithm declares that it supports chaining.  Therefore
in order for an ahash algorithm to support chaining, it must also
support virtual addresses directly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c                 | 280 +++++++++++++++++++++++++++++----
 include/crypto/hash.h          |  38 ++++-
 include/crypto/internal/hash.h |   7 +-
 include/linux/crypto.h         |   2 +-
 4 files changed, 293 insertions(+), 34 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index 0546835f7304..40ccaf4c0cd6 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -34,11 +34,17 @@ struct ahash_save_req_state {
 	int (*op)(struct ahash_request *req);
 	crypto_completion_t compl;
 	void *data;
+	struct scatterlist sg;
+	const u8 *src;
+	u8 *page;
+	unsigned int offset;
+	unsigned int nbytes;
 };
 
 static void ahash_reqchain_done(void *data, int err);
 static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt);
-static void ahash_restore_req(struct ahash_request *req);
+static void ahash_restore_req(struct ahash_save_req_state *state);
+static void ahash_def_finup_done1(void *data, int err);
 static int ahash_def_finup(struct ahash_request *req);
 
 /*
@@ -100,6 +106,10 @@ int shash_ahash_digest(struct ahash_request *req, struct shash_desc *desc)
 	unsigned int offset;
 	int err;
 
+	if (ahash_request_isvirt(req))
+		return crypto_shash_digest(desc, req->svirt, nbytes,
+					   req->result);
+
 	if (nbytes &&
 	    (sg = req->src, offset = sg->offset,
 	     nbytes <= min(sg->length, ((unsigned int)(PAGE_SIZE)) - offset))) {
@@ -182,6 +192,9 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 
 int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 {
+	if ((walk->flags & CRYPTO_AHASH_REQ_VIRT))
+		return err;
+
 	walk->data -= walk->offset;
 
 	kunmap_local(walk->data);
@@ -209,14 +222,20 @@ int crypto_hash_walk_first(struct ahash_request *req,
 			   struct crypto_hash_walk *walk)
 {
 	walk->total = req->nbytes;
+	walk->entrylen = 0;
 
-	if (!walk->total) {
-		walk->entrylen = 0;
+	if (!walk->total)
 		return 0;
+
+	walk->flags = req->base.flags;
+
+	if (ahash_request_isvirt(req)) {
+		walk->data = req->svirt;
+		walk->total = 0;
+		return req->nbytes;
 	}
 
 	walk->sg = req->src;
-	walk->flags = req->base.flags;
 
 	return hash_walk_new_entry(walk);
 }
@@ -264,18 +283,82 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
+static bool ahash_request_hasvirt(struct ahash_request *req)
+{
+	struct ahash_request *r2;
+
+	if (ahash_request_isvirt(req))
+		return true;
+
+	list_for_each_entry(r2, &req->base.list, base.list)
+		if (ahash_request_isvirt(r2))
+			return true;
+
+	return false;
+}
+
+static int ahash_reqchain_virt(struct ahash_save_req_state *state,
+			       int err, u32 mask)
+{
+	struct ahash_request *req = state->cur;
+
+	for (;;) {
+		unsigned len = state->nbytes;
+
+		req->base.err = err;
+
+		if (!state->offset)
+			break;
+
+		if (state->offset == len || err) {
+			u8 *result = req->result;
+
+			ahash_request_set_virt(req, state->src, result, len);
+			state->offset = 0;
+			break;
+		}
+
+		len -= state->offset;
+
+		len = min(PAGE_SIZE, len);
+		memcpy(state->page, state->src + state->offset, len);
+		state->offset += len;
+		req->nbytes = len;
+
+		err = state->op(req);
+		if (err == -EINPROGRESS) {
+			if (!list_empty(&state->head) ||
+			    state->offset < state->nbytes)
+				err = -EBUSY;
+			break;
+		}
+
+		if (err == -EBUSY)
+			break;
+	}
+
+	return err;
+}
+
 static int ahash_reqchain_finish(struct ahash_save_req_state *state,
 				 int err, u32 mask)
 {
 	struct ahash_request *req0 = state->req0;
 	struct ahash_request *req = state->cur;
+	struct crypto_ahash *tfm;
 	struct ahash_request *n;
+	bool update;
 
-	req->base.err = err;
+	err = ahash_reqchain_virt(state, err, mask);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		goto out;
 
 	if (req != req0)
 		list_add_tail(&req->base.list, &req0->base.list);
 
+	tfm = crypto_ahash_reqtfm(req);
+	update = state->op == crypto_ahash_alg(tfm)->update;
+
 	list_for_each_entry_safe(req, n, &state->head, base.list) {
 		list_del_init(&req->base.list);
 
@@ -283,10 +366,27 @@ static int ahash_reqchain_finish(struct ahash_save_req_state *state,
 		req->base.complete = ahash_reqchain_done;
 		req->base.data = state;
 		state->cur = req;
+
+		if (update && ahash_request_isvirt(req) && req->nbytes) {
+			unsigned len = req->nbytes;
+			u8 *result = req->result;
+
+			state->src = req->svirt;
+			state->nbytes = len;
+
+			len = min(PAGE_SIZE, len);
+
+			memcpy(state->page, req->svirt, len);
+			state->offset = len;
+
+			ahash_request_set_crypt(req, &state->sg, result, len);
+		}
+
 		err = state->op(req);
 
 		if (err == -EINPROGRESS) {
-			if (!list_empty(&state->head))
+			if (!list_empty(&state->head) ||
+			    state->offset < state->nbytes)
 				err = -EBUSY;
 			goto out;
 		}
@@ -294,11 +394,14 @@ static int ahash_reqchain_finish(struct ahash_save_req_state *state,
 		if (err == -EBUSY)
 			goto out;
 
-		req->base.err = err;
+		err = ahash_reqchain_virt(state, err, mask);
+		if (err == -EINPROGRESS || err == -EBUSY)
+			goto out;
+
 		list_add_tail(&req->base.list, &req0->base.list);
 	}
 
-	ahash_restore_req(req0);
+	ahash_restore_req(state);
 
 out:
 	return err;
@@ -312,7 +415,7 @@ static void ahash_reqchain_done(void *data, int err)
 	data = state->data;
 
 	if (err == -EINPROGRESS) {
-		if (!list_empty(&state->head))
+		if (!list_empty(&state->head) || state->offset < state->nbytes)
 			return;
 		goto notify;
 	}
@@ -329,40 +432,84 @@ static int ahash_do_req_chain(struct ahash_request *req,
 			      int (*op)(struct ahash_request *req))
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	bool update = op == crypto_ahash_alg(tfm)->update;
 	struct ahash_save_req_state *state;
 	struct ahash_save_req_state state0;
+	struct ahash_request *r2;
+	u8 *page = NULL;
 	int err;
 
-	if (!ahash_request_chained(req) || crypto_ahash_req_chain(tfm))
+	if (crypto_ahash_req_chain(tfm) ||
+	    (!ahash_request_chained(req) &&
+	     (!update || !ahash_request_isvirt(req))))
 		return op(req);
 
-	state = &state0;
+	if (update && ahash_request_hasvirt(req)) {
+		gfp_t gfp;
+		u32 flags;
 
+		flags = ahash_request_flags(req);
+		gfp = (flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?
+		      GFP_KERNEL : GFP_ATOMIC;
+		page = (void *)__get_free_page(gfp);
+		err = -ENOMEM;
+		if (!page)
+			goto out_set_chain;
+	}
+
+	state = &state0;
 	if (ahash_is_async(tfm)) {
 		err = ahash_save_req(req, ahash_reqchain_done);
-		if (err) {
-			struct ahash_request *r2;
-
-			req->base.err = err;
-			list_for_each_entry(r2, &req->base.list, base.list)
-				r2->base.err = err;
-
-			return err;
-		}
+		if (err)
+			goto out_free_page;
 
 		state = req->base.data;
 	}
 
 	state->op = op;
 	state->cur = req;
+	state->page = page;
+	state->offset = 0;
+	state->nbytes = 0;
 	INIT_LIST_HEAD(&state->head);
 	list_splice_init(&req->base.list, &state->head);
 
+	if (page)
+		sg_init_one(&state->sg, page, PAGE_SIZE);
+
+	if (update && ahash_request_isvirt(req) && req->nbytes) {
+		unsigned len = req->nbytes;
+		u8 *result = req->result;
+
+		state->src = req->svirt;
+		state->nbytes = len;
+
+		len = min(PAGE_SIZE, len);
+
+		memcpy(page, req->svirt, len);
+		state->offset = len;
+
+		ahash_request_set_crypt(req, &state->sg, result, len);
+	}
+
 	err = op(req);
 	if (err == -EBUSY || err == -EINPROGRESS)
 		return -EBUSY;
 
 	return ahash_reqchain_finish(state, err, ~0);
+
+out_free_page:
+	if (page) {
+		memset(page, 0, PAGE_SIZE);
+		free_page((unsigned long)page);
+	}
+
+out_set_chain:
+	req->base.err = err;
+	list_for_each_entry(r2, &req->base.list, base.list)
+		r2->base.err = err;
+
+	return err;
 }
 
 int crypto_ahash_init(struct ahash_request *req)
@@ -414,15 +561,19 @@ static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
 	req->base.complete = cplt;
 	req->base.data = state;
 	state->req0 = req;
+	state->page = NULL;
 
 	return 0;
 }
 
-static void ahash_restore_req(struct ahash_request *req)
+static void ahash_restore_req(struct ahash_save_req_state *state)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	struct ahash_save_req_state *state;
+	struct ahash_request *req = state->req0;
+	struct crypto_ahash *tfm;
 
+	free_page((unsigned long)state->page);
+
+	tfm = crypto_ahash_reqtfm(req);
 	if (!ahash_is_async(tfm))
 		return;
 
@@ -504,13 +655,74 @@ int crypto_ahash_finup(struct ahash_request *req)
 		return err;
 	}
 
-	if (!crypto_ahash_alg(tfm)->finup)
+	if (!crypto_ahash_alg(tfm)->finup ||
+	    (!crypto_ahash_req_chain(tfm) && ahash_request_hasvirt(req)))
 		return ahash_def_finup(req);
 
 	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->finup);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_finup);
 
+static int ahash_def_digest_finish(struct ahash_save_req_state *state, int err)
+{
+	struct ahash_request *req = state->req0;
+	struct crypto_ahash *tfm;
+
+	if (err)
+		goto out;
+
+	tfm = crypto_ahash_reqtfm(req);
+	if (ahash_is_async(tfm))
+		req->base.complete = ahash_def_finup_done1;
+
+	err = crypto_ahash_update(req);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		return err;
+
+out:
+	ahash_restore_req(state);
+	return err;
+}
+
+static void ahash_def_digest_done(void *data, int err)
+{
+	struct ahash_save_req_state *state0 = data;
+	struct ahash_save_req_state state;
+	struct ahash_request *areq;
+
+	state = *state0;
+	areq = state.req0;
+	if (err == -EINPROGRESS)
+		goto out;
+
+	areq->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	err = ahash_def_digest_finish(state0, err);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		return;
+
+out:
+	state.compl(state.data, err);
+}
+
+static int ahash_def_digest(struct ahash_request *req)
+{
+	struct ahash_save_req_state *state;
+	int err;
+
+	err = ahash_save_req(req, ahash_def_digest_done);
+	if (err)
+		return err;
+
+	state = req->base.data;
+
+	err = crypto_ahash_init(req);
+	if (err == -EINPROGRESS || err == -EBUSY)
+		return err;
+
+	return ahash_def_digest_finish(state, err);
+}
+
 int crypto_ahash_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -532,6 +744,9 @@ int crypto_ahash_digest(struct ahash_request *req)
 		return err;
 	}
 
+	if (!crypto_ahash_req_chain(tfm) && ahash_request_hasvirt(req))
+		return ahash_def_digest(req);
+
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
 
@@ -547,17 +762,19 @@ static void ahash_def_finup_done2(void *data, int err)
 	if (err == -EINPROGRESS)
 		return;
 
-	ahash_restore_req(areq);
+	ahash_restore_req(state);
 	ahash_request_complete(areq, err);
 }
 
-static int ahash_def_finup_finish1(struct ahash_request *req, int err)
+static int ahash_def_finup_finish1(struct ahash_save_req_state *state, int err)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ahash_request *req = state->req0;
+	struct crypto_ahash *tfm;
 
 	if (err)
 		goto out;
 
+	tfm = crypto_ahash_reqtfm(req);
 	if (ahash_is_async(tfm))
 		req->base.complete = ahash_def_finup_done2;
 
@@ -566,7 +783,7 @@ static int ahash_def_finup_finish1(struct ahash_request *req, int err)
 		return err;
 
 out:
-	ahash_restore_req(req);
+	ahash_restore_req(state);
 	return err;
 }
 
@@ -583,7 +800,7 @@ static void ahash_def_finup_done1(void *data, int err)
 
 	areq->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
-	err = ahash_def_finup_finish1(areq, err);
+	err = ahash_def_finup_finish1(state0, err);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return;
 
@@ -593,17 +810,20 @@ static void ahash_def_finup_done1(void *data, int err)
 
 static int ahash_def_finup(struct ahash_request *req)
 {
+	struct ahash_save_req_state *state;
 	int err;
 
 	err = ahash_save_req(req, ahash_def_finup_done1);
 	if (err)
 		return err;
 
+	state = req->base.data;
+
 	err = crypto_ahash_update(req);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
-	return ahash_def_finup_finish1(req, err);
+	return ahash_def_finup_finish1(state, err);
 }
 
 int crypto_ahash_export(struct ahash_request *req, void *out)
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 0a6f744ce4a1..4e87e39679cb 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -12,6 +12,9 @@
 #include <linux/crypto.h>
 #include <linux/string.h>
 
+/* Set this bit for virtual address instead of SG list. */
+#define CRYPTO_AHASH_REQ_VIRT	0x00000001
+
 struct crypto_ahash;
 
 /**
@@ -52,7 +55,10 @@ struct ahash_request {
 	struct crypto_async_request base;
 
 	unsigned int nbytes;
-	struct scatterlist *src;
+	union {
+		struct scatterlist *src;
+		const u8 *svirt;
+	};
 	u8 *result;
 
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
@@ -610,9 +616,13 @@ static inline void ahash_request_set_callback(struct ahash_request *req,
 					      crypto_completion_t compl,
 					      void *data)
 {
+	u32 keep = CRYPTO_AHASH_REQ_VIRT;
+
 	req->base.complete = compl;
 	req->base.data = data;
-	req->base.flags = flags;
+	flags &= ~keep;
+	req->base.flags &= keep;
+	req->base.flags |= flags;
 	crypto_reqchain_init(&req->base);
 }
 
@@ -636,6 +646,30 @@ static inline void ahash_request_set_crypt(struct ahash_request *req,
 	req->src = src;
 	req->nbytes = nbytes;
 	req->result = result;
+	req->base.flags &= ~CRYPTO_AHASH_REQ_VIRT;
+}
+
+/**
+ * ahash_request_set_virt() - set virtual address data buffers
+ * @req: ahash_request handle to be updated
+ * @src: source virtual address
+ * @result: buffer that is filled with the message digest -- the caller must
+ *	    ensure that the buffer has sufficient space by, for example, calling
+ *	    crypto_ahash_digestsize()
+ * @nbytes: number of bytes to process from the source virtual address
+ *
+ * By using this call, the caller references the source virtual address.
+ * The source virtual address points to the data the message digest is to
+ * be calculated for.
+ */
+static inline void ahash_request_set_virt(struct ahash_request *req,
+					  const u8 *src, u8 *result,
+					  unsigned int nbytes)
+{
+	req->svirt = src;
+	req->nbytes = nbytes;
+	req->result = result;
+	req->base.flags |= CRYPTO_AHASH_REQ_VIRT;
 }
 
 static inline void ahash_request_chain(struct ahash_request *req,
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 81542a48587e..195d6aeeede3 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -15,7 +15,7 @@ struct ahash_request;
 struct scatterlist;
 
 struct crypto_hash_walk {
-	char *data;
+	const char *data;
 
 	unsigned int offset;
 	unsigned int flags;
@@ -275,6 +275,11 @@ static inline bool ahash_request_chained(struct ahash_request *req)
 	return crypto_request_chained(&req->base);
 }
 
+static inline bool ahash_request_isvirt(struct ahash_request *req)
+{
+	return req->base.flags & CRYPTO_AHASH_REQ_VIRT;
+}
+
 static inline bool crypto_ahash_req_chain(struct crypto_ahash *tfm)
 {
 	return crypto_tfm_req_chain(&tfm->base);
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 1d2a6c515d58..61ac11226638 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -126,7 +126,7 @@
  */
 #define CRYPTO_ALG_FIPS_INTERNAL	0x00020000
 
-/* Set if the algorithm supports request chains. */
+/* Set if the algorithm supports request chains and virtual addresses. */
 #define CRYPTO_ALG_REQ_CHAIN		0x00040000
 
 /*
-- 
2.39.5

