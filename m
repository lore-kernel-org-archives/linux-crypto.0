Return-Path: <SRS0=yTfj=C2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CE07C43461
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 18:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0315821D24
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 18:37:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="t1F4i2ut"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726385AbgIQSgy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Sep 2020 14:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbgIQSgR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Sep 2020 14:36:17 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D51DC06178C
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 11:36:17 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id g4so3119354wrs.5
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 11:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XM0rn9lgSMh+/oP0wbhw4Z0Og4lOLAMikZRs+DnstJg=;
        b=t1F4i2utZ2d6rs6DCDEg4dyCXwYJlvBxt8DAK7YCJPHWLEuWYXH+YP7uoYpl016u8t
         R4PnzNq5M2D/veKMddKOixuoUYhHx0Ug4NcDn0Lq4wFCE0AlpgKfh9rf/6jG5dtNyR6R
         DOpOWrtTBqxl96lLAdOcxUVPkbt4v8lWwcTJpGp66IEn3Jg6jiLT0n7khrcG6R1nkY/e
         iUrlTNbDuw47FgRinC3Jlk4Nqi6JcZX7zeDcWOZSvyNib80nmJ7wJ6HAj1OjwjZrsRq6
         lCv79+SzNgXnA0VhnjgiGBEAtTHLSyq+kQgc2XdhLMOurmIsXN0b9RbDLGKkktFjqb6/
         TyXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=XM0rn9lgSMh+/oP0wbhw4Z0Og4lOLAMikZRs+DnstJg=;
        b=R1fyf0Jgth17tRcRbR+eMMYlwdyt1+pCW9ERSfSbJLBQ87k9beB7FeDHGeK61m+7SS
         lsv6KND8V5wKGPHyNc1P7bjdpN9FFr/n+lsdotbPEeE94NOrhNHZFT2AOpklqRr7wkrY
         O6PUqS+zXqPX43D97vNS9WmTr0zHUy75Z7oRafSiM+cceDBz7vCz3hVkDT38+orsXrPL
         EW++0uScbhJMQMRzLQRToCEf9EwQ2dfwatR4CWCnLWcSjTBLqkihMDL1y/i5ZBhwoMLQ
         feZFWPDZ5jgmrHqyNcPsWczivQE9tsmSFnBMF7Z2KIW84rvMDGrb5FeSLS076DJkpHUf
         fXzA==
X-Gm-Message-State: AOAM532JkQmXKLigVUPjiStD1Yfm0t+5yf3N1rG+6nb/rkbv/HVqJ5fz
        Kyw71G7yMIqr9lt7JK1g8Ul7KQ==
X-Google-Smtp-Source: ABdhPJxBCR6h6xFHou/Y3/DMQ76QCXKRZvp9f6aSU4/C91Y2zTMNW6ZBe33yJ+uulWo9T5gTTbvvuA==
X-Received: by 2002:adf:edd2:: with SMTP id v18mr33152164wro.242.1600367774867;
        Thu, 17 Sep 2020 11:36:14 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id x16sm571901wrq.62.2020.09.17.11.36.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 11:36:14 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 7/7] crypto: sun4i-ss: add SPDX header and remove blank lines
Date:   Thu, 17 Sep 2020 18:35:58 +0000
Message-Id: <1600367758-28589-8-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
References: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchs fixes some remaining style issue.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 3 ---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c   | 1 +
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index be6599220e9d..2011aa4f0415 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -137,7 +137,6 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	return err;
 }
 
-
 static int noinline_for_stack sun4i_ss_cipher_poll_fallback(struct skcipher_request *areq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
@@ -549,7 +548,6 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
 				    sizeof(struct sun4i_cipher_req_ctx) +
 				    crypto_skcipher_reqsize(op->fallback_tfm));
 
-
 	err = pm_runtime_get_sync(op->ss->dev);
 	if (err < 0)
 		goto error_pm;
@@ -636,5 +634,4 @@ int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	crypto_skcipher_set_flags(op->fallback_tfm, tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
 
 	return crypto_skcipher_setkey(op->fallback_tfm, key, keylen);
-
 }
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
index 102f8a90ce0f..4d1610952e90 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 #include "sun4i-ss.h"
 
 int sun4i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed,
-- 
2.26.2

