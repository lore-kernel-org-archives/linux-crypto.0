Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3E0214814;
	Sun,  3 Aug 2025 19:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754248274; cv=none; b=uSvAMxoMDM1TX8jFMNewoh0kYUhD9dOz84RhPqQ9cd8fSLCT3mIhXMTYr9uB5ojVNnzViknqF0UHlk2OAwP+3z1YVW/KhsRSlM8jFBSVbFen8H7nCf+fYOIPPulCENR9yT+05yNZnyMleG6zgavSBtkPXPGfJhmfuJmriR3oriU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754248274; c=relaxed/simple;
	bh=f6FBfJ2O2GQ3lk7rvtQvn1UblRaOsewFE81eXurpKa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vb6E9nDg7xD5GU8GUb5d80jXquxOsjAXRgABdkjI2VgbvaKZ4cEkFOWaorOn0jf/XHP7wr81u/56Ziu9xWhXAmmHaUKHbXjhxLUNXA4fPMaGwkCDC+sKQz0LUIALNpk8KBZtDAfaXf5g1Uvc74iVkBCwm5WlEEzOUgW3hweve+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ifkfe/Nn; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ifkfe/Nn"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-454f428038eso31245395e9.2;
        Sun, 03 Aug 2025 12:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754248271; x=1754853071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XM9OSoT7EEhuPBZA6neX1BQbhTIUd6+o400NZdJKrYY=;
        b=ifkfe/NnMapXq21xYKYdFK93Il8cMsjKakbDdFAYrK/hjlBxevX/LdDPt7Yp/MMWnI
         BOqMSf2TmF59riwFhGLO5injL/Zs6la8V3aPu147lDEgqeH80itHSccQaIy3321A2OWx
         WSaNlHwEikdeafQshmnZ2rne5MN7TAhp1VyZvI9hi+nTNycmNdoheAeyIBBiOJuMKzhZ
         DJakXK5WHaZnhfNl3E8sZLuFHifAmx3/FHTzwvaX/nOLh2cuLxo7/0sDFtq7RDk7BGZy
         ibnQtT8F3zeS6CEUAc5HhiSAjVrfheZYw7rDD/w7gVqy/MUDKe24Sce6R40KXnrxNCeM
         luXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754248271; x=1754853071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XM9OSoT7EEhuPBZA6neX1BQbhTIUd6+o400NZdJKrYY=;
        b=rn1zfEhVV9nSzUu24BdhWMsYuJmKPdb1vLrCXjCw/kUSOWZZe1IRGwCP7KJ7L8R9z/
         HD4nU7LJV5U23gsfdth76+TxzPKbB8APQksfWUeT8sJAb4QT2sPmdsxu0GreUa9ShnQJ
         Gw4emzdWLxN+MoMK+PmtMWcDVGdJBENiLhs3+ep39Jar5TAuCtqWVCVQn47QvUqjnF1F
         RQyRJpI174+j075MTo8z/ibMjcmw/AsZZ0Oa3NC1q+7bVFD0A+J2bNgTH5PADZNqyjf9
         N9hvgq3cYzp790XisdlcurAUKfdD1WGolJNVvZZxIIIg2V5PI0YK33r/VqkAEbSHuuCj
         fDjw==
X-Forwarded-Encrypted: i=1; AJvYcCVyl/y2pTb7rJ49BBjHJJGO4ILkhOb4zfHRH7bcKKbvsm6xR3WkbI3v/zRDWLkGm5mEVTtqXgJjMcan7XI=@vger.kernel.org, AJvYcCXD8DIwUfm0ILlCNIz3twnUA37AvbrxE/lXR/ACO432e9PswMiMON4RShFYJuoBDfTvF/Ozn1cJxYLa7l7b@vger.kernel.org
X-Gm-Message-State: AOJu0Yxi2APAm34FEmwyVSXhewQujr570dMcqDVKoxEshZ0qzwfXTueV
	1ZCZr2toZFbSH5xj3HTlWyJEDEnNr16szySSZl7CA3mG5Iyt+xi8L9Du
X-Gm-Gg: ASbGncsQcEbwYhghNlO1lh9w1uH4uz+IRyuFTibqA0Je9fjYlwvyf5EQu3ID/s+OBvG
	r4mPwBJH9cA9ze9HeYpTWFzZ52ueMPM0k9fwlYhB7T8V74BFjmbaavZuLC4IFj4gfOZLSXqqjrk
	T75HB0puXjzdpriDAd/DtEvnBX6xJ1EZ56WaDVgqeVr1VxAZ1sIWnVA8tURmQpXDaGtAwF29xmU
	bnibc7HhzL18F3RRVfpHVFAsaHhVcusORJXgZyQti0Wxyxz98k+KHr+G1tgHCk9tqeJ728FzwAQ
	P/I9F2qsTOdYcZGjpgW4iKqfADyGRMzHPfzsFBkgkycexjgTIFuucPWuhyMnjjVshCDx3h0eW1K
	dnyeoMr8NJOKKdHNl8sDV0rZKJ5dwr25vag==
X-Google-Smtp-Source: AGHT+IFrM0QM4YzPRURXac5BvBdFWZFGquBGzZldZ3BzPlquCbea+9B7z4XeK2D+7m4BeFHALnhLcg==
X-Received: by 2002:a05:600c:1c25:b0:456:27a4:50ac with SMTP id 5b1f17b1804b1-458b6b3d871mr47422325e9.23.1754248270728;
        Sun, 03 Aug 2025 12:11:10 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c45346asm13099210f8f.39.2025.08.03.12.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Aug 2025 12:11:10 -0700 (PDT)
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
Subject: [PATCH v2 7/9] crypto: sun8i-ce - pass task descriptor to cipher prepare/unprepare
Date: Sun,  3 Aug 2025 22:10:27 +0300
Message-ID: <20250803191029.3592987-8-ovidiu.panait.oss@gmail.com>
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

To remove some duplicated code, directly pass 'struct skcipher_request' and
'struct ce_task' pointers to sun8i_ce_cipher_{prepare,unprepare}.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 33 +++++++------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index f63d21cd1e52..021614b65e39 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -131,21 +131,19 @@ static int sun8i_ce_cipher_fallback(struct skcipher_request *areq)
 	return err;
 }
 
-static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req)
+static int sun8i_ce_cipher_prepare(struct skcipher_request *areq,
+				   struct ce_task *cet)
 {
-	struct skcipher_request *areq = container_of(async_req, struct skcipher_request, base);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
 	struct sun8i_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	struct sun8i_ce_dev *ce = op->ce;
 	struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 	struct skcipher_alg *alg = crypto_skcipher_alg(tfm);
 	struct sun8i_ce_alg_template *algt;
-	struct sun8i_ce_flow *chan;
-	struct ce_task *cet;
 	struct scatterlist *sg;
 	unsigned int todo, len, offset, ivsize;
 	u32 common, sym;
-	int flow, i;
+	int i;
 	int nr_sgs = 0;
 	int nr_sgd = 0;
 	int err = 0;
@@ -163,14 +161,9 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
 		algt->stat_req++;
 
-	flow = rctx->flow;
-
-	chan = &ce->chanlist[flow];
-
-	cet = chan->tl;
 	memset(cet, 0, sizeof(struct ce_task));
 
-	cet->t_id = cpu_to_le32(flow);
+	cet->t_id = cpu_to_le32(rctx->flow);
 	common = ce->variant->alg_cipher[algt->ce_algo_id];
 	common |= rctx->op_dir | CE_COMM_INT;
 	cet->t_common_ctl = cpu_to_le32(common);
@@ -314,24 +307,17 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 	return err;
 }
 
-static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
-				      void *async_req)
+static void sun8i_ce_cipher_unprepare(struct skcipher_request *areq,
+				      struct ce_task *cet)
 {
-	struct skcipher_request *areq = container_of(async_req, struct skcipher_request, base);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(areq);
 	struct sun8i_cipher_tfm_ctx *op = crypto_skcipher_ctx(tfm);
 	struct sun8i_ce_dev *ce = op->ce;
 	struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
-	struct sun8i_ce_flow *chan;
-	struct ce_task *cet;
 	unsigned int ivsize, offset;
 	int nr_sgs = rctx->nr_sgs;
 	int nr_sgd = rctx->nr_sgd;
-	int flow;
 
-	flow = rctx->flow;
-	chan = &ce->chanlist[flow];
-	cet = chan->tl;
 	ivsize = crypto_skcipher_ivsize(tfm);
 
 	if (areq->src == areq->dst) {
@@ -367,16 +353,19 @@ int sun8i_ce_cipher_do_one(struct crypto_engine *engine, void *areq)
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sun8i_cipher_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct sun8i_ce_dev *ce = ctx->ce;
+	struct sun8i_ce_flow *chan;
 	int err;
 
-	err = sun8i_ce_cipher_prepare(engine, areq);
+	chan = &ce->chanlist[rctx->flow];
+
+	err = sun8i_ce_cipher_prepare(req, chan->tl);
 	if (err)
 		return err;
 
 	err = sun8i_ce_run_task(ce, rctx->flow,
 				crypto_tfm_alg_name(req->base.tfm));
 
-	sun8i_ce_cipher_unprepare(engine, areq);
+	sun8i_ce_cipher_unprepare(req, chan->tl);
 
 	local_bh_disable();
 	crypto_finalize_skcipher_request(engine, req, err);
-- 
2.50.0

