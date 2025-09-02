Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5B530BF79;
	Tue,  2 Sep 2025 13:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819387; cv=none; b=Oi8Gq+58J+KPh86tPs+zfDqzMBdFtdvycqE5rBx26FxTVdsVmmAfStiFII0TYQkFCQMlaHOgK/DuOskx/UWA+oV/7LwmiFvIDA7S/0t6KDktPVPaMw8NJ65dYX5FOhTtud0bdwjvDraYh7nqLfxQTSQw8BQk54QLseh6fL7qxtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819387; c=relaxed/simple;
	bh=f6FBfJ2O2GQ3lk7rvtQvn1UblRaOsewFE81eXurpKa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBgtfOxfRmdEsmAF1T4MjLAdLqelfoMwYmdpH42KjLrsYmKdD7qUxdR5Nq3DsdCpf0vGA7cF60qYaEaOF0mXgDqopJKZ/nrX/cR7PT0PtsE6bPGhrM33RzpgFhaXPmzA4Jis4eQu1E+2heIxmqyxSIsUZfbpngC9L92pjYEaYY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y16q9osW; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y16q9osW"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45b83ae1734so23120575e9.0;
        Tue, 02 Sep 2025 06:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756819384; x=1757424184; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XM9OSoT7EEhuPBZA6neX1BQbhTIUd6+o400NZdJKrYY=;
        b=Y16q9osW+t06WINQRn5VwXXVIZm/95JnGiFMLZJ7BJeE/Kw8y+VEGSoDT67W17Rdzw
         9aeEOtNd7o1q++axggKESM4+dp0HVHGueE7kuAZFZq/usTLK+FYRamsab9eQzH8rkHEH
         X9chFS+ilE5pA21XCJlJwzLSjIw20rN9s/5uCsCdlLKUtlynWB0tBBA/S3hxexyCwtlI
         LprMbwhmLRz0w81GNrN2CuMp0vwX7WtURzaK1dMQwYHv34yn9Obbnwn6KXHFpsYPZjgu
         p9nl2DBUl2hqh9Sjv6AgEXyB9g6UC0nL2FdxVlDu5QCXN4soPLMMtkfUwPuEBNjWzZ/Y
         rz5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819384; x=1757424184;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XM9OSoT7EEhuPBZA6neX1BQbhTIUd6+o400NZdJKrYY=;
        b=wH8D1Z6tJdeGg2RqvYqquWfBG0EchJC/4SdrDRk0NJr78TSFQLUFKWXskvMECjiPQk
         VNJUEi2tsrkylX7RmbllQyTeZCzBIGGzZYYqchWcuuIjUH2M3E1XIQ5yMJ423HOfZpPq
         Gy8zt5V9QMHoa1Zg0qDzjw0G7taMqOeB4qrW7gFD7zTiHauHzCHRzVRnpuKqViy8OT7o
         UOc9SR3VNQocRrCUhdIzu9U92P8XkxjJKeEsPJfaG6KLcSEfdZ4wSBxAYOm7gFLlKj49
         05yz4JziD7ZpFyZLmbftXDv3kjXAFU49oXHcH9e9g6avfdrxNPrbFWhAG0lGpJHLpd7H
         cJpw==
X-Forwarded-Encrypted: i=1; AJvYcCUlq2ksSLL+MH9zRFBibKfVBrNLmdYC0JAy+yv2q+7jjLZAgOFBJ1pp+mh62yqom/wRoZ0Xm3hoVLyX18Eq@vger.kernel.org, AJvYcCWdXs68dbvEQRIcPD2PlSCzbE77dm9O0qvlQ9jzk86SHoS6UkqjFa6pf/700JqwR+9gohU+um3GCHnuBkY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWQ7JKgSDyb2AwDFvTEnRyWCuvy5RPWwUbKD8ndyITNwYbfQSw
	Mw4r8nE3OqoD7CQ3mVJ97JzmJ7BVVroyaYdIqbj1czhMz6s4R5oNLTUS
X-Gm-Gg: ASbGnct2jXLEjU3tTsL9W6Nz/WkTXYM2lYyKuTSXzVZ0bA/KXSL0nLXpKp0GRP3JCqv
	NiUj61v+akBnh9+hmn7Jsk8OFD6ZCaH8Q3eOwPYgaQPbtT1BUvFXtRuWdGVM032IPqOAtXzRymW
	Cr3nZRyTtQeaCdFOUsNU3G9mLsrjN5jU06Y3U+fGG8Hpr8SOtMqQjrN6pTv+ZZnWsefO58CnSMJ
	91dgTDb5VlhuvysHTsns51R1nRPh08/m8ovwziRXNi3XQqNWwwub9FT9DsE+YdBfnknMm0NoRNn
	RZzi3yNtg4O2ZXtVAbfbrPjxnxK9OIfB/YIaazU18SC5WoG7fUyHCOHC74aqSb9UTfDW/r64KgW
	/sq1H/ry+sa2CzsaMC6FaAjRbetSKd5CHjQ==
X-Google-Smtp-Source: AGHT+IHcOusuOZbxetLEUJAQpcS9Gkujl1YTX1DeE+tYFW/iEjj3AZ0hRgYLZeeDGlNURGNUHbKE/g==
X-Received: by 2002:a05:600c:1f1a:b0:456:1560:7c5f with SMTP id 5b1f17b1804b1-45b8554f88fmr83630355e9.14.1756819383829;
        Tue, 02 Sep 2025 06:23:03 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:c207:b600:978:f6fa:583e:b091])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b945332adsm44452155e9.4.2025.09.02.06.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 06:23:03 -0700 (PDT)
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
Subject: [PATCH v3 7/9] crypto: sun8i-ce - pass task descriptor to cipher prepare/unprepare
Date: Tue,  2 Sep 2025 16:21:32 +0300
Message-ID: <20250902132134.3287515-8-ovidiu.panait.oss@gmail.com>
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

