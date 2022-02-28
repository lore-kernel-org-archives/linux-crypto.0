Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A09F8C4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 19:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiB1TsC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiB1Trq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 14:47:46 -0500
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1C162017EF
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:45:56 -0800 (PST)
Received: by mail-wm1-f52.google.com with SMTP id c18-20020a7bc852000000b003806ce86c6dso46772wml.5
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F29NhyhRGwZzMFTx8mQRXilZvucaQuN0j6i5TN7/b3I=;
        b=VQXUifG0yVtXpgJZZlDW91n8TBcQ1Gf9UgRoho0rrVVplb120K1t18s+NcwxGoAbNz
         Xe55meGo81BEee65Kzi+Ql5BTOQd+Lx8hvBQyv8mfzgPGBC6goTuMfWnxWPjAEmdbV7D
         n4fUJsNoy8SMxorYJ6sL2nUqVxgWgonj9Z3ak1OSQRVHDKVq+C9zIDhbDvwPDqhs3YgF
         TC1vG5JC1w5xlf4g2v8W/jb0tM8pTHGQqjvaVpGtdLPN0f2AMpt4i6xd3uKuFge1K3YC
         4ZlnVWEoQtavNghlofYcHOP6GcwdoBZuvp6AEf9yUGkOq9djs7YQoY4loIxHSxZoEDsN
         96lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F29NhyhRGwZzMFTx8mQRXilZvucaQuN0j6i5TN7/b3I=;
        b=fnbW2KNjK4dR/ZzfttBOKJTGdPmBZr1wE6wMwRACHHgHq4ws7KE1YZ7eyEsGbUeiFq
         p/B00YG6iiBGnfCTPBu4nKX6tdtuzDUssruPIz5EQLnjVBZ76T4jdNXudJXLFZxtaLwd
         JAyDLRmoDVkLmDGVzunbQKUJlaqSKSXJHkN7nD5PfHKi2W/16b/3I5BwHx2eXt+I3t1c
         ym8R6JifDX4+4CbuOVv1GbQctbLMkpTDI1qioz/gW/cxgNwYf/BLcTjn9u8QNAlx9174
         lF/L2ts/UcX62Z3BQdY+lkZ6n3XQ2SLoXaXcu/1d4++0G8W49lBCDBBxkGyi+MAIN4+P
         VnzA==
X-Gm-Message-State: AOAM530tRH/iVj1FSAdvP/pR294kj8hjZwJHJTLpvMUPGhOSIXxijSpT
        0X1hqnqtNkbJonreSayKqeGviA==
X-Google-Smtp-Source: ABdhPJw3awcmd3PzDK6cgXM+7gY5JHwNU8oy961e1ncnFg6bhv5kCTrmL0gcmLKYifc0TFgTTF0RLw==
X-Received: by 2002:a05:600c:297:b0:381:41d3:e22f with SMTP id 23-20020a05600c029700b0038141d3e22fmr11662361wmk.108.1646077249449;
        Mon, 28 Feb 2022 11:40:49 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v25-20020a05600c215900b0038117f41728sm274143wml.43.2022.02.28.11.40.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 11:40:49 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 08/16] crypto: rockchip: better handle cipher key
Date:   Mon, 28 Feb 2022 19:40:29 +0000
Message-Id: <20220228194037.1600509-9-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228194037.1600509-1-clabbe@baylibre.com>
References: <20220228194037.1600509-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The key should not be set in hardware too much in advance, this will
fail it 2 TFM with different keys generate alternative requests.
The key should be stored and used just before doing cipher operations.

Fixes: ce0183cb6464b ("crypto: rockchip - switch to skcipher API")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.h          | 1 +
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c | 9 ++++++---
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index 8b1e15d8ddc6..826508e4a0c3 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -245,6 +245,7 @@ struct rk_ahash_rctx {
 struct rk_cipher_ctx {
 	struct rk_crypto_info		*dev;
 	unsigned int			keylen;
+	u32 key[AES_MAX_KEY_SIZE / 4];
 	u8				iv[AES_BLOCK_SIZE];
 	struct crypto_skcipher *fallback_tfm;
 };
diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index 060d52f18b31..cc817d361fda 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -95,7 +95,7 @@ static int rk_aes_setkey(struct crypto_skcipher *cipher,
 	    keylen != AES_KEYSIZE_256)
 		return -EINVAL;
 	ctx->keylen = keylen;
-	memcpy_toio(ctx->dev->reg + RK_CRYPTO_AES_KEY_0, key, keylen);
+	memcpy(ctx->key, key, keylen);
 
 	return crypto_skcipher_setkey(ctx->fallback_tfm, key, keylen);
 }
@@ -111,7 +111,7 @@ static int rk_des_setkey(struct crypto_skcipher *cipher,
 		return err;
 
 	ctx->keylen = keylen;
-	memcpy_toio(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, key, keylen);
+	memcpy(ctx->key, key, keylen);
 
 	return crypto_skcipher_setkey(ctx->fallback_tfm, key, keylen);
 }
@@ -127,7 +127,8 @@ static int rk_tdes_setkey(struct crypto_skcipher *cipher,
 		return err;
 
 	ctx->keylen = keylen;
-	memcpy_toio(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, key, keylen);
+	memcpy(ctx->key, key, keylen);
+
 	return crypto_skcipher_setkey(ctx->fallback_tfm, key, keylen);
 }
 
@@ -283,6 +284,7 @@ static void rk_ablk_hw_init(struct rk_crypto_info *dev)
 			     RK_CRYPTO_TDES_BYTESWAP_IV;
 		CRYPTO_WRITE(dev, RK_CRYPTO_TDES_CTRL, rctx->mode);
 		memcpy_toio(dev->reg + RK_CRYPTO_TDES_IV_0, req->iv, ivsize);
+		memcpy_toio(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, ctx->key, ctx->keylen);
 		conf_reg = RK_CRYPTO_DESSEL;
 	} else {
 		rctx->mode |= RK_CRYPTO_AES_FIFO_MODE |
@@ -295,6 +297,7 @@ static void rk_ablk_hw_init(struct rk_crypto_info *dev)
 			rctx->mode |= RK_CRYPTO_AES_256BIT_key;
 		CRYPTO_WRITE(dev, RK_CRYPTO_AES_CTRL, rctx->mode);
 		memcpy_toio(dev->reg + RK_CRYPTO_AES_IV_0, req->iv, ivsize);
+		memcpy_toio(ctx->dev->reg + RK_CRYPTO_AES_KEY_0, ctx->key, ctx->keylen);
 	}
 	conf_reg |= RK_CRYPTO_BYTESWAP_BTFIFO |
 		    RK_CRYPTO_BYTESWAP_BRFIFO;
-- 
2.34.1

