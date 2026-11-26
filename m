Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795721601;
	b=ZWntSopqCBsVG+8GRarx2+RZ0qIh4Fdp/bLMHmREAmf3pyeSWmL5B7etbDcBfIwBeChV
	 HAqiMWHuBF3ZxFuEITidQ1t7qVUqnBFQyRR054an3a1Kw+DQCKVKWjBKpE9+gOLpHNPce
	 tkw2cB2DMehIJzxjz8aXy1Br6JC7DDdghmo2L+Anulrl0Qqa8ZwDACP7BO0YqTPKkwp3+
	 St+1AsB5FhQkA2F6tsmJ8mrKmq3n2JTf8EYc3VmIbWY8PVmS9z08CO5GBI5+IkGnmE4iy
	 47snAxh2idL7jGhN9EtOl59e0xuUNABAuN1L2J1qFSNZw0qxpY7mYbJB1zlhKQQmDWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795721601;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=io+uaDknt7WdBvlAK0vnW3kOhuoYLdbo2w5Zw2Ijjss=;
	b=ej0M6UNNvzPYZPRySFiztO5v3nRMP3PtNOircGLcCMa046fdOU31iZAoV+VEN+T+g7+s
	 Kqr3fXeSU5hQ9ihDyD1aq2075XJoK3xnLowjeBb7pby+zOENPPxvQObN458usPk3x7DDm
	 EGcRAMXsn2BA8kC1O/YkZAf9t75zcy05Yi22YcgLCkOozRQX93qInwEddZgBH6XMm9YQ2
	 KOTcdVkbaB5YR01iKvXSRVfsMTVytOVynv6hwYanMWGnEu+hoyyq3h8L6SjESQvpgvhio
	 BUh9EcjSmH28+t38MUaUwqigFXpV3qONqlHxOXKhFjSqd5ytW0JakMOhrHChTaI9kNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SyzFwwva;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53525606A32E
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 19:33:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53525606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SyzFwwva
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so78767095e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 11:33:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795721599; x=1796326399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=io+uaDknt7WdBvlAK0vnW3kOhuoYLdbo2w5Zw2Ijjss=;
        b=SyzFwwvaE6etjYOfzyXoxXdgTGThKveq4rWY98v0x62+dAiBl1sw5JTTd9092Kzvzq
         ePRPUQfqxRMVn9kZZcAvqybR4F9LOIDNCb3J3dQehyt1pgI5WgsUnKdEDlm42tmxh6XN
         hF0YclE0CLu73KOQSHigEsQzHXXmL3zEnTfOluE2hWCy5i6jfGGoRigZCEGdgTjtSVSp
         tiNpOfZTuXlaRc5T6uhJr3r3SHMSxUVg/t6Nh6w0Miod5RdtyZSYA8vMr5zgSX/6aMts
         vzagFCFYfOzkLY8dQdYuYoiulA6+7F79sKjlv6Ev9bJCCru8sHvrgU295EubGgwkWyBj
         ub8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795721599; x=1796326399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=io+uaDknt7WdBvlAK0vnW3kOhuoYLdbo2w5Zw2Ijjss=;
        b=spT2iTNgxePTj3VJbk4y0QTozQXgMAQOvkSiwqcpEqlHTUWAB4U8dBhSMb7P4oSnV2
         7jyKvfJXisL6eb/xSH7KB5MHN3JZ4QJckPNRMrxXqichlP2DzMk74aCQjRBN5GdFKoW1
         SEFXVrj+NUjxnkE9Pt7BJYlTQwjALH2rT43du/5vbTwWYZZOIpzt5JgI74jLQ5HhJXwY
         Y7X/sWktQ2Fz2ifw4q8NFvFhMGPHlKpJqmjmdbdfS2RiaU0cWD01v4PLd2txoC7bYVya
         s/7fIalh8xJuEMjjbaeio68cnYf7995LNJ/6Sg3i1puea45//Ew3hQvu9BE9Wqd3Bp6C
         1bCA==
X-Gm-Message-State: APuU4Z8hKHu+hkr+/WJR+cYJlPL8u+wZSApa8iVsqCelsg2Jglj4tJ36
	XYio3UWBzL8+6kfRbysTWXmCKqxrDIATz3UP21sdcR8drRAj8VqtWbIj
X-Gm-Gg: AZFdTZd0V7tCfSPfdhutxTqIbDntlvgdNRgQRbazjX5OwdbyhISWGoKz7GW7RBid/Dc
	JXVA1uS5Tno22O0ieq54ahj8yp+PFqBRokuUbO8FvOv7Jw58X4yrEPj6Rvl6b+u2Amls8xNVjG5
	g4ilNPB4BX0FXsoqDpEOVX6Du2ZW5o54CfkQ2fK5+fNxH7FWaQiOXfrgfZ+hyomazJyka3l3Pcz
	H6yimyMHkwyvwWsUUEDO/v/KeBM0VRPG0dl7ieDe6hY+aJdRE2kcFTlt3qNoi45AyfaYCENM7jX
	WqfydVUuAsED4tShG3imK6OL+O1OwhmraLTgAaBYUMJPRunyhnvtE6DNuv846eQVRqjnZ8Ee5vZ
	hxsXMUfgCAksWe3vYcUALTPeibDj0m+gNOtxRLvCdFi+qaQn4qkZnoOMx3aiexzg039gTvbBt5m
	tGTNls+Ep1DlivTOub9TYpheO/HnIGYWQxuOgsq9ZP9qBGRtO8M6p+JEsG0mN5NeK9y7fGeKKal
	ZdBbZxs1Gtdot+CGXm6MZTXT0gejPot4O+NZuNsqjCaBTfnd8elc8WYzdeNtNAtZY5ArAX1cC5v
	+i+2D9g4a1x5MfZC2C4z5vtKwIiMAhA+lJC32+da0uZh6rPmfGb6nNBNZ4O/s3ddRyQ=
X-Received: by 2002:a05:600c:46cc:b0:4bb:6f41:399f with SMTP id 5b1f17b1804b1-4bb888236a3mr467148805e9.24.1795721598574;
        Thu, 26 Nov 2026 11:33:18 -0800 (PST)
Received: from localhost.localdomain ([79.117.198.103])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb906cdcc1sm368287675e9.2.2026.11.26.11.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 11:33:18 -0800 (PST)
From: Jose Nieto <jnieto.alaber@gmail.com>
To: Corentin Labbe <clabbe@baylibre.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	devicetree@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Alexey Romanov <romanov.alexey2000@gmail.com>
Subject: [PATCH v13 12/25] crypto: amlogic - Avoid kzalloc in engine thread
Date: Thu, 26 Nov 2026 20:32:28 +0100
Message-ID: <20261126193241.1471372-13-jnieto.alaber@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
References: <20261126193241.1471372-1-jnieto.alaber@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alexey Romanov <romanov.alexey2000@gmail.com>

It makes no sense to allocate memory via kzalloc, we
can use static buffer, speedup data processing and
don't think about kfree() calls.

Signed-off-by: Alexey Romanov <romanov.alexey2000@gmail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 drivers/crypto/amlogic/amlogic-gxl-cipher.c | 60 ++++++++++-----------
 drivers/crypto/amlogic/amlogic-gxl.h        |  4 +-
 2 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
index cb6b959bb1f9..df42940f1112 100644
--- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
+++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
@@ -59,7 +59,7 @@ static bool meson_cipher_need_fallback(struct skcipher_request *areq)
 static int meson_cipher_do_fallback(struct skcipher_request *areq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
-	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx_dma(tfm);
 	struct meson_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 	int err;
 #ifdef CONFIG_CRYPTO_DEV_AMLOGIC_GXL_DEBUG
@@ -91,7 +91,6 @@ struct cipher_ctx {
 	struct skcipher_request *areq;
 	struct scatterlist *src_sg;
 	struct scatterlist *dst_sg;
-	void *bkeyiv;
 
 	unsigned int src_offset;
 	unsigned int dst_offset;
@@ -147,7 +146,7 @@ static void meson_setup_keyiv_descs(struct cipher_ctx *ctx)
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct meson_alg_template *algt = container_of(alg,
 		struct meson_alg_template, alg.skcipher.base);
-	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx_dma(tfm);
 	struct meson_dev *mc = op->mc;
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	unsigned int blockmode = algt->blockmode;
@@ -157,7 +156,7 @@ static void meson_setup_keyiv_descs(struct cipher_ctx *ctx)
 		return;
 
 	if (blockmode == DESC_OPMODE_CBC) {
-		memcpy(ctx->bkeyiv + AES_MAX_KEY_SIZE, ctx->areq->iv, ivsize);
+		memcpy(op->keyiv + AES_MAX_KEY_SIZE, ctx->areq->iv, ivsize);
 		dma_sync_single_for_device(mc->dev, ctx->keyiv.addr,
 					   ctx->keyiv.len, DMA_TO_DEVICE);
 	}
@@ -179,7 +178,7 @@ static bool meson_setup_data_descs(struct cipher_ctx *ctx)
 {
 	struct meson_cipher_req_ctx *rctx = skcipher_request_ctx(ctx->areq);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(ctx->areq);
-	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx_dma(tfm);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct meson_alg_template *algt = container_of(alg,
 						       struct meson_alg_template,
@@ -222,7 +221,7 @@ static int meson_kick_hardware(struct cipher_ctx *ctx)
 {
 	struct meson_cipher_req_ctx *rctx = skcipher_request_ctx(ctx->areq);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(ctx->areq);
-	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx_dma(tfm);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct meson_alg_template *algt = container_of(alg,
 						       struct meson_alg_template,
@@ -292,7 +291,7 @@ static int meson_kick_hardware(struct cipher_ctx *ctx)
 static int meson_cipher(struct skcipher_request *areq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
-	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx_dma(tfm);
 	struct meson_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 	struct meson_dev *mc = op->mc;
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
@@ -305,6 +304,7 @@ static int meson_cipher(struct skcipher_request *areq)
 		.dst_sg = areq->dst,
 		.cryptlen = areq->cryptlen,
 	};
+	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	int err;
 
 	dev_dbg(mc->dev, "%s %s %u %x IV(%u) key=%u ctx.flow=%d\n", __func__,
@@ -320,21 +320,21 @@ static int meson_cipher(struct skcipher_request *areq)
 	mc->chanlist[rctx->flow].stat_req++;
 #endif
 
-	ctx.bkeyiv = kzalloc(48, GFP_KERNEL | GFP_DMA);
-	if (!ctx.bkeyiv)
-		return -ENOMEM;
-
-	memcpy(ctx.bkeyiv, op->key, op->keylen);
 	ctx.keyiv.len = op->keylen;
 	if (ctx.keyiv.len == AES_KEYSIZE_192)
 		ctx.keyiv.len = AES_MAX_KEY_SIZE;
 
-	ctx.keyiv.addr = dma_map_single(mc->dev, ctx.bkeyiv, ctx.keyiv.len,
+	if (algt->blockmode == DESC_OPMODE_CBC) {
+		memcpy(op->keyiv + AES_MAX_KEY_SIZE, areq->iv, ivsize);
+		ctx.keyiv.len = AES_MAX_KEY_SIZE + ivsize;
+	}
+
+	ctx.keyiv.addr = dma_map_single(mc->dev, op->keyiv, ctx.keyiv.len,
 					DMA_TO_DEVICE);
 	err = dma_mapping_error(mc->dev, ctx.keyiv.addr);
 	if (err) {
 		dev_err(mc->dev, "Cannot DMA MAP KEY IV\n");
-		goto free_keyiv;
+		return err;
 	}
 
 	err = meson_map_scatterlist(areq, mc);
@@ -368,9 +368,6 @@ static int meson_cipher(struct skcipher_request *areq)
 unmap_keyiv:
 	dma_unmap_single(mc->dev, ctx.keyiv.addr, ctx.keyiv.len, DMA_TO_DEVICE);
 
-free_keyiv:
-	kfree_sensitive(ctx.bkeyiv);
-
 	return err;
 }
 
@@ -390,7 +387,7 @@ int meson_handle_cipher_request(struct crypto_engine *engine, void *areq)
 static int meson_skdecrypt(struct skcipher_request *areq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
-	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx_dma(tfm);
 	struct meson_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 	struct crypto_engine *engine;
 	int e;
@@ -408,7 +405,7 @@ static int meson_skdecrypt(struct skcipher_request *areq)
 static int meson_skencrypt(struct skcipher_request *areq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
-	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx_dma(tfm);
 	struct meson_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 	struct crypto_engine *engine;
 	int e;
@@ -425,7 +422,7 @@ static int meson_skencrypt(struct skcipher_request *areq)
 
 static int meson_cipher_init(struct crypto_tfm *tfm)
 {
-	struct meson_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
+	struct meson_cipher_tfm_ctx *op = crypto_tfm_ctx_dma(tfm);
 	struct meson_alg_template *algt;
 	const char *name = crypto_tfm_alg_name(tfm);
 	struct crypto_skcipher *sktfm = __crypto_skcipher_cast(tfm);
@@ -443,7 +440,7 @@ static int meson_cipher_init(struct crypto_tfm *tfm)
 		return PTR_ERR(op->fallback_tfm);
 	}
 
-	crypto_skcipher_set_reqsize(sktfm, sizeof(struct meson_cipher_req_ctx) +
+	crypto_skcipher_set_reqsize_dma(sktfm, sizeof(struct meson_cipher_req_ctx) +
 				    crypto_skcipher_reqsize(op->fallback_tfm));
 
 	return 0;
@@ -451,16 +448,15 @@ static int meson_cipher_init(struct crypto_tfm *tfm)
 
 static void meson_cipher_exit(struct crypto_tfm *tfm)
 {
-	struct meson_cipher_tfm_ctx *op = crypto_tfm_ctx(tfm);
+	struct meson_cipher_tfm_ctx *op = crypto_tfm_ctx_dma(tfm);
 
-	kfree_sensitive(op->key);
 	crypto_free_skcipher(op->fallback_tfm);
 }
 
 static int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 			    unsigned int keylen)
 {
-	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
+	struct meson_cipher_tfm_ctx *op = crypto_skcipher_ctx_dma(tfm);
 	struct meson_dev *mc = op->mc;
 
 	switch (keylen) {
@@ -477,11 +473,9 @@ static int meson_aes_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		dev_dbg(mc->dev, "ERROR: Invalid keylen %u\n", keylen);
 		return -EINVAL;
 	}
-	kfree_sensitive(op->key);
+
+	memcpy(op->keyiv, key, keylen);
 	op->keylen = keylen;
-	op->key = kmemdup(key, keylen, GFP_KERNEL | GFP_DMA);
-	if (!op->key)
-		return -ENOMEM;
 
 	return crypto_skcipher_setkey(op->fallback_tfm, key, keylen);
 }
@@ -499,7 +493,6 @@ static struct meson_alg_template algs[] = {
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
 				CRYPTO_ALG_NEED_FALLBACK,
-			.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
 			.cra_init = meson_cipher_init,
@@ -528,7 +521,6 @@ static struct meson_alg_template algs[] = {
 			.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER |
 				CRYPTO_ALG_ASYNC | CRYPTO_ALG_ALLOCATES_MEMORY |
 				CRYPTO_ALG_NEED_FALLBACK,
-			.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx),
 			.cra_module = THIS_MODULE,
 			.cra_alignmask = 0xf,
 			.cra_init = meson_cipher_init,
@@ -548,6 +540,14 @@ static struct meson_alg_template algs[] = {
 
 int meson_cipher_register(struct meson_dev *mc)
 {
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(algs); i++) {
+		struct skcipher_alg *alg = &algs[i].alg.skcipher.base;
+
+		alg->base.cra_ctxsize = sizeof(struct meson_cipher_tfm_ctx) + crypto_dma_padding();
+	}
+
 	return meson_register_algs(mc, algs, ARRAY_SIZE(algs));
 }
 
diff --git a/drivers/crypto/amlogic/amlogic-gxl.h b/drivers/crypto/amlogic/amlogic-gxl.h
index 6797b44905d3..c401cbbadaa3 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -125,14 +125,14 @@ struct meson_cipher_req_ctx {
 
 /*
  * struct meson_cipher_tfm_ctx - context for a skcipher TFM
- * @key:		pointer to key data
+ * @keyiv:		key data
  * @keylen:		len of the key
  * @keymode:		The keymode(type and size of key) associated with this TFM
  * @mc:			pointer to the private data of driver handling this TFM
  * @fallback_tfm:	pointer to the fallback TFM
  */
 struct meson_cipher_tfm_ctx {
-	u32 *key;
+	u8 keyiv[AES_MAX_KEY_SIZE + AES_BLOCK_SIZE];
 	u32 keylen;
 	u32 keymode;
 	struct meson_dev *mc;
-- 
2.47.3

