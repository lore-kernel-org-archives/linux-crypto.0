Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B150C3F6B0
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Aug 2022 14:04:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbiHPOEC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Aug 2022 10:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbiHPOD3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Aug 2022 10:03:29 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AB34E61E
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:25 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id v10so10614671ljh.9
        for <linux-crypto@vger.kernel.org>; Tue, 16 Aug 2022 07:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=f68TJS9tWewQng2Ircr9iqi3OUtPf1sdFQxnP/ggvg0=;
        b=Jv+zyXB9Btp4l8yOnrbTFTXtyWE0UgiP0VeEphicL6m79Xt6YlXHzzjg1R5dPZlzbq
         4tPRIe7Jx1xKARZjoQr8mV+07uRKo93YUVAfB6rzfvCKcslG3jsAV9Dao2pYp4+pWTN4
         MDxNYh+t1o7Ljpe2lEiv4tvy5R3pPC/MUv0W48d1zZSGXEtzDZOkG11DgktCgZ8onj2f
         k/FOPUTQHg8rz8uZALohZVL74ymbvoo20ZPIkb3i1cvUdkVqoAIAdJkKO5/vq4F8SSJr
         pyoY8UWIrN+wkWsEiFBIcraZt+i2vyCTCUosG5sDZS7ykLsR5g7tr8XHzVeB61brTZsc
         G4wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=f68TJS9tWewQng2Ircr9iqi3OUtPf1sdFQxnP/ggvg0=;
        b=U6mnX2c52K2b3sZ5h1YIoq0VBR3A97IYgVdrIwimAyO8mUvzhmbDZ3+MhoEF7AFHmA
         3XdPYrkCrCgQfVaUFkf9J4ShDHqo3M/9BdFwN94G1oBbbEJIPQ8jSnvdyDCbK3hcysu5
         Vrq2qXdaKJzmW0cF8IQgY/Guj8nlEGXRVbk360MBBhYUdzPveXkjL8d2hRz/4wnrq6uw
         S5UmUize8s3Uskqwbvvs0WPtyMPEt8DVKezJZUw6EOQaM/UYteyRqNIvEKEfOqbM/izK
         eNpNPiwgStgkHXGwpD/Q4XEKZPp4AzsCSd8ZkRO6KsgSzk5CzgpenD72v83H3dFI3xe8
         39qQ==
X-Gm-Message-State: ACgBeo2KYu0p8HXFgxeyYifp/W/qk5lx2aCeq7kfn+hhodowArVSHS5p
        DD2XVKB2m+enAQrk0Sc9M9Yyvi5I/2GuUA==
X-Google-Smtp-Source: AA6agR4iyi8FdDgdIoLxUH9IWcb5UhAzz9r9NE6oygK59fMXBpEElClGOssGNm9S704WDVQK0AO0/A==
X-Received: by 2002:a2e:9254:0:b0:25e:4f20:8d3a with SMTP id v20-20020a2e9254000000b0025e4f208d3amr6932991ljg.233.1660658603339;
        Tue, 16 Aug 2022 07:03:23 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id r27-20020a2eb61b000000b0025e739cd9a7sm1747902ljn.101.2022.08.16.07.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 07:03:23 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3 09/16] crypto: ux500/hash: Get rid of state from request context
Date:   Tue, 16 Aug 2022 16:00:42 +0200
Message-Id: <20220816140049.102306-10-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220816140049.102306-1-linus.walleij@linaro.org>
References: <20220816140049.102306-1-linus.walleij@linaro.org>
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
ChangeLog v2->v3:
- Rebased on v6.0-rc1
ChangeLog v1->v2:
- No changes
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
index 844ef70301d5..c55f35b366be 100644
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
2.37.2

