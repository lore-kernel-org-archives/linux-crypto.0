Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0D09C4321E
	for <linux-crypto@archiver.kernel.org>; Mon,  2 May 2022 20:22:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235745AbiEBUYm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 May 2022 16:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387406AbiEBUXp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 May 2022 16:23:45 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B596FDFC0
        for <linux-crypto@vger.kernel.org>; Mon,  2 May 2022 13:19:58 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id m2-20020a1ca302000000b003943bc63f98so197609wme.4
        for <linux-crypto@vger.kernel.org>; Mon, 02 May 2022 13:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=THm4In0PmhA5rhHf5Q0NS/J0EmQtdGVSharMkvmTBW0=;
        b=xskEsfiHASuyyqofp4j29niKlceKKoiyI4dacxua7VfCiY2Z6Y70rDAAPE5p45i8uH
         Q56JyfQFrHg7SuqDPAzcYlz6g5uQjyViUhZHGOmG/noWWa1M8N/TBfjiXmq8YZ1jJski
         0rykjq0mMF7Or1pyf+kfHkp3JiV+Y/LVWYzyeuOHqdlf3roYmzQtiU6fXLkR6CAmeDuk
         gXFjmfcXg04kqNmdX7KLFyEscMLxKkAcQRuGTpHMbThtCj0OXhoQqoao6QJkrQL4BUoa
         +0//i9cnWttrzUflWQoL8jJV0Tn9rWjv2tlTa5wOa7WG2BeYZjM/dnAXIBPAHz4kSZxg
         n+Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=THm4In0PmhA5rhHf5Q0NS/J0EmQtdGVSharMkvmTBW0=;
        b=U0ok5oiz62KsJ7Npu4KP6srW+dNOyPFQdFKwpZgHTPeItU9WdCwK8jnSRWF9NJI8Hm
         c+ohg+XwKBmuKEaIM+ObW3V8vY9d2yt4Dq4/5L7Wdeoq1J+dNodoie8fDzlwbFWCb31a
         bOvJyDGCq+OgeKbPUxfqMxsfx2erjc4onYcUkdCWChkDchVQAoR0d1c5yC1FmR/TRqsO
         hUAilN2oDVW8FbDgnDiwyMiBBPfaYSZROGoFKvvF758ZHF3hFqCXPCrAE8Gozc/CLhzq
         GSVNgRvfOzw+Gvb9kGDCxM1RvBRvqnj6LFRxpRx6jF+54GS/BOr8svIVFndeUs0N+JTk
         5eTQ==
X-Gm-Message-State: AOAM5302A6amo4EppDMDI/VmeDE+ydIr3wQeg+j0MnJEGcFiJCI+jqel
        6ML3W5p/vnoMEinoVK/cstuNkQ==
X-Google-Smtp-Source: ABdhPJwd9m59vPwTJ58V1tlzxTY9PpNzpJrV2MMvHOj99lJbegjAi4e8Z+B35ixmspHBkE2kBNTecQ==
X-Received: by 2002:a05:600c:3b84:b0:394:32c6:489 with SMTP id n4-20020a05600c3b8400b0039432c60489mr537215wms.185.1651522797046;
        Mon, 02 May 2022 13:19:57 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id l2-20020adfb102000000b0020c547f75easm7238183wra.101.2022.05.02.13.19.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 May 2022 13:19:56 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au, jernej.skrabec@gmail.com,
        samuel@sholland.org, wens@csie.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@lists.linux.dev,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 16/19] crypto: sun8i-ce: Add function for handling hash padding
Date:   Mon,  2 May 2022 20:19:26 +0000
Message-Id: <20220502201929.843194-17-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220502201929.843194-1-clabbe@baylibre.com>
References: <20220502201929.843194-1-clabbe@baylibre.com>
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
index 859b7522faaa..1c82cd510c75 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -248,6 +248,64 @@ int sun8i_ce_hash_digest(struct ahash_request *areq)
 	return crypto_transfer_hash_request_to_engine(engine, areq);
 }
 
+static u64 hash_pad(__le32 *buf, unsigned int bufsize, u64 padi, u64 byte_count, bool le, int bs)
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
2.35.1

