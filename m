Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847E3C2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A499214D8
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y/XjWN13"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgA0Q5P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 11:57:15 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38554 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726191AbgA0Q5O (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 11:57:14 -0500
Received: by mail-pf1-f193.google.com with SMTP id x185so5174168pfc.5;
        Mon, 27 Jan 2020 08:57:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=K+CuE8HD59T0Dbl83YupeqY9uoXkVRO6zAexFr6qIIU=;
        b=Y/XjWN13CY3/Xh10fqgL+33YYlrbiTJphlaqYsYiaDZ2+Gjj49WUmJ09A4H93i4skA
         yTcLAdVVCvBj0wOS3Sy9GOHVXhsmrrFK4R5zRRkDqxQMnXl5vulQox3ztaKPdqMHBX+l
         1nEjtaWnhrStbHc3ohTkf00WJsizhjPLVn2PYd1EuZj/ANOkhnjyM/inUwYcIjJYzfot
         EH6yyAlFlUtgAIvoFsoTy15n/+PjVayjVZ+asBVixsNspv72/rzDNUkMFK4ZnxJRR7JB
         SeiQUGms0myG4wpACPe1vwUCjJ26vKSDzc8Tg98vPaPA9g5zL310S8bF73L3eVUIJyjw
         gyNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K+CuE8HD59T0Dbl83YupeqY9uoXkVRO6zAexFr6qIIU=;
        b=BuwWR8VJrHKdY2+T6SY9fpwKvYJRC76+VgVmrIH+P9CjQ3VuqRPzsvRC53afRaEp1K
         zGWx08G3ZtXqTu2w5rprNr+8I2SiKnjA+eNRZU2QDqJB1iwn1C+CR8pPLMYggK4bUiEF
         JAhMZC0BLSQrjgcuzNR+Dc3XF7cTq8hZQRt8Ga+PgY7rt4ah5PZXiIxIWsyAEuPHlS6U
         NnQE1uomO6vFHHz0QnajjUoMOV7YEY0JUFr8Bwl2/V5qEj0GbpktNgqjnRGKAP9Ersh3
         wTCCZOXWoi3FddF4ZqTQCT+P5cTQZNkg1BvKdozInbSQ3WThn9a0r62bijG6w2YvNLh1
         jZEQ==
X-Gm-Message-State: APjAAAVgNDEP+ZKTu36zLwmPETGcxSciaMMfQJ5D9xmxY4/bdeGW+TEq
        yPPzuMk8buK8wz5D3omV+5TH1lWQ
X-Google-Smtp-Source: APXvYqybQSRPV8pi2RZ/in+TSvs6ox84dHkDakvB9ZAtCGcCBqc72TkwVW5hEu3L1tD2qbwcnyc8yg==
X-Received: by 2002:a63:f410:: with SMTP id g16mr20361897pgi.193.1580144233726;
        Mon, 27 Jan 2020 08:57:13 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id u23sm16368642pfm.29.2020.01.27.08.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 08:57:12 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v7 6/9] crypto: caam - check if RNG job failed
Date:   Mon, 27 Jan 2020 08:56:43 -0800
Message-Id: <20200127165646.19806-7-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200127165646.19806-1-andrew.smirnov@gmail.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We shouldn't stay silent if RNG job fails. Add appropriate code to
check for that case and propagate error code up appropriately.

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
 drivers/crypto/caam/caamrng.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index cb498186b9b9..790624ae83c6 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -52,6 +52,11 @@ struct caam_rng_ctx {
 	struct kfifo fifo;
 };
 
+struct caam_rng_job_ctx {
+	struct completion *done;
+	int *err;
+};
+
 static struct caam_rng_ctx *to_caam_rng_ctx(struct hwrng *r)
 {
 	return container_of(r, struct caam_rng_ctx, rng);
@@ -60,12 +65,12 @@ static struct caam_rng_ctx *to_caam_rng_ctx(struct hwrng *r)
 static void caam_rng_done(struct device *jrdev, u32 *desc, u32 err,
 			  void *context)
 {
-	struct completion *done = context;
+	struct caam_rng_job_ctx *jctx = context;
 
 	if (err)
-		caam_jr_strstatus(jrdev, err);
+		*jctx->err = caam_jr_strstatus(jrdev, err);
 
-	complete(done);
+	complete(jctx->done);
 }
 
 static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma, int len)
@@ -89,6 +94,10 @@ static int caam_rng_read_one(struct device *jrdev,
 {
 	dma_addr_t dst_dma;
 	int err;
+	struct caam_rng_job_ctx jctx = {
+		.done = done,
+		.err  = &err,
+	};
 
 	len = min_t(int, len, CAAM_RNG_MAX_FIFO_STORE_SIZE);
 
@@ -101,7 +110,7 @@ static int caam_rng_read_one(struct device *jrdev,
 	init_completion(done);
 	err = caam_jr_enqueue(jrdev,
 			      caam_init_desc(desc, dst_dma, len),
-			      caam_rng_done, done);
+			      caam_rng_done, &jctx);
 	if (!err)
 		wait_for_completion(done);
 
-- 
2.21.0

