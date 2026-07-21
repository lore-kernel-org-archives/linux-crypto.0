Received: from smtpout-02.galae.net (smtpout-02.galae.net [185.246.84.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1C639FCD7
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 14:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.84.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784642409; cv=none; b=ovLiVtwK1l8J1OF8Be3wF4Vt7msBl7lEFAGMxhwktNjbq7WAog/DFA5Src65Qwqfx/qUTw0/rxxgH7eomrhzRDimBKlcstZsNNlQmXcE27+WbfaxTq8ZtA7sOXyBCdHfkAQpCxv7Ie7aWf0nwQg1g+lh0JzoNCspwDJ6DrQijEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784642409; c=relaxed/simple;
	bh=MS22pgai3VocF2kDhES3V/HEtmGLihIxFPHgVsjcM5A=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=UEfVpFYXg6Oc1oka1kS1kJIFuDDdavmV9oRVSFT+iad59UZqAbViEfXgSWp9jpE+UXoPAUhs8b3ACSMFTFgT18ddJJTt82k58uYxcjQU30M3FxlV5uT5Sc8lgYdHIN2Sc34v2Dq1CN3ioGRf3OGJbbxcfFcf6RJaQ8DwwkSHyaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=KwzkdOz0; arc=none smtp.client-ip=185.246.84.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="KwzkdOz0"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-02.galae.net (Postfix) with ESMTPS id E771F1A113B
	for <linux-crypto@vger.kernel.org>; Tue, 21 Jul 2026 14:00:03 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id BAC4960368;
	Tue, 21 Jul 2026 14:00:03 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5B9E011BD3B79;
	Tue, 21 Jul 2026 16:00:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1784642403; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=u/x/5JD+6l0Gve2STkuFjGGhK9kFHew6GxHTRK04M4A=;
	b=KwzkdOz0l4M0VZlDMkJya2YJ2CmReLnidlwMqNJEF2SZINPduN77CO7beqy6+pNFYT/nts
	cJpc4XHT9HcNjOc0y8oJXZ2ZqfdDnoGsw1mEyPoGQTtpmp49w2S3srnPF61fBMIo/Q708T
	qWO+eFMx4TI05o3TRChsbio5olKoKvUXsCsPTJLHn5gbith6XRlvo+Tw+g+Zhvtta4hFUv
	Rxd99Z5MAIvL+kzAtIbZO+FulLufwDQKjX+duyWDGLI+IVa8gnnoJU9Syq+nmaPR60aQGZ
	Makd5R4H6auByr8/+hZ1MEQpnqtdq5VkUsmmA7w0k3RUV/CuiqOjHmUBRc2R/A==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Tue, 21 Jul 2026 15:59:44 +0200
Subject: [PATCH v3 17/19] crypto: talitos - Replace has_ftr_sec1() with
 is_sec1() static key helper
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-7-1-rc1_talitos_cleanup-v3-17-7c71a2b77c83@bootlin.com>
References: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
In-Reply-To: <20260721-7-1-rc1_talitos_cleanup-v3-0-7c71a2b77c83@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Herve Codina <herve.codina@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Paul Louvel <paul.louvel@bootlin.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784642380; l=28945;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=MS22pgai3VocF2kDhES3V/HEtmGLihIxFPHgVsjcM5A=;
 b=lEDYxAt1xlS2wj7FcbqlBGhBIpPoLxjfCEoZ9VCC0c6CmU7vkvGwsoNxgJ5Kzx07WQbhpnSUr
 wG/b83GQpS9Bxh4Q5JPsTVBV/kZMikaJO1ljHWT+f0bzA+ho00P/kej
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Now that is_sec1() is available, replace all has_ftr_sec1(priv) calls
and the local "bool is_sec1" variables with direct is_sec1()
invocations.

It removes the requirement that every caller has to either get struct
talitos_private out of dev_get_drvdata() or/and pass the is_sec1
parameter to each inline helper.

Drop the now-unused has_ftr_sec1() helper.

Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/talitos-aead.c     |  24 +++----
 drivers/crypto/talitos/talitos-hash.c     |  26 +++----
 drivers/crypto/talitos/talitos-skcipher.c |  15 ++--
 drivers/crypto/talitos/talitos.c          | 113 +++++++++++++-----------------
 drivers/crypto/talitos/talitos.h          |  49 ++++---------
 5 files changed, 87 insertions(+), 140 deletions(-)

diff --git a/drivers/crypto/talitos/talitos-aead.c b/drivers/crypto/talitos/talitos-aead.c
index cd1b8e6d371b..d9e27eddfd1d 100644
--- a/drivers/crypto/talitos/talitos-aead.c
+++ b/drivers/crypto/talitos/talitos-aead.c
@@ -208,18 +208,16 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	int sg_count, ret;
 	int elen = 0;
 	bool sync_needed = false;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	bool is_ipsec_esp = desc->hdr & DESC_HDR_TYPE_IPSEC_ESP;
 	struct talitos_ptr *civ_ptr = &desc->ptr[is_ipsec_esp ? 2 : 3];
 	struct talitos_ptr *ckey_ptr = &desc->ptr[is_ipsec_esp ? 3 : 2];
 	dma_addr_t dma_icv = edesc->dma_link_tbl + edesc->dma_len - authsize;
 
 	/* hmac key */
-	to_talitos_ptr(&desc->ptr[0], ctx->dma_key, ctx->authkeylen, is_sec1);
+	to_talitos_ptr(&desc->ptr[0], ctx->dma_key, ctx->authkeylen);
 
 	sg_count = edesc->src_nents ?: 1;
-	if (is_sec1 && sg_count > 1)
+	if (is_sec1() && sg_count > 1)
 		sg_copy_to_buffer(areq->src, sg_count, edesc->buf,
 				  areq->assoclen + cryptlen);
 	else
@@ -237,11 +235,11 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	}
 
 	/* cipher iv */
-	to_talitos_ptr(civ_ptr, edesc->iv_dma, ivsize, is_sec1);
+	to_talitos_ptr(civ_ptr, edesc->iv_dma, ivsize);
 
 	/* cipher key */
 	to_talitos_ptr(ckey_ptr, ctx->dma_key  + ctx->authkeylen,
-		       ctx->enckeylen, is_sec1);
+		       ctx->enckeylen);
 
 	/*
 	 * cipher in
@@ -264,7 +262,7 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 	/* cipher out */
 	if (areq->src != areq->dst) {
 		sg_count = edesc->dst_nents ? : 1;
-		if (!is_sec1 || sg_count == 1)
+		if (!is_sec1() || sg_count == 1)
 			dma_map_sg(dev, areq->dst, sg_count, DMA_FROM_DEVICE);
 	}
 
@@ -281,15 +279,15 @@ static int ipsec_esp(struct talitos_edesc *edesc, struct aead_request *areq,
 		struct talitos_ptr *tbl_ptr = &edesc->link_tbl[tbl_off];
 
 		/* Add an entry to the link table for ICV data */
-		to_talitos_ptr_ext_set(tbl_ptr - 1, 0, is_sec1);
-		to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RET, is_sec1);
+		to_talitos_ptr_ext_set(tbl_ptr - 1, 0);
+		to_talitos_ptr_ext_set(tbl_ptr, DESC_PTR_LNKTBL_RET);
 
 		/* icv data follows link tables */
-		to_talitos_ptr(tbl_ptr, dma_icv, authsize, is_sec1);
-		to_talitos_ptr_ext_or(&desc->ptr[5], authsize, is_sec1);
+		to_talitos_ptr(tbl_ptr, dma_icv, authsize);
+		to_talitos_ptr_ext_or(&desc->ptr[5], authsize);
 		sync_needed = true;
 	} else if (!encrypt) {
-		to_talitos_ptr(&desc->ptr[6], dma_icv, authsize, is_sec1);
+		to_talitos_ptr(&desc->ptr[6], dma_icv, authsize);
 		sync_needed = true;
 	} else if (!is_ipsec_esp) {
 		talitos_sg_map(dev, areq->dst, authsize, edesc, &desc->ptr[6],
@@ -642,7 +640,7 @@ int talitos_register_aead(struct device *dev)
 		aead_alg = &aead_driver_algs[i].alg.aead;
 		alg = &aead_alg->base;
 
-		if (has_ftr_sec1(priv))
+		if (is_sec1())
 			alg->cra_alignmask = 3;
 
 		if (!(priv->features & TALITOS_FTR_SHA224_HWINIT) &&
diff --git a/drivers/crypto/talitos/talitos-hash.c b/drivers/crypto/talitos/talitos-hash.c
index f90018d4e219..c7a1a622c014 100644
--- a/drivers/crypto/talitos/talitos-hash.c
+++ b/drivers/crypto/talitos/talitos-hash.c
@@ -44,8 +44,6 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_desc *desc = &edesc->desc;
 
 	unmap_single_talitos_ptr(dev, &desc->ptr[5], DMA_FROM_DEVICE);
@@ -58,7 +56,7 @@ static void common_nonsnoop_hash_unmap(struct device *dev,
 		talitos_sg_unmap(dev, edesc, edesc->src, NULL, 0, 0);
 
 	/* When using hashctx-in, must unmap it. */
-	if (from_talitos_ptr_len(&desc->ptr[1], is_sec1))
+	if (from_talitos_ptr_len(&desc->ptr[1]))
 		unmap_single_talitos_ptr(dev, &desc->ptr[1],
 					 DMA_TO_DEVICE);
 
@@ -89,11 +87,10 @@ static void ahash_done(struct device *dev,
 		 container_of(desc, struct talitos_edesc, desc);
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	bool is_sec1 = has_ftr_sec1(dev_get_drvdata(dev));
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct talitos_edesc *next;
 
-	if (is_sec1) {
+	if (is_sec1()) {
 		free_edesc_list_from(areq, edesc);
 		ahash_request_complete(areq, err ?: req_ctx->to_hash_later);
 	} else {
@@ -150,8 +147,6 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 	struct device *dev = ctx->dev;
 	struct talitos_desc *desc = &edesc->desc;
 	bool sync_needed = false;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	int sg_count;
 
 	/* first DWORD empty */
@@ -169,11 +164,10 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	/* HMAC key */
 	if (ctx->keylen)
-		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen,
-			       is_sec1);
+		to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen);
 
 	sg_count = edesc->src_nents ?: 1;
-	if (is_sec1 && sg_count > 1)
+	if (is_sec1() && sg_count > 1)
 		sg_copy_to_buffer(edesc->src, sg_count, edesc->buf, length);
 	else if (length)
 		sg_count = dma_map_sg(dev, edesc->src, sg_count, DMA_TO_DEVICE);
@@ -201,7 +195,7 @@ static void common_nonsnoop_hash(struct talitos_edesc *edesc,
 
 	/* last DWORD empty */
 
-	if (is_sec1 && from_talitos_ptr_len(&desc->ptr[3], true) == 0)
+	if (is_sec1() && from_talitos_ptr_len(&desc->ptr[3]) == 0)
 		talitos_handle_buggy_hash(req_ctx, ctx, edesc, &desc->ptr[3]);
 
 	if (sync_needed)
@@ -222,12 +216,12 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
 
 static struct talitos_edesc *
 ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
-			  unsigned int blocksize, bool is_sec1)
+			  unsigned int blocksize)
 {
 	struct talitos_ctx *ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(areq));
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 	struct talitos_edesc *first = NULL, *prev_edesc = NULL, *edesc;
-	size_t desc_max = is_sec1 ? TALITOS1_MAX_DATA_LEN :
+	size_t desc_max = is_sec1() ? TALITOS1_MAX_DATA_LEN :
 				    TALITOS2_MAX_DATA_LEN;
 	struct scatterlist tmp[2];
 	size_t to_hash_this_desc;
@@ -272,7 +266,7 @@ ahash_process_req_prepare(struct ahash_request *areq, unsigned int nbytes,
 			edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
 
 		/* clear the DN bit  */
-		if (is_sec1 && !edesc->last)
+		if (is_sec1() && !edesc->last)
 			edesc->desc.hdr &= ~DESC_HDR_DONE_NOTIFY;
 
 		common_nonsnoop_hash(edesc, areq, to_hash_this_desc);
@@ -298,7 +292,6 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	struct talitos_edesc *edesc;
 	unsigned int blocksize =
 			crypto_tfm_alg_blocksize(crypto_ahash_tfm(tfm));
-	bool is_sec1 = has_ftr_sec1(dev_get_drvdata(ctx->dev));
 	unsigned int nbytes_to_hash;
 	unsigned int to_hash_later;
 	struct device *dev = ctx->dev;
@@ -314,8 +307,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 
 	req_ctx->to_hash_later = to_hash_later;
 
-	edesc = ahash_process_req_prepare(areq, nbytes_to_hash, blocksize,
-					  is_sec1);
+	edesc = ahash_process_req_prepare(areq, nbytes_to_hash, blocksize);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
index b12191243aae..2c34e2ffbf7e 100644
--- a/drivers/crypto/talitos/talitos-skcipher.c
+++ b/drivers/crypto/talitos/talitos-skcipher.c
@@ -59,21 +59,19 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	unsigned int ivsize = crypto_skcipher_ivsize(cipher);
 	int sg_count, ret;
 	bool sync_needed = false;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	bool is_ctr = (desc->hdr & DESC_HDR_SEL0_MASK) == DESC_HDR_SEL0_AESU &&
 		      (desc->hdr & DESC_HDR_MODE0_AESU_MASK) == DESC_HDR_MODE0_AESU_CTR;
 
 	/* first DWORD empty */
 
 	/* cipher iv */
-	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, ivsize, is_sec1);
+	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, ivsize);
 
 	/* cipher key */
-	to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen, is_sec1);
+	to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen);
 
 	sg_count = edesc->src_nents ?: 1;
-	if (is_sec1 && sg_count > 1)
+	if (is_sec1() && sg_count > 1)
 		sg_copy_to_buffer(areq->src, sg_count, edesc->buf,
 				  cryptlen);
 	else
@@ -91,7 +89,7 @@ static int common_nonsnoop(struct talitos_edesc *edesc,
 	/* cipher out */
 	if (areq->src != areq->dst) {
 		sg_count = edesc->dst_nents ? : 1;
-		if (!is_sec1 || sg_count == 1)
+		if (!is_sec1() || sg_count == 1)
 			dma_map_sg(dev, areq->dst, sg_count, DMA_FROM_DEVICE);
 	}
 
@@ -324,7 +322,6 @@ static struct talitos_alg_template skcipher_driver_algs[] = {
 
 int talitos_register_skcipher(struct device *dev)
 {
-	struct talitos_private *priv = dev_get_drvdata(dev);
 	struct skcipher_alg *skcipher_alg;
 	struct crypto_alg *alg;
 	size_t i;
@@ -338,10 +335,10 @@ int talitos_register_skcipher(struct device *dev)
 		skcipher_alg = &skcipher_driver_algs[i].alg.skcipher;
 		alg = &skcipher_alg->base;
 
-		if (has_ftr_sec1(priv))
+		if (is_sec1())
 			alg->cra_alignmask = 3;
 
-		if (!strcmp(alg->cra_name, "ctr(aes)") && !has_ftr_sec1(priv) &&
+		if (!strcmp(alg->cra_name, "ctr(aes)") && !is_sec1() &&
 		    DESC_TYPE(skcipher_driver_algs[i].desc_hdr_template) !=
 			    DESC_TYPE(DESC_HDR_TYPE_AESU_CTR_NONSNOOP)) {
 			continue;
diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index c93e3b551f6d..8ea26422f449 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -44,9 +44,8 @@ static int reset_channel(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = TALITOS_TIMEOUT;
-	bool is_sec1 = has_ftr_sec1(priv);
 
-	if (is_sec1) {
+	if (is_sec1()) {
 		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
 			  TALITOS1_CCCR_LO_RESET);
 
@@ -71,7 +70,7 @@ static int reset_channel(struct device *dev, int ch)
 	setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO, TALITOS_CCCR_LO_EAE |
 		  TALITOS_CCCR_LO_CDWE | TALITOS_CCCR_LO_CDIE);
 	/* enable chaining descriptors */
-	if (is_sec1)
+	if (is_sec1())
 		setbits32(priv->chan[ch].reg + TALITOS_CCCR_LO,
 			  TALITOS_CCCR_LO_NE);
 
@@ -87,8 +86,7 @@ static int reset_device(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	unsigned int timeout = TALITOS_TIMEOUT;
-	bool is_sec1 = has_ftr_sec1(priv);
-	u32 mcr = is_sec1 ? TALITOS1_MCR_SWR : TALITOS2_MCR_SWR;
+	u32 mcr = is_sec1() ? TALITOS1_MCR_SWR : TALITOS2_MCR_SWR;
 
 	setbits32(priv->reg + TALITOS_MCR, mcr);
 
@@ -116,7 +114,6 @@ static int init_device(struct device *dev)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int ch, err;
-	bool is_sec1 = has_ftr_sec1(priv);
 
 	/*
 	 * Master reset
@@ -140,7 +137,7 @@ static int init_device(struct device *dev)
 	}
 
 	/* enable channel done and error interrupts */
-	if (is_sec1) {
+	if (is_sec1()) {
 		clrbits32(priv->reg + TALITOS_IMR, TALITOS1_IMR_INIT);
 		clrbits32(priv->reg + TALITOS_IMR_LO, TALITOS1_IMR_LO_INIT);
 		/* disable parity error check in DEU (erroneous? test vect.) */
@@ -159,14 +156,14 @@ static int init_device(struct device *dev)
 }
 
 static void dma_map_request(struct device *dev, struct talitos_request *request,
-			    struct talitos_desc *desc, bool is_sec1)
+			    struct talitos_desc *desc)
 {
 	struct talitos_edesc *edesc =
 		container_of(desc, struct talitos_edesc, desc);
 	dma_addr_t dma_desc, prev_dma_desc;
 	struct talitos_edesc *prev_edesc = NULL;
 
-	if (is_sec1) {
+	if (is_sec1()) {
 		while (edesc) {
 			edesc->desc.hdr1 = edesc->desc.hdr;
 
@@ -220,7 +217,6 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	struct talitos_request *request;
 	unsigned long flags;
 	int head;
-	bool is_sec1 = has_ftr_sec1(priv);
 
 	spin_lock_irqsave(&priv->chan[ch].head_lock, flags);
 
@@ -234,7 +230,7 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 	request = &priv->chan[ch].fifo[head];
 
 	/* map descriptor and save caller data */
-	dma_map_request(dev, request, desc, is_sec1);
+	dma_map_request(dev, request, desc);
 	request->callback = callback;
 	request->context = context;
 
@@ -257,12 +253,12 @@ int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,
 }
 
 static __be32 get_request_hdr(struct device *dev,
-			      struct talitos_request *request, bool is_sec1)
+			      struct talitos_request *request)
 {
 	struct talitos_edesc *edesc;
 	dma_addr_t dma_desc;
 
-	if (!is_sec1) {
+	if (!is_sec1()) {
 		dma_sync_single_for_cpu(dev, request->dma_desc,
 					TALITOS_DESC_SIZE, DMA_BIDIRECTIONAL);
 
@@ -283,11 +279,11 @@ static __be32 get_request_hdr(struct device *dev,
 }
 
 static void dma_unmap_request(struct device *dev,
-			      struct talitos_request *request, bool is_sec1)
+			      struct talitos_request *request)
 {
 	struct talitos_edesc *edesc;
 
-	if (is_sec1) {
+	if (is_sec1()) {
 		dma_unmap_single(dev, request->dma_desc, TALITOS_DESC_SIZE,
 				 DMA_BIDIRECTIONAL);
 		edesc = container_of(request->desc, struct talitos_edesc, desc);
@@ -312,7 +308,6 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 	struct talitos_request *request, saved_req;
 	unsigned long flags;
 	int tail, status;
-	bool is_sec1 = has_ftr_sec1(priv);
 
 	spin_lock_irqsave(&priv->chan[ch].tail_lock, flags);
 
@@ -324,7 +319,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 
 		/* descriptors with their done bits set don't get the error */
 		rmb();
-		hdr = get_request_hdr(dev, request, is_sec1);
+		hdr = get_request_hdr(dev, request);
 
 		if ((hdr & DESC_HDR_DONE) == DESC_HDR_DONE)
 			status = 0;
@@ -334,7 +329,7 @@ static void flush_channel(struct device *dev, int ch, int error, int reset_ch)
 			else
 				status = error;
 
-		dma_unmap_request(dev, request, is_sec1);
+		dma_unmap_request(dev, request);
 
 		/* copy entries so we can call callback outside lock */
 		saved_req.desc = request->desc;
@@ -424,13 +419,13 @@ DEF_TALITOS2_DONE(ch0_2, TALITOS2_ISR_CH_0_2_DONE)
 DEF_TALITOS2_DONE(ch1_3, TALITOS2_ISR_CH_1_3_DONE)
 
 static __be32 search_desc_hdr_in_request(struct talitos_request *request,
-					 dma_addr_t cur_desc, bool is_sec1)
+					 dma_addr_t cur_desc)
 {
 	struct talitos_edesc *edesc;
 
 	if (request->dma_desc == cur_desc) {
 		return request->desc->hdr;
-	} else if (is_sec1) {
+	} else if (is_sec1()) {
 		edesc = container_of(request->desc, struct talitos_edesc, desc);
 		while (edesc->next_desc) {
 			if (edesc->desc.next_desc == cpu_to_be32(cur_desc))
@@ -447,7 +442,6 @@ static __be32 search_desc_hdr_in_request(struct talitos_request *request,
 static __be32 current_desc_hdr(struct device *dev, int ch)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	struct talitos_request *request;
 	int tail, iter;
 	dma_addr_t cur_desc;
@@ -466,7 +460,7 @@ static __be32 current_desc_hdr(struct device *dev, int ch)
 	do {
 		request = &priv->chan[ch].fifo[iter];
 
-		hdr = search_desc_hdr_in_request(request, cur_desc, is_sec1);
+		hdr = search_desc_hdr_in_request(request, cur_desc);
 		if (hdr)
 			break;
 
@@ -563,12 +557,11 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 	unsigned int timeout = TALITOS_TIMEOUT;
 	int ch, error, reset_dev = 0;
 	u32 v_lo;
-	bool is_sec1 = has_ftr_sec1(priv);
-	int reset_ch = is_sec1 ? 1 : 0; /* only SEC2 supports continuation */
+	int reset_ch = is_sec1() ? 1 : 0; /* only SEC2 supports continuation */
 
 	for (ch = 0; ch < priv->num_channels; ch++) {
 		/* skip channels without errors */
-		if (is_sec1) {
+		if (is_sec1()) {
 			/* bits 29, 31, 17, 19 */
 			if (!(isr & (1 << (29 + (ch & 1) * 2 - (ch & 2) * 6))))
 				continue;
@@ -594,19 +587,19 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 		if (v_lo & TALITOS_CCPSR_LO_MDTE)
 			dev_err(dev, "master data transfer error\n");
 		if (v_lo & TALITOS_CCPSR_LO_SGDLZ)
-			dev_err(dev, is_sec1 ? "pointer not complete error\n"
+			dev_err(dev, is_sec1() ? "pointer not complete error\n"
 					     : "s/g data length zero error\n");
 		if (v_lo & TALITOS_CCPSR_LO_FPZ)
-			dev_err(dev, is_sec1 ? "parity error\n"
+			dev_err(dev, is_sec1() ? "parity error\n"
 					     : "fetch pointer zero error\n");
 		if (v_lo & TALITOS_CCPSR_LO_IDH)
 			dev_err(dev, "illegal descriptor header error\n");
 		if (v_lo & TALITOS_CCPSR_LO_IEU)
-			dev_err(dev, is_sec1 ? "static assignment error\n"
+			dev_err(dev, is_sec1() ? "static assignment error\n"
 					     : "invalid exec unit error\n");
 		if (v_lo & TALITOS_CCPSR_LO_EU)
 			report_eu_error(dev, ch, current_desc_hdr(dev, ch));
-		if (!is_sec1) {
+		if (!is_sec1()) {
 			if (v_lo & TALITOS_CCPSR_LO_GB)
 				dev_err(dev, "gather boundary error\n");
 			if (v_lo & TALITOS_CCPSR_LO_GRL)
@@ -635,9 +628,9 @@ static void talitos_error(struct device *dev, u32 isr, u32 isr_lo)
 			}
 		}
 	}
-	if (reset_dev || (is_sec1 && isr & ~TALITOS1_ISR_4CHERR) ||
-	    (!is_sec1 && isr & ~TALITOS2_ISR_4CHERR) || isr_lo) {
-		if (is_sec1 && (isr_lo & TALITOS1_ISR_TEA_ERR))
+	if (reset_dev || (is_sec1() && isr & ~TALITOS1_ISR_4CHERR) ||
+	    (!is_sec1() && isr & ~TALITOS2_ISR_4CHERR) || isr_lo) {
+		if (is_sec1() && (isr_lo & TALITOS1_ISR_TEA_ERR))
 			dev_err(dev, "TEA error: ISR 0x%08x_%08x\n",
 				isr, isr_lo);
 		else
@@ -733,24 +726,22 @@ void talitos_sg_unmap(struct device *dev,
 			     struct scatterlist *dst,
 			     unsigned int len, unsigned int offset)
 {
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	unsigned int src_nents = edesc->src_nents ? : 1;
 	unsigned int dst_nents = edesc->dst_nents ? : 1;
 
-	if (is_sec1 && dst && dst_nents > 1) {
+	if (is_sec1() && dst && dst_nents > 1) {
 		dma_sync_single_for_device(dev, edesc->dma_link_tbl + offset,
 					   len, DMA_FROM_DEVICE);
 		sg_pcopy_from_buffer(dst, dst_nents, edesc->buf + offset, len,
 				     offset);
 	}
 	if (src != dst) {
-		if (src_nents == 1 || !is_sec1)
+		if (src_nents == 1 || !is_sec1())
 			dma_unmap_sg(dev, src, src_nents, DMA_TO_DEVICE);
 
-		if (dst && (dst_nents == 1 || !is_sec1))
+		if (dst && (dst_nents == 1 || !is_sec1()))
 			dma_unmap_sg(dev, dst, dst_nents, DMA_FROM_DEVICE);
-	} else if (src_nents == 1 || !is_sec1) {
+	} else if (src_nents == 1 || !is_sec1()) {
 		dma_unmap_sg(dev, src, src_nents, DMA_BIDIRECTIONAL);
 	}
 }
@@ -783,15 +774,15 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 
 		if (datalen > 0 && len > datalen) {
 			to_talitos_ptr(link_tbl_ptr + count,
-				       sg_dma_address(sg) + offset, datalen, 0);
-			to_talitos_ptr_ext_set(link_tbl_ptr + count, 0, 0);
+				       sg_dma_address(sg) + offset, datalen);
+			to_talitos_ptr_ext_set(link_tbl_ptr + count, 0);
 			count++;
 			len -= datalen;
 			offset += datalen;
 		}
 		to_talitos_ptr(link_tbl_ptr + count,
-			       sg_dma_address(sg) + offset, sg_next(sg) ? len : len + padding, 0);
-		to_talitos_ptr_ext_set(link_tbl_ptr + count, 0, 0);
+			       sg_dma_address(sg) + offset, sg_next(sg) ? len : len + padding);
+		to_talitos_ptr_ext_set(link_tbl_ptr + count, 0);
 		count++;
 		cryptlen -= len;
 		datalen -= len;
@@ -804,7 +795,7 @@ static int sg_to_link_tbl_offset(struct scatterlist *sg, int sg_count,
 	/* tag end of link table */
 	if (count > 0)
 		to_talitos_ptr_ext_set(link_tbl_ptr + count - 1,
-				       DESC_PTR_LNKTBL_RET, 0);
+				       DESC_PTR_LNKTBL_RET);
 
 	return count;
 }
@@ -815,33 +806,30 @@ int talitos_sg_map_ext(struct device *dev, struct scatterlist *src,
 			      unsigned int offset, int tbl_off, int elen,
 			      bool force, int align)
 {
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 	int aligned_len = ALIGN(len, align);
 
 	if (!src) {
-		to_talitos_ptr(ptr, 0, 0, is_sec1);
+		to_talitos_ptr(ptr, 0, 0);
 		return 1;
 	}
-	to_talitos_ptr_ext_set(ptr, elen, is_sec1);
+	to_talitos_ptr_ext_set(ptr, elen);
 	if (sg_count == 1 && !force) {
-		to_talitos_ptr(ptr, sg_dma_address(src) + offset, aligned_len, is_sec1);
+		to_talitos_ptr(ptr, sg_dma_address(src) + offset, aligned_len);
 		return sg_count;
 	}
-	if (is_sec1) {
-		to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, aligned_len, is_sec1);
+	if (is_sec1()) {
+		to_talitos_ptr(ptr, edesc->dma_link_tbl + offset, aligned_len);
 		return sg_count;
 	}
 	sg_count = sg_to_link_tbl_offset(src, sg_count, offset, len, elen,
 					 &edesc->link_tbl[tbl_off], align);
 	if (sg_count == 1 && !force) {
-		/* Only one segment now, so no link tbl needed*/
-		copy_talitos_ptr(ptr, &edesc->link_tbl[tbl_off], is_sec1);
+		copy_talitos_ptr(ptr, &edesc->link_tbl[tbl_off]);
 		return sg_count;
 	}
 	to_talitos_ptr(ptr, edesc->dma_link_tbl +
-			    tbl_off * sizeof(struct talitos_ptr), aligned_len, is_sec1);
-	to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP, is_sec1);
+			    tbl_off * sizeof(struct talitos_ptr), aligned_len);
+	to_talitos_ptr_ext_or(ptr, DESC_PTR_LNKTBL_JUMP);
 
 	return sg_count;
 }
@@ -875,9 +863,7 @@ struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	dma_addr_t iv_dma = 0;
 	gfp_t flags = cryptoflags & CRYPTO_TFM_REQ_MAY_SLEEP ? GFP_KERNEL :
 		      GFP_ATOMIC;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-	int max_len = is_sec1 ? TALITOS1_MAX_DATA_LEN : TALITOS2_MAX_DATA_LEN;
+	int max_len = is_sec1() ? TALITOS1_MAX_DATA_LEN : TALITOS2_MAX_DATA_LEN;
 
 	if (cryptlen + authsize > max_len) {
 		dev_err(dev, "length exceeds h/w max limit\n");
@@ -918,7 +904,7 @@ struct talitos_edesc *talitos_edesc_alloc(struct device *dev,
 	 */
 	alloc_len = sizeof(struct talitos_edesc);
 	if (src_nents || dst_nents || !encrypt) {
-		if (is_sec1)
+		if (is_sec1())
 			dma_len = (src_nents ? src_len : 0) +
 				  (dst_nents ? dst_len : 0) + authsize;
 		else
@@ -1094,14 +1080,13 @@ static int talitos_probe_irq(struct platform_device *ofdev)
 	struct device_node *np = ofdev->dev.of_node;
 	struct talitos_private *priv = dev_get_drvdata(dev);
 	int err;
-	bool is_sec1 = has_ftr_sec1(priv);
 
 	priv->irq[0] = irq_of_parse_and_map(np, 0);
 	if (!priv->irq[0]) {
 		dev_err(dev, "failed to map irq\n");
 		return -EINVAL;
 	}
-	if (is_sec1) {
+	if (is_sec1()) {
 		err = request_irq(priv->irq[0], talitos1_interrupt_4ch, 0,
 				  dev_driver_string(dev), dev);
 		goto primary_out;
@@ -1196,12 +1181,10 @@ static int talitos_probe(struct platform_device *ofdev)
 				  TALITOS_FTR_SHA224_HWINIT |
 				  TALITOS_FTR_HMAC_OK;
 
-	if (of_device_is_compatible(np, "fsl,sec1.0")) {
-		priv->features |= TALITOS_FTR_SEC1;
+	if (of_device_is_compatible(np, "fsl,sec1.0"))
 		talitos_init_branch(true);
-	} else {
+	else
 		talitos_init_branch(false);
-	}
 
 	if (of_device_is_compatible(np, "fsl,sec1.2")) {
 		priv->reg_deu = priv->reg + TALITOS12_DEU;
@@ -1232,7 +1215,7 @@ static int talitos_probe(struct platform_device *ofdev)
 	if (err)
 		goto err_out;
 
-	if (has_ftr_sec1(priv)) {
+	if (is_sec1()) {
 		if (priv->num_channels == 1)
 			tasklet_init(&priv->done_task[0], talitos1_done_ch0,
 				     (unsigned long)dev);
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index b0d176c7dab2..9bbdd409da5a 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -223,7 +223,6 @@ struct talitos_crypto_alg {
 #define TALITOS_FTR_HW_AUTH_CHECK 0x00000002
 #define TALITOS_FTR_SHA224_HWINIT 0x00000004
 #define TALITOS_FTR_HMAC_OK 0x00000008
-#define TALITOS_FTR_SEC1 0x00000010
 
 #if defined(CONFIG_CRYPTO_DEV_TALITOS1) && defined(CONFIG_CRYPTO_DEV_TALITOS2)
 DECLARE_STATIC_KEY_FALSE(talitos_is_sec1);
@@ -252,20 +251,6 @@ static inline void talitos_init_branch(bool sec1)
 
 #endif
 
-/*
- * If both CONFIG_CRYPTO_DEV_TALITOS1 and CONFIG_CRYPTO_DEV_TALITOS2 are
- * defined, we check the features which are set according to the device tree.
- * Otherwise, we answer true or false directly
- */
-static inline bool has_ftr_sec1(struct talitos_private *priv)
-{
-	if (IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS1) &&
-	    IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS2))
-		return priv->features & TALITOS_FTR_SEC1;
-
-	return IS_ENABLED(CONFIG_CRYPTO_DEV_TALITOS1);
-}
-
 /*
  * TALITOS_xxx_LO addresses point to the low data bits (32-63) of the register
  */
@@ -504,10 +489,10 @@ static inline bool has_ftr_sec1(struct talitos_private *priv)
 #define DESC_PTR_LNKTBL_NEXT			0x01
 
 static inline void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
-				  unsigned int len, bool is_sec1)
+				  unsigned int len)
 {
 	ptr->ptr = cpu_to_be32(lower_32_bits(dma_addr));
-	if (is_sec1) {
+	if (is_sec1()) {
 		ptr->len1 = cpu_to_be16(len);
 	} else {
 		ptr->len = cpu_to_be16(len);
@@ -516,10 +501,10 @@ static inline void to_talitos_ptr(struct talitos_ptr *ptr, dma_addr_t dma_addr,
 }
 
 static inline void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
-				    struct talitos_ptr *src_ptr, bool is_sec1)
+				    struct talitos_ptr *src_ptr)
 {
 	dst_ptr->ptr = src_ptr->ptr;
-	if (is_sec1) {
+	if (is_sec1()) {
 		dst_ptr->len1 = src_ptr->len1;
 	} else {
 		dst_ptr->len = src_ptr->len;
@@ -527,26 +512,23 @@ static inline void copy_talitos_ptr(struct talitos_ptr *dst_ptr,
 	}
 }
 
-static inline unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr,
-						  bool is_sec1)
+static inline unsigned short from_talitos_ptr_len(struct talitos_ptr *ptr)
 {
-	if (is_sec1)
+	if (is_sec1())
 		return be16_to_cpu(ptr->len1);
 	else
 		return be16_to_cpu(ptr->len);
 }
 
-static inline void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val,
-					  bool is_sec1)
+static inline void to_talitos_ptr_ext_set(struct talitos_ptr *ptr, u8 val)
 {
-	if (!is_sec1)
+	if (!is_sec1())
 		ptr->j_extent = val;
 }
 
-static inline void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val,
-					 bool is_sec1)
+static inline void to_talitos_ptr_ext_or(struct talitos_ptr *ptr, u8 val)
 {
-	if (!is_sec1)
+	if (!is_sec1())
 		ptr->j_extent |= val;
 }
 
@@ -559,10 +541,8 @@ static void __map_single_talitos_ptr(struct device *dev,
 				     unsigned long attrs)
 {
 	dma_addr_t dma_addr = dma_map_single_attrs(dev, data, len, dir, attrs);
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
 
-	to_talitos_ptr(ptr, dma_addr, len, is_sec1);
+	to_talitos_ptr(ptr, dma_addr, len);
 }
 
 static inline void map_single_talitos_ptr(struct device *dev,
@@ -589,11 +569,8 @@ static inline void unmap_single_talitos_ptr(struct device *dev,
 					    struct talitos_ptr *ptr,
 					    enum dma_data_direction dir)
 {
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	dma_unmap_single(dev, be32_to_cpu(ptr->ptr),
-			 from_talitos_ptr_len(ptr, is_sec1), dir);
+	dma_unmap_single(dev, be32_to_cpu(ptr->ptr), from_talitos_ptr_len(ptr),
+			 dir);
 }
 
 int talitos_submit(struct device *dev, int ch, struct talitos_desc *desc,

-- 
2.55.0

