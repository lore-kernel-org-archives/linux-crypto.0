Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E25212F98;
	Sun,  3 Aug 2025 19:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754248274; cv=none; b=tVaaq662EXhXNkCFRGjBEKMDfPchYCwZVwffoSeasrgTaeYWwS/9bhS11hbG752xZ5C5bUUmEqMoEb4YL8tT7C6/hhYk0TZcwN6ll2DBB8z2mptpyOLi718GKC02wOm5HxhHNe4z0IfOpNZoeVekNcRi+J1KfGef987jJD5AfRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754248274; c=relaxed/simple;
	bh=VLxVkCzDUptZN3MLV6XyYZWlwBVycUnPTFTRKmIikGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyixRnT82dcthX3KK50sLJ6EyNzJUYJ8b2Xt5oVcu3noxjldfuDxZrrowIfN7/EjTiF0sOQFKrr83u8nS/LGB8lMpTRo6oLNOZ4XldC5cXbOd+vTBlLIzOZUEZHf/Lem0awyurn/qcCq0fjiAGXo4T/SU1jDa76iYKBsrOeyguo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AKskXXl8; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AKskXXl8"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-458b49c98a7so11995875e9.1;
        Sun, 03 Aug 2025 12:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754248270; x=1754853070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dlcibDkuEhs59MfzxPNpL2Xe4LDD/D/d8iw52Y6RVVM=;
        b=AKskXXl8DGL9ir/m6who0hh5PkHdAR6hDSs5WBYkFKLfmqyrnsZFEHMA0RRIJYFh4z
         dHhbmQknv94PS/rWuX/3GonXZiBah0gpiqwxCO11c0evtoSH/JudwPCfBeDQDuyv5H6+
         6ZVXqgzN+8oePmn5rkJpnPq9EWgPDpDjwhClKx9dqQNSsgjkxpQR995eH3I2NMsYAODI
         R7pNPJigK+I3slg0/g84W89qt7wnNUP1OeJjUhfPH9ytyyx/qHvZNQOK+3mV2E9MRXcs
         EEhxOQTDxAdbd6chHPcnvU5URB+xSKTQMT+c0JF9tJYEkh2bbmzSVkYOcGq+1FY0Rue2
         OTPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754248270; x=1754853070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dlcibDkuEhs59MfzxPNpL2Xe4LDD/D/d8iw52Y6RVVM=;
        b=c3D4l0cVXYhlHyyKQyCELANWmwCjx2YbTrEimdbcuPdPS0AV+3gIrxPZIjEJLG7dZn
         1/IGvb096Hazrd6bu3WPMH9dz6mOrHWGeMoIH3XAs6QjGZ4MaQnqu+XDa5UELDbN+hUe
         MrQI2hwiTAL4oTo221qqU/CW6jAs39z9uLQl+9ljqwhpTiZclRAG3NLunCb5AXJobbd2
         Z2SjRUHUNCHpa/YFULTil/iefFHTQGnJov/1AyJtSYjPSLsyQlbLwG1vponxRNk3DG+j
         wk63yUxECulxmfnZKfi5ZyVXf7vXzKLy5MDUinEEsj/SBS9VvMQMCFUEBd47f4E8sUSC
         SF8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUviwJrnyfIsKyUvJTe15TGxrDwsgXQ+zGo7pSjcnUIY39qGRhGi0z2y5CbVBISoVpGAd3DmXN7ZdfNu3c=@vger.kernel.org, AJvYcCXTxCerree0qY9Pp8KCrNOUEXyv77eFtzooT3l85C53pqMIsCGIYJ7SU6R0R+5IhKHT+XAs2tatUfgZ7YN7@vger.kernel.org
X-Gm-Message-State: AOJu0YzJIz2VT2AfeWyruX4+cO7rN3f0ckKXTXP+C8GhbK/2a4MM3TpQ
	NISHs4gx6PlB4Bai3yjm/kXAtMiBuUGEDikbrp5xo3wMrrwx+AELNjkb
X-Gm-Gg: ASbGnctB5qDiBM4HpndXQ4lSC5Rz0BnW1wSXBCwZ5510W7h5XI1UD+6J+ueRA7beBMA
	K31poLKEebZsE4zU91Os0WYnDryIBJbOOCk6tKRQsmZ+6gxWi9JpoZXUAhTPojnvKXxKcsETzjp
	gbSOvDEM5Mum0ab460UI5tJDLDRFGhUIM1TuqUlfiFy4pGdzKeYK7oewG0rUNPcQHK8o4J+b2+A
	z09xZKFhUmrYHkwtOsl/QH8tC9Hq+1OhzqpJjqvwxnfBvmOZjPvRsnLIcXONvESkwAL/YceeoOZ
	DzksACsQbZaKvWtPMxLKjTlBF9A2Qhhw634/DJyyvMKDjxtXA3KBN6H4E1oM+6qOO9oC2dREtFf
	QygkU84MYOvCWv1TluhNMcjDDgm3MMH8r5+3L5t3AORBi
X-Google-Smtp-Source: AGHT+IHtfKq4zUbwXfC6aQHk7cG+DjOfnqmfBGllrsesIhnmsE+kULjZ44WqEg9ZZudwAxTaMk52SA==
X-Received: by 2002:a05:600c:19c9:b0:459:d494:faf9 with SMTP id 5b1f17b1804b1-459d494fd04mr22075015e9.10.1754248269489;
        Sun, 03 Aug 2025 12:11:09 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c45346asm13099210f8f.39.2025.08.03.12.11.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Aug 2025 12:11:09 -0700 (PDT)
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
Subject: [PATCH v2 6/9] crypto: sun8i-ce - fold sun8i_ce_cipher_run() into sun8i_ce_cipher_do_one()
Date: Sun,  3 Aug 2025 22:10:26 +0300
Message-ID: <20250803191029.3592987-7-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250803191029.3592987-1-ovidiu.panait.oss@gmail.com>
References: <20250803191029.3592987-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fold sun8i_ce_cipher_run() into it's only caller, sun8i_ce_cipher_do_one(),
to eliminate a bit of boilerplate.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 35 +++++++++----------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 69ba8236cf2d..f63d21cd1e52 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -360,31 +360,28 @@ static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
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
+	struct skcipher_request *req = skcipher_request_cast(areq);
+	struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(req);
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
+
+	sun8i_ce_cipher_unprepare(engine, areq);
+
+	local_bh_disable();
+	crypto_finalize_skcipher_request(engine, req, err);
+	local_bh_enable();
+
 	return 0;
 }
 
-- 
2.50.0

