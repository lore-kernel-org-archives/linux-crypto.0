Return-Path: <SRS0=6s16=C5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C071DC43463
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 18:37:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AEBA20897
	for <linux-crypto@archiver.kernel.org>; Sun, 20 Sep 2020 18:37:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="pT0FFND6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgITShc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 20 Sep 2020 14:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgITSh1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 20 Sep 2020 14:37:27 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86704C061755
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2020 11:37:26 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id d4so10005461wmd.5
        for <linux-crypto@vger.kernel.org>; Sun, 20 Sep 2020 11:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jTdlzUzyc1hcRCjE509a2kDcbNHBKMDXHMkrLBJjCcg=;
        b=pT0FFND6nkoHYyotdgwU1JAtZKe+QpWMkWB0/vahBAzG/8Ld4jH7LOF+KhWyjcj83t
         5Sx1nwXbpU0PNjl2Y003G0PYjPMwRiIqD5CYsm3Z0nBKnZ52AW5B3f5Hhj8p7itelMfp
         fvBatPUhYCOePXCZd1QIH91PiEHEvt+VDnDRsjG3ZauxunjMmzsJ+bmE99QNcPDxN6rS
         mKT67ZLBJo3J9fkL813BBeFdlQUanY2I2v07DKoQLz8k78j1GXzlghb79gZU2bah7KKg
         4p4K2uuaQccbL2gIHbH3zwiC8/XjHX0tiV71d3nbLb9AJadcKfPh7hAuDZKn0Mj0E89F
         Hdqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jTdlzUzyc1hcRCjE509a2kDcbNHBKMDXHMkrLBJjCcg=;
        b=hO0nNSa2qNfRo8tfes7hPS5+BB0TdGysA09xMc3TIZeB5OlAElf2qgjQOkDGqYRQU8
         MsayZ7pEx4BcgX0/eTAkHA7vb1b5gqrlknBm16EWut3mCDg4tnrGvckP6Ai6HtSYIuNm
         dEnvSTyyfq858IALgtagmgj6tQDoZdX+2OhF6mSHt/bKwycTVXG0rlCTICQvFmwlLW/U
         hnI0J+zB7kl1O4EjJQCniqfJfaVDq/QRrTi0o+yqRSlKKJXZVWA3I0tEvNxBO8qtZmC2
         LXxmlPtzc8zhqz3td76tT2wvGv7CdQS1c1yRXGWgiVqA37CXvakn4IiV0/YPFhbHICb2
         6kMw==
X-Gm-Message-State: AOAM531Bd4+e4C+MIuC0uIsGrAc9Ec5DSgKnTOWFAicoBXzJe4NnZK5a
        cXutKAUSNubTt/AlbxLQmNQJ5Q==
X-Google-Smtp-Source: ABdhPJznL0wnKPFRx+ll8rXF6fFCp51XOjtzRgf3arfEI4ScF5bVizdGKfVQJuxQR3n2Q1QXlekbrg==
X-Received: by 2002:a05:600c:414b:: with SMTP id h11mr26441143wmm.20.1600627045206;
        Sun, 20 Sep 2020 11:37:25 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id e18sm16419841wrx.50.2020.09.20.11.37.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 20 Sep 2020 11:37:24 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 1/7] crypto: sun4i-ss: linearize buffers content must be kept
Date:   Sun, 20 Sep 2020 18:37:12 +0000
Message-Id: <1600627038-40000-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
References: <1600627038-40000-1-git-send-email-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When running the non-optimized cipher function, SS produce partial random
output.
This is due to linearize buffers being reseted after each loop.

Fixes: 8d3bcb9900ca ("crypto: sun4i-ss - reduce stack usage")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
index b72de8939497..b92d175b5d2a 100644
--- a/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun4i-ss/sun4i-ss-cipher.c
@@ -163,6 +163,8 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 	unsigned int todo;
 	struct sg_mapping_iter mi, mo;
 	unsigned int oi, oo;	/* offset for in and out */
+	char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
+	char bufo[4 * SS_TX_MAX]; /* buffer for linearize SG dst */
 	unsigned int ob = 0;	/* offset in buf */
 	unsigned int obo = 0;	/* offset in bufo*/
 	unsigned int obl = 0;	/* length of data in bufo */
@@ -233,8 +235,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 
 	while (oleft) {
 		if (ileft) {
-			char buf[4 * SS_RX_MAX];/* buffer for linearize SG src */
-
 			/*
 			 * todo is the number of consecutive 4byte word that we
 			 * can read from current SG
@@ -295,8 +295,6 @@ static int sun4i_ss_cipher_poll(struct skcipher_request *areq)
 				oo = 0;
 			}
 		} else {
-			char bufo[4 * SS_TX_MAX]; /* buffer for linearize SG dst */
-
 			/*
 			 * read obl bytes in bufo, we read at maximum for
 			 * emptying the device
-- 
2.26.2

