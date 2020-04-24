Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 925D9C55194
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B66721569
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:03:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="FuoPfzJU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728071AbgDXOCj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728373AbgDXOCi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 10:02:38 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F2CC09B045
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:37 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id h2so10571495wmb.4
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SU0E9luozURTZ9TC+AsIeijArTCKSbuhSsq3JPq3G+Q=;
        b=FuoPfzJUK/ct5OaBTFDq9xyu8VZKYeQiFwCDQAeXPwGBBmcCFdiZLenmH3KNChIAjM
         c+Zax04FMpjAF11s0LW7x4jKqmzTHMzPYvIXkBqY5XF3YXiPsqRxXPmNQm0Q6/520H++
         HPxrRjWNsHr/lqXPWUKY8XQjN0VB3QUzRfJuPw3zgfd15dEIGQ57jpSRi7fE3p6cXdkx
         6NLzXSr4vNC9bN937sTzCCxJHmkGQLUwwcDJnpVBdpT9/yDiGxyps94d2eKaYsXjW8nI
         magVDUKbL+sJZKEDdI3RHiVbTHBQEFwb5y4azCLqdR1LABFCY4rDHAA0MYDddOaimcrL
         qdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SU0E9luozURTZ9TC+AsIeijArTCKSbuhSsq3JPq3G+Q=;
        b=ktgVCneJq4BqZWcncTZrLte9BC5fH/rW5OXyGlzqkaktvc355uFqhNSVc7ij4bHK0f
         rQp1kOjbUZcvmsfa5PJdtgg8exDQCO9fd6YCf6nn7+mx18h4dBeMfflrS64nK0YfakeF
         bMp0o60f7Xx0fE2JWh7pGGzcq6vqUVgVVhSglzLefKujiFzObvrgs6sQL3jNkiYFZKIv
         7AJA2i8sm46jlOpT22ZnvSqkChW0U/o1Of+DLGZbjC5J1MHoiYJ7TL80hE4x0ix5U+3p
         /jlxSzk2zTbwojrsL85f3GmNGshO2hzxubL+gFh1mEsSVUNKk9Zz2OXY/3vkMR6ES4oR
         ynFA==
X-Gm-Message-State: AGi0PuZD5P1brsKq+1er9Fo7KTyU6SY6dQW8KarRbAN0zWrofeOHnver
        EdHOAAdzeqp8wdlFVz6pi8YMgw==
X-Google-Smtp-Source: APiQypI0A8PJKVgaS0meuPVlaPvfocGUfiVkxmyRS+dPjkui9z0Cj6/x2YMQuD8fNlV3vVje8fNMtQ==
X-Received: by 2002:a1c:4304:: with SMTP id q4mr11080546wma.152.1587736955755;
        Fri, 24 Apr 2020 07:02:35 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id v131sm3061051wmb.19.2020.04.24.07.02.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 07:02:34 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 06/14] crypto: sun8i-ss: better debug printing
Date:   Fri, 24 Apr 2020 14:02:06 +0000
Message-Id: <1587736934-22801-7-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
References: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
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
index cd408969bd03..8ab154842c9e 100644
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
2.26.2

