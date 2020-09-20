Return-Path: <SRS0=6s16=C5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 947B9C43465
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 18:37:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 53286207BB
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 18:37:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="kqyC244Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgITShn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Sep 2020 14:37:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgITShd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Sep 2020 14:37:33 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E009CC061755
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2020 11:37:32 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id z9so10367499wmk.1
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2020 11:37:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ak5yUn/HwPwh2LarMLINzwpMFmwyFpMzNUg8yxcj+9E=;
        b=kqyC244ZUrr+OGvHrenlLr4NXJg0ICZFMRPzTVeKpgjPv3CwO0vDfsOqTHrf4/EOei
         mIMKqiJd5yVxd9TQzQ7IRQk8jI8yyBm3X+ryl82MxHKNLCuRxtc9OcelqfLrOGVLzGWG
         Jp0ta8tk8EYeFjCM3ToAFqxvHV20SZerE5CYbUZQIL3Ga8uwHjMSYdZmiqXAcFNuzeiq
         ON4H2d7wBoxixhIGpd59wZXq4nURMeaPp9ngqFvxLVMMyPb6p4+cLz8NKRvWfkaW9g7H
         C/Tm1UpwDuU9rbTyR6+ul5V/TnKmsw/kBtutElXRiqgk91oXuI3InCse7yLPrEZzJ+Cy
         z5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ak5yUn/HwPwh2LarMLINzwpMFmwyFpMzNUg8yxcj+9E=;
        b=O+dqNkWeDR05PyokdBq+HXCxInxxXOBCxbKz/ImrbXLnOwXZjqh+AlD6c6Bbd21MNT
         jSjW9z/f/KnrlcxX+w2ScRngb+uzR2G+31Azk7jNkgCu2HtZsAPV1MNmEgKUaeem7V1x
         he8RfNzdYDDzwJJLVjxG0c5Lcy+Q1pHv3CwYOXCgv5qhXAgtdovuC6LhJz7DTKZnKF7+
         v5P0zerYJOrOo1Ce12AZonfpzotGgxLx7nAlJRi867L+uavX3JC0VFY9R3HSaeTE0jK2
         kdC44yuQQ09mUuIAU8m1GSeXmdw3o7flD8Wzr5RRQwBN6pmMOaLJy8+yugb1cwLHsABp
         RyMw==
X-Gm-Message-State: AOAM5300mxPWN9MLgFKwZLcuiN4h+absbtE8CEWdKQZnoy0Si3i9eIc7
        5xZl1o+ag3ECQoIj9gt4bBCZxQ==
X-Google-Smtp-Source: ABdhPJxygsyfg5yVhWw6vSFMg8ycLN6WBvpVpQT8imbOMME8fIFWZPFMYhYGBdqb/exUcPjfaZQcig==
X-Received: by 2002:a1c:3d44:: with SMTP id k65mr25521614wma.132.1600627051042;
        Sun, 20 Sep 2020 11:37:31 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e18sm16419841wrx.50.2020.09.20.11.37.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 11:37:30 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 7/7] crypto: sun4i-ss: add SPDX header and remove blank lines
Date:   Sun, 20 Sep 2020 18:37:18 +0000
Message-Id: <1600627038-40000-8-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
References: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
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
index 2ec359eaa4cf..3f19c00f1b0b 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -137,7 +137,6 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	return err;
 }
 
-
 static int noinline_for_stack sun4i_ss_cipher_poll_fallback(struct skcipher_request *areq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
@@ -544,7 +543,6 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
 				    sizeof(struct sun4i_cipher_req_ctx) +
 				    crypto_skcipher_reqsize(op->fallback_tfm));
 
-
 	err = pm_runtime_get_sync(op->ss->dev);
 	if (err < 0)
 		goto error_pm;
@@ -631,5 +629,4 @@ int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
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

