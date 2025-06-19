Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1902323ED5E;
	Thu, 19 Jun 2025 12:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750335860; cv=none; b=PDkiG+DslzQqllatkmEcQBJBKUQBtaMqyO3GMdEQEqFI+044IJdwGLs9Bj11UtDywQl+jQQT/C/4elNA/SxZo0W7Z9OaHJyg5GG5i9LTnVtDO7TtFZbK+XXT2GkmUFQhlVsUsPHhabSRk3/Jb/JYtagcvEmZ1jrHyeDN8lIR18E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750335860; c=relaxed/simple;
	bh=C/gJk2ObWTENdNN8gXRsiciv6hvj3wk+copliiqlW8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljl49Jz2PrKSoL5qBPPHofAdc4VtPdNlpbdEdMZdV/84QJwHr9QiaAygovFXKGTYF1RgE/nsvsdxe8cNcN+amTM+EC0nOOfhMfMFT+FQH7gSRJcBRpHpIMEALYi4ejYx5o9s0eLRH+6e36spO0G8fo+F5DaRBTttpKvnYhozick=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hbg6CXLc; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hbg6CXLc"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-ade4679fba7so144146266b.2;
        Thu, 19 Jun 2025 05:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750335855; x=1750940655; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n4FE/m8CCQWWX6zEjUZSa1AuebcPVAo/kb1WN2hI258=;
        b=hbg6CXLcW1TtkUUoM+zWRzaSftIp7J1UzgcE9zXpPtT60VDLseauixlu9KB5p/mTUs
         2vYGIMrr9hN16BXXWjmju71IQfmbuKV+O+7TXfDB9frjLpqbUuvqoeG26ft+z0MBQoHU
         2WhbgzTsw/TMfdyO9dSUq8WYZZXCpA5vIjRQEOqyagS4I0tIjQbx37zvJKdmXkmbLoKk
         /RsVebu2iuuXEbalMTlpLf9xY0y6FfVJTrfZWmZInDTdMgZ3ogEHJC12ISDBuaqGZzrR
         gata6hwPMpt3ejFTdTHCKmNj4u9awc0tMmHre69KGvePtrZigsLsQGW9gIfPj6EL+A59
         jNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750335855; x=1750940655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n4FE/m8CCQWWX6zEjUZSa1AuebcPVAo/kb1WN2hI258=;
        b=WMP5wKAIBuJjvR7OofQkbo1GEujzYpHY8pqoa5iMa7EXeGj6JmyLuLPx02po/lRkWC
         vdDYBrX5YJeKFMMeryLQp7y1LTrkZAJPOg1tnnJTmp81vtxy1O76txatOpQhBW9vPhyl
         zJaSlRUF/IjqQrZlIYQ6aWWsWe4iS5qKnLp12z67BCXvEJS5YdoISPle2ptmU/0wJ3mi
         5i0ZejzhN7V19+CY3LGE3L9PgF3dzBlKMIcuVOkFQbJGuc1maTb9IK1uakkF/C61+lh5
         tMuqQ/YiS0pfJW7PcsPezFpQlrEBBJg/GgXu/emvdM9yomFIo61Rmysp7g2X6sg4ZbxK
         bFLQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSfSQDFOqv3yH5j5WkYAzFz0Sna7K7hSh07NYBwVNT+ir5DZTZMDWjsZNJLX6k8H8utXMReCAqLhfSYXHQ@vger.kernel.org, AJvYcCXyn6vtCfCZmrJU9DdtkmzNA/Lj6Do4Q447Xh4ySizG/bT7W/SwSq5wZ8rr5ylbKLerDUd3rJJKyj4DCAA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlMDhkfki+ud3Kms05LO5XgXl0y3vOL6m+VguvXQEnj1MScGSh
	rZT86hb3a+uEgm2Buk2Gyvju0xKigfLIKZazmg09KF4fbXfYDxELSwYRvJodaA==
X-Gm-Gg: ASbGncsePT16b0y8Sd2IlmY/6F732QQmU/Aq0jrqLfAF1MGSgs17WS26zVCh65bK1Ll
	u5hoe3bFnsEBxWTXV8Op1YxYbNOJH+RXa+A/dPhaChV/HkDuxtq8RI/X5FMYcZ+am+NMeX/Ax+p
	BH6Z7kG2fHtPpzdLlcxov2Bxu4Gd7CqxTFg7LmZXqh9kC1FJ8u6XHmLLYwq/oIt08hcyQAWrecv
	aShLlCsa+7JG5N5CKZifAHhYaalqfh4dY6tJLSUPQqB/z7lX3dj1oA2XIalVIhQvFlyCBzUMgXL
	hxlmIgoCYnhPI5seyHdO0549r3KkgYkBGWc4re+cGZYi7dVYgtt9XTqvazUlY1kFxhm038P/Rqu
	vSB4XgSWgvfXXoA==
X-Google-Smtp-Source: AGHT+IEqkd21piHtgzZrKyYzEgGCeUARprhDQ5f8PJdOXO/FUR4X0Sb+5gSgjLC8tCZKpkV/N0CMLw==
X-Received: by 2002:a17:907:1c9e:b0:ad8:8529:4f86 with SMTP id a640c23a62f3a-adfad5e2b12mr2149539166b.58.1750335855186;
        Thu, 19 Jun 2025 05:24:15 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae000b02bd3sm504688066b.3.2025.06.19.05.24.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 05:24:14 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: clabbe.montjoie@gmail.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Cc: wens@csie.org,
	jernej.skrabec@gmail.com,
	samuel@sholland.org,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Subject: [PATCH 04/10] crypto: sun8i-ce - save hash buffers and dma info to request context
Date: Thu, 19 Jun 2025 15:23:10 +0300
Message-ID: <20250619122316.2587236-5-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250619122316.2587236-1-ovidiu.panait.oss@gmail.com>
References: <20250619122316.2587236-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, all hash processing (buffer allocation/deallocation, dma
mapping/unmapping) is done inside do_one_request() callback.

In order to implement request batching, the hash buffers and dma info
associated with each request need to be saved inside request context, for
later use (during do_batch_requests() callback).

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 56 +++++++------------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 17 ++++++
 2 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 61e8d968fdcc..3ee0c65ef600 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -328,12 +328,9 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	u32 common;
 	u64 byte_count;
 	__le32 *bf;
-	void *buf, *result;
 	int j, i, todo;
 	u64 bs;
 	int digestsize;
-	dma_addr_t addr_res, addr_pad;
-	int ns = sg_nents_for_len(areq->src, areq->nbytes);
 
 	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash.base);
 	ce = algt->ce;
@@ -345,19 +342,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	if (digestsize == SHA384_DIGEST_SIZE)
 		digestsize = SHA512_DIGEST_SIZE;
 
-	/* the padding could be up to two block. */
-	buf = kcalloc(2, bs, GFP_KERNEL | GFP_DMA);
-	if (!buf) {
-		err = -ENOMEM;
-		goto err_out;
-	}
-	bf = (__le32 *)buf;
-
-	result = kzalloc(digestsize, GFP_KERNEL | GFP_DMA);
-	if (!result) {
-		err = -ENOMEM;
-		goto err_free_buf;
-	}
+	bf = (__le32 *)rctx->pad;
 
 	flow = rctx->flow;
 	chan = &ce->chanlist[flow];
@@ -378,11 +363,12 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	cet->t_sym_ctl = 0;
 	cet->t_asym_ctl = 0;
 
-	nr_sgs = dma_map_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
+	rctx->nr_sgs = sg_nents_for_len(areq->src, areq->nbytes);
+	nr_sgs = dma_map_sg(ce->dev, areq->src, rctx->nr_sgs, DMA_TO_DEVICE);
 	if (nr_sgs <= 0 || nr_sgs > MAX_SG) {
 		dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
 		err = -EINVAL;
-		goto err_free_result;
+		goto err_out;
 	}
 
 	len = areq->nbytes;
@@ -397,10 +383,13 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 		err = -EINVAL;
 		goto err_unmap_src;
 	}
-	addr_res = dma_map_single(ce->dev, result, digestsize, DMA_FROM_DEVICE);
-	cet->t_dst[0].addr = desc_addr_val_le32(ce, addr_res);
-	cet->t_dst[0].len = cpu_to_le32(digestsize / 4);
-	if (dma_mapping_error(ce->dev, addr_res)) {
+
+	rctx->result_len = digestsize;
+	rctx->addr_res = dma_map_single(ce->dev, rctx->result, rctx->result_len,
+					DMA_FROM_DEVICE);
+	cet->t_dst[0].addr = desc_addr_val_le32(ce, rctx->addr_res);
+	cet->t_dst[0].len = cpu_to_le32(rctx->result_len / 4);
+	if (dma_mapping_error(ce->dev, rctx->addr_res)) {
 		dev_err(ce->dev, "DMA map dest\n");
 		err = -EINVAL;
 		goto err_unmap_src;
@@ -428,10 +417,12 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 		goto err_unmap_result;
 	}
 
-	addr_pad = dma_map_single(ce->dev, buf, j * 4, DMA_TO_DEVICE);
-	cet->t_src[i].addr = desc_addr_val_le32(ce, addr_pad);
+	rctx->pad_len = j * 4;
+	rctx->addr_pad = dma_map_single(ce->dev, rctx->pad, rctx->pad_len,
+					DMA_TO_DEVICE);
+	cet->t_src[i].addr = desc_addr_val_le32(ce, rctx->addr_pad);
 	cet->t_src[i].len = cpu_to_le32(j);
-	if (dma_mapping_error(ce->dev, addr_pad)) {
+	if (dma_mapping_error(ce->dev, rctx->addr_pad)) {
 		dev_err(ce->dev, "DMA error on padding SG\n");
 		err = -EINVAL;
 		goto err_unmap_result;
@@ -444,21 +435,16 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 
 	err = sun8i_ce_run_task(ce, flow, crypto_ahash_alg_name(tfm));
 
-	dma_unmap_single(ce->dev, addr_pad, j * 4, DMA_TO_DEVICE);
+	dma_unmap_single(ce->dev, rctx->addr_pad, rctx->pad_len, DMA_TO_DEVICE);
 
 err_unmap_result:
-	dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
+	dma_unmap_single(ce->dev, rctx->addr_res, rctx->result_len,
+			 DMA_FROM_DEVICE);
 	if (!err)
-		memcpy(areq->result, result, crypto_ahash_digestsize(tfm));
+		memcpy(areq->result, rctx->result, crypto_ahash_digestsize(tfm));
 
 err_unmap_src:
-	dma_unmap_sg(ce->dev, areq->src, ns, DMA_TO_DEVICE);
-
-err_free_result:
-	kfree(result);
-
-err_free_buf:
-	kfree(buf);
+	dma_unmap_sg(ce->dev, areq->src, rctx->nr_sgs, DMA_TO_DEVICE);
 
 err_out:
 	local_bh_disable();
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 0d46531c475c..90b955787d37 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -110,6 +110,9 @@
 
 #define MAXFLOW 4
 
+#define CE_MAX_HASH_DIGEST_SIZE		SHA512_DIGEST_SIZE
+#define CE_MAX_HASH_BLOCK_SIZE		SHA512_BLOCK_SIZE
+
 /*
  * struct ce_clock - Describe clocks used by sun8i-ce
  * @name:	Name of clock needed by this variant
@@ -304,9 +307,23 @@ struct sun8i_ce_hash_tfm_ctx {
  * struct sun8i_ce_hash_reqctx - context for an ahash request
  * @fallback_req:	pre-allocated fallback request
  * @flow:	the flow to use for this request
+ * @nr_sgs: number of entries in the source scatterlist
+ * @result_len: result length in bytes
+ * @pad_len: padding length in bytes
+ * @addr_res: DMA address of the result buffer, returned by dma_map_single()
+ * @addr_pad: DMA address of the padding buffer, returned by dma_map_single()
+ * @result: per-request result buffer
+ * @pad: per-request padding buffer (up to 2 blocks)
  */
 struct sun8i_ce_hash_reqctx {
 	int flow;
+	int nr_sgs;
+	size_t result_len;
+	size_t pad_len;
+	dma_addr_t addr_res;
+	dma_addr_t addr_pad;
+	u8 result[CE_MAX_HASH_DIGEST_SIZE] ____cacheline_aligned;
+	u8 pad[2 * CE_MAX_HASH_BLOCK_SIZE] ____cacheline_aligned;
 	struct ahash_request fallback_req; // keep at the end
 };
 
-- 
2.49.0

