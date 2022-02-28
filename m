Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 848EDC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 19:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiB1Trd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiB1Tra (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 14:47:30 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD54ECB3B
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:45:48 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id n14so17080932wrq.7
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GHpdtAlTcspTEUjTHGrVm+ax9xkwkOuqMMVc7q/8Ibs=;
        b=2YW+JkjTQeX01R2meYtkCGrn+zWlP+oytmhWUAizCx0a3VTVaM4fsFoSYyIuY/1G6J
         nvpqoLWmvOLAcwz5HRtkBT4tcyPsjp9ExV471Mcf/CEyU6BKgSBO67Vwf/tbls2QwdCs
         9ht/XQlLA9o7zkXhUS7cEXRH+T0jOHtjJI2qF/8ZhvCnpxvvnrYYMrXS8GVzdFvrq5Dx
         09H16ZM8wLlKyR/e2hqVshjKc6Z3R9SWl0e8e6oOjRi0VfmzbkGKFsH0pZTjDtl1b4uR
         3HKLyz/wg3lvt2Dfr+hl0RaPNqIGW5IiALU3UqWwJBM2ramZ68rpEzF9XHXpwWo1V7lX
         9/uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GHpdtAlTcspTEUjTHGrVm+ax9xkwkOuqMMVc7q/8Ibs=;
        b=j2nNUGNe8k7su1IZrYiMZ87KREw+WfxZXke5uiVKhmYhmC6BFsgtIzknBgTpoHkx9Q
         +3PAkR8XFI7J9Bp3W62yuOUVLOMoyxOGrNyH1/66nowJ5+1agiWJTRWV9PsDqfHslnto
         CGZ2xiUyZM+uWX0RBKXQZcjIeuNWVvIWMIo3lF6tjM+9eGXMIFkLbbvBSS795aLcBbBs
         NIVdbrBPznH2sq6XAV6XIujKbe617mn+/ZtzOthHTVq1ZW3vGiq7Kupec715SZWQsuTx
         lazPHw205JrtiSVcZhUPFiYzM3/3ASYsTOEBKWS03tDjM2B+Un84RUBBJKdbRnbxBKij
         RU4A==
X-Gm-Message-State: AOAM533OWmFhdgxDvBLqV0bEvoi0nYOqpsh+YrqCCbAIcynUzFz1XYPW
        iU7Xnn0cNGwxxD5qk4uVVxBMiA==
X-Google-Smtp-Source: ABdhPJw+OJwbkRpsVAU+L7etyv7z0b4JQsL7JkKOZbd4zx9WSOwPsN5rjTqJ/HeVW0ANBo/FPceFsA==
X-Received: by 2002:a5d:678b:0:b0:1ed:9f21:d36 with SMTP id v11-20020a5d678b000000b001ed9f210d36mr17283236wru.550.1646077247270;
        Mon, 28 Feb 2022 11:40:47 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v25-20020a05600c215900b0038117f41728sm274143wml.43.2022.02.28.11.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 11:40:46 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 05/16] crypto: rockchip: do not store mode globally
Date:   Mon, 28 Feb 2022 19:40:26 +0000
Message-Id: <20220228194037.1600509-6-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228194037.1600509-1-clabbe@baylibre.com>
References: <20220228194037.1600509-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Storing the mode globally does not work if 2 requests are handled in the
same time.
We should store it in a request context.

Fixes: ce0183cb6464b ("crypto: rockchip - switch to skcipher API")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.h       |  5 +-
 .../crypto/rockchip/rk3288_crypto_skcipher.c  | 58 ++++++++++++-------
 2 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index 656d6795d400..c919d9a43a08 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -245,10 +245,13 @@ struct rk_ahash_rctx {
 struct rk_cipher_ctx {
 	struct rk_crypto_info		*dev;
 	unsigned int			keylen;
-	u32				mode;
 	u8				iv[AES_BLOCK_SIZE];
 };
 
+struct rk_cipher_rctx {
+	u32				mode;
+};
+
 enum alg_type {
 	ALG_TYPE_HASH,
 	ALG_TYPE_CIPHER,
diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index 8c44a19eab75..bbd0bf52bf07 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -76,9 +76,10 @@ static int rk_aes_ecb_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *dev = ctx->dev;
 
-	ctx->mode = RK_CRYPTO_AES_ECB_MODE;
+	rctx->mode = RK_CRYPTO_AES_ECB_MODE;
 	return rk_handle_req(dev, req);
 }
 
@@ -86,9 +87,10 @@ static int rk_aes_ecb_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *dev = ctx->dev;
 
-	ctx->mode = RK_CRYPTO_AES_ECB_MODE | RK_CRYPTO_DEC;
+	rctx->mode = RK_CRYPTO_AES_ECB_MODE | RK_CRYPTO_DEC;
 	return rk_handle_req(dev, req);
 }
 
@@ -96,9 +98,10 @@ static int rk_aes_cbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *dev = ctx->dev;
 
-	ctx->mode = RK_CRYPTO_AES_CBC_MODE;
+	rctx->mode = RK_CRYPTO_AES_CBC_MODE;
 	return rk_handle_req(dev, req);
 }
 
@@ -106,9 +109,10 @@ static int rk_aes_cbc_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *dev = ctx->dev;
 
-	ctx->mode = RK_CRYPTO_AES_CBC_MODE | RK_CRYPTO_DEC;
+	rctx->mode = RK_CRYPTO_AES_CBC_MODE | RK_CRYPTO_DEC;
 	return rk_handle_req(dev, req);
 }
 
@@ -116,9 +120,10 @@ static int rk_des_ecb_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *dev = ctx->dev;
 
-	ctx->mode = 0;
+	rctx->mode = 0;
 	return rk_handle_req(dev, req);
 }
 
@@ -126,9 +131,10 @@ static int rk_des_ecb_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *dev = ctx->dev;
 
-	ctx->mode = RK_CRYPTO_DEC;
+	rctx->mode = RK_CRYPTO_DEC;
 	return rk_handle_req(dev, req);
 }
 
@@ -136,9 +142,10 @@ static int rk_des_cbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *dev = ctx->dev;
 
-	ctx->mode = RK_CRYPTO_TDES_CHAINMODE_CBC;
+	rctx->mode = RK_CRYPTO_TDES_CHAINMODE_CBC;
 	return rk_handle_req(dev, req);
 }
 
@@ -146,9 +153,10 @@ static int rk_des_cbc_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *dev = ctx->dev;
 
-	ctx->mode = RK_CRYPTO_TDES_CHAINMODE_CBC | RK_CRYPTO_DEC;
+	rctx->mode = RK_CRYPTO_TDES_CHAINMODE_CBC | RK_CRYPTO_DEC;
 	return rk_handle_req(dev, req);
 }
 
@@ -156,9 +164,10 @@ static int rk_des3_ede_ecb_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *dev = ctx->dev;
 
-	ctx->mode = RK_CRYPTO_TDES_SELECT;
+	rctx->mode = RK_CRYPTO_TDES_SELECT;
 	return rk_handle_req(dev, req);
 }
 
@@ -166,9 +175,10 @@ static int rk_des3_ede_ecb_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *dev = ctx->dev;
 
-	ctx->mode = RK_CRYPTO_TDES_SELECT | RK_CRYPTO_DEC;
+	rctx->mode = RK_CRYPTO_TDES_SELECT | RK_CRYPTO_DEC;
 	return rk_handle_req(dev, req);
 }
 
@@ -176,9 +186,10 @@ static int rk_des3_ede_cbc_encrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *dev = ctx->dev;
 
-	ctx->mode = RK_CRYPTO_TDES_SELECT | RK_CRYPTO_TDES_CHAINMODE_CBC;
+	rctx->mode = RK_CRYPTO_TDES_SELECT | RK_CRYPTO_TDES_CHAINMODE_CBC;
 	return rk_handle_req(dev, req);
 }
 
@@ -186,9 +197,10 @@ static int rk_des3_ede_cbc_decrypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_crypto_info *dev = ctx->dev;
 
-	ctx->mode = RK_CRYPTO_TDES_SELECT | RK_CRYPTO_TDES_CHAINMODE_CBC |
+	rctx->mode = RK_CRYPTO_TDES_SELECT | RK_CRYPTO_TDES_CHAINMODE_CBC |
 		    RK_CRYPTO_DEC;
 	return rk_handle_req(dev, req);
 }
@@ -199,6 +211,7 @@ static void rk_ablk_hw_init(struct rk_crypto_info *dev)
 		skcipher_request_cast(dev->async_req);
 	struct crypto_skcipher *cipher = crypto_skcipher_reqtfm(req);
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(cipher);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(cipher);
 	u32 ivsize, block, conf_reg = 0;
 
@@ -206,22 +219,22 @@ static void rk_ablk_hw_init(struct rk_crypto_info *dev)
 	ivsize = crypto_skcipher_ivsize(cipher);
 
 	if (block == DES_BLOCK_SIZE) {
-		ctx->mode |= RK_CRYPTO_TDES_FIFO_MODE |
+		rctx->mode |= RK_CRYPTO_TDES_FIFO_MODE |
 			     RK_CRYPTO_TDES_BYTESWAP_KEY |
 			     RK_CRYPTO_TDES_BYTESWAP_IV;
-		CRYPTO_WRITE(dev, RK_CRYPTO_TDES_CTRL, ctx->mode);
+		CRYPTO_WRITE(dev, RK_CRYPTO_TDES_CTRL, rctx->mode);
 		memcpy_toio(dev->reg + RK_CRYPTO_TDES_IV_0, req->iv, ivsize);
 		conf_reg = RK_CRYPTO_DESSEL;
 	} else {
-		ctx->mode |= RK_CRYPTO_AES_FIFO_MODE |
+		rctx->mode |= RK_CRYPTO_AES_FIFO_MODE |
 			     RK_CRYPTO_AES_KEY_CHANGE |
 			     RK_CRYPTO_AES_BYTESWAP_KEY |
 			     RK_CRYPTO_AES_BYTESWAP_IV;
 		if (ctx->keylen == AES_KEYSIZE_192)
-			ctx->mode |= RK_CRYPTO_AES_192BIT_key;
+			rctx->mode |= RK_CRYPTO_AES_192BIT_key;
 		else if (ctx->keylen == AES_KEYSIZE_256)
-			ctx->mode |= RK_CRYPTO_AES_256BIT_key;
-		CRYPTO_WRITE(dev, RK_CRYPTO_AES_CTRL, ctx->mode);
+			rctx->mode |= RK_CRYPTO_AES_256BIT_key;
+		CRYPTO_WRITE(dev, RK_CRYPTO_AES_CTRL, rctx->mode);
 		memcpy_toio(dev->reg + RK_CRYPTO_AES_IV_0, req->iv, ivsize);
 	}
 	conf_reg |= RK_CRYPTO_BYTESWAP_BTFIFO |
@@ -246,6 +259,7 @@ static int rk_set_data_start(struct rk_crypto_info *dev)
 	struct skcipher_request *req =
 		skcipher_request_cast(dev->async_req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	u32 ivsize = crypto_skcipher_ivsize(tfm);
 	u8 *src_last_blk = page_address(sg_page(dev->sg_src)) +
@@ -254,7 +268,7 @@ static int rk_set_data_start(struct rk_crypto_info *dev)
 	/* Store the iv that need to be updated in chain mode.
 	 * And update the IV buffer to contain the next IV for decryption mode.
 	 */
-	if (ctx->mode & RK_CRYPTO_DEC) {
+	if (rctx->mode & RK_CRYPTO_DEC) {
 		memcpy(ctx->iv, src_last_blk, ivsize);
 		sg_pcopy_to_buffer(dev->first, dev->src_nents, req->iv,
 				   ivsize, dev->total - ivsize);
@@ -294,11 +308,12 @@ static void rk_iv_copyback(struct rk_crypto_info *dev)
 	struct skcipher_request *req =
 		skcipher_request_cast(dev->async_req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	u32 ivsize = crypto_skcipher_ivsize(tfm);
 
 	/* Update the IV buffer to contain the next IV for encryption mode. */
-	if (!(ctx->mode & RK_CRYPTO_DEC)) {
+	if (!(rctx->mode & RK_CRYPTO_DEC)) {
 		if (dev->aligned) {
 			memcpy(req->iv, sg_virt(dev->sg_dst) +
 				dev->sg_dst->length - ivsize, ivsize);
@@ -314,11 +329,12 @@ static void rk_update_iv(struct rk_crypto_info *dev)
 	struct skcipher_request *req =
 		skcipher_request_cast(dev->async_req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct rk_cipher_rctx *rctx = skcipher_request_ctx(req);
 	struct rk_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	u32 ivsize = crypto_skcipher_ivsize(tfm);
 	u8 *new_iv = NULL;
 
-	if (ctx->mode & RK_CRYPTO_DEC) {
+	if (rctx->mode & RK_CRYPTO_DEC) {
 		new_iv = ctx->iv;
 	} else {
 		new_iv = page_address(sg_page(dev->sg_dst)) +
-- 
2.34.1

