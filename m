Received: from smtpout-03.galae.net (smtpout-03.galae.net [185.246.85.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B08B384CE9;
	Fri, 11 Sep 2026 14:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.246.85.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138048; cv=none; b=eYTeGBinOGbhsbB5BjYHQnPe5IHneOe6kQDnVo2PRbs2wehE9sSey1CRDaBI9s4mH4e2WFHUzy3rnHFlUvdncWMku1uqhwzTwM3Adr5LRbwD74WswiRfpK3tWQlwwrdR57qCILI25OXOV/LW36pkGTb2NuMhWi1WXowr7UQfR3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138048; c=relaxed/simple;
	bh=310yfrmXGU19HZ7S1v7GTmTaaToAtr4tGwIh9BBX67E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=g/rnnRiQI09OaCM+JRAVWkh6JHk4R/mLOwlp/R1oPbGQ2hxkMOreCgWH5pQVKdO7a2i32ZTK0qqbJjc5wUciXQdzB1jYj+S0YEJoxneYsvm9MFWzuR8888nVljJPVYuqtygGX3+r1xdVgnRQQ0/c70jcpfi2hcMPdxpt9xUqDro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=rvZGbOB6; arc=none smtp.client-ip=185.246.85.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="rvZGbOB6"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-03.galae.net (Postfix) with ESMTPS id 94EF04E401F2;
	Fri, 11 Sep 2026 14:47:23 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 69D0C601DE;
	Fri, 11 Sep 2026 14:47:23 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2290711C7AFA5;
	Fri, 11 Sep 2026 16:47:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1789138042; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=PO+rYKM6F77jR7XPvoY3xK2p30omlFKVon5uPz+NutU=;
	b=rvZGbOB6ubykVbYhuBoYA1Ct+TZk4LxaHqc7q4WpsvNYy0RPpxpjWnKPG54uPtAmDnxewu
	DmrA/wt2C0Q3zIbejR4hno0wB2jbBgbBGgmB5IaysuxWH+gn0unHNcKgZryId+PodmUwRZ
	/MXhaPHKBTYslZ3wRurmrAXWQDGKdRCVstTCgDd7MJoZ1lmnS9FyGO0/LdhNdyrXRfxvRI
	rkX/Wcur0RAgykD9jX94M+0RUgMoZ35/0Ih0Z7vgwe7NJqDqyoIjlrwDA8Z9+Kh7q3I0g+
	vMvOXa9+/l+wDVg5BxQPEj/xAPc0EzKqVTYgEAP87hHoG5vQiON4uT34hLKcOg==
From: Paul Louvel <paul.louvel@bootlin.com>
Date: Fri, 11 Sep 2026 16:46:24 +0200
Subject: [PATCH v6 07/19] crypto: talitos/skcipher - Move into separate
 file
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260911-7-3-rc2_talitos_cleanup-v6-7-4215f347c97a@bootlin.com>
References: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
In-Reply-To: <20260911-7-3-rc2_talitos_cleanup-v6-0-4215f347c97a@bootlin.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>
Cc: Paul Louvel <paul.louvel@bootlin.com>, linux-crypto@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Christophe Leroy <chleroy@kernel.org>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789138028; l=28588;
 i=paul.louvel@bootlin.com; s=20260313; h=from:subject:message-id;
 bh=310yfrmXGU19HZ7S1v7GTmTaaToAtr4tGwIh9BBX67E=;
 b=H30XzA+QJ7i4MJ7KcheJoUELZyLvn4i+KcJpBjGjUZE6ZOSsz7PFdBTq3Xae9Dw6yrj15uArb
 a7UdBg9tKQmCFllai2kLQe+mGB+KshzeDLXb4/Hb3zE9HA6cRA4GmKs
X-Developer-Key: i=paul.louvel@bootlin.com; a=ed25519;
 pk=eLW50NT18UAvUT5cAcYf88zNbBCZDLFXuptpyLVhVIU=
X-Last-TLS-Session-Version: TLSv1.3

Move the skcipher algorithm implementations from talitos.c into
a dedicated talitos-skcipher.c file.

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
---
 drivers/crypto/talitos/Makefile           |   2 +-
 drivers/crypto/talitos/talitos-skcipher.c | 402 ++++++++++++++++++++++++++++++
 drivers/crypto/talitos/talitos.c          | 377 +---------------------------
 drivers/crypto/talitos/talitos.h          |   1 +
 4 files changed, 414 insertions(+), 368 deletions(-)

diff --git a/drivers/crypto/talitos/Makefile b/drivers/crypto/talitos/Makefile
index 57e5cb3bf8ba..34f1871276b0 100644
--- a/drivers/crypto/talitos/Makefile
+++ b/drivers/crypto/talitos/Makefile
@@ -1,3 +1,3 @@
 obj-$(CONFIG_CRYPTO_DEV_TALITOS) += crypto-talitos.o
 
-crypto-talitos-y := talitos.o talitos-rng.o talitos-hash.o
+crypto-talitos-y := talitos.o talitos-rng.o talitos-hash.o talitos-skcipher.o
diff --git a/drivers/crypto/talitos/talitos-skcipher.c b/drivers/crypto/talitos/talitos-skcipher.c
new file mode 100644
index 000000000000..e4e8bebdfb7b
--- /dev/null
+++ b/drivers/crypto/talitos/talitos-skcipher.c
@@ -0,0 +1,402 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+/*
+ * Freescale SEC (talitos) skcipher implementation
+ *
+ * Copyright (c) 2006-2011 Freescale Semiconductor, Inc.
+ */
+
+#include <crypto/internal/des.h>
+#include <crypto/internal/skcipher.h>
+
+#include "talitos.h"
+
+static void common_nonsnoop_unmap(struct device *dev,
+				  struct talitos_edesc *edesc,
+				  struct skcipher_request *areq)
+{
+	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
+
+	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->cryptlen, 0);
+	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1], DMA_TO_DEVICE);
+
+	if (edesc->dma_len)
+		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
+				 DMA_BIDIRECTIONAL);
+}
+
+static void skcipher_done(struct device *dev,
+			    struct talitos_desc *desc, void *context,
+			    int err)
+{
+	struct skcipher_request *areq = context;
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
+	unsigned int ivsize = crypto_skcipher_ivsize(cipher);
+	struct talitos_edesc *edesc;
+
+	edesc = container_of(desc, struct talitos_edesc, desc);
+
+	common_nonsnoop_unmap(dev, edesc, areq);
+	memcpy(areq->iv, ctx->iv, ivsize);
+
+	kfree(edesc);
+
+	skcipher_request_complete(areq, err);
+}
+
+static int common_nonsnoop(struct talitos_edesc *edesc,
+			   struct skcipher_request *areq,
+			   void (*callback) (struct device *dev,
+					     struct talitos_desc *desc,
+					     void *context, int error))
+{
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
+	struct device *dev = ctx->dev;
+	struct talitos_desc *desc = &edesc->desc;
+	unsigned int cryptlen = areq->cryptlen;
+	unsigned int ivsize = crypto_skcipher_ivsize(cipher);
+	int sg_count, ret;
+	bool sync_needed = false;
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+	bool is_ctr = (desc->hdr & DESC_HDR_SEL0_MASK) == DESC_HDR_SEL0_AESU &&
+		      (desc->hdr & DESC_HDR_MODE0_AESU_MASK) == DESC_HDR_MODE0_AESU_CTR;
+
+	/* first DWORD empty */
+
+	/* cipher iv */
+	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, ivsize, is_sec1);
+
+	/* cipher key */
+	to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen, is_sec1);
+
+	sg_count = edesc->src_nents ?: 1;
+	if (is_sec1 && sg_count > 1)
+		sg_copy_to_buffer(areq->src, sg_count, edesc->buf,
+				  cryptlen);
+	else
+		sg_count = dma_map_sg(dev, areq->src, sg_count,
+				      (areq->src == areq->dst) ?
+				      DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
+	/*
+	 * cipher in
+	 */
+	sg_count = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[3],
+				      sg_count, 0, 0, 0, false, is_ctr ? 16 : 1);
+	if (sg_count > 1)
+		sync_needed = true;
+
+	/* cipher out */
+	if (areq->src != areq->dst) {
+		sg_count = edesc->dst_nents ? : 1;
+		if (!is_sec1 || sg_count == 1)
+			dma_map_sg(dev, areq->dst, sg_count, DMA_FROM_DEVICE);
+	}
+
+	ret = talitos_sg_map(dev, areq->dst, cryptlen, edesc, &desc->ptr[4],
+			     sg_count, 0, (edesc->src_nents + 1));
+	if (ret > 1)
+		sync_needed = true;
+
+	/* iv out */
+	map_single_talitos_ptr(dev, &desc->ptr[5], ivsize, ctx->iv,
+			       DMA_FROM_DEVICE);
+
+	/* last DWORD empty */
+
+	if (sync_needed)
+		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
+					   edesc->dma_len, DMA_BIDIRECTIONAL);
+
+	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
+	if (ret != -EINPROGRESS) {
+		common_nonsnoop_unmap(dev, edesc, areq);
+		kfree(edesc);
+	}
+	return ret;
+}
+
+static int skcipher_setkey(struct crypto_skcipher *cipher,
+			     const u8 *key, unsigned int keylen)
+{
+	struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
+	struct device *dev = ctx->dev;
+
+	if (ctx->keylen)
+		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
+
+	memcpy(&ctx->key, key, keylen);
+	ctx->keylen = keylen;
+
+	ctx->dma_key = dma_map_single(dev, ctx->key, keylen, DMA_TO_DEVICE);
+
+	return 0;
+}
+
+static int skcipher_des_setkey(struct crypto_skcipher *cipher,
+				 const u8 *key, unsigned int keylen)
+{
+	return verify_skcipher_des_key(cipher, key) ?:
+	       skcipher_setkey(cipher, key, keylen);
+}
+
+static int skcipher_des3_setkey(struct crypto_skcipher *cipher,
+				  const u8 *key, unsigned int keylen)
+{
+	return verify_skcipher_des3_key(cipher, key) ?:
+	       skcipher_setkey(cipher, key, keylen);
+}
+
+static int skcipher_aes_setkey(struct crypto_skcipher *cipher,
+				  const u8 *key, unsigned int keylen)
+{
+	if (keylen == AES_KEYSIZE_128 || keylen == AES_KEYSIZE_192 ||
+	    keylen == AES_KEYSIZE_256)
+		return skcipher_setkey(cipher, key, keylen);
+
+	return -EINVAL;
+}
+
+static struct talitos_edesc *skcipher_edesc_alloc(struct skcipher_request *
+						    areq, bool encrypt)
+{
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
+	unsigned int ivsize = crypto_skcipher_ivsize(cipher);
+
+	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
+				   areq->iv, 0, areq->cryptlen, 0, ivsize, 0,
+				   areq->base.flags, encrypt);
+}
+
+static int skcipher_encrypt(struct skcipher_request *areq)
+{
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
+	struct talitos_edesc *edesc;
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_skcipher_tfm(cipher));
+
+	if (!areq->cryptlen)
+		return 0;
+
+	if (areq->cryptlen % blocksize)
+		return -EINVAL;
+
+	/* allocate extended descriptor */
+	edesc = skcipher_edesc_alloc(areq, true);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	/* set encrypt */
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
+
+	return common_nonsnoop(edesc, areq, skcipher_done);
+}
+
+static int skcipher_decrypt(struct skcipher_request *areq)
+{
+	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
+	struct talitos_edesc *edesc;
+	unsigned int blocksize =
+			crypto_tfm_alg_blocksize(crypto_skcipher_tfm(cipher));
+
+	if (!areq->cryptlen)
+		return 0;
+
+	if (areq->cryptlen % blocksize)
+		return -EINVAL;
+
+	/* allocate extended descriptor */
+	edesc = skcipher_edesc_alloc(areq, false);
+	if (IS_ERR(edesc))
+		return PTR_ERR(edesc);
+
+	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
+
+	return common_nonsnoop(edesc, areq, skcipher_done);
+}
+
+static int talitos_cra_init_skcipher(struct crypto_skcipher *tfm)
+{
+	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
+	struct talitos_crypto_alg *talitos_alg;
+	struct talitos_ctx *ctx = crypto_skcipher_ctx(tfm);
+
+	talitos_alg = container_of(alg, struct talitos_crypto_alg,
+				   algt.alg.skcipher);
+
+	return talitos_init_common(ctx, talitos_alg);
+}
+
+static const struct talitos_alg_template skcipher_driver_algs[] = {
+	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+		.alg.skcipher = {
+			.base.cra_name = "ecb(aes)",
+			.base.cra_driver_name = "ecb-aes-talitos",
+			.base.cra_blocksize = AES_BLOCK_SIZE,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.setkey = skcipher_aes_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU,
+	},
+	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+		.alg.skcipher = {
+			.base.cra_name = "cbc(aes)",
+			.base.cra_driver_name = "cbc-aes-talitos",
+			.base.cra_blocksize = AES_BLOCK_SIZE,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			.setkey = skcipher_aes_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CBC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+		.alg.skcipher = {
+			.base.cra_name = "ctr(aes)",
+			.base.cra_driver_name = "ctr-aes-talitos",
+			.base.cra_blocksize = 1,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			.setkey = skcipher_aes_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_AESU_CTR_NONSNOOP |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CTR,
+	},
+	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+		.alg.skcipher = {
+			.base.cra_name = "ctr(aes)",
+			.base.cra_driver_name = "ctr-aes-talitos",
+			.base.cra_blocksize = 1,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
+			.ivsize = AES_BLOCK_SIZE,
+			.setkey = skcipher_aes_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_AESU |
+				     DESC_HDR_MODE0_AESU_CTR,
+	},
+	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+		.alg.skcipher = {
+			.base.cra_name = "ecb(des)",
+			.base.cra_driver_name = "ecb-des-talitos",
+			.base.cra_blocksize = DES_BLOCK_SIZE,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.setkey = skcipher_des_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU,
+	},
+	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+		.alg.skcipher = {
+			.base.cra_name = "cbc(des)",
+			.base.cra_driver_name = "cbc-des-talitos",
+			.base.cra_blocksize = DES_BLOCK_SIZE,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
+			.min_keysize = DES_KEY_SIZE,
+			.max_keysize = DES_KEY_SIZE,
+			.ivsize = DES_BLOCK_SIZE,
+			.setkey = skcipher_des_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC,
+	},
+	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+		.alg.skcipher = {
+			.base.cra_name = "ecb(des3_ede)",
+			.base.cra_driver_name = "ecb-3des-talitos",
+			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.setkey = skcipher_des3_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_3DES,
+	},
+	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
+		.alg.skcipher = {
+			.base.cra_name = "cbc(des3_ede)",
+			.base.cra_driver_name = "cbc-3des-talitos",
+			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
+			.base.cra_flags = CRYPTO_ALG_ASYNC |
+					  CRYPTO_ALG_ALLOCATES_MEMORY,
+			.min_keysize = DES3_EDE_KEY_SIZE,
+			.max_keysize = DES3_EDE_KEY_SIZE,
+			.ivsize = DES3_EDE_BLOCK_SIZE,
+			.setkey = skcipher_des3_setkey,
+		},
+		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
+				     DESC_HDR_SEL0_DEU |
+				     DESC_HDR_MODE0_DEU_CBC |
+				     DESC_HDR_MODE0_DEU_3DES,
+	},
+};
+
+int talitos_register_skcipher(struct device *dev)
+{
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	struct talitos_alg_template talitos_alg_template;
+	struct skcipher_alg *skcipher_alg;
+	struct crypto_alg *alg;
+	size_t i;
+	int ret;
+
+	for (i = 0; i < ARRAY_SIZE(skcipher_driver_algs); i++) {
+		if (!talitos_hw_supports(
+			    dev, skcipher_driver_algs[i].desc_hdr_template))
+			continue;
+
+		talitos_alg_template = skcipher_driver_algs[i];
+
+		skcipher_alg = &talitos_alg_template.alg.skcipher;
+		alg = &skcipher_alg->base;
+
+		alg->cra_exit = talitos_cra_exit;
+		if (has_ftr_sec1(priv))
+			alg->cra_alignmask = 3;
+
+		skcipher_alg->init = talitos_cra_init_skcipher;
+		skcipher_alg->setkey = skcipher_alg->setkey ?: skcipher_setkey;
+		skcipher_alg->encrypt = skcipher_encrypt;
+		skcipher_alg->decrypt = skcipher_decrypt;
+
+		if (!strcmp(alg->cra_name, "ctr(aes)") && !has_ftr_sec1(priv) &&
+		    DESC_TYPE(talitos_alg_template.desc_hdr_template) !=
+			    DESC_TYPE(DESC_HDR_TYPE_AESU_CTR_NONSNOOP)) {
+			continue;
+		}
+
+		ret = talitos_register_common(dev, &talitos_alg_template);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/talitos/talitos.c b/drivers/crypto/talitos/talitos.c
index 5e5ccdeec82b..6b671b26e1af 100644
--- a/drivers/crypto/talitos/talitos.c
+++ b/drivers/crypto/talitos/talitos.c
@@ -1339,215 +1339,6 @@ static int aead_decrypt(struct aead_request *req)
 	return ipsec_esp(edesc, req, false, ipsec_esp_decrypt_swauth_done);
 }
 
-static int skcipher_setkey(struct crypto_skcipher *cipher,
-			     const u8 *key, unsigned int keylen)
-{
-	struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
-	struct device *dev = ctx->dev;
-
-	if (ctx->keylen)
-		dma_unmap_single(dev, ctx->dma_key, ctx->keylen, DMA_TO_DEVICE);
-
-	memcpy(&ctx->key, key, keylen);
-	ctx->keylen = keylen;
-
-	ctx->dma_key = dma_map_single(dev, ctx->key, keylen, DMA_TO_DEVICE);
-
-	return 0;
-}
-
-static int skcipher_des_setkey(struct crypto_skcipher *cipher,
-				 const u8 *key, unsigned int keylen)
-{
-	return verify_skcipher_des_key(cipher, key) ?:
-	       skcipher_setkey(cipher, key, keylen);
-}
-
-static int skcipher_des3_setkey(struct crypto_skcipher *cipher,
-				  const u8 *key, unsigned int keylen)
-{
-	return verify_skcipher_des3_key(cipher, key) ?:
-	       skcipher_setkey(cipher, key, keylen);
-}
-
-static int skcipher_aes_setkey(struct crypto_skcipher *cipher,
-				  const u8 *key, unsigned int keylen)
-{
-	if (keylen == AES_KEYSIZE_128 || keylen == AES_KEYSIZE_192 ||
-	    keylen == AES_KEYSIZE_256)
-		return skcipher_setkey(cipher, key, keylen);
-
-	return -EINVAL;
-}
-
-static void common_nonsnoop_unmap(struct device *dev,
-				  struct talitos_edesc *edesc,
-				  struct skcipher_request *areq)
-{
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVICE);
-
-	talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->cryptlen, 0);
-	unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1], DMA_TO_DEVICE);
-
-	if (edesc->dma_len)
-		dma_unmap_single(dev, edesc->dma_link_tbl, edesc->dma_len,
-				 DMA_BIDIRECTIONAL);
-}
-
-static void skcipher_done(struct device *dev,
-			    struct talitos_desc *desc, void *context,
-			    int err)
-{
-	struct skcipher_request *areq = context;
-	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
-	unsigned int ivsize = crypto_skcipher_ivsize(cipher);
-	struct talitos_edesc *edesc;
-
-	edesc = container_of(desc, struct talitos_edesc, desc);
-
-	common_nonsnoop_unmap(dev, edesc, areq);
-	memcpy(areq->iv, ctx->iv, ivsize);
-
-	kfree(edesc);
-
-	skcipher_request_complete(areq, err);
-}
-
-static int common_nonsnoop(struct talitos_edesc *edesc,
-			   struct skcipher_request *areq,
-			   void (*callback) (struct device *dev,
-					     struct talitos_desc *desc,
-					     void *context, int error))
-{
-	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
-	struct device *dev = ctx->dev;
-	struct talitos_desc *desc = &edesc->desc;
-	unsigned int cryptlen = areq->cryptlen;
-	unsigned int ivsize = crypto_skcipher_ivsize(cipher);
-	int sg_count, ret;
-	bool sync_needed = false;
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-	bool is_ctr = (desc->hdr & DESC_HDR_SEL0_MASK) == DESC_HDR_SEL0_AESU &&
-		      (desc->hdr & DESC_HDR_MODE0_AESU_MASK) == DESC_HDR_MODE0_AESU_CTR;
-
-	/* first DWORD empty */
-
-	/* cipher iv */
-	to_talitos_ptr(&desc->ptr[1], edesc->iv_dma, ivsize, is_sec1);
-
-	/* cipher key */
-	to_talitos_ptr(&desc->ptr[2], ctx->dma_key, ctx->keylen, is_sec1);
-
-	sg_count = edesc->src_nents ?: 1;
-	if (is_sec1 && sg_count > 1)
-		sg_copy_to_buffer(areq->src, sg_count, edesc->buf,
-				  cryptlen);
-	else
-		sg_count = dma_map_sg(dev, areq->src, sg_count,
-				      (areq->src == areq->dst) ?
-				      DMA_BIDIRECTIONAL : DMA_TO_DEVICE);
-	/*
-	 * cipher in
-	 */
-	sg_count = talitos_sg_map_ext(dev, areq->src, cryptlen, edesc, &desc->ptr[3],
-				      sg_count, 0, 0, 0, false, is_ctr ? 16 : 1);
-	if (sg_count > 1)
-		sync_needed = true;
-
-	/* cipher out */
-	if (areq->src != areq->dst) {
-		sg_count = edesc->dst_nents ? : 1;
-		if (!is_sec1 || sg_count == 1)
-			dma_map_sg(dev, areq->dst, sg_count, DMA_FROM_DEVICE);
-	}
-
-	ret = talitos_sg_map(dev, areq->dst, cryptlen, edesc, &desc->ptr[4],
-			     sg_count, 0, (edesc->src_nents + 1));
-	if (ret > 1)
-		sync_needed = true;
-
-	/* iv out */
-	map_single_talitos_ptr(dev, &desc->ptr[5], ivsize, ctx->iv,
-			       DMA_FROM_DEVICE);
-
-	/* last DWORD empty */
-
-	if (sync_needed)
-		dma_sync_single_for_device(dev, edesc->dma_link_tbl,
-					   edesc->dma_len, DMA_BIDIRECTIONAL);
-
-	ret = talitos_submit(dev, ctx->ch, desc, callback, areq);
-	if (ret != -EINPROGRESS) {
-		common_nonsnoop_unmap(dev, edesc, areq);
-		kfree(edesc);
-	}
-	return ret;
-}
-
-static struct talitos_edesc *skcipher_edesc_alloc(struct skcipher_request *
-						    areq, bool encrypt)
-{
-	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
-	unsigned int ivsize = crypto_skcipher_ivsize(cipher);
-
-	return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
-				   areq->iv, 0, areq->cryptlen, 0, ivsize, 0,
-				   areq->base.flags, encrypt);
-}
-
-static int skcipher_encrypt(struct skcipher_request *areq)
-{
-	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
-	struct talitos_edesc *edesc;
-	unsigned int blocksize =
-			crypto_tfm_alg_blocksize(crypto_skcipher_tfm(cipher));
-
-	if (!areq->cryptlen)
-		return 0;
-
-	if (areq->cryptlen % blocksize)
-		return -EINVAL;
-
-	/* allocate extended descriptor */
-	edesc = skcipher_edesc_alloc(areq, true);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
-
-	/* set encrypt */
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRYPT;
-
-	return common_nonsnoop(edesc, areq, skcipher_done);
-}
-
-static int skcipher_decrypt(struct skcipher_request *areq)
-{
-	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_skcipher_ctx(cipher);
-	struct talitos_edesc *edesc;
-	unsigned int blocksize =
-			crypto_tfm_alg_blocksize(crypto_skcipher_tfm(cipher));
-
-	if (!areq->cryptlen)
-		return 0;
-
-	if (areq->cryptlen % blocksize)
-		return -EINVAL;
-
-	/* allocate extended descriptor */
-	edesc = skcipher_edesc_alloc(areq, false);
-	if (IS_ERR(edesc))
-		return PTR_ERR(edesc);
-
-	edesc->desc.hdr = ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND;
-
-	return common_nonsnoop(edesc, areq, skcipher_done);
-}
-
 static struct talitos_alg_template driver_algs[] = {
 	/* AEAD algorithms.  These use a single-pass ipsec_esp descriptor */
 	{	.type = CRYPTO_ALG_TYPE_AEAD,
@@ -2006,131 +1797,6 @@ static struct talitos_alg_template driver_algs[] = {
 				     DESC_HDR_MODE1_MDEU_PAD |
 				     DESC_HDR_MODE1_MDEU_MD5_HMAC,
 	},
-	/* SKCIPHER algorithms. */
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "ecb(aes)",
-			.base.cra_driver_name = "ecb-aes-talitos",
-			.base.cra_blocksize = AES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.setkey = skcipher_aes_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "cbc(aes)",
-			.base.cra_driver_name = "cbc-aes-talitos",
-			.base.cra_blocksize = AES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			.setkey = skcipher_aes_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CBC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "ctr(aes)",
-			.base.cra_driver_name = "ctr-aes-talitos",
-			.base.cra_blocksize = 1,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			.setkey = skcipher_aes_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_AESU_CTR_NONSNOOP |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CTR,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "ctr(aes)",
-			.base.cra_driver_name = "ctr-aes-talitos",
-			.base.cra_blocksize = 1,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = AES_MIN_KEY_SIZE,
-			.max_keysize = AES_MAX_KEY_SIZE,
-			.ivsize = AES_BLOCK_SIZE,
-			.setkey = skcipher_aes_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_AESU |
-				     DESC_HDR_MODE0_AESU_CTR,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "ecb(des)",
-			.base.cra_driver_name = "ecb-des-talitos",
-			.base.cra_blocksize = DES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = DES_KEY_SIZE,
-			.max_keysize = DES_KEY_SIZE,
-			.setkey = skcipher_des_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "cbc(des)",
-			.base.cra_driver_name = "cbc-des-talitos",
-			.base.cra_blocksize = DES_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = DES_KEY_SIZE,
-			.max_keysize = DES_KEY_SIZE,
-			.ivsize = DES_BLOCK_SIZE,
-			.setkey = skcipher_des_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_CBC,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "ecb(des3_ede)",
-			.base.cra_driver_name = "ecb-3des-talitos",
-			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = DES3_EDE_KEY_SIZE,
-			.max_keysize = DES3_EDE_KEY_SIZE,
-			.setkey = skcipher_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-				     DESC_HDR_SEL0_DEU |
-				     DESC_HDR_MODE0_DEU_3DES,
-	},
-	{	.type = CRYPTO_ALG_TYPE_SKCIPHER,
-		.alg.skcipher = {
-			.base.cra_name = "cbc(des3_ede)",
-			.base.cra_driver_name = "cbc-3des-talitos",
-			.base.cra_blocksize = DES3_EDE_BLOCK_SIZE,
-			.base.cra_flags = CRYPTO_ALG_ASYNC |
-					  CRYPTO_ALG_ALLOCATES_MEMORY,
-			.min_keysize = DES3_EDE_KEY_SIZE,
-			.max_keysize = DES3_EDE_KEY_SIZE,
-			.ivsize = DES3_EDE_BLOCK_SIZE,
-			.setkey = skcipher_des3_setkey,
-		},
-		.desc_hdr_template = DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
-			             DESC_HDR_SEL0_DEU |
-		                     DESC_HDR_MODE0_DEU_CBC |
-		                     DESC_HDR_MODE0_DEU_3DES,
-	},
 };
 
 int talitos_init_common(struct talitos_ctx *ctx,
@@ -2167,18 +1833,6 @@ static int talitos_cra_init_aead(struct crypto_aead *tfm)
 	return talitos_init_common(ctx, talitos_alg);
 }
 
-static int talitos_cra_init_skcipher(struct crypto_skcipher *tfm)
-{
-	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
-	struct talitos_crypto_alg *talitos_alg;
-	struct talitos_ctx *ctx = crypto_skcipher_ctx(tfm);
-
-	talitos_alg = container_of(alg, struct talitos_crypto_alg,
-				   algt.alg.skcipher);
-
-	return talitos_init_common(ctx, talitos_alg);
-}
-
 void talitos_cra_exit(struct crypto_tfm *tfm)
 {
 	struct talitos_ctx *ctx = crypto_tfm_ctx(tfm);
@@ -2281,6 +1935,12 @@ int talitos_register_common(struct device *dev,
 				       t_alg->algt.type);
 		ret = crypto_register_ahash(&t_alg->algt.alg.hash);
 		break;
+	case CRYPTO_ALG_TYPE_SKCIPHER:
+		alg = &t_alg->algt.alg.skcipher.base;
+		talitos_alg_set_common(priv, alg, t_alg->algt.priority,
+				       t_alg->algt.type);
+		ret = crypto_register_skcipher(&t_alg->algt.alg.skcipher);
+		break;
 	default:
 		dev_err(dev, "unknown algorithm type %d\n", t_alg->algt.type);
 		devm_kfree(dev, t_alg);
@@ -2317,21 +1977,6 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	t_alg->algt = *template;
 
 	switch (t_alg->algt.type) {
-	case CRYPTO_ALG_TYPE_SKCIPHER:
-		alg = &t_alg->algt.alg.skcipher.base;
-		alg->cra_exit = talitos_cra_exit;
-		t_alg->algt.alg.skcipher.init = talitos_cra_init_skcipher;
-		t_alg->algt.alg.skcipher.setkey =
-			t_alg->algt.alg.skcipher.setkey ?: skcipher_setkey;
-		t_alg->algt.alg.skcipher.encrypt = skcipher_encrypt;
-		t_alg->algt.alg.skcipher.decrypt = skcipher_decrypt;
-		if (!strcmp(alg->cra_name, "ctr(aes)") && !has_ftr_sec1(priv) &&
-		    DESC_TYPE(t_alg->algt.desc_hdr_template) !=
-		    DESC_TYPE(DESC_HDR_TYPE_AESU_CTR_NONSNOOP)) {
-			devm_kfree(dev, t_alg);
-			return ERR_PTR(-ENOTSUPP);
-		}
-		break;
 	case CRYPTO_ALG_TYPE_AEAD:
 		alg = &t_alg->algt.alg.aead.base;
 		alg->cra_exit = talitos_cra_exit;
@@ -2576,6 +2221,10 @@ static int talitos_probe(struct platform_device *ofdev)
 	if (err)
 		goto err_out;
 
+	err = talitos_register_skcipher(dev);
+	if (err)
+		goto err_out;
+
 	/* register crypto algorithms the device supports */
 	for (i = 0; i < ARRAY_SIZE(driver_algs); i++) {
 		if (talitos_hw_supports(dev,
@@ -2592,12 +2241,6 @@ static int talitos_probe(struct platform_device *ofdev)
 			}
 
 			switch (t_alg->algt.type) {
-			case CRYPTO_ALG_TYPE_SKCIPHER:
-				err = crypto_register_skcipher(
-						&t_alg->algt.alg.skcipher);
-				alg = &t_alg->algt.alg.skcipher.base;
-				break;
-
 			case CRYPTO_ALG_TYPE_AEAD:
 				err = crypto_register_aead(
 					&t_alg->algt.alg.aead);
diff --git a/drivers/crypto/talitos/talitos.h b/drivers/crypto/talitos/talitos.h
index 99584157837a..07cdd6034883 100644
--- a/drivers/crypto/talitos/talitos.h
+++ b/drivers/crypto/talitos/talitos.h
@@ -610,3 +610,4 @@ void talitos_unregister_rng(struct device *dev);
 /* Hash */
 
 int talitos_register_hash(struct device *dev);
+int talitos_register_skcipher(struct device *dev);

-- 
2.55.0

