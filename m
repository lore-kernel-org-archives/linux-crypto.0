Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF853191A5
	for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 19:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779651967; cv=none; b=sc27RZIM86BQ/QK5xm+cwAl9apGjAQx6o/j0hNy4CSCl5/B+nxDcTFyZPD8FhxABbsox7o9ETcEEUW8nx1Vmj+57xmQMDJoY32fa7pza8CGyywcClL66PZBMDfcwgJAlXG89TdLbhflZuYuqziBYUhaYcvuPPVigb9OCaoy16Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779651967; c=relaxed/simple;
	bh=WIKc2AWfDYUc69JvL1/9qtytzct+TF9XfENjVXjaDWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O2LiVYZLiFqqpZVFk7Len2rOCX2h47o4IhPtqF61VUktwMGopqcx+O6oT5ZKPzJ4D1avNNHrIaRQRBJ1ANSkyq9UfNCm/YygFR7wdzZfEyELNHmukW8+XOxtvkqVVjkTNZ8yUInKeLTNNlbc5fZtr1lhYbEOiYnT6RJ/MEKA9nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=URr+eE6f; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="URr+eE6f"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ba4efedbeaso68028525ad.1
        for <linux-crypto@vger.kernel.org>; Sun, 24 May 2026 12:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779651962; x=1780256762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ao2qyIA2jJ7uaRRfz0Dt0ISPAp8Fb4RgnxFXCHmkExc=;
        b=URr+eE6f0j5ZmAn+SuHtUpKNKt38qDPQS4oblsOXJta8D+z1Wv2HgOrbHu7CscRNCY
         g+QSjdxOfSLT+A5sWaZrgtQ5BVqwRpUcmSQQT/77mPiNThMET2iw4e8430G4t1ZN0GKM
         I+fE2pENuTwXeHkuPav6sIa1us+UvwHQ8duf6xyYVROxprbirJhkjGpLdPRKrqNDDbzQ
         vqoV6yHKSPde/ItBMURNcSU+zcgGP5PiDHq+6/3ef2cFFmAJHS93n0z7n1BzQ+Us6wim
         /EOxH8EeZmwGf06Yc0iCBAs3faeFdvYzweMws6xuFkynxlyOccNVtLERLwFspqjVy+Sp
         hwcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779651962; x=1780256762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ao2qyIA2jJ7uaRRfz0Dt0ISPAp8Fb4RgnxFXCHmkExc=;
        b=dnnHHtpbpb7b/r5PsEKrf0Q/ZSeZXtSx1/UVGotSbq9gZHwlfGiKTVj/42JZVw6T4w
         2wdbhEJA7ACGbmic5Y7Bvgk26p/s33fIbGXAIVEsGd1nHqv2PJ5mPH1pAZimoDVea7eP
         +cpX/8wcccKfaAA2BchO5b6BADlGqh3Pz38T1jouhJnADycWyjkgxIOYIQGL1hdT8PaU
         KjDflO5qdF0CNHLPLhlEGdQDq0IL58LHEJHL3UUgolsYvHj0aF4i11Lswbvm8Z/QIva0
         C1Q+FtQJtXTIBnA+ZhHP4tK9oi8JyFGlgONEvQ3JQH9ZGR8Ur+2MlD1mO2TFsXaJlYAn
         UrBA==
X-Forwarded-Encrypted: i=1; AFNElJ9nH5xEDdOGlB4AAhOrKJzrDpBmgdqsLkrUszFZY6GQ7mXv/FAAqFQ1dEyO4Xyf2osi1VbzUmpXiYV4AZE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzI1JxZGTEhfPyVT+aDB4744+QJPofIa3om3KxHXgamWVKrMrua
	4I1l1y028uC2KOsNrO1F2bmG6ahlMxwageCarhChRIio2R1cCe6amZ42
X-Gm-Gg: Acq92OGAwD9mQvKR6FSruN585X1RjSI/kksoQv15FoIYnQ8W5FydYxh0z/xzJw18WNY
	JEbOlZUFbGDnPe7Kg26y8i5bfHbNZc1SUpRowpKt+uPFnrrPLBW0W+9WvNG8o+U6YZXtZKCas4+
	/fxRxlrttzK+ehH83C6x6ns/zs/gz46OmNJS62dMTMODXzof9+1sB9K+YIUtv8CgYgx36P0H85i
	xaIRZv3l83ig3xNIxOW81GwbHU+z4hK9fg/4QMoAIrBkesIyD8lLspyS6ApPFcGvfmktSy32PIx
	AUGvxxHERgRIg9ont3o1oygtsDY1eCgmELClknucqcYs06zaU94YGu+1/mXckuhrI/zMn207Hmj
	FSxQFQK1j2JqrPEE4kJShliDRgIPLTccCQu0vBT4SqO2WR153HalFakBBqRq7noOmphKuGKMhch
	8TNxjLnXTz9o3iGfYGUJPe4wno
X-Received: by 2002:a17:902:e885:b0:2bc:e62a:979b with SMTP id d9443c01a7336-2beb0699cdemr130695435ad.30.1779651962547;
        Sun, 24 May 2026 12:46:02 -0700 (PDT)
Received: from mincom1 ([125.149.177.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb590aa7esm74414485ad.78.2026.05.24.12.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 12:46:02 -0700 (PDT)
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
Subject: [PATCH 6/6] crypto: eip93: handle request ID exhaustion
Date: Mon, 25 May 2026 04:45:28 +0900
Message-ID: <20260524194528.3666383-7-hurryman2212@gmail.com>
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
index e3bd28cc0c67..0de18a0cbe33 100644
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

