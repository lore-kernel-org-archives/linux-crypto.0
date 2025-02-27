Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6CC22A4E0
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 10:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740651306; cv=none; b=nmiHD2ZWM7EfeEi5c7w8Xxe8YONgmVn2kKEAZXTW8MusHrtX3+V+9MXUTq+4lNI5eQc0KjtfMkJFPdlW68yB6UQ4Xhm16PCJQBMcqBMZRDi9peFn1AP+8QYC5rcrOmuFmBg7juaDaI8klYs9+TyaSKvrGM5lCYCpk3ITKLNql68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740651306; c=relaxed/simple;
	bh=983/R3Wrh+r4T8gJqoNIDGV/NxBoLkMuaxzLgQnbS04=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=Qj2LzURV90n5daY0crT2LuVIolXnxIhfFVcnzMvZVYKMnBHRyxrS7QauzXerHPZ88rak+eFwek63o+0w58b1UV3HLz2dKy+RN21GN+QcduEs/FQEDPxJwi87YU/e+a5ZYVvLpbLdNnUvxns1EChgSJoCzd06hHJq3rMt3T11ygI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=b0jjzhxD; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="b0jjzhxD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5bLm0Q94gEJgQpTepUh8jBt4BX7iBQgckVIz1+HDSw8=; b=b0jjzhxDEm4w22vBdiS01nujcH
	tOwm/kRJycBH+iY8c3ynLYLldXGucQyNXLUH1C5HN8sVPf89f22M0/gB0y6c0Ww4UJVJgVmgITy1l
	mE3ukpTSVLy9hs7EBC8WzHQuT8inkTgul5MSFDk+X1nImEQ8/geww9KXM+i3mjD8B3lGT20jwhYF2
	3qqjBxTAbZ1Hv2hxsQO1OYQh7RwCF47ccJyRUmIdYB6n1i7HUfZ5q63fzpfUAZ8fg6guKiG6VBivL
	QXVCaFTGPzO+WvRWzpdVhFK/myDTZPnu10hxF7axIZiVVfryaOihfYxYxUaVj6YDOOglRRIyrmmve
	VWK91Fbg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tnauy-002Dqy-10;
	Thu, 27 Feb 2025 18:15:01 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 27 Feb 2025 18:15:00 +0800
Date: Thu, 27 Feb 2025 18:15:00 +0800
Message-Id: <c4725c40e2c36e0f8954d3a3b20bb6099317f73b.1740651138.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1740651138.git.herbert@gondor.apana.org.au>
References: <cover.1740651138.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/7] crypto: acomp - Add request chaining and virtual
 addresses
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: linux-mm@kvack.org, Yosry Ahmed <yosry.ahmed@linux.dev>
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
 crypto/acompress.c                  | 201 ++++++++++++++++++++++++++++
 include/crypto/acompress.h          |  89 ++++++++++--
 include/crypto/internal/acompress.h |  22 +++
 3 files changed, 299 insertions(+), 13 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 30176316140a..d2103d4e42cc 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -23,6 +23,8 @@ struct crypto_scomp;
 
 static const struct crypto_type crypto_acomp_type;
 
+static void acomp_reqchain_done(void *data, int err);
+
 static inline struct acomp_alg *__crypto_acomp_alg(struct crypto_alg *alg)
 {
 	return container_of(alg, struct acomp_alg, calg.base);
@@ -153,6 +155,205 @@ void acomp_request_free(struct acomp_req *req)
 }
 EXPORT_SYMBOL_GPL(acomp_request_free);
 
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
+	if (!state->src)
+		return;
+
+	acomp_request_set_virt(req, state->src, state->dst, slen, dlen);
+	state->src = NULL;
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
+		if (acomp_request_isvirt(req)) {
+			unsigned int slen = req->slen;
+			unsigned int dlen = req->dlen;
+			const u8 *svirt = req->svirt;
+			u8 *dvirt = req->dvirt;
+
+			state->src = svirt;
+			state->dst = dvirt;
+
+			sg_init_one(&state->ssg, svirt, slen);
+			sg_init_one(&state->dsg, dvirt, dlen);
+
+			acomp_request_set_params(req, &state->ssg, &state->dsg,
+						 slen, dlen);
+		}
+
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
+	if (acomp_request_isvirt(req)) {
+		unsigned int slen = req->slen;
+		unsigned int dlen = req->dlen;
+		const u8 *svirt = req->svirt;
+		u8 *dvirt = req->dvirt;
+
+		state->src = svirt;
+		state->dst = dvirt;
+
+		sg_init_one(&state->ssg, svirt, slen);
+		sg_init_one(&state->dsg, dvirt, dlen);
+
+		acomp_request_set_params(req, &state->ssg, &state->dsg,
+					 slen, dlen);
+	}
+
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
index b6d5136e689d..15bb13e47f8b 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -12,10 +12,34 @@
 #include <linux/atomic.h>
 #include <linux/container_of.h>
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
+#include <linux/types.h>
 
 #define CRYPTO_ACOMP_ALLOC_OUTPUT	0x00000001
+
+/* Set this bit for virtual address instead of SG list. */
+#define CRYPTO_ACOMP_REQ_VIRT		0x00000002
+
+/* Set this bit for if virtual address buffer cannot be used for DMA. */
+#define CRYPTO_ACOMP_REQ_NONDMA		0x00000004
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
@@ -24,14 +48,24 @@
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
 
@@ -200,10 +234,14 @@ static inline void acomp_request_set_callback(struct acomp_req *req,
 					      crypto_completion_t cmpl,
 					      void *data)
 {
+	u32 keep = CRYPTO_ACOMP_ALLOC_OUTPUT | CRYPTO_ACOMP_REQ_VIRT;
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
@@ -230,11 +268,42 @@ static inline void acomp_request_set_params(struct acomp_req *req,
 	req->slen = slen;
 	req->dlen = dlen;
 
-	req->base.flags &= ~CRYPTO_ACOMP_ALLOC_OUTPUT;
+	req->base.flags &= ~(CRYPTO_ACOMP_ALLOC_OUTPUT | CRYPTO_ACOMP_REQ_VIRT);
 	if (!req->dst)
 		req->base.flags |= CRYPTO_ACOMP_ALLOC_OUTPUT;
 }
 
+/**
+ * acomp_request_set_virt() -- Sets virtual address request parameters
+ *
+ * Sets virtual address parameters required by an acomp operation
+ *
+ * @req:	asynchronous compress request
+ * @src:	virtual address pointer to input buffer
+ * @dst:	virtual address pointer to output buffer.
+ * @slen:	size of the input buffer
+ * @dlen:	size of the output buffer.
+ */
+static inline void acomp_request_set_virt(struct acomp_req *req,
+					  const u8 *src, u8 *dst,
+					  unsigned int slen,
+					  unsigned int dlen)
+{
+	req->svirt = src;
+	req->dvirt = dst;
+	req->slen = slen;
+	req->dlen = dlen;
+
+	req->base.flags &= ~CRYPTO_ACOMP_ALLOC_OUTPUT;
+	req->base.flags |= CRYPTO_ACOMP_REQ_VIRT;
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
@@ -244,10 +313,7 @@ static inline void acomp_request_set_params(struct acomp_req *req,
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
@@ -258,9 +324,6 @@ static inline int crypto_acomp_compress(struct acomp_req *req)
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
index 8831edaafc05..b3b48dea7f2f 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -109,4 +109,26 @@ void crypto_unregister_acomp(struct acomp_alg *alg);
 int crypto_register_acomps(struct acomp_alg *algs, int count);
 void crypto_unregister_acomps(struct acomp_alg *algs, int count);
 
+static inline bool acomp_request_chained(struct acomp_req *req)
+{
+	return crypto_request_chained(&req->base);
+}
+
+static inline bool acomp_request_isvirt(struct acomp_req *req)
+{
+	return req->base.flags & CRYPTO_ACOMP_REQ_VIRT;
+}
+
+static inline bool acomp_request_isnondma(struct acomp_req *req)
+{
+	return (req->base.flags &
+		(CRYPTO_ACOMP_REQ_NONDMA | CRYPTO_ACOMP_REQ_VIRT)) ==
+	       (CRYPTO_ACOMP_REQ_NONDMA | CRYPTO_ACOMP_REQ_VIRT);
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

