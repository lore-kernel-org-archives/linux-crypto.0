Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3946CC0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 15:01:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F1BF82074D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 15:01:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVBmx9Jm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731802AbgCPPBQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 11:01:16 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46402 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731780AbgCPPBN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 11:01:13 -0400
Received: by mail-pg1-f194.google.com with SMTP id y30so9882351pga.13;
        Mon, 16 Mar 2020 08:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5opG/WqdObFJY1MKCrS0UlWt4bpICiyw/uq+oIUzdY0=;
        b=FVBmx9Jmsm+YpwdWdVoZeOF/ZCPAPTwl3AeNGg6Cpm+0cJQqmvEUKa1S/QnCyE6uq3
         L87guLTV5m+OorNrQG27aX5eCpB4tkhjQX23P31P9Kf0z99xIXYle+fyolja7gSY1L9m
         K9bP/BMFo3YTHb5nWF/R4iCbHPbMVJxhNYDf0WXiEcLeQHxf21dcP1/+LXX2HUCBVjPE
         ESfwUihi03ePtuhav+QY66L48yJBYCewTEiYsUnUBD/xvCvDcj9foiIAonKNcx8IkmP2
         LMpy96Em/cPXW/oP17GbJStjofcFMxRJaFg1Jjb9XuDl5MPz+UoNlOpzm4caa1LHQdCh
         kuqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5opG/WqdObFJY1MKCrS0UlWt4bpICiyw/uq+oIUzdY0=;
        b=hXcO+QBGblqwZGR+hO13LKeupkdqoPff7xfkeotHeZnbq2ze9zA4DHne243ZznBpwU
         r/wryNNoJ5EIZgfSKShZJkdmO0jXuIQ4A9W8UIN9laSZf/bDZTUFxHU9bcqMdC1S1Zli
         VZJ5mb35rCOPMXqG1rwbF7v/QoI8PCC/zgA3Pr0XxoxJboZK2QWocEivOjpHjPTsab8T
         PQ1ZiAw+TdSzvpKfB5ZaLBxadYZHoNAUCzQtlQfC5x86waI3z3xCbLWQhSn89inPy9uF
         DFEuG4SnX+dL8UoqAmfXFileCa48DruyoE2k3W+nmq9VMawvukEM6IOJE8yUfUIt2bi8
         tQQQ==
X-Gm-Message-State: ANhLgQ0WMzWL10stwsL0Hl+f6HQCa5xHS/aKzU5mLEbDjiL2NHRwuOCJ
        baBl8VYAZ/eIOcoqThGq+g6HGmYH
X-Google-Smtp-Source: ADFU+vuYj7BMkAbNu1vmKUlpMsBm9X90d78ksq6odhJxm9ffProKglFA4sXoOaTSfDcN4bSHbJQaKw==
X-Received: by 2002:a62:a116:: with SMTP id b22mr82123pff.122.1584370870475;
        Mon, 16 Mar 2020 08:01:10 -0700 (PDT)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id o128sm256354pfg.5.2020.03.16.08.01.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 08:01:09 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v8 5/8] crypto: caam - check if RNG job failed
Date:   Mon, 16 Mar 2020 08:00:44 -0700
Message-Id: <20200316150047.30828-6-andrew.smirnov@gmail.com>
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
 drivers/crypto/caam/caamrng.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index b3b92e5944cd..ffbdc912f1be 100644
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

