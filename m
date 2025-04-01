Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E948C2C6;
	Tue,  1 Apr 2025 19:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743535442; cv=none; b=MJnUsCeL9/GGBbzdr+GlvOxUHI4LMgxvj3Cte2Cz4gcDC5SlxZ+gyJSxEKRDC0D5mPqV5IheM0Yzi9d+jJVg5b3VE/rWJSrtAO9yDyARVFoU61kRyZi85FNEhvYC+/ewg6z7lrBzrHxr6G7HsxfEAPuUBNR24SBMfVLwX9XaK40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743535442; c=relaxed/simple;
	bh=ijYhgMFPW0GwZbvTlvUWZO6qB0iZ1PV0+yjxL+ZbDOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvOpf6/8C1uNMitnoAg25YdFznSicuqBVwFMS8hkJxjCO8V1WVvq46ARJIJ6rswHhVHjtwiNTb2WhBJUkNrkXzYerPUfPK//Qoyqv2ITPoNWzBN2UV9cb2/B1ri/VKKGH6NqHc4Pov48Ydg67PCs0tbFZDmZTMSqTeTePiqg3KM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yxd0jHH8; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yxd0jHH8"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3913b539aabso3487540f8f.2;
        Tue, 01 Apr 2025 12:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743535439; x=1744140239; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZzBkugdw4gdptdF8hF2WvHzloU2qygLTygvgXH5F5js=;
        b=Yxd0jHH8O+aA5NKjLNG3TMdSfko2KdGFqtwgGc6HlWQsuw3Ju0kMy2qB+1pz8qb/CI
         jMbqmowt0lYq881KEUzWGG5VMeXMgvr7boqAkxjluojQdoR5rKFD/4R91u4+L69V+7s/
         rCe1f+TjPJzgBOmP7T87z+h7arf6mmen+cWSBsvDd0WQM3cyGNkb6z8HdlWQQ79WM2N4
         twjjKMYD8JUBPgwKUSo1K0q5mi1Jv08LIalU6gTaTYTzu35nfnV/DwAsRmSQc2ZQUSfR
         jZmf80X2bxxJNt9k4/UoTeNBwD1K0HUfWfwdYxSGabU3qQI6d1DvJ0fsqGWitMuBICY1
         4YJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743535439; x=1744140239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZzBkugdw4gdptdF8hF2WvHzloU2qygLTygvgXH5F5js=;
        b=B1MtJvm3w/fMxAtnk83tjaIKDZli0mQcrcS0X1V1L5Ga0QG1vNj1XFoDCnDXzhM2S5
         CTHSyZfCVtFUWYTxPh0RDChijULgpsEfpBFhA104JGvgoh54ZYZMdnFu4sFn1KkN4VAZ
         2MYdbh1eCPXBhqJT+OzzEZ9Ia2hT5IvZ3aQLV043sCg11zLOIrXD3fBuzRnkL8oJsu4L
         uF2B+H19ld8YLcNKBQsaHPXIebI7uURtoV3lc4QS/njdLxs2REt8Mmu1xN1pb416p9fM
         K7vQvozBKLpby/TuAle7RmqhwHHHoTtfFZtR62+MjfMcPKWoUQyltaR8amB9P79CZFSs
         fwLw==
X-Forwarded-Encrypted: i=1; AJvYcCWe4F43MhFwVPV/raMAXlEEU24BKBCrAUKLn87191paG0TMEh8RfzKbw0WPJreBJrpcfFOJhDfbir7W0Bk=@vger.kernel.org, AJvYcCXZMVNZz5qGh6eOJ6sFSY2l6KMISRVvV//JJvahHsLwYEXvYK9dgAZ58LJGZhiA3XAbU9c3zj+9Ujcqd1f0@vger.kernel.org
X-Gm-Message-State: AOJu0YxvTf4oZnkpnp7xy+atIVlJ5hg83cB+UX4OCZTHBLerrobcI9uX
	mt9Izt8oWSwxEuY2TfYGscN82QSMWyMXQOG/yThIEcrhlChz5xKW
X-Gm-Gg: ASbGncueY1GUOj7SwNd1zHa4ubL3EucVexGmH7EFVlSnB/OcUxt51OZZcXf0aC6/LIL
	JDJ0fIXWC7HGkleuq01Z+aM5vA48i3YdjIa5ZkanhaZiPpmi+x3MOjzcMMHIah3Kl75jcp46NAa
	V/ASesfHpXITvr19TBM36S3f2pJ8b+gzt8VrIU2hhMLVp/mT751z3B93jI5917IalPfYW1srTDh
	BLPKWbHJoGjKfJ/a+i8WOxbA8/Ikk4quHTUmCvxGwP8HU4M2OvZkFOUMiYBATMWirN8oRDe7NpC
	r0Kg5x+TlxIKfKsKvlBSRNydrKjmOc4Vx8xxQriPYxLQfZTdetvDEJL/m2V56IEskSyHQ0O/
X-Google-Smtp-Source: AGHT+IHdVEsoyIGdrpYCryCmSoxbMMM8oYYvuj+OQEED1lz5k318eW2R/hcBuIk9AkMR8eZjNXUkHQ==
X-Received: by 2002:a05:6000:381:b0:39c:1f0a:ee0 with SMTP id ffacd0b85a97d-39c1f0a0f69mr5763858f8f.2.1743535438907;
        Tue, 01 Apr 2025 12:23:58 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b66aa32sm15353438f8f.50.2025.04.01.12.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 12:23:58 -0700 (PDT)
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
Subject: [PATCH 3/6] crypto: sun8i-ce-hash - factor out debugfs fallback statistics
Date: Tue,  1 Apr 2025 22:23:18 +0300
Message-ID: <20250401192321.3370188-3-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>
References: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to reduce code duplication, factor out to a separate function
the codepath that increments debugfs fallback stats.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 53 +++++++------------
 1 file changed, 20 insertions(+), 33 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 2c2d285de154..b0959d8218cb 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -23,6 +23,20 @@
 #include <linux/string.h>
 #include "sun8i-ce.h"
 
+static void sun8i_ce_hash_stat_fb_inc(struct crypto_ahash *tfm)
+{
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
+		struct sun8i_ce_alg_template *algt __maybe_unused;
+		struct ahash_alg *alg = crypto_ahash_alg(tfm);
+
+		algt = container_of(alg, struct sun8i_ce_alg_template,
+				    alg.hash.base);
+#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
+		algt->stat_fb++;
+#endif
+	}
+}
+
 int sun8i_ce_hash_init_tfm(struct crypto_ahash *tfm)
 {
 	struct sun8i_ce_hash_tfm_ctx *op = crypto_ahash_ctx(tfm);
@@ -113,22 +127,13 @@ int sun8i_ce_hash_final(struct ahash_request *areq)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct sun8i_ce_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 
+	sun8i_ce_hash_stat_fb_inc(tfm);
+
 	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
 	rctx->fallback_req.base.flags = areq->base.flags &
 					CRYPTO_TFM_REQ_MAY_SLEEP;
 	rctx->fallback_req.result = areq->result;
 
-	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
-		struct sun8i_ce_alg_template *algt __maybe_unused;
-		struct ahash_alg *alg = crypto_ahash_alg(tfm);
-
-		algt = container_of(alg, struct sun8i_ce_alg_template,
-				    alg.hash.base);
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
-		algt->stat_fb++;
-#endif
-	}
-
 	return crypto_ahash_final(&rctx->fallback_req);
 }
 
@@ -153,6 +158,8 @@ int sun8i_ce_hash_finup(struct ahash_request *areq)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct sun8i_ce_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 
+	sun8i_ce_hash_stat_fb_inc(tfm);
+
 	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
 	rctx->fallback_req.base.flags = areq->base.flags &
 					CRYPTO_TFM_REQ_MAY_SLEEP;
@@ -161,17 +168,6 @@ int sun8i_ce_hash_finup(struct ahash_request *areq)
 	rctx->fallback_req.src = areq->src;
 	rctx->fallback_req.result = areq->result;
 
-	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
-		struct sun8i_ce_alg_template *algt __maybe_unused;
-		struct ahash_alg *alg = crypto_ahash_alg(tfm);
-
-		algt = container_of(alg, struct sun8i_ce_alg_template,
-				    alg.hash.base);
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
-		algt->stat_fb++;
-#endif
-	}
-
 	return crypto_ahash_finup(&rctx->fallback_req);
 }
 
@@ -181,6 +177,8 @@ static int sun8i_ce_hash_digest_fb(struct ahash_request *areq)
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct sun8i_ce_hash_tfm_ctx *tfmctx = crypto_ahash_ctx(tfm);
 
+	sun8i_ce_hash_stat_fb_inc(tfm);
+
 	ahash_request_set_tfm(&rctx->fallback_req, tfmctx->fallback_tfm);
 	rctx->fallback_req.base.flags = areq->base.flags &
 					CRYPTO_TFM_REQ_MAY_SLEEP;
@@ -189,17 +187,6 @@ static int sun8i_ce_hash_digest_fb(struct ahash_request *areq)
 	rctx->fallback_req.src = areq->src;
 	rctx->fallback_req.result = areq->result;
 
-	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG)) {
-		struct sun8i_ce_alg_template *algt __maybe_unused;
-		struct ahash_alg *alg = crypto_ahash_alg(tfm);
-
-		algt = container_of(alg, struct sun8i_ce_alg_template,
-				    alg.hash.base);
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
-		algt->stat_fb++;
-#endif
-	}
-
 	return crypto_ahash_digest(&rctx->fallback_req);
 }
 
-- 
2.48.1

