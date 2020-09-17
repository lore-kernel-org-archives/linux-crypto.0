Return-Path: <SRS0=yTfj=C2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E86DDC43461
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 18:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EC20221E3
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Sep 2020 18:36:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="Iu747+4n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726654AbgIQSgP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Sep 2020 14:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbgIQSgL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Sep 2020 14:36:11 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05D5C061788
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 11:36:09 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id e16so3134212wrm.2
        for <linux-crypto@vger.kernel.org>; Thu, 17 Sep 2020 11:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jTdlzUzyc1hcRCjE509a2kDcbNHBKMDXHMkrLBJjCcg=;
        b=Iu747+4nadzvDfyHCyTyuRJhiIU4JEOTx7wcl9fRZmk4C2hj26XLP/pLYoNWCXkNoa
         jOG8/8qUQh9csSVrxPpXSLZB7w7m2/mkvWFMko8b/zg/Z7ttLd1ZC+hExrJdPx60e0PY
         DGPFCHfb55pFL94T4GzExTONjciAmVl0VIYj29tldHOgshEBgmTCekX5f9FxIO8xVy93
         TQrf1HjVu9cDXHHOMehhlpk8KxDRSZt7TDhRQoq66hjhfqUUWsDJC5vKyCqpCfaCHW+3
         JhvQWkL851NyQoea13o8i1gW2piPvOrQirFTd+7HYoZIDSFRTpLgyuneoMGuurVSFMNa
         nHTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jTdlzUzyc1hcRCjE509a2kDcbNHBKMDXHMkrLBJjCcg=;
        b=pquNq67TQUqhW7ZppPJURFoil5/ofecYnElK3Ti/WoHfIVZWAZDVd+X1zKgNgowwmp
         VKA9ngpIgfE4GoF1oTn2uZj7iqW40NQs7AiJ909HENYZFs7KXFbiYxfFln/dnU27uvQI
         olM09XfU4cqhn2as6mcu621VNaWUhVbvF70Ojez4yHpEjc5MI1UplgzBgpNaPfZmXITJ
         N+piHG3c3ReEkuiAnoaf6AavEmM2L21AXYdn2RuoiKQbsdJDe3vdV1l0IuTNHye8B9hl
         8d9pMA1Hxi/e28Az45f4OpZBnLvu+aFzJVztAdbzA115FaGMBbpdFAnOE5cSOHSzBCAd
         eMLw==
X-Gm-Message-State: AOAM530Xd5zJiEmf+AYlkcoEPtNWGFs2c9vdn/MfiNxFD6fHhO2puq8i
        tnBno0h9CZ+rdWhzZiCL8ea6iQ==
X-Google-Smtp-Source: ABdhPJwPR3kJwirxBvcg7+EKXYc7it131pIcBWGKU+Rwhgt8ETaSOml+RRDdd+wopE0SsNNZADqqUg==
X-Received: by 2002:adf:cd0e:: with SMTP id w14mr36379858wrm.0.1600367768639;
        Thu, 17 Sep 2020 11:36:08 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id x16sm571901wrq.62.2020.09.17.11.36.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Sep 2020 11:36:07 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     arnd@arndb.de, davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 1/7] crypto: sun4i-ss: linearize buffers content must be kept
Date:   Thu, 17 Sep 2020 18:35:52 +0000
Message-Id: <1600367758-28589-2-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
References: <1600367758-28589-1-git-send-email-clabbe@baylibre.com>
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

