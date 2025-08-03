Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BEFD21C188;
	Sun,  3 Aug 2025 19:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754248276; cv=none; b=jjKl1XTeoIIZQExeejZDfq6/jE3EBIx1N6xzseS+v/AxR6qpnYvW/jPRvCGyW6/6WUDvsqnD9vYQOXS9VZOmesmWBs2FVFUdUjJ1ZkLwAuhTwa4PLeLgJlB9fzwvbcNkVaM1L1v6JQt2AijWq3pYinRKP+Cp17ic2/sys0cExgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754248276; c=relaxed/simple;
	bh=J9ebtys+gOadsS+t9/vBdipuMTDeR7aQZjcVU3lSpuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tI0UdAq+cZjiPM0TFWCXQB36gLbCptjmZ+ptALIV1cWi9KQGjy7dsFtcO85SBzU2g4SPSlcZJgpBoC+imPHLQxkUsg8m9w6OiBsfMyFJthBOHQ4jhgODOPTgof/0oxiGk6fxwcyeAhYxAzE/Bkhxt5pjLwn9Fe2T6qnpH0IHYe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=doxBc1tg; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="doxBc1tg"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-451d3f72391so32270725e9.3;
        Sun, 03 Aug 2025 12:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754248273; x=1754853073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5OquH3bzsfHd+3HPbbgh3jCNSZfVC5bnpDs/2otunY4=;
        b=doxBc1tgP4sE1Xcwb5GCt2x0Mt/LUZC70VyVU2Y+/frfBUqvIEl1OBt94uhiNGty4v
         cw3y7O7lFl4/znHKGk+W/3ZnBYcKv+dSpHbsiRbUn7OXpePMmD59NUiAhQokrWlbPmhV
         e/DwJE7ivz+kFgKgXePJYx2uIAdo4bn1ZfNNpqewTPVqCqOGxa8torPl1XszHt/IqWMx
         /uTkll83HnG5k1cUOjX7EmZhxc5/4Kg7WRayb2tyo7N84RcaR7Dv4vJJPUKJ7xJZOqEG
         yLpDS/tXuQgHNPXO1/vidmoEpthgLjfpgmuKF524rsiNavcuVStrs74j1jEdfwqsdBm6
         saFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754248273; x=1754853073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5OquH3bzsfHd+3HPbbgh3jCNSZfVC5bnpDs/2otunY4=;
        b=t+YHOekOTPd0Izxr0MwVtEqpEVQAYrJiybhZy3TsH7LqWmADHJOtaqOeWQRAdLCEtU
         hkjkIi9/WpTNWMZd8nyOYpoTTgg94/HZ/qVh2XkLXVbPt2fJN+IaQvvzgtNS5micXd13
         7nOp4lyNmWLn+hWNgYu6ZVTgg98cfg20LxLOu9kozaMCb+4+y20o9s/628NuIYq9ZS/O
         KX6ni2VmlrZbs4yBvVnBKWKP3El/159HNQlPG+hpcXvSHzWBfYfCzUYaP0hhdhVza7qU
         09KlUuwtMwimYTTc8eWg02mNtVB6RlsUxcegITlwJ4lysLsC3ZWPYHO71sFMeHlhLYSf
         meCA==
X-Forwarded-Encrypted: i=1; AJvYcCVdslYgYSXQIucDWQnkTOgLz9PS8+7ZiXb4Pa8OG6j7L3QYuKH036z9mikOy/k3a0Jlt4XtOHG7EvJSJq7C@vger.kernel.org, AJvYcCWZZDCe7d68LdbEMkpvlQzaXptE53sX/36oH0gCL8kV5VjXBDesYxfUkx5LDrMsrHWXQp4jpZEUB8Ulv7c=@vger.kernel.org
X-Gm-Message-State: AOJu0YyiM/k8BqUbTYRvKGlmG0IA0dSJ4Iz6CoREaDUW+DC1QbRi9Wpy
	JGSTC0RPwSxghd2d45xD51OoEAiY5GyBOCCFmGSrwGZPS63tsF26+t/3
X-Gm-Gg: ASbGnctdyIIw4+Q48FUFB58CV5DjaEb5ZUte2liBJ0A1nA/6vnxcrZe517hWTAc2NU0
	bIm34n+hwcsrzctXBMxri5k6ldBEvji/oomSJ5NZ0qiCIxymdFWri/0Mg47lQKTd7QjE+DOwrKo
	m0y/zHIM+HY9eBIeDgO9xlAOw0obcwiPwYPcHVXjJ87d09ixED9+eY+rHMxtso/YO9g1kJ8daYs
	ynAOXyTE6FWe40G3dJIzrJC2NLs+Ev4JBPHGLGoIbVGU6thRlTdC3vrf/JYJirZBoj5D1RVY02t
	5p4bmdXtO1pEeiUaB6Gmc85Kwj0QbtWsh1/3brtjEWs5agi+hMNcEGeHbXKYBODQ7ICgcPq7tJF
	K324L5GpZkQPN6ouz08NBJqFdSQQ220AOiIe6b6dgUjeq
X-Google-Smtp-Source: AGHT+IGpjk4CRmkJ8M4LqTsc8/ENOgpA5it89IFM3cfJG0O++/wGGjyhzDfblVGHm0OKLzdq4SaUOQ==
X-Received: by 2002:a05:6000:2f85:b0:3a4:e68e:d33c with SMTP id ffacd0b85a97d-3b8d94c4caamr5017378f8f.47.1754248273270;
        Sun, 03 Aug 2025 12:11:13 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c45346asm13099210f8f.39.2025.08.03.12.11.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Aug 2025 12:11:12 -0700 (PDT)
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
Subject: [PATCH v2 9/9] crytpo: sun8i-ce - factor out prepare/unprepare from sun8i_ce_hash_run()
Date: Sun,  3 Aug 2025 22:10:29 +0300
Message-ID: <20250803191029.3592987-10-ovidiu.panait.oss@gmail.com>
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

In order to make the ahash code more clear and modular, split the
monolithic sun8i_ce_hash_run() callback into two parts, prepare and
unprepare (therefore aligning it with the sun8i-ce skcipher code).

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 62 ++++++++++++++-----
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index e28100c07b86..70c761baf847 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -312,18 +312,15 @@ static u64 hash_pad(__le32 *buf, unsigned int bufsize, u64 padi, u64 byte_count,
 	return j;
 }
 
-int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
+static int sun8i_ce_hash_prepare(struct ahash_request *areq, struct ce_task *cet)
 {
-	struct ahash_request *areq = container_of(breq, struct ahash_request, base);
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
 	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
 	struct sun8i_ce_hash_reqctx *rctx = ahash_request_ctx(areq);
 	struct sun8i_ce_alg_template *algt;
 	struct sun8i_ce_dev *ce;
-	struct sun8i_ce_flow *chan;
-	struct ce_task *cet;
 	struct scatterlist *sg;
-	int nr_sgs, flow, err;
+	int nr_sgs, err;
 	unsigned int len;
 	u32 common;
 	u64 byte_count;
@@ -344,18 +341,14 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 
 	bf = (__le32 *)rctx->pad;
 
-	flow = rctx->flow;
-	chan = &ce->chanlist[flow];
-
 	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
 		algt->stat_req++;
 
 	dev_dbg(ce->dev, "%s %s len=%d\n", __func__, crypto_tfm_alg_name(areq->base.tfm), areq->nbytes);
 
-	cet = chan->tl;
 	memset(cet, 0, sizeof(struct ce_task));
 
-	cet->t_id = cpu_to_le32(flow);
+	cet->t_id = cpu_to_le32(rctx->flow);
 	common = ce->variant->alg_hash[algt->ce_algo_id];
 	common |= CE_COMM_INT;
 	cet->t_common_ctl = cpu_to_le32(common);
@@ -433,22 +426,59 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
 	else
 		cet->t_dlen = cpu_to_le32(areq->nbytes / 4 + j);
 
-	err = sun8i_ce_run_task(ce, flow, crypto_ahash_alg_name(tfm));
-
-	dma_unmap_single(ce->dev, rctx->addr_pad, rctx->pad_len, DMA_TO_DEVICE);
+	return 0;
 
 err_unmap_result:
 	dma_unmap_single(ce->dev, rctx->addr_res, rctx->result_len,
 			 DMA_FROM_DEVICE);
-	if (!err)
-		memcpy(areq->result, rctx->result, crypto_ahash_digestsize(tfm));
 
 err_unmap_src:
 	dma_unmap_sg(ce->dev, areq->src, rctx->nr_sgs, DMA_TO_DEVICE);
 
 err_out:
+	return err;
+}
+
+static void sun8i_ce_hash_unprepare(struct ahash_request *areq,
+				    struct ce_task *cet)
+{
+	struct sun8i_ce_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ce_hash_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct sun8i_ce_dev *ce = ctx->ce;
+
+	dma_unmap_single(ce->dev, rctx->addr_pad, rctx->pad_len, DMA_TO_DEVICE);
+	dma_unmap_single(ce->dev, rctx->addr_res, rctx->result_len,
+			 DMA_FROM_DEVICE);
+	dma_unmap_sg(ce->dev, areq->src, rctx->nr_sgs, DMA_TO_DEVICE);
+}
+
+int sun8i_ce_hash_run(struct crypto_engine *engine, void *async_req)
+{
+	struct ahash_request *areq = ahash_request_cast(async_req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
+	struct sun8i_ce_hash_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct sun8i_ce_hash_reqctx *rctx = ahash_request_ctx(areq);
+	struct sun8i_ce_dev *ce = ctx->ce;
+	struct sun8i_ce_flow *chan;
+	int err;
+
+	chan = &ce->chanlist[rctx->flow];
+
+	err = sun8i_ce_hash_prepare(areq, chan->tl);
+	if (err)
+		return err;
+
+	err = sun8i_ce_run_task(ce, rctx->flow, crypto_ahash_alg_name(tfm));
+
+	sun8i_ce_hash_unprepare(areq, chan->tl);
+
+	if (!err)
+		memcpy(areq->result, rctx->result,
+		       crypto_ahash_digestsize(tfm));
+
 	local_bh_disable();
-	crypto_finalize_hash_request(engine, breq, err);
+	crypto_finalize_hash_request(engine, async_req, err);
 	local_bh_enable();
 
 	return 0;
-- 
2.50.0

