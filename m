Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB90CCA479
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 13:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiGUNpl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiGUNow (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 09:44:52 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD74863CE
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:19 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id u19so2928030lfs.0
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jqVIpScoCCWkDYabFnlwaaN9YoNnkMmK49AqBQlpN38=;
        b=pwObx/GcQLid5/AwpUISVuaVTzteHWScJQUuM1WEjLsOkMMiz5TsxXhF85mQdwOvaX
         nr7CMIWIZKl2bC1SuFVblpMBnCom3gKIMCVfHlQ3re2Hj18Tis/QKuXG+hce3EP9sx4n
         9y8RNtaZgJZvAa9QKl16XEMt8XXTQ5DzYiG15FsO0c89UQK8gEuLzy0nhCkYhj9vpScZ
         g9Ypm9Ao4X7LLNbUK8n0f8oQKcmMpgH6rDSGG3bWXDFcjVhLFDF5jmWCoaFPBFOQTrk8
         5PvXeelLKuNOQWezzvFe9YMsq0WBtiCKOsz7E1RfVWaJcprSOEK4rZqqlf6GkhWLRWC5
         fwjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jqVIpScoCCWkDYabFnlwaaN9YoNnkMmK49AqBQlpN38=;
        b=Gz91WicJbxJNSvPxKnXG0d9dJXigYsdcMzZvB6NbSoSl3ELBB2mMx1Jnj8hA+FE2Vd
         8PT/YR/+ABOYVrRRR9Ab5anQ6CUcsEN+eNthtU4UVvfUY8cUQj5i8KMg4TDVC5BM/5NJ
         8uiBYl3WaRM7YyT6mONc7PZCrLJ/BFJ7VdVI2S4Oycxysuig9qxM9QkthxfolzgEQ518
         L/0zGNBe1Jq7Vr/mhr1V85FzxPNl2D3ptcABoORHYW14usBXICBpED5plTW1oI6+uPl6
         TplHPJsLErZ4KwWK5NuSMiGtvK9dqHggAdvWsmNZXVLL8ezVaraQdB+Kl+YHf1qsJcnM
         j03g==
X-Gm-Message-State: AJIora9K1px962FKqRA+tCjgDHgCnzjN378zY84udmRzJRJGDb2BLpoQ
        ouf9uT5pxNb6AsSgmlcsk6nMTkpEBX3XLQ==
X-Google-Smtp-Source: AGRyM1vgzjJ0BItV7slTtOxAPzurr5dvcxKAOsX1nCxr/sj7eczTLe7+VgthdYOaNjtRyAVTn8MZng==
X-Received: by 2002:a05:6512:3fa2:b0:48a:16df:266f with SMTP id x34-20020a0565123fa200b0048a16df266fmr18593242lfa.414.1658410995946;
        Thu, 21 Jul 2022 06:43:15 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o23-20020ac24e97000000b004867a427026sm458568lfr.40.2022.07.21.06.43.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:15 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 15/15] crypto: ux500/hash: Drop regulator handling
Date:   Thu, 21 Jul 2022 15:40:50 +0200
Message-Id: <20220721134050.1047866-16-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This "APE" voltage is not handled by a regulator but by the
power domain, drop it.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/ux500/hash/hash_core.c | 35 +++------------------------
 1 file changed, 4 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 55d27af8c9de..35bda646f49c 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -27,8 +27,6 @@
 #include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <linux/crypto.h>
-
-#include <linux/regulator/consumer.h>
 #include <linux/dmaengine.h>
 #include <linux/bitops.h>
 
@@ -247,8 +245,7 @@ static int get_empty_message_digest(
  * hash_disable_power - Request to disable power and clock.
  * @device_data:	Structure for the hash device.
  *
- * This function request for disabling power (regulator) and clock,
- * and could also save current hw state.
+ * This function request for disabling the clock.
  */
 static int hash_disable_power(struct hash_device_data *device_data)
 {
@@ -260,9 +257,6 @@ static int hash_disable_power(struct hash_device_data *device_data)
 		goto out;
 
 	clk_disable(device_data->clk);
-	ret = regulator_disable(device_data->regulator);
-	if (ret)
-		dev_err(dev, "%s: regulator_disable() failed!\n", __func__);
 
 	device_data->power_state = false;
 
@@ -276,8 +270,7 @@ static int hash_disable_power(struct hash_device_data *device_data)
  * hash_enable_power - Request to enable power and clock.
  * @device_data:		Structure for the hash device.
  *
- * This function request for enabling power (regulator) and clock,
- * and could also restore a previously saved hw state.
+ * This function request for enabling the clock.
  */
 static int hash_enable_power(struct hash_device_data *device_data)
 {
@@ -286,17 +279,9 @@ static int hash_enable_power(struct hash_device_data *device_data)
 
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
@@ -1575,25 +1560,17 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	spin_lock_init(&device_data->ctx_lock);
 	spin_lock_init(&device_data->power_state_lock);
 
-	device_data->regulator = regulator_get(dev, "v-ape");
-	if (IS_ERR(device_data->regulator)) {
-		dev_err(dev, "%s: regulator_get() failed!\n", __func__);
-		ret = PTR_ERR(device_data->regulator);
-		device_data->regulator = NULL;
-		goto out;
-	}
-
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
@@ -1637,9 +1614,6 @@ static int ux500_hash_probe(struct platform_device *pdev)
 out_clk_unprepare:
 	clk_unprepare(device_data->clk);
 
-out_regulator:
-	regulator_put(device_data->regulator);
-
 out:
 	return ret;
 }
@@ -1682,7 +1656,6 @@ static int ux500_hash_remove(struct platform_device *pdev)
 			__func__);
 
 	clk_unprepare(device_data->clk);
-	regulator_put(device_data->regulator);
 
 	return 0;
 }
-- 
2.36.1

