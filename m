Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C590C4167D
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 19:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237970AbiDMTKH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbiDMTKA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 15:10:00 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0742370CFD
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:38 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id b19so3963375wrh.11
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p55H6E0886aSJalxirRbnL3xLKJ1MG4FEZeIU1Ksblw=;
        b=MWfH9rhjS4kYABFCOD8A2pPFY++uVUZ8LAVX5bdw61oIeh1cFPG+JhjRhdC5RwRwNt
         Cmo+t3usSTii1D9mNiCfSMg4en7hAkh3ractzlPy/E+l5vwwZ73IFI8+BvYxBka71hCc
         nFredmvx0CMKyfDZyL6ev+rzxwRydne/blmbs5eCUd/GmpxyKyXI2pid1Bdbb39fpyqG
         E3qA+Ommr0Du9MqGK65vtKPK4YD/gOu/j6MmTFiW13EWkC5p6kCbQMJhDGrvX0+snr0i
         Al9n2wySFwziCVySQLNuWa9/CDEu59u/EJualBSSRgo+NC95+oDJ46i/gz8tPi0Q6ON0
         6dBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p55H6E0886aSJalxirRbnL3xLKJ1MG4FEZeIU1Ksblw=;
        b=R+zIZWWb6vRRWKj0SFF1aEM3PyVHT+aHTdfbBTzDXMNYyN2NEh81P3YMG/t7Q2HiF2
         f+PQ8ZTm0BMJ+CJ/Sf0T1AIaYJuiGcMxJyu0fSdoX2wz/QVjcv4cvT580hVt2eZr7huX
         gE2PFT+SwabFvMXW6ruL0cdQgJ82xVH+8zw1Nq57bpqe2kjk3XeNSEI9WJMbkKc463j/
         oQRLcnkaDbv79VzRiCg3kTulIqwHeUAoWPGn4OjlhjwLbOVHwzTZo54jxAEzQflqRmS1
         YQmP6v2Xc3Nfd/YNS6CRbFLWoq9ao0FjkHMdios8hMNCy9cBn61fZHUL4CJUKxwB80Jp
         UPsw==
X-Gm-Message-State: AOAM531XYAIkvw0h63lul4wz3rTjNaZjvidFLfJldDqh5BSsOM/hkZ6p
        5LqtDLcM1r/aMDPcaIFlujfzxg==
X-Google-Smtp-Source: ABdhPJx+lwIskjfvzg8sH7td1AEsMm3+nQKJ3+1FkKm2XKocXVu0c8zMQSmQ6YKKLtt9+JF8y7G/eA==
X-Received: by 2002:a05:6000:2aa:b0:207:a57a:c9c3 with SMTP id l10-20020a05600002aa00b00207a57ac9c3mr233542wry.417.1649876856621;
        Wed, 13 Apr 2022 12:07:36 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o29-20020a05600c511d00b0038e3532b23csm3551852wms.15.2022.04.13.12.07.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:07:36 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 14/33] crypto: rockchip: handle reset also in PM
Date:   Wed, 13 Apr 2022 19:06:54 +0000
Message-Id: <20220413190713.1427956-15-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413190713.1427956-1-clabbe@baylibre.com>
References: <20220413190713.1427956-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

reset could be handled by PM functions.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/rockchip/rk3288_crypto.c | 19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index d9258b9e71b3..a11a92e1f3fd 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -73,6 +73,8 @@ static int rk_crypto_pm_suspend(struct device *dev)
 {
 	struct rk_crypto_info *rkdev = dev_get_drvdata(dev);
 
+	reset_control_assert(rkdev->rst);
+
 	rk_crypto_disable_clk(rkdev);
 	return 0;
 }
@@ -81,6 +83,8 @@ static int rk_crypto_pm_resume(struct device *dev)
 {
 	struct rk_crypto_info *rkdev = dev_get_drvdata(dev);
 
+	reset_control_deassert(rkdev->rst);
+
 	return rk_crypto_enable_clk(rkdev);
 }
 
@@ -222,13 +226,6 @@ static void rk_crypto_unregister(void)
 	}
 }
 
-static void rk_crypto_action(void *data)
-{
-	struct rk_crypto_info *crypto_info = data;
-
-	reset_control_assert(crypto_info->rst);
-}
-
 static const struct of_device_id crypto_of_id_table[] = {
 	{ .compatible = "rockchip,rk3288-crypto" },
 	{}
@@ -254,14 +251,6 @@ static int rk_crypto_probe(struct platform_device *pdev)
 		goto err_crypto;
 	}
 
-	reset_control_assert(crypto_info->rst);
-	usleep_range(10, 20);
-	reset_control_deassert(crypto_info->rst);
-
-	err = devm_add_action_or_reset(dev, rk_crypto_action, crypto_info);
-	if (err)
-		goto err_crypto;
-
 	crypto_info->reg = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(crypto_info->reg)) {
 		err = PTR_ERR(crypto_info->reg);
-- 
2.35.1

