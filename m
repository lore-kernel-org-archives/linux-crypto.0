From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: [PATCH] Fix request context corruption.
Date: Wed, 19 Nov 2008 17:03:30 +0300
Message-ID: <12271034142436-git-send-email-zbr@ioremap.net>
References: <12271034133347-git-send-email-zbr@ioremap.net>
 <12271034132587-git-send-email-zbr@ioremap.net>
 <12271034131753-git-send-email-zbr@ioremap.net>
 <1227103414646-git-send-email-zbr@ioremap.net>
 <1227103414418-git-send-email-zbr@ioremap.net>
Cc: linux-crypto@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Evgeniy Polyakov <zbr@ioremap.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zbr.yandex.ru ([213.180.219.33]:37389 "EHLO gavana.yandex.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753990AbYKSOH4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Nov 2008 09:07:56 -0500
In-Reply-To: <1227103414418-git-send-email-zbr@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

HIFN uses the transform context to store per-request data, which breaks
when more than one request is outstanding. Move per request members from
struct hifn_context to a new struct hifn_request_context and convert
the code to use this.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>
---
 drivers/crypto/hifn_795x.c |  100 ++++++++++++++++++++++++-------------------
 1 files changed, 56 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 13152f1..9a9e7ea 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -657,9 +657,15 @@ struct ablkcipher_walk
 
 struct hifn_context
 {
-	u8			key[HIFN_MAX_CRYPT_KEY_LENGTH], *iv;
+	u8			key[HIFN_MAX_CRYPT_KEY_LENGTH];
 	struct hifn_device	*dev;
-	unsigned int		keysize, ivsize;
+	unsigned int		keysize;
+};
+
+struct hifn_request_context
+{
+	u8			*iv;
+	unsigned int		ivsize;
 	u8			op, type, mode, unused;
 	struct ablkcipher_walk	walk;
 };
@@ -1167,7 +1173,8 @@ static int hifn_setup_crypto_command(struct hifn_device *dev,
 }
 
 static int hifn_setup_cmd_desc(struct hifn_device *dev,
-		struct hifn_context *ctx, void *priv, unsigned int nbytes)
+		struct hifn_context *ctx, struct hifn_request_context *rctx,
+		void *priv, unsigned int nbytes)
 {
 	struct hifn_dma *dma = (struct hifn_dma *)dev->desc_virt;
 	int cmd_len, sa_idx;
@@ -1178,7 +1185,7 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 	buf_pos = buf = dma->command_bufs[dma->cmdi];
 
 	mask = 0;
-	switch (ctx->op) {
+	switch (rctx->op) {
 		case ACRYPTO_OP_DECRYPT:
 			mask = HIFN_BASE_CMD_CRYPT | HIFN_BASE_CMD_DECODE;
 			break;
@@ -1195,15 +1202,15 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 	buf_pos += hifn_setup_base_command(dev, buf_pos, nbytes,
 			nbytes, mask, dev->snum);
 
-	if (ctx->op == ACRYPTO_OP_ENCRYPT || ctx->op == ACRYPTO_OP_DECRYPT) {
+	if (rctx->op == ACRYPTO_OP_ENCRYPT || rctx->op == ACRYPTO_OP_DECRYPT) {
 		u16 md = 0;
 
 		if (ctx->keysize)
 			md |= HIFN_CRYPT_CMD_NEW_KEY;
-		if (ctx->iv && ctx->mode != ACRYPTO_MODE_ECB)
+		if (rctx->iv && rctx->mode != ACRYPTO_MODE_ECB)
 			md |= HIFN_CRYPT_CMD_NEW_IV;
 
-		switch (ctx->mode) {
+		switch (rctx->mode) {
 			case ACRYPTO_MODE_ECB:
 				md |= HIFN_CRYPT_CMD_MODE_ECB;
 				break;
@@ -1220,7 +1227,7 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 				goto err_out;
 		}
 
-		switch (ctx->type) {
+		switch (rctx->type) {
 			case ACRYPTO_TYPE_AES_128:
 				if (ctx->keysize != 16)
 					goto err_out;
@@ -1255,7 +1262,7 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 
 		buf_pos += hifn_setup_crypto_command(dev, buf_pos,
 				nbytes, nbytes, ctx->key, ctx->keysize,
-				ctx->iv, ctx->ivsize, md);
+				rctx->iv, rctx->ivsize, md);
 	}
 
 	dev->sa[sa_idx] = priv;
@@ -1265,7 +1272,7 @@ static int hifn_setup_cmd_desc(struct hifn_device *dev,
 			HIFN_D_LAST | HIFN_D_MASKDONEIRQ);
 
 	if (++dma->cmdi == HIFN_D_CMD_RSIZE) {
-		dma->cmdr[dma->cmdi].l = __cpu_to_le32(HIFN_MAX_COMMAND |
+		dma->cmdr[dma->cmdi].l = __cpu_to_le32(
 			HIFN_D_VALID | HIFN_D_LAST |
 			HIFN_D_MASKDONEIRQ | HIFN_D_JUMP);
 		dma->cmdi = 0;
@@ -1369,7 +1376,8 @@ static void hifn_setup_dst_desc(struct hifn_device *dev, struct page *page,
 	}
 }
 
-static int hifn_setup_dma(struct hifn_device *dev, struct hifn_context *ctx,
+static int hifn_setup_dma(struct hifn_device *dev,
+		struct hifn_context *ctx, struct hifn_request_context *rctx,
 		struct scatterlist *src, struct scatterlist *dst,
 		unsigned int nbytes, void *priv)
 {
@@ -1385,18 +1393,18 @@ static int hifn_setup_dma(struct hifn_device *dev, struct hifn_context *ctx,
 		len = min(src->length, n);
 
 		dprintk("%s: spage: %p, soffset: %u, nbytes: %u, "
-			"priv: %p, ctx: %p.\n",
-			dev->name, spage, soff, nbytes, priv, ctx);
+			"priv: %p, rctx: %p.\n",
+			dev->name, spage, soff, nbytes, priv, rctx);
 		hifn_setup_src_desc(dev, spage, soff, len, n - len == 0);
 
 		src++;
 		n -= len;
 	}
 
-	t = &ctx->walk.cache[0];
+	t = &rctx->walk.cache[0];
 	n = nbytes;
 	while (n) {
-		if (t->length) {
+		if (t->length && rctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
 			dpage = sg_page(t);
 			doff = 0;
 			len = t->length;
@@ -1408,8 +1416,8 @@ static int hifn_setup_dma(struct hifn_device *dev, struct hifn_context *ctx,
 		len = min(len, n);
 
 		dprintk("%s: dpage: %p, doffset: %u, nbytes: %u, "
-			"priv: %p, ctx: %p.\n",
-			dev->name, dpage, doff, nbytes, priv, ctx);
+			"priv: %p, rctx: %p.\n",
+			dev->name, dpage, doff, nbytes, priv, rctx);
 		hifn_setup_dst_desc(dev, dpage, doff, len, n - len == 0);
 
 		dst++;
@@ -1417,7 +1425,7 @@ static int hifn_setup_dma(struct hifn_device *dev, struct hifn_context *ctx,
 		n -= len;
 	}
 
-	hifn_setup_cmd_desc(dev, ctx, priv, nbytes);
+	hifn_setup_cmd_desc(dev, ctx, rctx, priv, nbytes);
 	hifn_setup_res_desc(dev);
 	return 0;
 }
@@ -1580,16 +1588,17 @@ static int ablkcipher_walk(struct ablkcipher_request *req,
 static int hifn_setup_session(struct ablkcipher_request *req)
 {
 	struct hifn_context *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct hifn_request_context *rctx = ablkcipher_request_ctx(req);
 	struct hifn_device *dev = ctx->dev;
 	unsigned long dlen, flags;
 	unsigned int nbytes = req->nbytes, idx = 0;
 	int err = -EINVAL, sg_num;
 	struct scatterlist *dst;
 
-	if (ctx->iv && !ctx->ivsize && ctx->mode != ACRYPTO_MODE_ECB)
+	if (rctx->iv && !rctx->ivsize && rctx->mode != ACRYPTO_MODE_ECB)
 		goto err_out_exit;
 
-	ctx->walk.flags = 0;
+	rctx->walk.flags = 0;
 
 	while (nbytes) {
 		dst = &req->dst[idx];
@@ -1597,19 +1606,19 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 
 		if (!IS_ALIGNED(dst->offset, HIFN_D_DST_DALIGN) ||
 		    !IS_ALIGNED(dlen, HIFN_D_DST_DALIGN))
-			ctx->walk.flags |= ASYNC_FLAGS_MISALIGNED;
+			rctx->walk.flags |= ASYNC_FLAGS_MISALIGNED;
 
 		nbytes -= dlen;
 		idx++;
 	}
 
-	if (ctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
-		err = ablkcipher_walk_init(&ctx->walk, idx, GFP_ATOMIC);
+	if (rctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
+		err = ablkcipher_walk_init(&rctx->walk, idx, GFP_ATOMIC);
 		if (err < 0)
 			return err;
 	}
 
-	sg_num = ablkcipher_walk(req, &ctx->walk);
+	sg_num = ablkcipher_walk(req, &rctx->walk);
 	if (sg_num < 0) {
 		err = sg_num;
 		goto err_out_exit;
@@ -1624,7 +1633,7 @@ static int hifn_setup_session(struct ablkcipher_request *req)
 	dev->snum++;
 	dev->started++;
 
-	err = hifn_setup_dma(dev, ctx, req->src, req->dst, req->nbytes, req);
+	err = hifn_setup_dma(dev, ctx, rctx, req->src, req->dst, req->nbytes, req);
 	if (err)
 		goto err_out;
 
@@ -1639,9 +1648,9 @@ err_out_exit:
 	if (err)
 		dprintk("%s: iv: %p [%d], key: %p [%d], mode: %u, op: %u, "
 				"type: %u, err: %d.\n",
-			dev->name, ctx->iv, ctx->ivsize,
+			dev->name, rctx->iv, rctx->ivsize,
 			ctx->key, ctx->keysize,
-			ctx->mode, ctx->op, ctx->type, err);
+			rctx->mode, rctx->op, rctx->type, err);
 
 	return err;
 }
@@ -1651,6 +1660,7 @@ static int hifn_test(struct hifn_device *dev, int encdec, u8 snum)
 	int n, err;
 	u8 src[16];
 	struct hifn_context ctx;
+	struct hifn_request_context rctx;
 	u8 fips_aes_ecb_from_zero[16] = {
 		0x66, 0xE9, 0x4B, 0xD4,
 		0xEF, 0x8A, 0x2C, 0x3B,
@@ -1663,16 +1673,16 @@ static int hifn_test(struct hifn_device *dev, int encdec, u8 snum)
 
 	ctx.dev = dev;
 	ctx.keysize = 16;
-	ctx.ivsize = 0;
-	ctx.iv = NULL;
-	ctx.op = (encdec)?ACRYPTO_OP_ENCRYPT:ACRYPTO_OP_DECRYPT;
-	ctx.mode = ACRYPTO_MODE_ECB;
-	ctx.type = ACRYPTO_TYPE_AES_128;
-	ctx.walk.cache[0].length = 0;
+	rctx.ivsize = 0;
+	rctx.iv = NULL;
+	rctx.op = (encdec)?ACRYPTO_OP_ENCRYPT:ACRYPTO_OP_DECRYPT;
+	rctx.mode = ACRYPTO_MODE_ECB;
+	rctx.type = ACRYPTO_TYPE_AES_128;
+	rctx.walk.cache[0].length = 0;
 
 	sg_init_one(&sg, &src, sizeof(src));
 
-	err = hifn_setup_dma(dev, &ctx, &sg, &sg, sizeof(src), NULL);
+	err = hifn_setup_dma(dev, &ctx, &rctx, &sg, &sg, sizeof(src), NULL);
 	if (err)
 		goto err_out;
 
@@ -1758,9 +1768,10 @@ static int ablkcipher_get(void *saddr, unsigned int *srestp, unsigned int offset
 static void hifn_process_ready(struct ablkcipher_request *req, int error)
 {
 	struct hifn_context *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct hifn_request_context *rctx = ablkcipher_request_ctx(req);
 	struct hifn_device *dev;
 
-	dprintk("%s: req: %p, ctx: %p.\n", __func__, req, ctx);
+	dprintk("%s: req: %p, ctx: %p rctx: %p.\n", __func__, req, ctx, rctx);
 
 	dev = ctx->dev;
 	dprintk("%s: req: %p, started: %d.\n", __func__, req, dev->started);
@@ -1768,14 +1779,14 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 	if (--dev->started < 0)
 		BUG();
 
-	if (ctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
+	if (rctx->walk.flags & ASYNC_FLAGS_MISALIGNED) {
 		unsigned int nbytes = req->nbytes;
 		int idx = 0, err;
 		struct scatterlist *dst, *t;
 		void *saddr;
 
 		while (nbytes) {
-			t = &ctx->walk.cache[idx];
+			t = &rctx->walk.cache[idx];
 			dst = &req->dst[idx];
 
 			dprintk("\n%s: sg_page(t): %p, t->length: %u, "
@@ -1803,7 +1814,7 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 			kunmap_atomic(saddr, KM_IRQ1);
 		}
 
-		ablkcipher_walk_exit(&ctx->walk);
+		ablkcipher_walk_exit(&rctx->walk);
 	}
 
 	req->base.complete(&req->base, error);
@@ -2109,6 +2120,7 @@ static int hifn_setup_crypto_req(struct ablkcipher_request *req, u8 op,
 		u8 type, u8 mode)
 {
 	struct hifn_context *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct hifn_request_context *rctx = ablkcipher_request_ctx(req);
 	unsigned ivsize;
 
 	ivsize = crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(req));
@@ -2129,11 +2141,11 @@ static int hifn_setup_crypto_req(struct ablkcipher_request *req, u8 op,
 			type = ACRYPTO_TYPE_AES_256;
 	}
 
-	ctx->op = op;
-	ctx->mode = mode;
-	ctx->type = type;
-	ctx->iv = req->info;
-	ctx->ivsize = ivsize;
+	rctx->op = op;
+	rctx->mode = mode;
+	rctx->type = type;
+	rctx->iv = req->info;
+	rctx->ivsize = ivsize;
 
 	/*
 	 * HEAVY TODO: needs to kick Herbert XU to write documentation.
@@ -2484,7 +2496,7 @@ static int hifn_cra_init(struct crypto_tfm *tfm)
 	struct hifn_context *ctx = crypto_tfm_ctx(tfm);
 
 	ctx->dev = ha->dev;
