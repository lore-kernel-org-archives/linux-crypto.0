Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCDE253F12;
	Thu, 19 Jun 2025 12:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750335863; cv=none; b=G+CGc5jbz+sBv6jXJ2cfDfoISt60jwf882XJ1pyhclj8m4Ts7mXcg44WpgCDw6lhHMMthYmGTT5PDC5PY286bFnWj7qlnWHyyYPpbDIDkWTOJTQM4WchuliLvRqaeyYFELX3ankoF4PXC93cN2khSrdqQnEdm5tPMQagZYMEjc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750335863; c=relaxed/simple;
	bh=SV17SgqAFM/CwgJKb43KYYELjIo00ELjwm2XuaeiHoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtwUV4gksMMLrR33RwL3jkqk6O2UlQH8j4Ga0uqAyv+TS+RPP+r88B0l/a/O33/nJEXAIMLWvJkKvBG9BSLhMqZ1g8NJ7SvWz2PBI0Ak4jaAxlMRhV5fR4pCYNaUbVPIBLPiHs9tVvJ5Mily6YuObQ7AqnMp0Z9ngwnkEVtMlxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=juk6oTfl; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="juk6oTfl"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-606ddbda275so1441991a12.1;
        Thu, 19 Jun 2025 05:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750335860; x=1750940660; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TntJfTNuRfw8H9ywL1n4IQi1UH/CB2DPSoGeEkzsKwc=;
        b=juk6oTflyeNv1BxcBz7hGeXEYz5s1IFneu9Gsxiy+8ZcL7ES53rfrcgBD6PLAcAGkT
         4PSZ2dbqPelZJfu80swBv8gmMN/Y659q6zwLqvFhfxJ1tXxDHx6wt3gUEL6m8luaXmw8
         WtiAEY+cv6CPHhqplPeJ0w1WvfXAp1umTC2LjJxwUjfR+H2rAshWu8CseYaZNnR2c5CA
         6ZirD3ioiiv9Pj87Pu9MVR+ElZskNn3BiAGrPEFYpcn5k+8ha6DWPix7O3TYKr5hBgNu
         F9AFg/CSswVahQe+QjfB5dyL2zEzHf5OxJWXSRGr4SnlQjkmSlfrCOAo3grERhVljt6u
         V5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750335860; x=1750940660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TntJfTNuRfw8H9ywL1n4IQi1UH/CB2DPSoGeEkzsKwc=;
        b=vEjtf7N75ZA06T7XQ1oYHYm7+1bVTKCupFWNpoVu2O8WdMlCXlpYREwROqiVQljE2Y
         Qdabpkjj7RQWpCxKrS1hKaS5WFGi4RH2fmjuFU3Fr7RSuc2sH4po0N4roDtxFDz1hEa1
         lY7CoFU1KUJCZalzXUtP37y5oW14i1ITvPWgee7xvtzqTrv9rLR4AuEbkzfoyMIEdoob
         Zhz+SlNUzqPDrOV8Me0HL7VN9J2bLXIVdxFYzk0r8JHGTIvUj3y20X+Nsiu0dxvMnqZi
         hJYehM2z7I817BE6RddeLZOGebaAf8m3l/PIdFi3DG+tYNkcSQjODqxusX/KLeDubvdC
         bF+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWMpkM1EpRGshoK3VAMNedMpvh9KxuQl28kSXqQe63YFrngeNC5H8FFHYLS8dCUlmXbDXsk9aVArCS9VTJn@vger.kernel.org, AJvYcCX+njOSRTSbwyD2f/z/wl8YHOBWM571Aiyi5u5kmnOVngHd2aR2yHN/r6jrbKl6DNl+1T2wfVbzmKfzy6A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzs7BrWfPFGMily+4sut+f96t3ej2SQ+6846JGM2OJnq9ALIF7p
	LmH26uz0wcy2ZsGtYMCSNv/NSpOmymjGVHQdn7Dbpk+qyzvyn38EWw68
X-Gm-Gg: ASbGncvV+HzXjAIZNpdfFrXs2EJ9pfGgkFdxC0AZi3ZxiBQ2ltDWRaLOKvas8fChBqp
	TnzuUtBZ1C9rnpLfgT1akmInmhkGs/Kjy6EaakItjEFAzKnX3i9CK5aduRhULzzszslfZIqapcz
	dkuQ3UPVRUY5kzt7NoozkFhHz+jhmLxnrn33Aws0JAPcQbocN0kNPsvqvzdteJ9AJhbq/Su9ZsH
	F1iJbJUrsj4L+B445Lq5kVsUU/H5dgg2t1RF3EBocSxHQ5hDBw2pISH4eiXmsRmQ2cJt7WMfbYs
	HxVbNK80mQ1z6QhMxQEYeDuFo2VNUzzmPrd9ymZL0E8PCuuKSj24J/2JlUZo1lHjXkRSPtlwkOr
	Z2aY8YSslInFp9w==
X-Google-Smtp-Source: AGHT+IHwGI3VAdkps/w875TI+PTeKjZsVrfn6fAKJdMQGXVhrfDL7CIBgagxHkyrj9BPDgk2ITeRzw==
X-Received: by 2002:a17:907:3fa9:b0:ad8:89f8:3f51 with SMTP id a640c23a62f3a-adfad28d0e8mr2120856066b.6.1750335859832;
        Thu, 19 Jun 2025 05:24:19 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae000b02bd3sm504688066b.3.2025.06.19.05.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 05:24:19 -0700 (PDT)
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
Subject: [PATCH 08/10] crypto: sun8i-ce - factor out public versions of finalize request
Date: Thu, 19 Jun 2025 15:23:14 +0300
Message-ID: <20250619122316.2587236-9-ovidiu.panait.oss@gmail.com>
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

Factor out hash and cipher finalize routines so that they can be used in
the next commits during do_batch_requests() callback.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 23 ++++++++++---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 33 ++++++++++++++-----
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h  | 26 +++++++++++++++
 3 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index d206b4fb5084..22b1fe72aa71 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -346,6 +346,24 @@ static void sun8i_ce_cipher_unprepare(struct skcipher_request *areq,
 	dma_unmap_single(ce->dev, rctx->addr_key, op->keylen, DMA_TO_DEVICE);
 }
 
+void sun8i_ce_cipher_finalize_req(struct crypto_async_request *async_req,
+				  struct ce_task *cet, int err)
+{
+	struct skcipher_request *req = skcipher_request_cast(async_req);
+	struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(req);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct sun8i_cipher_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct sun8i_ce_flow *chan;
+
+	chan = &ctx->ce->chanlist[rctx->flow];
+
+	sun8i_ce_cipher_unprepare(req, cet);
+
+	local_bh_disable();
+	crypto_finalize_skcipher_request(chan->engine, req, err);
+	local_bh_enable();
+}
+
 int sun8i_ce_cipher_do_one(struct crypto_engine *engine, void *areq)
 {
 	struct skcipher_request *req = skcipher_request_cast(areq);
@@ -366,11 +384,8 @@ int sun8i_ce_cipher_do_one(struct crypto_engine *engine, void *areq)
 
 	err = sun8i_ce_run_task(ce, rctx->flow,
 				crypto_tfm_alg_name(req->base.tfm));
-	sun8i_ce_cipher_unprepare(req, cet);
 
-	local_bh_disable();
-	crypto_finalize_skcipher_request(engine, req, err);
-	local_bh_enable();
+	sun8i_ce_cipher_finalize_req(areq, cet, err);
 
 	return 0;
 }
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 7811fa17388c..5d8ac1394c0c 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -453,6 +453,29 @@ static void sun8i_ce_hash_unprepare(struct ahash_request *areq,
 	dma_unmap_sg(ce->dev, areq->src, rctx->nr_sgs, DMA_TO_DEVICE);
 }
 
+void sun8i_ce_hash_finalize_req(struct crypto_async_request *async_req,
+				struct ce_task *cet,
+				int err)
+{
+	struct ahash_request *areq = ahash_request_cast(async_req);
+	struct sun8i_ce_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ce_hash_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct sun8i_ce_flow *chan;
+
+	chan = &ctx->ce->chanlist[rctx->flow];
+
+	sun8i_ce_hash_unprepare(areq, cet);
+
+	if (!err)
+		memcpy(areq->result, rctx->result,
+		       crypto_ahash_digestsize(tfm));
+
+	local_bh_disable();
+	crypto_finalize_hash_request(chan->engine, areq, err);
+	local_bh_enable();
+}
+
 int sun8i_ce_hash_run(struct crypto_engine *engine, void *async_req)
 {
 	struct ahash_request *areq = ahash_request_cast(async_req);
@@ -473,15 +496,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *async_req)
 
 	err = sun8i_ce_run_task(ce, rctx->flow, crypto_ahash_alg_name(tfm));
 
-	sun8i_ce_hash_unprepare(areq, cet);
-
-	if (!err)
-		memcpy(areq->result, rctx->result,
-		       crypto_ahash_digestsize(tfm));
-
-	local_bh_disable();
-	crypto_finalize_hash_request(engine, async_req, err);
-	local_bh_enable();
+	sun8i_ce_hash_finalize_req(async_req, cet, err);
 
 	return 0;
 }
diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
index 90b955787d37..1022fd590256 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce.h
@@ -383,6 +383,19 @@ int sun8i_ce_cipher_do_one(struct crypto_engine *engine, void *areq);
 int sun8i_ce_skdecrypt(struct skcipher_request *areq);
 int sun8i_ce_skencrypt(struct skcipher_request *areq);
 
+/**
+ * sun8i_ce_cipher_finalize_req - finalize cipher request
+ * @async_req: request to be finalized
+ * @cet: task descriptor associated with @async_req
+ * @err: error code indicating if request was executed successfully
+ *
+ * This function does the final cleanups for request @async_req and
+ * finalizes the request.
+ */
+void sun8i_ce_cipher_finalize_req(struct crypto_async_request *async_req,
+				  struct ce_task *cet,
+				  int err);
+
 int sun8i_ce_get_engine_number(struct sun8i_ce_dev *ce);
 
 int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name);
@@ -398,6 +411,19 @@ int sun8i_ce_hash_finup(struct ahash_request *areq);
 int sun8i_ce_hash_digest(struct ahash_request *areq);
 int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq);
 
+/**
+ * sun8i_ce_hash_finalize_req - finalize hash request
+ * @async_req: request to be finalized
+ * @cet: task descriptor associated with @async_req
+ * @err: error code indicating if request was executed successfully
+ *
+ * This function does the final cleanups for request @async_req and
+ * finalizes the request.
+ */
+void sun8i_ce_hash_finalize_req(struct crypto_async_request *async_req,
+				struct ce_task *cet,
+				int err);
+
 int sun8i_ce_prng_generate(struct crypto_rng *tfm, const u8 *src,
 			   unsigned int slen, u8 *dst, unsigned int dlen);
 int sun8i_ce_prng_seed(struct crypto_rng *tfm, const u8 *seed, unsigned int slen);
-- 
2.49.0

