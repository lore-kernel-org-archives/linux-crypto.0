Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CF8233128;
	Mon, 28 Jul 2025 06:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753682886; cv=none; b=q+Xb/1vWDFPdCYGtnTtBNuoW39q14640Uwg/UtywSa7H7hHA98My2ObnNlCtY97xaP9aXDrOTJAkzXJhHmdkYgQiqWtX3PTt4QbZcKypRQFmlCES96ntJdoLfSchZF7Ox/TGd7MdIhrFbWQBeNCPJCGr6Mld9jvgst03+rTDUS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753682886; c=relaxed/simple;
	bh=f6FBfJ2O2GQ3lk7rvtQvn1UblRaOsewFE81eXurpKa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SFtFkkSwvvivhFhXlqHjKMbwJuOUodCyFTy8jUIdOV+VXEOvcyPC2zbwlvgh8MLPMJOF8wJgMddoCC9cH2HCRqAE37SSTpDWX69juRUIqIHIBlMG+RSXHQVVw2fCH5f5NhxZAvWWMJAU0jKv9c7PE11tj8XRs33x79xpjzdpSDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cxShXArQ; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cxShXArQ"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4550709f2c1so32242835e9.3;
        Sun, 27 Jul 2025 23:08:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753682883; x=1754287683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XM9OSoT7EEhuPBZA6neX1BQbhTIUd6+o400NZdJKrYY=;
        b=cxShXArQ/7kFZcNJbVw8U+tq2wdcUKJpk+6pW5bKBaDCfXaMACPTyX2YgACVQ7k8Pi
         vqYrhZFuQL9F9vfbvAsPfWtyW8tpEwth27y6HFDBBDKe1sLgJ3cGmcNyDIl50JjNhOOF
         wMAqaSV3V8aiIuSlvFJs5kY3ciwOg4KQ6VmHjibxG9K8F7BJ9NWFadLvGn8X5sG9HNQj
         +C/rHyTFZ9piSHq5pcBZCRZCz/+JZzEqg6SdnLQc1bLSQZBY3RD0ARZdV60Y8WklJ2gA
         aWknJZUtI7neKgA+1YB3RVUMOzpOZTwHLVfFsY9O1+5VJ2rUBXuqcc0SGRJKJgSnR+5g
         79cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753682883; x=1754287683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XM9OSoT7EEhuPBZA6neX1BQbhTIUd6+o400NZdJKrYY=;
        b=Ntrd/m9zKU+aAGSyJWatKDt98TrFjEXWJ40PFL3bIsqKV+vYFBE9Tm2RvvwJkGZTah
         Cm0/4wyiCl7y1VdAGOeNWi29QLh0jVj5MrNWSiczPv4A2dpr1RCrAguGtmqhGIFc8Trr
         +l5Wy2EvZZNMvmexJM4HT2EK85SgiryGBQzIOL6gZ57bmrYhgQ1ew9vsf/XNFoL6llsC
         rEZqsMnketxPIizjVAoOUcGHLdu8Llvh0EfV4r1bhXdN4Yp9Z8ckfJV7e+171CX7tFQz
         MAm2PD/p1DY96UKk2Wwh1G2ZHk0AS2cBvtPp4woOL2G65Ik4tcwimDKR1wz3cqfl6rJ8
         NgvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqgHan367IalOsXOkBbYY19mbF+kGpfBt/rmWNq9MNR4k7f1rz3HgLQttjvNSM8pdRnJs1/KbIswvx66zy@vger.kernel.org, AJvYcCWzJmBVq/gu3fr4yMDmAE8cHIVJWIqgEiIDRiAq2ZUfRQiPtBUiLUENGI9mi2R0R3lY4+pB/sPfOHfaAvQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzaUWfvDQmbleeesgKppBmjquMGa34dSPEE3Jeo/Aj/LoiiexMV
	DTNNcEPUnmZvnoYk9ztq7vV17XncmcmXu4eJdazILGq27kUcrmYeuxN2
X-Gm-Gg: ASbGnct+7xVCiTs5Alp0JF/wCRgtrnPl6CidENY37BpZxsIcpaGyYdSdcPMGhB01j0H
	OSj0IcWDH6A1ZOF1cUQ8Wyvwcy00h2zkkkfSI2v0B8yI8fiOqXM29gzuA1XUHmTGSEqNLieZ2fV
	qOLBMHvQFGpyuOZWJ2/smaVVe01SfiWZPLK9sqPrSh94kH+GXhNoHSKulrbxgDeDrgh+1RF2BvE
	r0vhb6qtLkjqGPc2IIT0bYU53L8A3mlQODkMKcu57FeVRbqBjW08t/5bPbOGbBCGhr093wCS2n6
	Ln7uw3mSgCBHnvB3eZt0Ut1N9aIEe72Tn4YwZS7j7vKUpNa203CAEO7AX/v0hdWm7PnhazoTnFH
	1QzCWlnAqiuowvoCezfm8eW38C6CW313EDw==
X-Google-Smtp-Source: AGHT+IF4uUDpr1nH7CAsFxI85U0J21VbGx+Pa4bqECbTdmTZSrvcjVZKnUakIVKf5iSA2kR6TptSZw==
X-Received: by 2002:a05:600c:6309:b0:456:207e:fd86 with SMTP id 5b1f17b1804b1-4588459921cmr31627685e9.2.1753682883194;
        Sun, 27 Jul 2025 23:08:03 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587abe6ba0sm86195215e9.9.2025.07.27.23.08.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 23:08:02 -0700 (PDT)
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
Subject: [PATCH 7/9] crypto: sun8i-ce - pass task descriptor to cipher prepare/unprepare
Date: Mon, 28 Jul 2025 09:06:59 +0300
Message-ID: <20250728060701.1787607-8-ovidiu.panait.oss@gmail.com>
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

