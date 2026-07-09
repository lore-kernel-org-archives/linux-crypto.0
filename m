Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5173C2799
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 19:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783625409; cv=none; b=qaavyMkBzUdx/W6zBQhVAxmLhtfFa5XiK0vDoOysebOvSQOOh3usY0ushE3GSbWUCigmq6/zeqfLym9SYTAp+Az7RNnj0BTZX3y4KcZykbuu12dTUoSzyBFDxTnKujAT4vky0BU3Et33Ff5AkJSzxUi+PLd9XmGjYB3UXZiZ8qU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783625409; c=relaxed/simple;
	bh=++JTawjAt1d0huWmeelUNtyXKGcXYuOwYQrfPBEaQ5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qQX4QSnkQLOBQUyHZa8tzie98IWIKQ6x453P3FS/kinRbAq7ks1/a2OpfCOt0FjCg20WyjFc2593qGzxvg0o7EGNXLwdBETrJHNKKsmGXbM2Q/plBCv7W+PhZQWkw3sY/IIhDXQiHuXq8ty51KZ+Zu3g4so2JDwB5ayHCI3WDuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oYhWN1eJ; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oYhWN1eJ"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4629051c9d1so154954f8f.2
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2026 12:30:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783625405; x=1784230205; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tSBqdtjzORVJfxfZYpeMYer5/81yiMZAIDvIw0ufSuE=;
        b=oYhWN1eJuXAFCI/vB7hsZuPiGQcS9QDrKboNpPR84mvh790LuB9LXyu7VJcd80daSy
         i8cjccJK/lBJzqDFAstoxCEw06oPWjvA5MHWIxBUwuGPGWNE0u1byoa8FmTadBOqCnP/
         z80mip7YP2D6b2H/wK4QhHCqyLWnfNDIHIZCOyjAmmgKZ5tfuthVQ8j2cCqC1i6rRgHW
         3lZZ4SbMUcrz/Qc1Wmret36sLgdMkAnhOH0PPaIoVALY0ZjxrgQWbLEPwqhqcahJ/0Kv
         +7n78uWP4NYt6TjsSjMJTwgexzBEe/y3tjdGj7FQLW93ce/g6qTLpIsiujJ4pjLqoLiI
         8A0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783625405; x=1784230205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tSBqdtjzORVJfxfZYpeMYer5/81yiMZAIDvIw0ufSuE=;
        b=eZrHbVE+bFR/ciLKfGuty2qn+AKd135ynhZ1cZU+QJ3e5MBp0EdLrXwmvE+O/a1p8K
         Dy9v4CMI78q+miGJoEQlBeuGoDMCKyM+sNE8uueOdpE8QSc3vt6XXsSHBrLK+Ixf4JvY
         x33vK0VjHYmAgUA1bRi7h3CaA0zGpth/dvfody2EEbN+kqrwkG8kS9T/75yVoNMy8UP2
         IDHT1cEb1YV9ER+1RPSS3cMefJ2mZ1x1BU4f3vhCr05B7nEqksFwo+TuS+5jKUMhE4zk
         70Ny9DOP5sG9muP8rnIaanK9cPyg2G45t64sBSj9OiV3zUJ/bSsG0tDR6PUOzo91mpzG
         KPkw==
X-Forwarded-Encrypted: i=1; AHgh+RpFXFBl59yTqiF4v5+lQ8K7qNDitGxFs/hNEWdex23X0vBJloKOXILCwpck+SqOs3qVzKRWlCjNQskd8p0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDHrymyFfvlIuFDA1+kHYvR1c7bxTKsg3IYfBQCaaa3F7R1mWk
	pjFxM7jK+oCCUDHj+2HWH5QBS6NmfScK06XHNNZmyi8HBC5KI6iuqjsG
X-Gm-Gg: AfdE7cn0cCOcLfryJqLOeOJWU+66ndW6OYtujg0+CWTynfvQHATSZZsKCG64wxwrzYx
	owYlqh0sOve0C3lNGKjXd47JhpTuvedCSIzRZS6Dd0Dgi5e034nTzV4e9BVQQgJX8OHchG9APkz
	1sdpwDeThdiLcu1Q2KHCQi6RgU8rfvFfQq1IarOLiSXD6zzurAZq2pvqeKZEb9XL8IFXgfPo6C5
	2NFHoGCyHu9GhVTpaxOXeJsxpsfJAVN/TshrKNuyQpIYMHL0N9S7SFDLkZR79Vi+/kbYLqvSdMR
	StE0+Tj8jvzfJtKpatZ/PErSSsQ12Jr+CgNcvN2HDRk2ZBVrtlFdY32LOUuDd00bpIeXtNuFNZb
	RJDwRGjs68eVL2URvmuasCEP/+nGHsIDiMqWmuaETLGGCPbZtbcx4ht5n4uq2JLShqvqJV785A7
	03ucvrkP6nR7SJ6aTnRosu9QXX
X-Received: by 2002:a05:6000:186e:b0:460:1a36:deac with SMTP id ffacd0b85a97d-47df07bbe7bmr8708297f8f.24.1783625404977;
        Thu, 09 Jul 2026 12:30:04 -0700 (PDT)
Received: from mini.main.internal ([2a02:908:c211:cd18:d9f3:ab2b:ac6e:fc84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e6ccsm53873509f8f.5.2026.07.09.12.30.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 12:30:04 -0700 (PDT)
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
Subject: [PATCH 4/5] crypto: talitos - fix SEC1 32k ahash request limitation
Date: Thu,  9 Jul 2026 21:28:25 +0200
Message-ID: <20260709192826.12699-5-ggoerisch@gmail.com>
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

From: Paul Louvel <paul.louvel@bootlin.com>

commit 655ef638a2bc3cd0a9eff99a02f83cab94a3a917 upstream.

Since commit c662b043cdca ("crypto: af_alg/hash: Support
MSG_SPLICE_PAGES"), the crypto core may pass large scatterlists spanning
multiple pages to drivers supporting ahash operations. As a result, a
driver can now receive large ahash requests.

The SEC1 engine has a limitation where a single descriptor cannot
process more than 32k of data. The current implementation attempts to
handle the entire request within a single descriptor, which leads to
failures raised by the driver:

  "length exceeds h/w max limit"

Address this limitation by splitting large ahash requests into multiple
descriptors, each respecting the 32k hardware limit. This allows
processing arbitrarily large requests.

Cc: stable@vger.kernel.org
Fixes: c662b043cdca ("crypto: af_alg/hash: Support MSG_SPLICE_PAGES")
Signed-off-by: Paul Louvel <paul.louvel@bootlin.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/talitos.c | 216 ++++++++++++++++++++++++++-------------
 1 file changed, 147 insertions(+), 69 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index a941ec08817e..ea6ae72c71ad 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -12,6 +12,7 @@
  * All rights reserved.
  */
 
+#include <linux/workqueue.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
@@ -870,10 +871,18 @@ struct talitos_ahash_req_ctx {
 	unsigned int swinit;
 	unsigned int first;
 	unsigned int last;
+	unsigned int last_request;
 	unsigned int to_hash_later;
 	unsigned int nbuf;
 	struct scatterlist bufsl[2];
 	struct scatterlist *psrc;
+
+	struct scatterlist request_bufsl[2];
+	struct ahash_request *areq;
+	struct scatterlist *request_sl;
+	unsigned int remaining_ahash_request_bytes;
+	unsigned int current_ahash_request_bytes;
+	struct work_struct sec1_ahash_process_remaining;
 };
 
 struct talitos_export_state {
@@ -1759,7 +1768,20 @@ static void ahash_done(struct device *dev,
 
 	kfree(edesc);
 
-	ahash_request_complete(areq, err);
+	if (err) {
+		ahash_request_complete(areq, err);
+		return;
+	}
+
+	req_ctx->remaining_ahash_request_bytes -=
+		req_ctx->current_ahash_request_bytes;
+
+	if (!req_ctx->remaining_ahash_request_bytes) {
+		ahash_request_complete(areq, 0);
+		return;
+	}
+
+	schedule_work(&req_ctx->sec1_ahash_process_remaining);
 }
 
 /*
@@ -1925,60 +1947,7 @@ static struct talitos_edesc *ahash_edesc_alloc(struct ahash_request *areq,
 				   nbytes, 0, 0, 0, areq->base.flags, false);
 }
 
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
-}
-
-static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
+static int ahash_process_req_one(struct ahash_request *areq, unsigned int nbytes)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
@@ -1997,12 +1966,12 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 
 	if (!req_ctx->last && (nbytes + req_ctx->nbuf <= blocksize)) {
 		/* Buffer up to one whole block */
-		nents = sg_nents_for_len(areq->src, nbytes);
+		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_copy_to_buffer(areq->src, nents,
+		sg_copy_to_buffer(req_ctx->request_sl, nents,
 				  ctx_buf + req_ctx->nbuf, nbytes);
 		req_ctx->nbuf += nbytes;
 		return 0;
@@ -2029,7 +1998,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 		sg_init_table(req_ctx->bufsl, nsg);
 		sg_set_buf(req_ctx->bufsl, ctx_buf, req_ctx->nbuf);
 		if (nsg > 1)
-			sg_chain(req_ctx->bufsl, 2, areq->src);
+			sg_chain(req_ctx->bufsl, 2, req_ctx->request_sl);
 		req_ctx->psrc = req_ctx->bufsl;
 	} else if (is_sec1 && req_ctx->nbuf && req_ctx->nbuf < blocksize) {
 		int offset;
@@ -2038,26 +2007,26 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 			offset = blocksize - req_ctx->nbuf;
 		else
 			offset = nbytes_to_hash - req_ctx->nbuf;
-		nents = sg_nents_for_len(areq->src, offset);
+		nents = sg_nents_for_len(req_ctx->request_sl, offset);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_copy_to_buffer(areq->src, nents,
+		sg_copy_to_buffer(req_ctx->request_sl, nents,
 				  ctx_buf + req_ctx->nbuf, offset);
 		req_ctx->nbuf += offset;
-		req_ctx->psrc = scatterwalk_ffwd(req_ctx->bufsl, areq->src,
+		req_ctx->psrc = scatterwalk_ffwd(req_ctx->bufsl, req_ctx->request_sl,
 						 offset);
 	} else
-		req_ctx->psrc = areq->src;
+		req_ctx->psrc = req_ctx->request_sl;
 
 	if (to_hash_later) {
-		nents = sg_nents_for_len(areq->src, nbytes);
+		nents = sg_nents_for_len(req_ctx->request_sl, nbytes);
 		if (nents < 0) {
 			dev_err(dev, "Invalid number of src SG.\n");
 			return nents;
 		}
-		sg_pcopy_to_buffer(areq->src, nents,
+		sg_pcopy_to_buffer(req_ctx->request_sl, nents,
 				   req_ctx->buf[(req_ctx->buf_idx + 1) & 1],
 				      to_hash_later,
 				      nbytes - to_hash_later);
@@ -2065,7 +2034,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	req_ctx->to_hash_later = to_hash_later;
 
 	/* Allocate extended descriptor */
-	edesc = ahash_edesc_alloc(areq, nbytes_to_hash);
+	edesc = ahash_edesc_alloc(req_ctx->areq, nbytes_to_hash);
 	if (IS_ERR(edesc))
 		return PTR_ERR(edesc);
 
@@ -2087,14 +2056,123 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 	if (ctx->keylen && (req_ctx->first || req_ctx->last))
 		edesc->desc.hdr |= DESC_HDR_MODE0_MDEU_HMAC;
 
-	return common_nonsnoop_hash(edesc, areq, nbytes_to_hash, ahash_done);
+	return common_nonsnoop_hash(edesc, req_ctx->areq, nbytes_to_hash, ahash_done);
 }
 
-static int ahash_update(struct ahash_request *areq)
+static void sec1_ahash_process_remaining(struct work_struct *work)
+{
+	struct talitos_ahash_req_ctx *req_ctx =
+		container_of(work, struct talitos_ahash_req_ctx,
+			     sec1_ahash_process_remaining);
+	int err = 0;
+
+	req_ctx->request_sl = scatterwalk_ffwd(req_ctx->request_bufsl,
+					       req_ctx->request_sl, TALITOS1_MAX_DATA_LEN);
+
+	if (req_ctx->remaining_ahash_request_bytes > TALITOS1_MAX_DATA_LEN)
+		req_ctx->current_ahash_request_bytes = TALITOS1_MAX_DATA_LEN;
+	else {
+		req_ctx->current_ahash_request_bytes =
+			req_ctx->remaining_ahash_request_bytes;
+
+		if (req_ctx->last_request)
+			req_ctx->last = 1;
+	}
+
+	err = ahash_process_req_one(req_ctx->areq,
+				    req_ctx->current_ahash_request_bytes);
+
+	if (err != -EINPROGRESS)
+		ahash_request_complete(req_ctx->areq, err);
+}
+
+static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	struct talitos_private *priv = dev_get_drvdata(dev);
+	bool is_sec1 = has_ftr_sec1(priv);
+
+	req_ctx->areq = areq;
+	req_ctx->request_sl = areq->src;
+	req_ctx->remaining_ahash_request_bytes = nbytes;
+
+	if (is_sec1) {
+		if (nbytes > TALITOS1_MAX_DATA_LEN)
+			nbytes = TALITOS1_MAX_DATA_LEN;
+		else if (req_ctx->last_request)
+			req_ctx->last = 1;
+	}
+
+	req_ctx->current_ahash_request_bytes = nbytes;
+
+	return ahash_process_req_one(req_ctx->areq,
+				     req_ctx->current_ahash_request_bytes);
+}
+
+static int ahash_init(struct ahash_request *areq)
 {
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct talitos_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct device *dev = ctx->dev;
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+	unsigned int size;
+	dma_addr_t dma;
 
+	/* Initialize the context */
+	req_ctx->buf_idx = 0;
+	req_ctx->nbuf = 0;
+	req_ctx->first = 1; /* first indicates h/w must init its context */
+	req_ctx->swinit = 0; /* assume h/w init of context */
+	size =	(crypto_ahash_digestsize(tfm) <= SHA256_DIGEST_SIZE)
+			? TALITOS_MDEU_CONTEXT_SIZE_MD5_SHA1_SHA256
+			: TALITOS_MDEU_CONTEXT_SIZE_SHA384_SHA512;
+	req_ctx->hw_context_size = size;
+	req_ctx->last_request = 0;
 	req_ctx->last = 0;
+	INIT_WORK(&req_ctx->sec1_ahash_process_remaining, sec1_ahash_process_remaining);
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
+static int ahash_update(struct ahash_request *areq)
+{
+	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
+
+	req_ctx->last_request = 0;
 
 	return ahash_process_req(areq, areq->nbytes);
 }
@@ -2103,7 +2181,7 @@ static int ahash_final(struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	req_ctx->last = 1;
+	req_ctx->last_request = 1;
 
 	return ahash_process_req(areq, 0);
 }
@@ -2112,7 +2190,7 @@ static int ahash_finup(struct ahash_request *areq)
 {
 	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
 
-	req_ctx->last = 1;
+	req_ctx->last_request = 1;
 
 	return ahash_process_req(areq, areq->nbytes);
 }
-- 
2.54.0

