Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5BC1C43460
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C95613D6
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 20:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235421AbhEEU1n (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 16:27:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235434AbhEEU1c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 16:27:32 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB633C06174A
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 13:26:33 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n84so2181136wma.0
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 13:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fXYl2Kd9Z6DQd+07hwt5I3DejWQEV84aSXZywdSKmBg=;
        b=gQwq39oS6hiFY8oCq851HXtNpZypSZVJ8gFMcTbUbVPYtJAh888yMkV2QWPTtn5bpV
         JfGNOSS06+ggZrmcvIM7RXycCFkDUkx6fi5tfNvAjN7eSl9Jsof+tVxVSyWVWVTPq/BJ
         QVXusoJK5qVqDGxkz15LRFUHu+eDjHSK4eZyklRF+tHvSXP8rxnP+EzEy8nE/yHVZ9Cp
         ba1nPjfTV/xzb/2hkdzWr8SqsA9yB2kAhoQ+NiN03TM4mL9Gsd2OkYa0kuPiIKfbu1Cy
         J2MxyQd2YudzAXStRG4aaoDf+/ysQsB+JVQLvn2gDPobWkPdoWLX1QDw9uIHqoiACVCe
         dt0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fXYl2Kd9Z6DQd+07hwt5I3DejWQEV84aSXZywdSKmBg=;
        b=GmTGzA5DcVnCFvg0/oZcvOB8k/40r8ISgrGrIDnembPckQU0fsgagUESl+3NBcLltB
         KVs5AQKw32OTSz3YGQ4SbosqSHzHh/iTikcMVyJtIwde+bLIUyvZCLj/UVZbfsSKPTGR
         aDTBWXrrhtkmTUzjr/La/lproXe4L0IUfktZvSLEIXRsbGXN4kThSfRv29HoloNLLLdK
         de8je2/vb+bOP1Och9fiBMrwyB0eNYdC1+XSQFHc8MBDrc+Rp/lyESbAtQp9Ubzby9c8
         FxK09lCmdIWNjnPBjkjsJ+zpV1GXGWUtpSWituBEL2IWhxFswPc93GKDW552B8oeKQUL
         HgEA==
X-Gm-Message-State: AOAM530yPa2U8/v3JitFGfhnBnxYqLZ+XSwIgQuvgLlaV32+NVnpFxVF
        KwkYg8bfWkitg7d993BgDrFn1g==
X-Google-Smtp-Source: ABdhPJxYOjVF2q+jc2hsn/yko6RJPWYwLB+DbB/5M0S2mjv83OOsGwHbZ3doiTE9fozjnpqAepUPMA==
X-Received: by 2002:a7b:c303:: with SMTP id k3mr558273wmj.100.1620246392503;
        Wed, 05 May 2021 13:26:32 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id a15sm497245wrr.53.2021.05.05.13.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 13:26:32 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     chohnstaedt@innominate.com, davem@davemloft.net,
        herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 09/11] crypto: ixp4xx: Correct functions alignment
Date:   Wed,  5 May 2021 20:26:16 +0000
Message-Id: <20210505202618.2663889-10-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210505202618.2663889-1-clabbe@baylibre.com>
References: <20210505202618.2663889-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch fixes all alignment issues reported by checkpatch.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/ixp4xx_crypto.c | 65 ++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 03ae9c3a8d97..b38650b0fea1 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -354,8 +354,8 @@ static void finish_scattered_hmac(struct crypt_ctl *crypt)
 	int decryptlen = req->assoclen + req->cryptlen - authsize;
 
 	if (req_ctx->encrypt) {
-		scatterwalk_map_and_copy(req_ctx->hmac_virt,
-			req->dst, decryptlen, authsize, 1);
+		scatterwalk_map_and_copy(req_ctx->hmac_virt, req->dst,
+					 decryptlen, authsize, 1);
 	}
 	dma_pool_free(buffer_pool, req_ctx->hmac_virt, crypt->icv_rev_aes);
 }
@@ -412,7 +412,7 @@ static void one_packet(dma_addr_t phys)
 	case CTL_FLAG_GEN_ICV:
 		ctx = crypto_tfm_ctx(crypt->data.tfm);
 		dma_pool_free(ctx_pool, crypt->regist_ptr,
-				crypt->regist_buf->phys_addr);
+			      crypt->regist_buf->phys_addr);
 		dma_pool_free(buffer_pool, crypt->regist_buf, crypt->src_buf);
 		if (atomic_dec_and_test(&ctx->configuring))
 			complete(&ctx->completion);
@@ -494,14 +494,13 @@ static int init_ixp_crypto(struct device *dev)
 	 * so assure it is large enough
 	 */
 	BUILD_BUG_ON(SHA1_DIGEST_SIZE > sizeof(struct buffer_desc));
-	buffer_pool = dma_pool_create("buffer", dev,
-			sizeof(struct buffer_desc), 32, 0);
+	buffer_pool = dma_pool_create("buffer", dev, sizeof(struct buffer_desc),
+				      32, 0);
 	ret = -ENOMEM;
 	if (!buffer_pool)
 		goto err;
 
-	ctx_pool = dma_pool_create("context", dev,
-			NPE_CTX_LEN, 16, 0);
+	ctx_pool = dma_pool_create("context", dev, NPE_CTX_LEN, 16, 0);
 	if (!ctx_pool)
 		goto err;
 
@@ -546,9 +545,8 @@ static void release_ixp_crypto(struct device *dev)
 	npe_release(npe_c);
 
 	if (crypt_virt)
-		dma_free_coherent(dev,
-			NPE_QLEN * sizeof(struct crypt_ctl),
-			crypt_virt, crypt_phys);
+		dma_free_coherent(dev, NPE_QLEN * sizeof(struct crypt_ctl),
+				  crypt_virt, crypt_phys);
 }
 
 static void reset_sa_dir(struct ix_sa_dir *dir)
@@ -641,7 +639,8 @@ static void exit_tfm_aead(struct crypto_aead *tfm)
 }
 
 static int register_chain_var(struct crypto_tfm *tfm, u8 xpad, u32 target,
-		int init_len, u32 ctx_addr, const u8 *key, int key_len)
+			      int init_len, u32 ctx_addr, const u8 *key,
+			      int key_len)
 {
 	struct ixp_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct crypt_ctl *crypt;
@@ -735,11 +734,11 @@ static int setup_auth(struct crypto_tfm *tfm, int encrypt, unsigned int authsize
 		dir->npe_mode |= NPE_OP_HASH_VERIFY;
 
 	ret = register_chain_var(tfm, HMAC_OPAD_VALUE, otarget,
-			init_len, npe_ctx_addr, key, key_len);
+				 init_len, npe_ctx_addr, key, key_len);
 	if (ret)
 		return ret;
 	return register_chain_var(tfm, HMAC_IPAD_VALUE, itarget,
-			init_len, npe_ctx_addr, key, key_len);
+				  init_len, npe_ctx_addr, key, key_len);
 }
 
 static int gen_rev_aes_key(struct crypto_tfm *tfm)
@@ -770,8 +769,8 @@ static int gen_rev_aes_key(struct crypto_tfm *tfm)
 	return 0;
 }
 
-static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
-		const u8 *key, int key_len)
+static int setup_cipher(struct crypto_tfm *tfm, int encrypt, const u8 *key,
+			int key_len)
 {
 	u8 *cinfo;
 	u32 cipher_cfg;
@@ -791,9 +790,15 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
 	}
 	if (cipher_cfg & MOD_AES) {
 		switch (key_len) {
-		case 16: keylen_cfg = MOD_AES128; break;
-		case 24: keylen_cfg = MOD_AES192; break;
-		case 32: keylen_cfg = MOD_AES256; break;
+		case 16:
+			keylen_cfg = MOD_AES128;
+			break;
+		case 24:
+			keylen_cfg = MOD_AES192;
+			break;
+		case 32:
+			keylen_cfg = MOD_AES256;
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -855,7 +860,7 @@ static struct buffer_desc *chainup_buffers(struct device *dev,
 }
 
 static int ablk_setkey(struct crypto_skcipher *tfm, const u8 *key,
-			unsigned int key_len)
+		       unsigned int key_len)
 {
 	struct ixp_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int ret;
@@ -892,7 +897,7 @@ static int ablk_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 }
 
 static int ablk_rfc3686_setkey(struct crypto_skcipher *tfm, const u8 *key,
-		unsigned int key_len)
+			       unsigned int key_len)
 {
 	struct ixp_ctx *ctx = crypto_skcipher_ctx(tfm);
 
@@ -901,7 +906,7 @@ static int ablk_rfc3686_setkey(struct crypto_skcipher *tfm, const u8 *key,
 		return -EINVAL;
 
 	memcpy(ctx->nonce, key + (key_len - CTR_RFC3686_NONCE_SIZE),
-			CTR_RFC3686_NONCE_SIZE);
+	       CTR_RFC3686_NONCE_SIZE);
 
 	key_len -= CTR_RFC3686_NONCE_SIZE;
 	return ablk_setkey(tfm, key, key_len);
@@ -979,7 +984,7 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 		 * for more than one dst buffer, I think. */
 		req_ctx->dst = NULL;
 		if (!chainup_buffers(dev, req->dst, nbytes, &dst_hook,
-					flags, DMA_FROM_DEVICE))
+				     flags, DMA_FROM_DEVICE))
 			goto free_buf_dest;
 		src_direction = DMA_TO_DEVICE;
 		req_ctx->dst = dst_hook.next;
@@ -988,8 +993,8 @@ static int ablk_perform(struct skcipher_request *req, int encrypt)
 		req_ctx->dst = NULL;
 	}
 	req_ctx->src = NULL;
-	if (!chainup_buffers(dev, req->src, nbytes, &src_hook,
-				flags, src_direction))
+	if (!chainup_buffers(dev, req->src, nbytes, &src_hook, flags,
+			     src_direction))
 		goto free_buf_src;
 
 	req_ctx->src = src_hook.next;
@@ -1042,7 +1047,7 @@ static int ablk_rfc3686_crypt(struct skcipher_request *req)
 }
 
 static int aead_perform(struct aead_request *req, int encrypt,
-		int cryptoffset, int eff_cryptlen, u8 *iv)
+			int cryptoffset, int eff_cryptlen, u8 *iv)
 {
 	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
 	struct ixp_ctx *ctx = crypto_aead_ctx(tfm);
@@ -1130,12 +1135,12 @@ static int aead_perform(struct aead_request *req, int encrypt,
 		/* The 12 hmac bytes are scattered,
 		 * we need to copy them into a safe buffer */
 		req_ctx->hmac_virt = dma_pool_alloc(buffer_pool, flags,
-				&crypt->icv_rev_aes);
+						    &crypt->icv_rev_aes);
 		if (unlikely(!req_ctx->hmac_virt))
 			goto free_buf_dst;
 		if (!encrypt) {
 			scatterwalk_map_and_copy(req_ctx->hmac_virt,
-				req->src, cryptlen, authsize, 0);
+						 req->src, cryptlen, authsize, 0);
 		}
 		req_ctx->encrypt = encrypt;
 	} else {
@@ -1176,11 +1181,11 @@ static int aead_setup(struct crypto_aead *tfm, unsigned int authsize)
 	if (ret)
 		goto out;
 	ret = setup_auth(&tfm->base, 0, authsize, ctx->authkey,
-			ctx->authkey_len, digest_len);
+			 ctx->authkey_len, digest_len);
 	if (ret)
 		goto out;
 	ret = setup_auth(&tfm->base, 1, authsize,  ctx->authkey,
-			ctx->authkey_len, digest_len);
+			 ctx->authkey_len, digest_len);
 out:
 	if (!atomic_dec_and_test(&ctx->configuring))
 		wait_for_completion(&ctx->completion);
@@ -1197,7 +1202,7 @@ static int aead_setauthsize(struct crypto_aead *tfm, unsigned int authsize)
 }
 
 static int aead_setkey(struct crypto_aead *tfm, const u8 *key,
-			unsigned int keylen)
+		       unsigned int keylen)
 {
 	struct ixp_ctx *ctx = crypto_aead_ctx(tfm);
 	struct crypto_authenc_keys keys;
-- 
2.26.3

