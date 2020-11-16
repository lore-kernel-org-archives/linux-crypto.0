Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97544C64E7C
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 13:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B861222B9
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Nov 2020 13:54:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="Ic5PMkRX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729264AbgKPNyS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Nov 2020 08:54:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbgKPNyR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Nov 2020 08:54:17 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A816C0613D1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2020 05:54:17 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id v21so565787pgi.2
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2020 05:54:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9KimMFHuJMnM9grT5G3KxuUOgh3PH0P48I8p4U+udaQ=;
        b=Ic5PMkRXlhVdSn1pWSmS1kPdU/KqAU1PUu1PX3YtldYe+Sw12gskyReuGYmw6982BL
         h3IUS/2dQ5DOb4jgGf0L/9FmfAkNhg6w+MXRznImvmZlRbWDeYLX16b5hhcJtBVTyp35
         an1y3QibWAPeRLmxXPV61hNeNpKixqczEROZ1WIhOPukNVFOUD+zjgmShh8Oml8bO5ez
         BLKrrkl6bUcHWBrGb/kF9ML1NNdaL53IAZAaAi5v57ZLvM7UnX0nD/antZWiZzK4kV3b
         kO67GdiNCqmHYFUFb1qlHlxKKwCW/X7OcbMEPJZWSrvWFcZHXCdSEb6q7ula/jvqvAu/
         v+oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9KimMFHuJMnM9grT5G3KxuUOgh3PH0P48I8p4U+udaQ=;
        b=dDWCKDj34n8+cWcdbqzfR0pf91keUJXkgETVan8qVNttP5Q2oIS3Mx57LO5a2D6kbM
         sIn6jfyoim8w12ZU2WZbS7z4IABU/NRS3fMA/gL/6OEmXj+3tRkUV16tewmukQ90FaHb
         peXyNI+eFRenyfNX1PtAupht5hAG07nqI+5pasfgo7eTX0GuJuOj61orHEUfDTUC3CCh
         Tu26sKsz6EFjAfz0KR6pOuIzZSqdgGvoxZtiRZVjVR6lLvexzyeq0EOD1YgwfjHahi/8
         pY2Fgsj9GPEunzeMWE0L8jUqL3V9wWXhPWzIlBNLaxaJHV0ZTO/bJwFR9n59kjzTZ0C8
         UOaQ==
X-Gm-Message-State: AOAM533kTMRACOWwY1uZcbL3KM1sBJA16ca6B5idm2ca/AwJ0BErg66O
        ZWXYGlLQXv039DZfT3fBn0e01g==
X-Google-Smtp-Source: ABdhPJwLmogq1AEKcuBJffxz+FZsXEOnjKY5VgObBdJzLoVsYhFPTClW06qKFMqUsrtUFUhBgorTuQ==
X-Received: by 2002:a63:154e:: with SMTP id 14mr13036618pgv.49.1605534857019;
        Mon, 16 Nov 2020 05:54:17 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id u22sm15864031pgf.24.2020.11.16.05.54.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 05:54:16 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 1/7] crypto: sun4i-ss: linearize buffers content must be kept
Date:   Mon, 16 Nov 2020 13:53:39 +0000
Message-Id: <20201116135345.11834-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201116135345.11834-1-clabbe@baylibre.com>
References: <20201116135345.11834-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When running the non-optimized cipher function, SS produce partial random
output.
This is due to linearize buffers being reseted after each loop.

For preserving stack, instead of moving them back to start of function,
I move them in sun4i_ss_ctx.

Fixes: 8d3bcb9900ca ("crypto: sun4i-ss - reduce stack usage")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 12 ++++--------
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h        |  2 ++
 2 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index b72de8939497..19f1aa577ed4 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -233,8 +233,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	while (oleft) {
 		if (ileft) {
-			char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
-
 			/*
 			 * todo is the number of consecutive 4byte word that we
 			 * can read from current SG
@@ -256,12 +254,12 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				 */
 				todo = min(rx_cnt * 4 - ob, ileft);
 				todo = min_t(size_t, todo, mi.length - oi);
-				memcpy(buf + ob, mi.addr + oi, todo);
+				memcpy(ss->buf + ob, mi.addr + oi, todo);
 				ileft -= todo;
 				oi += todo;
 				ob += todo;
 				if (!(ob % 4)) {
-					writesl(ss->base + SS_RXFIFO, buf,
+					writesl(ss->base + SS_RXFIFO, ss->buf,
 						ob / 4);
 					ob = 0;
 				}
@@ -295,13 +293,11 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				oo = 0;
 			}
 		} else {
-			char bufo[4 * SS_TX_MAX]; /* buffer for linearize SG dst */
-
 			/*
 			 * read obl bytes in bufo, we read at maximum for
 			 * emptying the device
 			 */
-			readsl(ss->base + SS_TXFIFO, bufo, tx_cnt);
+			readsl(ss->base + SS_TXFIFO, ss->bufo, tx_cnt);
 			obl = tx_cnt * 4;
 			obo = 0;
 			do {
@@ -313,7 +309,7 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				 */
 				todo = min_t(size_t,
 					     mo.length - oo, obl - obo);
-				memcpy(mo.addr + oo, bufo + obo, todo);
+				memcpy(mo.addr + oo, ss->bufo + obo, todo);
 				oleft -= todo;
 				obo += todo;
 				oo += todo;
diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
index 163962f9e284..02105b39fbfe 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss.h
@@ -148,6 +148,8 @@ struct sun4i_ss_ctx {
 	struct reset_control *reset;
 	struct device *dev;
 	struct resource *res;
+	char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
+	char bufo[4 * SS_TX_MAX]; /* buffer for linearize SG dst */
 	spinlock_t slock; /* control the use of the device */
 #ifdef CONFIG_CRYPTO_DEV_SUN4I_SS_PRNG
 	u32 seed[SS_SEED_LEN / BITS_PER_LONG];
-- 
2.26.2

