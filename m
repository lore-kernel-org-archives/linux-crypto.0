Return-Path: <SRS0=HVQB=5E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBD8CC4332B
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B105820663
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Mar 2020 16:13:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k1Po56HI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgCSQNH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Mar 2020 12:13:07 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:38417 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728352AbgCSQNG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Mar 2020 12:13:06 -0400
Received: by mail-pj1-f65.google.com with SMTP id m15so1207780pje.3;
        Thu, 19 Mar 2020 09:13:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LCAGbzjQfd4JlaOjjKxUHcbjmkgk4JwloTjciGBlv28=;
        b=k1Po56HIE5oa4MTwiqOPUWFcpcwLNDu4cqdhSntXEMuAjPT3beaaDGNTHuwUlFI/w2
         kCJfOkOakXmPOiBKp8k84V24ALWAHYUSEjU+Kb9esxMIXKEM56Is8hOgJRWFmHHHIYFt
         O95e8d6Wprbe5LAPMArHpOiazgMrDOgBxdNdOhdG5Ra+6eyn4cLkf44EdpcnxGVx2M7B
         /H8HrwK3MAApWRKAMhXmq+W0VESWhZg4Oe7nuqIY/P+B0kyFC7xDqRTGTxG6fvw+4l7c
         dskXAEbxinPW1Cr1RB8IyKjYE/0esCSDuC1BIQ0fGJwrcLgTXje+FVXUGMnK/qyWOxmB
         UbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LCAGbzjQfd4JlaOjjKxUHcbjmkgk4JwloTjciGBlv28=;
        b=SazoUGCNpR5aBWqkVZeWEdB99u9HSdeWI3HcYvoR9CHly7FyXHfXpmD/5mqq2N895B
         ocUjolFxHQvkdhBh5+tYKBA/WeifOMuEDgHs4r/tUsOJ0hxbDbYM4S24EH9Xdr2DcDk8
         xLWvd6Af/T5NmopwAotjSOaZ+Nm4ssfC/37tl9ZoamMpk3zyTekPDSrrve0o/ZIdsbiV
         85JFFIR1UlbdHbgCv8ncTL54ammhMuOsAvOBcMCPsDy//tqJ/rcXmbYuFZPehRdAWZ5k
         3hCEyveDBaOUgutkOVMZcwTeHVa+gEpXt489h1hjgxSnF/3DdStoJmUDUN/XaF71QrFM
         JIKA==
X-Gm-Message-State: ANhLgQ14QnnjACCi8fopaCV2hRJP3+p64f7yRN9p98gE6A3XQmpJjyPu
        2iFS5fCWQrpn4qc7p8SKhNKWFnhb
X-Google-Smtp-Source: ADFU+vuOBTTg0DRV+kx/4nBnO86lbNIGtDuRvm6CAZ8PoJpE2YxRAmUt0jwPeGB5bdsNxL+z1tuZrQ==
X-Received: by 2002:a17:902:463:: with SMTP id 90mr4300514ple.213.1584634384883;
        Thu, 19 Mar 2020 09:13:04 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id x189sm3000078pfb.1.2020.03.19.09.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Mar 2020 09:13:03 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v9 5/9] crypto: caam - check if RNG job failed
Date:   Thu, 19 Mar 2020 09:12:29 -0700
Message-Id: <20200319161233.8134-6-andrew.smirnov@gmail.com>
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

We shouldn't stay silent if RNG job fails. Add appropriate code to
check for that case and propagate error code up appropriately.

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
 drivers/crypto/caam/caamrng.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index e64f2d77fa03..d0027d31e840 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -44,6 +44,11 @@ struct caam_rng_ctx {
 	struct kfifo fifo;
 };
 
+struct caam_rng_job_ctx {
+	struct completion *done;
+	int *err;
+};
+
 static struct caam_rng_ctx *to_caam_rng_ctx(struct hwrng *r)
 {
 	return (struct caam_rng_ctx *)r->priv;
@@ -52,12 +57,12 @@ static struct caam_rng_ctx *to_caam_rng_ctx(struct hwrng *r)
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
@@ -80,7 +85,11 @@ static int caam_rng_read_one(struct device *jrdev,
 			     struct completion *done)
 {
 	dma_addr_t dst_dma;
-	int err;
+	int err, ret = 0;
+	struct caam_rng_job_ctx jctx = {
+		.done = done,
+		.err  = &ret,
+	};
 
 	len = min_t(int, len, CAAM_RNG_MAX_FIFO_STORE_SIZE);
 
@@ -93,7 +102,7 @@ static int caam_rng_read_one(struct device *jrdev,
 	init_completion(done);
 	err = caam_jr_enqueue(jrdev,
 			      caam_init_desc(desc, dst_dma, len),
-			      caam_rng_done, done);
+			      caam_rng_done, &jctx);
 	if (err == -EINPROGRESS) {
 		wait_for_completion(done);
 		err = 0;
@@ -101,7 +110,7 @@ static int caam_rng_read_one(struct device *jrdev,
 
 	dma_unmap_single(jrdev, dst_dma, len, DMA_FROM_DEVICE);
 
-	return err ?: len;
+	return err ?: (ret ?: len);
 }
 
 static void caam_rng_fill_async(struct caam_rng_ctx *ctx)
-- 
2.21.0

