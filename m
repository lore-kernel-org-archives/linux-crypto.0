Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E32B924E4A8;
	Mon,  7 Apr 2025 12:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744029443; cv=none; b=PaqI5tlQPeKUv3LmZ0dSb7tdCGVIwGZDWWnT8l+3LrCnd9ACnm/ZFMxos/Qc2MlyeRilurZIWkPk4O05hncL4HHo55RAkC4JWo+Q4VEdzAgn8rRD32fJii1vhMvIAog//gOnM1oJ6qHkQO0g0tr6yLCsxnXD6SJhrohDLMW5VR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744029443; c=relaxed/simple;
	bh=sg0cvB5ctoBdLyPSk10rrJPwZxp79Q6IByN4TnHAN74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Th8aIPUBKS22Rg8XtqufH8HRwlEkazlZZdUHQWnL35T2JSzVeVwuwQZ8F0MNwk6IsoDRNgoQ9d9YzqEkQzC4VAnivttfmcF5zyMzWztuIrzdm9hYwXtlYCyjT3YNUVrEgUdh/ymJAy32KVA6NVG4wksNKeXd6s8Mj6GNWsy2ou0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MZn7qQrn; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MZn7qQrn"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-39c1efc4577so2291384f8f.0;
        Mon, 07 Apr 2025 05:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744029440; x=1744634240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfWnLdfANaqdQSj+h+q53Jo6tygA2YrUlTN092Bn+P0=;
        b=MZn7qQrn8YUbIcX6V1iL3YsBe9D5SfgyJ4oXhQBprbbhvRBQcI6ZgC1xmzX4xHHEaC
         BgPDrgpPS/ERYQAFgtfSNz/0cztUFtQvv9Y4AyK4b8+z5isYQDRS+K+0BPCIQH4Blne8
         ZfgSpJv2JhDlfXlZlKcQ1j8GDXf8ljKnxySuzNrBQJt/tHu1oyvdeU8sw8FODvJjeFA5
         bwbN7l3ymMeRYcslyAQIjb79oKN5YHfn/dk67qzHFRDbUf8IZ4w7J8cldB9lOSRs3kr3
         JniAqdOC2ALAqvvWdPylSCCSeM4fagSYb4sS6xDPLFmsyrxUCxwoCjE+U0uqU92jTAiq
         uOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744029440; x=1744634240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FfWnLdfANaqdQSj+h+q53Jo6tygA2YrUlTN092Bn+P0=;
        b=lU+nn7v8ug9beLkwsT/X3GeZnKpl2kWA5omcZpGrwZ38J1cS2G9uXldSJtIdPq34Tl
         GhS+h/tEYzNoJE5sTf65Hy6amruSJ3BRdNblbmEglxtlY9XaZk5TmLA/Xdr4ByIBj61u
         HQVpJkX5WCV3y7a827h8/Gml1178dfSwo72eC3j6f9weKj45UxLbxJTkxe1uNNF4MD7g
         QSzIbai77zKsfRgn1kRl1NQPdVOgKXFyVUHcLyBKRJG6fn4MWu1SsApSdjV4v66iaLCX
         lpiYlfHcdzRwLj19RmeSnISL8mT1+JWr5xxME5m5Jyt56UOexBKZCmKWCzc4kmiKGj3y
         Ic0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUx8zvWLYiZ0MDjsTuH7mZgdjrMOHIWb39i08kVQZ2pqUoRCqccrtrxT8uxjwfvSN3i9KhVntzrrvvoAik=@vger.kernel.org, AJvYcCXDQPpjRZxAoErefC0NBjmVWr64sQEbR0JZLVMtX5T6purjrxHF/s0SJpn6CYNHYMosGvaFi0Id2pKQ+Ww=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4i24VjSzAZss8DvuvJhnT+tbZ7hH12dAOK2nb/ELPxBjHRH8i
	lKoQCWx3jBHESlZDjX2d+wU5e46aAiN6zkPj82nrjR9of3BUW0pmPwp3YQ==
X-Gm-Gg: ASbGnctX2bAlfyAjuPGqKsNGjXRtMmBySfCYVU2fuZprPIP71netQkcaLQ9wQGoh3mx
	hzjyvG9pm3oR+kiiE6bYavKvH8rPaD2Dl4uLOM0y8rKF3xN1dFJOdOuUSNaF9hJAyB1CxFB4yxP
	0HNP5nZjWUpSIuv4aXV40YPQCuW4TPZefPlQyX2w9NhpqZYjGqqF10rOpO3mNNDSlRJoj2MOsbS
	/oGrEXCtdvaYOF7UQBKqeUrAnP+i4nqsFby8u195Uz4tYN07STsHJ1PVtnBh7eLDWHxGiEBEGCj
	d2kJ0slD42OxowNLsFdZlHnTRUIcLXyOw90EhGhNGoa0jwBxrFNHDppHbbzKYBPVD9FfO9NO
X-Google-Smtp-Source: AGHT+IEHnAR7JxfNzMoB/DN5jUIucYjOoQpUgj5aPi18JnL9jSaicvC3fEnhePc6RSQppmdiZItLtQ==
X-Received: by 2002:a5d:5c84:0:b0:397:3900:ef8c with SMTP id ffacd0b85a97d-39cba9332a5mr10735755f8f.35.1744029440054;
        Mon, 07 Apr 2025 05:37:20 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301b76f2sm12065198f8f.53.2025.04.07.05.37.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 05:37:19 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Akhil R <akhilrajeev@nvidia.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	linux-tegra@vger.kernel.org
Subject: [PATCH 4/4] crypto: tegra - use API helpers to setup fallback request
Date: Mon,  7 Apr 2025 15:36:04 +0300
Message-ID: <20250407123604.2109561-4-ovidiu.panait.oss@gmail.com>
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

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
Cc: Akhil R <akhilrajeev@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>
Cc: Jonathan Hunter <jonathanh@nvidia.com>
Cc: linux-tegra@vger.kernel.org

 drivers/crypto/tegra/tegra-se-hash.c | 52 +++++++++++++++-------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 42d007b7af45..d09b4aaeecef 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -117,8 +117,9 @@ static int tegra_sha_fallback_init(struct ahash_request *req)
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
-	rctx->fallback_req.base.flags = req->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
 
 	return crypto_ahash_init(&rctx->fallback_req);
 }
@@ -130,10 +131,10 @@ static int tegra_sha_fallback_update(struct ahash_request *req)
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
-	rctx->fallback_req.base.flags = req->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
-	rctx->fallback_req.nbytes = req->nbytes;
-	rctx->fallback_req.src = req->src;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
+	ahash_request_set_crypt(&rctx->fallback_req, req->src, NULL, req->nbytes);
 
 	return crypto_ahash_update(&rctx->fallback_req);
 }
@@ -145,9 +146,10 @@ static int tegra_sha_fallback_final(struct ahash_request *req)
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
-	rctx->fallback_req.base.flags = req->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
-	rctx->fallback_req.result = req->result;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
+	ahash_request_set_crypt(&rctx->fallback_req, NULL, req->result, 0);
 
 	return crypto_ahash_final(&rctx->fallback_req);
 }
@@ -159,12 +161,11 @@ static int tegra_sha_fallback_finup(struct ahash_request *req)
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
-	rctx->fallback_req.base.flags = req->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	rctx->fallback_req.nbytes = req->nbytes;
-	rctx->fallback_req.src = req->src;
-	rctx->fallback_req.result = req->result;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
+	ahash_request_set_crypt(&rctx->fallback_req, req->src, req->result,
+				req->nbytes);
 
 	return crypto_ahash_finup(&rctx->fallback_req);
 }
@@ -176,12 +177,11 @@ static int tegra_sha_fallback_digest(struct ahash_request *req)
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
-	rctx->fallback_req.base.flags = req->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	rctx->fallback_req.nbytes = req->nbytes;
-	rctx->fallback_req.src = req->src;
-	rctx->fallback_req.result = req->result;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
+	ahash_request_set_crypt(&rctx->fallback_req, req->src, req->result,
+				req->nbytes);
 
 	return crypto_ahash_digest(&rctx->fallback_req);
 }
@@ -193,8 +193,9 @@ static int tegra_sha_fallback_import(struct ahash_request *req, const void *in)
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
-	rctx->fallback_req.base.flags = req->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
 
 	return crypto_ahash_import(&rctx->fallback_req, in);
 }
@@ -206,8 +207,9 @@ static int tegra_sha_fallback_export(struct ahash_request *req, void *out)
 	struct tegra_sha_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
-	rctx->fallback_req.base.flags = req->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
 
 	return crypto_ahash_export(&rctx->fallback_req, out);
 }
-- 
2.48.1

