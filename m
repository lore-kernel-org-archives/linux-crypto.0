Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7A735964
	for <linux-crypto@vger.kernel.org>; Sun,  9 Mar 2025 02:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741488208; cv=none; b=TONfxoahc60/PdrYiVacRLwg6yJ/H2glta1+PVp5tIZzc8VeQ4X4ETDDrA2exRGqKevYTZikq+oI7SatTCGvSo6U5FxO5obGgVyhDnHakZlPrBireSOka8xfugba4SBL96ogK7MLkz5sYkpmcYrX0LV/1ojcczxJ+yK0X4ND+Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741488208; c=relaxed/simple;
	bh=FyBtr8XpRM0UJfNREODTLfouBnWh5jfOiRz6etvFirI=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=mNQPHk0eWb59QH7PrhTkx75JOWSKBdM2NjgKWgUy3dJGtLrXRJ23CJiIm5+uAPNFETCUwZPo57ZIodLOIw24JMAg7gZQHS1w16BgTms35rhQY7Y4B+dt40RDTeoRgAUtD/Giq8OOAbVJ1oZSSXjY/4y8R6gLWn0Q1snTvL29GxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=U0tIuWqf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="U0tIuWqf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2vvdqs0cESZ5aaFG4LyQxqmkcLcKEewb2GXbqdmmPo8=; b=U0tIuWqfubYquyEBBUG05+ugW5
	YVclxcxBe4NHYZEhjV2UrVpPVk354WB63M4EtlCobYM+VG9W3+FBwJN5xcB8y2cip6E6kF6JnujVn
	MYmzR9sv22y3ucEstUlSFLaNHQlN82DFtoDXezVCFN+0xs7a6yuOHxO27jqGVK6pZFEVoh9geCSSV
	ijB61mWSycKag9h+juYcz/HuV+kC1fY+krH5vQwqlc0mpj2C4xgLuKcqcsZQLEy5M0Ld011vJ8y9m
	dvvAmrxujzlr3IQ+jmv3aCXqmiO5Iic5CcJLLe2OLGUuCH7aSvm0JkE5k0tiPHk2wBe3xgYvdZZqP
	HuKu7pzg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tr6dN-004zHe-2F;
	Sun, 09 Mar 2025 10:43:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Mar 2025 10:43:21 +0800
Date: Sun, 09 Mar 2025 10:43:21 +0800
Message-Id: <e9da3237a4b9ca0a9c8aad8f182997ad14320b5a.1741488107.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1741488107.git.herbert@gondor.apana.org.au>
References: <cover.1741488107.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v3 PATCH 5/8] crypto: acomp - Add request chaining and virtual
 addresses
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, Sergey Senozhatsky <senozhatsky@chromium.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

This adds request chaining and virtual address support to the
acomp interface.

It is identical to the ahash interface, except that a new flag
CRYPTO_ACOMP_REQ_NONDMA has been added to indicate that the
virtual addresses are not suitable for DMA.  This is because
all existing and potential acomp users can provide memory that
is suitable for DMA so there is no need for a fall-back copy
path.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/acompress.c                  | 197 +++++++++++++++++++++++++++
 include/crypto/acompress.h          | 198 ++++++++++++++++++++++++++--
 include/crypto/internal/acompress.h |  42 ++++++
 3 files changed, 424 insertions(+), 13 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index ef36ec31d73d..45444e99a9db 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -23,6 +23,8 @@ struct crypto_scomp;
 
 static const struct crypto_type crypto_acomp_type;
 
+static void acomp_reqchain_done(void *data, int err);
+
 static inline struct acomp_alg *__crypto_acomp_alg(struct crypto_alg *alg)
 {
 	return container_of(alg, struct acomp_alg, calg.base);
@@ -123,6 +125,201 @@ struct crypto_acomp *crypto_alloc_acomp_node(const char *alg_name, u32 type,
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_acomp_node);
 
+static bool acomp_request_has_nondma(struct acomp_req *req)
+{
+	struct acomp_req *r2;
+
+	if (acomp_request_isnondma(req))
+		return true;
+
+	list_for_each_entry(r2, &req->base.list, base.list)
+		if (acomp_request_isnondma(r2))
+			return true;
+
+	return false;
+}
+
+static void acomp_save_req(struct acomp_req *req, crypto_completion_t cplt)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	struct acomp_req_chain *state = &req->chain;
+
+	if (!acomp_is_async(tfm))
+		return;
+
+	state->compl = req->base.complete;
+	state->data = req->base.data;
+	req->base.complete = cplt;
+	req->base.data = state;
+	state->req0 = req;
+}
+
+static void acomp_restore_req(struct acomp_req_chain *state)
+{
+	struct acomp_req *req = state->req0;
+	struct crypto_acomp *tfm;
+
+	tfm = crypto_acomp_reqtfm(req);
+	if (!acomp_is_async(tfm))
+		return;
+
+	req->base.complete = state->compl;
+	req->base.data = state->data;
+}
+
+static void acomp_reqchain_virt(struct acomp_req_chain *state, int err)
+{
+	struct acomp_req *req = state->cur;
+	unsigned int slen = req->slen;
+	unsigned int dlen = req->dlen;
+
+	req->base.err = err;
+	state = &req->chain;
+
+	if (state->src)
+		acomp_request_set_src_dma(req, state->src, slen);
+	if (state->dst)
+		acomp_request_set_dst_dma(req, state->dst, dlen);
+	state->src = NULL;
+	state->dst = NULL;
+}
+
+static void acomp_virt_to_sg(struct acomp_req *req)
+{
+	struct acomp_req_chain *state = &req->chain;
+
+	if (acomp_request_src_isvirt(req)) {
+		unsigned int slen = req->slen;
+		const u8 *svirt = req->svirt;
+
+		state->src = svirt;
+		sg_init_one(&state->ssg, svirt, slen);
+		acomp_request_set_src_sg(req, &state->ssg, slen);
+	}
+
+	if (acomp_request_dst_isvirt(req)) {
+		unsigned int dlen = req->dlen;
+		u8 *dvirt = req->dvirt;
+
+		state->dst = dvirt;
+		sg_init_one(&state->dsg, dvirt, dlen);
+		acomp_request_set_dst_sg(req, &state->dsg, dlen);
+	}
+}
+
+static int acomp_reqchain_finish(struct acomp_req_chain *state,
+				 int err, u32 mask)
+{
+	struct acomp_req *req0 = state->req0;
+	struct acomp_req *req = state->cur;
+	struct acomp_req *n;
+
+	acomp_reqchain_virt(state, err);
+
+	if (req != req0)
+		list_add_tail(&req->base.list, &req0->base.list);
+
+	list_for_each_entry_safe(req, n, &state->head, base.list) {
+		list_del_init(&req->base.list);
+
+		req->base.flags &= mask;
+		req->base.complete = acomp_reqchain_done;
+		req->base.data = state;
+		state->cur = req;
+
+		acomp_virt_to_sg(req);
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
+		acomp_reqchain_virt(state, err);
+		list_add_tail(&req->base.list, &req0->base.list);
+	}
+
+	acomp_restore_req(state);
+
+out:
+	return err;
+}
+
+static void acomp_reqchain_done(void *data, int err)
+{
+	struct acomp_req_chain *state = data;
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
+	err = acomp_reqchain_finish(state, err, CRYPTO_TFM_REQ_MAY_BACKLOG);
+	if (err == -EBUSY)
+		return;
+
+notify:
+	compl(data, err);
+}
+
+static int acomp_do_req_chain(struct acomp_req *req,
+			      int (*op)(struct acomp_req *req))
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
+	struct acomp_req_chain *state = &req->chain;
+	int err;
+
+	if (crypto_acomp_req_chain(tfm) ||
+	    (!acomp_request_chained(req) && !acomp_request_isvirt(req)))
+		return op(req);
+
+	/*
+	 * There are no in-kernel users that do this.  If and ever
+	 * such users come into being then we could add a fall-back
+	 * path.
+	 */
+	if (acomp_request_has_nondma(req))
+		return -EINVAL;
+
+	if (acomp_is_async(tfm)) {
+		acomp_save_req(req, acomp_reqchain_done);
+		state = req->base.data;
+	}
+
+	state->op = op;
+	state->cur = req;
+	state->src = NULL;
+	INIT_LIST_HEAD(&state->head);
+	list_splice_init(&req->base.list, &state->head);
+
+	acomp_virt_to_sg(req);
+	err = op(req);
+	if (err == -EBUSY || err == -EINPROGRESS)
+		return -EBUSY;
+
+	return acomp_reqchain_finish(state, err, ~0);
+}
+
+int crypto_acomp_compress(struct acomp_req *req)
+{
+	return acomp_do_req_chain(req, crypto_acomp_reqtfm(req)->compress);
+}
+EXPORT_SYMBOL_GPL(crypto_acomp_compress);
+
+int crypto_acomp_decompress(struct acomp_req *req)
+{
+	return acomp_do_req_chain(req, crypto_acomp_reqtfm(req)->decompress);
+}
+EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
+
 void comp_prepare_alg(struct comp_alg_common *alg)
 {
 	struct crypto_alg *base = &alg->base;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index c4937709ad0e..c4d8a29274c6 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -13,13 +13,42 @@
 #include <linux/compiler_types.h>
 #include <linux/container_of.h>
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/spinlock_types.h>
 #include <linux/types.h>
 
 #define CRYPTO_ACOMP_ALLOC_OUTPUT	0x00000001
+
+/* Set this bit if source is virtual address instead of SG list. */
+#define CRYPTO_ACOMP_REQ_SRC_VIRT	0x00000002
+
+/* Set this bit for if virtual address source cannot be used for DMA. */
+#define CRYPTO_ACOMP_REQ_SRC_NONDMA	0x00000004
+
+/* Set this bit if destination is virtual address instead of SG list. */
+#define CRYPTO_ACOMP_REQ_DST_VIRT	0x00000008
+
+/* Set this bit for if virtual address destination cannot be used for DMA. */
+#define CRYPTO_ACOMP_REQ_DST_NONDMA	0x00000010
+
 #define CRYPTO_ACOMP_DST_MAX		131072
 
+struct acomp_req;
+
+struct acomp_req_chain {
+	struct list_head head;
+	struct acomp_req *req0;
+	struct acomp_req *cur;
+	int (*op)(struct acomp_req *req);
+	crypto_completion_t compl;
+	void *data;
+	struct scatterlist ssg;
+	struct scatterlist dsg;
+	const u8 *src;
+	u8 *dst;
+};
+
 /**
  * struct acomp_req - asynchronous (de)compression request
  *
@@ -28,14 +57,24 @@
  * @dst:	Destination data
  * @slen:	Size of the input buffer
  * @dlen:	Size of the output buffer and number of bytes produced
+ * @chain:	Private API code data, do not use
  * @__ctx:	Start of private context data
  */
 struct acomp_req {
 	struct crypto_async_request base;
-	struct scatterlist *src;
-	struct scatterlist *dst;
+	union {
+		struct scatterlist *src;
+		const u8 *svirt;
+	};
+	union {
+		struct scatterlist *dst;
+		u8 *dvirt;
+	};
 	unsigned int slen;
 	unsigned int dlen;
+
+	struct acomp_req_chain chain;
+
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
@@ -222,10 +261,16 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 					      crypto_completion_t cmpl,
 					      void *data)
 {
+	u32 keep = CRYPTO_ACOMP_ALLOC_OUTPUT | CRYPTO_ACOMP_REQ_SRC_VIRT |
+		   CRYPTO_ACOMP_REQ_SRC_NONDMA | CRYPTO_ACOMP_REQ_DST_VIRT |
+		   CRYPTO_ACOMP_REQ_DST_NONDMA;
+
 	req->base.complete = cmpl;
 	req->base.data = data;
-	req->base.flags &= CRYPTO_ACOMP_ALLOC_OUTPUT;
-	req->base.flags |= flgs & ~CRYPTO_ACOMP_ALLOC_OUTPUT;
+	req->base.flags &= keep;
+	req->base.flags |= flgs & ~keep;
+
+	crypto_reqchain_init(&req->base);
 }
 
 /**
@@ -252,11 +297,144 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 	req->slen = slen;
 	req->dlen = dlen;
 
-	req->base.flags &= ~CRYPTO_ACOMP_ALLOC_OUTPUT;
+	req->base.flags &= ~(CRYPTO_ACOMP_ALLOC_OUTPUT |
+			     CRYPTO_ACOMP_REQ_SRC_VIRT |
+			     CRYPTO_ACOMP_REQ_SRC_NONDMA |
+			     CRYPTO_ACOMP_REQ_DST_VIRT |
+			     CRYPTO_ACOMP_REQ_DST_NONDMA);
 	if (!req->dst)
 		req->base.flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
 }
 
+/**
+ * acomp_request_set_src_sg() -- Sets source scatterlist
+ *
+ * Sets source scatterlist required by an acomp operation.
+ *
+ * @req:	asynchronous compress request
+ * @src:	pointer to input buffer scatterlist
+ * @slen:	size of the input buffer
+ */
+static inline void acomp_request_set_src_sg(struct acomp_req *req,
+					    struct scatterlist *src,
+					    unsigned int slen)
+{
+	req->src = src;
+	req->slen = slen;
+
+	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_NONDMA;
+	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_VIRT;
+}
+
+/**
+ * acomp_request_set_src_dma() -- Sets DMA source virtual address
+ *
+ * Sets source virtual address required by an acomp operation.
+ * The address must be usable for DMA.
+ *
+ * @req:	asynchronous compress request
+ * @src:	virtual address pointer to input buffer
+ * @slen:	size of the input buffer
+ */
+static inline void acomp_request_set_src_dma(struct acomp_req *req,
+					     const u8 *src, unsigned int slen)
+{
+	req->svirt = src;
+	req->slen = slen;
+
+	req->base.flags &= ~CRYPTO_ACOMP_REQ_SRC_NONDMA;
+	req->base.flags |= CRYPTO_ACOMP_REQ_SRC_VIRT;
+}
+
+/**
+ * acomp_request_set_src_nondma() -- Sets non-DMA source virtual address
+ *
+ * Sets source virtual address required by an acomp operation.
+ * The address can not be used for DMA.
+ *
+ * @req:	asynchronous compress request
+ * @src:	virtual address pointer to input buffer
+ * @slen:	size of the input buffer
+ */
+static inline void acomp_request_set_src_nondma(struct acomp_req *req,
+						const u8 *src,
+						unsigned int slen)
+{
+	req->svirt = src;
+	req->slen = slen;
+
+	req->base.flags |= CRYPTO_ACOMP_REQ_SRC_NONDMA;
+	req->base.flags |= CRYPTO_ACOMP_REQ_SRC_VIRT;
+}
+
+/**
+ * acomp_request_set_dst_sg() -- Sets destination scatterlist
+ *
+ * Sets destination scatterlist required by an acomp operation.
+ *
+ * @req:	asynchronous compress request
+ * @dst:	pointer to output buffer scatterlist
+ * @dlen:	size of the output buffer
+ */
+static inline void acomp_request_set_dst_sg(struct acomp_req *req,
+					    struct scatterlist *dst,
+					    unsigned int dlen)
+{
+	req->dst = dst;
+	req->dlen = dlen;
+
+	req->base.flags &= ~CRYPTO_ACOMP_REQ_DST_NONDMA;
+	req->base.flags &= ~CRYPTO_ACOMP_REQ_DST_VIRT;
+}
+
+/**
+ * acomp_request_set_dst_dma() -- Sets DMA destination virtual address
+ *
+ * Sets destination virtual address required by an acomp operation.
+ * The address must be usable for DMA.
+ *
+ * @req:	asynchronous compress request
+ * @dst:	virtual address pointer to output buffer
+ * @dlen:	size of the output buffer
+ */
+static inline void acomp_request_set_dst_dma(struct acomp_req *req,
+					     u8 *dst, unsigned int dlen)
+{
+	req->dvirt = dst;
+	req->dlen = dlen;
+
+	req->base.flags &= ~CRYPTO_ACOMP_ALLOC_OUTPUT;
+	req->base.flags &= ~CRYPTO_ACOMP_REQ_DST_NONDMA;
+	req->base.flags |= CRYPTO_ACOMP_REQ_DST_VIRT;
+}
+
+/**
+ * acomp_request_set_dst_nondma() -- Sets non-DMA destination virtual address
+ *
+ * Sets destination virtual address required by an acomp operation.
+ * The address can not be used for DMA.
+ *
+ * @req:	asynchronous compress request
+ * @dst:	virtual address pointer to output buffer
+ * @dlen:	size of the output buffer
+ */
+static inline void acomp_request_set_dst_nondma(struct acomp_req *req,
+						u8 *dst, unsigned int dlen)
+{
+	req->dvirt = dst;
+	req->dlen = dlen;
+
+	req->base.flags &= ~CRYPTO_ACOMP_ALLOC_OUTPUT;
+	req->base.flags |= CRYPTO_ACOMP_REQ_DST_NONDMA;
+	req->base.flags |= CRYPTO_ACOMP_REQ_DST_VIRT;
+}
+
+static inline void acomp_request_chain(struct acomp_req *req,
+				       struct acomp_req *head)
+{
+	crypto_request_chain(&req->base, &head->base);
+}
+
 /**
  * crypto_acomp_compress() -- Invoke asynchronous compress operation
  *
@@ -266,10 +444,7 @@ static inline void acomp_request_set_params(struct acomp_req *req,
  *
  * Return:	zero on success; error code in case of error
  */
-static inline int crypto_acomp_compress(struct acomp_req *req)
-{
-	return crypto_acomp_reqtfm(req)->compress(req);
-}
+int crypto_acomp_compress(struct acomp_req *req);
 
 /**
  * crypto_acomp_decompress() -- Invoke asynchronous decompress operation
@@ -280,9 +455,6 @@ static inline int crypto_acomp_compress(struct acomp_req *req)
  *
  * Return:	zero on success; error code in case of error
  */
-static inline int crypto_acomp_decompress(struct acomp_req *req)
-{
-	return crypto_acomp_reqtfm(req)->decompress(req);
-}
+int crypto_acomp_decompress(struct acomp_req *req);
 
 #endif
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 4a8f7e3beaa1..957a5ed7c7f1 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -94,4 +94,46 @@ void crypto_unregister_acomp(struct acomp_alg *alg);
 int crypto_register_acomps(struct acomp_alg *algs, int count);
 void crypto_unregister_acomps(struct acomp_alg *algs, int count);
 
+static inline bool acomp_request_chained(struct acomp_req *req)
+{
+	return crypto_request_chained(&req->base);
+}
+
+static inline bool acomp_request_src_isvirt(struct acomp_req *req)
+{
+	return req->base.flags & CRYPTO_ACOMP_REQ_SRC_VIRT;
+}
+
+static inline bool acomp_request_dst_isvirt(struct acomp_req *req)
+{
+	return req->base.flags & CRYPTO_ACOMP_REQ_DST_VIRT;
+}
+
+static inline bool acomp_request_isvirt(struct acomp_req *req)
+{
+	return req->base.flags & (CRYPTO_ACOMP_REQ_SRC_VIRT |
+				  CRYPTO_ACOMP_REQ_DST_VIRT);
+}
+
+static inline bool acomp_request_src_isnondma(struct acomp_req *req)
+{
+	return req->base.flags & CRYPTO_ACOMP_REQ_SRC_NONDMA;
+}
+
+static inline bool acomp_request_dst_isnondma(struct acomp_req *req)
+{
+	return req->base.flags & CRYPTO_ACOMP_REQ_DST_NONDMA;
+}
+
+static inline bool acomp_request_isnondma(struct acomp_req *req)
+{
+	return req->base.flags & (CRYPTO_ACOMP_REQ_SRC_NONDMA |
+				  CRYPTO_ACOMP_REQ_DST_NONDMA);
+}
+
+static inline bool crypto_acomp_req_chain(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_req_chain(&tfm->base);
+}
+
 #endif
-- 
2.39.5

