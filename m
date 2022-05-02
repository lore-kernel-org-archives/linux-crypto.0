Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C87BC433EF
	for <linux-crypto@archiver.kernel.org>; Mon,  2 May 2022 20:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387342AbiEBUXX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 May 2022 16:23:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387278AbiEBUXV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 May 2022 16:23:21 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B71DF32
        for <linux-crypto@vger.kernel.org>; Mon,  2 May 2022 13:19:46 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i5so20856011wrc.13
        for <linux-crypto@vger.kernel.org>; Mon, 02 May 2022 13:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bhu4eLQiIRL8RKU2XjxwIhN+TQjOmHOSbzeiE02npHs=;
        b=6mXw8hwrlWl+Lkou1IHnPcR77Qj8SjR1rk5xX35wNVTGHj6WtCPHn99tOmMe+TGTN1
         4VgSQgDOlo5/JSZMWl3vs9FdGpgMGgmtkJ9bJahqqI5vps2zSM0H5oVgz/wpO566AzdU
         eprVi0pxD24DKfdZG860cuQbtiA+xHxIaVkbs8ZhFhUoGDl6xOf23Zrri7VG6K10+KPb
         j4TcN8DKkI6RbHnyVc3PD5aHXBx0F+Nm+xJ03cm8+6aLcduNrCeoejmoLfpu92wZ+wdU
         m6rr+1WrTrsF+sE2tq88t9RK7t09r207MGczHOurB27e99Ru0DFBDOjKEbdda7IdROwV
         zofw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bhu4eLQiIRL8RKU2XjxwIhN+TQjOmHOSbzeiE02npHs=;
        b=jrzhI7z68lCq1D6bRpwY20ZRUaesWV+aZQ8uw7R39gRdmBAE8/frvsryaAK6w8oK5p
         L84ju4RP5IWZ83qCbVcX52wgEdgcqjc9JttQthqx11xtRmPx0gaCIIyc2Z8/MFXem91r
         AY9uIXuXmuN3SFgmswht48ikUcDWNrnzyEDR8sb8Y8Bp8DcwbYL0/zwOrWMChh8PnJ4B
         bMnRyPi1sOJ23OTF8wHUbFMSmVBsu410mcFgK2Pj/wjJeKaz74PPzVh8SDANMbraKL8p
         57EXmRskmVXxkyV12YFmFUHRPpeQ+ug6Ti2QtNCbVGdoTLmhDpJ1q6I3hqXFGvtr5AUp
         xhxg==
X-Gm-Message-State: AOAM531TH0imjcUOd2Xfjg/mj/hXLTxxc//YdrfxaAG1GQ8aDvW+Lxki
        slIanTNwsNOeeO1GSCAOZ6VQrw==
X-Google-Smtp-Source: ABdhPJwjus7/meUmZC5qIxb4pLGm0uyVjK5FJyqHsJSI5/SMEAf5aF9tfKyoJD0JHpFnkshjg7ehxg==
X-Received: by 2002:a05:6000:1d83:b0:203:ed96:fa4c with SMTP id bk3-20020a0560001d8300b00203ed96fa4cmr10487646wrb.400.1651522785102;
        Mon, 02 May 2022 13:19:45 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id l2-20020adfb102000000b0020c547f75easm7238183wra.101.2022.05.02.13.19.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 13:19:44 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 05/19] crypto: sun8i-ss: handle zero sized sg
Date:   Mon,  2 May 2022 20:19:15 +0000
Message-Id: <20220502201929.843194-6-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220502201929.843194-1-clabbe@baylibre.com>
References: <20220502201929.843194-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

sun8i-ss does not handle well the possible zero sized sg.

Fixes: d9b45418a917 ("crypto: sun8i-ss - support hash algorithms")
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 1a71ed49d233..ca4f280af35d 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -380,13 +380,21 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	}
 
 	len = areq->nbytes;
-	for_each_sg(areq->src, sg, nr_sgs, i) {
+	sg = areq->src;
+	i = 0;
+	while (len > 0 && sg) {
+		if (sg_dma_len(sg) == 0) {
+			sg = sg_next(sg);
+			continue;
+		}
 		rctx->t_src[i].addr = sg_dma_address(sg);
 		todo = min(len, sg_dma_len(sg));
 		rctx->t_src[i].len = todo / 4;
 		len -= todo;
 		rctx->t_dst[i].addr = addr_res;
 		rctx->t_dst[i].len = digestsize / 4;
+		sg = sg_next(sg);
+		i++;
 	}
 	if (len > 0) {
 		dev_err(ss->dev, "remaining len %d\n", len);
-- 
2.35.1

