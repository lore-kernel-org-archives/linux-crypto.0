Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCA68C25B0E
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235926AbiHPOEI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235879AbiHPOD3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:29 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203296B141
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:27 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id f20so15051961lfc.10
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=0bbDdce5gaqck7gjD3V4/vgwIpyzTmf0xP/GcVB/qg0=;
        b=iXRPGFTUiQ7SA/TpFgZM6Y8lAjxpMUrpFPLQj/KN9Oi16VdpPoju7+7wn7zhs9ZGZ0
         qKX5hGFFLay6nHNizBHoTuJ4ak50xxbpWQjZK6lzUbiK1rRRg1hbm3YSFnws91PlKAnj
         1QARn9Xmm9dFgd/wYIfu8+HcJ5PTU834Qyz9HzhdNiIzhDoKem0I+5fcW5DOMXDVC05x
         p8uNeTetjE/gv1/7aEahT2VHzKYpGouygruykvjQApvjwERuReoVn1qsbauot6p806gz
         /ytSm6NLeIYTyy8NnW5u8lhECE1KECxXfQMH2u2njNZAhNAv8Xli08NN95B8rXzRAvKa
         Htog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=0bbDdce5gaqck7gjD3V4/vgwIpyzTmf0xP/GcVB/qg0=;
        b=Sob+3sRhvHumc1kjfRzMX7NCRq4v1gthdccpRUhAVwOs/wJEdYdOpt+e3E8kb+7kum
         ROg3vjB1lor8L8L0DsrmV4zzCQO9VEJHbQP0sPN4Yn3dr8jHjy8p58DLONN9vn9/wZ29
         ORZRUyE0oJZOtOV2psHzKS6NzQljRJWrdFZaFTNQCdyfLq197RFTVIOWMufWyB1ADUJj
         7oyN+lK4PBLoX5cfVFM4PNDGUCqQ2Y1Mw7fjzKK4f2+hrjMD+ByndhYXwBu9vSFN768S
         7bs++Qgap2Ya0LWYg4arRIaT5hGlvOpCl4OuLcjXLiADGNicUW+b0I+R5rRup3Bx/oz5
         N9Ew==
X-Gm-Message-State: ACgBeo2FX6ifLxZkoijiJJkTzqJdqNE7wbMei9bTKRJbz7JjqIKIp+t5
        H7HYn44Py6K7UQolYA2zI8SwTl+HGDmFdQ==
X-Google-Smtp-Source: AA6agR5IknY7XRE8Tl46q9vwQWFwpcY9hN4EEToXrBpaURtE3nmrw/NjhWf9/CRu6OnNKCBaIqXOLA==
X-Received: by 2002:a05:6512:3d18:b0:48d:244d:2120 with SMTP id d24-20020a0565123d1800b0048d244d2120mr7040062lfv.387.1660658606127;
        Tue, 16 Aug 2022 07:03:26 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:25 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 11/16] crypto: ux500/hash: Drop custom uint64 type
Date:   Tue, 16 Aug 2022 16:00:44 +0200
Message-Id: <20220816140049.102306-12-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Drop the homebrewn uint64 support, the kernel has a u64 type
that works just fine so we use that instead.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Rebased on v6.0-rc1
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
index c8771839ec8e..5fe0720cb1f5 100644
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
2.37.2

