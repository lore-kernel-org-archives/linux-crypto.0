Return-Path: <SRS0=6s16=C5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50516C43466
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 18:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11BCC207D3
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 18:37:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="RoIaqdq+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgITShc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Sep 2020 14:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726359AbgITShc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Sep 2020 14:37:32 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D7CC0613D8
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2020 11:37:30 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x14so10475772wrl.12
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2020 11:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3OyGuodJwZo3ZuRGej7X4SpPtHUnPs0FAyD9Ejylqzc=;
        b=RoIaqdq+e0795nGzWShgL380T4BXMnZSXrHw09SiRa8w9HbuTKl71pGS0QgH/OJ3xK
         nLUahSLe8gAbMiJimVsCuqjkAPxybtlKWXzXixZbr2Myp59+9ee+ARC/T9sJLR269Grf
         YhL0XBMnfoUH72cjtkCVwLHAVmm9Aa13p+VoKPslqNNKo6tgFyUPJdOXA+Qf9sEuWJwJ
         es9/Ow95Iv+UGuomjo0eIflGjp6rwtMR+XVH3bUXTMxrBYwpk7wSVf8WsHxI91tCWA+h
         eYJuF5rHLUkAnnf8k7Hq9BetVFQopgZa6ZhTg+t0hnd1J2hDjnekRp0WHbh0hOhsSEZw
         If7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3OyGuodJwZo3ZuRGej7X4SpPtHUnPs0FAyD9Ejylqzc=;
        b=mRfMKmUM0KWWZ0k81P6yR64KP5os/wjAvD2uQ/GkcG3O7cO9phLI51tJphsRr9FvVV
         mO68fr5RRK+mM3p84RMuL5ubJ0bxftEKzgv2fCGHjxyIAdI4hghkGI3JpC0OZq+Bletu
         tjzUtg6FopJm91aOmr8ejesii/C75jZyynrqGuwZs/X/eGdDmm7HUcq4z0/aXJe1PJrd
         NDptPE5DC+h0c1zsdJlhDRsQPUiSVYXYWEgQ3P0RrKuuNpahrV+kQ1dgygf2RK3V4Hv3
         OCFUd2B+ccPofbqVat7aBXYVeRPOl8zhntxtAXXuJTfaW7y9MMNvOF342OJrXEYFe7m5
         l3Lg==
X-Gm-Message-State: AOAM533u9IFkMw2tgZK56HI/tqRUq2HE6x3MwKkc00kOjPXHsmQJaT3D
        Un3eRSypiIB6bOlaju6mf5hmAQ==
X-Google-Smtp-Source: ABdhPJww+6NOi8GJs7+7r6z4gKijDA+FXf0aSA2CdHowZYjtNN8SgZILS8uTKvVlG8N477QqbY45ew==
X-Received: by 2002:a5d:4591:: with SMTP id p17mr48173433wrq.408.1600627049213;
        Sun, 20 Sep 2020 11:37:29 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e18sm16419841wrx.50.2020.09.20.11.37.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 11:37:28 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v2 5/7] crypto: sun4i-ss: initialize need_fallback
Date:   Sun, 20 Sep 2020 18:37:16 +0000
Message-Id: <1600627038-40000-6-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
References: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The need_fallback is never initialized and seem to be always true at runtime.
So all hardware operations are always bypassed.

Fixes: 0ae1f46c55f87 ("crypto: sun4i-ss - fallback when length is not multiple of blocksize")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index a05889745097..f3bdf465b02e 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -181,7 +181,7 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int obo = 0;	/* offset in bufo*/
 	unsigned int obl = 0;	/* length of data in bufo */
 	unsigned long flags;
-	bool need_fallback;
+	bool need_fallback = false;
 
 	if (!areq->cryptlen)
 		return 0;
-- 
2.26.2

