Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8BA2D3EF4;
	Thu, 26 Jun 2025 09:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750931967; cv=none; b=GcYupLZ9IOku28ib+s5ezUHiF4RW0V6G0pOlZ/zRV31nBG8v0dWTsYTCELfHRCxe4P4Y39Q6o8IbLqft9cev+JdASlrwzqtOWAm4v4QD7C1tN59kXOhAgTrCUQD3z5pwsth8bgtzVYwXf+C3ByN8JhxqtRPNv2+KSD6bqChXPdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750931967; c=relaxed/simple;
	bh=ThK72kzM3/NAb5q4kYO3GzKkml/jXobH2nqcwRen8oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHc7YwHmIjiaIIukXL9gUwQyDwJVlyc6QP+h18j5eFWC8bmxPZWmIa1ZEzXvX6xyc3okqocxHBBF1fFpiq/D9YngqvauFJRaof/GGFDlfyBlOZqiLDbQ6l3ecxjzbe3wX1Ivlop2fRxlfgElfP2Knehe/VNIHjWwMBfGsXN9nS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gSCPY6XS; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gSCPY6XS"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-ae0dd62f2adso53201966b.2;
        Thu, 26 Jun 2025 02:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750931964; x=1751536764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rgIbzVPscBuyqUEBsClRFHHr0kmYa9s+xoX+40DNp18=;
        b=gSCPY6XSedNaGLc2+zHoSPEh3J/xVpzeJRhrB7NK1BlLKX9NLADl8ySSmnHlH0/wth
         wL1xNI75X8caOXNcWJs78IHBO2aITqwQJ/bHcpeUR3ZXlgjPrRD9WpXia7bj86pZj80L
         ZoHCUs+oPGADIc4IVpBVu/PicN7iLqgNdwgRuCUUioG0Ef/p7Jr9sV45XZpzN8gGHIf7
         HQROjWaw5EMtd6WhnV6e/rZENrqk1ba8nM3cFRLv7/EQA4+rZ4h6VRXSkpg+ADIoIdYS
         bo/zhUVvrwKhibJB9sGdII45xhQxqeJ2S+gJ2Ohjag5sxB653985ukExY34RMgAme88S
         gzmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750931964; x=1751536764;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rgIbzVPscBuyqUEBsClRFHHr0kmYa9s+xoX+40DNp18=;
        b=J0uFksacRaTphPPgH0yxh/qmWalnLF3WuPpDpczoXkBRiPJQJgh+dGCGzQ6QY/rCjx
         yR4MaCwswa2X0N2BH3DzbAQnaLj7fO0M8bOxFCxOMDOOWO5sukIRW8pKZhQSbMnIkQmi
         80B63r3CGpIrnIJW+v+YnBGOXQ7j2g9j+7TmnuBtr3L/pzgVJZeMj1kteK6ghjOgOGJw
         issqygfZfpJVg94KVOWu5j9UVvg4o9D7rxJXHPfpqLbqjgqY+PFsX7VwI/SS9pplgnJ/
         e4NKJMbnIQGh5Dm8v07RZKdaolQ+05x5U5+bXF2i8Mawb8XipKbjrYatEFK0v58o49BD
         y5Ew==
X-Forwarded-Encrypted: i=1; AJvYcCU+rg73dRZ5xBglpuPCW3jeXYSmRodkff2OjCCpOPoIma/w5ouw0MiFny+KhxXAbx8wSFlGCD0GZF5O5kU=@vger.kernel.org, AJvYcCUxTfarRtpicd1ae4t2jROfxZbfqRFMtnO7PmRMje9+vYx719iZl2D0pAYDRBkM0SjbPiX2xZPHHYuW+r9M@vger.kernel.org
X-Gm-Message-State: AOJu0YwqJaX79fEEeY/GxpM682CKZ/yCaNkpaXslPKUNtQ7teuc1kQEM
	z1J4nQfxcBXHtH2wLLwVFWfJp6MLDzcDEN3Uztp7eMsTMX3A+TTMrlkS
X-Gm-Gg: ASbGnct1z1awv2mDKf7nhn+37vykWVlhTkd4jzFLaJiOb87tjlh15VRgyIixQboEk/A
	Yx0QJO0gaCpvIEHMqvTvDqpTaNeVPSH1AoDUzXWOBCqodYUlBvuYdz/C9fEeNxpLVXeGWRgAPH7
	M6LsfncoyMHtgAiWXrycDKYc3pzEDQ1QV4PlQzME7rX4mmzFYPUaK+OclK1+a3sJD9XZbIro0lO
	nFgJyJrsEzzkcYPZ4ZxQ8hywM9OkbFf588eUpeCwxabpgRL3jstImffH8rwY48XztekQVs0I8Q8
	zbV3XICH0ui6xecN8sIWIlSmZgTwVyrrEUtp37Wtd0JuXJ8+e/4KgGQ33ZeekZh5IvtEUL4QndS
	BnH/hLKFoMOnUhg==
X-Google-Smtp-Source: AGHT+IHJfX+7ivm4fdZr8aEC60S1v6KlfF4DtnJ6WAAHM60+ZeTeCtoGepFQRb/ZdyWtPXc8/FAGAQ==
X-Received: by 2002:a17:907:94c7:b0:ade:bf32:b05a with SMTP id a640c23a62f3a-ae0be53a92cmr665540566b.0.1750931963697;
        Thu, 26 Jun 2025 02:59:23 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae06aa5ff34sm1014106166b.40.2025.06.26.02.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 02:59:23 -0700 (PDT)
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
Subject: [PATCH v2 05/10] crytpo: sun8i-ce - factor out prepare/unprepare code from ahash do_one_request
Date: Thu, 26 Jun 2025 12:58:08 +0300
Message-ID: <20250626095813.83963-6-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
References: <20250626095813.83963-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The crypto engine workflow for batching requests requires the driver to
chain the requests in do_one_request() and then send the batch for
processing in do_batch_requests().

Split the monolithic ahash do_one_request() callback into two parts,
prepare and unprepare, so they can be used in batch processing.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 64 ++++++++++++++-----
 1 file changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 3ee0c65ef600..7811fa17388c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -312,18 +312,15 @@ static u64 hash_pad(__le32 *buf, unsigned int bufsize, u64 padi, u64 byte_count,
 	return j;
 }
 
-int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
+static int sun8i_ce_hash_prepare(struct ahash_request *areq, struct ce_task *cet)
 {
-	struct ahash_request *areq = container_of(breq, struct ahash_request, base);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
 	struct sun8i_ce_hash_reqctx *rctx = ahash_request_ctx(areq);
 	struct sun8i_ce_alg_template *algt;
 	struct sun8i_ce_dev *ce;
-	struct sun8i_ce_flow *chan;
-	struct ce_task *cet;
 	struct scatterlist *sg;
-	int nr_sgs, flow, err;
+	int nr_sgs, err;
 	unsigned int len;
 	u32 common;
 	u64 byte_count;
@@ -344,18 +341,14 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 
 	bf = (__le32 *)rctx->pad;
 
-	flow = rctx->flow;
-	chan = &ce->chanlist[flow];
-
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
 		algt->stat_req++;
 
 	dev_dbg(ce->dev, "%s %s len=%d\n", __func__, crypto_tfm_alg_name(areq->base.tfm), areq->nbytes);
 
-	cet = chan->tl;
 	memset(cet, 0, sizeof(struct ce_task));
 
-	cet->t_id = cpu_to_le32(flow);
+	cet->t_id = cpu_to_le32(rctx->flow);
 	common = ce->variant->alg_hash[algt->ce_algo_id];
 	common |= CE_COMM_INT;
 	cet->t_common_ctl = cpu_to_le32(common);
@@ -433,22 +426,61 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	else
 		cet->t_dlen = cpu_to_le32(areq->nbytes / 4 + j);
 
-	err = sun8i_ce_run_task(ce, flow, crypto_ahash_alg_name(tfm));
-
-	dma_unmap_single(ce->dev, rctx->addr_pad, rctx->pad_len, DMA_TO_DEVICE);
+	return 0;
 
 err_unmap_result:
 	dma_unmap_single(ce->dev, rctx->addr_res, rctx->result_len,
 			 DMA_FROM_DEVICE);
-	if (!err)
-		memcpy(areq->result, rctx->result, crypto_ahash_digestsize(tfm));
 
 err_unmap_src:
 	dma_unmap_sg(ce->dev, areq->src, rctx->nr_sgs, DMA_TO_DEVICE);
 
 err_out:
+	return err;
+}
+
+static void sun8i_ce_hash_unprepare(struct ahash_request *areq,
+				    struct ce_task *cet)
+{
+	struct sun8i_ce_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ce_hash_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct sun8i_ce_dev *ce = ctx->ce;
+
+	dma_unmap_single(ce->dev, rctx->addr_pad, rctx->pad_len, DMA_TO_DEVICE);
+	dma_unmap_single(ce->dev, rctx->addr_res, rctx->result_len,
+			 DMA_FROM_DEVICE);
+	dma_unmap_sg(ce->dev, areq->src, rctx->nr_sgs, DMA_TO_DEVICE);
+}
+
+int sun8i_ce_hash_run(struct crypto_engine *engine, void *async_req)
+{
+	struct ahash_request *areq = ahash_request_cast(async_req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ce_hash_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct sun8i_ce_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct sun8i_ce_dev *ce = ctx->ce;
+	struct sun8i_ce_flow *chan;
+	struct ce_task *cet;
+	int err;
+
+	chan = &ce->chanlist[rctx->flow];
+	cet = chan->tl;
+
+	err = sun8i_ce_hash_prepare(areq, cet);
+	if (err)
+		return err;
+
+	err = sun8i_ce_run_task(ce, rctx->flow, crypto_ahash_alg_name(tfm));
+
+	sun8i_ce_hash_unprepare(areq, cet);
+
+	if (!err)
+		memcpy(areq->result, rctx->result,
+		       crypto_ahash_digestsize(tfm));
+
 	local_bh_disable();
-	crypto_finalize_hash_request(engine, breq, err);
+	crypto_finalize_hash_request(engine, async_req, err);
 	local_bh_enable();
 
 	return 0;
-- 
2.49.0

