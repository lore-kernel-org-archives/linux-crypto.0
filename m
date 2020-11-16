Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA118C64E69
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 13:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B251F222E8
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 13:55:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="pHOAjGIM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729817AbgKPNym (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Nov 2020 08:54:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729743AbgKPNyl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Nov 2020 08:54:41 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F66AC0613D1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2020 05:54:40 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id w6so14215624pfu.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2020 05:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oFmZrd7NE3HbQX/Lo8F4S5lrtb+Hwz8PmiBSdug9JUU=;
        b=pHOAjGIMcO3pLa2qipnYk3+0D2U6SBY246HUqsvNSSKyA64ULFAc9XPKYhAZ3LHVpx
         iPgKQZpjGbafyU9mGED3WvU93MWI/URKOqhaMClTUTIn5idMEr2WMSm3Pl8FknUgF1Lg
         CExg8xMsGbpFjRBHBoMMVdF/gYdSI0DhTuIVIWxDb2ey4h6sT2bdJGrK1DoRfgH6hQAA
         n3X7Amu4u+9on2FeaWIWIe5pqxXuhNMOQMaKqGkC3ZgzAZaPiCyNU020+uGezPvE0k5V
         0hgIf0Cai09dErI+/YhhtctQbKZt4QyLsudO4N1DSOMVF5Fc90speRF9uoGNgAk6DwaJ
         JUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oFmZrd7NE3HbQX/Lo8F4S5lrtb+Hwz8PmiBSdug9JUU=;
        b=pK9H3pQW8yNK3BQ4+l+I3fk9AENBce9v0D0PrK+Yad/Am4lH7OInurL0OKRg0Vuwh/
         KV9jgeE4ERvQ7Dkqb3JtIhvTKKGNETWK/IIygbHTiKgqokt4xUlVS8xLPXKuD00yAB9O
         FBrfThrB2tQs/dIxYSZ4vqKS8svrxES8Nd6ucJ/MFtTZQwSiYWyNoOpKk4Mk6OEtlqXB
         WsAFa6eTehcI/LxSlemMm7wRdDYM6hzZjyoXaiZf9wrOpZaEmm42/6YVlt9n/2Wft2qV
         ENT3Q3KUYSC0hkcGg4pjIdFsWsYhj6uR/0XPsX6JRjPbnVdeqHdrvsswabWiw/EO6pK4
         9x4Q==
X-Gm-Message-State: AOAM530tDUvv4U1MTO8WNKOdJO00uGCs+sjFV9wqLuPe1RLRtwrldzXm
        G+1YnWu5ztUBdxQhkjACmYAiOA==
X-Google-Smtp-Source: ABdhPJwG3dyo/34EnfPSLxxDmG2RWghKRkJ6P0GIJZkqnwDVqvPCn01dXaEjThZARmuMLjbRAn1Y7w==
X-Received: by 2002:a17:90b:78d:: with SMTP id l13mr16238310pjz.57.1605534879998;
        Mon, 16 Nov 2020 05:54:39 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id u22sm15864031pgf.24.2020.11.16.05.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 05:54:39 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v3 4/7] crypto: sun4i-ss: handle BigEndian for cipher
Date:   Mon, 16 Nov 2020 13:53:42 +0000
Message-Id: <20201116135345.11834-5-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201116135345.11834-1-clabbe@baylibre.com>
References: <20201116135345.11834-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Ciphers produce invalid results on BE.
Key and IV need to be written in LE.

Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index 53478c3feca6..8f4621826330 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -52,13 +52,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writesl(ss->base + SS_KEY0 + i * 4, &op->key[i], 1);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writesl(ss->base + SS_IV0 + i * 4, &v, 1);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);
@@ -223,13 +223,13 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	spin_lock_irqsave(&ss->slock, flags);
 
-	for (i = 0; i < op->keylen; i += 4)
-		writel(*(op->key + i / 4), ss->base + SS_KEY0 + i);
+	for (i = 0; i < op->keylen / 4; i++)
+		writesl(ss->base + SS_KEY0 + i * 4, &op->key[i], 1);
 
 	if (areq->iv) {
 		for (i = 0; i < 4 && i < ivsize / 4; i++) {
 			v = *(u32 *)(areq->iv + i * 4);
-			writel(v, ss->base + SS_IV0 + i * 4);
+			writesl(ss->base + SS_IV0 + i * 4, &v, 1);
 		}
 	}
 	writel(mode, ss->base + SS_CTL);
-- 
2.26.2

