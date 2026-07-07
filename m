Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12268438493
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 17:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783444562; cv=none; b=DYycvcAgDnGPiTiQV8EK2TxK/FcFNkt7HKwmDz0XrQNvPCBL3rVzy8BwVH8rDwD+mpPAmOmjpYxOj8ohtioyvNW0b2XSXrM6Bd9amKTsftBUAw0E7VyomifR4OxpVqZclFb05qp0PUiMHgJDZY3pUrb4v4SzJFxPp8jW5ZHwA3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783444562; c=relaxed/simple;
	bh=4qw6UdagDB5Rg+pUwsg3VZ0z5i6gd9nT+MgXaEkbUrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvYrYOKO6mp28p/NavyjZoEwJ2UUlcQ0vQhkGlnUMvcyZi/4FSRNONVcLyJnyXpiXuq94rfJkNxdBxFLbVLj4k0BVFQ4aXC1zEZFQ+3nq5vyFYRHjs1XL99X7nDq3W3luT3dt8BC3WEWa9bqq/bnKbriHpOtQGR6dSQMwhiOpsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fYUa1wgr; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fYUa1wgr"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-847921eed4aso6065156b3a.3
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 10:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783444560; x=1784049360; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=upvkT7BOTIVikHvpyUtlt+ZS5mn49ZMriQt2QIdU8EA=;
        b=fYUa1wgrT8FW6g7j407dt4L9js3j0os4C9EGhyBK7DKZJHEs2j3zhn+kTlkTJXg3+8
         gWe6vmgYG1UyNpb8oFYV4Ik23QZ2MNcxZCu9QB3wrkmYbs7vF5E03TKCdw76nXSosfh/
         0asP7KeovcDI6gLJOyUkP5BxRviemVsZHL+61C0dOr9gRxFUZyHt9nUKwu5jz79ZAkAC
         o5YNwXQRZqJGG4TQNCgnsjBLAa1Cpq93a6wjR2wOqqtOFkH7/tM6KxHwaxNxR9nybQkQ
         JEXAXjedEs8IVNS9/Ab5N16pqMoaFw4Yc+cDqAudBzLDerKvte8ZoK1h/x6jBKxLvLtM
         XpxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783444560; x=1784049360;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=upvkT7BOTIVikHvpyUtlt+ZS5mn49ZMriQt2QIdU8EA=;
        b=mXBj36Xxp5jKVnCSI0gRRFnlPaH6uZ+45wNT3JLTY3lPGbW+mGPPcV1dm5wkN8YFIG
         QFaWJawRvu5xn3JnqoySNiP9tMw7GC2HNG7+ZSL6lpyvS9EBy/20Xr+4ACZpbzMkeBTv
         TBPCOy56DN30WCQaX6XiQiC7SNEibCIQgjYbSrHcslNuHvAUv7s38TUlpsDVLANLncYX
         pKTDnczJtjrs3W1oF+mt7sjscL9abCXoSzgbOYez/omrA/veBL230YPCRM47VuR8lS32
         ecvMOY9amIvCH5/pqTfUXcTKl8xiWw7a5KI1UqdKYa8GxTdwS11VQs2PvnBCKRzJqu7y
         KZOg==
X-Gm-Message-State: AOJu0Yx+/iAWt7u8pFJ8eMCcBW0ve5xv4U9otTSa+o+HGyRK3u6aWMmo
	f/MCV3ZpaADkw1X7m86OZfpIudfDj7N88e+AYrlg0HPrpJ4v7rg2OZtB
X-Gm-Gg: AfdE7cmoU6ZHTA3OwvIoIQR3Btq1mA95SoOirGr6zUKSdKu7Dv17Zz5vgOny1fT3DOS
	JhXQfCrYoO+Vfk2hgqWdmdp2SCesAVmO9hu/0w3gypsFtNZAzVQKrm42LT7yYJ1hObEDVeA721U
	gY7j0MIEnl77shWl4T1hd8t/Gfw1/e7KtvLjz4/eQNlglxJ7q3STQeXeVK4uXxINVoHSDMWDLSu
	Ng15y5sCf5Zv8yZbNsFOLlXto7i6IiQgiYPRe/Lmw1gbPczl3WoAWZEINx4k9/bJ5C2B8kQ3t6w
	dXj3gDsr7F1OXCRRairwrhdGYrFqnWRqkAqCiFpvARsgFrjdbhboo8EX3eCru1Qv9Dmo6ie8RTt
	4ja8b6W9Fm06vGBM3nas/likz6N2dUiCn4JxcBVRqruQvdpBQHwmSB2o9cxAXRU/UuStpqAjUMG
	RdpVrjsT3UaP73
X-Received: by 2002:a05:6a00:2d09:b0:847:8b11:5966 with SMTP id d2e1a72fcca58-84826c1df53mr5910658b3a.1.1783444560009;
        Tue, 07 Jul 2026 10:16:00 -0700 (PDT)
Received: from mincom1 ([175.235.236.90])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b5e566sm5784602b3a.3.2026.07.07.10.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 10:15:59 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Antoine Tenart <atenart@kernel.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Richard van Schagen <vschagen@icloud.com>,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH v2 1/5] crypto: eip93: guard DMA cleanup on uninitialized mappings
Date: Wed,  8 Jul 2026 02:15:33 +0900
Message-ID: <20260707171537.467608-2-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707171537.467608-1-hurryman2212@gmail.com>
References: <20260707171537.467608-1-hurryman2212@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several error paths can reach cleanup before all DMA addresses have been
initialized or mapped. Initialize request DMA handles and check them before
cleanup so the driver does not unmap zero or stale addresses.

If mapping the temporary HMAC SA record fails, also release the block data
DMA mapping that was already active.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Reported-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Originally-by: Mieczyslaw Nalewaj <namiltd@yahoo.com>
Suggested-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 .../crypto/inside-secure/eip93/eip93-common.c |  8 ++-
 .../crypto/inside-secure/eip93/eip93-hash.c   | 54 ++++++++++++-------
 2 files changed, 41 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
index 4c163d7281b3..ed46730c36bc 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
@@ -527,6 +527,8 @@ int eip93_send_req(struct crypto_async_request *async,
 
 	rctx->sa_state_ctr = NULL;
 	rctx->sa_state = NULL;
+	rctx->sa_state_ctr_base = 0;
+	rctx->sa_state_base = 0;
 
 	if (IS_ECB(flags))
 		goto skip_iv;
@@ -534,8 +536,10 @@ int eip93_send_req(struct crypto_async_request *async,
 	memcpy(iv, reqiv, rctx->ivsize);
 
 	rctx->sa_state = kzalloc(sizeof(*rctx->sa_state), GFP_KERNEL);
-	if (!rctx->sa_state)
-		return -ENOMEM;
+	if (!rctx->sa_state) {
+		err = -ENOMEM;
+		goto free_sa_state;
+	}
 
 	sa_state = rctx->sa_state;
 
diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
index 84d3ff2d3836..63bb6c4670cb 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
@@ -34,7 +34,7 @@ static void eip93_hash_free_data_blocks(struct ahash_request *req)
 	if (!list_empty(&rctx->blocks))
 		INIT_LIST_HEAD(&rctx->blocks);
 
-	if (rctx->finalize)
+	if (rctx->finalize && rctx->data_dma)
 		dma_unmap_single(eip93->dev, rctx->data_dma,
 				 rctx->data_used,
 				 DMA_TO_DEVICE);
@@ -47,12 +47,13 @@ static void eip93_hash_free_sa_record(struct ahash_request *req)
 	struct eip93_hash_ctx *ctx = crypto_ahash_ctx(ahash);
 	struct eip93_device *eip93 = ctx->eip93;
 
-	if (IS_HMAC(ctx->flags))
+	if (IS_HMAC(ctx->flags) && rctx->sa_record_hmac_base)
 		dma_unmap_single(eip93->dev, rctx->sa_record_hmac_base,
 				 sizeof(rctx->sa_record_hmac), DMA_TO_DEVICE);
 
-	dma_unmap_single(eip93->dev, rctx->sa_record_base,
-			 sizeof(rctx->sa_record), DMA_TO_DEVICE);
+	if (rctx->sa_record_base)
+		dma_unmap_single(eip93->dev, rctx->sa_record_base,
+				 sizeof(rctx->sa_record), DMA_TO_DEVICE);
 }
 
 void eip93_hash_handle_result(struct crypto_async_request *async, int err)
@@ -66,8 +67,9 @@ void eip93_hash_handle_result(struct crypto_async_request *async, int err)
 	struct eip93_device *eip93 = ctx->eip93;
 	int i;
 
-	dma_unmap_single(eip93->dev, rctx->sa_state_base,
-			 sizeof(*sa_state), DMA_FROM_DEVICE);
+	if (rctx->sa_state_base)
+		dma_unmap_single(eip93->dev, rctx->sa_state_base,
+				 sizeof(*sa_state), DMA_FROM_DEVICE);
 
 	/*
 	 * With partial_hash assume SHA256_DIGEST_SIZE buffer is passed.
@@ -200,6 +202,10 @@ static void __eip93_hash_init(struct ahash_request *req)
 
 	rctx->len = 0;
 	rctx->data_used = 0;
+	rctx->sa_record_base = 0;
+	rctx->sa_state_base = 0;
+	rctx->sa_record_hmac_base = 0;
+	rctx->data_dma = 0;
 	rctx->partial_hash = false;
 	rctx->finalize = false;
 	INIT_LIST_HEAD(&rctx->blocks);
@@ -250,8 +256,12 @@ static int eip93_send_hash_req(struct crypto_async_request *async, u8 *data,
 									   sizeof(*sa_record_hmac),
 									   DMA_TO_DEVICE);
 				ret = dma_mapping_error(eip93->dev, rctx->sa_record_hmac_base);
-				if (ret)
+				if (ret) {
+					rctx->sa_record_hmac_base = 0;
+					dma_unmap_single(eip93->dev, src_addr, len,
+							 DMA_TO_DEVICE);
 					return ret;
+				}
 
 				cdesc.sa_addr = rctx->sa_record_hmac_base;
 			}
@@ -420,12 +430,14 @@ static int eip93_hash_update(struct ahash_request *req)
 	return ret;
 
 free_sa_record:
-	dma_unmap_single(eip93->dev, rctx->sa_record_base,
-			 sizeof(*sa_record), DMA_TO_DEVICE);
+	if (rctx->sa_record_base)
+		dma_unmap_single(eip93->dev, rctx->sa_record_base,
+				 sizeof(*sa_record), DMA_TO_DEVICE);
 
 free_sa_state:
-	dma_unmap_single(eip93->dev, rctx->sa_state_base,
-			 sizeof(*sa_state), DMA_TO_DEVICE);
+	if (rctx->sa_state_base)
+		dma_unmap_single(eip93->dev, rctx->sa_state_base,
+				 sizeof(*sa_state), DMA_TO_DEVICE);
 
 	return ret;
 }
@@ -501,12 +513,14 @@ static int __eip93_hash_final(struct ahash_request *req, bool map_dma)
 free_blocks:
 	eip93_hash_free_data_blocks(req);
 
-	dma_unmap_single(eip93->dev, rctx->sa_record_base,
-			 sizeof(*sa_record), DMA_TO_DEVICE);
+	if (rctx->sa_record_base)
+		dma_unmap_single(eip93->dev, rctx->sa_record_base,
+				 sizeof(*sa_record), DMA_TO_DEVICE);
 
 free_sa_state:
-	dma_unmap_single(eip93->dev, rctx->sa_state_base,
-			 sizeof(*sa_state), DMA_TO_DEVICE);
+	if (rctx->sa_state_base)
+		dma_unmap_single(eip93->dev, rctx->sa_state_base,
+				 sizeof(*sa_state), DMA_TO_DEVICE);
 
 	return ret;
 }
@@ -549,11 +563,13 @@ static int eip93_hash_finup(struct ahash_request *req)
 	return __eip93_hash_final(req, false);
 
 free_sa_record:
-	dma_unmap_single(eip93->dev, rctx->sa_record_base,
-			 sizeof(*sa_record), DMA_TO_DEVICE);
+	if (rctx->sa_record_base)
+		dma_unmap_single(eip93->dev, rctx->sa_record_base,
+				 sizeof(*sa_record), DMA_TO_DEVICE);
 free_sa_state:
-	dma_unmap_single(eip93->dev, rctx->sa_state_base,
-			 sizeof(*sa_state), DMA_TO_DEVICE);
+	if (rctx->sa_state_base)
+		dma_unmap_single(eip93->dev, rctx->sa_state_base,
+				 sizeof(*sa_state), DMA_TO_DEVICE);
 
 	return ret;
 }
-- 
2.53.0

