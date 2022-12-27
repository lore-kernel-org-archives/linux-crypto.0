Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FAB9C4332F
	for <linux-crypto@archiver.kernel.org>; Tue, 27 Dec 2022 23:04:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiL0XEi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 27 Dec 2022 18:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232208AbiL0XEU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Dec 2022 18:04:20 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03DBEDF4E
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2022 15:04:16 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id bq39so13625904lfb.0
        for <linux-crypto@vger.kernel.org>; Tue, 27 Dec 2022 15:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kkirVz/33x31xBhYi0JWwLjL/jhzRe4WWEuKEkFMsWo=;
        b=RLGiwgxjXRKc4EsXCwQvENz0JiKBKPzIuszL+O72xNIyJFyyHKJeL8r9MEzjhKdZS8
         q4HqvnZwSMwOyApCGuSCpVLJWrEVHv4EdSQhHTZWdH+R1g7qB5uQRAd5NQ4QdD18Ugml
         twuEIRSX6sESMNwC7fenxmYuaQ8nL0sjFFB5sxfcPLRLqNfglSk2ap2gferOOXxEFAnX
         ism+O2+77CnkhV+3dIJfDwEqf9NUczrfpn2xsVHmzHLC+Eiwoq6NjYqf3haNgghsWgZh
         kXaHxyrS4GatK5nDBFeiZTHjfInTE1y5g+HYPADV+PvYxtkgcyw4u+AE/g40Oumfuaon
         u1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kkirVz/33x31xBhYi0JWwLjL/jhzRe4WWEuKEkFMsWo=;
        b=g4IJFibWPMHBv6kaODapeawYpdNWso2HAwI4tD/sCXlwXqin3AVv9ec8ShcBQ/cyZN
         HfoPdZx0wP4o2EJuFB5r+7yTQ9xSsRIhHyrpdw9SimffpiEtsuyak6JPXD+g5OUBsEq4
         KBaOKiA1XU0xuq3S1NSQqWSjjNYg9ooo56gFuyBnSW7xcdx+VkLUksb8nY16MJCTu63t
         /UKpIdPSSj5X1YWQvNzAFEYkQXxzlNaLRxnFfM5FUGPH5k098/Mtw/wEhV9Rojz+HuEc
         uSXqs+MR+uwghS8fGbVwf/CxWu0bHevUA0D5/nK4kMlGgbSS377wTKh1GGDkh0JjqS9b
         j4MA==
X-Gm-Message-State: AFqh2koqdptX4UZhEpg1Z+ovl5zXQ3TXnSAQ5rufbdKEDIml2lmRQxoE
        Ajzu0zNVL+uotRd1JsGUr4qz0g==
X-Google-Smtp-Source: AMrXdXuRg+RWZECcd05OZBukglo+UoFlAtGbMa+BgMEGs3zidEZnp+S5U/6qnvyErizFnkt12pIUFg==
X-Received: by 2002:a05:6512:3d11:b0:4b5:2ef3:fd2a with SMTP id d17-20020a0565123d1100b004b52ef3fd2amr12007982lfv.47.1672182254389;
        Tue, 27 Dec 2022 15:04:14 -0800 (PST)
Received: from Fecusia.local (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id bg25-20020a05651c0b9900b0027fbd4ee003sm876925ljb.124.2022.12.27.15.04.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Dec 2022 15:04:12 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 28 Dec 2022 00:03:36 +0100
Subject: [PATCH 4/7] crypto: stm32/hash: Make dma_mode a bool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-ux500-stm32-hash-v1-4-b637ac4cda01@linaro.org>
References: <20221227-ux500-stm32-hash-v1-0-b637ac4cda01@linaro.org>
In-Reply-To: <20221227-ux500-stm32-hash-v1-0-b637ac4cda01@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.11.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This flag enables/disables DMA mode and is a true/false
flag so make it a bool. Clamp the value from the
HASH_HWCFGR register to a bool as well using a double-bang
construction.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/crypto/stm32/stm32-hash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index cc0a4e413a82..5f03be121787 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -166,7 +166,7 @@ struct stm32_hash_dev {
 	struct reset_control	*rst;
 	void __iomem		*io_base;
 	phys_addr_t		phys_base;
-	u32			dma_mode;
+	bool			dma_mode;
 	u32			dma_maxburst;
 
 	struct ahash_request	*req;
@@ -481,7 +481,7 @@ static int stm32_hash_hmac_dma_send(struct stm32_hash_dev *hdev)
 	struct stm32_hash_ctx *ctx = crypto_ahash_ctx(tfm);
 	int err;
 
-	if (ctx->keylen < HASH_DMA_THRESHOLD || (hdev->dma_mode == 1)) {
+	if (ctx->keylen < HASH_DMA_THRESHOLD || (hdev->dma_mode)) {
 		err = stm32_hash_write_key(hdev);
 		if (stm32_hash_wait_busy(hdev))
 			return -ETIMEDOUT;
@@ -568,7 +568,7 @@ static int stm32_hash_dma_send(struct stm32_hash_dev *hdev)
 
 		sg[0] = *tsg;
 		if (sg_is_last(sg)) {
-			if (hdev->dma_mode == 1) {
+			if (hdev->dma_mode) {
 				len = (ALIGN(sg->length, 16) - 16);
 
 				ncp = sg_pcopy_to_buffer(
@@ -602,7 +602,7 @@ static int stm32_hash_dma_send(struct stm32_hash_dev *hdev)
 			return err;
 	}
 
-	if (hdev->dma_mode == 1) {
+	if (hdev->dma_mode) {
 		if (stm32_hash_wait_busy(hdev))
 			return -ETIMEDOUT;
 		reg = stm32_hash_read(hdev, HASH_CR);
@@ -663,7 +663,7 @@ static bool stm32_hash_dma_aligned_data(struct ahash_request *req)
 		return false;
 
 	if (sg_nents(req->src) > 1) {
-		if (hdev->dma_mode == 1)
+		if (hdev->dma_mode)
 			return false;
 		for_each_sg(req->src, sg, sg_nents(req->src), i) {
 			if ((!IS_ALIGNED(sg->length, sizeof(u32))) &&
@@ -1525,7 +1525,7 @@ static int stm32_hash_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_engine_start;
 
-	hdev->dma_mode = stm32_hash_read(hdev, HASH_HWCFGR);
+	hdev->dma_mode = !!stm32_hash_read(hdev, HASH_HWCFGR);
 
 	/* Register algos */
 	ret = stm32_hash_register_algs(hdev);

-- 
2.38.1
