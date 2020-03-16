Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B0FC0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 15:01:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 16C332073E
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 15:01:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SCifVSsX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731807AbgCPPBY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 11:01:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39527 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731823AbgCPPBS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 11:01:18 -0400
Received: by mail-pf1-f193.google.com with SMTP id d25so2081990pfn.6;
        Mon, 16 Mar 2020 08:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6FSGRqvWIrV1AnR+eNOcmfjvZaVEwGuCJbbdcQTrqeA=;
        b=SCifVSsXYGYFePDAubNpRPpOOD5WkSnD9w88D/7K+mYZNxj+5Zwm4drhBTnVdWA8HV
         Sh3abG8AvOaX/Vv5iLPRSXKGUxTKluBGEmJDmxCUNGkwyw0NZ1+LeGioYh2yD9wAwSAB
         AQ4YzbGplhRBFA2AbhnwKXPq5eTLxmLYA0GvdIrPu3znAFa6qNIkEwelLFz/DwHDeQDf
         zn8gRXC64aae5ZRQzJoonYy211eEXAOsKObw8cjTBSaW0ZVVMI+yQbx20+l2SRxjWM9S
         TspP+r9pWqRmAjwKNfRsWvFwgwn6RrjRYs0fdZUD8glo3BBDaZy7ZLs2UCylLclDh2tr
         KsUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6FSGRqvWIrV1AnR+eNOcmfjvZaVEwGuCJbbdcQTrqeA=;
        b=R4xNfiMV2FFNEFUmhkYqkjgKT/Or17NWtUzZWgx+1Ro1/ugvpwG+2EghYBsCU8vA4O
         9FYlTfcOI1NUz8i451LfXb0gSBJO5GKPJZDJIDwMtogcg64kMiLlTgluGWK+LM9PTqfd
         K0pWhu1giQR53dBpxIHNlHaGYIYwG2KmQMPMTJFejbQXZKVosGHrOoNeMYzuH0FMYbXx
         XsC+8xHgKvsgC92Cwj2aO9ZrpOuho6W2Shijpi6EeIrQtYl6QhFr7L3LNjR9LUi82l9c
         AIwx2tuzRm3h36g3wuvDfz0Gs8yB1Iqvy+xqajGW33wHzO8NtnkUy9D+jnN4rJTmBN5+
         3yBg==
X-Gm-Message-State: ANhLgQ0buPVgFiROAAfIq87hmiaRsHFL8RqcpMaZrClK9cAySY55Ioec
        CRrsv6VtcZ303DyK0mcB9t6mKgWm
X-Google-Smtp-Source: ADFU+vtR0JV4vkxPY1U/B35BsEtpeY7gjYv1FzdAARr9vqVT1MatpZtC/avVrGNXXNOnr7h9qgQ1ag==
X-Received: by 2002:a65:5181:: with SMTP id h1mr323912pgq.62.1584370875444;
        Mon, 16 Mar 2020 08:01:15 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id o128sm256354pfg.5.2020.03.16.08.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 08:01:14 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v8 8/8] crypto: caam - limit single JD RNG output to maximum of 16 bytes
Date:   Mon, 16 Mar 2020 08:00:47 -0700
Message-Id: <20200316150047.30828-9-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200316150047.30828-1-andrew.smirnov@gmail.com>
References: <20200316150047.30828-1-andrew.smirnov@gmail.com>
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
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-imx@nxp.com
---
 drivers/crypto/caam/caamrng.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index cffa6604f726..77d048dfe5d0 100644
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
-- 
2.21.0

