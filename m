Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA82C433DF
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 09:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB1E124896
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 09:08:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729637AbgFUJID (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 05:08:03 -0400
Received: from foss.arm.com ([217.140.110.172]:47906 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727119AbgFUJIC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 05:08:02 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DED14101E;
        Sun, 21 Jun 2020 02:08:00 -0700 (PDT)
Received: from e110176-lin.arm.com (E113494.Arm.com [10.50.66.186])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F11103F6CF;
        Sun, 21 Jun 2020 02:07:58 -0700 (PDT)
From:   Gilad Ben-Yossef <gilad@benyossef.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Libo Wang <libo.wang@arm.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] crypto: ccree: adapt ccree essiv supprot to kcapi
Date:   Sun, 21 Jun 2020 12:07:47 +0300
Message-Id: <20200621090748.18464-3-gilad@benyossef.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200621090748.18464-1-gilad@benyossef.com>
References: <20200621090748.18464-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ESSIV support in ccree was added before the kernel
generic support and using a slightly different API.

This patch brings the ccree essiv interface into
compliance with kernel crypto api one.

Since CryptoCell only support 256 bit AES key for ESSIV,
also use a fallback if requested a smaller key size.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Libo Wang <libo.wang@arm.com>
---
 drivers/crypto/ccree/cc_cipher.c | 124 +++++++++++++++++++++++--------
 1 file changed, 93 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index e61f35ca9945..6575e216262b 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -60,6 +60,8 @@ struct cc_cipher_ctx {
 		struct cc_cpp_key_info cpp;
 	};
 	struct crypto_shash *shash_tfm;
+	struct crypto_skcipher *fallback_tfm;
+	bool fallback_on;
 };
 
 static void cc_cipher_complete(struct device *dev, void *cc_req, int err);
@@ -79,7 +81,6 @@ static int validate_keys_sizes(struct cc_cipher_ctx *ctx_p, u32 size)
 		case CC_AES_128_BIT_KEY_SIZE:
 		case CC_AES_192_BIT_KEY_SIZE:
 			if (ctx_p->cipher_mode != DRV_CIPHER_XTS &&
-			    ctx_p->cipher_mode != DRV_CIPHER_ESSIV &&
 			    ctx_p->cipher_mode != DRV_CIPHER_BITLOCKER)
 				return 0;
 			break;
@@ -163,30 +164,49 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 				     skcipher_alg.base);
 	struct device *dev = drvdata_to_dev(cc_alg->drvdata);
 	unsigned int max_key_buf_size = cc_alg->skcipher_alg.max_keysize;
+	unsigned int fallback_req_size = 0;
 
 	dev_dbg(dev, "Initializing context @%p for %s\n", ctx_p,
 		crypto_tfm_alg_name(tfm));
 
-	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
-				    sizeof(struct cipher_req_ctx));
-
 	ctx_p->cipher_mode = cc_alg->cipher_mode;
 	ctx_p->flow_mode = cc_alg->flow_mode;
 	ctx_p->drvdata = cc_alg->drvdata;
 
 	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+		const char *name = crypto_tfm_alg_name(tfm);
+
 		/* Alloc hash tfm for essiv */
-		ctx_p->shash_tfm = crypto_alloc_shash("sha256-generic", 0, 0);
+		ctx_p->shash_tfm = crypto_alloc_shash("sha256", 0, 0);
 		if (IS_ERR(ctx_p->shash_tfm)) {
 			dev_err(dev, "Error allocating hash tfm for ESSIV.\n");
 			return PTR_ERR(ctx_p->shash_tfm);
 		}
+		max_key_buf_size <<= 1;
+
+		/* Alloc fallabck tfm or essiv when key size != 256 bit */
+		ctx_p->fallback_tfm =
+			crypto_alloc_skcipher(name, 0, CRYPTO_ALG_NEED_FALLBACK | CRYPTO_ALG_ASYNC);
+
+		if (IS_ERR(ctx_p->fallback_tfm)) {
+			/* Note we're still allowing registration with no fallback since it's
+			 * better to have most modes supported than none at all.
+			 */
+			dev_warn(dev, "Error allocating fallback algo %s. Some modes may be available.\n",
+			       name);
+			ctx_p->fallback_tfm = NULL;
+		} else {
+			fallback_req_size = crypto_skcipher_reqsize(ctx_p->fallback_tfm);
+		}
 	}
 
+	crypto_skcipher_set_reqsize(__crypto_skcipher_cast(tfm),
+				    sizeof(struct cipher_req_ctx) + fallback_req_size);
+
 	/* Allocate key buffer, cache line aligned */
-	ctx_p->user.key = kmalloc(max_key_buf_size, GFP_KERNEL);
+	ctx_p->user.key = kzalloc(max_key_buf_size, GFP_KERNEL);
 	if (!ctx_p->user.key)
-		goto out_shash;
+		goto out_fallback;
 
 	dev_dbg(dev, "Allocated key buffer in context. key=@%p\n",
 		ctx_p->user.key);
@@ -207,7 +227,8 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
 
 out_key:
 	kfree(ctx_p->user.key);
-out_shash:
+out_fallback:
+	crypto_free_skcipher(ctx_p->fallback_tfm);
 	crypto_free_shash(ctx_p->shash_tfm);
 
 	return -ENOMEM;
@@ -230,6 +251,8 @@ static void cc_cipher_exit(struct crypto_tfm *tfm)
 		/* Free hash tfm for essiv */
 		crypto_free_shash(ctx_p->shash_tfm);
 		ctx_p->shash_tfm = NULL;
+		crypto_free_skcipher(ctx_p->fallback_tfm);
+		ctx_p->fallback_tfm = NULL;
 	}
 
 	/* Unmap key buffer */
@@ -313,6 +336,7 @@ static int cc_cipher_sethkey(struct crypto_skcipher *sktfm, const u8 *key,
 	}
 
 	ctx_p->keylen = keylen;
+	ctx_p->fallback_on = false;
 
 	switch (cc_slot_to_key_type(hki.hw_key1)) {
 	case CC_HW_PROTECTED_KEY:
@@ -398,10 +422,33 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 	/* STAT_PHASE_0: Init and sanity checks */
 
 	if (validate_keys_sizes(ctx_p, keylen)) {
-		dev_dbg(dev, "Unsupported key size %d.\n", keylen);
+		dev_dbg(dev, "Invalid key size %d.\n", keylen);
 		return -EINVAL;
 	}
 
+	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
+
+		/* We only support 256 bit ESSIV-CBC-AES keys */
+		if (keylen != AES_KEYSIZE_256)  {
+			unsigned int flags = crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_MASK;
+
+			if (likely(ctx_p->fallback_tfm)) {
+				ctx_p->fallback_on = true;
+				crypto_skcipher_clear_flags(ctx_p->fallback_tfm,
+							    CRYPTO_TFM_REQ_MASK);
+				crypto_skcipher_clear_flags(ctx_p->fallback_tfm, flags);
+				return crypto_skcipher_setkey(ctx_p->fallback_tfm, key, keylen);
+			}
+
+			dev_dbg(dev, "Unsupported key size %d and no fallback.\n", keylen);
+			return -EINVAL;
+		}
+
+		/* Internal ESSIV key buffer is double sized */
+		max_key_buf_size <<= 1;
+	}
+
+	ctx_p->fallback_on = false;
 	ctx_p->key_type = CC_UNPROTECTED_KEY;
 
 	/*
@@ -429,24 +476,23 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 				max_key_buf_size, DMA_TO_DEVICE);
 
 	memcpy(ctx_p->user.key, key, keylen);
-	if (keylen == 24)
-		memset(ctx_p->user.key + 24, 0, CC_AES_KEY_SIZE_MAX - 24);
 
 	if (ctx_p->cipher_mode == DRV_CIPHER_ESSIV) {
 		/* sha256 for key2 - use sw implementation */
-		int key_len = keylen >> 1;
 		int err;
 
 		SHASH_DESC_ON_STACK(desc, ctx_p->shash_tfm);
 
 		desc->tfm = ctx_p->shash_tfm;
 
-		err = crypto_shash_digest(desc, ctx_p->user.key, key_len,
-					  ctx_p->user.key + key_len);
+		err = crypto_shash_digest(desc, ctx_p->user.key, keylen,
+					  ctx_p->user.key + keylen);
 		if (err) {
 			dev_err(dev, "Failed to hash ESSIV key.\n");
 			return err;
 		}
+
+		keylen <<= 1;
 	}
 	dma_sync_single_for_device(dev, ctx_p->user.key_dma_addr,
 				   max_key_buf_size, DMA_TO_DEVICE);
@@ -584,9 +630,10 @@ static void cc_setup_xex_state_desc(struct crypto_tfm *tfm,
 	int flow_mode = ctx_p->flow_mode;
 	int direction = req_ctx->gen_ctx.op_type;
 	dma_addr_t key_dma_addr = ctx_p->user.key_dma_addr;
-	unsigned int key_len = ctx_p->keylen;
+	unsigned int key_len = (ctx_p->keylen / 2);
 	dma_addr_t iv_dma_addr = req_ctx->gen_ctx.iv_dma_addr;
 	unsigned int du_size = nbytes;
+	unsigned int key_offset = key_len;
 
 	struct cc_crypto_alg *cc_alg =
 		container_of(tfm->__crt_alg, struct cc_crypto_alg,
@@ -606,6 +653,10 @@ static void cc_setup_xex_state_desc(struct crypto_tfm *tfm,
 	case DRV_CIPHER_XTS:
 	case DRV_CIPHER_ESSIV:
 	case DRV_CIPHER_BITLOCKER:
+
+		if (cipher_mode == DRV_CIPHER_ESSIV)
+			key_len = SHA256_DIGEST_SIZE;
+
 		/* load XEX key */
 		hw_desc_init(&desc[*seq_size]);
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
@@ -615,12 +666,12 @@ static void cc_setup_xex_state_desc(struct crypto_tfm *tfm,
 					  ctx_p->hw.key2_slot);
 		} else {
 			set_din_type(&desc[*seq_size], DMA_DLLI,
-				     (key_dma_addr + (key_len / 2)),
-				     (key_len / 2), NS_BIT);
+				     (key_dma_addr + key_offset),
+				     key_len, NS_BIT);
 		}
 		set_xex_data_unit_size(&desc[*seq_size], du_size);
 		set_flow_mode(&desc[*seq_size], S_DIN_to_AES2);
-		set_key_size_aes(&desc[*seq_size], (key_len / 2));
+		set_key_size_aes(&desc[*seq_size], key_len);
 		set_setup_mode(&desc[*seq_size], SETUP_LOAD_XEX_KEY);
 		(*seq_size)++;
 
@@ -629,7 +680,7 @@ static void cc_setup_xex_state_desc(struct crypto_tfm *tfm,
 		set_setup_mode(&desc[*seq_size], SETUP_LOAD_STATE1);
 		set_cipher_mode(&desc[*seq_size], cipher_mode);
 		set_cipher_config0(&desc[*seq_size], direction);
-		set_key_size_aes(&desc[*seq_size], (key_len / 2));
+		set_key_size_aes(&desc[*seq_size], key_len);
 		set_flow_mode(&desc[*seq_size], flow_mode);
 		set_din_type(&desc[*seq_size], DMA_DLLI, iv_dma_addr,
 			     CC_AES_BLOCK_SIZE, NS_BIT);
@@ -880,6 +931,17 @@ static int cc_cipher_process(struct skcipher_request *req,
 		goto exit_process;
 	}
 
+	if (ctx_p->fallback_on) {
+		struct skcipher_request *subreq = skcipher_request_ctx(req);
+
+		*subreq = *req;
+		skcipher_request_set_tfm(subreq, ctx_p->fallback_tfm);
+		if (direction == DRV_CRYPTO_DIRECTION_ENCRYPT)
+			return crypto_skcipher_encrypt(subreq);
+		else
+			return crypto_skcipher_decrypt(subreq);
+	}
+
 	/* The IV we are handed may be allocted from the stack so
 	 * we must copy it to a DMAable buffer before use.
 	 */
@@ -1023,7 +1085,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.sec_func = true,
 	},
 	{
-		.name = "essiv(paes)",
+		.name = "essiv(cbc(paes),sha256)",
 		.driver_name = "essiv-paes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
 		.template_skcipher = {
@@ -1041,7 +1103,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.sec_func = true,
 	},
 	{
-		.name = "essiv512(paes)",
+		.name = "essiv512(cbc(paes),sha256)",
 		.driver_name = "essiv-paes-du512-ccree",
 		.blocksize = AES_BLOCK_SIZE,
 		.template_skcipher = {
@@ -1060,7 +1122,7 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.sec_func = true,
 	},
 	{
-		.name = "essiv4096(paes)",
+		.name = "essiv4096(cbc(paes),sha256)",
 		.driver_name = "essiv-paes-du4096-ccree",
 		.blocksize = AES_BLOCK_SIZE,
 		.template_skcipher = {
@@ -1282,15 +1344,15 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.std_body = CC_STD_NIST,
 	},
 	{
-		.name = "essiv(aes)",
+		.name = "essiv(cbc(aes),sha256)",
 		.driver_name = "essiv-aes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
 			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
 			},
 		.cipher_mode = DRV_CIPHER_ESSIV,
@@ -1299,15 +1361,15 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.std_body = CC_STD_NIST,
 	},
 	{
-		.name = "essiv512(aes)",
+		.name = "essiv512(cbc(aes),sha256)",
 		.driver_name = "essiv-aes-du512-ccree",
 		.blocksize = AES_BLOCK_SIZE,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
 			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
 			},
 		.cipher_mode = DRV_CIPHER_ESSIV,
@@ -1317,15 +1379,15 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.std_body = CC_STD_NIST,
 	},
 	{
-		.name = "essiv4096(aes)",
+		.name = "essiv4096(cbc(aes),sha256)",
 		.driver_name = "essiv-aes-du4096-ccree",
 		.blocksize = AES_BLOCK_SIZE,
 		.template_skcipher = {
 			.setkey = cc_cipher_setkey,
 			.encrypt = cc_cipher_encrypt,
 			.decrypt = cc_cipher_decrypt,
-			.min_keysize = AES_MIN_KEY_SIZE * 2,
-			.max_keysize = AES_MAX_KEY_SIZE * 2,
+			.min_keysize = AES_MIN_KEY_SIZE,
+			.max_keysize = AES_MAX_KEY_SIZE,
 			.ivsize = AES_BLOCK_SIZE,
 			},
 		.cipher_mode = DRV_CIPHER_ESSIV,
-- 
2.27.0

