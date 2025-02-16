Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47922199B8
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 03:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739675244; cv=none; b=DIUGOgSvWAMeYDZT6e3LR4z6d2E/zpXldRKfLB8Ei+jifjG5AkQRTe2pmX0+8osCRCCQN6CPX/SPJlFozxDNnGlx4xZf+q8LeVKgI1b32VEFo4gKvbk2+T72JXq0FNTeHQwl90Ks6Nw5aDG/Y/PhoxSh7QVc4nmgvuZ9P8xt9Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739675244; c=relaxed/simple;
	bh=ngVqmcVjyuRr0fzi+JKTUsW81NW3PTctVC2QF4dOB4Y=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=ILkHLsHTVnKuQG77Ih0uWTzdAfvLgPPzSbXf2lEJMq44FyuWGCSz0xD0/uccNM1GW6yd5q3zXpnph7yKfYckM0KJjeMBgmwxBVOkOnoS7zVe5Qw5SO2iY/IPU0R/R6ZUh9eXdPhFEtwie2suyfUhpKnV5+pC6MgsTCVpDKunLZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=dFFBYkHT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="dFFBYkHT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=jrSfLFfLt6LV+gM98uhBTRMPVhMJjEWqhHmSmGKFnUc=; b=dFFBYkHTnV6sljQuGQ/hPRm03g
	R+m3bDnt1897JWyDc9r/uZw2eJowR4E2A9E+PAFD35zTVNyYl6DZfP5k5Xh7vAStXPmwBZ46aEkvq
	YoLnqLr6Dv8sdCd6ujHmuSyEtmyp9BKBY7Agys13IsJglmRJ4vbItAbwrMG0KQTgshEHj2fgj/T6L
	zFn8o1OBmzcsOVB8W0k1AKphaJsMsksRcwL4Ty1ZyoVVU3TLeZ71+0LHINBczZHZagxWss8r99rjr
	gxvTJ7Iq6LWGR0/98MBLAZGWgmC0bNKSytz032Qmla9ZkHweGxTYFBfO3tsBclUTcJ6fhPyGeK5zv
	iIqeyGJQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjUn6-000gXt-2U;
	Sun, 16 Feb 2025 11:07:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 11:07:17 +0800
Date: Sun, 16 Feb 2025 11:07:17 +0800
Message-Id: <2620cdada3777a66d3600cd1887cd34245d1e26a.1739674648.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1739674648.git.herbert@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 03/11] crypto: hash - Add request chaining API
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This adds request chaining to the ahash interface.  Request chaining
allows multiple requests to be submitted in one shot.  An algorithm
can elect to receive chained requests by setting the flag
CRYPTO_ALG_REQ_CHAIN.  If this bit is not set, the API will break
up chained requests and submit them one-by-one.

A new err field is added to struct crypto_async_request to record
the return value for each individual request.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c                 | 261 +++++++++++++++++++++++++++++----
 crypto/algapi.c                |   2 +-
 include/crypto/algapi.h        |  11 ++
 include/crypto/hash.h          |  28 ++--
 include/crypto/internal/hash.h |  10 ++
 include/linux/crypto.h         |  24 +++
 6 files changed, 299 insertions(+), 37 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index c8e7327c6949..0546835f7304 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -28,11 +28,19 @@
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 
 struct ahash_save_req_state {
-	struct ahash_request *req;
+	struct list_head head;
+	struct ahash_request *req0;
+	struct ahash_request *cur;
+	int (*op)(struct ahash_request *req);
 	crypto_completion_t compl;
 	void *data;
 };
 
+static void ahash_reqchain_done(void *data, int err);
+static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt);
+static void ahash_restore_req(struct ahash_request *req);
+static int ahash_def_finup(struct ahash_request *req);
+
 /*
  * For an ahash tfm that is using an shash algorithm (instead of an ahash
  * algorithm), this returns the underlying shash tfm.
@@ -256,24 +264,145 @@ int crypto_ahash_setkey(struct crypto_ahash *tfm, const u8 *key,
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_setkey);
 
+static int ahash_reqchain_finish(struct ahash_save_req_state *state,
+				 int err, u32 mask)
+{
+	struct ahash_request *req0 = state->req0;
+	struct ahash_request *req = state->cur;
+	struct ahash_request *n;
+
+	req->base.err = err;
+
+	if (req != req0)
+		list_add_tail(&req->base.list, &req0->base.list);
+
+	list_for_each_entry_safe(req, n, &state->head, base.list) {
+		list_del_init(&req->base.list);
+
+		req->base.flags &= mask;
+		req->base.complete = ahash_reqchain_done;
+		req->base.data = state;
+		state->cur = req;
+		err = state->op(req);
+
+		if (err == -EINPROGRESS) {
+			if (!list_empty(&state->head))
+				err = -EBUSY;
+			goto out;
+		}
+
+		if (err == -EBUSY)
+			goto out;
+
+		req->base.err = err;
+		list_add_tail(&req->base.list, &req0->base.list);
+	}
+
+	ahash_restore_req(req0);
+
+out:
+	return err;
+}
+
+static void ahash_reqchain_done(void *data, int err)
+{
+	struct ahash_save_req_state *state = data;
+	crypto_completion_t compl = state->compl;
+
+	data = state->data;
+
+	if (err == -EINPROGRESS) {
+		if (!list_empty(&state->head))
+			return;
+		goto notify;
+	}
+
+	err = ahash_reqchain_finish(state, err, CRYPTO_TFM_REQ_MAY_BACKLOG);
+	if (err == -EBUSY)
+		return;
+
+notify:
+	compl(data, err);
+}
+
+static int ahash_do_req_chain(struct ahash_request *req,
+			      int (*op)(struct ahash_request *req))
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ahash_save_req_state *state;
+	struct ahash_save_req_state state0;
+	int err;
+
+	if (!ahash_request_chained(req) || crypto_ahash_req_chain(tfm))
+		return op(req);
+
+	state = &state0;
+
+	if (ahash_is_async(tfm)) {
+		err = ahash_save_req(req, ahash_reqchain_done);
+		if (err) {
+			struct ahash_request *r2;
+
+			req->base.err = err;
+			list_for_each_entry(r2, &req->base.list, base.list)
+				r2->base.err = err;
+
+			return err;
+		}
+
+		state = req->base.data;
+	}
+
+	state->op = op;
+	state->cur = req;
+	INIT_LIST_HEAD(&state->head);
+	list_splice_init(&req->base.list, &state->head);
+
+	err = op(req);
+	if (err == -EBUSY || err == -EINPROGRESS)
+		return -EBUSY;
+
+	return ahash_reqchain_finish(state, err, ~0);
+}
+
 int crypto_ahash_init(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash))
-		return crypto_shash_init(prepare_shash_desc(req, tfm));
+	if (likely(tfm->using_shash)) {
+		struct ahash_request *r2;
+		int err;
+
+		err = crypto_shash_init(prepare_shash_desc(req, tfm));
+		req->base.err = err;
+
+		list_for_each_entry(r2, &req->base.list, base.list) {
+			struct shash_desc *desc;
+
+			desc = prepare_shash_desc(r2, tfm);
+			r2->base.err = crypto_shash_init(desc);
+		}
+
+		return err;
+	}
+
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
-	return crypto_ahash_alg(tfm)->init(req);
+
+	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->init);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_init);
 
 static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
 {
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	struct ahash_save_req_state *state;
 	gfp_t gfp;
 	u32 flags;
 
+	if (!ahash_is_async(tfm))
+		return 0;
+
 	flags = ahash_request_flags(req);
 	gfp = (flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?  GFP_KERNEL : GFP_ATOMIC;
 	state = kmalloc(sizeof(*state), gfp);
@@ -284,14 +413,20 @@ static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
 	state->data = req->base.data;
 	req->base.complete = cplt;
 	req->base.data = state;
-	state->req = req;
+	state->req0 = req;
 
 	return 0;
 }
 
 static void ahash_restore_req(struct ahash_request *req)
 {
-	struct ahash_save_req_state *state = req->base.data;
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct ahash_save_req_state *state;
+
+	if (!ahash_is_async(tfm))
+		return;
+
+	state = req->base.data;
 
 	req->base.complete = state->compl;
 	req->base.data = state->data;
@@ -302,10 +437,24 @@ int crypto_ahash_update(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash))
-		return shash_ahash_update(req, ahash_request_ctx(req));
+	if (likely(tfm->using_shash)) {
+		struct ahash_request *r2;
+		int err;
 
-	return crypto_ahash_alg(tfm)->update(req);
+		err = shash_ahash_update(req, ahash_request_ctx(req));
+		req->base.err = err;
+
+		list_for_each_entry(r2, &req->base.list, base.list) {
+			struct shash_desc *desc;
+
+			desc = ahash_request_ctx(r2);
+			r2->base.err = shash_ahash_update(r2, desc);
+		}
+
+		return err;
+	}
+
+	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->update);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_update);
 
@@ -313,10 +462,24 @@ int crypto_ahash_final(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash))
-		return crypto_shash_final(ahash_request_ctx(req), req->result);
+	if (likely(tfm->using_shash)) {
+		struct ahash_request *r2;
+		int err;
 
-	return crypto_ahash_alg(tfm)->final(req);
+		err = crypto_shash_final(ahash_request_ctx(req), req->result);
+		req->base.err = err;
+
+		list_for_each_entry(r2, &req->base.list, base.list) {
+			struct shash_desc *desc;
+
+			desc = ahash_request_ctx(r2);
+			r2->base.err = crypto_shash_final(desc, r2->result);
+		}
+
+		return err;
+	}
+
+	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->final);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_final);
 
@@ -324,10 +487,27 @@ int crypto_ahash_finup(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash))
-		return shash_ahash_finup(req, ahash_request_ctx(req));
+	if (likely(tfm->using_shash)) {
+		struct ahash_request *r2;
+		int err;
 
-	return crypto_ahash_alg(tfm)->finup(req);
+		err = shash_ahash_finup(req, ahash_request_ctx(req));
+		req->base.err = err;
+
+		list_for_each_entry(r2, &req->base.list, base.list) {
+			struct shash_desc *desc;
+
+			desc = ahash_request_ctx(r2);
+			r2->base.err = shash_ahash_finup(r2, desc);
+		}
+
+		return err;
+	}
+
+	if (!crypto_ahash_alg(tfm)->finup)
+		return ahash_def_finup(req);
+
+	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->finup);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_finup);
 
@@ -335,20 +515,34 @@ int crypto_ahash_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 
-	if (likely(tfm->using_shash))
-		return shash_ahash_digest(req, prepare_shash_desc(req, tfm));
+	if (likely(tfm->using_shash)) {
+		struct ahash_request *r2;
+		int err;
+
+		err = shash_ahash_digest(req, prepare_shash_desc(req, tfm));
+		req->base.err = err;
+
+		list_for_each_entry(r2, &req->base.list, base.list) {
+			struct shash_desc *desc;
+
+			desc = prepare_shash_desc(r2, tfm);
+			r2->base.err = shash_ahash_digest(r2, desc);
+		}
+
+		return err;
+	}
 
 	if (crypto_ahash_get_flags(tfm) & CRYPTO_TFM_NEED_KEY)
 		return -ENOKEY;
 
-	return crypto_ahash_alg(tfm)->digest(req);
+	return ahash_do_req_chain(req, crypto_ahash_alg(tfm)->digest);
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_digest);
 
 static void ahash_def_finup_done2(void *data, int err)
 {
 	struct ahash_save_req_state *state = data;
-	struct ahash_request *areq = state->req;
+	struct ahash_request *areq = state->req0;
 
 	if (err == -EINPROGRESS)
 		return;
@@ -359,12 +553,15 @@ static void ahash_def_finup_done2(void *data, int err)
 
 static int ahash_def_finup_finish1(struct ahash_request *req, int err)
 {
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+
 	if (err)
 		goto out;
 
-	req->base.complete = ahash_def_finup_done2;
+	if (ahash_is_async(tfm))
+		req->base.complete = ahash_def_finup_done2;
 
-	err = crypto_ahash_alg(crypto_ahash_reqtfm(req))->final(req);
+	err = crypto_ahash_final(req);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
@@ -380,7 +577,7 @@ static void ahash_def_finup_done1(void *data, int err)
 	struct ahash_request *areq;
 
 	state = *state0;
-	areq = state.req;
+	areq = state.req0;
 	if (err == -EINPROGRESS)
 		goto out;
 
@@ -396,14 +593,13 @@ static void ahash_def_finup_done1(void *data, int err)
 
 static int ahash_def_finup(struct ahash_request *req)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	int err;
 
 	err = ahash_save_req(req, ahash_def_finup_done1);
 	if (err)
 		return err;
 
-	err = crypto_ahash_alg(tfm)->update(req);
+	err = crypto_ahash_update(req);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
@@ -618,8 +814,6 @@ static int ahash_prepare_alg(struct ahash_alg *alg)
 	base->cra_type = &crypto_ahash_type;
 	base->cra_flags |= CRYPTO_ALG_TYPE_AHASH;
 
-	if (!alg->finup)
-		alg->finup = ahash_def_finup;
 	if (!alg->setkey)
 		alg->setkey = ahash_nosetkey;
 
@@ -690,5 +884,20 @@ int ahash_register_instance(struct crypto_template *tmpl,
 }
 EXPORT_SYMBOL_GPL(ahash_register_instance);
 
+void ahash_request_free(struct ahash_request *req)
+{
+	struct ahash_request *tmp;
+	struct ahash_request *r2;
+
+	if (unlikely(!req))
+		return;
+
+	list_for_each_entry_safe(r2, tmp, &req->base.list, base.list)
+		kfree_sensitive(r2);
+
+	kfree_sensitive(req);
+}
+EXPORT_SYMBOL_GPL(ahash_request_free);
+
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Asynchronous cryptographic hash type");
diff --git a/crypto/algapi.c b/crypto/algapi.c
index 5318c214debb..e7a9a2ada2cf 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -955,7 +955,7 @@ struct crypto_async_request *crypto_dequeue_request(struct crypto_queue *queue)
 		queue->backlog = queue->backlog->next;
 
 	request = queue->list.next;
-	list_del(request);
+	list_del_init(request);
 
 	return list_entry(request, struct crypto_async_request, list);
 }
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 156de41ca760..11065978d360 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -11,6 +11,7 @@
 #include <linux/align.h>
 #include <linux/cache.h>
 #include <linux/crypto.h>
+#include <linux/list.h>
 #include <linux/types.h>
 #include <linux/workqueue.h>
 
@@ -271,4 +272,14 @@ static inline u32 crypto_tfm_alg_type(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
 }
 
+static inline bool crypto_request_chained(struct crypto_async_request *req)
+{
+	return !list_empty(&req->list);
+}
+
+static inline bool crypto_tfm_req_chain(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_CHAIN;
+}
+
 #endif	/* _CRYPTO_ALGAPI_H */
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 9c1f8ca59a77..0a6f744ce4a1 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -572,16 +572,7 @@ static inline struct ahash_request *ahash_request_alloc_noprof(
  * ahash_request_free() - zeroize and free the request data structure
  * @req: request data structure cipher handle to be freed
  */
-static inline void ahash_request_free(struct ahash_request *req)
-{
-	kfree_sensitive(req);
-}
-
-static inline void ahash_request_zero(struct ahash_request *req)
-{
-	memzero_explicit(req, sizeof(*req) +
-			      crypto_ahash_reqsize(crypto_ahash_reqtfm(req)));
-}
+void ahash_request_free(struct ahash_request *req);
 
 static inline struct ahash_request *ahash_request_cast(
 	struct crypto_async_request *req)
@@ -622,6 +613,7 @@ static inline void ahash_request_set_callback(struct ahash_request *req,
 	req->base.complete = compl;
 	req->base.data = data;
 	req->base.flags = flags;
+	crypto_reqchain_init(&req->base);
 }
 
 /**
@@ -646,6 +638,12 @@ static inline void ahash_request_set_crypt(struct ahash_request *req,
 	req->result = result;
 }
 
+static inline void ahash_request_chain(struct ahash_request *req,
+				       struct ahash_request *head)
+{
+	crypto_request_chain(&req->base, &head->base);
+}
+
 /**
  * DOC: Synchronous Message Digest API
  *
@@ -947,4 +945,14 @@ static inline void shash_desc_zero(struct shash_desc *desc)
 			 sizeof(*desc) + crypto_shash_descsize(desc->tfm));
 }
 
+static inline int ahash_request_err(struct ahash_request *req)
+{
+	return req->base.err;
+}
+
+static inline bool ahash_is_async(struct crypto_ahash *tfm)
+{
+	return crypto_tfm_is_async(&tfm->base);
+}
+
 #endif	/* _CRYPTO_HASH_H */
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 58967593b6b4..81542a48587e 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -270,5 +270,15 @@ static inline struct crypto_shash *__crypto_shash_cast(struct crypto_tfm *tfm)
 	return container_of(tfm, struct crypto_shash, base);
 }
 
+static inline bool ahash_request_chained(struct ahash_request *req)
+{
+	return crypto_request_chained(&req->base);
+}
+
+static inline bool crypto_ahash_req_chain(struct crypto_ahash *tfm)
+{
+	return crypto_tfm_req_chain(&tfm->base);
+}
+
 #endif	/* _CRYPTO_INTERNAL_HASH_H */
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b164da5e129e..1d2a6c515d58 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -13,6 +13,8 @@
 #define _LINUX_CRYPTO_H
 
 #include <linux/completion.h>
+#include <linux/errno.h>
+#include <linux/list.h>
 #include <linux/refcount.h>
 #include <linux/slab.h>
 #include <linux/types.h>
@@ -124,6 +126,9 @@
  */
 #define CRYPTO_ALG_FIPS_INTERNAL	0x00020000
 
+/* Set if the algorithm supports request chains. */
+#define CRYPTO_ALG_REQ_CHAIN		0x00040000
+
 /*
  * Transform masks and values (for crt_flags).
  */
@@ -174,6 +179,7 @@ struct crypto_async_request {
 	struct crypto_tfm *tfm;
 
 	u32 flags;
+	int err;
 };
 
 /**
@@ -540,5 +546,23 @@ int crypto_comp_decompress(struct crypto_comp *tfm,
 			   const u8 *src, unsigned int slen,
 			   u8 *dst, unsigned int *dlen);
 
+static inline void crypto_reqchain_init(struct crypto_async_request *req)
+{
+	req->err = -EINPROGRESS;
+	INIT_LIST_HEAD(&req->list);
+}
+
+static inline void crypto_request_chain(struct crypto_async_request *req,
+					struct crypto_async_request *head)
+{
+	req->err = -EINPROGRESS;
+	list_add_tail(&req->list, &head->list);
+}
+
+static inline bool crypto_tfm_is_async(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC;
+}
+
 #endif	/* _LINUX_CRYPTO_H */
 
-- 
2.39.5

