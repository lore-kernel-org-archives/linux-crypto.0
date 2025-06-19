Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B2D9251782;
	Thu, 19 Jun 2025 12:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750335862; cv=none; b=SzEp1/AjGeZ+GARuInfhkX0OdeDIKl+NxQXm5+thYGSAmnZrmgNaHuYfpzDREHl2fs5eOWp1Yrr19P4KyTjnt4mbKUYlfFT8iXi294hTPsGL8ASHwGbw6cmgAvXwrZVc9QdyNH6GySPNIUM7TaLnkYtmW3t2SDGzoxGtT9qvm/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750335862; c=relaxed/simple;
	bh=kINjivbB1+ylLn7tV9af00mOK273H9HJI0nMG3aaa1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WlPUTnkRued/pK8DmBlPCTPGXdyDje/rSlHX68ePlYV84/Z5aPGcTB8Pxdm1mZ9mX7UqwfYuZGrfg/+PdYyTjByteI73Zq7blJwO0CQFDEBtz7y0MVlgtDWEvI3qAt2d/JDpTvyGVeAJ9PlttMjXe0biWwkv0YCUq+Yq9kfy0H8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lTDfPL0m; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lTDfPL0m"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ad93ff9f714so135257066b.2;
        Thu, 19 Jun 2025 05:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750335859; x=1750940659; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SfOFmSReN1wX8YEf6gXPwdHyf/C+wiQacKthqWE/o4Y=;
        b=lTDfPL0miKfZwuGXmgCxxQOpvY96FPrqvC/hXxPCbdGdeMewst7EkbRV/9jQK7h6Sm
         pa/u7k5VshIK1GVmhxsvTFKaywScB24F2k7tO5cpIi3f0GEyX0/K0eYh/9VIFu/7wBGX
         ouALiMIBzu7VembSFeJn+uE9ywskkkVKPVf9NkCAb7jK6rYCNrsnDtvdEmj4PVdHiP32
         FMiufD8nCngV3jbyXzI38TJ19kyl2eGgMsIxN9mF7xBNb/MxEDtwfSA6qzAhoxSHK7jF
         kvYB8cKsEH8drgElp2Kvnzaq9qGviV0czIMz+MRhKJcGRKjun70kJSzFqhIGz5paidgB
         GMXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750335859; x=1750940659;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SfOFmSReN1wX8YEf6gXPwdHyf/C+wiQacKthqWE/o4Y=;
        b=I8hXAxN3YQq7tnA91EvtzsQR0c3PkwfkBvFL8E9w/EnTAYpgB30G/V+C60U6d9wk6D
         AHKb3/7UirBPkVj5cVi5+R3BOP8c9/hxyh7GBM1+Tr85uYA+5zczfw50AXvd0vmKkCsd
         A0JRSFKELmyBNUplXr+5VjvVafANFt97dj65h9ODeyjafmhnQeUXNaZDkeF+JXmAqe7D
         1PU0/A8OPLBiCDXsEYjfOvF4AuGkCbm5HE1prs6yL+NxMWT/b9EydlefvJSBNqXwac1B
         pwTUCxIuN5UM0k/a/U1+JTY5ub0myHIJilTJl2UMWQRhv75/UysqOVHbn8OTbczXnIAA
         qXFA==
X-Forwarded-Encrypted: i=1; AJvYcCURCESjHRd+5eAYFlg4xqgbBgBiSdzZ9gRu14M3gsxGa+gz0uW7dtGUb7ZskWI8P9dFiytTPapF8UOUs/g=@vger.kernel.org, AJvYcCX3dyf9v6Hi4Wh2azYLHU+c4FBIh3UsraGhxAPS6FGHkIl2mUq2Ah7RsG1cvp9RCSGx5XKEbn3GuqPnadDA@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3gdpXBO5wuP5CQ5sDkM4iD/vS5xKbNycXFn5waUXMmWQjFEla
	AwPcPIFjMiIdY0+esPAe8my4JDMmOD8f4DRDSrVgLvtzKEcunR9/7phb
X-Gm-Gg: ASbGncuCvfnWac/jHTa9hhatiSG3LV3lgoXy9npwM2pqh0q3j76ygh/Luv/DH54ghG/
	sV9vbAwGZHZ9FNbkx2cD0sau9ZQdHT0nSmr6VY+ujMTlOVTLSQW+3I9CWOlwwfu9thCMMwatH3C
	i5sdtrrr2OlqNuATKJIp29aHt7WPTqC6fFCq6gj13vR9MG0CsMWwkRLhGH9wCJwNWUZpTw4xLwD
	UOBKwPdjXrJ56+BNmdver0HYwDs/MSYcEpEz8jbJYPqdjcR4IBOiPBffIjEpwZnOM4oHFcckes9
	Vnq8+BCfAR9Y7fAceaLRpz9Bdunj0Lpun3Tzksf/4g6A/7Kw4vYykGLQjQocjtGsv5hvImsVX0K
	BM2pOhnNfkK3SQw==
X-Google-Smtp-Source: AGHT+IGEPeo5IOklcxib13+gmY/mAxR132u//d0bSaTarIv0yq4bk3Wfepb86FCqZ57HZAhqV1/TKw==
X-Received: by 2002:a17:906:c10f:b0:adb:3345:7594 with SMTP id a640c23a62f3a-adfad31e10cmr1852773366b.9.1750335858569;
        Thu, 19 Jun 2025 05:24:18 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae000b02bd3sm504688066b.3.2025.06.19.05.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 05:24:18 -0700 (PDT)
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
Subject: [PATCH 07/10] crypto: sun8i-ce - pass task descriptor to cipher prepare/unprepare
Date: Thu, 19 Jun 2025 15:23:13 +0300
Message-ID: <20250619122316.2587236-8-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250619122316.2587236-1-ovidiu.panait.oss@gmail.com>
References: <20250619122316.2587236-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rework sun8i_ce_cipher_prepare() and sun8i_ce_cipher_unprepare() to take a
task descriptor pointer as a parameter. Move common flow setup code to
sun8i_ce_cipher_do_one() and also remove the crypto_engine parameter, as it
was not used anyway.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 37 +++++++------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index 5fdb6a986b1f..d206b4fb5084 100644
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
@@ -362,20 +348,25 @@ static void sun8i_ce_cipher_unprepare(struct crypto_engine *engine,
 
 int sun8i_ce_cipher_do_one(struct crypto_engine *engine, void *areq)
 {
-	struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(areq);
 	struct skcipher_request *req = skcipher_request_cast(areq);
+	struct sun8i_cipher_req_ctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
 	struct sun8i_cipher_tfm_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct sun8i_ce_dev *ce = ctx->ce;
+	struct sun8i_ce_flow *chan;
+	struct ce_task *cet;
 	int err;
 
-	err = sun8i_ce_cipher_prepare(engine, areq);
+	chan = &ce->chanlist[rctx->flow];
+	cet = chan->tl;
+
+	err = sun8i_ce_cipher_prepare(req, cet);
 	if (err)
 		return err;
 
 	err = sun8i_ce_run_task(ce, rctx->flow,
 				crypto_tfm_alg_name(req->base.tfm));
-	sun8i_ce_cipher_unprepare(engine, areq);
+	sun8i_ce_cipher_unprepare(req, cet);
 
 	local_bh_disable();
 	crypto_finalize_skcipher_request(engine, req, err);
-- 
2.49.0

