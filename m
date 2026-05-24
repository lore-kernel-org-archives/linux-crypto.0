Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501E21CD1E4
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 19:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779651954; cv=none; b=gHdZAGlbMLCrcQ5xiRe5/m2ftMp5L1Oki/sroGhfecIN8EX5z6hbpzpvVP44LW0TxzQmClIBScgCjqLXq+YmyaE8PdunT2rirjlR5y+ufqp6Yld7EUvXwoztQu7h7CvENFPAfKEuDWr22RQdJPvJ63Qq9BxMlw9dgUOrpE9oKKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779651954; c=relaxed/simple;
	bh=4qw6UdagDB5Rg+pUwsg3VZ0z5i6gd9nT+MgXaEkbUrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hUZEpwhhnrVwCS+NffIgGcgj8uiOK8I7wIuIIGP/nJ0T426LzRdXuGVb14L6cPEnyl/qN9JZJCDE72BSKEFU/a9bJ9dHRH/87S43dmqPSmPM2j/t2qOlPLF9QUxVsLQbi5aAwvWQyHqtfspBS+dh6qb+m7UMoqjc8+vYl7AEahs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yzlo5mW+; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yzlo5mW+"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ba17c8cfacso94296425ad.2
        for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 12:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779651951; x=1780256751; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=upvkT7BOTIVikHvpyUtlt+ZS5mn49ZMriQt2QIdU8EA=;
        b=Yzlo5mW+5FH8BD+LFnmSvrr6xDozUmMaBGTGvOcmbYFZbgRJiB1ZEtXeIe2SG+eQra
         ZQ0QgExWkbOtQcS8BeANEc2fRFnhT7bJ+lnlQ/Ez5uC98GXPFjxk+ED2euva9QDzIjD7
         psd7Z0axbudpetd4WIjdXGzfyXlnFwqFWj5XdHwnNvXjabz7j3sJSpbfVZCcg7PQt1Yf
         8pFxhJvw0jGoSXCAX8mzlTV13FbcS9/1SAcv/f7zr0Br9nYKJkrraIeKANbcFgWFuUDd
         F1uUkGZSPbknCgG+wb8KX/5EAXIxiUq4Ea4yPDkK1qBmKyfU0vNUgjmcI8TsG6K8iTvO
         VAYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779651951; x=1780256751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=upvkT7BOTIVikHvpyUtlt+ZS5mn49ZMriQt2QIdU8EA=;
        b=dGH9mnuUogxVk2lywDJXjfMrwrN/4BG97nA8c3zr7oD19xH/EEbJ059MfrG2CpjJ8T
         ljjon984OB3d5N2gH9q/AGDADGDce0nkOsqCCqKZq0MzRZsicPo+e1xPHO7TDkERA48D
         B4Wii0kdlqy3mgXqrUZa1A+NMlhd3J+d81NFJvtYcFpVZEuq9/b61VdFhEnEw2F1g3fi
         WOUPGTyy+15IWaL8zl0NV5mhjBuI43+jWXbxurXn4PUNd9FUT4u01Vfz4EAcUOMYTvFc
         SD8g9w5jUVwpjVfDrh6d4lkW6JlXdqCxvB1J7Tb9JnUiN8mYyOAwwtLXzkn9s0q87ZaT
         3Rww==
X-Forwarded-Encrypted: i=1; AFNElJ/bBYRI33B9ozFAdisPivYZqJNF5zeZ9qenz4mVMlE/0ev8Vp9ipsX1nCqE0TtsPz8eUllGOt3eATq3otc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyvVr3vvbHT81wu3LkadG1QDconzR7XCxo4+xYgVgpGzwt4UVlw
	EtHzqohclpeesnfbqvxroG5Av8xJkJFZkIV0t3FLGDhP5Eu6rl+NVN7F
X-Gm-Gg: Acq92OGJvEZB1iG3lgMqJY4BMj9Q4QofD/7QGr+HqUFhPV948S8cwmHfvo2quwmjCCz
	p9UgjI58zmS4Ih8vXFIXMC2JpmHZACm84na5NPmLLO/atDNEKzjaIoZ/0hVWp85OK7bGMBIOgPd
	Gd+bLLy8Xrj5IzFrS6zSO67XZRTa4URkbxjsG6ULx1iVfMLkdhF+prRevsfxbe+6Eobga5tKaHV
	/2fR1iwxAbY4/rVlk6Bjb0kDYRdNyq8WYBf/dmyDzWlLpkmBvgICinkxuLDgmXiyD3L4ULNvOo9
	Wzgpi0YAEfUtGfPRUKXWvJ6pX8GNnQBpaF/Wr/oiiFybPSizMOl+w6AdZjBxtDrfNAO8jLXAqaG
	AGY7XQiWEgExzFeBUZggWw9mwm+CcY0Ap6VO5XqZaAC2hM+TI268NO5LAEM5kPqc0K2t+H8Po05
	JJI/Kwj/argeiQtMFzJ3z30fgC
X-Received: by 2002:a17:903:440f:b0:2b0:67a7:5c4b with SMTP id d9443c01a7336-2beb0603fbemr127850575ad.28.1779651950934;
        Sun, 24 May 2026 12:45:50 -0700 (PDT)
Received: from mincom1 ([125.149.177.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb590aa7esm74414485ad.78.2026.05.24.12.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 12:45:50 -0700 (PDT)
From: Jihong Min <hurryman2212@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-kernel@vger.kernel.org,
	Benjamin Larsson <benjamin.larsson@genexis.eu>,
	Mieczyslaw Nalewaj <namiltd@yahoo.com>,
	Aleksander Jan Bajkowski <olek2@wp.pl>,
	Jihong Min <hurryman2212@gmail.com>
Subject: [PATCH 2/6] crypto: eip93: guard DMA cleanup on uninitialized mappings
Date: Mon, 25 May 2026 04:45:24 +0900
Message-ID: <20260524194528.3666383-3-hurryman2212@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260524194528.3666383-1-hurryman2212@gmail.com>
References: <20260524194528.3666383-1-hurryman2212@gmail.com>
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

