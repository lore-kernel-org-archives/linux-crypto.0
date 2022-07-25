Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D75FACCA48C
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235342AbiGYOHf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235276AbiGYOHc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:07:32 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4A115FCC
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:30 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id by8so13234297ljb.13
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V9qbu9pBS7+3W8ZYo1R9wg6Idr81jkbRlVfnq4Xdegw=;
        b=vcRKkgvDyoN9zjH5gsnY0vT7d2/dQODfvaY75B23jv/5Yq7u89OyepPanfnm/SNh1J
         7oR8WBwPscK2aDXI8Xme3XmsDFahek5EozjdqCin+5luNi28zQn6WhKt5VstNq/XEDUC
         AyQoD57RP9/yOTqdpqX4SShnAT2IB4/FeKPgBvKL8xHFf3aFp0BCclIyghbGSJ5phJsn
         3ALdUyw5sK78yk+LAI/ZJvTJWYdsoNvyoGqperpMKceBv5LfzVoXqavQNKjbnNj+9BXW
         /FKY/Q3uLV80pjxPswajCp4NuLtW5yOx517Mk5bFBo564lCR264WSdbTPq7XGx4c8daH
         q1yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V9qbu9pBS7+3W8ZYo1R9wg6Idr81jkbRlVfnq4Xdegw=;
        b=d2+l1YxdzMGnnoPtkF55dnNaHq+sCk3aw4P68B0r9wGbquPSJ6LdUE4GlqZ5tsmtcl
         uNqsCNIm5L+S1kIoti4FeKlAmJyWQJ4gTnxwkGkkkPu9533B6UCcVQ5tEf6i0uRPACCf
         2k3n9+NdnO/bS/wWCEsFgqmE9Kn5ggn3clJ2iUw3wOvuJUc29SRk8kgH9g7rilLtOcnE
         stha9gT1bCD79BEpxKp/vfPBwUhrHTgpL1xYZgTiAjr/ULRDZElI7jecIWQMaHPFd4HW
         sIvudbJMR0s9VZkZiT9Q4KzFK8orLaJRHcvjhDILyB2RVD31J8QXKC/hHgnEYspKCShz
         M2jw==
X-Gm-Message-State: AJIora8vKUuIFyEAaopwr4QMFuNdUPmhqSlCldoy3s5nu7obQcybrBzC
        RoFzcSZFLMvh16BZ0PA137EDs0HW3JFbtw==
X-Google-Smtp-Source: AGRyM1uJcrN5AaY3eNHSIYIIu7YgnA1QC0+LcgDImVrnSpq+aBtQMWFzenZf0xxVwEhmPJon/wdVCg==
X-Received: by 2002:a2e:938c:0:b0:25d:f714:52e8 with SMTP id g12-20020a2e938c000000b0025df71452e8mr4015661ljh.454.1658758050037;
        Mon, 25 Jul 2022 07:07:30 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b0047f7419de4asm901127lfo.180.2022.07.25.07.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:07:29 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/15 v2] crypto: ux500/hash: Rename and switch type of member
Date:   Mon, 25 Jul 2022 16:04:56 +0200
Message-Id: <20220725140504.2398965-8-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725140504.2398965-1-linus.walleij@linaro.org>
References: <20220725140504.2398965-1-linus.walleij@linaro.org>
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
index c9ceaa0b1778..b3649e00184f 100644
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
2.36.1

