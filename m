Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD15FC54EE9
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Sep 2022 13:00:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbiIANAx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 09:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiIAM6u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 08:58:50 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E231479A56
        for <linux-crypto@vger.kernel.org>; Thu,  1 Sep 2022 05:57:51 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id c7so15587757wrp.11
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2022 05:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=z10vTtQ4qHSJZ9nRrmQY5lLp9Bvyc0G2kDbemdDveLc=;
        b=gxFS041sKmCJ8gotE/rzRHIFcK8pgteVLsHohzmHGLL/Asvsnk4TqKRaOJx2n2JSxl
         33hGjEieWt9UJm8s4yv7CVA5XS9LFVlbGGs9a8nqvSovNxG7/2HP4rrROSOZJrYmUvXX
         MfsKyCI8gUr/kjw3RcjCzVH8Z8qNhIkkAAf8mxKe5BjnZypSBNxB0FPddIgyfb10blqA
         aiQzQL8JBz5NrW2n2FKFzuuH12j3hPhdLuSyVsocChUGMiqV/jDjBKWUJ/PgrGbdDFOD
         PdkzhEE5laWc34/FtNaacKvoN0PCBNxlW5nK1TegOu3msHpNYhauUnTtfnfQE2XcK+H8
         hh3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=z10vTtQ4qHSJZ9nRrmQY5lLp9Bvyc0G2kDbemdDveLc=;
        b=ia2sCmf+3g1id/KLh98YULKXy+idm7Q4690cqZAS6WfYZS9mhr0iGdX5Yg16XPbKPz
         iBTQVODlq2pZARzkMDiUYOlsxOhowmdz2jDEFDEbf3AqM7JgamMsKwecnS9E06Sl5Qwn
         vZmdB7D6zYaFkYRYNcDGGZ2psY+HhsteZ+ZSlY1iPTMyvdD+NnpYqmojXie8ekQHmTKK
         bx/u2pZgTQHl5tXDdbPWgapfwjItopHl9iRml9jqvRUMYRf+LsWsL6Iv0uYzc4pUif3S
         SpDN/BdOdYnwU2k2maLsGIjiv3AI/+fn465SzA3HnHTesAASHvtjVe81BQWpSmH7nSpK
         IFiQ==
X-Gm-Message-State: ACgBeo2h9mKaHwIjtsTc7nEV8p6cRfhap0PrWg5LLZWE/g6Gn3UyE24k
        V7iJqBpp5A5GgY73sM1BsCYqqQ==
X-Google-Smtp-Source: AA6agR42iXjNLWIdpiBHP13edGTdQ/2uIMitreBQnTgTu+13p4zqUS0pjcpdsslMonKuDmBkZbHpkg==
X-Received: by 2002:a5d:5281:0:b0:224:fe40:798f with SMTP id c1-20020a5d5281000000b00224fe40798fmr14952340wrv.90.1662037069759;
        Thu, 01 Sep 2022 05:57:49 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v5-20020a5d59c5000000b002257fd37877sm15556709wry.6.2022.09.01.05.57.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 05:57:49 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, ardb@kernel.org,
        davem@davemloft.net, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v9 32/33] crypto: rockchip: permit to have more than one reset
Date:   Thu,  1 Sep 2022 12:57:09 +0000
Message-Id: <20220901125710.3733083-33-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901125710.3733083-1-clabbe@baylibre.com>
References: <20220901125710.3733083-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The RK3399 has 3 resets, so the driver to handle multiple resets.
This is done by using devm_reset_control_array_get_exclusive().

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index 232dc625d6e5..d96f375423d5 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -281,7 +281,7 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	crypto_info->rst = devm_reset_control_get(dev, "crypto-rst");
+	crypto_info->rst = devm_reset_control_array_get_exclusive(dev);
 	if (IS_ERR(crypto_info->rst)) {
 		err = PTR_ERR(crypto_info->rst);
 		goto err_crypto;
-- 
2.35.1

