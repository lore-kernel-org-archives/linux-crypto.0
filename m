Return-Path: <SRS0=HVQB=5E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95760C4332D
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4468920663
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HjM+U9z/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgCSQNQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Mar 2020 12:13:16 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:35945 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbgCSQNP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Mar 2020 12:13:15 -0400
Received: by mail-pl1-f194.google.com with SMTP id g2so1260669plo.3;
        Thu, 19 Mar 2020 09:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JqqHZc4mDxy3aXLOeDIjzEXKU4xYTgoxmYnKR8gehFo=;
        b=HjM+U9z/XZTlYhdv3Sk+x3hZJ6CpC/cdHsB3IK2QTz6jfjPtDIXz0ab4FAVKVT9Wyr
         3CiF5xRdQKogS/l6wsdAiysCwl7WImUBvRM4Uh8FnhgIxIfdd77NzfYVIWs0uH5txoKH
         f88ABy/7kIomD0XBZMCfGfxKTmLI+kFMZgLzG/PFDgZIX93J8nJGEn64AtE1m0yIkINl
         uaAx/nt3pGichXQm6rHsAszPiT7rOA4LJ4E97cuZvi9ZXqcMEbJIeTkxncLdLVKhqZ0J
         5KSBYarfHTXkWd8bJY1U9zQqtbHaNcf463uTh/47OkVCZc2rg2796wrg1I9GD0XZpC7Z
         WLMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JqqHZc4mDxy3aXLOeDIjzEXKU4xYTgoxmYnKR8gehFo=;
        b=QEOr9nNbJMKZsB8mqhWyn3pxF69D+g8ptqRondKVaHayPEzioi5Ofh/iAfbcCYmNR9
         Lp51AQdhrHrA/OVRGCviVamsxdrh1d9098CjhAhKG7o3Hj7o2eFTvTbsfm9VAQjk3Jee
         d1ikwyEbaq34qVC7wepO1Xb85BAJ5fEQrem15CuAYwqkEblBzZpaGA5QHNd1RI58jeDK
         2zwy2RBrRi03VfrJZHsaH4NjHiHwJSg63ngjD8rDbemLP+7sCgENGpIEnAMeMwg+Vi2P
         nHoJyKf7teMLi22IW96CgmUpFcbq0SWMIHsitCIQOG+PaHcWs+mgUQn658lL1w3CFCjH
         wTew==
X-Gm-Message-State: ANhLgQ0gQqXalqSgLUTt54llPrRr0cuN+htR2LO0pDFYsXybo6/fXz+j
        B7YCiK52GuO2W00jGK78h5+wz43l
X-Google-Smtp-Source: ADFU+vtD+ZU1UZxrL6uW3d0LIHHlr0wSfkXr7nmblPWYrzoL4s8Y2yHIN7DrjMMkkRLLEPfXbNyYFQ==
X-Received: by 2002:a17:90a:8403:: with SMTP id j3mr4685474pjn.8.1584634393466;
        Thu, 19 Mar 2020 09:13:13 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id x189sm3000078pfb.1.2020.03.19.09.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 09:13:12 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v9 9/9] crypto: caam - limit single JD RNG output to maximum of 16 bytes
Date:   Thu, 19 Mar 2020 09:12:33 -0700
Message-Id: <20200319161233.8134-10-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200319161233.8134-1-andrew.smirnov@gmail.com>
References: <20200319161233.8134-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to follow recommendation in SP800-90C (section "9.4 The
Oversampling-NRBG Construction") limit the output of "generate" JD
submitted to CAAM. See
https://lore.kernel.org/linux-crypto/VI1PR0402MB3485EF10976A4A69F90E5B0F98580@VI1PR0402MB3485.eurprd04.prod.outlook.com/
for more details.

This change should make CAAM's hwrng driver good enough to have 1024
quality rating.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-imx@nxp.com
---
 drivers/crypto/caam/caamrng.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 988bfddbadc6..77d048dfe5d0 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -22,9 +22,7 @@
 #include "jr.h"
 #include "error.h"
 
-#define CAAM_RNG_MAX_FIFO_STORE_SIZE	U16_MAX
-
-#define CAAM_RNG_FIFO_LEN		SZ_32K /* Must be a multiple of 2 */
+#define CAAM_RNG_MAX_FIFO_STORE_SIZE	16
 
 /*
  * Length of used descriptors, see caam_init_desc()
@@ -65,14 +63,15 @@ static void caam_rng_done(struct device *jrdev, u32 *desc, u32 err,
 	complete(jctx->done);
 }
 
-static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma, int len)
+static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma)
 {
 	init_job_desc(desc, 0);	/* + 1 cmd_sz */
 	/* Generate random bytes: + 1 cmd_sz */
 	append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |
 			 OP_ALG_PR_ON);
 	/* Store bytes: + 1 cmd_sz + caam_ptr_sz  */
-	append_fifo_store(desc, dst_dma, len, FIFOST_TYPE_RNGSTORE);
+	append_fifo_store(desc, dst_dma,
+			  CAAM_RNG_MAX_FIFO_STORE_SIZE, FIFOST_TYPE_RNGSTORE);
 
 	print_hex_dump_debug("rng job desc@: ", DUMP_PREFIX_ADDRESS,
 			     16, 4, desc, desc_bytes(desc), 1);
@@ -92,7 +91,7 @@ static int caam_rng_read_one(struct device *jrdev,
 		.err  = &ret,
 	};
 
-	len = min_t(int, len, CAAM_RNG_MAX_FIFO_STORE_SIZE);
+	len = CAAM_RNG_MAX_FIFO_STORE_SIZE;
 
 	dst_dma = dma_map_single(jrdev, dst, len, DMA_FROM_DEVICE);
 	if (dma_mapping_error(jrdev, dst_dma)) {
@@ -102,7 +101,7 @@ static int caam_rng_read_one(struct device *jrdev,
 
 	init_completion(done);
 	err = caam_jr_enqueue(jrdev,
-			      caam_init_desc(desc, dst_dma, len),
+			      caam_init_desc(desc, dst_dma),
 			      caam_rng_done, &jctx);
 	if (err == -EINPROGRESS) {
 		wait_for_completion(done);
@@ -122,7 +121,7 @@ static void caam_rng_fill_async(struct caam_rng_ctx *ctx)
 
 	sg_init_table(sg, ARRAY_SIZE(sg));
 	nents = kfifo_dma_in_prepare(&ctx->fifo, sg, ARRAY_SIZE(sg),
-				     CAAM_RNG_FIFO_LEN);
+				     CAAM_RNG_MAX_FIFO_STORE_SIZE);
 	if (!nents)
 		return;
 
@@ -156,7 +155,7 @@ static int caam_read(struct hwrng *rng, void *dst, size_t max, bool wait)
 	}
 
 	out = kfifo_out(&ctx->fifo, dst, max);
-	if (kfifo_len(&ctx->fifo) <= CAAM_RNG_FIFO_LEN / 2)
+	if (kfifo_is_empty(&ctx->fifo))
 		schedule_work(&ctx->worker);
 
 	return out;
@@ -186,7 +185,8 @@ static int caam_init(struct hwrng *rng)
 	if (!ctx->desc_async)
 		return -ENOMEM;
 
-	if (kfifo_alloc(&ctx->fifo, CAAM_RNG_FIFO_LEN, GFP_DMA | GFP_KERNEL))
+	if (kfifo_alloc(&ctx->fifo, CAAM_RNG_MAX_FIFO_STORE_SIZE,
+			GFP_DMA | GFP_KERNEL))
 		return -ENOMEM;
 
 	INIT_WORK(&ctx->worker, caam_rng_worker);
@@ -246,6 +246,7 @@ int caam_rng_init(struct device *ctrldev)
 	ctx->rng.cleanup = caam_cleanup;
 	ctx->rng.read    = caam_read;
 	ctx->rng.priv    = (unsigned long)ctx;
+	ctx->rng.quality = 1024;
 
 	dev_info(ctrldev, "registering rng-caam\n");
 
-- 
2.21.0

