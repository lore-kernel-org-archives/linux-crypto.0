Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A92C3B71B8
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 19:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783625406; cv=none; b=LhbsleeC1PDSsMSwI7oimkiUP3YVybRCS21CwSb7gr5O4QBWUhm2f9f9Hrvy5IeV2S9U2bLorvkWp7pHytlrBbBIyBSvTZoP484ElPll7zclOu5XFCOydY49cJyRDym5X4DwI7qjirs3vf/53jtLH0O3c4OPWn8xx0pmPqbpTNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783625406; c=relaxed/simple;
	bh=It/vngTHoXgwnbxdJi+l2Offpe5utn5IJdLuix8L6rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuWaTTHW9bxwTU9qWCycKhw4nw0IwcqcWA/Dv16ovWrgGG08TESGRYqtNcvf644rVJRmd4w4SXtvMceeYdr8/QvxIBpZQCAPobSXJtUty1DD13HfE/1guBcAfuTg4Xu62NKAKZEDA+U76HbMsFkU1cGcFoljpwu5nId7BUixKcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KLe8WIky; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KLe8WIky"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-4720d22c94aso243157f8f.1
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2026 12:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783625403; x=1784230203; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lSepW92Ui6zUAtuYYdgbrc3o33jZ3G2C22P2tfVDqpY=;
        b=KLe8WIkywgpLqow3/iXk/xz3Vx6QO/8LpKaSvpDOUsNhBAan8b1xImU1I2ZeD4S7KI
         CcgC+kQBg6+GxFxsu09FKtQgeh0geBl0YGzjmjgvDOG+8RR21C5fwzMIFCLwRq6nXhzK
         uppjBg1fwY7OaJK8O4PJ+fGDi0eYAxEKcwsC2N0bEb2SumXiOY/1QNj91GSnqhBMAuTC
         xv3nZ+cW7LKVhetZZD07tc4ovzwFThvyh2Sj9ce+jUGJovfJ3ZnzDyD0T/uVUnEXtZGA
         toUD3B0cvuvZ+naUk1U82hfmr/Xog5XzwQ0GBJZ5DaxR6HWk+0oggrevgR/CXn+ctPG1
         cbPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783625403; x=1784230203;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=lSepW92Ui6zUAtuYYdgbrc3o33jZ3G2C22P2tfVDqpY=;
        b=nrYdDCyumWS80HWrUwJAJYlF8rQAR6cCWaqXC4O0fOvQnQCvbY6MIzZOpscub3n7D1
         jeWiPTMdeV83ZUFq6b/Y5vW3M7uW8uqQt8Ct9yzbjP6LkTRo8Pb919OHy6Qh7Pl5rx1Z
         Jb2fOs9h5BSj/5EFfmAt0yJKMAX/QnaGujGgeUWGwtDnNJBz7137Tx2NqWjvyouPW0S4
         7bsU0UXzVtag/6RBdMA5LUmiIh53IT7mMxuJpPF+/iwq/As8u/IMQy3sCBW4dswVSeAJ
         3K1y1rxE1uYrpvZniCubuRqzeZgHQqBvvu4R5cmH8bttoTuBft8nR8fjI5hbW03bfGTW
         lCwQ==
X-Forwarded-Encrypted: i=1; AHgh+RrQMKMNHNEjRMJy+TMqvMemdUy7fFnpsXEKTJKV5al95/MsErHiGgBE9O78LKKvYC4eQP/OzA2myWybtmE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9iwJG0S6V++oWEZ/GeG2e1dKtaOAwwfarnk/gphgIng9zHrNs
	aElKcABbziuP6Qh8gAn1veXr6jvAjgwQ+SBuxg2q1iu4SPaFn2WNYoyN
X-Gm-Gg: AfdE7cmi33SqfqE5icBscLfiSlQ5QveE9zFoxMgxk9ct/ZhUQRwDQu0kRl+HZhwh1Yy
	IjP2cw2Mh0Z4iT3ZzGq5mlicb5pG4XbF76TJ0hO8QqRfm6llhzrSth4ThuRpRTHauJbUf2vvXc9
	XZvl8RLoJKVLVGfzDbMyyTq3bbE5Rf0xMq24QeqRpQJ2GIPzFdhCZSHtnwPF0bel7c4DQPrOkM3
	C6mbKHBtnA+eGq8sXeVMEDSLRpXMEFb4RMLZjU68li6uw0H5NY/5s+ji8u3GzdqrkmeAd7ypgV7
	oFpAv0oMybQR2N/ao7yiSmd2fidSwIL+nrv522YN5TKUzz6wsw6m6MCgS+KnrjubjDf9etdWtXx
	VmSrRW9xehV6fWfnzxd5qJwoxjG93cW3pBrqVH2RLShrw6dv+myOEh+FOii4ch0J1t9mBCz0Kzx
	+y/Bk1Lcw77lUEU8M/IXx3Y53R
X-Received: by 2002:a05:6000:3cc:b0:47e:693d:6cca with SMTP id ffacd0b85a97d-47e693d6cd9mr1729574f8f.42.1783625402661;
        Thu, 09 Jul 2026 12:30:02 -0700 (PDT)
Received: from mini.main.internal ([2a02:908:c211:cd18:d9f3:ab2b:ac6e:fc84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e6ccsm53873509f8f.5.2026.07.09.12.30.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 12:30:02 -0700 (PDT)
From: Goetz Goerisch <ggoerisch@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ggoerisch@gmail.com,
	herbert@gondor.apana.org.au,
	herve.codina@bootlin.com,
	linux-crypto@vger.kernel.org,
	miquel.raynal@bootlin.com,
	paul.louvel@bootlin.com,
	sashal@kernel.org,
	stable@vger.kernel.org,
	thomas.petazzoni@bootlin.com
Subject: [PATCH 2/5] Revert "crypto: talitos - fix SEC1 32k ahash request limitation"
Date: Thu,  9 Jul 2026 21:28:23 +0200
Message-ID: <20260709192826.12699-3-ggoerisch@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260709192826.12699-1-ggoerisch@gmail.com>
References: <2026070912-pluck-bagful-2a71@gregkh>
 <20260709192826.12699-1-ggoerisch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This reverts commit 00463d5f864ae28b7938d5acd0ddd800d5457e8b.
---
 drivers/crypto/talitos.c | 216 +++++++++++++--------------------------
 1 file changed, 69 insertions(+), 147 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index f78a44f99101..4ca4fbd227bc 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -12,7 +12,6 @@
  * All rights reserved.
  */
 
-#include <linux/workqueue.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -871,18 +870,10 @@ struct talitos_ahash_req_ctx {
 	unsigned int swinit;
 	unsigned int first;
 	unsigned int last;
-	unsigned int last_request;
 	unsigned int to_hash_later;
 	unsigned int nbuf;
 	struct scatterlist bufsl[2];
 	struct scatterlist *psrc;
-
-	struct scatterlist request_bufsl[2];
-	struct ahash_request *areq;
-	struct scatterlist *request_sl;
-	unsigned int remaining_ahash_request_bytes;
-	unsigned int current_ahash_request_bytes;
-	struct work_struct sec1_ahash_process_remaining;
 };
 
 struct talitos_export_state {
@@ -1768,20 +1759,7 @@ static void ahash_done(struct device *dev,
 
 	kfree(edesc);
 
-	if (err) {
-		ahash_request_complete(areq, err);
-		return;
-	}
-
-	req_ctx->remaining_ahash_request_bytes -=
-		req_ctx->current_ahash_request_bytes;
-
-	if (!req_ctx->remaining_ahash_request_bytes) {
-		ahash_request_complete(areq, 0);
-		return;
-	}
-
-	schedule_work(&req_ctx->sec1_ahash_process_remaining);
+	ahash_request_complete(areq, err);
 }
 
 /*
@@ -1947,7 +1925,60 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
 				   nbytes, 0, 0, 0, areq->base.flags, false);
 }
 
-static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes)
+static int ahash_init(struct ahash_request *areq)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	unsigned int size;
+	dma_addr_t dma;
+
+	/* Initialize the context */
+	req_ctx->buf_idx = 0;
+	req_ctx->nbuf = 0;
+	req_ctx->first = 1; /* first indicates h/w must init its context */
+	req_ctx->swinit = 0; /* assume h/w init of context */
+	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
+			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
+			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
+	req_ctx->hw_context_size = size;
+
+	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
+			     DMA_TO_DEVICE);
+	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_TO_DEVICE);
+
+	return 0;
+}
+
+/*
+ * on h/w without explicit sha224 support, we initialize h/w context
+ * manually with sha224 constants, and tell it to run sha256.
+ */
+static int ahash_init_sha224_swinit(struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	req_ctx->hw_context[0] = SHA224_H0;
+	req_ctx->hw_context[1] = SHA224_H1;
+	req_ctx->hw_context[2] = SHA224_H2;
+	req_ctx->hw_context[3] = SHA224_H3;
+	req_ctx->hw_context[4] = SHA224_H4;
+	req_ctx->hw_context[5] = SHA224_H5;
+	req_ctx->hw_context[6] = SHA224_H6;
+	req_ctx->hw_context[7] = SHA224_H7;
+
+	/* init 64-bit count */
+	req_ctx->hw_context[8] = 0;
+	req_ctx->hw_context[9] = 0;
+
+	ahash_init(areq);
+	req_ctx->swinit = 1;/* prevent h/w initting context with sha256 values*/
+
+	return 0;
+}
+
+static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
@@ -1966,12 +1997,12 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 
 	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
-		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
+		nents = sg_nents_for_len(areq->src, nbytes);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_copy_to_buffer(req_ctx->request_sl, nents,
+		sg_copy_to_buffer(areq->src, nents,
 				  ctx_buf + req_ctx->nbuf, nbytes);
 		req_ctx->nbuf += nbytes;
 		return 0;
@@ -1998,7 +2029,7 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 		sg_init_table(req_ctx->bufsl, nsg);
 		sg_set_buf(req_ctx->bufsl, ctx_buf, req_ctx->nbuf);
 		if (nsg > 1)
-			sg_chain(req_ctx->bufsl, 2, req_ctx->request_sl);
+			sg_chain(req_ctx->bufsl, 2, areq->src);
 		req_ctx->psrc = req_ctx->bufsl;
 	} else if (is_sec1 && req_ctx->nbuf && req_ctx->nbuf < blocksize) {
 		int offset;
@@ -2007,26 +2038,26 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 			offset = blocksize - req_ctx->nbuf;
 		else
 			offset = nbytes_to_hash - req_ctx->nbuf;
-		nents = sg_nents_for_len(req_ctx->request_sl, offset);
+		nents = sg_nents_for_len(areq->src, offset);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_copy_to_buffer(req_ctx->request_sl, nents,
+		sg_copy_to_buffer(areq->src, nents,
 				  ctx_buf + req_ctx->nbuf, offset);
 		req_ctx->nbuf += offset;
-		req_ctx->psrc = scatterwalk_ffwd(req_ctx->bufsl, req_ctx->request_sl,
+		req_ctx->psrc = scatterwalk_ffwd(req_ctx->bufsl, areq->src,
 						 offset);
 	} else
-		req_ctx->psrc = req_ctx->request_sl;
+		req_ctx->psrc = areq->src;
 
 	if (to_hash_later) {
-		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
+		nents = sg_nents_for_len(areq->src, nbytes);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_pcopy_to_buffer(req_ctx->request_sl, nents,
+		sg_pcopy_to_buffer(areq->src, nents,
 				   req_ctx->buf[(req_ctx->buf_idx + 1) & 1],
 				      to_hash_later,
 				      nbytes - to_hash_later);
@@ -2034,7 +2065,7 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	req_ctx->to_hash_later = to_hash_later;
 
 	/* Allocate extended descriptor */
-	edesc = ahash_edesc_alloc(req_ctx->areq, nbytes_to_hash);
+	edesc = ahash_edesc_alloc(areq, nbytes_to_hash);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -2056,123 +2087,14 @@ static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes
 	if (ctx->keylen && (req_ctx->first || req_ctx->last))
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
 
-	return common_nonsnoop_hash(edesc, req_ctx->areq, nbytes_to_hash, ahash_done);
-}
-
-static void sec1_ahash_process_remaining(struct work_struct *work)
-{
-	struct talitos_ahash_req_ctx *req_ctx =
-		container_of(work, struct talitos_ahash_req_ctx,
-			     sec1_ahash_process_remaining);
-	int err = 0;
-
-	req_ctx->request_sl = scatterwalk_ffwd(req_ctx->request_bufsl,
-					       req_ctx->request_sl, TALITOS1_MAX_DATA_LEN);
-
-	if (req_ctx->remaining_ahash_request_bytes > TALITOS1_MAX_DATA_LEN)
-		req_ctx->current_ahash_request_bytes = TALITOS1_MAX_DATA_LEN;
-	else {
-		req_ctx->current_ahash_request_bytes =
-			req_ctx->remaining_ahash_request_bytes;
-
-		if (req_ctx->last_request)
-			req_ctx->last = 1;
-	}
-
-	err = ahash_process_req_one(req_ctx->areq,
-				    req_ctx->current_ahash_request_bytes);
-
-	if (err != -EINPROGRESS)
-		ahash_request_complete(req_ctx->areq, err);
-}
-
-static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = ctx->dev;
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct talitos_private *priv = dev_get_drvdata(dev);
-	bool is_sec1 = has_ftr_sec1(priv);
-
-	req_ctx->areq = areq;
-	req_ctx->request_sl = areq->src;
-	req_ctx->remaining_ahash_request_bytes = nbytes;
-
-	if (is_sec1) {
-		if (nbytes > TALITOS1_MAX_DATA_LEN)
-			nbytes = TALITOS1_MAX_DATA_LEN;
-		else if (req_ctx->last_request)
-			req_ctx->last = 1;
-	}
-
-	req_ctx->current_ahash_request_bytes = nbytes;
-
-	return ahash_process_req_one(req_ctx->areq,
-				     req_ctx->current_ahash_request_bytes);
-}
-
-static int ahash_init(struct ahash_request *areq)
-{
-	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
-	struct device *dev = ctx->dev;
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	unsigned int size;
-	dma_addr_t dma;
-
-	/* Initialize the context */
-	req_ctx->buf_idx = 0;
-	req_ctx->nbuf = 0;
-	req_ctx->first = 1; /* first indicates h/w must init its context */
-	req_ctx->swinit = 0; /* assume h/w init of context */
-	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
-			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
-			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
-	req_ctx->hw_context_size = size;
-	req_ctx->last_request = 0;
-	req_ctx->last = 0;
-	INIT_WORK(&req_ctx->sec1_ahash_process_remaining, sec1_ahash_process_remaining);
-
-	dma = dma_map_single(dev, req_ctx->hw_context, req_ctx->hw_context_size,
-			     DMA_TO_DEVICE);
-	dma_unmap_single(dev, dma, req_ctx->hw_context_size, DMA_TO_DEVICE);
-
-	return 0;
-}
-
-/*
- * on h/w without explicit sha224 support, we initialize h/w context
- * manually with sha224 constants, and tell it to run sha256.
- */
-static int ahash_init_sha224_swinit(struct ahash_request *areq)
-{
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-
-	req_ctx->hw_context[0] = SHA224_H0;
-	req_ctx->hw_context[1] = SHA224_H1;
-	req_ctx->hw_context[2] = SHA224_H2;
-	req_ctx->hw_context[3] = SHA224_H3;
-	req_ctx->hw_context[4] = SHA224_H4;
-	req_ctx->hw_context[5] = SHA224_H5;
-	req_ctx->hw_context[6] = SHA224_H6;
-	req_ctx->hw_context[7] = SHA224_H7;
-
-	/* init 64-bit count */
-	req_ctx->hw_context[8] = 0;
-	req_ctx->hw_context[9] = 0;
-
-	ahash_init(areq);
-	req_ctx->swinit = 1;/* prevent h/w initting context with sha256 values*/
-
-	return 0;
+	return common_nonsnoop_hash(edesc, areq, nbytes_to_hash, ahash_done);
 }
 
 static int ahash_update(struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	req_ctx->last_request = 0;
+	req_ctx->last = 0;
 
 	return ahash_process_req(areq, areq->nbytes);
 }
@@ -2181,7 +2103,7 @@ static int ahash_final(struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	req_ctx->last_request = 1;
+	req_ctx->last = 1;
 
 	return ahash_process_req(areq, 0);
 }
@@ -2190,7 +2112,7 @@ static int ahash_finup(struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	req_ctx->last_request = 1;
+	req_ctx->last = 1;
 
 	return ahash_process_req(areq, areq->nbytes);
 }
-- 
2.54.0

