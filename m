Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5A302D876B;
	Thu, 26 Jun 2025 09:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750931968; cv=none; b=tMA7Fx4HpazyaQleJ/P1LysPlgvrV3K6V6kNTG+2L2++cfJLXupvKMiDnASBlthUreeVS0jeNGaBy3suQjjTJ6JCwhzcPpBhsoRWHMDh2V284Yu4TvFLNhvxRX2MvyjO3ShjNEcbefQRjvJOuYZjmkrX20H0ONhrtXQGu4CCKTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750931968; c=relaxed/simple;
	bh=MVmmWlPksmaiBVibi00qDI48RIUv844ifSFHgrjus/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFDi6iWOeej488pcUgjPM/r8PdHLdX671pQF8QYtYJwYMm0LJW4yAB0PX4VIp0fzfHu1SbUl2S1BgTpJvjMUebLyz81w9cBx5Quu5SCIuAkpNmf6oqHzCDAz0520H24G5yl+SoXHL3VoOL/SQhH5mtUsW8simW1FYhpk6U1A7jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aAvx8EzQ; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aAvx8EzQ"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-60789b450ceso1406769a12.2;
        Thu, 26 Jun 2025 02:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750931965; x=1751536765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOCWgCxa5TuHqEzs7P/Xd0Uu+UeKSk+lfEEEEay9BLo=;
        b=aAvx8EzQx+3Wbw17Wa5Bx7efFdS4LR6GxbYF2Z3yrPsbqiM0FLLA0VMauLc2SGNwE9
         SFRUtEXBnhmxy+Cq3sXH92VgK/M37SI0Zkfd6P9xLGIdNO4FY/4/kWjmxsJHgZ89H0cq
         tXzlsNOuN+5bak54QbU2HALd6DqGSnRYo270n4U50ogc1tdOujHQdJEFfsMlIt43jb1o
         JV2d8LfoFybl6WzL5/Qeo2yXUlkY8+ipXJdvu3ZguHTNzoulg8iH8f1EDG2OcP38Rua5
         oZ6uvXai9d8bpGuecbIgqh09rtFKMbG+2Sg0WwryyNTaAy4Tzq9EiqpG8LR5mIbyrGaJ
         iFnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750931965; x=1751536765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nOCWgCxa5TuHqEzs7P/Xd0Uu+UeKSk+lfEEEEay9BLo=;
        b=lmUoatQq9qEdl9yyw800/I2lTS9Qn9p8v+dQ0sqW+BVJT7P41cuQNb44rr7o4lDteT
         p1FkJxsRvh5uX0Qeh9pvNeiwNztkaJS7Ky3VJ0vKcWlwTocBoTi4FIpmOFJCIyz2VaQo
         ToEUC8mQAt/wDg162aqu6qlspTiHtGb1ZV16lHgs9Js2UA52sUG8gdrGdQ8dKvvLCrrM
         64onrcOVs9CmxNubTaNGJFgzjfb2nbbOkKn0Odqi5ZBuR0vNrvNHPYF+wFfxYyMFby/L
         pYOxftXPqrobeCGMWFUZnXXu17+OlyYrdkSDvwv5spKDtCkj1zj01HdIM/yidhG1sD8T
         5X0w==
X-Forwarded-Encrypted: i=1; AJvYcCUO1r1PH0Y/YM1pPunMM54FPZ7AXnUmTAWx8rPK6MyD5V0GlY6k7/X3DIvOV9DXdjAd+3AMHM73hVPtGu4=@vger.kernel.org, AJvYcCXyuC9qGf5SjkKFlfOc2LG7c34jz/DZRKrz9omYNwxBERiGXOgJppJCIW4+vm6jrgSqkL4nQ7YC0IPvaGlN@vger.kernel.org
X-Gm-Message-State: AOJu0Yxvvvw5fRmAnyBzF8oGx8w2vgNOJDnGehi8PvG0OVCEGTEbfp/f
	hBNNUbbXCKz6/30f3AaP/4wftZuUlKtewGMrymrnxg3sJVcqYfG4Ghjr
X-Gm-Gg: ASbGncvy8mBtdRBbkRsP27OCafhmhpFepvJ2Fv3UcPp3ZrQclicbEulNP0yJgb26fes
	70tgvjMQELmX796CZmzoPp24r7sSkEW00m+rjK76h3zrvqumSb170B31vYIcgr0iHAlfF5XjPj6
	5Rb3+xDI8mAP1+Xgj/bVLRcDQmcUj9Mn0YoO2LBxbCue2os2tzJUsokRiNPYTa71vcWv5sUjyXH
	/j150dnOA8MTci6xH5Ts3e8NoaH5t2JbfWVxaZ16yTbgYgfBYLYX5HtsMD3+P399rkapfhbLmbX
	wNHVwKH5utcLS/sSzcPTIYjtApmb9/b0yMDmDgoZ1Kd7Xd7/lTZFZU2F7NCGpYAQHVeb0pvc7ts
	LB68Z/tijxX+uJA==
X-Google-Smtp-Source: AGHT+IFXLtDWsVLMRJFKSM7ZfKEbTxaY7obk208Kuz4qR9WlO3f5+snTWFaRNwrAjl6SXIyIm+JgZw==
X-Received: by 2002:a17:906:33d5:b0:ade:cdec:7085 with SMTP id a640c23a62f3a-ae0be893190mr488892666b.26.1750931964994;
        Thu, 26 Jun 2025 02:59:24 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae06aa5ff34sm1014106166b.40.2025.06.26.02.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 02:59:24 -0700 (PDT)
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
Subject: [PATCH v2 06/10] crypto: sun8i-ce - fold sun8i_ce_cipher_run() into sun8i_ce_cipher_do_one()
Date: Thu, 26 Jun 2025 12:58:09 +0300
Message-ID: <20250626095813.83963-7-ovidiu.panait.oss@gmail.com>
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

Fold sun8i_ce_cipher_run() into it's only caller, sun8i_ce_cipher_do_one(),
to eliminate a bit of boilerplate.

This will also make it a bit more clear that the skcipher do_one_request()
callback follows the usual prepare -> run -> unprepare pattern.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 34 ++++++++-----------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 9963e5962551..5fdb6a986b1f 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -360,31 +360,27 @@ static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
 	dma_unmap_single(ce->dev, rctx->addr_key, op->keylen, DMA_TO_DEVICE);
 }
 
-static void sun8i_ce_cipher_run(struct crypto_engine *engine, void *areq)
-{
-	struct skcipher_request *breq = container_of(areq, struct skcipher_request, base);
-	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(breq);
-	struct sun8i_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
-	struct sun8i_ce_dev *ce = op->ce;
-	struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(breq);
-	int flow, err;
-
-	flow = rctx->flow;
-	err = sun8i_ce_run_task(ce, flow, crypto_tfm_alg_name(breq->base.tfm));
-	sun8i_ce_cipher_unprepare(engine, areq);
-	local_bh_disable();
-	crypto_finalize_skcipher_request(engine, breq, err);
-	local_bh_enable();
-}
-
 int sun8i_ce_cipher_do_one(struct crypto_engine *engine, void *areq)
 {
-	int err = sun8i_ce_cipher_prepare(engine, areq);
+	struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
+	struct skcipher_request *req = skcipher_request_cast(areq);
+	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
+	struct sun8i_cipher_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct sun8i_ce_dev *ce = ctx->ce;
+	int err;
 
+	err = sun8i_ce_cipher_prepare(engine, areq);
 	if (err)
 		return err;
 
-	sun8i_ce_cipher_run(engine, areq);
+	err = sun8i_ce_run_task(ce, rctx->flow,
+				crypto_tfm_alg_name(req->base.tfm));
+	sun8i_ce_cipher_unprepare(engine, areq);
+
+	local_bh_disable();
+	crypto_finalize_skcipher_request(engine, req, err);
+	local_bh_enable();
+
 	return 0;
 }
 
-- 
2.49.0

