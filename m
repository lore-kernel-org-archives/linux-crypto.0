Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C99AC433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 20:56:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiCQU6A (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbiCQU5m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 16:57:42 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0368B15407F
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:17 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id r64so3796930wmr.4
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rDd6Lum4WVHK2qnq9j8fS4muA5cEDXa7xMcM4rmC0VU=;
        b=bQxQxJAopjBa0cH3DEA/wH7NmBNJs68v3ttaUHN/+kGRSs6CQsIpqCvzQQN2lyiZa5
         O9dMEpnnsSy4JfQpypICumZkQ/hfGH9OX3mg4mdQbuAAS0E+BjA+6mbMnUOanIeTVNmP
         KHpuqC9s2au36N2guRPz4Q5RluOow2CMFqhnPmaCuhE69JVLbrCaxtYcqg5q18QeuJ4s
         MaK6NCzRLP/CRb74vXmwyBHCN6mQc44u7+4d8P8rU+iSIduD1scckg/ESB2SFEJ1GVSN
         WwuAdMYz6HZJhzuD/xRei98D5eYjbgGxlPMNoCoQkBKCfdZvip7YoM0SD4XpebERtwpg
         eu1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rDd6Lum4WVHK2qnq9j8fS4muA5cEDXa7xMcM4rmC0VU=;
        b=Z3dO+V5evWTXtLOkxVgbLFeJvnp87IeKnuLzZdXVX+C6RDi0zcc8bEiwgFlt55IC4E
         t+OEm5NjlEKmNP2QBp23Hb0D/rXBuE+mQDgBiw+MRJyGcTjLWAf9p5emYRo8prBHcfIu
         +KXbOyeZb3gaMJ82+LjYuQc6Me5BbfIRKPzlf1FR6Mf1RhAhIy1Evk95x9c5B/1rT9jE
         mfmft4RwEbBLbfgDF8C+RqC5uO4zLHlSC9Qrjvw7BVPgV6VX57Jh0j244fAC4DzWzWyN
         92iXCO0Y1StfDrB2bIJ52bxJGezfquCaiXmj+TBQCPEAJcJbqMpp1v8sBKfY6udsU9Q1
         pjbA==
X-Gm-Message-State: AOAM533ey2edNqGoTbs2O8V77/VCZsttoabXVwfbUNqRyEbP/xBjBD4k
        KOICMJw0BmsvjeSD6J+VOrfSFQ==
X-Google-Smtp-Source: ABdhPJyQHkhV6+UUIW8gnu0AAX3hcWcWqqY3Ps0tnLgGEr/efCECgC8g9vsbSOUGQX3PgDIA0DNkUg==
X-Received: by 2002:a05:600c:4e07:b0:38c:8187:13c3 with SMTP id b7-20020a05600c4e0700b0038c818713c3mr3010470wmq.11.1647550576305;
        Thu, 17 Mar 2022 13:56:16 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id r4-20020a05600c35c400b00389f368cf1esm3695424wmq.40.2022.03.17.13.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 13:56:16 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 07/19] crypto: sun8i-ss: test error before assigning
Date:   Thu, 17 Mar 2022 20:55:53 +0000
Message-Id: <20220317205605.3924836-8-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317205605.3924836-1-clabbe@baylibre.com>
References: <20220317205605.3924836-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The first thing we should do after dma_map_single() is to test the
result.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index eaa0bbaf5581..49e2e947b36b 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -420,15 +420,15 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	}
 
 	addr_pad = dma_map_single(ss->dev, pad, j * 4, DMA_TO_DEVICE);
-	rctx->t_src[i].addr = addr_pad;
-	rctx->t_src[i].len = j;
-	rctx->t_dst[i].addr = addr_res;
-	rctx->t_dst[i].len = digestsize / 4;
 	if (dma_mapping_error(ss->dev, addr_pad)) {
 		dev_err(ss->dev, "DMA error on padding SG\n");
 		err = -EINVAL;
 		goto theend;
 	}
+	rctx->t_src[i].addr = addr_pad;
+	rctx->t_src[i].len = j;
+	rctx->t_dst[i].addr = addr_res;
+	rctx->t_dst[i].len = digestsize / 4;
 
 	err = sun8i_ss_run_hash_task(ss, rctx, crypto_tfm_alg_name(areq->base.tfm));
 
-- 
2.34.1

