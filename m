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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51333C2D0DB
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 249A6214AF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V6vcvtVN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgA0Q5T (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 11:57:19 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39432 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727278AbgA0Q5T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 11:57:19 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so3952301plp.6;
        Mon, 27 Jan 2020 08:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gBX0rF+FM22EQWDgrCOhfsho6eL33Pl7f2z/Wb05rxk=;
        b=V6vcvtVNGL1dkzbEEu5edrSulsfvxMusZPHTKrlqP1YctbYITDoWl4FcIrt3OagBqs
         cRz9R1ag1kwmkqpe88XQu0chXEwdmZGBiBynw97aoo/7IkN8V2LQuOaByn/X97MVJ/mv
         yhGQyesxee/3u2b5zTUzfQN4uUxB8n7zkuJClVUwBLJyViiBoq+k1qy+G2VeGjtk0sbb
         aHqv+oOXHfidda6SJIuj9AOMuG0DywQMxZyrfREGxOFh0oYkoiuxdWUzst7DjKzXxxVY
         JLHmlZWJ2t5WGJrnKJvbppOXHaZUXylNb6yE7JznH+wOgURycPrjWfeZQXsI2+3xqf5n
         9fwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gBX0rF+FM22EQWDgrCOhfsho6eL33Pl7f2z/Wb05rxk=;
        b=fGetXjQ26hD0D3O848VckdKaOTWVLauqsFBwss5XWR7wCOm6QYcvo8949y7NoJ29f7
         dU8MOgDDrn4WrIHDgNORtmlhfqONtWadnCtJgEWAW35aX6wShvvhNlujeTADXm1J6usn
         PrDJ/sXc9PEXLl3p/6/vXGPR7QUTaL/JWmt1T0XI5EfNDBVvCOyc/bTGr6Uxl7B4ezo1
         LcQaIH1mJzUpcvhiiVh9b+Vuz21wXjiPsDSunfiaDNCF+ujyBnwgfAag7kj0ZMBsh4AN
         6GPZXdfsocQ7FrZ3bPYLHWVnHKDpTcljVIvMS+CvddR0Po2sUxJeSS1kp2aUshWvL8Jv
         ZLXw==
X-Gm-Message-State: APjAAAU7VmaviQdEAxKxZTO6vAgZCI1vmgUZvjPsQ2Fs9n2Dx7wXftA3
        2rS/eH42vKFHdqRQh6R/zWmD/Aig
X-Google-Smtp-Source: APXvYqy4pV0aoh/I0RzG7st8QuqEadZ9OoF6E4Td9jxqCEaH3yBPrehQHMfoI9YELup/g23o06vIdA==
X-Received: by 2002:a17:902:7d8c:: with SMTP id a12mr17548169plm.47.1580144238429;
        Mon, 27 Jan 2020 08:57:18 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id u23sm16368642pfm.29.2020.01.27.08.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 08:57:17 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v7 9/9] crypto: caam - limit single JD RNG output to maximum of 16 bytes
Date:   Mon, 27 Jan 2020 08:56:46 -0800
Message-Id: <20200127165646.19806-10-andrew.smirnov@gmail.com>
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
 drivers/crypto/caam/caamrng.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index 62f3a69ae837..c0981fce68b7 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -23,9 +23,9 @@
 #include "error.h"
 
 /* length of descriptors */
-#define CAAM_RNG_MAX_FIFO_STORE_SIZE	U16_MAX
+#define CAAM_RNG_MAX_FIFO_STORE_SIZE	16
 
-#define CAAM_RNG_FIFO_LEN		SZ_32K /* Must be a multiple of 2 */
+#define CAAM_RNG_FIFO_LEN		64 /* Must be a multiple of 2 */
 
 /*
  * See caam_init_desc()
@@ -128,7 +128,7 @@ static void caam_rng_fill_async(struct caam_rng_ctx *ctx)
 
 	sg_init_table(sg, ARRAY_SIZE(sg));
 	nents = kfifo_dma_in_prepare(&ctx->fifo, sg, ARRAY_SIZE(sg),
-				     CAAM_RNG_FIFO_LEN);
+				     CAAM_RNG_MAX_FIFO_STORE_SIZE);
 	if (!nents)
 		return;
 
@@ -246,6 +246,7 @@ int caam_rng_init(struct device *ctrldev)
 	ctx->rng.init    = caam_init;
 	ctx->rng.cleanup = caam_cleanup;
 	ctx->rng.read    = caam_read;
+	ctx->rng.quality = 1024;
 
 	dev_info(ctrldev, "registering rng-caam\n");
 
-- 
2.21.0

