Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C38430E82B;
	Tue,  2 Sep 2025 13:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819390; cv=none; b=P1X++HJ4x+nfMh5NxBdYq/zG9O3jInZW+mjh06UssCiSscDoz9UfMyZwZh2UiOXDk/Qe8VxU8me9GCDEo2ZiU138Rmo4KIWlZ22ilCaOm8+T04o+wfymikhhdzDUprEKjLxdpFcA4BxYQpSrN/fjKIPAxxyEAiLzSwLtJEkR+Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819390; c=relaxed/simple;
	bh=pi1l7opJu00vs6MD7nSWkMq1KZSzvh++I4qQ67bTi2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8kB91O/s09dbkxNxRg7rqeSSeHWUqEWqqhDE/+vTYduWi1wDw+T0bAZa4N9UY9EmqaXWIxQozMI5BjOzP9jQn25TS9VjE/OF7TBkm+LIDLkSMofCpeo3zWecmRPnrC6fTQ30xyx6Ds2RzX368k7N4DaIz9V6cP1qNmwlcok8d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c5YOn7/2; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c5YOn7/2"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3d0b6008a8bso2111014f8f.0;
        Tue, 02 Sep 2025 06:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756819386; x=1757424186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+zU65F7Gerz/ADwaQ8W/yEAgtxRKhLtaag+pELJ150=;
        b=c5YOn7/2SAM7xPfF66ZCpDKe9AuZsY6snS9czo5FwGTVouXmZcit8UHgDvcXc33Lrn
         /iBdClrgO6M1sp0k8vuHSFIpgPpMBehUD1LXe2nLf8XU2adfq1F9R0gBHIdSlHFloufV
         Zlvpiz4QFJBvCfYvdU1pn9gqBucDhKlQ700AUICBMFXvRd3GKuxGUr3B+4EgvB4kBh0Q
         im0TRbkGnHryhJ3t7HbS+pjkmVn2J8of2rilRvZtRl7Wj2s9diPl2nrT+R8wRRPjawjD
         sLtixWFxXYfHO7w98g/Btyfe/HiFAZk5w92R1CtDUh9Vsg0d1jEc1+skk+0P7H2sGNqy
         Zq1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819386; x=1757424186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J+zU65F7Gerz/ADwaQ8W/yEAgtxRKhLtaag+pELJ150=;
        b=jGXYHYrGXiFQSakhOGDk0nBqORgBQZ9SP9c30AljdMo6B954qf1qlQleFlpOcwzn1I
         CIUlRXGXrp6B9VE59zBXpnGxcK0Awd1INY1nTmUkp94/ho+g73I+4J+WDjpHu+HuAOYd
         lZ4iV3+W3BYY4s1Q8/W36QMtPowOk4cxFmWaeG6C4b96FHLZw4Yr4dUNoOQuvMPBTAon
         ewaEkolXXdNczhSX3snImt0fjBS0CKeLPZBvtYlZ1NyP416SE9akncGvuk673kT79upA
         vCl+wKj5bKj3T5kAbHSIzKir6zD5eqEZWrGCkp8ZPvpOpuLsT7M/7mDoo7NaZ8vGqTfb
         4CTw==
X-Forwarded-Encrypted: i=1; AJvYcCVAJdwpc+5q4Xiq2iVqNx2n9MLknHy4raFhIKBrRSAE+N0x8fcY9qXVS6NsA3ef7KVHOX3KFCNeXzsej/PK@vger.kernel.org, AJvYcCX1v/b6r9nFInyoFgBCnZYP8swGSfyqP/FZ+t/LZ4ROQ7hJAgE8PGLim6fbl88D+j1pNK1JalBQAROvT+I=@vger.kernel.org
X-Gm-Message-State: AOJu0YxF653bKiUx8F2Pzd79XMH30k56tJ7Hh09f156fU6JSQYmkjCUL
	wzww80XLkFlz850wAgJsg/o+RivvFI7mnMWxj1BqX9aMtDiGv4T5R2/u
X-Gm-Gg: ASbGncuRSdVEyvfxU2YmhROPgp8kScRIZnNzi079vRpUVkKRYFbUVnSm92qVWTsEiUe
	8RyGJG9K3VBMQ/7M0+vR5iPM0t9jUb/lMZ/iTQuoLNLAaZWH2te19VgTiant5/mkVNdjLut154A
	Y35WnRGUSfAC5Mi+1XtX47l01d64dDwmFvgPJ6p7YcFoMhlYjvBtb63993WKahj7x3m1S+S5MLP
	KkfcaVLm5JFgkLf7c1ZAtr7jH6JFp2TcoUxr5lQqU0mpNEMgpLaGHiiBHRVkbdl/zTOHlDpRFa7
	GqQNQHZhuh1/FBNKS7c5UyBlKtjDIqI0EFjDYNTBREl3qCVq/oMJBBJyPX/EfXgQkYYQj5Akq6V
	CCeHvYSAIltU7LM9DrSwc1YREiJI8bRuAm72rGQKCjhiy
X-Google-Smtp-Source: AGHT+IGEIroq02nSpRHx0vFtxRxr9TNdfsRxwLjDOb7ndAqqFPycS5qCf/jnA7MepquM0G+zsISS8Q==
X-Received: by 2002:a05:6000:2281:b0:3ca:83e2:6339 with SMTP id ffacd0b85a97d-3d1e02cb35fmr8305578f8f.49.1756819386400;
        Tue, 02 Sep 2025 06:23:06 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:c207:b600:978:f6fa:583e:b091])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b945332adsm44452155e9.4.2025.09.02.06.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 06:23:06 -0700 (PDT)
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
Subject: [PATCH v3 9/9] crytpo: sun8i-ce - factor out prepare/unprepare from sun8i_ce_hash_run()
Date: Tue,  2 Sep 2025 16:21:34 +0300
Message-ID: <20250902132134.3287515-10-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902132134.3287515-1-ovidiu.panait.oss@gmail.com>
References: <20250902132134.3287515-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to make the ahash code more clear and modular, split the
monolithic sun8i_ce_hash_run() callback into two parts, prepare and
unprepare (therefore aligning it with the sun8i-ce skcipher code).

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 62 ++++++++++++++-----
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 6573c566bd0d..d01594353d9a 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -313,18 +313,15 @@ static u64 hash_pad(__le32 *buf, unsigned int bufsize, u64 padi, u64 byte_count,
 	return j;
 }
 
-int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
+static int sun8i_ce_hash_prepare(struct ahash_request *areq, struct ce_task *cet)
 {
-	struct ahash_request *areq = container_of(breq, struct ahash_request, base);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
 	struct sun8i_ce_hash_reqctx *rctx = ahash_request_ctx_dma(areq);
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
@@ -345,18 +342,14 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 
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
@@ -434,22 +427,59 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
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
+	struct sun8i_ce_hash_reqctx *rctx = ahash_request_ctx_dma(areq);
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
+	struct sun8i_ce_hash_reqctx *rctx = ahash_request_ctx_dma(areq);
+	struct sun8i_ce_dev *ce = ctx->ce;
+	struct sun8i_ce_flow *chan;
+	int err;
+
+	chan = &ce->chanlist[rctx->flow];
+
+	err = sun8i_ce_hash_prepare(areq, chan->tl);
+	if (err)
+		return err;
+
+	err = sun8i_ce_run_task(ce, rctx->flow, crypto_ahash_alg_name(tfm));
+
+	sun8i_ce_hash_unprepare(areq, chan->tl);
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
2.50.0

