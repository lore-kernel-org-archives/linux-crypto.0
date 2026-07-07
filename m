Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDFA43C7D7
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 17:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783444572; cv=none; b=qb5h+dFHE2EjU0p25iUcnIHytBSJgQ66OhWr4Qzb3u1fMThOZPdvoPE1XNoKkRc/ZjowZeG98JkFYN6DWGMIxwuFujaws1d9VFs4uXzwrlGFhh+kzFwDy5mG+3/f7SLBqIashJJCf0cde4HaGKi2csIv4Mt6aLVsvnGrN2+al1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783444572; c=relaxed/simple;
	bh=wY5J8RATxw25FUFTurlUiRpQPU+ozXAEQbFlgZXFiPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mI9KUngVnemsu+MZ316UUbko42Xgu6LDMLjPAifnIx0NlW/HXbVw0qsBQSf5gAt10esQtOQUdSHocwWJESb++T+sj0TxZL6auBXO3yCCxSRrX/1bFHE6RNeb0gqiQziLRVnvFrjOyv1rvLzamr5ugTI3sQAhjxmFmzoptwb4+Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ILv+nfo4; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ILv+nfo4"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-845ea8924fdso5058315b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 10:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783444570; x=1784049370; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oEDqnCNqibEtTaWsaYV3oyWQSsrfj6nCiEaNarfOWCQ=;
        b=ILv+nfo4GVO78Md018pINMZrFskjYTXxq+Q70E5XlYgC8a+yrVsAmVIrPjMxdMKn86
         b9JCqOHP5n3wG6SkeKdMYiaKbWHK7p0V+lQHLb51IqS06VKGFawKzbkQuVuEGd6LipBO
         Ayax6Uc+dLviZz2ecZdnwX13cGGUkOB4J5Yn4FItMnEhETRVJAjGnRi6iLyaVUWhc8hn
         hFOzfPKrgJikU/SFZIb7nzGAS5phAWWNbAt9bHcQGkyzz7hVQfBbsq+u/ByJG284SRDn
         m0aLv9bDk++W2WxNo3OAx2IgBVcWajUZTweoPVJXG0CpdXn6VB43IleidUjlClu4Wj88
         Xk1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783444570; x=1784049370;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oEDqnCNqibEtTaWsaYV3oyWQSsrfj6nCiEaNarfOWCQ=;
        b=RVZCSVHkYKxR8HVZxoECjMiyR+5tX4J0O67JET4d/xHYYyVMz+ub2K10JLZMd7w0ng
         4Cz7WKgemwVBQa/3qAVLz7FqxGjz9fp03Ah8g2R6UvQ+qnE6W1YsudFKWh4mcfMFu0CL
         sK13HweXH+l99tHbF8BHmpw7DPedBUIN0w5ltWTT3DOz/5ZZ8hhEVAMmjLzgsQuhRkPT
         h0uDisVFsMzGKd3NaDCvZg3eI1dLNPP7eERZC6I9BsWjjXZdNvJpgcLO9YjLygBt9Xha
         Q9EHH9O6c9YFgBNqp04HAq+IFePJ3fEayzZVjtSQiNBtRyiY5JDY637rR9WbWHCsxRZ/
         bVPg==
X-Gm-Message-State: AOJu0YzVlCdSFNkRcdlB8dmVMjDiTipLyH13pIYYMyrssl09/3tiXBIx
	ZRPDLcGoeecv+kBsC5gF/LjT+MqjKRPmmyT6te9AKFVAy3ip7uCOiIIZ
X-Gm-Gg: AfdE7clgZKewpXEebOA2Y+Y3eBwHQvmfZW1WkONlZCZxDrzpe48QCXIp3j5z6RD5glY
	z+vq4NnH+2nKKZ+prbmT5JNg+uszBV1vYze88BL1CgTHu+W/8DtwGbHPuF1dx7DAXmJ3ZZ1a+nj
	tNUsb91k0ddntTGCNsia9onExez8wDmlJo2O+WCSljb9qFykMMNTRdKVSIo1qN9uNDMr5/T0uXF
	aLMDIxGV4ECOoeWdV7coh6mkeoGu6hYUb8hGBljseFWFi/DfOf14S2Rz5+APjPpU5Pm58oK3GR3
	i9mhVS/u5JXVAT8h3kZAPi//G23hRu1p3jiK6N9/v9St38sdBjwhYXmRgFlnLWXixrgmoQWbjsd
	AF/H5fI85NaBzv52YfCdGphVNfZT1BvomB0O1OIwY0bs0FF70XmtE0cnXRqpqrSpqktvJb3aQXT
	HPGTNbfQhj7Wkm
X-Received: by 2002:a05:6a00:6c87:b0:847:949e:ea73 with SMTP id d2e1a72fcca58-84826d99da7mr5586425b3a.50.1783444570151;
        Tue, 07 Jul 2026 10:16:10 -0700 (PDT)
Received: from mincom1 ([175.235.236.90])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b5e566sm5784602b3a.3.2026.07.07.10.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 10:16:09 -0700 (PDT)
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
Subject: [PATCH v2 5/5] crypto: eip93: handle request ID exhaustion
Date: Wed,  8 Jul 2026 02:15:37 +0900
Message-ID: <20260707171537.467608-6-hurryman2212@gmail.com>
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

The driver stores the async request pointer in an IDR and places the ID in
the hardware descriptor. The old allocation used the ring depth as the IDR
limit. It also did not check allocation failure, so request pressure could
encode a negative error value as a descriptor user ID.

Allocate request IDs from the full user ID field range and wait while the
IDR is full. Publish the descriptor only after DMA mappings and ID
allocation have succeeded. Add unwind paths for mappings that are active
when ID allocation fails, and tolerate stale or missing result IDs in the
interrupt handler.

Fixes: 9739f5f93b78 ("crypto: eip93 - Add Inside Secure SafeXcel EIP-93 crypto engine support")
Reported-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Suggested-by: Benjamin Larsson <benjamin.larsson@genexis.eu>
Tested-by: Aleksander Jan Bajkowski <olek2@wp.pl>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Jihong Min <hurryman2212@gmail.com>
---
 .../crypto/inside-secure/eip93/eip93-common.c | 48 +++++++++++++++----
 .../crypto/inside-secure/eip93/eip93-common.h |  3 ++
 .../crypto/inside-secure/eip93/eip93-hash.c   | 26 +++++++---
 .../crypto/inside-secure/eip93/eip93-main.c   |  6 +++
 .../crypto/inside-secure/eip93/eip93-main.h   |  2 +
 5 files changed, 69 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.c b/drivers/crypto/inside-secure/eip93/eip93-common.c
index f422c93748c9..88b89d05d510 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.c
@@ -65,6 +65,31 @@ int eip93_parse_ctrl_stat_err(struct eip93_device *eip93, int err)
 	}
 }
 
+int eip93_alloc_request_id(struct eip93_device *eip93, void *request)
+{
+	int id;
+
+	scoped_guard(spinlock_bh, &eip93->ring->idr_lock)
+		id = idr_alloc(&eip93->ring->crypto_async_idr, request, 0,
+			       EIP93_REQUEST_IDR_LIMIT, GFP_ATOMIC);
+
+	return id;
+}
+
+int eip93_alloc_request_id_wait(struct eip93_device *eip93, void *request)
+{
+	int id;
+
+	for (;;) {
+		id = eip93_alloc_request_id(eip93, request);
+		if (id != -ENOSPC)
+			return id;
+
+		usleep_range(EIP93_RING_BUSY_DELAY,
+			     EIP93_RING_BUSY_DELAY * 2);
+	}
+}
+
 static void *eip93_ring_next_wptr(struct eip93_device *eip93,
 				  struct eip93_desc_ring *ring)
 {
@@ -597,15 +622,6 @@ int eip93_send_req(struct crypto_async_request *async,
 	cdesc.sa_addr = rctx->sa_record_base;
 	cdesc.arc4_addr = 0;
 
-	scoped_guard(spinlock_bh, &eip93->ring->idr_lock)
-		crypto_async_idr = idr_alloc(&eip93->ring->crypto_async_idr, async, 0,
-					     EIP93_RING_NUM - 1, GFP_ATOMIC);
-
-	cdesc.user_id = FIELD_PREP(EIP93_PE_USER_ID_CRYPTO_IDR, (u16)crypto_async_idr) |
-			FIELD_PREP(EIP93_PE_USER_ID_DESC_FLAGS, rctx->desc_flags);
-
-	rctx->cdesc = &cdesc;
-
 	/* map DMA_BIDIRECTIONAL to invalidate cache on destination
 	 * implies __dma_cache_wback_inv
 	 */
@@ -620,8 +636,22 @@ int eip93_send_req(struct crypto_async_request *async,
 		goto free_sg_dma;
 	}
 
+	crypto_async_idr = eip93_alloc_request_id_wait(eip93, async);
+	if (crypto_async_idr < 0) {
+		err = crypto_async_idr;
+		goto free_src_sg_dma;
+	}
+
+	cdesc.user_id = FIELD_PREP(EIP93_PE_USER_ID_CRYPTO_IDR, crypto_async_idr) |
+			FIELD_PREP(EIP93_PE_USER_ID_DESC_FLAGS, rctx->desc_flags);
+
+	rctx->cdesc = &cdesc;
+
 	return eip93_scatter_combine(eip93, rctx, datalen, split, offsetin);
 
+free_src_sg_dma:
+	if (src != dst)
+		dma_unmap_sg(eip93->dev, src, rctx->src_nents, DMA_TO_DEVICE);
 free_sg_dma:
 	dma_unmap_sg(eip93->dev, dst, rctx->dst_nents, DMA_BIDIRECTIONAL);
 free_sa_state_ctr_dma:
diff --git a/drivers/crypto/inside-secure/eip93/eip93-common.h b/drivers/crypto/inside-secure/eip93/eip93-common.h
index 41c43782eb5c..3898962d0abf 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-common.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-common.h
@@ -17,6 +17,9 @@ void eip93_set_sa_record(struct sa_record *sa_record, const unsigned int keylen,
 
 int eip93_parse_ctrl_stat_err(struct eip93_device *eip93, int err);
 
+int eip93_alloc_request_id(struct eip93_device *eip93, void *request);
+int eip93_alloc_request_id_wait(struct eip93_device *eip93, void *request);
+
 int eip93_hmac_setkey(u32 ctx_flags, const u8 *key, unsigned int keylen,
 		      unsigned int hashlen, u8 *ipad, u8 *opad,
 		      bool skip_ipad);
diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
index 060e90c5eaa7..512e0e2ce25e 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
@@ -221,6 +221,7 @@ static int eip93_send_hash_req(struct crypto_async_request *async, u8 *data,
 	struct eip93_device *eip93 = ctx->eip93;
 	struct eip93_descriptor cdesc = { };
 	dma_addr_t src_addr;
+	bool hmac_sa_mapped = false;
 	int ret;
 
 	/* Map block data to DMA */
@@ -258,22 +259,23 @@ static int eip93_send_hash_req(struct crypto_async_request *async, u8 *data,
 				ret = dma_mapping_error(eip93->dev, rctx->sa_record_hmac_base);
 				if (ret) {
 					rctx->sa_record_hmac_base = 0;
-					dma_unmap_single(eip93->dev, src_addr, len,
-							 DMA_TO_DEVICE);
-					return ret;
+					goto unmap_src;
 				}
 
 				cdesc.sa_addr = rctx->sa_record_hmac_base;
+				hmac_sa_mapped = true;
 			}
 
 			cdesc.pe_ctrl_stat_word |= EIP93_PE_CTRL_PE_HASH_FINAL;
 		}
 
-		scoped_guard(spinlock_bh, &eip93->ring->idr_lock)
-			crypto_async_idr = idr_alloc(&eip93->ring->crypto_async_idr, async, 0,
-						     EIP93_RING_NUM - 1, GFP_ATOMIC);
+		crypto_async_idr = eip93_alloc_request_id_wait(eip93, async);
+		if (crypto_async_idr < 0) {
+			ret = crypto_async_idr;
+			goto unmap_hmac_sa;
+		}
 
-		cdesc.user_id |= FIELD_PREP(EIP93_PE_USER_ID_CRYPTO_IDR, (u16)crypto_async_idr) |
+		cdesc.user_id |= FIELD_PREP(EIP93_PE_USER_ID_CRYPTO_IDR, crypto_async_idr) |
 				 FIELD_PREP(EIP93_PE_USER_ID_DESC_FLAGS, EIP93_DESC_LAST);
 	}
 
@@ -291,6 +293,16 @@ static int eip93_send_hash_req(struct crypto_async_request *async, u8 *data,
 
 	*data_dma = src_addr;
 	return 0;
+
+unmap_hmac_sa:
+	if (hmac_sa_mapped) {
+		dma_unmap_single(eip93->dev, rctx->sa_record_hmac_base,
+				 sizeof(rctx->sa_record_hmac), DMA_TO_DEVICE);
+		rctx->sa_record_hmac_base = 0;
+	}
+unmap_src:
+	dma_unmap_single(eip93->dev, src_addr, len, DMA_TO_DEVICE);
+	return ret;
 }
 
 static int eip93_hash_init(struct ahash_request *req)
diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.c b/drivers/crypto/inside-secure/eip93/eip93-main.c
index eee5fd8f9e96..a412a5ffe8b4 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.c
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.c
@@ -257,6 +257,12 @@ static void eip93_handle_result_descriptor(struct eip93_device *eip93)
 		idr_remove(&eip93->ring->crypto_async_idr, crypto_idr);
 	}
 
+	if (!async) {
+		dev_warn_ratelimited(eip93->dev, "missing request id %u\n",
+				     crypto_idr);
+		goto get_more;
+	}
+
 	/* Parse error in ctrl stat word */
 	err = eip93_parse_ctrl_stat_err(eip93, err);
 
diff --git a/drivers/crypto/inside-secure/eip93/eip93-main.h b/drivers/crypto/inside-secure/eip93/eip93-main.h
index 990c2401b7ce..5237b75bba62 100644
--- a/drivers/crypto/inside-secure/eip93/eip93-main.h
+++ b/drivers/crypto/inside-secure/eip93/eip93-main.h
@@ -13,11 +13,13 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/bitfield.h>
 #include <linux/interrupt.h>
+#include <linux/limits.h>
 
 #define EIP93_RING_BUSY_DELAY		500
 
 #define EIP93_RING_NUM			512
 #define EIP93_RING_BUSY			32
+#define EIP93_REQUEST_IDR_LIMIT		(U16_MAX + 1)
 #define EIP93_CRA_PRIORITY		1500
 
 #define EIP93_RING_SA_STATE_ADDR(base, idx)	((base) + (idx))
-- 
2.53.0

