Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4DEC0502C
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Sep 2022 12:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233936AbiIAM7d (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 08:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233941AbiIAM6l (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 08:58:41 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 242D085AB7
        for <linux-crypto@vger.kernel.org>; Thu,  1 Sep 2022 05:57:40 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id k9so22290328wri.0
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2022 05:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=0KerGvUzdejWLAwshDyy9ppWCWrJnFuYbHleK5z5lUU=;
        b=51+egLLpPXGqBQOou9kHJKjXpvhQkpryEmXh2BCvRqlzLpuXL/Zd3GcbARJ0i+nqdD
         3Lqgzn9JbK2oVDhvQbuTt5DYfeZen0iVNiBTV3MSfrjrhzPUItwreSb6pmxvh7cOpNUS
         5w8zFlBIR29WnGISr31Z6m9Xmp56jB+R1vkMA2PhW++qR+0IKMGVk9IKByvzGqxNDKKS
         i3gyDDxlx87Bt/w+C2c5W7JGa4l0jWuB10PIufcyz0F1BLIC5PvxcXlI3Ve46Pc2VcIc
         jGerwHQhmvEOaFvNN1xvwiK0b0E1p+HzSreF0uwbUztghU/oGOp7NkJFomn2XfxZPK47
         ueww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=0KerGvUzdejWLAwshDyy9ppWCWrJnFuYbHleK5z5lUU=;
        b=Skxs2Nj9kDez2UsVJ/Qmdk8yqx5bnASw6yWT37C43Guyr7Qv1LZye0L+KxnY00aQv8
         8Q/Go5miwLP96cxbhPe0plTWaLlFBfgE5YUNI2nTVJcVyiblLDp1E6xaXdK1hUaYvbWf
         tN+8QbRsW/hLay55GBK+NRCdrMfmUmbSdXD5pO999xQuFwwZLPzDtx2v0Q8WOpbGbwXf
         ysQUGwB7GurmtpU1fJjmYH9ibkLlKlY9YDGvauMRFHHMAMo/60q8LB/Fb64L2ybU6B7Z
         fLl1F20c6Qxwm8IPJN19wHuKoOO+7THjl8nM1ByTTEHJMsITNJDpM6PO8P/S338njUuZ
         ERNQ==
X-Gm-Message-State: ACgBeo1kiwBZ34fWKC8MZOjojcM+kupVdJWGDRBY9XBE6q+gV4a8vEuH
        XjI1GVMznS2d6kKCY5Odj9BVCA==
X-Google-Smtp-Source: AA6agR7Mhzano3E4Dx7iL7/SbQr+biuz9Sx+ufgic4soGNhU2IV9QB4S94zQvTMrdFx/BTVNvDsczQ==
X-Received: by 2002:a5d:6d46:0:b0:21f:8b7:4c1d with SMTP id k6-20020a5d6d46000000b0021f08b74c1dmr14861638wri.455.1662037060605;
        Thu, 01 Sep 2022 05:57:40 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v5-20020a5d59c5000000b002257fd37877sm15556709wry.6.2022.09.01.05.57.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:57:40 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, ardb@kernel.org,
        davem@davemloft.net, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>,
        John Keeping <john@metanate.com>
Subject: [PATCH v9 23/33] crypto: rockchip: use the rk_crypto_info given as parameter
Date:   Thu,  1 Sep 2022 12:57:00 +0000
Message-Id: <20220901125710.3733083-24-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901125710.3733083-1-clabbe@baylibre.com>
References: <20220901125710.3733083-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of using the crypto_info from TFM ctx, use the one given as parameter.

Reviewed-by: John Keeping <john@metanate.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index 6a1bea98fded..cf0dfb6029d8 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -254,7 +254,7 @@ static void rk_cipher_hw_init(struct rk_crypto_info *dev, struct skcipher_reques
 			     RK_CRYPTO_TDES_BYTESWAP_KEY |
 			     RK_CRYPTO_TDES_BYTESWAP_IV;
 		CRYPTO_WRITE(dev, RK_CRYPTO_TDES_CTRL, rctx->mode);
-		memcpy_toio(ctx->dev->reg + RK_CRYPTO_TDES_KEY1_0, ctx->key, ctx->keylen);
+		memcpy_toio(dev->reg + RK_CRYPTO_TDES_KEY1_0, ctx->key, ctx->keylen);
 		conf_reg = RK_CRYPTO_DESSEL;
 	} else {
 		rctx->mode |= RK_CRYPTO_AES_FIFO_MODE |
@@ -266,7 +266,7 @@ static void rk_cipher_hw_init(struct rk_crypto_info *dev, struct skcipher_reques
 		else if (ctx->keylen == AES_KEYSIZE_256)
 			rctx->mode |= RK_CRYPTO_AES_256BIT_key;
 		CRYPTO_WRITE(dev, RK_CRYPTO_AES_CTRL, rctx->mode);
-		memcpy_toio(ctx->dev->reg + RK_CRYPTO_AES_KEY_0, ctx->key, ctx->keylen);
+		memcpy_toio(dev->reg + RK_CRYPTO_AES_KEY_0, ctx->key, ctx->keylen);
 	}
 	conf_reg |= RK_CRYPTO_BYTESWAP_BTFIFO |
 		    RK_CRYPTO_BYTESWAP_BRFIFO;
-- 
2.35.1

