Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE8230AAA6;
	Tue,  2 Sep 2025 13:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819386; cv=none; b=V+b4ramq+yjm8LBDCrVTYAln3vTc4Qieq3T+gY6wKtlhTPwJy3xS965ZGHQNTnFgxcBVEcgqxA82pyHNSOOAaLx20VutBpsbfQqvSzFVz3qo8+qFEYklCHhP0mKW4oSkVH/HfEgIBow+Gm1HLBdbNkI8a7DV0QDI5FtxaxwWWPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819386; c=relaxed/simple;
	bh=VLxVkCzDUptZN3MLV6XyYZWlwBVycUnPTFTRKmIikGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMVEyK8oq0mEhN/RIYNxHNjZmxs6L9U3wmJnnE1/Hn3tMRQ/QPpOksG2TXjIwBOCqJM1MwEGSGAITgELHLvhTCkkefMv5TBAz6pAElyfAgNx5MxRw5n/hDtByHJdpVdFGW2QoHupi02w6mfbD5kwBWtW218BwNiLkhdCn/kJvCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K+/J6H5v; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K+/J6H5v"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45b83ae1734so23120275e9.0;
        Tue, 02 Sep 2025 06:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756819383; x=1757424183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dlcibDkuEhs59MfzxPNpL2Xe4LDD/D/d8iw52Y6RVVM=;
        b=K+/J6H5vUIqP3Al1LFRB2L8yjsY5BjyiJNO9YGz5MXX6RvPLTj5n3GAqjVo41HT3m/
         fJYbd9pm1JO7WWEe5OWU9ixXJGtEaCGbWjd8nosY4ZqK7g2vG5ViJaJZkcCn7r6zVHI8
         e5TKoav98Os2E/y9DUTb0aFE48Ou0LZRX5bm+jlhxiytNivVLqSlCpj1mkXz4JmquO8P
         3l/E2wb3LJLJVZwfskw2jYyXcLk7XOTv2gk4WAG25pw2YFj5ODTwWqJVgeirIlGkjZVv
         tZpfpEkZg5QtMHvD65VVZ8yeJxK80/XEtDjOnknNgiPWEZCbEiGWdFlnwba+ESiomAZ9
         EtYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819383; x=1757424183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dlcibDkuEhs59MfzxPNpL2Xe4LDD/D/d8iw52Y6RVVM=;
        b=b/Ptk60R3MHtvZtAcXHjxJ8JRXyluVelXSiFtVtaVDri+SaBrQkXIodt19GxLeG1Zu
         MtZdEzIau8YO1W/BOD+pGi/IDl0fvW4PtzMDXOPA3slcdwTttD8jSC09xkjXnMBGwjFI
         bN3nLXTAYUOhAVZVlFCm16pprSE1P08OBMntuxD3Mt7zXEMHoDvNs155+9rDUG+RcMBU
         rFuVSMXGo0x5EdtHOm3UcfMhw8BbrqubnP7tyPSYDTd3CzhE05l28XgeP7Fm0HzVt0+Z
         aZhmbtue7PYWtkjgTUifntoytQeZ9wr6KYXt2hwkPwYEHbM+d/aWx8cjAx7gb6Yr6I0V
         +68Q==
X-Forwarded-Encrypted: i=1; AJvYcCWxVfYl037Dv/1GYgtCtD87d4E/g2uWW8MO0cFwUtx1t0WK5ChjFCm4paKvk2E3gMKtgFCDIQz9f2bJCz8=@vger.kernel.org, AJvYcCXRMBANzxSQK2OEZC+h28SGEcNurp7PjxSroP4rJeYuwNAmOCJCi5zYzbR/rgU2SdiIKooi4O0pGohvjtpm@vger.kernel.org
X-Gm-Message-State: AOJu0YwCKN4CCiJ0HOi1Ao4jZ2SkHkT9LTk4F96a5oNrZq9u6r3AYnn9
	iRd3zLP4u+tn1kJm9vrBpd1FN6Zl8TNE/bLujzpP358WPouulcVyLbvN
X-Gm-Gg: ASbGncuYCdHCx4NISMnKMi/c+Es0Bouv+kQZ9VncFD7hRJjUtR1ofzRJDdzgYZKWCs9
	J9F9hPlH3UDScl9xyOzs6Uh1ZrNs4eRIM8BahsYHjNJcRx2UzCHz3cXGfwJuPOPFWv578gFXl93
	1ZHBLvntQUtvEvAz6+AI5rFEYoky2UXg2SogY1uoAofkN68s0m9+UQMbAJq77B1auqIaHCeHkk5
	+qgVFF5vHAC6eoVGZO1rnJH3JhnUS7uLioISvRWHs2ca8INx3eN1hHXu5NTzjcUHpQ9+OjssYt+
	KHT+Lln1hbGjnvh0YuBQFB2QxZqCpASbROwEjC+v+QAPWP7sfpBVuy/ujEflZG/67eluzZ/JQ9N
	qxI/GbArJlBRQbd5mpDTWV0EJVZ053Nx+zA==
X-Google-Smtp-Source: AGHT+IHVnaSqlqqL4i33vbnl8DxH3Zomz9ikQnMsjbbKikajW7iV7MsBCgP8xKySewSnOuFEhpUjVQ==
X-Received: by 2002:a05:6000:1ace:b0:3cf:3fe7:2203 with SMTP id ffacd0b85a97d-3d1dd81d0a4mr8042987f8f.7.1756819382532;
        Tue, 02 Sep 2025 06:23:02 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:c207:b600:978:f6fa:583e:b091])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b945332adsm44452155e9.4.2025.09.02.06.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 06:23:02 -0700 (PDT)
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
Subject: [PATCH v3 6/9] crypto: sun8i-ce - fold sun8i_ce_cipher_run() into sun8i_ce_cipher_do_one()
Date: Tue,  2 Sep 2025 16:21:31 +0300
Message-ID: <20250902132134.3287515-7-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902132134.3287515-1-ovidiu.panait.oss@gmail.com>
References: <20250902132134.3287515-1-ovidiu.panait.oss@gmail.com>
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

