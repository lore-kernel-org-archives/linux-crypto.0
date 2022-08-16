Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3485BC2BB41
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235852AbiHPODn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235851AbiHPOD0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:26 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFEB1B9
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:22 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id y23so10602778ljh.12
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=vE+aW0nyiBU1fJkWezdCMzH7B9Qn6/AKvNwg7L28u/U=;
        b=axPyiZ0bm5BhK8rVP2fWFI6tyueVMbMoQryKim0gXmddKeN3IkzpqTzcP8z7z5mFQH
         N8Vkg2hoDCMQTRW3IRmf1vmhwO+aon0ayqYFHnjLHKtCoqePAdW1SRjcDSgXo//co24W
         z0zGwZynTreXv+mUlfdr9o9wd/m6v4El7LhVh4vnAZor6dHtrPJI545nruJcMLoP2Z5K
         I5XviAwCeUksPSJH8xb+ArlPEX04idtZoITuDwOBj/BdMzn3UEi3egbubC3N0MQqnQuK
         PERbKjtLkT8WRF8Uy1ovm1tf1a+HTP7PYWR3ujImX68PKFlLnYO1Ra3DILE33o+cTWVz
         eiNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=vE+aW0nyiBU1fJkWezdCMzH7B9Qn6/AKvNwg7L28u/U=;
        b=28uNLYx0jMJrTS184N7TesK5wTPyGIKfpiSLbdCSguYaL97TEnVx8LyydnTpFwAsf6
         DIBvekIeqCWBdlLk/o95KKnE2A8z/cMb8x61jPWtkO17v/p22yby1DBVoexgKT7lha6f
         7UTwszmMLBRCke4lnltAowREBPwHnh6Crm7UgA9NEHqdsinbUyT8tQg1/+NO8rbCtMBP
         e+/L22D8wN/zrKe/5l1wKjQOj2bZEiFbTNbWdL4oFEA0TStXrA3OaN64mjKi4mWlr4uD
         th/ysPB48s8VkBDocU7uN7bIwQVKT+Uxm04YHNM3ky5VmZjTBD3MGOfJRTRhcE9LtoU6
         jvpA==
X-Gm-Message-State: ACgBeo3s0t1dUgrF4pjBtvR2X1qfR3bxGGpNOpYRxRLXK0QPm6d8kSok
        6r3BEVHje2sq/qMmZFjYSSNMijUV3kO3iA==
X-Google-Smtp-Source: AA6agR7bykuYD9HHvkyQiRgpFBqN6f8Jv3eezb1aU7GXT/eOBOWJ7GJNC9nzWdXwUN8416J16/cKXQ==
X-Received: by 2002:a2e:a7c8:0:b0:25e:792a:6fa8 with SMTP id x8-20020a2ea7c8000000b0025e792a6fa8mr6594019ljp.398.1660658602053;
        Tue, 16 Aug 2022 07:03:22 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:21 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 08/16] crypto: ux500/hash: Stop saving/restoring compulsively
Date:   Tue, 16 Aug 2022 16:00:41 +0200
Message-Id: <20220816140049.102306-9-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
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
ChangeLog v2->v3:
- Rebased on v6.0-rc1
ChangeLog v1->v2:
- No changes
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
index c5cd9a5f7e5c..844ef70301d5 100644
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
2.37.2

