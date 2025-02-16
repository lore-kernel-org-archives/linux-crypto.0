Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B1817E4
	for <linux-crypto@vger.kernel.org>; Sun, 16 Feb 2025 03:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739675239; cv=none; b=NcjAQVrMztQRLbh/fF9b8LNeh1SwTrLc5Se9mCXuCdgVaeohmPPzFoaZ6uZzeThw7/bm1wOmjKcbxluC5pieZt1sS+i1FyQd8cbAWiMCbcoQ7TyghfpdjxokbtamRyBpBWEpNkATom3Ads0PuqmR+Xybgtd6ZlYU5QqUPI1iZ/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739675239; c=relaxed/simple;
	bh=a5IvobQdDd67NuvafwjGwrdTks1mGVCWAx+yKT8yafs=;
	h=Date:Message-Id:In-Reply-To:References:From:Subject:To:Cc; b=qXh1TLru9GDplbEisCD2Mg3Y89Ry5hpxGObOdDt34mbFr0WwROYx1nkDRIKUbJhmsPfpV/OPYm04KeS7pBe4JAevs9RGvstzKDAYdmujVj5V7fmlqniXSnBtfcDRp5Wygm6APZDKStTxlEh26a5WEuU7Lg2cqoZF1fJqHEuHMhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=g1Zf6bF8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="g1Zf6bF8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=Cc:To:Subject:From:References:In-Reply-To:Message-Id:Date:
	Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cyd6Nq1HT0PcrsGafZnNvIlqd9vNMhgLdADFFGPRSjQ=; b=g1Zf6bF8axcT6Irs2BHlguoiDO
	sngdFNejlQZEHhR5LDQyBb3uLfBZZj1PYPJMnTlnnUombH2X55swlx9zm67FxbsUZknnBXB8zVKK8
	ZIEgDeyGqi7ZJayF+YVts1H0xU1Kyvu+a05U99bsygwexT8cdPuzm3Wl1YsFUu4ArRWSgzEdE6XmL
	h+VV+wcjFerYBAQ7JSnyuBXulCr16WAsc9JXLC6rnV8ZPv3s1D1HbSAMgR42k7dTQ/4kbpA8jX6Ee
	Dl6UVu65nSgvHXnCAVm0tvG7G5PQ/+LWhKsGPaXcC8qTE2b1dFhk8DN8Qyi1sa4+n0ctcgXwkdyyl
	uKc8DKqw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjUn2-000gXV-0W;
	Sun, 16 Feb 2025 11:07:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 11:07:12 +0800
Date: Sun, 16 Feb 2025 11:07:12 +0800
Message-Id: <2fc12150edcde501896347c565735acc3fc24eb3.1739674648.git.herbert@gondor.apana.org.au>
In-Reply-To: <cover.1739674648.git.herbert@gondor.apana.org.au>
References: <cover.1739674648.git.herbert@gondor.apana.org.au>
From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [v2 PATCH 01/11] crypto: ahash - Only save callback and data in
 ahash_save_req
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>

As unaligned operations are supported by the underlying algorithm,
ahash_save_req and ahash_restore_req can be greatly simplified to
only preserve the callback and data.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 crypto/ahash.c        | 97 ++++++++++++++++---------------------------
 include/crypto/hash.h |  3 --
 2 files changed, 35 insertions(+), 65 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index bcd9de009a91..c8e7327c6949 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -27,6 +27,12 @@
 
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000e
 
+struct ahash_save_req_state {
+	struct ahash_request *req;
+	crypto_completion_t compl;
+	void *data;
+};
+
 /*
  * For an ahash tfm that is using an shash algorithm (instead of an ahash
  * algorithm), this returns the underlying shash tfm.
@@ -262,67 +268,34 @@ int crypto_ahash_init(struct ahash_request *req)
 }
 EXPORT_SYMBOL_GPL(crypto_ahash_init);
 
-static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt,
-			  bool has_state)
+static int ahash_save_req(struct ahash_request *req, crypto_completion_t cplt)
 {
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
-	unsigned int ds = crypto_ahash_digestsize(tfm);
-	struct ahash_request *subreq;
-	unsigned int subreq_size;
-	unsigned int reqsize;
-	u8 *result;
+	struct ahash_save_req_state *state;
 	gfp_t gfp;
 	u32 flags;
 
-	subreq_size = sizeof(*subreq);
-	reqsize = crypto_ahash_reqsize(tfm);
-	reqsize = ALIGN(reqsize, crypto_tfm_ctx_alignment());
-	subreq_size += reqsize;
-	subreq_size += ds;
-
 	flags = ahash_request_flags(req);
 	gfp = (flags & CRYPTO_TFM_REQ_MAY_SLEEP) ?  GFP_KERNEL : GFP_ATOMIC;
-	subreq = kmalloc(subreq_size, gfp);
-	if (!subreq)
+	state = kmalloc(sizeof(*state), gfp);
+	if (!state)
 		return -ENOMEM;
 
-	ahash_request_set_tfm(subreq, tfm);
-	ahash_request_set_callback(subreq, flags, cplt, req);
-
-	result = (u8 *)(subreq + 1) + reqsize;
-
-	ahash_request_set_crypt(subreq, req->src, result, req->nbytes);
-
-	if (has_state) {
-		void *state;
-
-		state = kmalloc(crypto_ahash_statesize(tfm), gfp);
-		if (!state) {
-			kfree(subreq);
-			return -ENOMEM;
-		}
-
-		crypto_ahash_export(req, state);
-		crypto_ahash_import(subreq, state);
-		kfree_sensitive(state);
-	}
-
-	req->priv = subreq;
+	state->compl = req->base.complete;
+	state->data = req->base.data;
+	req->base.complete = cplt;
+	req->base.data = state;
+	state->req = req;
 
 	return 0;
 }
 
-static void ahash_restore_req(struct ahash_request *req, int err)
+static void ahash_restore_req(struct ahash_request *req)
 {
-	struct ahash_request *subreq = req->priv;
+	struct ahash_save_req_state *state = req->base.data;
 
-	if (!err)
-		memcpy(req->result, subreq->result,
-		       crypto_ahash_digestsize(crypto_ahash_reqtfm(req)));
-
-	req->priv = NULL;
-
-	kfree_sensitive(subreq);
+	req->base.complete = state->compl;
+	req->base.data = state->data;
+	kfree(state);
 }
 
 int crypto_ahash_update(struct ahash_request *req)
@@ -374,51 +347,51 @@ EXPORT_SYMBOL_GPL(crypto_ahash_digest);
 
 static void ahash_def_finup_done2(void *data, int err)
 {
-	struct ahash_request *areq = data;
+	struct ahash_save_req_state *state = data;
+	struct ahash_request *areq = state->req;
 
 	if (err == -EINPROGRESS)
 		return;
 
-	ahash_restore_req(areq, err);
-
+	ahash_restore_req(areq);
 	ahash_request_complete(areq, err);
 }
 
 static int ahash_def_finup_finish1(struct ahash_request *req, int err)
 {
-	struct ahash_request *subreq = req->priv;
-
 	if (err)
 		goto out;
 
-	subreq->base.complete = ahash_def_finup_done2;
+	req->base.complete = ahash_def_finup_done2;
 
-	err = crypto_ahash_alg(crypto_ahash_reqtfm(req))->final(subreq);
+	err = crypto_ahash_alg(crypto_ahash_reqtfm(req))->final(req);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
 out:
-	ahash_restore_req(req, err);
+	ahash_restore_req(req);
 	return err;
 }
 
 static void ahash_def_finup_done1(void *data, int err)
 {
-	struct ahash_request *areq = data;
-	struct ahash_request *subreq;
+	struct ahash_save_req_state *state0 = data;
+	struct ahash_save_req_state state;
+	struct ahash_request *areq;
 
+	state = *state0;
+	areq = state.req;
 	if (err == -EINPROGRESS)
 		goto out;
 
-	subreq = areq->priv;
-	subreq->base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
+	areq->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	err = ahash_def_finup_finish1(areq, err);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return;
 
 out:
-	ahash_request_complete(areq, err);
+	state.compl(state.data, err);
 }
 
 static int ahash_def_finup(struct ahash_request *req)
@@ -426,11 +399,11 @@ static int ahash_def_finup(struct ahash_request *req)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
 	int err;
 
-	err = ahash_save_req(req, ahash_def_finup_done1, true);
+	err = ahash_save_req(req, ahash_def_finup_done1);
 	if (err)
 		return err;
 
-	err = crypto_ahash_alg(tfm)->update(req->priv);
+	err = crypto_ahash_alg(tfm)->update(req);
 	if (err == -EINPROGRESS || err == -EBUSY)
 		return err;
 
diff --git a/include/crypto/hash.h b/include/crypto/hash.h
index 2d5ea9f9ff43..9c1f8ca59a77 100644
--- a/include/crypto/hash.h
+++ b/include/crypto/hash.h
@@ -55,9 +55,6 @@ struct ahash_request {
 	struct scatterlist *src;
 	u8 *result;
 
-	/* This field may only be used by the ahash API code. */
-	void *priv;
-
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-- 
2.39.5

