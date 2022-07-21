Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52C90CCA479
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 13:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiGUNpd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:45:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiGUNoV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 09:44:21 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B35385D7A
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:13 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id u19so2927532lfs.0
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e5peYR0Efclqvks8gE1Xez5fN1UPbYUQQo+StiCfVL8=;
        b=Kedld5xfzBpCYIgbscjcyRNZ3LZV0mdUzdd6OPSW7bzd6LuE6vDnuwuCg3LsbsSbJf
         DXN1aFoKH0/H12BYIvjgSRqjCIw4HS5iAkLf4rKSkzC97aVVwmDt+qY9oakRzmaj1AEp
         u8AQzzAWfq+YIYe3HAZCVhKz6lDLwtHpa+XLzrn87KywTGLoFqmx0ig+KyxsQAE24hwo
         c3xSHcegT+h7bkjc0iNXJKnFFxWkWsBpYyGsWr1lPoZVfstm3CJjp7LzsvnzoK70R4ri
         WDSfx8iJALv2mOEvtvjt9CLFl2tgaHNlg1tRM1Ml3uEfzIZjiw2/PkOYYeH0tSQ4J8lP
         wjQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e5peYR0Efclqvks8gE1Xez5fN1UPbYUQQo+StiCfVL8=;
        b=2Y3G+8O4ajDA+X8oL7VX9tK2tricB7EThc9uaVh0b+XfrZCFfMYjP57VU30LzaClW9
         3j2KFUWIEZxGER7/e7uxvFK2+GINeCkxKgt42saR41GEcF/wy3wYOqHcgphb90LxLxxb
         Ku2aylVoGkEnhliLRBw0lxDCEqBliCN/55Iz4NtiewjLLzyviQgl1p2049cZ5UG9YaVP
         e9qiz/JQGVp4POg7Ndvo1FaX9QF4REPbrAvC7h1zFq2x0i5Q98bOxQtWZWec9egFgdEx
         HRQNL4LOHKGITS6lYhtMv8nJ8yeabB/3ANUOv301ZYbXnuSAOyU24NC9juX3B2bHaA8K
         2s2Q==
X-Gm-Message-State: AJIora9hmq2RCQHGT5cGMQpLlAbyHsn7ymn/uzrGRuBMomB8seOV1KE2
        0ixxGzoG4vH8NNtMEOL3DchcOgRY5sLNlw==
X-Google-Smtp-Source: AGRyM1uBbJ1+R25sHXBzgNaAD8lR6mxDELXe22s0Ubvae8UDFz1KKJ/fxOZezmd7xEkEzob6fmfjoQ==
X-Received: by 2002:a05:6512:32c9:b0:48a:2a34:1f53 with SMTP id f9-20020a05651232c900b0048a2a341f53mr14142009lfg.335.1658410988152;
        Thu, 21 Jul 2022 06:43:08 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o23-20020ac24e97000000b004867a427026sm458568lfr.40.2022.07.21.06.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:07 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 09/15] crypto: ux500/hash: Get rid of state from request context
Date:   Thu, 21 Jul 2022 15:40:44 +0200
Message-Id: <20220721134050.1047866-10-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The request context is exactly for that: context state related
to the request. The code was (ab)using the state used to store
the hardware state for this. Move out the three variables from
the hardware state to the request context and clean up the
mess left behind.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/ux500/hash/hash_alg.h  | 21 +++++++--------
 drivers/crypto/ux500/hash/hash_core.c | 38 +++++++++++----------------
 2 files changed, 26 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/ux500/hash/hash_alg.h b/drivers/crypto/ux500/hash/hash_alg.h
index d9d59dba6e6e..5aa86c4855f5 100644
--- a/drivers/crypto/ux500/hash/hash_alg.h
+++ b/drivers/crypto/ux500/hash/hash_alg.h
@@ -214,17 +214,10 @@ struct hash_register {
  * @csr[52]:	HASH Context Swap Registers 0-39.
  * @csfull:	HASH Context Swap Registers 40 ie Status flags.
  * @csdatain:	HASH Context Swap Registers 41 ie Input data.
- * @buffer:	Working buffer for messages going to the hardware.
- * @length:	Length of the part of message hashed so far (floor(N/64) * 64).
- * @index:	Valid number of bytes in buffer (N % 64).
  *
  * This structure is used between context switches, i.e. when ongoing jobs are
  * interupted with new jobs. When this happens we need to store intermediate
  * results in software.
- *
- * WARNING: "index" is the  member of the structure, to be sure  that "buffer"
- * is aligned on a 4-bytes boundary. This is highly implementation dependent
- * and MUST be checked whenever this code is ported on new platforms.
  */
 struct hash_state {
 	u32		temp_cr;
@@ -233,9 +226,6 @@ struct hash_state {
 	u32		csr[52];
 	u32		csfull;
 	u32		csdatain;
-	u32		buffer[HASH_BLOCK_SIZE / sizeof(u32)];
-	struct uint64	length;
-	u8		index;
 };
 
 /**
@@ -333,13 +323,22 @@ struct hash_ctx {
 
 /**
  * struct hash_ctx - The request context used for hash calculations.
+ * @buffer:	Working buffer for messages going to the hardware.
+ * @length:	Length of the part of message hashed so far (floor(N/64) * 64).
+ * @index:	Valid number of bytes in buffer (N % 64).
  * @state:	The state of the current calculations.
  * @dma_mode:	Used in special cases (workaround), e.g. need to change to
  *		cpu mode, if not supported/working in dma mode.
  * @hw_initialized: Indicates if hardware is initialized for new operations.
+ *
+ * WARNING: "index" is the  member of the structure, to be sure  that "buffer"
+ * is aligned on a 4-bytes boundary. This is highly implementation dependent
+ * and MUST be checked whenever this code is ported on new platforms.
  */
 struct hash_req_ctx {
-	struct hash_state	state;
+	u32			buffer[HASH_BLOCK_SIZE / sizeof(u32)];
+	struct uint64		length;
+	u8			index;
 	bool			dma_mode;
 	bool			hw_initialized;
 };
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index c2e8bd977f57..46dad128b6fe 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -448,7 +448,9 @@ static int ux500_hash_init(struct ahash_request *req)
 	if (!ctx->key)
 		ctx->keylen = 0;
 
-	memset(&req_ctx->state, 0, sizeof(struct hash_state));
+	req_ctx->index = 0;
+	req_ctx->length.low_word = 0;
+	req_ctx->length.high_word = 0;
 	req_ctx->hw_initialized = false;
 	if (hash_mode == HASH_MODE_DMA) {
 		if (req->nbytes < HASH_DMA_ALIGN_SIZE) {
@@ -553,11 +555,11 @@ static void hash_messagepad(struct hash_device_data *device_data,
  */
 static void hash_incrementlength(struct hash_req_ctx *ctx, u32 incr)
 {
-	ctx->state.length.low_word += incr;
+	ctx->length.low_word += incr;
 
 	/* Check for wrap-around */
-	if (ctx->state.length.low_word < incr)
-		ctx->state.length.high_word++;
+	if (ctx->length.low_word < incr)
+		ctx->length.high_word++;
 }
 
 /**
@@ -872,9 +874,9 @@ static int hash_hw_final(struct ahash_request *req)
 		}
 	}
 
-	if (req_ctx->state.index) {
-		hash_messagepad(device_data, req_ctx->state.buffer,
-				req_ctx->state.index);
+	if (req_ctx->index) {
+		hash_messagepad(device_data, req_ctx->buffer,
+				req_ctx->index);
 	} else {
 		HASH_SET_DCAL;
 		while (readl(&device_data->base->str) & HASH_STR_DCAL_MASK)
@@ -922,8 +924,8 @@ int hash_hw_update(struct ahash_request *req)
 	struct crypto_hash_walk walk;
 	int msg_length;
 
-	index = req_ctx->state.index;
-	buffer = (u8 *)req_ctx->state.buffer;
+	index = req_ctx->index;
+	buffer = (u8 *)req_ctx->buffer;
 
 	msg_length = crypto_hash_walk_first(req, &walk);
 
@@ -931,10 +933,10 @@ int hash_hw_update(struct ahash_request *req)
 	if (msg_length == 0)
 		return 0;
 
-	/* Check if ctx->state.length + msg_length
+	/* Check if ctx->length + msg_length
 	   overflows */
-	if (msg_length > (req_ctx->state.length.low_word + msg_length) &&
-	    HASH_HIGH_WORD_MAX_VAL == req_ctx->state.length.high_word) {
+	if (msg_length > (req_ctx->length.low_word + msg_length) &&
+	    req_ctx->length.high_word == HASH_HIGH_WORD_VAL_MAX) {
 		pr_err("%s: HASH_MSG_LENGTH_OVERFLOW!\n", __func__);
 		return crypto_hash_walk_done(&walk, -EPERM);
 	}
@@ -955,9 +957,9 @@ int hash_hw_update(struct ahash_request *req)
 		msg_length = crypto_hash_walk_done(&walk, 0);
 	}
 
-	req_ctx->state.index = index;
+	req_ctx->index = index;
 	dev_dbg(device_data->dev, "%s: indata length=%d\n",
-		__func__, req_ctx->state.index);
+		__func__, req_ctx->index);
 
 	return 0;
 }
@@ -980,14 +982,6 @@ int hash_resume_state(struct hash_device_data *device_data,
 		return -EPERM;
 	}
 
-	/* Check correctness of index and length members */
-	if (device_state->index > HASH_BLOCK_SIZE ||
-	    (device_state->length.low_word % HASH_BLOCK_SIZE) != 0) {
-		dev_err(device_data->dev, "%s: HASH_INVALID_PARAMETER!\n",
-			__func__);
-		return -EPERM;
-	}
-
 	/*
 	 * INIT bit. Set this bit to 0b1 to reset the HASH processor core and
 	 * prepare the initialize the HASH accelerator to compute the message
-- 
2.36.1

