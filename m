Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 356BAC25B0E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbiHPOEU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235883AbiHPODm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:42 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4EC6319
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:30 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id u6so10628672ljk.8
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=rF3jH/rtUdR2dYrOhKBuwcHbVAqHrocZAK7mo3xPYCg=;
        b=B2CsJZONYIaydYyrfgBAc5tNXRqvnP8wRNofzwSTblaB0HKbrSKlJ/opaGOBOtOSqb
         ycApkrv1zHrKl03A3GMRDFWUI5GfaW/SkXalZziGGqkC2rbC0wQ/oWX6+rrU/CkkM+0R
         9jadcMW/PrZWXFIRm/hzC2+F6+iPqfo7/4x4Hp9vrmvZW78/cQGdc5cSEAiiL9Gdv2YU
         VrTPH+gcnPSxwLXzFvmi7T5s/AHh0IPHeHFyAHSBFs5CzjjiXrUfuGR77UK7LuNAm9Q7
         humMhtcgyU/lpCrOwbSQ4pr1A2ryxk79OILL9dUhM3dxtlnSRqGGivAvHfD5MksuCdmI
         71bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=rF3jH/rtUdR2dYrOhKBuwcHbVAqHrocZAK7mo3xPYCg=;
        b=LMeZ6VyqHLd70mtHGWv79BvW0ZgTr+u3RyucBA7+aua83nYaVrqmgCjnojb3CXm0gj
         I3RUyD2Tk6nQnijnykIWqgCKepty01KPz5fqht57C0QVzbBUNbUoOAyv50NIcJeggxEO
         mvIBcMJkMgcINBQsY/S0FrNNISoaZy+sDRPWUMq0FKW+k/RL62u96rQemU/4VVPXTSfr
         rqRpQ0R15PAN55zGeixh+ykK27I15TcOtUGW/EaBWHh76z2RJwnnBYXIGj7qAzDiirVi
         fy1rvGrDVWvHlWvwq75t9160O7lt3hnzpS++OfRtLN52dkRr/nW561UkzYnOylXwGdcw
         Sk7w==
X-Gm-Message-State: ACgBeo0Cujm66SPalt/By9IHE4IADbarrNgzLGJlbWd1b7Lxz/edNtFE
        qIr1tefuSYxEnW3hpjf5DqkIY/IzSNvBdQ==
X-Google-Smtp-Source: AA6agR7eJJ40nSspx3DYNPIKyxE12DsiM4iS6VE4Hl3zQEtS+Ed4hx5GU3HMkc92wcwZdhzXiPVFKw==
X-Received: by 2002:a2e:8e71:0:b0:261:74ad:ab5f with SMTP id t17-20020a2e8e71000000b0026174adab5fmr5829083ljk.387.1660658607541;
        Tue, 16 Aug 2022 07:03:27 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:27 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 12/16] crypto: ux500/hash: Drop regulator handling
Date:   Tue, 16 Aug 2022 16:00:45 +0200
Message-Id: <20220816140049.102306-13-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This "APE" voltage is not handled by a regulator but by the
power domain, drop it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Rebased on v6.0-rc1
ChangeLog v1->v2:
- New patch after noticing the power domain is handling this
  voltage.
---
 drivers/crypto/ux500/hash/hash_core.c | 38 +++------------------------
 1 file changed, 4 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 5fe0720cb1f5..21657c9c79a7 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -24,8 +24,6 @@
 #include <linux/mod_devicetable.h>
 #include <linux/platform_device.h>
 #include <linux/crypto.h>
-
-#include <linux/regulator/consumer.h>
 #include <linux/dmaengine.h>
 #include <linux/bitops.h>
 
@@ -244,22 +242,17 @@ static int get_empty_message_digest(
  * hash_disable_power - Request to disable power and clock.
  * @device_data:	Structure for the hash device.
  *
- * This function request for disabling power (regulator) and clock,
- * and could also save current hw state.
+ * This function request for disabling the clock.
  */
 static int hash_disable_power(struct hash_device_data *device_data)
 {
 	int ret = 0;
-	struct device *dev = device_data->dev;
 
 	spin_lock(&device_data->power_state_lock);
 	if (!device_data->power_state)
 		goto out;
 
 	clk_disable(device_data->clk);
-	ret = regulator_disable(device_data->regulator);
-	if (ret)
-		dev_err(dev, "%s: regulator_disable() failed!\n", __func__);
 
 	device_data->power_state = false;
 
@@ -273,8 +266,7 @@ static int hash_disable_power(struct hash_device_data *device_data)
  * hash_enable_power - Request to enable power and clock.
  * @device_data:		Structure for the hash device.
  *
- * This function request for enabling power (regulator) and clock,
- * and could also restore a previously saved hw state.
+ * This function request for enabling the clock.
  */
 static int hash_enable_power(struct hash_device_data *device_data)
 {
@@ -283,17 +275,9 @@ static int hash_enable_power(struct hash_device_data *device_data)
 
 	spin_lock(&device_data->power_state_lock);
 	if (!device_data->power_state) {
-		ret = regulator_enable(device_data->regulator);
-		if (ret) {
-			dev_err(dev, "%s: regulator_enable() failed!\n",
-				__func__);
-			goto out;
-		}
 		ret = clk_enable(device_data->clk);
 		if (ret) {
 			dev_err(dev, "%s: clk_enable() failed!\n", __func__);
-			ret = regulator_disable(
-					device_data->regulator);
 			goto out;
 		}
 		device_data->power_state = true;
@@ -1487,27 +1471,17 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	spin_lock_init(&device_data->ctx_lock);
 	spin_lock_init(&device_data->power_state_lock);
 
-	/* Enable power for HASH1 hardware block */
-	device_data->regulator = regulator_get(dev, "v-ape");
-	if (IS_ERR(device_data->regulator)) {
-		dev_err(dev, "%s: regulator_get() failed!\n", __func__);
-		ret = PTR_ERR(device_data->regulator);
-		device_data->regulator = NULL;
-		goto out;
-	}
-
-	/* Enable the clock for HASH1 hardware block */
 	device_data->clk = devm_clk_get(dev, NULL);
 	if (IS_ERR(device_data->clk)) {
 		dev_err(dev, "%s: clk_get() failed!\n", __func__);
 		ret = PTR_ERR(device_data->clk);
-		goto out_regulator;
+		goto out;
 	}
 
 	ret = clk_prepare(device_data->clk);
 	if (ret) {
 		dev_err(dev, "%s: clk_prepare() failed!\n", __func__);
-		goto out_regulator;
+		goto out;
 	}
 
 	/* Enable device power (and clock) */
@@ -1544,9 +1518,6 @@ static int ux500_hash_probe(struct platform_device *pdev)
 out_clk_unprepare:
 	clk_unprepare(device_data->clk);
 
-out_regulator:
-	regulator_put(device_data->regulator);
-
 out:
 	return ret;
 }
@@ -1585,7 +1556,6 @@ static int ux500_hash_remove(struct platform_device *pdev)
 			__func__);
 
 	clk_unprepare(device_data->clk);
-	regulator_put(device_data->regulator);
 
 	return 0;
 }
-- 
2.37.2

