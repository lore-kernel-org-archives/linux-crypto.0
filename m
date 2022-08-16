Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4106C2BB41
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235892AbiHPODq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235855AbiHPOD1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:27 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B641BE
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:23 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id x19so15059473lfq.7
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=A70WX7DY4qkBKLEGBBQrXfzLaOJByga2AhTnjtGkloI=;
        b=ILxP7Y/jnoFu+RfOL3EGGDkSxVXMMS2ROa8dyVxCGlzk9BqX6QVdu/KGNigwWjtqE9
         x27h0f0CysmHYhXbVg38KsMjGUjhL7F97DYGzq6a5lwH1NvcyIe77Ico+AZOoJEuXj8k
         Texj9AajA5RlzquoSi5GKZQIAArelAd99nJX7QMU6J38iVE+e5RBi/eT5tq0GXcJjsqe
         vYlh7BDhcGKzFtSzSZVIdrJNpFfT4mz3HwWOGTvIQVEItUUlALYlzKw5XqSQqS9gSeOp
         6dknfEcDdr2w+XZ/L3vuyPr1pFt+xdo5N0MDAOrE/dW8Ez8vZ43UrCztCv8ZEFubcuhx
         OkOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=A70WX7DY4qkBKLEGBBQrXfzLaOJByga2AhTnjtGkloI=;
        b=AgVKRQsV0Au7zqxlH+bG6bbI+7l+RBMtqUy0ppIQYrFcXm4GaArlvSWskBlv6+qG3b
         rNnztOeIzS1+6XEGswDfgzSDA9qXAfjWkrU/emu/JfpGqRehwzmW636IVBl/x8XV2rnL
         14x2gB2URaUry0cF4LCnzOBHkR0PCpg32CA+nONiMFIo+B34ORInIZEWW9immm3NsPps
         0OoHpN1iAWnZrvxcdXWsh5eNutO21oVa6HokxQzM+9OCp55at+/PKWaIaqnZKHz7n1ge
         iPeZuz2Sa5ojxR+XERYpilE9hZQgzPVqA+M9LYe6bOnNvHzwklOJ6e1777wz4MxR21VC
         DwFQ==
X-Gm-Message-State: ACgBeo1aC9EHrWgZsv/pCvb3RyBleSW82SGztAfueVyZqy6FbYbmRopZ
        uYo2HiHwItBWIkZIqR0EiWdkYfIyWAiSLA==
X-Google-Smtp-Source: AA6agR4ECdixOwtqyQP3h7+yA6qBge6uWF2XSamZbE9VfMLZOEtIOwtoRKUtOOJuGfxalqOidLKkEA==
X-Received: by 2002:a05:6512:68e:b0:491:8971:9efa with SMTP id t14-20020a056512068e00b0049189719efamr5235069lfe.514.1660658600741;
        Tue, 16 Aug 2022 07:03:20 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:20 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 07/16] crypto: ux500/hash: Rename and switch type of member
Date:   Tue, 16 Aug 2022 16:00:40 +0200
Message-Id: <20220816140049.102306-8-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The "updated" member of the context is very confusing, it
actually means "hw_intialized" so rename it to this and
switch it to a bool so it is clear how this is used.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Rebased on v6.0-rc1
ChangeLog v1->v2:
- No changes
---
 drivers/crypto/ux500/hash/hash_alg.h  |  4 ++--
 drivers/crypto/ux500/hash/hash_core.c | 14 +++++++-------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index 00730c0090ae..d124fd17519f 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -336,12 +336,12 @@ struct hash_ctx {
  * @state:	The state of the current calculations.
  * @dma_mode:	Used in special cases (workaround), e.g. need to change to
  *		cpu mode, if not supported/working in dma mode.
- * @updated:	Indicates if hardware is initialized for new operations.
+ * @hw_initialized: Indicates if hardware is initialized for new operations.
  */
 struct hash_req_ctx {
 	struct hash_state	state;
 	bool			dma_mode;
-	u8			updated;
+	bool			hw_initialized;
 };
 
 /**
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index b559c53dc703..c5cd9a5f7e5c 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -449,7 +449,7 @@ static int ux500_hash_init(struct ahash_request *req)
 		ctx->keylen = 0;
 
 	memset(&req_ctx->state, 0, sizeof(struct hash_state));
-	req_ctx->updated = 0;
+	req_ctx->hw_initialized = false;
 	if (hash_mode == HASH_MODE_DMA) {
 		if (req->nbytes < HASH_DMA_ALIGN_SIZE) {
 			req_ctx->dma_mode = false; /* Don't use DMA */
@@ -674,7 +674,7 @@ static int hash_process_data(struct hash_device_data *device_data,
 			break;
 		}
 
-		if (req_ctx->updated) {
+		if (req_ctx->hw_initialized) {
 			ret = hash_resume_state(device_data,
 						&device_data->state);
 			memmove(req_ctx->state.buffer,
@@ -694,7 +694,7 @@ static int hash_process_data(struct hash_device_data *device_data,
 					__func__);
 				goto out;
 			}
-			req_ctx->updated = 1;
+			req_ctx->hw_initialized = true;
 		}
 		/*
 		 * If 'data_buffer' is four byte aligned and
@@ -759,7 +759,7 @@ static int hash_dma_final(struct ahash_request *req)
 	dev_dbg(device_data->dev, "%s: (ctx=0x%lx)!\n", __func__,
 		(unsigned long)ctx);
 
-	if (req_ctx->updated) {
+	if (req_ctx->hw_initialized) {
 		ret = hash_resume_state(device_data, &device_data->state);
 
 		if (ret) {
@@ -794,7 +794,7 @@ static int hash_dma_final(struct ahash_request *req)
 
 		/* Number of bits in last word = (nbytes * 8) % 32 */
 		HASH_SET_NBLW((req->nbytes * 8) % 32);
-		req_ctx->updated = 1;
+		req_ctx->hw_initialized = true;
 	}
 
 	/* Store the nents in the dma struct. */
@@ -857,7 +857,7 @@ static int hash_hw_final(struct ahash_request *req)
 	dev_dbg(device_data->dev, "%s: (ctx=0x%lx)!\n", __func__,
 		(unsigned long)ctx);
 
-	if (req_ctx->updated) {
+	if (req_ctx->hw_initialized) {
 		ret = hash_resume_state(device_data, &device_data->state);
 
 		if (ret) {
@@ -899,7 +899,7 @@ static int hash_hw_final(struct ahash_request *req)
 		goto out;
 	}
 
-	if (!req_ctx->updated) {
+	if (!req_ctx->hw_initialized) {
 		ret = init_hash_hw(device_data, ctx);
 		if (ret) {
 			dev_err(device_data->dev,
-- 
2.37.2

