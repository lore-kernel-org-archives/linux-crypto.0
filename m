Received: from mx1.sberdevices.ru (mx2.sberdevices.ru [45.89.224.132])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6451E04A1;
	Fri, 13 Dec 2024 14:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.89.224.132
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734098904; cv=none; b=byCiNXo/GdcYi1/77gpysBjTlU1xTYrLS9PMCvRS8Gi37tDpQ6yqH0ywBvPTnk7VLMz0+28pWuHFKSTYId7WVsLTHvXrB1rE1pnB5/qs2EaKrkzX8Ji7EFNVxnZUTcVGKJPy332W0WwpADvEtQR5QnrPSCBEZ2b3Kqs1g7jsc7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734098904; c=relaxed/simple;
	bh=RLzO4ToctsU+Qrcz/bsQ1z9sd92L5lxv09hj0cntCQs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W2thRZPaqyR41vwb4BzGLp4Yz4p43MvibQ+mKx1o1mlRBiYyBIMpgyt0wup1FZZXCxjwY2csNNRZtzIZ+36lENu62TeVPgPrLyk9VdlsHcv/BUaGh+kPdvVtnaD4cThCaIRzVjgjARDbJX//eSe/KLd1+PZSs2SOcXt5xRND+Vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com; spf=pass smtp.mailfrom=salutedevices.com; dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b=qSxsprSu; arc=none smtp.client-ip=45.89.224.132
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=salutedevices.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=salutedevices.com header.i=@salutedevices.com header.b="qSxsprSu"
Received: from p-infra-ksmg-sc-msk02.sberdevices.ru (localhost [127.0.0.1])
	by mx1.sberdevices.ru (Postfix) with ESMTP id 4D0A112002C;
	Fri, 13 Dec 2024 17:08:19 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 mx1.sberdevices.ru 4D0A112002C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=salutedevices.com;
	s=mail; t=1734098899;
	bh=hLoqLOdHC7ETuw0Lpv2iOVwTRzUO0Q4fKeRj6QmsGGY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:From;
	b=qSxsprSu7aoo9qahNyaf+sLrpAHxYzV1Rn6Fd7x1421wA+JkHBgRMZb2IbvmtI5Jj
	 8RLXeu+zeDYcwi633ncgwZlVSy12ufsSIE0PyMAcugBerDIcM5h6btme3idtTpDsQ5
	 ugs3gl1OGFjml9iRNaPXWqFzg1QQi+kt6CTUMc/NwcMWBXUVlPDr5ZEh4GStiuesxH
	 PO+srb9zeH4tvBiLkTdk5+2VR4tSpwEwy78sic9kPZDsJrqYEhaETkSYaYDuHX+OcB
	 i3sMPlrjjXDD7/oKoBc0U698QhQft1J4G3vp3vUGWjGVX4gF1OXuU+g66xqx17h/fZ
	 qOyQY834l9KiQ==
Received: from smtp.sberdevices.ru (p-i-exch-sc-m02.sberdevices.ru [172.16.192.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.sberdevices.ru (Postfix) with ESMTPS;
	Fri, 13 Dec 2024 17:08:19 +0300 (MSK)
From: Alexey Romanov <avromanov@salutedevices.com>
To: <neil.armstrong@linaro.org>, <clabbe@baylibre.com>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>, <robh+dt@kernel.org>,
	<krzysztof.kozlowski+dt@linaro.org>, <krzk+dt@kernel.org>,
	<conor+dt@kernel.org>, <khilman@baylibre.com>, <jbrunet@baylibre.com>,
	<martin.blumenstingl@googlemail.com>, <vadim.fedorenko@linux.dev>
CC: <linux-crypto@vger.kernel.org>, <linux-amlogic@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <kernel@salutedevices.com>, "Alexey
 Romanov" <avromanov@salutedevices.com>
Subject: [PATCH v11 10/22] crypto: amlogic - Avoid kzalloc in engine thread
Date: Fri, 13 Dec 2024 17:07:43 +0300
Message-ID: <20241213140755.1298323-11-avromanov@salutedevices.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241213140755.1298323-1-avromanov@salutedevices.com>
References: <20241213140755.1298323-1-avromanov@salutedevices.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: p-i-exch-a-m1.sberdevices.ru (172.24.196.116) To
 p-i-exch-a-m1.sberdevices.ru (172.24.196.116)
X-KSMG-Rule-ID: 10
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Lua-Profiles: 189823 [Dec 13 2024]
X-KSMG-AntiSpam-Version: 6.1.1.7
X-KSMG-AntiSpam-Envelope-From: avromanov@salutedevices.com
X-KSMG-AntiSpam-Rate: 0
X-KSMG-AntiSpam-Status: not_detected
X-KSMG-AntiSpam-Method: none
X-KSMG-AntiSpam-Auth: dkim=none
X-KSMG-AntiSpam-Info: LuaCore: 47 0.3.47 57010b355d009055a5b6c34e0385c69b21a4e07f, {Tracking_from_domain_doesnt_match_to}, smtp.sberdevices.ru:7.1.1,5.0.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;salutedevices.com:7.1.1, FromAlignment: s
X-MS-Exchange-Organization-SCL: -1
X-KSMG-AntiSpam-Interceptor-Info: scan successful
X-KSMG-AntiPhishing: Clean
X-KSMG-LinksScanning: Clean
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 2.0.1.6960, bases: 2024/12/13 12:33:00 #26873825
X-KSMG-AntiVirus-Status: Clean, skipped

It makes no sense to allocate memory via kzalloc, we
can use static buffer, speedup data processing and
don't think about kfree() calls.

Signed-off-by: Alexey Romanov <avromanov@salutedevices.com>
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
index 9fbe5ab44877..aca0bbb9badc 100644
--- a/drivers/crypto/amlogic/amlogic-gxl.h
+++ b/drivers/crypto/amlogic/amlogic-gxl.h
@@ -127,14 +127,14 @@ struct meson_cipher_req_ctx {
 
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
2.34.1

