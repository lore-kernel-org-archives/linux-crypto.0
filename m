Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E12E2D97B7;
	Thu, 26 Jun 2025 09:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750931971; cv=none; b=h7YkCQAEAGbmEXNFmMldu91FUBzdIVaMtLPuv2BbPdOtaOQUFld8f44pHhMJsgcMAbQmOBJFSYSQZcDRMcLH2yZb0krN82O/pJDoC8Jn+a4aWQCEwVZmiELn24BiClKnm8hnFBzkyv0aRC40F2HS20R9/eA4XmDHfdg4ej8A2Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750931971; c=relaxed/simple;
	bh=SV17SgqAFM/CwgJKb43KYYELjIo00ELjwm2XuaeiHoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kT2dur1UI8gOgDPTW/hEzKlTaa32DYQRzk0XpfOX6MHK5stzpDp8a9VKKYvr+U9hFrHggqQjqrf2pVV71oO2dZJjJ4ySFTQgY1FzyE17Pa8PsA2ftK9zrhUpPc1L9JtqpRRnc1nFR5HmMS0kFGewoq6kQoQlUqBcKVIassBAqLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NgGvP6es; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NgGvP6es"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ae0dad3a179so61646866b.1;
        Thu, 26 Jun 2025 02:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750931968; x=1751536768; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TntJfTNuRfw8H9ywL1n4IQi1UH/CB2DPSoGeEkzsKwc=;
        b=NgGvP6es0MrtG3PlAavJecoud+OG6WQHeu0p5PuMihAA7NdULdNpWi9slEd6lIw6vx
         8pPSOnLoW0hgetYR8s60oeZaJblcYC6HIqAQM9rbsYaw/0CZw1rW3SzKnCWF4wBhhfuB
         0nMthKOnO7jV3vTQTrGO2EFrJezwdnrVDZ1mK32JCk7OahzqAauQnNerMlvsyyJ5RxvV
         NojAJR2I6QvH5sWPyoaLrrxeEFbqKgS7Q0GhSQ3WfTOF/A05KTz31fdZFv+pp0GAhwU1
         2Ivqz25bXHBlgyfzl5awyWxS7vVSwC8qHgYu+hJpUy15xugZLX1XumAUl+AhJs/XrWIW
         QtrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750931968; x=1751536768;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TntJfTNuRfw8H9ywL1n4IQi1UH/CB2DPSoGeEkzsKwc=;
        b=ObAhCuRRpsN7GN3rDtaPKBKrJ010xV4ZPiw2iYxjIO/+AaXVYPA7fCtRhnHwQdbvMZ
         zehFWlEFKVfBzFFDUjUZKol1YEru+nClIJdk1X8KATs0MqJtFhxoeRfrMvCSf3nZBZro
         M7sE94auJwvnjqmw7ypPBjgmOD2MgxUt8H5yRLPWWNd4FE0ZmnzVoLr8hO7wH2PZHY4c
         2Nw60FGSoBoLXgYkebidB3pE96NHhquYakFrI1+3OKqK0C4osdNrlnTEIoAQBhWl4vX+
         PUIvSjO52dORKIslVwP5I4/5Jn7AgnNmsySUhUuljzwloopjmROLsFV/8gUROujiU2pA
         c6gw==
X-Forwarded-Encrypted: i=1; AJvYcCW7FqJlUCWKiAYNZIiWRHcdtB1Rl9EOuyGYWkAnhAoLrfcQsxMpIBGrPPNtb6dF289QGBvOEEM7PjdGdrbW@vger.kernel.org, AJvYcCXpCiqiMbns8wxpSWVDOL38P52mSqdXRqoanjIyY4nk5u61OyRs6QszRBKDMaS0v8+/1io714tzwew3YPU=@vger.kernel.org
X-Gm-Message-State: AOJu0YztfmPHRPMQ0boBtwMIHwizj6t6mnagmZhW4EcGmovuNINjwMUl
	9OQ1XFIMQ2rdxVBu/R9k54LGEZ9SIMyO01xaUzmXvGzenubC8Ma4tVnP
X-Gm-Gg: ASbGncsWnHuqgIK/vh8115D5FSEG9q1U8r1VZhPJN/Ip+x7KR2BgjUt+P4HQsb+b5Mx
	t/vGJZaZ6RdGzgviiJm4jPq0MSaW/hDdonfJgsCb3C2V+RhWhc1L60wSFd+CLzDWRV1KZw/POQ7
	fQ1eBoEH24YF86Vs0bAOprhUwLJIN1Ixes2yfi1KRtlXpVqro0gCYJhaG2NZ41257WS4JQpsWW4
	RM9iAdn8iekSfXNwanS9RjwR6Khyw/1SCxFziRN6IvgjiHGMGLnK2GCC7Rzt0+T8Fly91xLm1Bt
	wpjZ07618+ZddLcA/NGyDtVS9xP0kwdJ1wiuOBSuSPVyth9ztIBKO00nYfE26OdaD7IYsTeAsy1
	F8Lptt6EUJUaYJA==
X-Google-Smtp-Source: AGHT+IFyb5bPq7coEij2ylBbwkujWU2PveIvkYkjw2FajzUHkMcuMAgQb7EBUOsbFoZBWzMPaDgZYA==
X-Received: by 2002:a17:906:7308:b0:ade:9fb:b07d with SMTP id a640c23a62f3a-ae0be7fe523mr687847466b.4.1750931967528;
        Thu, 26 Jun 2025 02:59:27 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae06aa5ff34sm1014106166b.40.2025.06.26.02.59.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 02:59:27 -0700 (PDT)
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
Subject: [PATCH v2 08/10] crypto: sun8i-ce - factor out public versions of finalize request
Date: Thu, 26 Jun 2025 12:58:11 +0300
Message-ID: <20250626095813.83963-9-ovidiu.panait.oss@gmail.com>
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

