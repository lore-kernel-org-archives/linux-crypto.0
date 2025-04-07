Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7918D23AE64;
	Mon,  7 Apr 2025 12:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744029442; cv=none; b=srLjmiGmCPfTS2ubs3QDjKamCvT9NhLWJ5/fGUd/qM55RZ6Eo/OQBm1a9wJo8dwDhY2NrpLDjMCckee0eQe+uEzvkFrFxk08eaxnqCJvrJ65CVsu+vK/WzLvcCFBLt/lfhW2z8fK2KgWmhN0IZHxInQuVU3UVFbCtFXHV7UZERc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744029442; c=relaxed/simple;
	bh=SvbeQtb6k7bGVUoSWfqcjFFLSqmkgm82+xG8E4qpwXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZ8InpNjWHLJJI1jI192IvcFkVmwPCo4qu6IHYZBm5Aiz0GsUEeCMPJuMRCivuCZWgtSQRt2lBrEfonYMhx0xmLYzfAKLrRYN5GrYrS2Ktf37D6ly2mgKCAlIf3JTzXrJdmX8/5+ZeVwqCPA/CJxPCsMAGC4WT8/60OsJZaSy2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IqHQ1O3u; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IqHQ1O3u"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-39c0dfad22aso2562431f8f.2;
        Mon, 07 Apr 2025 05:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744029438; x=1744634238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nJwN15SFuWFw+J8LbQ3OEgp3ncmtC3qYGCS05leh5Dk=;
        b=IqHQ1O3uOX/D5ycDlRCSQ5Y7IhT624dLxADjMW/q3WIHsxO9s1WrS9SXGUpl2pCnW8
         ehWaBI9fyVoKMK6wDL2Odp2CTcG8mGGN7eLe9zNTqGzJQyJYjRcY2QHoqXhIfPi2gckm
         jxZt5pgL9NdyeLiyStweTROSl4I7b7ahpUgfS/uWeNQK1EnxbkAo2I/8WPo2epEzmqrJ
         GwstknGAKR+8HDfjEovepz45NpZ+mM7mW+tuCJMHqwBTj3pj6DDSuKtfov0OHo8IiD5P
         LzCg/zekzdGedIoKZ7yBBEWvXpmhDLb9yKMZc4KntGkjk97FJLnlIckI2NP1kM82hXIr
         eBRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744029438; x=1744634238;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nJwN15SFuWFw+J8LbQ3OEgp3ncmtC3qYGCS05leh5Dk=;
        b=L0Bta4x3tJBwTvQ5p1+SjR324WYoSerCxAOM34kroNUrnQ2i1GuJsJmRpOOy9bX4bW
         iF6GkX2JTPGFTehjkvNf4ZeCFTvpzqfXASZtDQDfj0RnkvU5JFoejdhZbRokqsRifD1I
         MVSIiAkw3qGYGpvpCEAEnv6ax6dkXthIDnivEpNWa1NPqzZ5/Kw/EDksQE7cZF3IeqMH
         cA6fpvptpWOJVHptmaMm+6q3tqqKQAvPypnrBVA6BXlJdctocazTw2xE2ik6g9Z5UPZQ
         vTQhh0dYUDjHRI3a4BJcMjEdMXdIVElj3qzMFZHVjp947UogU8EXkhEJspAUgpMsDQHU
         cY2w==
X-Forwarded-Encrypted: i=1; AJvYcCVK9J2War/NAAT39x/rQPbd9mhwbDdtHlTnLFqLhuVX6OR+GXf0GSvID9u9qaiOe+22XrwcpzBrqCl2cXA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8NbG+MMVZffMW3eXC50gVx6mCawJ2/sK70DNxD1dr1hRaQe1f
	dxEOF7ZGvXKgXyYbqxX4rvllb/iDV7RHo1yFeDL8KgrmxLXT8USATZAHvw==
X-Gm-Gg: ASbGnctNslXOv8JaKHp7BBYB41e0ecaay3UlNEgfjJf7sY9tLo2YBbA0pBmIIURSMau
	urYb0kC0t0Fwi/LgvKdXvVoW0o6y8flhDOmMjJ7xDkclixN07RNrslZyI77qKBEIwFEwNl30SBn
	h7fT1lD3DV1Y6/BUkO0r6fIMBINyAbZV57CM6Jn7xKc6nV0szicr+C5iPQ028WezlbG1ROCjgVh
	EjTDwko8R/o0gNyg39upAb6tflpa0MKVeqMqF7+aV3gJRU6srLQMKsxVmcSU2ua4stR9EvANsrx
	s+CpKxhakKu1JkduDRgD4gEoNU8AXl4ClJTSNKIKckZIQZd4T58kf2WOCBbp/8EB3a2Y1DBQ
X-Google-Smtp-Source: AGHT+IGOiYeoMEwHC9hRn8culHx4Ww1nJheukDZ53zBULfafTN1LFvaJ8yuDLqKUZnP9wmJYz7FCzQ==
X-Received: by 2002:a05:6000:2405:b0:391:4999:776c with SMTP id ffacd0b85a97d-39cba975d5dmr10077751f8f.40.1744029437773;
        Mon, 07 Apr 2025 05:37:17 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c301b76f2sm12065198f8f.53.2025.04.07.05.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Apr 2025 05:37:17 -0700 (PDT)
From: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
To: linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	linux-kernel@vger.kernel.org,
	Ovidiu Panait <ovidiu.panait.oss@gmail.com>,
	Corentin Labbe <clabbe@baylibre.com>,
	Heiko Stuebner <heiko@sntech.de>,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org
Subject: [PATCH 2/4] crypto: rk3288 - use API helpers to setup fallback request
Date: Mon,  7 Apr 2025 15:36:02 +0300
Message-ID: <20250407123604.2109561-2-ovidiu.panait.oss@gmail.com>
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
Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-rockchip@lists.infradead.org

 drivers/crypto/rockchip/rk3288_crypto_ahash.c | 52 ++++++++++---------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 69d6019d8abc..d6928ebe9526 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -52,12 +52,11 @@ static int rk_ahash_digest_fb(struct ahash_request *areq)
 	algt->stat_fb++;
 
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
 
 	return crypto_ahash_digest(&rctx->fallback_req);
 }
@@ -124,8 +123,9 @@ static int rk_ahash_init(struct ahash_request *req)
 	struct rk_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
-	rctx->fallback_req.base.flags = req->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
 
 	return crypto_ahash_init(&rctx->fallback_req);
 }
@@ -137,10 +137,10 @@ static int rk_ahash_update(struct ahash_request *req)
 	struct rk_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 
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
@@ -152,9 +152,10 @@ static int rk_ahash_final(struct ahash_request *req)
 	struct rk_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 
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
@@ -166,12 +167,11 @@ static int rk_ahash_finup(struct ahash_request *req)
 	struct rk_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 
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
@@ -183,8 +183,9 @@ static int rk_ahash_import(struct ahash_request *req, const void *in)
 	struct rk_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 
 	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback_tfm);
-	rctx->fallback_req.base.flags = req->base.flags &
-					CRYPTO_TFM_REQ_MAY_SLEEP;
+	ahash_request_set_callback(&rctx->fallback_req,
+				   req->base.flags & CRYPTO_TFM_REQ_MAY_SLEEP,
+				   req->base.complete, req->base.data);
 
 	return crypto_ahash_import(&rctx->fallback_req, in);
 }
@@ -196,8 +197,9 @@ static int rk_ahash_export(struct ahash_request *req, void *out)
 	struct rk_ahash_ctx *ctx = crypto_ahash_ctx(tfm);
 
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

