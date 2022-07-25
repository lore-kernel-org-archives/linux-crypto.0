Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807ECCCA473
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Jul 2022 14:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235358AbiGYOIC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Jul 2022 10:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235311AbiGYOHl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Jul 2022 10:07:41 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4040717054
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:36 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id by8so13234614ljb.13
        for <linux-crypto@vger.kernel.org>; Mon, 25 Jul 2022 07:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f/vbPkNKKbkjJjRwGJUOoxcfcoJSh1/50auwny6lijM=;
        b=ygR5yI4yLkEw91pK3Zuyntm9mWwzok7jYknAlg00Gb60IwA+HqI7ez7sn8KMEm2wbS
         vo1sFTF/qSsSJeH0yCDjsXxqoKFSizsVGR4pwYLpwrSe1NC7hxxPtnyKEuA5v1iThfxo
         t5/Aso14HYPsamjcem4xtmQGk/HsxVjGkb3LZM27s0Q+7B+3IFp92lwF51HgFzk3Y24v
         N5Gc/bm0RKekHRmyQfLgKcSEVJOwBefBx+c9CDaO3qPuaTC35m8BIENmRB4F8Ry6pX4M
         XknAT0PDVv/KaB/mg+E7uULlirB3qbh3fMo0v5g8q7KPkoqV84qTu8f6NVvWPPOuQQoG
         TiHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f/vbPkNKKbkjJjRwGJUOoxcfcoJSh1/50auwny6lijM=;
        b=aJFlSDNSJJQtbnN5ZkjFErHp3SpNyAuojUqg8kCRHuUu6r7hNpjshPbhX7FzdUg+e6
         5N+jUFePpdayxeuUk0U4MO+zBxlgCLJVwIF+zzPivUYnScgVne0pQia/pJTTpbquE00D
         JGbsShsXiX4e79j6cg0RrVX07QdD6tOlZmpNJpZpm4/XmjQukioQNVXX+3TFkgzmzWXv
         Sz30aaHMyOMChMYs+X1CAgk0bsax1OcdQER4AedxAoK7yIny6IpilfX/so7VhWbNzYWb
         ZGYKQ5xcXIzFdUJeDrYYiDdrd9TVLlWoF/S7oSB7qmQvN9Y04GgmIPaA9iaZ9OE8nFRv
         6JhA==
X-Gm-Message-State: AJIora8zTr/tc2wEyP5RspgZpuHyEW2QQdXTbvx7g1NBz7lnUUQyRVeR
        nIGH6jlFg+F5Kwod/Mja0mdUI6eTkaVdqg==
X-Google-Smtp-Source: AGRyM1tlVocaOXGBmAUJjTtSoTV1/vY6C+4qoaq0mflIUvRWTwEBbDnxfqq2kPY13ZWsVUTxYCZypg==
X-Received: by 2002:a05:651c:178f:b0:25d:ba24:2e98 with SMTP id bn15-20020a05651c178f00b0025dba242e98mr4288019ljb.197.1658758055508;
        Mon, 25 Jul 2022 07:07:35 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o7-20020a05651205c700b0047f7419de4asm901127lfo.180.2022.07.25.07.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 07:07:35 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 11/15 v2] crypto: ux500/hash: Drop custom uint64 type
Date:   Mon, 25 Jul 2022 16:05:00 +0200
Message-Id: <20220725140504.2398965-12-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220725140504.2398965-1-linus.walleij@linaro.org>
References: <20220725140504.2398965-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop the homebrewn uint64 support, the kernel has a u64 type
that works just fine so we use that instead.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- No changes
---
 drivers/crypto/ux500/hash/hash_alg.h  | 19 ++----------------
 drivers/crypto/ux500/hash/hash_core.c | 28 ++++-----------------------
 2 files changed, 6 insertions(+), 41 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index 05f0b0221a13..6a610c83e63d 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -16,9 +16,6 @@
 #define HASH_DMA_PERFORMANCE_MIN_SIZE	1024
 #define HASH_BYTES_PER_WORD		4
 
-/* Maximum value of the length's high word */
-#define HASH_HIGH_WORD_MAX_VAL		0xFFFFFFFFUL
-
 /* Power on Reset values HASH registers */
 #define HASH_RESET_CR_VALUE		0x0
 #define HASH_RESET_STR_VALUE		0x0
@@ -135,18 +132,6 @@ enum hash_mode {
 	HASH_MODE_DMA
 };
 
-/**
- * struct uint64 - Structure to handle 64 bits integers.
- * @high_word:	Most significant bits.
- * @low_word:	Least significant bits.
- *
- * Used to handle 64 bits integers.
- */
-struct uint64 {
-	u32 high_word;
-	u32 low_word;
-};
-
 /**
  * struct hash_register - Contains all registers in ux500 hash hardware.
  * @cr:		HASH control register (0x000).
@@ -227,7 +212,7 @@ struct hash_state {
 	u32		csfull;
 	u32		csdatain;
 	u32		buffer[HASH_BLOCK_SIZE / sizeof(u32)];
-	struct uint64	length;
+	u64		length;
 	u8		index;
 	bool		dma_mode;
 	bool		hw_initialized;
@@ -342,7 +327,7 @@ struct hash_ctx {
  */
 struct hash_req_ctx {
 	u32			buffer[HASH_BLOCK_SIZE / sizeof(u32)];
-	struct uint64		length;
+	u64			length;
 	u8			index;
 	bool			dma_mode;
 	bool			hw_initialized;
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 1edb11812c7d..390e50b2b1d2 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -449,8 +449,7 @@ static int ux500_hash_init(struct ahash_request *req)
 		ctx->keylen = 0;
 
 	req_ctx->index = 0;
-	req_ctx->length.low_word = 0;
-	req_ctx->length.high_word = 0;
+	req_ctx->length = 0;
 	req_ctx->hw_initialized = false;
 	if (hash_mode == HASH_MODE_DMA) {
 		if (req->nbytes < HASH_DMA_ALIGN_SIZE) {
@@ -545,23 +544,6 @@ static void hash_messagepad(struct hash_device_data *device_data,
 		cpu_relax();
 }
 
-/**
- * hash_incrementlength - Increments the length of the current message.
- * @ctx: Hash context
- * @incr: Length of message processed already
- *
- * Overflow cannot occur, because conditions for overflow are checked in
- * hash_hw_update.
- */
-static void hash_incrementlength(struct hash_req_ctx *ctx, u32 incr)
-{
-	ctx->length.low_word += incr;
-
-	/* Check for wrap-around */
-	if (ctx->length.low_word < incr)
-		ctx->length.high_word++;
-}
-
 /**
  * hash_setconfiguration - Sets the required configuration for the hash
  *                         hardware.
@@ -709,7 +691,7 @@ static int hash_process_data(struct hash_device_data *device_data,
 					  (const u32 *)buffer,
 					  HASH_BLOCK_SIZE);
 		}
-		hash_incrementlength(req_ctx, HASH_BLOCK_SIZE);
+		req_ctx->length += HASH_BLOCK_SIZE;
 		data_buffer += (HASH_BLOCK_SIZE - *index);
 
 		msg_length -= (HASH_BLOCK_SIZE - *index);
@@ -933,10 +915,8 @@ int hash_hw_update(struct ahash_request *req)
 	if (msg_length == 0)
 		return 0;
 
-	/* Check if ctx->length + msg_length
-	   overflows */
-	if (msg_length > (req_ctx->length.low_word + msg_length) &&
-	    req_ctx->length.high_word == HASH_HIGH_WORD_VAL_MAX) {
+	/* Check if ctx->length + msg_length overflows */
+	if ((req_ctx->length + msg_length) < msg_length) {
 		pr_err("%s: HASH_MSG_LENGTH_OVERFLOW!\n", __func__);
 		return crypto_hash_walk_done(&walk, -EPERM);
 	}
-- 
2.36.1

