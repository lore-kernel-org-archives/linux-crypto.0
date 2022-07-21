Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC19FC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 13:45:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiGUNpP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbiGUNnp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 09:43:45 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C66D85D42
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:09 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id z22so2851003lfu.7
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kbCVp68pTylnpll/X9Y58r8MWp+XSo2mGEuR4kEk9k0=;
        b=KZysEJGF9UH4uakT8svVH4JJtlutY+f2qmieEzLmzim0oG18NBeW3X4oPJ5WYBZpX0
         JhsXXACAudGyqwnd8ntMv30odZBC6TWR7RqJ8BYacgzaw0TFYLU6baicjvBYE76NDBtq
         JRiYgzrhQDIdX3df2PX8VuzFfEeJqQ2b7FQMYlj82vsaDyUiRdIFBuTa1stMj4HCOqzw
         thxgH0impl+8tz9g8LM+jtQqwC0rOqDw5rWk/zFHyf+ETntxssf19+USjCH1UWqrG3/A
         jaKCRrpRbVSYWjlHstWplEcr21gtBmWJgWB3AKlgtMBoBXVkjrQFEPj5+125cs8PuCy9
         yLbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kbCVp68pTylnpll/X9Y58r8MWp+XSo2mGEuR4kEk9k0=;
        b=4f+arQNcfRraxcHEX/TWgJpr3+wcF3xZZUIK4RfGVWttUlDBd+uXDoKQ/DeSxGY3En
         Ro+jgqb1Ujx/o1N/AuS7Yj7XqKkEsbReYb3JIKDZtIrAnewPz8HtMy2EVkwvAX3vUC1P
         Pl/xZraKSiPKzx4vZn/nPOo2+HKreGIsTOQgvTeJSTTf7q/yIuTABQr0qwgByNuHTRp9
         3mIPFh4R2GGdBK8/8OcejSR2JZOt+ANcC9MD0k3Oeerw36eGAEa7KAfyap0pKfJ7Tqfo
         U+z4QoPJiGC2XuUkmQxJS4vIwjTX+ZSED+TSYEGBPy+ZMU85mMoqZvjmn5prv8gu6Kd8
         BTXg==
X-Gm-Message-State: AJIora8a1Wxu5Etdn7oWIb9EnjZsnRJlHzsCLhEpRBQ66GucZimRqy3S
        iUQPwWfIVVoJrQmhYInCPl9fGegvXoc8ng==
X-Google-Smtp-Source: AGRyM1sP8uN2UmbDxPkZ6BT+FFysbLQRDWXGFIwwmPllDY9kofBC0g8g8EM4kuYI2E5x4MaSKerYNQ==
X-Received: by 2002:a05:6512:ba4:b0:489:d071:c085 with SMTP id b36-20020a0565120ba400b00489d071c085mr21837242lfv.652.1658410986951;
        Thu, 21 Jul 2022 06:43:06 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o23-20020ac24e97000000b004867a427026sm458568lfr.40.2022.07.21.06.43.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:06 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 08/15] crypto: ux500/hash: Stop saving/restoring compulsively
Date:   Thu, 21 Jul 2022 15:40:43 +0200
Message-Id: <20220721134050.1047866-9-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The driver is saving/restoring state very intensively, because
of assumptions that suspend/resume can be called at any time.
(Android behaviours.) We removed the state save/restore from
the PM hooks and will use runtime PM for this instead so get
rid of this.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/ux500/hash/hash_alg.h  |  1 -
 drivers/crypto/ux500/hash/hash_core.c | 44 +++------------------------
 2 files changed, 4 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index d124fd17519f..d9d59dba6e6e 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -369,7 +369,6 @@ struct hash_device_data {
 	spinlock_t		power_state_lock;
 	struct regulator	*regulator;
 	struct clk		*clk;
-	struct hash_state	state; /* Used for saving and resuming state */
 	struct hash_dma		dma;
 };
 
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index b3649e00184f..c2e8bd977f57 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -674,19 +674,7 @@ static int hash_process_data(struct hash_device_data *device_data,
 			break;
 		}
 
-		if (req_ctx->hw_initialized) {
-			ret = hash_resume_state(device_data,
-						&device_data->state);
-			memmove(req_ctx->state.buffer,
-				device_data->state.buffer,
-				HASH_BLOCK_SIZE);
-			if (ret) {
-				dev_err(device_data->dev,
-					"%s: hash_resume_state() failed!\n",
-					__func__);
-				goto out;
-			}
-		} else {
+		if (!req_ctx->hw_initialized) {
 			ret = init_hash_hw(device_data, ctx);
 			if (ret) {
 				dev_err(device_data->dev,
@@ -725,17 +713,6 @@ static int hash_process_data(struct hash_device_data *device_data,
 		msg_length -= (HASH_BLOCK_SIZE - *index);
 		*index = 0;
 
-		ret = hash_save_state(device_data,
-				      &device_data->state);
-
-		memmove(device_data->state.buffer,
-			req_ctx->state.buffer,
-			HASH_BLOCK_SIZE);
-		if (ret) {
-			dev_err(device_data->dev, "%s: hash_save_state() failed!\n",
-				__func__);
-			goto out;
-		}
 	} while (msg_length != 0);
 out:
 
@@ -759,15 +736,7 @@ static int hash_dma_final(struct ahash_request *req)
 	dev_dbg(device_data->dev, "%s: (ctx=0x%lx)!\n", __func__,
 		(unsigned long)ctx);
 
-	if (req_ctx->hw_initialized) {
-		ret = hash_resume_state(device_data, &device_data->state);
-
-		if (ret) {
-			dev_err(device_data->dev, "%s: hash_resume_state() failed!\n",
-				__func__);
-			goto out;
-		}
-	} else {
+	if (!req_ctx->hw_initialized) {
 		ret = hash_setconfiguration(device_data, ctx);
 		if (ret) {
 			dev_err(device_data->dev,
@@ -858,13 +827,8 @@ static int hash_hw_final(struct ahash_request *req)
 		(unsigned long)ctx);
 
 	if (req_ctx->hw_initialized) {
-		ret = hash_resume_state(device_data, &device_data->state);
-
-		if (ret) {
-			dev_err(device_data->dev,
-				"%s: hash_resume_state() failed!\n", __func__);
-			goto out;
-		}
+		/* That's fine, result is in HW */
+		dev_dbg(device_data->dev, "%s hw initialized\n", __func__);
 	} else if (req->nbytes == 0 && ctx->keylen == 0) {
 		u8 zero_hash[SHA256_DIGEST_SIZE];
 		u32 zero_hash_size = 0;
-- 
2.36.1

