Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D73C282DD
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 892A62072A
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YsQN8sZD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgAHPmG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jan 2020 10:42:06 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33595 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgAHPmC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jan 2020 10:42:02 -0500
Received: by mail-pf1-f193.google.com with SMTP id z16so1830490pfk.0;
        Wed, 08 Jan 2020 07:42:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e1VydrddQQ2iYB1DThmBo5L3jMtREdgLznIozdRQZ6Q=;
        b=YsQN8sZDCsVBLyqVqglFYQX3ipzdNfpAUgQ8dxBhxSuL45z81+BFcKCb3k8LSqqBIy
         8yjy0b2ow+l/gtoaQcoU+C7T/8s1DL5R6evI3b6cwef3mYlKGvO6gJkO6FnrblnbiEnh
         e/h96a3ANkKUIaP1TLQBCH05aR7CvW7/zKAl5z7Cp4xBFeJzwDFKNcuFvJtaAXuVg+Qj
         zxjfuONcUpwegTVDC2p8PvEr/kCvYuVK1LS8nGnAuQb9NPWx8xHvLDpQj0ATfs0itati
         nUYljY6+1MAWRv+zoIlZq963wyGuJ234s910bSQ+LuovSBGGQiyM2Pqo0eIJFFAtrhp5
         N+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e1VydrddQQ2iYB1DThmBo5L3jMtREdgLznIozdRQZ6Q=;
        b=U+CsERhGGY+BPZGK3MQIc0kjE+JtXJolijv5pXy//XRXoZTASxH2Yz1O17VDNY1tPI
         snH53SNFCUvgwCmbMRvHJ5DgNO5NQ2IOO/P3DVkqUK6vwzTuM6b2jFy7EH3egvqog4mW
         4zbYQ7ZLb5hBeqW4jMlfW4T+HCP2YqzbB79MCEkf5l3jA4wyKR+HkO0LI1qNIJRjomY8
         Zpkd0I69lwihWOxPGPdVx/voCpOXnVvSnp1v3onL1d9BL048qUB4ifpA40cipK7T4zAU
         B8yrJer+nFMnYjmkQ7pp4V7vZeHXzeT5BoWg4WyQsgTm7SZlL46DTyYslscpnezuaHVb
         dgTg==
X-Gm-Message-State: APjAAAU2I8ejS+6Wkei8RRHhT1wjGMh50LIhaiyllTGJLKaGqQYnyiOA
        qD390nQyuA8tevj07eC38pdD4D9I
X-Google-Smtp-Source: APXvYqx3dfQwyBq6j3FDwObhn/gSdqmirlOoClvmjzVDteEIveTxU2sklT6ftL0+rbntMCSOsgYZ9Q==
X-Received: by 2002:a62:1d87:: with SMTP id d129mr5551144pfd.87.1578498121397;
        Wed, 08 Jan 2020 07:42:01 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id e1sm4286640pfl.98.2020.01.08.07.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 07:42:00 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v6 4/7] crypto: caam - check if RNG job failed
Date:   Wed,  8 Jan 2020 07:40:44 -0800
Message-Id: <20200108154047.12526-5-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200108154047.12526-1-andrew.smirnov@gmail.com>
References: <20200108154047.12526-1-andrew.smirnov@gmail.com>
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
index 3960f5c81c97..554aafbd4d11 100644
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

