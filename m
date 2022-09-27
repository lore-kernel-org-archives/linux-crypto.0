Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67B3BC54EE9
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Sep 2022 07:58:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231425AbiI0H61 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Sep 2022 03:58:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231515AbiI0H5X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2022 03:57:23 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FE9AE9F4
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:56:10 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id t4so5974803wmj.5
        for <linux-crypto@vger.kernel.org>; Tue, 27 Sep 2022 00:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=z10vTtQ4qHSJZ9nRrmQY5lLp9Bvyc0G2kDbemdDveLc=;
        b=SUtWt/yKk8dwQYXBM4pX0YSAMwhU0ggta2eQ2yzWE3hZuzbqcAra+8iI1B43bIaLde
         2A5pKkjX7yk/Ek7bmehuqmQsmxxHC7tGVGUTB9P3weCNedcwxv2TbavFR7/94cJMiKBg
         GDLHG/gw8KymsHp402S2SKJ57hI1Crk1V/vmJGaSqUcOMlE808U4gcA+45+bv29Mlo9v
         cczjPNLpUfrYxoQcled6pr02jRD8OzLNZX4rqOuu+AKIEvyECAACnj7lKco/su8KTFtV
         ICkdHA72mnoM156gkzmBCTRv/g55zJuHF437s8jfbVy+bPoJly6lTWmH2el8NhUSvFCT
         o6yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=z10vTtQ4qHSJZ9nRrmQY5lLp9Bvyc0G2kDbemdDveLc=;
        b=cr+pRUNjmJfT7fs2k3pFhfFBQ4sXARwhdYBVQ4DF/zGMw0gPXrOytluKpJXDJujpV7
         MZMjaGy/UHFpX25jahGbMeNDoRwL1REL1JQBMh9zxhE6suTDK7KAGQ2ix29L4rocgA6F
         5dstloTG6AuhqMVomUHvQwnIFHeFZCg7IQHQqdi4wLt1oMivIATdmZ+znpJ1q7XnmHcs
         JeJCNGUzL1672g35wDXAudF48rTfxbWY154fQ0bEZrPidpnrLAcVbp6FEpfYr38YMTTC
         iHlSL2vMNs/+8QWRFsbhaIpXs23/YCuP39hL0uHcS+/rOkUkKRWsBai4uDKUDJkhEySf
         E27A==
X-Gm-Message-State: ACrzQf2ygKT2czcp8j34aRoBmBwRfeVrQG2iyzgD4E1FQ93D0qfgTupM
        wKfy1no9bRY6b5xT68RNOadqlA==
X-Google-Smtp-Source: AMsMyM4BaygUsH/WyeQVQo3CW9varbVyVY8PtLnBUqF7L7qtyzWYzthtkrR1qRH4omU72F2l8jzJYA==
X-Received: by 2002:a05:600c:1c03:b0:3b4:618b:5d14 with SMTP id j3-20020a05600c1c0300b003b4618b5d14mr1534048wms.59.1664265369832;
        Tue, 27 Sep 2022 00:56:09 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id x8-20020adfdcc8000000b0022afbd02c69sm1076654wrm.56.2022.09.27.00.56.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 00:56:09 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, krzysztof.kozlowski+dt@linaro.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v10 32/33] crypto: rockchip: permit to have more than one reset
Date:   Tue, 27 Sep 2022 07:55:10 +0000
Message-Id: <20220927075511.3147847-33-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220927075511.3147847-1-clabbe@baylibre.com>
References: <20220927075511.3147847-1-clabbe@baylibre.com>
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

