Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 663B8C4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 20:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbiCQU6K (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiCQU5m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 16:57:42 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C1A170DAE
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:19 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 7-20020a05600c228700b00385fd860f49so3843438wmf.0
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XtchaM94YM1VegqN4dLecw9vdPFGdK2+AK0IlUyWGNM=;
        b=JN6BCT/TB8P/cEYVkNRv0NhaugkXmtIe5kGi2WExIn1h+G6U+AJ32Ez9/RCgHRmLDp
         M5MJzJF1yDdVggt8Rtc2aZMhnJUNBTAVxK4oxU/7RmJz05sp3tZvnC1turEOgiQND5/r
         raLEo3avhyafqd38eMMEchgMaR5rAMvHjDgxtVR6VFtwQHDimutOS19Uba4PF+fHs43L
         jke6YmhRH3t6gRfVks5PXcu1eJmUkHdowWOlxMBo3s9PAdjmfml0r+vjGhQUyvfU+dK7
         O+weVl89dQCQjMjLevV2YMXaK5qeEzZAtx99qziy3hEKAtduHcHlsqp7NU2fFW/IAqXN
         8oNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XtchaM94YM1VegqN4dLecw9vdPFGdK2+AK0IlUyWGNM=;
        b=gSyfdfkDNneB4QObUVr06KlMJpS493gGkkphJVNokeHzGqQjyIiReZMPBX/V+MEfve
         vKhCClKUDp3uiDc+l9eAGIDZ77tMl+2jGqdiQm7JD6fqX28Bh8c0KMQjRK0KcDvDj0lQ
         2kC8Bbe26wd19BIdWarVi54vRbk4TaKv6xyTMfvOra/KQIGCOCWRTJdFsNOl/H2CHREu
         IY1HlLnhNHqj9RFtjN4tzhTBWjsu+XQDXWggunDtGd8ZX2cnb4/Zj3friOg1k8mJti49
         XFPHyoURL9rPH4shXP7ctimGeqMzvLqpejwGytYtzdqyIDztdWSBCBP+drquodgt6wMp
         FuRA==
X-Gm-Message-State: AOAM533btvlg54mPkkgyjZuYHtFddMnfygYO5TRtrl6cQfojEnn3C66+
        MHrzE8jDdkPGfXF8t4jKjB40EQ==
X-Google-Smtp-Source: ABdhPJzf9ed7YPOo1pNtfYfn4ilwHvwd9wFs/snO9PWNIXdQ873daopcr6dF4eMoUCC6IGWn/3++cw==
X-Received: by 2002:a1c:f719:0:b0:381:ba:5247 with SMTP id v25-20020a1cf719000000b0038100ba5247mr5731291wmh.183.1647550578428;
        Thu, 17 Mar 2022 13:56:18 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id r4-20020a05600c35c400b00389f368cf1esm3695424wmq.40.2022.03.17.13.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 13:56:18 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 10/19] crypto: sun8i-ss: do not zeroize all pad
Date:   Thu, 17 Mar 2022 20:55:56 +0000
Message-Id: <20220317205605.3924836-11-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317205605.3924836-1-clabbe@baylibre.com>
References: <20220317205605.3924836-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Instead of memset all pad buffer, it is faster to only put 0 where
needed.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 9582ac450d08..53e5bfb99c93 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -319,7 +319,7 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	unsigned int len;
 	u64 fill, min_fill, byte_count;
 	void *pad, *result;
-	int j, i, todo;
+	int j, i, k, todo;
 	__be64 *bebits;
 	__le64 *lebits;
 	dma_addr_t addr_res, addr_pad;
@@ -334,7 +334,6 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 
 	result = ss->flows[rctx->flow].result;
 	pad = ss->flows[rctx->flow].pad;
-	memset(pad, 0, algt->alg.hash.halg.base.cra_blocksize * 2);
 	bf = (__le32 *)pad;
 
 	for (i = 0; i < MAX_SG; i++) {
@@ -395,7 +394,10 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	if (fill < min_fill)
 		fill += 64;
 
+	k = j;
 	j += (fill - min_fill) / sizeof(u32);
+	for (; k < j; k++)
+		bf[k] = 0;
 
 	switch (algt->ss_algo_id) {
 	case SS_ID_HASH_MD5:
-- 
2.34.1

