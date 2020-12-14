Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35362C2BB40
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8DC622512
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502944AbgLNUDp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502956AbgLNUDg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 15:03:36 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D7EC061794
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:02:56 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id w5so12593972pgj.3
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:02:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IcIRwkZ8OZdNHBj5vIxvJw4vzDArIn2JvgviRxGrME0=;
        b=BxgQm4GOTVDXkX8er1nP7MnoFp1SSFm0fOFDppClgd5e+RfY2YSQO8U4xhDsZydL5y
         droFoRW+xtGGZFSuvMCLYmX8CUXDRlCQqvnTjQbUliug0cF4rTfHEYnIPQze9c0U0qus
         tklfphhmK4d0q+PrZmu183Z4Fg+pOj7XuHPJP9HynYRtzL8CLCXyGG5yB9T/OGtTLPjO
         sIcpoFFAeTtn1pdBu8NOzVT45MXxKguubd/z2WpkQIKwpJYS5stNxIAdadtDCvgD06/Y
         J/BAt2YVUv31WZakw51Gk24D5Yerypg62C2s3vKJH49JjF97nmlzCyoI28ezisy34xBN
         EGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IcIRwkZ8OZdNHBj5vIxvJw4vzDArIn2JvgviRxGrME0=;
        b=K3Cs5MUVf0clhnaaKz1feeZVguPpHmfS2HZyYgOembX7ktuMMv7+QcJZdPHUz3r7yl
         cY6EMDLKZU7NloeUPxikZbSf33MeCN4uATuOFy2LMvJ/K8qaLCMOex175j5oxD8M47Ap
         epal0vVDvuGp1XS46w45RRT3+JeUGriOuRNPU9YsWnj57rm5suJppkdWOJk9ps1h9zAg
         F9pIjXciv901CfFzVG+/4ECyKwFZAaKSYSPV/21hKDWMtUVOGcMzHc2qnRJY6hAQxLNZ
         dfEOBECZZDGL4ZCcpG8hoUf4g/jYe72On4UU8BFfeZhxXTLLALO4xZPylmgDNltRdNod
         hluQ==
X-Gm-Message-State: AOAM530qPWhcrsa5IMvfsSA+F3gLGqFXVUJk3fQOZ5OknUWWwWbqUcrG
        hSTpDJ1RTy34BhcW2lTwrTJxmw==
X-Google-Smtp-Source: ABdhPJwO/V/z0sxQfPRx31wpvQ3CP7pHObiVAuAdG03+4tQ8oJkJX2O9uVVXDk6uzKgWyKip5r4pFQ==
X-Received: by 2002:a63:5849:: with SMTP id i9mr25981184pgm.271.1607976176314;
        Mon, 14 Dec 2020 12:02:56 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id js9sm22434109pjb.2.2020.12.14.12.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:02:55 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 1/8] crypto: sun4i-ss: linearize buffers content must be kept
Date:   Mon, 14 Dec 2020 20:02:25 +0000
Message-Id: <20201214200232.17357-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214200232.17357-1-clabbe@baylibre.com>
References: <20201214200232.17357-1-clabbe@baylibre.com>
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
index 5c291e4a6857..c242fccb2ab6 100644
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

