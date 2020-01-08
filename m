Return-Path: <SRS0=xmdE=25=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D939CC33CA1
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:42:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF54A2073A
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Jan 2020 15:42:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X695sjDZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729051AbgAHPmI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Jan 2020 10:42:08 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:52291 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729045AbgAHPmH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Jan 2020 10:42:07 -0500
Received: by mail-pj1-f67.google.com with SMTP id a6so1236778pjh.2;
        Wed, 08 Jan 2020 07:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NqcNgcBIdsIjxgPBGKJAVyvsIKyRH4Nc8ZAOSc+D0fE=;
        b=X695sjDZ3I4ZjRLo6I24zQ/zy2+HMnhKMYzkrip6EpfcvthHq8Ax+KZkMQsZxEeUUU
         wYJvnt0YXY/nrHPafYHkVWd3Upn3aFRB4M3ZqLt16ZC5jtWFU1b922rTKr3Zp7sFnSU/
         XP/vOOnJ13BHHu9QXBXe2w3HKY+QbtdcXqtFZiXmYuKsYt84Wd96oZ/98gX4lrZfqzBz
         P4WyVoM+o+lAN7Az6Ck9gNUiO4X1lzN2RQ5T3Tbh9KQj4NUq9d0C3ZFwZbKTtWWmgAgB
         oJTzakpiEr1vCInId1dZ1l709PXO/UG7uEJXgGn2WRxilb4D3HmAAnQb70HdqSiYViZi
         DpBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NqcNgcBIdsIjxgPBGKJAVyvsIKyRH4Nc8ZAOSc+D0fE=;
        b=iOWbrqtV3gMXLeRGH+iq+3AvCwWIAtOY1p19vdLIqk0j0SPzLUeQq2WG2kiC1R678t
         ze3Dnzxda78rkTtg8uh9+qCMR9zswAPp3hjVv7wyGuT8jvHTw2OGDZySNt33I7VJL5im
         xr9v40K7Jhd68jxs6bB8rubjeQebtJqW+LInKk0YUNj4yr7G15dz/c9Z1l9WWhF9lQ1U
         JZxdKY9I8RJjOjUtehambq3rvSRRbs7etLEWRJ1oSmYeRyb9zM2MA+ETgI3PyS5/nakg
         QFRV91CtPNK+p8qtRgUWg1OzohZbiW44NdxR2m0v8/qxNsMjPASX3QzA0u6eClsBQKmm
         3TZw==
X-Gm-Message-State: APjAAAUBEGOsI/A++eVaDT011snrgGa5KnOKyfF3+b83dBKZ2g229rLS
        4lngOTjtwDAQiFAhA74Q6PpK4yzt
X-Google-Smtp-Source: APXvYqza+Ai3sj9qXmjB+8LuxnlqvhRuDxggGyIJVthk929D3XxHkipgLVT+kgJlJhcVp0zhz0eDrA==
X-Received: by 2002:a17:902:7203:: with SMTP id ba3mr5794754plb.249.1578498126366;
        Wed, 08 Jan 2020 07:42:06 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id e1sm4286640pfl.98.2020.01.08.07.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2020 07:42:05 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v6 7/7] crypto: caam - limit single JD RNG output to maximum of 16 bytes
Date:   Wed,  8 Jan 2020 07:40:47 -0800
Message-Id: <20200108154047.12526-8-andrew.smirnov@gmail.com>
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

In order to follow recommendation in SP800-90C (section "9.4 The
Oversampling-NRBG Construction") limit the output of "generate" JD
submitted to CAAM. See
https://lore.kernel.org/linux-crypto/VI1PR0402MB3485EF10976A4A69F90E5B0F98580@VI1PR0402MB3485.eurprd04.prod.outlook.com/
for more details.

This change should make CAAM's hwrng driver good enough to have 999
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
 drivers/crypto/caam/caamrng.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 91ccde0240fe..2b75ffffcac9 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -23,7 +23,7 @@
 #include "error.h"
 
 /* length of descriptors */
-#define CAAM_RNG_MAX_FIFO_STORE_SIZE	U16_MAX
+#define CAAM_RNG_MAX_FIFO_STORE_SIZE	16
 
 #define CAAM_RNG_FIFO_LEN		SZ_32K /* Must be a multiple of 2 */
 
@@ -134,7 +134,7 @@ static void caam_rng_fill_async(struct caam_rng_ctx *ctx)
 
 	sg_init_table(sg, ARRAY_SIZE(sg));
 	nents = kfifo_dma_in_prepare(&ctx->fifo, sg, ARRAY_SIZE(sg),
-				     CAAM_RNG_FIFO_LEN);
+				     CAAM_RNG_MAX_FIFO_STORE_SIZE);
 	if (!nents)
 		return;
 
@@ -241,6 +241,7 @@ int caam_rng_init(struct device *ctrldev)
 	ctx->rng.init    = caam_init;
 	ctx->rng.cleanup = caam_cleanup;
 	ctx->rng.read    = caam_read;
+	ctx->rng.quality = 999;
 
 	dev_info(ctrldev, "registering rng-caam\n");
 
-- 
2.21.0

