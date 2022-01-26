Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F88FC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 21:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbiAZVFD (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 16:05:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231814AbiAZVFC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 16:05:02 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1444CC06173B
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 13:04:59 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id i187-20020a1c3bc4000000b0034d2ed1be2aso4581406wma.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jan 2022 13:04:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7wnW9cjljKpRIDwPHBIabEh75SAX6Ok5P1VkPlwmXoE=;
        b=TNqd45zsvDFw4xElwZBPy2f9it1IFu9BRfjwTsvfLFoaZXD9u+yRtoMV2UkKGWOoOv
         E1Qny8J9CRjBw6Cr7IKPVs+8bKGAoARjBUGPBLrO4I8/NWz/9Vwcrp+g31DN7ivXkhX3
         VmFE5VWzJJoWG/PzasdyB8JX5ivSIxzvHPBmrUKrFWPOAQ1e6FJWVK+RC2La47vVgfQo
         F81ZQY6vO2sYi5XtdF/yttCK1TlEVY1R0qblahqZ+rBobIA8dW8bV1NwDgDv1BOFqbah
         /NPcNpNeGS3DiPJCOBK9e1HTOPpKu3rCE5Nqam3arJuVSRp3rZk9qa0JV4veDLoWcdEu
         wTaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7wnW9cjljKpRIDwPHBIabEh75SAX6Ok5P1VkPlwmXoE=;
        b=JHIVADQR1oivY2LegO7FnsunHoWK04dOnAzn3qw8xt5kGPcUzb50yCBn3+y5gJLt9Y
         ekJajN3GfpbI72WIghIWutCYbnYBV8/y6OAo05zmfX5xkDxEIs0FYuac83KVOlDXin0Y
         GBsr0BUXI1Z29fMMAFdvKUYeK9tuXAXewhDxi3T8SWt3MxG4czOx43VdCbgDf7Y5l2Iz
         9PLvpJOz6ex7uJ/4MYBT72edJxkhDyTI78dV/hmNiBHteRJZaQ4pJyKN4dITFaQLCzzE
         WDHWg7bnADTRgbUSetL7zzPqoQSrhx4jQwXy0VtbZOvH+Q2sIJxGCpRRZeNsneRRXSN9
         QcQg==
X-Gm-Message-State: AOAM533TO7FPtJhfVrWMm/7NfXjsDg7kkpk5VkWvF80P+tr5ffUTCDxU
        ibDpeqnn1uPmSslS2sDn07slzIh6aGd8nQ==
X-Google-Smtp-Source: ABdhPJwBVnGfoDjyVtqqAIN/rwr6e1id+stGs09Zp6t39Zlb9GsJfHIPx9+9GrF60q+ST5Edgezktg==
X-Received: by 2002:a7b:c4c5:: with SMTP id g5mr428047wmk.139.1643231097636;
        Wed, 26 Jan 2022 13:04:57 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j19sm4948611wmq.17.2022.01.26.13.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 13:04:57 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        jernej.skrabec@gmail.com, mripard@kernel.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        linux-sunxi@googlegroups.com, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 8/8] crypto: sun8i-ss: handle requests if last block is not modulo 64
Date:   Wed, 26 Jan 2022 21:04:41 +0000
Message-Id: <20220126210441.3661782-9-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220126210441.3661782-1-clabbe@baylibre.com>
References: <20220126210441.3661782-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The current sun8i-ss handle only requests with all SG length being
modulo 64.
But the last SG could be always handled by copying it on the pad buffer.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../crypto/allwinner/sun8i-ss/sun8i-ss-core.c |  2 +-
 .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 35 ++++++++++++++-----
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h  |  2 ++
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
index 084261d7899c..c8c079f3b466 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-core.c
@@ -475,7 +475,7 @@ static int allocate_flows(struct sun8i_ss_dev *ss)
 		init_completion(&ss->flows[i].complete);
 
 		/* the padding could be up to two block. */
-		ss->flows[i].pad = devm_kmalloc(ss->dev, SHA256_BLOCK_SIZE * 2,
+		ss->flows[i].pad = devm_kmalloc(ss->dev, MAX_PAD_SIZE,
 						GFP_KERNEL | GFP_DMA);
 		if (!ss->flows[i].pad)
 			goto error_engine;
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 1aae36d541d8..dd5e4f0fd5ab 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -13,6 +13,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/scatterlist.h>
 #include <crypto/internal/hash.h>
+#include <crypto/scatterwalk.h>
 #include <crypto/sha1.h>
 #include <crypto/sha2.h>
 #include <crypto/md5.h>
@@ -261,6 +262,9 @@ static bool sun8i_ss_hash_need_fallback(struct ahash_request *areq)
 
 	if (areq->nbytes == 0)
 		return true;
+	if (areq->nbytes >= MAX_PAD_SIZE - 64)
+		return true;
+
 	/* we need to reserve one SG for the padding one */
 	if (sg_nents(areq->src) > MAX_SG - 1)
 		return true;
@@ -269,10 +273,13 @@ static bool sun8i_ss_hash_need_fallback(struct ahash_request *areq)
 		/* SS can operate hash only on full block size
 		 * since SS support only MD5,sha1,sha224 and sha256, blocksize
 		 * is always 64
-		 * TODO: handle request if last SG is not len%64
-		 * but this will need to copy data on a new SG of size=64
 		 */
-		if (sg->length % 64 || !IS_ALIGNED(sg->offset, sizeof(u32)))
+		/* Only the last block could be bounced to the pad buffer */
+		if (sg->length % 64 && sg_next(sg))
+			return true;
+		if (!IS_ALIGNED(sg->offset, sizeof(u32)))
+			return true;
+		if (sg->length % 4)
 			return true;
 		sg = sg_next(sg);
 	}
@@ -360,6 +367,7 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 		goto theend;
 	}
 
+	j = 0;
 	len = areq->nbytes;
 	sg = areq->src;
 	i = 0;
@@ -368,12 +376,19 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 			sg = sg_next(sg);
 			continue;
 		}
-		rctx->t_src[i].addr = sg_dma_address(sg);
 		todo = min(len, sg_dma_len(sg));
-		rctx->t_src[i].len = todo / 4;
-		len -= todo;
-		rctx->t_dst[i].addr = addr_res;
-		rctx->t_dst[i].len = digestsize / 4;
+		/* only the last SG could be with a size not modulo64 */
+		if (todo % 64 == 0) {
+			rctx->t_src[i].addr = sg_dma_address(sg);
+			rctx->t_src[i].len = todo / 4;
+			rctx->t_dst[i].addr = addr_res;
+			rctx->t_dst[i].len = digestsize / 4;
+			len -= todo;
+		} else {
+			scatterwalk_map_and_copy(bf, sg, 0, todo, 0);
+			j += todo / 4;
+			len -= todo;
+		}
 		sg = sg_next(sg);
 		i++;
 	}
@@ -383,8 +398,10 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 		goto theend;
 	}
 
+	if (j > 0)
+		i--;
+
 	byte_count = areq->nbytes;
-	j = 0;
 	bf[j++] = cpu_to_le32(0x80);
 
 	fill = 64 - (byte_count % 64);
diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
index f9f089ede934..8c9649bab88c 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss.h
@@ -82,6 +82,8 @@
 #define PRNG_DATA_SIZE (160 / 8)
 #define PRNG_SEED_SIZE DIV_ROUND_UP(175, 8)
 
+#define MAX_PAD_SIZE 4096
+
 /*
  * struct ss_clock - Describe clocks used by sun8i-ss
  * @name:       Name of clock needed by this variant
-- 
2.34.1

