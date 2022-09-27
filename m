Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6F2C07E9D
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 07:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbiI0H6J (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Sep 2022 03:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiI0H4w (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2022 03:56:52 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E75CCAE211
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:55:59 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id l18so1693404wrw.9
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=0KerGvUzdejWLAwshDyy9ppWCWrJnFuYbHleK5z5lUU=;
        b=tFZZkGLF12zpJ31kndQX4/eM+ARGjrnucK7XCQ8xEzjNs8rXqJXlW9DOiPgvta1cA0
         Yy9+5gkNcMt20ahW61SdWn0goPxqolClL5ZlG+JTNs278lWWZq453BNrLGlUX/q/Z8mx
         1LYi9+zNPagPwC71r/b8mMLvjoKFrQcG99vO5jCh+QgbOBn9ntWmGCYNEjZDvVCZmyj2
         l4QUUuEbbcrs4NIHGKG9IwB9S9/nUTSwAzTFoPQYAZMneUoXm8ypujPZAKTJ7amhwD0e
         P5wdhOt3nio9X2nmDhWLztkpWl5ax1AXyki3jhpErcshNVxIZXh2JEDgx4/mwoVzU/Ti
         hBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=0KerGvUzdejWLAwshDyy9ppWCWrJnFuYbHleK5z5lUU=;
        b=x3OB9aVTNDF88yEvVcR+vNhbtbB4funD7X+bstu6nDdZEHDRKApe7p1bGkp4Gr3218
         ygGpTZPak2EfAb0WCpUxC13Ohru85dDSrwjPZ374soYFdRHk/bzNa+DRDTU/YVB+Cv4n
         EYE7UU1UFYSOAgoQA5JKlvd31Uztlz9AqRr/WxwkJjatASUsaAO1YkdiTcHALapgwqjj
         M5/6qvOpYah2XzCUdix7Pwh+QOnuR+6h2QT7y9hyQJoOElqKyoxRXQEfcZNeEfHbKiOQ
         6pwUMg/BV97dJ/YMGSU+en3FU9KhR8aLycg372z/o3NoiHQWigF5EqEdVqeZRJJzMKWO
         9QUg==
X-Gm-Message-State: ACrzQf0VFAUQhGfsp5aoO0Ec6U2XbOujcvYUoVzuW2xRtHzoyFLIGMFK
        mHK8DPN4svwqUzbO0EdX2ijIkQ==
X-Google-Smtp-Source: AMsMyM7cTV+QeJCXQ/wabYGrCDeuge3SgCP1vYJoewZaxtGyOUU+Nm9KENJZ/QjBK8MeyIn1pqZGSQ==
X-Received: by 2002:adf:9cd0:0:b0:22a:7cea:d3c3 with SMTP id h16-20020adf9cd0000000b0022a7cead3c3mr16728656wre.196.1664265359229;
        Tue, 27 Sep 2022 00:55:59 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id x8-20020adfdcc8000000b0022afbd02c69sm1076654wrm.56.2022.09.27.00.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:55:58 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>,
        John Keeping <john@metanate.com>
Subject: [PATCH v10 23/33] crypto: rockchip: use the rk_crypto_info given as parameter
Date:   Tue, 27 Sep 2022 07:55:01 +0000
Message-Id: <20220927075511.3147847-24-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220927075511.3147847-1-clabbe@baylibre.com>
References: <20220927075511.3147847-1-clabbe@baylibre.com>
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

