Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC51524CEEA;
	Mon,  7 Apr 2025 12:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744029444; cv=none; b=iiwy7P+owdTPfjoWeUYmg/ctD5d5kZ8UgT/nQQfWQ56vFdop0IjKhG/rSU9MxVrkNSK/vul5YyeQfrt8SV8Kqq4y5S7Zw3cekGu3IjGVS0YMm8uDE6TB8A8KeFedS/OcCNDQjIH9hwSV2IOGLBuvOlFqtAHO+ns5Zv20mg+xUq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744029444; c=relaxed/simple;
	bh=fPaIJlcWeN7XcHAT4dA7liyZzdvlkwCm9/OnQCQ+nbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaMC5146PtEYrzqpmLuDq3Kcz3k/QAdJeEme8odZZwD8lX+oea1piismLwFuCKITxSEabcFS4Hwp+DEYPUsU3pZCBzyfR340iXT4N65ciXZWJqHyUIgMfe/9w0BYmT1tpXfPqATGBHdI/FUorF/fUAZpexJRgqkqh9vuUcAIgsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dKFE3lTZ; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dKFE3lTZ"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3912fdddf8fso3381814f8f.1;
        Mon, 07 Apr 2025 05:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744029439; x=1744634239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0o6+zdI0AtRq1Xlwz5OA5c9uHll3v6Nadhh0JoXi15w=;
        b=dKFE3lTZVDjWFDEn8jhcl91iaoqGJTLt5gt3eLm10FXWozrWUejOwGdrYEWUygFZHv
         eHO14cjEnkHwIG9RhI5IyYoadXBNqoAWikdCX8esKBxAO3zZ6sHWrDCMMC/Pf60NDNqM
         2IurqPFpOfcT3in62fWYbqwW7cxLGzi9GKG+ieXkQRdybBAFqEHmkorPpYWBSCVlPEIm
         XAtXQxDHvMzhxv+lPDC9LRrQCadtAx7Mo2ROeAmRSq1mi/UOhPQY1r3QEwRUZ9H44J8Z
         uB7xLwujSxWWl1cfTqF67iAj+2HiHWjQgcvWByrzXh/bGdvFtAsaUAI9mB++68wv6ZMC
         txrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744029439; x=1744634239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0o6+zdI0AtRq1Xlwz5OA5c9uHll3v6Nadhh0JoXi15w=;
        b=jHRza67fp2WYokvGsdMzDm+0x138yWdY4WAYKxYnocyR+3qLlB7BKqeyQdSpXRT0AB
         c4vDzy3YQkKPdf2VVdsUk2IvIxqYI59NCYieSwCtqeuoZl7Oefkcb9E7exTiCkDy7H1Y
         1slzZZ66PNtk6rIAnf3HAZmKHDcztRHA8RQ8iVqioLMkYaIN1Zvss/+nY+irWUMOFLDX
         ScYYtU+N0ggx34W1SXdVbhQnO4ELHNA+EyWC+ViB8iUCt8txh9vY10Ze3lVydTqMJTt/
         U3+rir+6ZOxHtVA1rQg+a6dTYekoa4hgiSI76s5oadh256mCGQ17OARCx4hdwuThWBTk
         sYlw==
X-Forwarded-Encrypted: i=1; AJvYcCWB5e8/r8onX3WflIONSMJLrZIMUlFdNIhe0ih4CU3zVxqzEpnZSgsr8dK55KjYN4vjyuCJF83RsQ8WQHE=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywz8zvNdCG7sNQPrUMQWZPRq0vwdiNgkV8VD6eejmKXk+rg4q64
	A89Rn52GuPObMZimYnGuemB8uyrb7LkcWe3qgPd4v3rdVh5A9Kc9v+nzXg==
X-Gm-Gg: ASbGncsAynOa+nLisx953XjGsoO9HbjYHnzLeE7UXJmQy0gScnaXt8+d3qG4yyls0ap
	X3K+b94EZe2uEGear8klTIS4sGrt0DTblTaXC/wgHR0emoJU1SGGuXCIXTFxiv6ywjGWVyPBOLa
	33NG3cshfq+3kDTd/SEBIpza3CcRLvNyCK0/awLQuElxx0C1M1KbDNeSV/f/4lTr92rlWeKcQWj
	cEdKjUGoEkWQCumyn2UvLFNDxBarGcyEiHf7yQ1M7xuzB/FOLaPw1ZnqwfEI4hFt2BFsugASMn6
	29F6d6Nllpn2zPLQCHFFqLbVLKFwTEhnqBQAUom9g0F2fW1s3eAEeGC3x34oDlyzJUTXqXSN
X-Google-Smtp-Source: AGHT+IEPI0/uAmG1j3NVe3lMMXToyTKqXz/tt6wVkSqKVKUWUxmvO7uD/TEvDrvrmVRLlqnGT6k+9g==
X-Received: by 2002:a05:6000:2489:b0:390:e9ee:f27a with SMTP id ffacd0b85a97d-39cba94dac8mr10539389f8f.28.1744029438981;
        Mon, 07 Apr 2025 05:37:18 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301b76f2sm12065198f8f.53.2025.04.07.05.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 05:37:18 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Corentin Labbe <clabbe.montjoie@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-sunxi@lists.linux.dev
Subject: [PATCH 3/4] crypto: sun8i-ss - use API helpers to setup fallback request
Date: Mon,  7 Apr 2025 15:36:03 +0300
Message-ID: <20250407123604.2109561-3-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250407123604.2109561-1-ovidiu.panait.oss@gmail.com>
References: <20250407123604.2109561-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than setting up the fallback request by hand, use
ahash_request_set_callback() and ahash_request_set_crypt() API helpers
to properly setup the new request.

This also ensures that the completion callback is properly passed down
to the fallback algorithm, which avoids a crash with async fallbacks.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: Samuel Holland <samuel@sholland.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-sunxi@lists.linux.dev

 .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 49 ++++++++++---------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
index 753f67a36dc5..8bc08089f044 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
@@ -150,7 +150,9 @@ int sun8i_ss_hash_init(struct ahash_request *areq)
 	memset(rctx, 0, sizeof(struct sun8i_ss_hash_reqctx));
 
 	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
-	rctx->fallback_req.base.flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   areq->base.complete, areq->base.data);
 
 	return crypto_ahash_init(&rctx->fallback_req);
 }
@@ -162,7 +164,9 @@ int sun8i_ss_hash_export(struct ahash_request *areq, void *out)
 	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
-	rctx->fallback_req.base.flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   areq->base.complete, areq->base.data);
 
 	return crypto_ahash_export(&rctx->fallback_req, out);
 }
@@ -174,7 +178,9 @@ int sun8i_ss_hash_import(struct ahash_request *areq, const void *in)
 	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
-	rctx->fallback_req.base.flags = areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   areq->base.complete, areq->base.data);
 
 	return crypto_ahash_import(&rctx->fallback_req, in);
 }
@@ -186,9 +192,10 @@ int sun8i_ss_hash_final(struct ahash_request *areq)
 	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
-	rctx->fallback_req.base.flags = areq->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
-	rctx->fallback_req.result = areq->result;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   areq->base.complete, areq->base.data);
+	ahash_request_set_crypt(&rctx->fallback_req, NULL, areq->result, 0);
 
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG)) {
 		struct ahash_alg *alg = crypto_ahash_alg(tfm);
@@ -212,10 +219,10 @@ int sun8i_ss_hash_update(struct ahash_request *areq)
 	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
-	rctx->fallback_req.base.flags = areq->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
-	rctx->fallback_req.nbytes = areq->nbytes;
-	rctx->fallback_req.src = areq->src;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   areq->base.complete, areq->base.data);
+	ahash_request_set_crypt(&rctx->fallback_req, areq->src, NULL, areq->nbytes);
 
 	return crypto_ahash_update(&rctx->fallback_req);
 }
@@ -227,12 +234,11 @@ int sun8i_ss_hash_finup(struct ahash_request *areq)
 	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
-	rctx->fallback_req.base.flags = areq->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	rctx->fallback_req.nbytes = areq->nbytes;
-	rctx->fallback_req.src = areq->src;
-	rctx->fallback_req.result = areq->result;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   areq->base.complete, areq->base.data);
+	ahash_request_set_crypt(&rctx->fallback_req, areq->src, areq->result,
+				areq->nbytes);
 
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG)) {
 		struct ahash_alg *alg = crypto_ahash_alg(tfm);
@@ -256,12 +262,11 @@ static int sun8i_ss_hash_digest_fb(struct ahash_request *areq)
 	struct sun8i_ss_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
-	rctx->fallback_req.base.flags = areq->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	rctx->fallback_req.nbytes = areq->nbytes;
-	rctx->fallback_req.src = areq->src;
-	rctx->fallback_req.result = areq->result;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   areq->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   areq->base.complete, areq->base.data);
+	ahash_request_set_crypt(&rctx->fallback_req, areq->src, areq->result,
+				areq->nbytes);
 
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_SS_DEBUG)) {
 		struct ahash_alg *alg = crypto_ahash_alg(tfm);
-- 
2.48.1

