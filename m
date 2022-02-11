Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94ACBC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Feb 2022 12:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242496AbiBKMQ2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Feb 2022 07:16:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237296AbiBKMQ1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Feb 2022 07:16:27 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF5BF26
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 04:16:26 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id s10so1385526wrb.1
        for <linux-crypto@vger.kernel.org>; Fri, 11 Feb 2022 04:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mvl1wkNYm6RPkegUr/uIzjNHoyz2Xn8SussJz1Z+CdY=;
        b=lFrHfoiAMlozZfasDvYf333y10SDkdJeqArttbeQpBga/b5WxYIwUNfotHavSujnc7
         tn3F5Ayv6fiAZmUVInKh1q7eHOk5O8jEJiDHF+J/5gkxuQtPO3/PQUx9n6oYmTHvi8wq
         8eLSHCuXVF2PyqO4+3PTTtjgq+nnKQaAKoogYClq/k8AehKizJdGcnxCJrl16A5gjNd7
         q6sxU34ajDV2moYCCaJExp8sisWwH9DrrRyAqN1MBXfS8NELY1YBiwWMNnLIMKNS7dTB
         xf/8TgDbrw6gPIkfVPIchFRUZaGJyRW6BS9UyLuLto1hqVwwxJ/G7BY8e3pgA/4B5N+e
         Zi/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mvl1wkNYm6RPkegUr/uIzjNHoyz2Xn8SussJz1Z+CdY=;
        b=fYvFKcTKo6HsCsd0g2XbdJcmni2iLjiOVeNwSwUN0kgS0jOh8+jxdzvWMsBejSbdI7
         n/xeMeiuV9ZwVUkLOHkOFOg3QMMSiKfAedeURE5wwZAyWhkygLjcrvJ1cQ8fF/cbtCNI
         3Zph/UjNm1LNu9hYj3Li6C/9+DZUU5nDID4cBozyOE5noodBQFSqfZoCydQYfTSjLXGn
         fQ/JARnfqU40AzpgN3rJkhXy3BjA0a2XcOgTc4QsTkjW/GHpKUwy4UV+CqEJZl/m4N10
         89YeyRUpnlNS0FO9RCDT/8MjvKK9f8JMSx9ojpdw8x/ZcCW3lL5GYopEClzJGXi0wpcE
         Xz7w==
X-Gm-Message-State: AOAM530M1DbylQN3M+YYhSA4NknzU+4gyMB90D6NuUQUrJngq1xGiGhz
        qDBTR6LD5tGXkqlBr/BIQdbfNyH40QB3OQ==
X-Google-Smtp-Source: ABdhPJwGUQacHI4CxH9hSOZ9rIRJOkrXKFeMz7H/g9nlpl2QbK6F77vVWMHaWbmnYplFIJPlZEdJTw==
X-Received: by 2002:a5d:590d:: with SMTP id v13mr1172963wrd.274.1644581784643;
        Fri, 11 Feb 2022 04:16:24 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id l11sm6451885wry.77.2022.02.11.04.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 04:16:24 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, heiko@sntech.de
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: rockchip: ECB does not need IV
Date:   Fri, 11 Feb 2022 12:16:17 +0000
Message-Id: <20220211121617.3393068-1-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When loading rockchip crypto module, testmgr complains that ivsize of ecb-des3-ede-rk
is not the same than generic implementation.
In fact ECB does not use an IV.

Fixes: ce0183cb6464b ("crypto: rockchip - switch to skcipher API")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index 1cece1a7d3f0..5bbf0d2722e1 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -506,7 +506,6 @@ struct rk_crypto_tmp rk_ecb_des3_ede_alg = {
 		.exit			= rk_ablk_exit_tfm,
 		.min_keysize		= DES3_EDE_KEY_SIZE,
 		.max_keysize		= DES3_EDE_KEY_SIZE,
-		.ivsize			= DES_BLOCK_SIZE,
 		.setkey			= rk_tdes_setkey,
 		.encrypt		= rk_des3_ede_ecb_encrypt,
 		.decrypt		= rk_des3_ede_ecb_decrypt,
-- 
2.34.1

