Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8343CC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235329AbiGYOHr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235333AbiGYOHe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:07:34 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46A9414D35
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:33 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id a13so13080820ljr.11
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C6S3uKvTAP+Cp0+QHVaCOI5oR5HoGiw3zJjt6sISzSU=;
        b=yTVzpWenvwRkWoozJxMrX1G2Siyp5l8lHkNgDuuxKQTs0WDKiCSxJqCXzVRDMz+mwA
         7Cbg2sfEMF5q9Nmz6q6yafvsoW5xXKgXWKnJ6fG90RHn7Kew1Y6ho5z7crhoHPadpjsL
         m2gjHyk8WZrOpgykW7W0s4kFhPhViFe+ADajhpDOomE6v0EnCoyYDR0TcrOgQVdsThvZ
         pnBCsl1r6MPKdTsGzYZcsLkB6o43iudjstrajruGG1dOBxnAUzfQFFcuqORdEEXw6Xuc
         NhlKHTahomNq2+eBF6kmiHgvijZy+OfFv5v6hXKY347t9n3wbmBtsbjgidTVyUY2lGe5
         Wqrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C6S3uKvTAP+Cp0+QHVaCOI5oR5HoGiw3zJjt6sISzSU=;
        b=bQWtzYtotqu1z0jKi1lqa43DgwBqE6DDcXlOuHGvwHjYU9dpRRDw4mE5OnhyH6g0gz
         r/EREQUCSNoOSaKphQ5iF12KC18pr+Z9GoYeOO2OOyVyUAIaFX66VMHDa97RNCW1j6t7
         jKl8aQQF/Fw2OX2IIQ1vLvMG/UJg/oOyXApQ3Cu/z8JDLifW7y5X8k6ZYsmgg5XprZbR
         aaLXyY9ZVCvkEfflODyccoifAffYR+Eq9CTJ9A21O5E/GDMPseVOG6u3cbzoLgHxpF5O
         /rLw0ztrFJM7++sHlb/+hVHkkf3E2hfrTVW8GWzmzPJ9PMnTNeEOmXbp0nLwxiJ8UTIV
         Ij1g==
X-Gm-Message-State: AJIora/5RkiWTg4/gQxr6xvk9gfSP4UIXJtXk8yHQl9xx3n9oecw8njQ
        nPZGhTq5u7q8qphuIA75x7Eqfk9S8KeNWA==
X-Google-Smtp-Source: AGRyM1v6m9uG8KrasSYT71mXP4rd8Zh4mfRM7XRxUrJXE/q+b9w2l5/yQxgs+EkYgpzxrZbJJuVFcg==
X-Received: by 2002:a2e:5705:0:b0:25d:f295:c9d8 with SMTP id l5-20020a2e5705000000b0025df295c9d8mr4528319ljb.292.1658758051314;
        Mon, 25 Jul 2022 07:07:31 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b0047f7419de4asm901127lfo.180.2022.07.25.07.07.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:07:31 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 08/15 v2] crypto: ux500/hash: Stop saving/restoring compulsively
Date:   Mon, 25 Jul 2022 16:04:57 +0200
Message-Id: <20220725140504.2398965-9-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725140504.2398965-1-linus.walleij@linaro.org>
References: <20220725140504.2398965-1-linus.walleij@linaro.org>
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

