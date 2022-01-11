Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9B6C433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jan 2022 12:41:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbiAKMlW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jan 2022 07:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236359AbiAKMlW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jan 2022 07:41:22 -0500
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431F9C06173F
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2022 04:41:22 -0800 (PST)
Received: by mail-vk1-xa32.google.com with SMTP id n12so2623287vkc.12
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2022 04:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5nbctxTqSbKVLgxPcBh73m81LJiUTavZURj9y7UFZyU=;
        b=b+ZZrNZT+jFsQ8CwSWNJJf9yClxOnhkLLIcvrblvHKiY9YBV4Dt4rA9IqJQtg5DyUe
         sfKNlmw1VKydmZ0W51HFs7FW7hyQRyd2e38P6vyElDHlVtoZKDpf9jd9yNZrr9Gy/E64
         5FfPIizaQNzFk/0nj8usX6ZooPwX6Sqh0mLKvyEPlrOWYg6hSwi8dsjmEN4U58MlPwEh
         bRPt98Ymqhgx5woUkNZuoNK9oXrPg3VTa2oXZHuogeR/nP7IIvVftPhAnT4LUCjV3AbW
         lM4DRfCQHC8ku4PaaVLjcwgYlPlmFQw578AU9gh9e92LZrhijgOd1iz/r4H8nzGuds67
         4RNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5nbctxTqSbKVLgxPcBh73m81LJiUTavZURj9y7UFZyU=;
        b=SK8rWawqjjyyep08iKRDOPs4xeHyI9czwHg1So2oEs7plTVx/ZVr4EEpsweK3Gg+/2
         nDKHpXS/rMnIUA4sQ5q8pPR4uE8069bijDj/4oXSI8Hag8QieEa5bopbPsvqidaBqjBg
         vhzjaLETKVXs/peghQf8qAcaDWlwyH4ZF7dG9MPPZyoekTKKpugBHWAbVQRlxnYgU1VK
         ToFxRjTTYMhW/bm6wkHTqSaRrS/aIYmkly1IwEYLiAcMgQakxxBDBG7qZBBvyOBZA5Vo
         bW7Rxin7Tf0QykHKRxvj3Y5N9p0S5KrNaqsNaSCDXVBc4X9nyfGlYC9PIiJ4p6bhOzxz
         kOAA==
X-Gm-Message-State: AOAM530OhlBz5P34Xj9EHDffAs33trDPPe6HTJehbVWwsQs6Y+1oPEUy
        NIMZDwx6zJSp/SuHkSBeVlU=
X-Google-Smtp-Source: ABdhPJw0l7jQhigpBdxR5YvSPwm6eLiNemW1z3CMhn4uFUp3/87K9nIC8mtBMcow8+bawPg2yzVH5g==
X-Received: by 2002:a05:6122:200d:: with SMTP id l13mr2147658vkd.16.1641904881419;
        Tue, 11 Jan 2022 04:41:21 -0800 (PST)
Received: from localhost.localdomain ([2804:14c:485:504a:adc1:6d00:a8f1:3386])
        by smtp.gmail.com with ESMTPSA id m62sm5734790uam.0.2022.01.11.04.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 04:41:21 -0800 (PST)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     horia.geanta@nxp.com, andrei.botila@nxp.com,
        andrew.smirnov@gmail.com, fredrik.yhlen@endian.se, hs@denx.de,
        linux-crypto@vger.kernel.org, Fabio Estevam <festevam@denx.de>
Subject: [PATCH] crypto: caam - enable prediction resistance conditionally
Date:   Tue, 11 Jan 2022 09:41:04 -0300
Message-Id: <20220111124104.2379295-1-festevam@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance
in HRWNG") the following CAAM errors can be seen on i.MX6:

caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
hwrng: no data available
caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
hwrng: no data available
caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
hwrng: no data available
caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
hwrng: no data available

OP_ALG_PR_ON is enabled unconditionally, which may cause the problem
on i.MX devices.

Fix the problem by only enabling OP_ALG_PR_ON on platforms that have
Management Complex support.

Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWNG")
Signed-off-by: Fabio Estevam <festevam@denx.de>
---
 drivers/crypto/caam/caamrng.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 77d048dfe5d0..3514fe5de2a5 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -63,12 +63,19 @@ static void caam_rng_done(struct device *jrdev, u32 *desc, u32 err,
 	complete(jctx->done);
 }
 
-static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma)
+static u32 *caam_init_desc(struct device *jrdev, u32 *desc, dma_addr_t dst_dma)
 {
+	struct caam_drv_private *priv = dev_get_drvdata(jrdev->parent);
+
 	init_job_desc(desc, 0);	/* + 1 cmd_sz */
 	/* Generate random bytes: + 1 cmd_sz */
-	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |
-			 OP_ALG_PR_ON);
+
+	if (priv->mc_en)
+		append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |
+				  OP_ALG_PR_ON);
+	else
+		append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
+
 	/* Store bytes: + 1 cmd_sz + caam_ptr_sz  */
 	append_fifo_store(desc, dst_dma,
 			  CAAM_RNG_MAX_FIFO_STORE_SIZE, FIFOST_TYPE_RNGSTORE);
@@ -101,7 +108,7 @@ static int caam_rng_read_one(struct device *jrdev,
 
 	init_completion(done);
 	err = caam_jr_enqueue(jrdev,
-			      caam_init_desc(desc, dst_dma),
+			      caam_init_desc(jrdev, desc, dst_dma),
 			      caam_rng_done, &jctx);
 	if (err == -EINPROGRESS) {
 		wait_for_completion(done);
-- 
2.25.1

