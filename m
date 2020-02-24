Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7275C38BE2
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 20:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8942621744
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 20:26:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="Wv4HPspE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgBXU0L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Feb 2020 15:26:11 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:33835 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727242AbgBXU0K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Feb 2020 15:26:10 -0500
Received: by mail-wm1-f66.google.com with SMTP id s144so674321wme.1
        for <linux-crypto@vger.kernel.org>; Mon, 24 Feb 2020 12:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=F7a1q9zaXkmFSVJOCg0lehp0yKULwcs/09ZgYtgpjUU=;
        b=Wv4HPspEJkZrX2QzJQyje7IucGzsS7rUzgqxdGPdIZWOw1o+1CJE/ZaSrRAZVcUsgq
         u0j8BUdO73nFXL1/pYTcP03ju/oNFNmclaeoU4sE5jx59swnUqq8lX+q5zeRQOgpwNQY
         dFxFHil6Ke115v+VbH7j/GGwfwh02Vv2m9TeR8MErXOIQJClm7N9pouprrxsoSuxpdfh
         9n5nrirbEHkIHINMuriwUoxe7dcdO1DCgXZn1ETFNHbqUMoxNK/Nh8bQoYKFxhXU9UFn
         du5hl+eRew+oYMtTvMnfJ1Q6C+t/JSLZNFZfKD4Eoy8tklMrTY0Lif0/u89udl/fcTSl
         oA+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F7a1q9zaXkmFSVJOCg0lehp0yKULwcs/09ZgYtgpjUU=;
        b=TI9xp8iXbjWM0jHOdurLrVV9iIwhyLxhyN9XQWU8D9wrJhk2I9z24fIGnIjVgipSBp
         xfOJJEzOJMkZw/XqPcMyVy2h3nwuAVzryDYfJ3iPLwfUGgxxdff/UPd5kcd4bRGuV/kp
         mQOFFpm5rhchwyOTuGl0cE0hMw7rD4RlvDm7iwIu4BuNUMWefWe/+mVMZDIZnnq/polU
         XAc6hVMHWBOesCx2iOSgzRD3EohMpytcJzEKHUW86xp2erZw9CufO+6E59iCH9mGs6s2
         8NgYBmA5fUC6cmzi+CBPSDLCAAe/l+mwvR53HhqdONMOrpbO8Wdatl1EquPGZrCrjMZH
         NjOA==
X-Gm-Message-State: APjAAAVNbX7PHChBqEu3NPIYbMV3+jxPQhq8nXe/zcnex/wzyHY9ziVO
        Uvepr7F9Sqse5S4Za59G3dew0g==
X-Google-Smtp-Source: APXvYqzUO5DyKjGU4OIrt+jNB0R1fsRpxxtROEgWMHzOWaT3f8jOiJ25/0nAzMg/rQtuhxQqHJnnmA==
X-Received: by 2002:a1c:bdc5:: with SMTP id n188mr748049wmf.124.1582575968969;
        Mon, 24 Feb 2020 12:26:08 -0800 (PST)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id a7sm13356602wrm.29.2020.02.24.12.26.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 24 Feb 2020 12:26:08 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 1/2] crypto: sun8i-ss: fix description of stat_fb
Date:   Mon, 24 Feb 2020 20:26:02 +0000
Message-Id: <1582575963-27649-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The description of stat_fb was wrong, let's fix it.

Fixes: f08fcced6d00 ("crypto: allwinner - Add sun8i-ss cryptographic offloader")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index 5ca8da9311b8..66c78c03e376 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -205,7 +205,7 @@ struct sun8i_ss_rng_tfm_ctx {
  *			this template
  * @alg:		one of sub struct must be used
  * @stat_req:		number of request done on this template
- * @stat_fb:		total of all data len done on this template
+ * @stat_fb:		number of request which has fallbacked
  */
 struct sun8i_ss_alg_template {
 	u32 type;
-- 
2.24.1

