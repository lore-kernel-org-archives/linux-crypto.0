Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89B3AC2BB9A
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534842168B
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Dec 2020 20:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502929AbgLNUEt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Dec 2020 15:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2502925AbgLNUEb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Dec 2020 15:04:31 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1576C0611CD
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:03:29 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id q4so3666549plr.7
        for <linux-crypto@vger.kernel.org>; Mon, 14 Dec 2020 12:03:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/NQcBcxnSSCbTyD9KLIq28pNKLVWeJF0Xi2g4zRlj5Q=;
        b=BWDbKhjIvlRnDFMJS30nLErO8n5zQGQOFr1GBmhiQ/z5Sbj/gTfISm+/YyP+1ejNIx
         BhfOtwhF44hLrad5DcFQ+cN/J6SylBqt31eT4nYLCVZ7bh6x6KszGxEmUuRKUZWatp6+
         dIvo65hW3LpA6XtZIbkKL3igOiCQXoa4+T/Kqf6G/ixh1pmKNZld1WOINtrK07GLWFSp
         psYayT4MMDC5yIVWSuLTPFRdI78XqUZU+i4p+zHerSrQFfh9MDIj4tFNNH4hBZgase8V
         IAEQImbr5FvbiCd0Wa+duYix6UHO+QvIMT5iN1nrcxr8JWaU5o5pd2RCBRkprysJbMiz
         SCrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/NQcBcxnSSCbTyD9KLIq28pNKLVWeJF0Xi2g4zRlj5Q=;
        b=Rtc4WxFLjCm0fgJzRucy/dkXGf5spyzLbR5hipxkMkuWkd6flSDmzIlY1za2HjCsuN
         DHMDHd7RqUdTvgHNd1V7R4dy1/fjwbblXaAizvXBauvCpGbByJuAac00fDSk3AqE7evx
         ZMZgHgZ5uCeejDRbm1JlEMiMoTwYtWAoDjVMjpOE/kZm2RrXOnZIP5Ux2cOo0T7mCsEC
         HYzFBwJ5xDiwnoshKlZZJTRyQNsBEAuFs12Z3OJ/3phAtuBDJUrPhEDTM60rSWerWxMA
         FZMDAdFwnhXZIck38A8mgG6uUlB6K8mq3G+xZZalgupELu5WGsx3xAt3+2aqFH+/KMca
         SdEw==
X-Gm-Message-State: AOAM5305cnmCz4P4LEluFIT8hSB7ooNj77mXwHKQdlcKwWTWoDOlhotj
        Qbswl4YqhHpVg3J6LeoGorBi5X1JtnxrZA==
X-Google-Smtp-Source: ABdhPJzVftKX3JHllPFJXT+Px6ObnhPcoq33wsrCnt7OC07UiXA3O0/RMhAm/IYNx/ni//62ovC1Pw==
X-Received: by 2002:a17:90a:9f44:: with SMTP id q4mr27157886pjv.226.1607976209548;
        Mon, 14 Dec 2020 12:03:29 -0800 (PST)
Received: from localhost.localdomain ([163.172.76.58])
        by smtp.googlemail.com with ESMTPSA id js9sm22434109pjb.2.2020.12.14.12.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 12:03:29 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@siol.net, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 6/8] crypto: sun4i-ss: fix kmap usage
Date:   Mon, 14 Dec 2020 20:02:30 +0000
Message-Id: <20201214200232.17357-7-clabbe@baylibre.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201214200232.17357-1-clabbe@baylibre.com>
References: <20201214200232.17357-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

With the recent kmap change, some tests which were conditional on
CONFIG_DEBUG_HIGHMEM now are enabled by default.
This permit to detect a problem in sun4i-ss usage of kmap.

sun4i-ss uses two kmap via sg_miter (one for input, one for output), but
using two kmap at the same time is hard:
"the ordering has to be correct and with sg_miter that's probably hard to get
right." (quoting Tlgx)

So the easiest solution is to never have two sg_miter/kmap open at the same time.
After each use of sg_miter, I store the current index, for being able to
resume sg_miter to the right place.

Fixes: 6298e948215f ("crypto: sunxi-ss - Add Allwinner Security System crypto accelerator")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../allwinner/sun4i-ss/sun4i-ss-cipher.c      | 109 +++++++++++-------
 1 file changed, 65 insertions(+), 44 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index 5759fa79f293..ffa628c89e21 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -31,6 +31,8 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	unsigned int ileft = areq->cryptlen;
 	unsigned int oleft = areq->cryptlen;
 	unsigned int todo;
+	unsigned long pi = 0, po = 0; /* progress for in and out */
+	bool miter_err;
 	struct sg_mapping_iter mi, mo;
 	unsigned int oi, oo; /* offset for in and out */
 	unsigned long flags;
@@ -63,39 +65,51 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	}
 	writel(mode, ss->base + SS_CTL);
 
-	sg_miter_start(&mi, areq->src, sg_nents(areq->src),
-		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
-	sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
-		       SG_MITER_TO_SG | SG_MITER_ATOMIC);
-	sg_miter_next(&mi);
-	sg_miter_next(&mo);
-	if (!mi.addr || !mo.addr) {
-		dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
-		err = -EINVAL;
-		goto release_ss;
-	}
 
 	ileft = areq->cryptlen / 4;
 	oleft = areq->cryptlen / 4;
 	oi = 0;
 	oo = 0;
 	do {
-		todo = min(rx_cnt, ileft);
-		todo = min_t(size_t, todo, (mi.length - oi) / 4);
-		if (todo) {
-			ileft -= todo;
-			writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);
-			oi += todo * 4;
-		}
-		if (oi == mi.length) {
-			sg_miter_next(&mi);
-			oi = 0;
+		if (ileft) {
+			sg_miter_start(&mi, areq->src, sg_nents(areq->src),
+					SG_MITER_FROM_SG | SG_MITER_ATOMIC);
+			if (pi)
+				sg_miter_skip(&mi, pi);
+			miter_err = sg_miter_next(&mi);
+			if (!miter_err || !mi.addr) {
+				dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
+				err = -EINVAL;
+				goto release_ss;
+			}
+			todo = min(rx_cnt, ileft);
+			todo = min_t(size_t, todo, (mi.length - oi) / 4);
+			if (todo) {
+				ileft -= todo;
+				writesl(ss->base + SS_RXFIFO, mi.addr + oi, todo);
+				oi += todo * 4;
+			}
+			if (oi == mi.length) {
+				pi += mi.length;
+				oi = 0;
+			}
+			sg_miter_stop(&mi);
 		}
 
 		spaces = readl(ss->base + SS_FCSR);
 		rx_cnt = SS_RXFIFO_SPACES(spaces);
 		tx_cnt = SS_TXFIFO_SPACES(spaces);
 
+		sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
+			       SG_MITER_TO_SG | SG_MITER_ATOMIC);
+		if (po)
+			sg_miter_skip(&mo, po);
+		miter_err = sg_miter_next(&mo);
+		if (!miter_err || !mo.addr) {
+			dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
+			err = -EINVAL;
+			goto release_ss;
+		}
 		todo = min(tx_cnt, oleft);
 		todo = min_t(size_t, todo, (mo.length - oo) / 4);
 		if (todo) {
@@ -104,9 +118,10 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 			oo += todo * 4;
 		}
 		if (oo == mo.length) {
-			sg_miter_next(&mo);
 			oo = 0;
+			po += mo.length;
 		}
+		sg_miter_stop(&mo);
 	} while (oleft);
 
 	if (areq->iv) {
@@ -120,8 +135,6 @@ static int noinline_for_stack sun4i_ss_opti_poll(struct skcipher_request *areq)
 	}
 
 release_ss:
-	sg_miter_stop(&mi);
-	sg_miter_stop(&mo);
 	writel(0, ss->base + SS_CTL);
 	spin_unlock_irqrestore(&ss->slock, flags);
 	return err;
@@ -174,6 +187,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int todo;
 	void *backup_iv = NULL;
 	struct sg_mapping_iter mi, mo;
+	unsigned long pi = 0, po = 0; /* progress for in and out */
+	bool miter_err;
 	unsigned int oi, oo;	/* offset for in and out */
 	unsigned int ob = 0;	/* offset in buf */
 	unsigned int obo = 0;	/* offset in bufo*/
@@ -234,17 +249,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	}
 	writel(mode, ss->base + SS_CTL);
 
-	sg_miter_start(&mi, areq->src, sg_nents(areq->src),
-		       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
-	sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
-		       SG_MITER_TO_SG | SG_MITER_ATOMIC);
-	sg_miter_next(&mi);
-	sg_miter_next(&mo);
-	if (!mi.addr || !mo.addr) {
-		dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
-		err = -EINVAL;
-		goto release_ss;
-	}
 	ileft = areq->cryptlen;
 	oleft = areq->cryptlen;
 	oi = 0;
@@ -252,6 +256,16 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	while (oleft) {
 		if (ileft) {
+			sg_miter_start(&mi, areq->src, sg_nents(areq->src),
+				       SG_MITER_FROM_SG | SG_MITER_ATOMIC);
+			if (pi)
+				sg_miter_skip(&mi, pi);
+			miter_err = sg_miter_next(&mi);
+			if (!miter_err || !mi.addr) {
+				dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
+				err = -EINVAL;
+				goto release_ss;
+			}
 			/*
 			 * todo is the number of consecutive 4byte word that we
 			 * can read from current SG
@@ -284,31 +298,38 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				}
 			}
 			if (oi == mi.length) {
-				sg_miter_next(&mi);
+				pi += mi.length;
 				oi = 0;
 			}
+			sg_miter_stop(&mi);
 		}
 
 		spaces = readl(ss->base + SS_FCSR);
 		rx_cnt = SS_RXFIFO_SPACES(spaces);
 		tx_cnt = SS_TXFIFO_SPACES(spaces);
-		dev_dbg(ss->dev,
-			"%x %u/%zu %u/%u cnt=%u %u/%zu %u/%u cnt=%u %u\n",
-			mode,
-			oi, mi.length, ileft, areq->cryptlen, rx_cnt,
-			oo, mo.length, oleft, areq->cryptlen, tx_cnt, ob);
 
 		if (!tx_cnt)
 			continue;
+		sg_miter_start(&mo, areq->dst, sg_nents(areq->dst),
+			       SG_MITER_TO_SG | SG_MITER_ATOMIC);
+		if (po)
+			sg_miter_skip(&mo, po);
+		miter_err = sg_miter_next(&mo);
+		if (!miter_err || !mo.addr) {
+			dev_err_ratelimited(ss->dev, "ERROR: sg_miter return null\n");
+			err = -EINVAL;
+			goto release_ss;
+		}
 		/* todo in 4bytes word */
 		todo = min(tx_cnt, oleft / 4);
 		todo = min_t(size_t, todo, (mo.length - oo) / 4);
+
 		if (todo) {
 			readsl(ss->base + SS_TXFIFO, mo.addr + oo, todo);
 			oleft -= todo * 4;
 			oo += todo * 4;
 			if (oo == mo.length) {
-				sg_miter_next(&mo);
+				po += mo.length;
 				oo = 0;
 			}
 		} else {
@@ -333,12 +354,14 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				obo += todo;
 				oo += todo;
 				if (oo == mo.length) {
+					po += mo.length;
 					sg_miter_next(&mo);
 					oo = 0;
 				}
 			} while (obo < obl);
 			/* bufo must be fully used here */
 		}
+		sg_miter_stop(&mo);
 	}
 	if (areq->iv) {
 		if (mode & SS_DECRYPTION) {
@@ -351,8 +374,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	}
 
 release_ss:
-	sg_miter_stop(&mi);
-	sg_miter_stop(&mo);
 	writel(0, ss->base + SS_CTL);
 	spin_unlock_irqrestore(&ss->slock, flags);
 
-- 
2.26.2

