Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B3E1C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Jul 2022 13:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiGUNpH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Jul 2022 09:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiGUNnp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Jul 2022 09:43:45 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C611484EF6
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:07 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id d17so702425lfa.12
        for <linux-crypto@vger.kernel.org>; Thu, 21 Jul 2022 06:43:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HhpllRtGPyfYOFcVtALeo5Lim/8BCK7aMQ+o6IB1CCg=;
        b=SZiw2hljtgz/Tefp0Hm6SFpl31k3xFjh7vFkzR+iXOshIvlv2qWr0YysSjp8+Qb3zE
         juX6pgNSbVi+Gb+VObjbT69nq25tMCn6xDqn3yay42QpTezLdiEqSEvp/HBE+VeMgoFn
         u97mcz5XAJWnFQdXgJw8vi/m/phCJi3j0OszgqGGskBc0Z44cw7YW6JaLXk4hVuyEPm6
         Pqz8W/VSG3GCGoaZWvNGIBiMLeOcbaKJ7/w2rVmRPi5XTWWgovR6s8kHczlAfntzMSnm
         4V6NcKx5ZG3p3OXjqriiqBqFkqquf7itTRhqbAdffUSds01qHvOUnvHw7DA+wGIslDCn
         eU4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HhpllRtGPyfYOFcVtALeo5Lim/8BCK7aMQ+o6IB1CCg=;
        b=PcNrV/JiJazx/thpSt1764nVuT+hWFWBnR1EhZke4MlU9wL1+oreAixwDH9P/kBFEX
         JIvZlFxWZBdVGHvhzGo95mB0NfJBUb+g3OSD8kzAjKiBa6U7MJ/YPGW0n2iuqg0HY9e9
         /mX/w53L/jc+cZvCdgO0oNGWFvDnss71cHNNkWJZuJ0NEpo7iJ5kv5hHh8R15Jq6aOnw
         EbEUcyvtgNniUy01rvYLYDEBe9vEZTeuXO9uSUvlyxqUz6oB5v0v1WuIPcTzmawAWfjd
         kvDW3TZnvzHM+P7WypoCNNefEAacC1oEGKWIxRXxZKdsUO+AZdHzOnki5pZSfRNssdvG
         a02g==
X-Gm-Message-State: AJIora8oHkbPoWlU5hrJuWD8yOfHH83ZQXV9ffINN7v6UE/CDQzpecMs
        TVzqkU0QDBpQpPfzpLVWytT9LJnHXKDnOg==
X-Google-Smtp-Source: AGRyM1vOjAxbnnjt1DpADEEVLl/xffxBjAPEqZVI++jUzSnHEYGPdIiryt/uyfD6GQ1rw8k2Fsp7sw==
X-Received: by 2002:a05:6512:220d:b0:489:f036:7c8c with SMTP id h13-20020a056512220d00b00489f0367c8cmr21522487lfu.15.1658410985708;
        Thu, 21 Jul 2022 06:43:05 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id o23-20020ac24e97000000b004867a427026sm458568lfr.40.2022.07.21.06.43.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 06:43:05 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 07/15] crypto: ux500/hash: Rename and switch type of member
Date:   Thu, 21 Jul 2022 15:40:42 +0200
Message-Id: <20220721134050.1047866-8-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220721134050.1047866-1-linus.walleij@linaro.org>
References: <20220721134050.1047866-1-linus.walleij@linaro.org>
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

