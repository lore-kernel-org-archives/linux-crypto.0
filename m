Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6B0C433FE
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 20:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbiCQU6H (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbiCQU5m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 16:57:42 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F155187B9D
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:22 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id x15so8988858wru.13
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VPG5xdEe7CwrsSmHCV/4usRyLbFbgTbMpwY3twMAA2c=;
        b=YoZ5/aT2zO6zC4OhNOsVH9dqiz98KfdADE+JUelGribOhOMJN6b9ZnmRTC9PERTvse
         LfaI32yvJxMGJoFUymSyQmkrs7fWNqGHayYWSMFlFENjGhgRSLCVCEHDx/n0c43qbAyQ
         fkWA67FW/tL8EOz5YtoMUqiUnquIS6aJdZu+xHJfoiLk4A7UHXQpYhOorYHpoIt7lv4G
         IEDIoP34BLGcv4aQZ40Q3+ZBXPMuvO/9S37RQkQt3zm7KzJZqxG5ittaDzBLEJDQCRaC
         vBvwgckYJOmwTYER7SoDrdc4PY0haLWK7KOaZR7XV/pnW3KCqgDH8tzbYF2F6VtFLYyj
         ZlXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VPG5xdEe7CwrsSmHCV/4usRyLbFbgTbMpwY3twMAA2c=;
        b=fJKA9m1s41d9yvE1BPqI/lJwc2lZS2LihraxeNR30bmCSsDS7EbmJhqcJL8y49/ZCF
         pOf81AGBRayIsvlJR0Hb3N8RMargbymjvw7wgSysPVpc6NQ+bK74aZ/T05GquoNLnZPg
         IxMDmGOO7Uw7dnUkHBfDDfNrK/XTQ5uOJ6qVZO8q3lCTcgyqamdj4Gvf3t5jaegraBFx
         +VeeycLvPUaiWRWX6yY94EX1ko/Ia5MY/8JAom3OJm4SCDxANwSOucKmcDek2ynxs2tg
         aejOhXfdzWl8Bkeu3FyJ3ODZcA0IDobfbdhRqUSAzrYJEzapH0r09aLekzL3BhIiWjcY
         SFhQ==
X-Gm-Message-State: AOAM5307uFvFc9vUSZZJCGkUXngBKcO25w5OWGEdbFn/NApAwZNQynKu
        7wKyym18hbhUNgV8YE4aLypAK6I4UQBenw==
X-Google-Smtp-Source: ABdhPJxfg+Ya5WTbS08Kg64X3jLz38a3MEx09xKt5tFJFO95djJRsRFQg2KJ0+opA5SEpZjf+jS25w==
X-Received: by 2002:a5d:47c8:0:b0:1ef:8e97:2b8c with SMTP id o8-20020a5d47c8000000b001ef8e972b8cmr5733811wrc.545.1647550580732;
        Thu, 17 Mar 2022 13:56:20 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id r4-20020a05600c35c400b00389f368cf1esm3695424wmq.40.2022.03.17.13.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 13:56:20 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 13/19] crypto: sun8i-ss: Add function for handling hash padding
Date:   Thu, 17 Mar 2022 20:55:59 +0000
Message-Id: <20220317205605.3924836-14-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220317205605.3924836-1-clabbe@baylibre.com>
References: <20220317205605.3924836-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Move all padding work to a dedicated function.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 87 ++++++++++++++-----
 1 file changed, 65 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index cb510ec21ec4..6adb6a0428b7 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -328,6 +328,64 @@ int sun8i_ss_hash_digest(struct ahash_request *areq)
 	return crypto_transfer_hash_request_to_engine(engine, areq);
 }
 
+static u64 hash_pad(u32 *buf, unsigned int bufsize, u64 padi, u64 byte_count, bool le, int bs)
+{
+	u64 fill, min_fill, j, k;
+	__be64 *bebits;
+	__le64 *lebits;
+
+	j = padi;
+	buf[j++] = cpu_to_le32(0x80);
+
+	if (bs == 64) {
+		fill = 64 - (byte_count % 64);
+		min_fill = 2 * sizeof(u32) + sizeof(u32);
+	} else {
+		fill = 128 - (byte_count % 128);
+		min_fill = 4 * sizeof(u32) + sizeof(u32);
+	}
+
+	if (fill < min_fill)
+		fill += bs;
+
+	k = j;
+	j += (fill - min_fill) / sizeof(u32);
+	if (j * 4 > bufsize) {
+		pr_err("%s OVERFLOW %llu\n", __func__, j);
+		return 0;
+	}
+	for (; k < j; k++)
+		buf[k] = 0;
+
+	if (le) {
+		/* MD5 */
+		lebits = (__le64 *)&buf[j];
+		*lebits = cpu_to_le64(byte_count << 3);
+		j += 2;
+	} else {
+		if (bs == 64) {
+			/* sha1 sha224 sha256 */
+			bebits = (__be64 *)&buf[j];
+			*bebits = cpu_to_be64(byte_count << 3);
+			j += 2;
+		} else {
+			/* sha384 sha512*/
+			bebits = (__be64 *)&buf[j];
+			*bebits = cpu_to_be64(byte_count >> 61);
+			j += 2;
+			bebits = (__be64 *)&buf[j];
+			*bebits = cpu_to_be64(byte_count << 3);
+			j += 2;
+		}
+	}
+	if (j * 4 > bufsize) {
+		pr_err("%s OVERFLOW %llu\n", __func__, j);
+		return 0;
+	}
+
+	return j;
+}
+
 /* sun8i_ss_hash_run - run an ahash request
  * Send the data of the request to the SS along with an extra SG with padding
  */
@@ -342,11 +400,9 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 	struct scatterlist *sg;
 	int nr_sgs, err, digestsize;
 	unsigned int len;
-	u64 fill, min_fill, byte_count;
+	u64 byte_count;
 	void *pad, *result;
 	int j, i, k, todo;
-	__be64 *bebits;
-	__le64 *lebits;
 	dma_addr_t addr_res, addr_pad;
 	__le32 *bf;
 
@@ -421,33 +477,20 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
 		i--;
 
 	byte_count = areq->nbytes;
-	bf[j++] = cpu_to_le32(0x80);
-
-	fill = 64 - (byte_count % 64);
-	min_fill = 3 * sizeof(u32);
-
-	if (fill < min_fill)
-		fill += 64;
-
-	k = j;
-	j += (fill - min_fill) / sizeof(u32);
-	for (; k < j; k++)
-		bf[k] = 0;
-
 	switch (algt->ss_algo_id) {
 	case SS_ID_HASH_MD5:
-		lebits = (__le64 *)&bf[j];
-		*lebits = cpu_to_le64(byte_count << 3);
-		j += 2;
+		j = hash_pad(bf, 4096, j, byte_count, true, bs);
 		break;
 	case SS_ID_HASH_SHA1:
 	case SS_ID_HASH_SHA224:
 	case SS_ID_HASH_SHA256:
-		bebits = (__be64 *)&bf[j];
-		*bebits = cpu_to_be64(byte_count << 3);
-		j += 2;
+		j = hash_pad(bf, 4096, j, byte_count, false, bs);
 		break;
 	}
+	if (!j) {
+		err = -EINVAL;
+		goto theend;
+	}
 
 	addr_pad = dma_map_single(ss->dev, pad, j * 4, DMA_TO_DEVICE);
 	if (dma_mapping_error(ss->dev, addr_pad)) {
-- 
2.34.1

