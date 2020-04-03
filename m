Return-Path: <SRS0=Ncaf=5T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF84C2BA17
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:51:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0D302077D
	for <linux-crypto@archiver.kernel.org>; Fri,  3 Apr 2020 19:51:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="pirqFxht"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbgDCTu4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 Apr 2020 15:50:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54152 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728111AbgDCTuz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Apr 2020 15:50:55 -0400
Received: by mail-wm1-f65.google.com with SMTP id d77so8374820wmd.3
        for <linux-crypto@vger.kernel.org>; Fri, 03 Apr 2020 12:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DUwfWiW0UJxalwoOZqAt5RYAz8XQErLckHV7vR83OWY=;
        b=pirqFxhtHNPHRAEdKqSTs4Euef6KGq6HZwRdcmT4t4aLwZMfvlhm7hlrjmVzTdRxpl
         eFo9dW0UBEptLeS9GP9lAySK33wFSJBQqw42epc7Nu3ycqFuIMEpb1YyARdOSnQPhxFU
         Wlo2JpiSRrQpWc6DS4QNsKZbC8SCuIPzI3J6tZ87ccf5wHcLzCkFt9hULvgPnqRxQ8By
         9CBmjph2lVCBrzXF3VxhiT+ySEDwV/Jd1cF+YBimg3snUdVsY0DIlvHNBuZTnHMQR4Dz
         atH8ar4NRKj2bagsgPCfxiNbRZNZj65BxFSphFJOj1QNvspMV36m6ij9Z6+ClozPVGGq
         u96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DUwfWiW0UJxalwoOZqAt5RYAz8XQErLckHV7vR83OWY=;
        b=GWYGb/tGx5KJg2Tkzx/1ZrTelo+GSWLMahax2Nueg1NcOa9Ongscs0gOjpsMqdeCJK
         KmJSemymN1NQEqxMSLJSl9hR5DJWsmKTHKy7+awY6L2pzbKzOdvGQY+C+cHZErxwpDV3
         IRgFyw/s8+pc9buhsjm7ROrcQetq21fpoqtBwgd5DPUH9MnKuoVmLkd/t5wOGWCzUmvf
         GhVasE37tRJEL6MfNWQ0K0d89nLz+0LHPwXOrPGFD7cUZ+UsN4QRRV3IWeUg49T+nfkl
         LKDF/iKG3jt7xl2Z0TIpmU6plCPEEdfPerW3sSP58GY9boD9ej6RmpdxaNUd08xF+AkS
         aw4Q==
X-Gm-Message-State: AGi0PuZMEHArbXEEkq3kmJVbRLK/gn+lmH9jMAXDHGtWMKYP7q2YmPaP
        0rOgYOeL61sH4Z/onunoT2zbEg==
X-Google-Smtp-Source: APiQypKOyL9ads/3hMVSff7qNmS6J5YYs0teENKpVn9t8B1IfnPqaGI7AiHQNnoMwQBYFwAvtKTTvQ==
X-Received: by 2002:a1c:7308:: with SMTP id d8mr10713890wmb.31.1585943454150;
        Fri, 03 Apr 2020 12:50:54 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id c17sm8102448wrp.28.2020.04.03.12.50.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 03 Apr 2020 12:50:53 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 7/7] crypto: sun8i-ss: better debug printing
Date:   Fri,  3 Apr 2020 19:50:38 +0000
Message-Id: <1585943438-862-8-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
References: <1585943438-862-1-git-send-email-clabbe@baylibre.com>
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
index d7832e2eb39c..cbeaf1962c05 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -420,19 +420,19 @@ static int sun8i_ss_dbgfs_read(struct seq_file *seq, void *v)
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
2.24.1

