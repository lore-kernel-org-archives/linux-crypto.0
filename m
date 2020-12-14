Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8605C2BB48
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 717E8207A0
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502909AbgLNUEp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503003AbgLNUEf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 15:04:35 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EC6C061794
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:03:43 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id w4so13333446pgg.13
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=glOnBFiECF8TpThPY1T9sfOwrbTI0Z62FinuvRqJFM0=;
        b=Ihg/wFKGpdoKe519ELAQtVqcDaavMDG5r1bihOEcNRbZQC+E7hplzqpQEDgnpdH4j+
         Oq4WgDsgFsUhl2gaWy8jb2LcpU6VfJdTj6goH9M5mG8HI3M9NSfZXSjLLnRzMDPxRtZs
         IimAH8Frd9xs5hPPBaUPviKS0I7ce5DX4v0ZMKbI11ovv2oy9SoqLOumdsXFRraW1ef6
         9resbu3JryZ2X3XZ6eUytHER6uZ/MiBvaApyfiaQoE3wk1lLeFkuAxTAtI7gDcBRsy3G
         UBZto2UDXbLui+9dqZ0GmYsiYJ2T2wxV7cNEUQls7zJ7ffuD4TV8Jowwfi9/FyzTiK9K
         4CXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=glOnBFiECF8TpThPY1T9sfOwrbTI0Z62FinuvRqJFM0=;
        b=m/symo0rwdZic86N3GtZslXn2YBITnnq4Nlmss9ph5wbiX9Y1jN1TpCLRAorqsZG55
         y7wRFn+R9MgwVjQkJ+4qmz5EZrbqvn6namStghihFvJhF0PWnejgmFGbCndLPG/MC3J6
         S2zDCot+AS1JgrrtuxDRVZVMuOeT3JpOJLzGk6yFEL6ROiecy8EqVJugHBfiNB2emgVx
         AltR5MlRqcblAY4KjV3ffybQ91rl76pjB9+ME/+M3qaq41C96svRa94azQ84mSuWW2NG
         PxK3alG7dKWDNF2TOL8/Nve5KhhIFvZGy6z7YHatxDuvRHQZfMdyGkTzsXGFKfm4pJcb
         tHVg==
X-Gm-Message-State: AOAM533Y9RyNWbxwBdz6g7SvQN4jtUHNusd/KNqyB/trpak4VXCGRGp3
        MSAvrfjPNU9JalXYbBWiNDjK6g==
X-Google-Smtp-Source: ABdhPJwvuNU7fNETFGXKRki8LGh9J9X3JjvJeJr8KA/CryX3oDtGLsr/ecJej4eRH91ApwyyhXsmww==
X-Received: by 2002:a63:4f4c:: with SMTP id p12mr23050633pgl.432.1607976221864;
        Mon, 14 Dec 2020 12:03:41 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id js9sm22434109pjb.2.2020.12.14.12.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:03:41 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 8/8] crypto: sun4i-ss: add SPDX header and remove blank lines
Date:   Mon, 14 Dec 2020 20:02:32 +0000
Message-Id: <20201214200232.17357-9-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214200232.17357-1-clabbe@baylibre.com>
References: <20201214200232.17357-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchs fixes some remaining style issue.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 3 ---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c   | 1 +
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index d5275d914d09..c2e6f5ed1d79 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -148,7 +148,6 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	return err;
 }
 
-
 static int noinline_for_stack sun4i_ss_cipher_poll_fallback(struct skcipher_request *areq)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
@@ -562,7 +561,6 @@ int sun4i_ss_cipher_init(struct crypto_tfm *tfm)
 				    sizeof(struct sun4i_cipher_req_ctx) +
 				    crypto_skcipher_reqsize(op->fallback_tfm));
 
-
 	err = pm_runtime_get_sync(op->ss->dev);
 	if (err < 0)
 		goto error_pm;
@@ -649,5 +647,4 @@ int sun4i_ss_des3_setkey(struct crypto_skcipher *tfm, const u8 *key,
 	crypto_skcipher_set_flags(op->fallback_tfm, tfm->base.crt_flags & CRYPTO_TFM_REQ_MASK);
 
 	return crypto_skcipher_setkey(op->fallback_tfm, key, keylen);
-
 }
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
index 152841076e3a..443160a114bb 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-prng.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
 #include "sun4i-ss.h"
 
 int sun4i_ss_prng_seed(struct crypto_rng *tfm, const u8 *seed,
-- 
2.26.2

