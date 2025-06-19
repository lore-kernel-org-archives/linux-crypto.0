Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C847248888;
	Thu, 19 Jun 2025 12:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750335858; cv=none; b=GzibR34vV0oRqUd9Of68GQKQ1Tm1CEMdG8EpNQE+6McWjcVNaRYz8t1v0kCqDEw2u1eKI/0lgFmcmCawQaj1bMB3OyBp5D6pM0S8M2BZoZ4zuykagXCKVbwzXR+zvrPgFQQFZCjHiWX574mYKozK9vch+X+feyD1Rzq3hh7PNLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750335858; c=relaxed/simple;
	bh=pRmnLFjBJ2dWkN+uiG3G+4366k2+/zNV3iQ7dsrr+ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=roMnd1cj1xONiqxkks8jVkkIjAVco+60Qj1AGEGtl7YUqjakI4QgkNT/JIdASdSsN0PU4ikePqaTMe60yfPepDu9gog1k7MNRVkEiOru9I7CRmVverWGYQ2vMtVs9TBLGr/LebpdcxI5Vzb7fC2ND4gtFGqVpxmnQjmh10dlYuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ThHQuOYe; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ThHQuOYe"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-60700a745e5so1478463a12.3;
        Thu, 19 Jun 2025 05:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750335854; x=1750940654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t10wxuAUiB4KyOt9zeZgZ/9RxJrj16+YdQHln4bOH7s=;
        b=ThHQuOYeqiZG+GJk9D7KhulVi21VVv8RRsKVO+tvEV+uwloMA12pZEwGU7SQesBY1i
         VPDzQFnaTAsyIvgspU80IuHAUFHCdNF8zFSYaZJiQcAG+WuWunUlGJqHcW9IHz4SiYZX
         Qn2ujI7JJJdIcMcGbeVx5NINlMfNqwF24j+fDnBtrvDIOaFO1S/VZqZKL+PIr7lYMZP+
         pQb5pSK3exNUJeknP1yToyBOoUJ/0hi0/pvpuwwQxDfSF2sX7VCQNiAadcf6TqXRbYvI
         06iubcaHeADi2WLpHE+mvTCDTGzOZJRmwJUWEZoSYIESl80caVXQWw+iYeTtiaD4H45r
         +gIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750335854; x=1750940654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t10wxuAUiB4KyOt9zeZgZ/9RxJrj16+YdQHln4bOH7s=;
        b=F5PZaUhaTzOOPyPN80UHPzr9WXT8RJqC0dxP0M/QfPujLQHHRVkPW/rPPD4cpiHRgG
         84Rt4irxgKmKHRgXu3mDZvW73tGNqg+fHRhDsE5bv1nGRGTj+YM0YVH7laaJHnnnvmqt
         134H4u3w2bQovbWe/1BuyKeVMRFgeD5dWt6KVHvX8ugcqStSE5S7nIODxpVIP84XkRk2
         5IHim1LY800By3eWu+uwiQC2RMVWF8CH6Zi1yoEtZxr+TCUktvIqQzxPlxst+ODljtJC
         ygAA9I3YrxSkr0y1hctSvAb1IP+7DbJKTCIgx67mqD+MeuRLxYfpDXwHWHVnNZqiTpzw
         t5og==
X-Forwarded-Encrypted: i=1; AJvYcCVH4k/uWTUv+GK2LTa2mJNXhw8QG5DYePP8JTiygfJc2RDNNYGKUZG+DVR2tffSP2ZMyEzKTQ86KiOHLWw=@vger.kernel.org, AJvYcCXmEtcR9iMNUhjefjpXJsksMbsGu3a9WgwwUol1upSPtsc+D7TNRCJIFnBNQmXuaHwcrNsJ2Ns6/FD2WF9c@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1LZ01NoleKanfffu7sCsCGLdjN/VrcZ5YTm+2ZkJUBkjH85fj
	BFPLxCzxfK3z1HH35hGbJAOlTB0PWPTzaGKH4MhMppjWeVvVzfDMCFhE
X-Gm-Gg: ASbGnctH7mRSA8TqCKgsvu3jOnPGnGQXUHCzTPny6o+urILKyUoihfvW5Kg3KCV5rHc
	h4V0yhbQ//57jDsEmGcig1bhsVuIliMAqfOkfgCs9jglvzeNekuQ7VYQUE47V5wQMDFNkzPcihy
	+y4/AeD7Z+lCnwe8udkCZ9G3MeTKC4Fs4oe2tzL3EljLVYO3jI174u6kKn+igaht+Qp0/AtjHF+
	MfO2DzMvfrmIhC5Qdol/H6lURFpKSAN6kpcnWLT0l/aXWnLyaMtcsbAEmEkYgLsO/G0SnA3H7Tq
	QP0IuLyXCEI5NsvWKIg01/AoDJz841qsOyOYfHgFWRe8IMpfc73ecFvYDAYcH7XN80r5O1yBpRT
	id2o90Fm4h7YUPw==
X-Google-Smtp-Source: AGHT+IHjXBuVHBHVzGX7KJawSoi/MaD0OIMw0TPwOstgtvFQbFHnqwQM6253a1WMLNA8WmktvzgJrw==
X-Received: by 2002:a17:907:7fa6:b0:ae0:3f20:68f8 with SMTP id a640c23a62f3a-ae03f207cdamr188465966b.39.1750335854011;
        Thu, 19 Jun 2025 05:24:14 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae000b02bd3sm504688066b.3.2025.06.19.05.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 05:24:13 -0700 (PDT)
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
Subject: [PATCH 03/10] crypto: sun8i-ce - move bounce_iv and backup_iv to request context
Date: Thu, 19 Jun 2025 15:23:09 +0300
Message-ID: <20250619122316.2587236-4-ovidiu.panait.oss@gmail.com>
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

Currently, the iv buffers are allocated once per flow during driver probe.
Having a single iv buffer for all requests works with the current setup
where requests are processed one by one, but it wouldn't work if multiple
requests are chained together and processed in one go.

In preparation for introducing request batching, allocate iv buffers per
request, rather than per flow.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c       | 18 +++++++++---------
 .../crypto/allwinner/sun8i-ce/sun8i-ce-core.c  | 12 ------------
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h   |  8 ++++----
 3 files changed, 13 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 113a1100f2ae..9963e5962551 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -209,11 +209,11 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	if (areq->iv && ivsize > 0) {
 		if (rctx->op_dir & CE_DECRYPTION) {
 			offset = areq->cryptlen - ivsize;
-			scatterwalk_map_and_copy(chan->backup_iv, areq->src,
+			scatterwalk_map_and_copy(rctx->backup_iv, areq->src,
 						 offset, ivsize, 0);
 		}
-		memcpy(chan->bounce_iv, areq->iv, ivsize);
-		rctx->addr_iv = dma_map_single(ce->dev, chan->bounce_iv, ivsize,
+		memcpy(rctx->bounce_iv, areq->iv, ivsize);
+		rctx->addr_iv = dma_map_single(ce->dev, rctx->bounce_iv, ivsize,
 					       DMA_TO_DEVICE);
 		if (dma_mapping_error(ce->dev, rctx->addr_iv)) {
 			dev_err(ce->dev, "Cannot DMA MAP IV\n");
@@ -299,13 +299,13 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
-			memcpy(areq->iv, chan->backup_iv, ivsize);
-			memzero_explicit(chan->backup_iv, ivsize);
+			memcpy(areq->iv, rctx->backup_iv, ivsize);
+			memzero_explicit(rctx->backup_iv, ivsize);
 		} else {
 			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
 						 ivsize, 0);
 		}
-		memzero_explicit(chan->bounce_iv, ivsize);
+		memzero_explicit(rctx->bounce_iv, ivsize);
 	}
 
 	dma_unmap_single(ce->dev, rctx->addr_key, op->keylen, DMA_TO_DEVICE);
@@ -348,13 +348,13 @@ static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
 					 DMA_TO_DEVICE);
 		offset = areq->cryptlen - ivsize;
 		if (rctx->op_dir & CE_DECRYPTION) {
-			memcpy(areq->iv, chan->backup_iv, ivsize);
-			memzero_explicit(chan->backup_iv, ivsize);
+			memcpy(areq->iv, rctx->backup_iv, ivsize);
+			memzero_explicit(rctx->backup_iv, ivsize);
 		} else {
 			scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
 						 ivsize, 0);
 		}
-		memzero_explicit(chan->bounce_iv, ivsize);
+		memzero_explicit(rctx->bounce_iv, ivsize);
 	}
 
 	dma_unmap_single(ce->dev, rctx->addr_key, op->keylen, DMA_TO_DEVICE);
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
index 79ec172e5c99..930a6579d853 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
@@ -757,18 +757,6 @@ static int sun8i_ce_allocate_chanlist(struct sun8i_ce_dev *ce)
 			err = -ENOMEM;
 			goto error_engine;
 		}
-		ce->chanlist[i].bounce_iv = devm_kmalloc(ce->dev, AES_BLOCK_SIZE,
-							 GFP_KERNEL | GFP_DMA);
-		if (!ce->chanlist[i].bounce_iv) {
-			err = -ENOMEM;
-			goto error_engine;
-		}
-		ce->chanlist[i].backup_iv = devm_kmalloc(ce->dev, AES_BLOCK_SIZE,
-							 GFP_KERNEL);
-		if (!ce->chanlist[i].backup_iv) {
-			err = -ENOMEM;
-			goto error_engine;
-		}
 	}
 	return 0;
 error_engine:
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index f12c32d1843f..0d46531c475c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -188,8 +188,6 @@ struct ce_task {
  * @status:	set to 1 by interrupt if task is done
  * @t_phy:	Physical address of task
  * @tl:		pointer to the current ce_task for this flow
- * @backup_iv:		buffer which contain the next IV to store
- * @bounce_iv:		buffer which contain the IV
  * @stat_req:	number of request done by this flow
  */
 struct sun8i_ce_flow {
@@ -198,8 +196,6 @@ struct sun8i_ce_flow {
 	int status;
 	dma_addr_t t_phy;
 	struct ce_task *tl;
-	void *backup_iv;
-	void *bounce_iv;
 #ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 	unsigned long stat_req;
 #endif
@@ -264,6 +260,8 @@ static inline __le32 desc_addr_val_le32(struct sun8i_ce_dev *dev,
  * @nr_sgd:		The number of destination SG (as given by dma_map_sg())
  * @addr_iv:		The IV addr returned by dma_map_single, need to unmap later
  * @addr_key:		The key addr returned by dma_map_single, need to unmap later
+ * @bounce_iv:		Current IV buffer
+ * @backup_iv:		Next IV buffer
  * @fallback_req:	request struct for invoking the fallback skcipher TFM
  */
 struct sun8i_cipher_req_ctx {
@@ -273,6 +271,8 @@ struct sun8i_cipher_req_ctx {
 	int nr_sgd;
 	dma_addr_t addr_iv;
 	dma_addr_t addr_key;
+	u8 bounce_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
+	u8 backup_iv[AES_BLOCK_SIZE] ____cacheline_aligned;
 	struct skcipher_request fallback_req;   // keep at the end
 };
 
-- 
2.49.0

