Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3AA22DFBA;
	Mon, 28 Jul 2025 06:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753682885; cv=none; b=YH9qmwL1nP+Fry5s/Un1jMTHvXpD+MnZbbNy3z/DHwLraa2Qg/ezIly0poxw6KGOblHqkWW6ktRGhsYvtpNF/U8MilmMKmWG2tcXAG9Bu5fNSNBAA+WoFfyuES4sSfDSlBOLdacpupKhrudydCf5OeV6qdgwOHf14CLprPPyIkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753682885; c=relaxed/simple;
	bh=VLxVkCzDUptZN3MLV6XyYZWlwBVycUnPTFTRKmIikGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCdnzRH3IzXQ6RTNmOy4Gf5hTpv07WvLoafHOg0N2DNT/xdSVdOcmrr0Ri8dTk4AM+ijXnLo4pU2Bxomp58jE3sOkClXcTzIgB+AB/uvGQfnmB881VVfyqb/QRV/HJ6LfoK1OUT6ubzr0p876k27BAm+/yveAI+UHS0fQuKgezk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XwUZTu6s; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XwUZTu6s"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45619d70c72so36292795e9.0;
        Sun, 27 Jul 2025 23:08:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753682882; x=1754287682; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dlcibDkuEhs59MfzxPNpL2Xe4LDD/D/d8iw52Y6RVVM=;
        b=XwUZTu6sFswh4N/D9axZdSgzyQNUF/5z3vMf6VYQ7bJ77oFB8GFT0QxPC4G9tfH3Y8
         OMkPpyuTN14GK1YgtyS33fRK91XtW3smz6iN/BDWqrjE8gjXq6KSpD07XpBvAIQOQWcR
         ZX2QCgh+0jl53R+KBw8DuQGQ4bMEEL8N+y/K8e0Z4YIC/Bk5/wYY4f8owkLJbBs2yNof
         hlD4oaw36dmqOGLPdElplfKuUYH14bP6GoeW4h8cT9/4TsuLQ1syGqpZrdDsRsvVec6I
         5mfWhg5TrJPXn6+vVoQepgPF92w+skTbc/XggYAmYiCgX4QBqBnKatUZmyaU+TOjdzYp
         nYZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753682882; x=1754287682;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dlcibDkuEhs59MfzxPNpL2Xe4LDD/D/d8iw52Y6RVVM=;
        b=vceAFXJkJF7LEcbafGZoU+l/s4oqh9rOASI2ihfhz8n4hU8DSAjIflr4wcLQPOr90O
         TbO+mSue7dMhAAn/4aBH+uTvi4wYs9kN2g9HnDDiMcJuQzaQrLjk8mlp6DxPoqVp6g/R
         dpeoSe7Wcpuk7uC8R7O9PBbiiKw0r9Ze5Wld8w8YSyj//Bhaf7KsziGD2EaoZoq1Pyzo
         juaJhwtAHUwKg1TAUPTQ1WPFhHXKfgXPYHBgbTMqjNlV3B2m0s5ftE6Rrny5ah34hg2e
         poNk0iO5xB1toa6URZe6XOP7vz4B4QX9lgl56VWs8czgx+3qN83romlPyYl/Wm8Qs/w5
         d/sA==
X-Forwarded-Encrypted: i=1; AJvYcCVZJvMN1A+e8WMTbnJlmshPZpKS8oG+5A5bVZhylKS7106eKdbrer216OCFM9fGXrHzG2sdrJIUrFE3Luk=@vger.kernel.org, AJvYcCVkqlo2YuDWHD0Vxfw47BgMpncaBd8FXmpvpx19SsEtJ/ldY7dcNjfrUhLHjihoKBSayWE+Ue9i7hiKNAJo@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7moLXeRtfo7qfZZfh1OXtNo1gNzxO8inZ3wYiwWRViCBbgLYj
	AYKWuicGmtzUTGKGE8RXfG8iyxuX517OczWi+wGOfslkGwRmCv5STP+s
X-Gm-Gg: ASbGncuO1frqPRNSbjpkU23z8D6CLzCLgBAzrAi1Jzn8NaVOfLJO8UNGHl188XS98mX
	vbnWO+Na343w7tLm08Pgb/qx6Q5pw3qhAy+XT6Rq//yUOm6Kuc2sv5EJauFHR1LA+ZnC+l5nsdX
	JPpUbbDTa79EoCbigj/5qnNFM2YMNsaYTnjg39coC6SLU9LNu9Ye6yOyB4VmP8Agq/OXfJ+TXJl
	ot1+P5YZTbAcYbQiA8klcvZzStjDU67z6eZUuS3nETbt/teHDT40FVicihprA1ALJmvJk4GY3JG
	ZOSnEi55Nk5X5N7I1jEvFunzJimbGJNAYa1xLewhbDxr8gMlWO5/9IHsoy9NCgyBidqz9FrWBUd
	jNf0oX9ssl9GhDB8WrZzDq4RFVmiU1MIW9w==
X-Google-Smtp-Source: AGHT+IGpFevRNhf2Vrq4L9a0rQ+pWGEn25CUoR7Gcz+cBTBQUtLy+n5N/VX74UxKawJZYUhaHpYi5w==
X-Received: by 2002:a05:600c:1ca9:b0:450:c9e3:91fe with SMTP id 5b1f17b1804b1-458754bbe03mr80560255e9.0.1753682881878;
        Sun, 27 Jul 2025 23:08:01 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587abe6ba0sm86195215e9.9.2025.07.27.23.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 23:08:01 -0700 (PDT)
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
Subject: [PATCH 6/9] crypto: sun8i-ce - fold sun8i_ce_cipher_run() into sun8i_ce_cipher_do_one()
Date: Mon, 28 Jul 2025 09:06:58 +0300
Message-ID: <20250728060701.1787607-7-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250728060701.1787607-1-ovidiu.panait.oss@gmail.com>
References: <20250728060701.1787607-1-ovidiu.panait.oss@gmail.com>
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

