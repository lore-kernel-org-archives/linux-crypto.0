Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A525C2BB41
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbiHPODa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:03:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbiHPODY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:24 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F05A4F64B
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:18 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id u3so15048382lfk.8
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=3hdGrIQ299lWEia0LRNRsH0WiIkUXzcfHJxdjTksbeY=;
        b=aDb6oRbTUav887/pixDHR2STjGNB7SH6U3SiRfOgf51fHKYFsirOyX31PcM9bao8ou
         sXROU2ZUvor/CGrgjUELCeN/Wo4zI8vkmCQAZAgipVLuJDCeUWxbb24hnq7HvUxaOe84
         epvMo3NNYFMIKeHha0M4SgKIkJxfcCLYgzIve5z2w3kWTVFX9yncHNI4OUI+G/L17eEy
         a3yCKnPCjqUmtHMM10LVgJcOcCznfVimGo/Qj6UMCAsEYuSTi4VtRjdUMec5WHdM2Ten
         b+1N1n/swhwGBDiD4T+VzPia5K9BOTQYV1g/yjQMNbgW3/QiQrfhXXg2sSlIHpHm2H7W
         ffhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=3hdGrIQ299lWEia0LRNRsH0WiIkUXzcfHJxdjTksbeY=;
        b=AZdJCA7OyY8XnZJ1zbX3HsrUKJLhx5ErPFTWugoYAJfpcSw/Dscg3USgtIhcCeJzXl
         tHqActcSLMYxPEp9fTTxwK7m4rRrCA3Pimr62KC1McvXswl75HAd6NllHxfpF9EDPVUa
         //XtVqY3/XARYZC8qfz2u/pQYASPQHR5qhe58ckOebEivQlqM0whcVzftBptjqgzZduY
         AbLRgjBsnZgZUtT+pG8I+o/9Bt0ZMtOPK+9kjO+LQ0wdS73MICPUn9XX3J/FzIsRflOZ
         kZfjHJXtJR+laesQWrgqxxGMum8N6ooko1pG3BxRALNAdO9tMezlOJyyLUIMFnF2tCRk
         haEw==
X-Gm-Message-State: ACgBeo0FTBBvO8560Lu3wB6xHoxKAMOe91HOs8bRFYuR4/eU2gCf+IhR
        ENrKysZkSQU00WGZJTk0nyKTzXWMjJJ1xg==
X-Google-Smtp-Source: AA6agR5pX4QOud24aTiuXTToEkBKj5LLVsmQBYveANhSWYtmdmsba+yHZBXgJ/qp9qWgiOWJVkJXdg==
X-Received: by 2002:ac2:44af:0:b0:48a:f361:fe1d with SMTP id c15-20020ac244af000000b0048af361fe1dmr7601083lfm.190.1660658596764;
        Tue, 16 Aug 2022 07:03:16 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:16 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 04/16] crypto: ux500/hash: Drop custom state save/restore
Date:   Tue, 16 Aug 2022 16:00:37 +0200
Message-Id: <20220816140049.102306-5-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop the code that is saving and restoring the device state
as part of the PM operations: this is the job of .import and
.export, do not try to work around the framework.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Rebased on v6.0-rc1
ChangeLog v1->v2:
- No changes
---
 drivers/crypto/ux500/hash/hash_core.c | 52 +++++----------------------
 1 file changed, 8 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index aa6bbae107cd..fbd6335f142b 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -243,13 +243,11 @@ static int get_empty_message_digest(
 /**
  * hash_disable_power - Request to disable power and clock.
  * @device_data:	Structure for the hash device.
- * @save_device_state:	If true, saves the current hw state.
  *
  * This function request for disabling power (regulator) and clock,
  * and could also save current hw state.
  */
-static int hash_disable_power(struct hash_device_data *device_data,
-			      bool save_device_state)
+static int hash_disable_power(struct hash_device_data *device_data)
 {
 	int ret = 0;
 	struct device *dev = device_data->dev;
@@ -258,12 +256,6 @@ static int hash_disable_power(struct hash_device_data *device_data,
 	if (!device_data->power_state)
 		goto out;
 
-	if (save_device_state) {
-		hash_save_state(device_data,
-				&device_data->state);
-		device_data->restore_dev_state = true;
-	}
-
 	clk_disable(device_data->clk);
 	ret = regulator_disable(device_data->regulator);
 	if (ret)
@@ -280,13 +272,11 @@ static int hash_disable_power(struct hash_device_data *device_data,
 /**
  * hash_enable_power - Request to enable power and clock.
  * @device_data:		Structure for the hash device.
- * @restore_device_state:	If true, restores a previous saved hw state.
  *
  * This function request for enabling power (regulator) and clock,
  * and could also restore a previously saved hw state.
  */
-static int hash_enable_power(struct hash_device_data *device_data,
-			     bool restore_device_state)
+static int hash_enable_power(struct hash_device_data *device_data)
 {
 	int ret = 0;
 	struct device *dev = device_data->dev;
@@ -309,12 +299,6 @@ static int hash_enable_power(struct hash_device_data *device_data,
 		device_data->power_state = true;
 	}
 
-	if (device_data->restore_dev_state) {
-		if (restore_device_state) {
-			device_data->restore_dev_state = false;
-			hash_resume_state(device_data, &device_data->state);
-		}
-	}
 out:
 	spin_unlock(&device_data->power_state_lock);
 
@@ -1597,7 +1581,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	}
 
 	/* Enable device power (and clock) */
-	ret = hash_enable_power(device_data, false);
+	ret = hash_enable_power(device_data);
 	if (ret) {
 		dev_err(dev, "%s: hash_enable_power() failed!\n", __func__);
 		goto out_clk_unprepare;
@@ -1625,7 +1609,7 @@ static int ux500_hash_probe(struct platform_device *pdev)
 	return 0;
 
 out_power:
-	hash_disable_power(device_data, false);
+	hash_disable_power(device_data);
 
 out_clk_unprepare:
 	clk_unprepare(device_data->clk);
@@ -1666,7 +1650,7 @@ static int ux500_hash_remove(struct platform_device *pdev)
 
 	ahash_algs_unregister_all(device_data);
 
-	if (hash_disable_power(device_data, false))
+	if (hash_disable_power(device_data))
 		dev_err(dev, "%s: hash_disable_power() failed\n",
 			__func__);
 
@@ -1706,7 +1690,7 @@ static void ux500_hash_shutdown(struct platform_device *pdev)
 
 	ahash_algs_unregister_all(device_data);
 
-	if (hash_disable_power(device_data, false))
+	if (hash_disable_power(device_data))
 		dev_err(&pdev->dev, "%s: hash_disable_power() failed\n",
 			__func__);
 }
@@ -1720,7 +1704,6 @@ static int ux500_hash_suspend(struct device *dev)
 {
 	int ret;
 	struct hash_device_data *device_data;
-	struct hash_ctx *temp_ctx = NULL;
 
 	device_data = dev_get_drvdata(dev);
 	if (!device_data) {
@@ -1728,18 +1711,7 @@ static int ux500_hash_suspend(struct device *dev)
 		return -ENOMEM;
 	}
 
-	spin_lock(&device_data->ctx_lock);
-	if (!device_data->current_ctx)
-		device_data->current_ctx++;
-	spin_unlock(&device_data->ctx_lock);
-
-	if (device_data->current_ctx == ++temp_ctx) {
-		ret = hash_disable_power(device_data, false);
-
-	} else {
-		ret = hash_disable_power(device_data, true);
-	}
-
+	ret = hash_disable_power(device_data);
 	if (ret)
 		dev_err(dev, "%s: hash_disable_power()\n", __func__);
 
@@ -1754,7 +1726,6 @@ static int ux500_hash_resume(struct device *dev)
 {
 	int ret = 0;
 	struct hash_device_data *device_data;
-	struct hash_ctx *temp_ctx = NULL;
 
 	device_data = dev_get_drvdata(dev);
 	if (!device_data) {
@@ -1762,14 +1733,7 @@ static int ux500_hash_resume(struct device *dev)
 		return -ENOMEM;
 	}
 
-	spin_lock(&device_data->ctx_lock);
-	if (device_data->current_ctx == ++temp_ctx)
-		device_data->current_ctx = NULL;
-	spin_unlock(&device_data->ctx_lock);
-
-	if (device_data->current_ctx)
-		ret = hash_enable_power(device_data, true);
-
+	ret = hash_enable_power(device_data);
 	if (ret)
 		dev_err(dev, "%s: hash_enable_power() failed!\n", __func__);
 
-- 
2.37.2

