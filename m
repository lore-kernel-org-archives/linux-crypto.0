Return-Path: <SRS0=6s16=C5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7A7BC43463
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 18:37:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76F0321789
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 18:37:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="NJyb9kIF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbgITShr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Sep 2020 14:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbgITShc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Sep 2020 14:37:32 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0ECC0613D3
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2020 11:37:28 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id z9so10367390wmk.1
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2020 11:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=huiz4hWuEDAzBaczeTBJaesBVDz4VU4ls/AvOgJWeOk=;
        b=NJyb9kIFE/CthzhB4unI7Fmylr/83s0udqDUg2mdWAjKOkkMxeZcaiuYQNanTBeUJB
         GdfMBRs/1TR5EI7Fw7Spdcz6XKGxReckwGNC+dM5iviTrjJja2r5dGsaKCIS+BJli/BK
         QP1A8RsAko1XFRDsQE6TtGErG85J7k3ZHlf956ywSzC+huS0B8AQL+WmQL67SwCy0K9T
         PUv+Xq277PgRT4gKtsLqxjc58rynv0Ero3znor32MPMMcpLPezUJYXuxJ1/DDie4/AlS
         rT5jM4X1IFvqjIG1MdKk7E24u4X3klqR7C1G/t710ZHP+DkmX4sFmNCP4H8ZE4LKE3mJ
         uBsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=huiz4hWuEDAzBaczeTBJaesBVDz4VU4ls/AvOgJWeOk=;
        b=HP3Z9VrONW57pBJkmVet4M1xxr/bIEhT+8hto5Ng3WCMxZ0iY0cmozmRp7OmGxzoql
         ZPNY+Q0JIt1GVyLwqzJCrDGSWMcL8+IioDqZVZ6Mzqo9uHGff6pa+4zcJ5YQrWindyUV
         TiRbKTnxrZczAiq1jNu5h6hai1mPumaDEwuUwu5ZKeh5mSh27eRtFV+ALCfpT1GZXTsA
         fme3sVwRhelFq+sucdJ9DxVv/dReq4cwtJnfQLE3G3BBmHhrZyMsIIMIFFK6ckQCj0QS
         Kn1wasdFX+0/aCAK8Yk1ocWjfTfe4ToR5wOOJA6WNtPCY55DWjMRH9IqprkK6U7+MrFT
         TwOw==
X-Gm-Message-State: AOAM5323NSVt5fQNjVVrhNnRKJc18DyL8khBs7pL8z/WBvnNe96sI19w
        Si1yR4P9hG4BrMtdDOSsVwUxdgPpp7/nkQ==
X-Google-Smtp-Source: ABdhPJxlW7YndNuMU5bTLBRvti9rCp3LJ0Og/iDwJDuLz/GP8bWpCiL+y6oZwC3+DzIN4Mq+kjfm2g==
X-Received: by 2002:a1c:23c8:: with SMTP id j191mr25370500wmj.64.1600627047323;
        Sun, 20 Sep 2020 11:37:27 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e18sm16419841wrx.50.2020.09.20.11.37.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 11:37:26 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>, stable@vger.kernel.org
Subject: [PATCH v2 3/7] crypto: sun4i-ss: IV register does not work on A10 and A13
Date:   Sun, 20 Sep 2020 18:37:14 +0000
Message-Id: <1600627038-40000-4-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
References: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Allwinner A10 and A13 SoC have a version of the SS which produce
invalid IV in IVx register.

Instead of adding a variant for those, let's convert SS to produce IV
directly from data.
Fixes: 6298e948215f2 ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Cc: <stable@vger.kernel.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      | 34 +++++++++++++++----
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index 2614640231dc..c6c25204780d 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -20,6 +20,7 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	unsigned int ivsize = crypto_skcipher_ivsize(tfm);
 	struct sun4i_cipher_req_ctx *ctx = skcipher_request_ctx(areq);
 	u32 mode = ctx->mode;
+	void *backup_iv = NULL;
 	/* when activating SS, the default FIFO space is SS_RX_DEFAULT(32) */
 	u32 rx_cnt = SS_RX_DEFAULT;
 	u32 tx_cnt = 0;
@@ -42,6 +43,13 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 		return -EINVAL;
 	}
 
+	if (areq->iv && ivsize > 0 && mode & SS_DECRYPTION) {
+		backup_iv = kzalloc(ivsize, GFP_KERNEL);
+		if (!backup_iv)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(backup_iv, areq->src, areq->cryptlen - ivsize, ivsize, 0);
+	}
+
 	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen; i += 4)
@@ -102,9 +110,12 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	} while (oleft);
 
 	if (areq->iv) {
-		for (i = 0; i < 4 && i < ivsize / 4; i++) {
-			v = readl(ss->base + SS_IV0 + i * 4);
-			*(u32 *)(areq->iv + i * 4) = v;
+		if (mode & SS_DECRYPTION) {
+			memcpy(areq->iv, backup_iv, ivsize);
+			kfree_sensitive(backup_iv);
+		} else {
+			scatterwalk_map_and_copy(areq->iv, areq->dst, areq->cryptlen - ivsize,
+						 ivsize, 0);
 		}
 	}
 
@@ -161,6 +172,7 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int ileft = areq->cryptlen;
 	unsigned int oleft = areq->cryptlen;
 	unsigned int todo;
+	void *backup_iv = NULL;
 	struct sg_mapping_iter mi, mo;
 	unsigned int oi, oo;	/* offset for in and out */
 	char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
@@ -204,6 +216,13 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	if (need_fallback)
 		return sun4i_ss_cipher_poll_fallback(areq);
 
+	if (areq->iv && ivsize > 0 && mode & SS_DECRYPTION) {
+		backup_iv = kzalloc(ivsize, GFP_KERNEL);
+		if (!backup_iv)
+			return -ENOMEM;
+		scatterwalk_map_and_copy(backup_iv, areq->src, areq->cryptlen - ivsize, ivsize, 0);
+	}
+
 	spin_lock_irqsave(&ss->slock, flags);
 
 	for (i = 0; i < op->keylen; i += 4)
@@ -324,9 +343,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 		}
 	}
 	if (areq->iv) {
-		for (i = 0; i < 4 && i < ivsize / 4; i++) {
-			v = readl(ss->base + SS_IV0 + i * 4);
-			*(u32 *)(areq->iv + i * 4) = v;
+		if (mode & SS_DECRYPTION) {
+			memcpy(areq->iv, backup_iv, ivsize);
+			kfree_sensitive(backup_iv);
+		} else {
+			scatterwalk_map_and_copy(areq->iv, areq->dst, areq->cryptlen - ivsize,
+						 ivsize, 0);
 		}
 	}
 
-- 
2.26.2

