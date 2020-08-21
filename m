Return-Path: <SRS0=Bmkv=B7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38537C433E3
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 13:47:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 144B62078D
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Aug 2020 13:47:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="Puvzic2e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728838AbgHUNrT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Aug 2020 09:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728808AbgHUNnx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Aug 2020 09:43:53 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004FEC061574
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2020 06:43:50 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id x5so1919623wmi.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Aug 2020 06:43:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CfYFcq4WmzTE0aAQvo/9AeYUJUnGPZBDIaHQZNs9Mgk=;
        b=Puvzic2eVEt1CzfvVJq8LdLpaTXDiBzuMX5oC0Qxut7sSaA4J8Al2raadiD78+d/NX
         NMEQ5uni/zIVkWVFDlE4nBitm24dRKGgslzUSY3C7OSk7rafv/s0MQuCd7z6fGqWSgkZ
         vFYaIL+USewgI57iAw08InJT3SvhKbrp6hrgkOPxWzeHSfe6/TBuBwAZcg5XDl74Tr0W
         +5Py8NfLkz51Y2ecdQV7miz1peQ0arYLiTqOXm7pv7d7sXG3e0Ak5MuAFHkOaQSRxjDW
         ogq9+2LnGQHU8gU07CHnW80qbSxmve5TYR6DSFUiWTbEYeHx9ScnYqD6S8uE+3/lgpom
         HgaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CfYFcq4WmzTE0aAQvo/9AeYUJUnGPZBDIaHQZNs9Mgk=;
        b=uT12CwdpKQY1rebo8k0VsZcYyBUnlGf3V+F3zxGO0Tq9kdxaSvGlEilky5p0WSL0vQ
         eG3i6HW9KPbH1dw/JxMsMw/uRjhdi3kznfSS5FRQZu/cNt0SxqwNJhiwy+RpJZdtWsyD
         NIqnua++mV7+W9xGJNwNvz8BjiiMzZF3mwxCIdZeEnn+/SXGsTMXjHsqyp66MvgzFEgP
         raCBM3LdvMmZsW/jwagEYT7yLcf/QR1Uv75+fDkWBGenVeiW5bxU2UT7qliA4oJJQuvs
         wFWFgnyms3wGrbNKBLlrU1r8XMqcBHu5nEPu/R/Gg81RO8J1GxkCUs5RTZ+kYilQWi8z
         UaYw==
X-Gm-Message-State: AOAM533lR4vuy3xHg1qwi6r2fS3s0LR3PI4GeZnBLM5UbMRbGJ1Cy53X
        Y5d6KPXAw5rrDocyqxARAyYqGA==
X-Google-Smtp-Source: ABdhPJwaqcrZbmfpf961U1mxkND2slDuBvxrZwZsRm2ZyiiVJnTek98LgnZO18Oy2tyR0n1p538b0w==
X-Received: by 2002:a1c:dc8b:: with SMTP id t133mr3825165wmg.148.1598017429665;
        Fri, 21 Aug 2020 06:43:49 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id 202sm5971179wmb.10.2020.08.21.06.43.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Aug 2020 06:43:48 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 06/18] crypto: sun8i-ss: better debug printing
Date:   Fri, 21 Aug 2020 13:43:23 +0000
Message-Id: <1598017415-39059-7-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598017415-39059-1-git-send-email-clabbe@baylibre.com>
References: <1598017415-39059-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch reworks the way debug info are printed.
Instead of printing raw numbers, let's add a bit of context.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 5cf00d03be1f..739874596c72 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -424,19 +424,19 @@ static int sun8i_ss_dbgfs_read(struct seq_file *seq, void *v)
 			continue;
 		switch (ss_algs[i].type) {
 		case CRYPTO_ALG_TYPE_SKCIPHER:
-			seq_printf(seq, "%s %s %lu %lu\n",
+			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
 				   ss_algs[i].alg.skcipher.base.cra_driver_name,
 				   ss_algs[i].alg.skcipher.base.cra_name,
 				   ss_algs[i].stat_req, ss_algs[i].stat_fb);
 			break;
 		case CRYPTO_ALG_TYPE_RNG:
-			seq_printf(seq, "%s %s %lu %lu\n",
+			seq_printf(seq, "%s %s reqs=%lu tsize=%lu\n",
 				   ss_algs[i].alg.rng.base.cra_driver_name,
 				   ss_algs[i].alg.rng.base.cra_name,
 				   ss_algs[i].stat_req, ss_algs[i].stat_bytes);
 			break;
 		case CRYPTO_ALG_TYPE_AHASH:
-			seq_printf(seq, "%s %s %lu %lu\n",
+			seq_printf(seq, "%s %s reqs=%lu fallback=%lu\n",
 				   ss_algs[i].alg.hash.halg.base.cra_driver_name,
 				   ss_algs[i].alg.hash.halg.base.cra_name,
 				   ss_algs[i].stat_req, ss_algs[i].stat_fb);
-- 
2.26.2

