Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D59BBC4332F
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Mar 2022 20:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbiCQU6C (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Mar 2022 16:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbiCQU5u (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Mar 2022 16:57:50 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBFE1B756B
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:24 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id p184-20020a1c29c1000000b0037f76d8b484so3795032wmp.5
        for <linux-crypto@vger.kernel.org>; Thu, 17 Mar 2022 13:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mh4jiSkDLwsXXr3eCwHVBQsjqiQzNM7iBR5uhA4LEdU=;
        b=RyxOa44Cou11d6dAd7IrT8ym2ReKWPZNo6u1lUp6B2x0DpQ+KyQKAy00ug4t+FTHcw
         HDuSg2+o+nlr1siY+vAl0J5TKQyEZOOZSL3NXEU55Q8WhwYe8Q1Qvbty7sd8Pn8rv0jP
         oJHND4hRhiqmqq3V/JHrL/28TNGuOatmW0GeSbJlL2Djq/rywmr8ZmxhlF72Tje2VOxG
         WsTqIfkCPnTDAQoPcLsmmBzMyxFZ2b5zuG5BTwALWFpfa0duWD4r/Crq9sVDJHZkETU4
         2RuBNUeGVcqnKx3QU9rBNiNLwpFqY4G6p8P5VCl+LfUwd4JflSN7Hn5LNp5XVuW7JpB8
         xFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mh4jiSkDLwsXXr3eCwHVBQsjqiQzNM7iBR5uhA4LEdU=;
        b=HqgdCF4i01JCWTL9PxdYlfbsuvMw7XYaNYtEWMi3cNYb/omv7/EbSC+SYgE3W3k0sQ
         k+wUmya5Xbr/4yThamAmnhgXmlWwLBvFm6056fjAfFB8oSU9550tzkYBs/PbiDFSQNue
         l+1yuQ1dYPo/ufy8WUMN830q5rdxYbPRbYF+Brue3l7oT0c6xMYdYM8qmXPTOSynudJJ
         ArXdtsuTguvTwSF7QDq9L3SQ3Ty6/PyIj0JHAikCer6LcIyrhnbtZNNV783vqEYkxcDH
         e5KZWRh5pJ4Q82YiJOWTIEB9G/8CfGGBzkoDw7lUXCfA+AD2+ZW/2S/bkuYil3OwU5rB
         jzIw==
X-Gm-Message-State: AOAM533AtYmTOTWJTmxqIv6xI4Nv+YLwMx4fRoRSXQmWmPAS6nOwW9KQ
        wgVdp5XXTwAhnwZMvm8N8TnVGw==
X-Google-Smtp-Source: ABdhPJw5dlriYcc9uqGoP84adGYCZXOx9OG+Nxl7pjmm3Tmgd0DJ60WWmg/crDMndcSeFXcIAa1YkQ==
X-Received: by 2002:a05:600c:1990:b0:389:d72d:ca77 with SMTP id t16-20020a05600c199000b00389d72dca77mr5605859wmq.1.1647550582838;
        Thu, 17 Mar 2022 13:56:22 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id r4-20020a05600c35c400b00389f368cf1esm3695424wmq.40.2022.03.17.13.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 13:56:22 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 16/19] crypto: sun8i-ce: Add function for handling hash padding
Date:   Thu, 17 Mar 2022 20:56:02 +0000
Message-Id: <20220317205605.3924836-17-clabbe@baylibre.com>
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
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 95 +++++++++++++------
 1 file changed, 65 insertions(+), 30 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 859b7522faaa..820651f0387f 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -248,6 +248,64 @@ int sun8i_ce_hash_digest(struct ahash_request *areq)
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
 int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 {
 	struct ahash_request *areq = container_of(breq, struct ahash_request, base);
@@ -266,10 +324,6 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	__le32 *bf;
 	void *buf = NULL;
 	int j, i, todo;
-	int nbw = 0;
-	u64 fill, min_fill;
-	__be64 *bebits;
-	__le64 *lebits;
 	void *result = NULL;
 	u64 bs;
 	int digestsize;
@@ -348,44 +402,25 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 
 	byte_count = areq->nbytes;
 	j = 0;
-	bf[j++] = cpu_to_le32(0x80);
-
-	if (bs == 64) {
-		fill = 64 - (byte_count % 64);
-		min_fill = 2 * sizeof(u32) + (nbw ? 0 : sizeof(u32));
-	} else {
-		fill = 128 - (byte_count % 128);
-		min_fill = 4 * sizeof(u32) + (nbw ? 0 : sizeof(u32));
-	}
-
-	if (fill < min_fill)
-		fill += bs;
-
-	j += (fill - min_fill) / sizeof(u32);
 
 	switch (algt->ce_algo_id) {
 	case CE_ID_HASH_MD5:
-		lebits = (__le64 *)&bf[j];
-		*lebits = cpu_to_le64(byte_count << 3);
-		j += 2;
+		j = hash_pad(bf, 2 * bs, j, byte_count, true, bs);
 		break;
 	case CE_ID_HASH_SHA1:
 	case CE_ID_HASH_SHA224:
 	case CE_ID_HASH_SHA256:
-		bebits = (__be64 *)&bf[j];
-		*bebits = cpu_to_be64(byte_count << 3);
-		j += 2;
+		j = hash_pad(bf, 2 * bs, j, byte_count, false, bs);
 		break;
 	case CE_ID_HASH_SHA384:
 	case CE_ID_HASH_SHA512:
-		bebits = (__be64 *)&bf[j];
-		*bebits = cpu_to_be64(byte_count >> 61);
-		j += 2;
-		bebits = (__be64 *)&bf[j];
-		*bebits = cpu_to_be64(byte_count << 3);
-		j += 2;
+		j = hash_pad(bf, 2 * bs, j, byte_count, false, bs);
 		break;
 	}
+	if (!j) {
+		err = -EINVAL;
+		goto theend;
+	}
 
 	addr_pad = dma_map_single(ce->dev, buf, j * 4, DMA_TO_DEVICE);
 	cet->t_src[i].addr = cpu_to_le32(addr_pad);
-- 
2.34.1

