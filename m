Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE2FC433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 13:45:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiGUNpW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:45:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230170AbiGUNns (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 09:43:48 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891D684EDE
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:11 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id y11so2858446lfs.6
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wnw+J8g0tiBhDzUiau+rb2PQi3V9NPBPTs3vvmSimvA=;
        b=C/30z5ieecqUehs+DRtzuPB5/G+kSizttIIaABkDKMpSlvs4oOY1lTItvwUZitY155
         JVT3fUHSfI/Sp4/5r8SP3STvPr3jM0AF6srfDc4GDa0ajcjgBlWvN90meerLs2EReuMp
         jJr/c+jdMTCvFfzhRe03l6Ez8a0wKMmKzHu2N/PBChSQsSYva4SfJrwCEOPA6PrKVYTg
         C2o/qoIacYS6dC/N3mfIgR3vi9J43lNccyIhOEUMGbJDlbXn3nksw0/HFrFB9ITYBILe
         ReqRy9ETf9hZVxKkLG0dCX8DiDtzNJ6gb2TGygeeVIH7dApKtFFiBeL71vH5WoqKiyxf
         HaDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wnw+J8g0tiBhDzUiau+rb2PQi3V9NPBPTs3vvmSimvA=;
        b=1hK7OazHykZOI870quKK7EKSJJng9WadTqnOolrwNSu/9WI3z5hZ9vR+hoazVZf3G6
         oLzYTSTiu4EGf0MFFrtO/YsZLxY59a/w8sEskKJiWVsJf0c7H57JI1rtnMmX0pOyedT7
         ECsV50RYou9waMfRC0FkTCGvjopAJjJ/2JiSfYOxjTtJYH62vUM81SA+N4+FwYhJ8XfQ
         end4ZPAqFNrK/bU6at3VhBxUdorTVh6mwaXvELK1ZDolBL6qVnssDXkRUF/O9gwWskFK
         GLQhX/itHj2wiZP8ybspQ4VGwb8q7B1uS/86T4DDclbEPtwtbJ6AnncXF/0q/Hj0HWCs
         V+Wg==
X-Gm-Message-State: AJIora+qWTTrD1JHY3OoIf0ISVKJrJRfsUdscF/pUqoJEZxVW28zK+jN
        u+05eXqeGbwVesc5crlRYMIqY4UZlAWCGg==
X-Google-Smtp-Source: AGRyM1up3uDJL+F6wFXlokobzv+BfbbhHSmmnKFXtK5/UNG931oQbQMPOjvf5vm/UJcpy9mbBjZG+A==
X-Received: by 2002:a05:6512:3b27:b0:489:e87e:c1ef with SMTP id f39-20020a0565123b2700b00489e87ec1efmr22562535lfv.490.1658410990833;
        Thu, 21 Jul 2022 06:43:10 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o23-20020ac24e97000000b004867a427026sm458568lfr.40.2022.07.21.06.43.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:10 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 11/15] crypto: ux500/hash: Drop custom uint64 type
Date:   Thu, 21 Jul 2022 15:40:46 +0200
Message-Id: <20220721134050.1047866-12-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop the homebrewn uint64 support, the kernel has a u64 type
that works just fine so we use that instead.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
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

