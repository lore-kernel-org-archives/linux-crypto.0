Return-Path: <SRS0=+94A=AC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303C4C433E1
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 19:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14BF325240
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Jun 2020 19:32:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="LO8UzHpE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730473AbgFUTbX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Jun 2020 15:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730385AbgFUTbU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Jun 2020 15:31:20 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB987C061795
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 12:31:19 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id b6so14549184wrs.11
        for <linux-crypto@vger.kernel.org>; Sun, 21 Jun 2020 12:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SU0E9luozURTZ9TC+AsIeijArTCKSbuhSsq3JPq3G+Q=;
        b=LO8UzHpETYPvNo1e9VsCpz5L5EBXdv+Qr0TT4+X9oue83KoQ8fjr2lS16bVGwb1hNQ
         ZKTIJTrQn7+ABlFu9R4vyuR98AkdUwjGk8jqimDcqO8Y+smuK43NMkieNLUUb7gr8qfU
         /B4N8Vv4T3/5dYP2+Ptno4F6Tdmwnu94Gbe0yNEoPzfI3LWLrfwMEM0pm+VN/HD1Rx1i
         FFaJnTcY285iSA5K/R6lIW3eneHTwZpyYOzRF7Q1+jiuXsoU6W1/+ZEVo0euE9gPBLLa
         hRuoBI2nG4fPA38w+9IAvSPHGEqsH1YByEoN+GcZIoq9hJYmhIcDeBEJrzJmZsZeAdqI
         UV5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SU0E9luozURTZ9TC+AsIeijArTCKSbuhSsq3JPq3G+Q=;
        b=c9mH5Ehw2uCOauyGmxPMlTJzF1SlWtyU5uQE/fdhx1Yydm+UYeDl9vk+ThVv2zlqm/
         x+vPgkV4XQBpRS5zb4SMe4T5s8M7QFl8vAVDIxiqyHZyzKBng8/IVttVC+apafDm5/jh
         +W5SH23t319Ma54a2SXH0Wa8a/ZyDp5jT5tfAp9rxvGVklgwuEys503twIMO6Tz4VxxQ
         Er4XalGsMMTKs9VCazMUGvYaOd50KqUyzrBfsBFdgE58VdXdVyurNRINdXazJ6oPZSHD
         xo93ui5vrkuDAEI5oaivZfH8iiIj/OH/AlDOlzxMM5UQh/BgXqG41EaYqN/WRGaPxImG
         rUQQ==
X-Gm-Message-State: AOAM533KmsVYYGrhq/AwqtcHnkftEq+xPDdx4tqkdtnwL5sEE4hXQnXy
        DZUc48RW1qz9O94OQLHd6esWNw==
X-Google-Smtp-Source: ABdhPJyu7IsUkvwcU6DqOz28NDWp0RrQ+yIcr/B2mB9koq0CWDI6Nnx2t9u+LFRNKkyfEUezVJlRGw==
X-Received: by 2002:a5d:40d2:: with SMTP id b18mr14893904wrq.131.1592767878740;
        Sun, 21 Jun 2020 12:31:18 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e3sm16086924wrj.17.2020.06.21.12.31.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jun 2020 12:31:18 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 06/14] crypto: sun8i-ss: better debug printing
Date:   Sun, 21 Jun 2020 19:30:59 +0000
Message-Id: <1592767867-35982-7-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1592767867-35982-1-git-send-email-clabbe@baylibre.com>
References: <1592767867-35982-1-git-send-email-clabbe@baylibre.com>
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

