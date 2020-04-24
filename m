Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF0FC55194
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BDDE21582
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 14:02:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="cA4XqStY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbgDXOC0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 10:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727082AbgDXOC0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 10:02:26 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D1FC09B045
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:25 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z6so10874535wml.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2020 07:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LFDRXwTitCs1nrRc2jOX6sWRaTpGwdnr5FsLJM6PpMw=;
        b=cA4XqStYQ3bJdc/z0XtvsleabRXRTvKKpGNZXfAxCX/J4R/VlS1P2nRctqDhYN9uL6
         hA2YNT9vS+RusmqhGcnw6UYAyyjSiXRvqiayiQ9336ybq5F86jrE1LigdDmvO94775Zq
         XCFX1a6iT7SxxQIlDlmf0D2WspHCYl+NATRjv9SPxzCGKYcOIB2zun6fmLqT/KS9nBEo
         VuEE33Bv6CK7A7p0hZOa2PZyEsdOA64WDIWpuGwahdB+RURUS8C+JTUP4NT+/mar1Mbo
         2cZ1DyAtdkF/RrPfpKJrf7nI0UCnzZRL2GgoKIRtyGGJe8MswS4KBW1ZPXReZYKaE8xR
         EYag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LFDRXwTitCs1nrRc2jOX6sWRaTpGwdnr5FsLJM6PpMw=;
        b=LfHC/ErOkBNpPKVmTgABQdcDTPk9C+vNMmFWQZtcX+nj3hU4PXvXIJcpmYCdQ5GTvJ
         q23NGaoHwA2odVAtV3LG9I8r7ep0Rk8+a49voZEXyID72DPRyEy/KxScdQCYn/E1q54g
         3ElQHM0VibxDc2L3DJtS0c9UW0+dODzPUkLk7sg8dYRBNsEkDm9UUAjGCqQbsDRA3EwT
         X0zfk4fRSRVGaV46tQazQZaKOdWgkygACikUYOQEjGwsFmwTd8YNNVIVnYXQkEccZ8ag
         eIMZyT50ie5c8FIf6VgwtgjpxlXpE0zAVAzfNc4NjKkBSDCM58gjYYhjB9+vyxqDQPTO
         MydQ==
X-Gm-Message-State: AGi0PuY5LuSdOieiMYURSmOWFWtOahknn+ELPlxUdbpSVgP/zVtPj7nM
        AafmjOi3RL2vCJtle/zFClNjDQ==
X-Google-Smtp-Source: APiQypI7FP3oDj+Ga1cJJbsF1kwlbSAYMlbf8X/KovxXObcFQAoCwc5XUxK3qZl570o61YXVEbKfzQ==
X-Received: by 2002:a05:600c:290f:: with SMTP id i15mr9772059wmd.167.1587736944462;
        Fri, 24 Apr 2020 07:02:24 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id v131sm3061051wmb.19.2020.04.24.07.02.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 07:02:23 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 01/14] crypto: sun8i-ss: Add SS_START define
Date:   Fri, 24 Apr 2020 14:02:01 +0000
Message-Id: <1587736934-22801-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
References: <1587736934-22801-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of using an hardcoded value, let's use a defined value for
SS_START.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c | 2 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h      | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 5d9d0fedcb06..81eff935fb5c 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -61,7 +61,7 @@ int sun8i_ss_run_task(struct sun8i_ss_dev *ss, struct sun8i_cipher_req_ctx *rctx
 		      const char *name)
 {
 	int flow = rctx->flow;
-	u32 v = 1;
+	u32 v = SS_START;
 	int i;
 
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index 29c44f279112..f7a64033fc03 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -13,6 +13,8 @@
 #include <linux/debugfs.h>
 #include <linux/crypto.h>
 
+#define SS_START	1
+
 #define SS_ENCRYPTION		0
 #define SS_DECRYPTION		BIT(6)
 
-- 
2.26.2

