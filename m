Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1472D97B2;
	Thu, 26 Jun 2025 09:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750931970; cv=none; b=uPMGTSlE4bTiOq2s/MtyUt8KE2kn9cM2ve4pvnZYBeteYIpkyGyPWeROAQjLrnJ4KffLzQ96mHK2cLyXq5kPpSDfIklMR4axPeJlAA5mInKh1StJIYsMC2t7EQQ7r0JEo3zwNRpPL0f+7CHSIR8jAodCq5Zp8f8JK2p70Gmbvrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750931970; c=relaxed/simple;
	bh=kINjivbB1+ylLn7tV9af00mOK273H9HJI0nMG3aaa1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKS0bryux0eawA1yFkeyPn05fbmF5vL4aaqFCx4HvMI+csrJnYDhYsHks3C1Gp0hvSMAZFL0QGFRXfEaHr9cygyvKn4Ooha5UBVMnGnzC6sCF3plHV+BvOYJPjl4E3fwH5qY+G7rbbhOIWL4JzfTWKU/BT5fvGAyQh9yjLXvtxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nViVaWLN; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nViVaWLN"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-60c4521ae2cso1451954a12.0;
        Thu, 26 Jun 2025 02:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750931966; x=1751536766; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SfOFmSReN1wX8YEf6gXPwdHyf/C+wiQacKthqWE/o4Y=;
        b=nViVaWLNMmpJqwX3aVnuZJEYLSW7l+V+tT7sfO3YhQ8OtrWB1rUSGx567+gXUN1r/n
         erMaR9OK/yRoKY5vm5vCtCSHaYkyA/U7+XT0pP8RGgWk7KLxO9dIDdDR6cG14Kn3/OiZ
         KJkFI9A+B+mBwxKFsMLbrYGCw5ylq18pITfBwvUGft6gPDueDlAiqiyjDTrbLzzVnTgD
         ZnPkWJvb1uPQkSMsUhac/GLqQsOAd0tshlPeISOgtyZaYNsjGQodT6rRB0BVvjfc+pJC
         gKaukQnYT04c/3/+5461ukfHLr5w5jgqXL/2vGieW0Mpand6sCrMblwdWa6nuwRPW4XF
         rpcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750931966; x=1751536766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SfOFmSReN1wX8YEf6gXPwdHyf/C+wiQacKthqWE/o4Y=;
        b=wdAXIW4RQ7+v/BsxW9dObcwBMMxW8B97E7TKp5sbSN7JVdbGuj0PlZyVitterHNbvx
         G2TvgvMloj1Px7hI7IcmyB/nYeiF0fuqAg59fNPXvBaItDq5euCb8aW3dAzZ1jDwzWYr
         lNucTacO25tLsP7B/N+T8ytOyvxNyC5Tz+WovkzsMnZbyEvQMOCeqNS83QP/PQ/OFrWr
         cGIPNNlEUOtr0Nlxxqb3u7eK6j9EfeNDvpO7q/6dNIQ7duusr9qM8izdBA+uTkcCWi3N
         rHtWX26KdKgnFOIDpxGaRYwrpeeqMYBNTSTauOhIdEFkFN+PWgLmD/5OI2MPw/trVZ0c
         8EfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVy9STaw39dtCVLE0faMk7qjWyK2uRIao72T+m6kjza2GF03CxESQJno+EekNva6/6rRyaOVXZNQxcL+C0K@vger.kernel.org, AJvYcCXHkKSWoqPY00DcLDGEl4O/XNUe3jQ3wB5fcbEUp4PnibCO+HQ7Vgv80e+LX9J3/rLzr/P7yVE43Tts7U0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx98U/DhtumJw+yaMfSDc2l+fRHuJ3Iq2pOZeZGRY8qqI97Kjm6
	KTvfoft9Jh8+9iYLiGIul6bNqRCpXEl5Ub56p4gKza1d2bTsVLB+GdFb
X-Gm-Gg: ASbGncsJlhaIg895Ltr2jBu+q3RFKYH/06RFCTgxtV5/VnU9YCqVJv4ODrZWXRKsXvO
	2HQ7DAx+NLr/Qvh49rd1GcPS8BMmC+U7ozaHkFRxg+XIZrZnwnmD/4HIeGZclQxFsTzRhZNSrPb
	sbeLd50TCA69CuSIllr5FcTf2xwxW1LFvHCHiaGfdtX6Zl6K7JuEPFQ8647Mlv4ZoRBE1fLSnWp
	aaEwcvb6ez2ns2DmEX7R/0bsf73JqiY9W3xA8bLLt7f4ygmG1SlssTpqIlI9IMT5cPSA6yKZXdE
	WqVi+J3d6ZEjHU5MAV55P10AZ1/2hk/zXy5lX6HjhFgGm9o/2DagbqlTNGtNRSCdY9TO8TafNgl
	FZX6xditln+Mt/fK1vau4qdXX
X-Google-Smtp-Source: AGHT+IHpLn6aCPnOPWyRWC4lX3V76l2fWHzGHcZP/K3tw1wy0XjyFByxeww30mlPPfNzoaWZ+4XQ7Q==
X-Received: by 2002:a17:906:390e:b0:acf:15d:2385 with SMTP id a640c23a62f3a-ae0be84ee1amr611692566b.16.1750931966229;
        Thu, 26 Jun 2025 02:59:26 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae06aa5ff34sm1014106166b.40.2025.06.26.02.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 02:59:25 -0700 (PDT)
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
Subject: [PATCH v2 07/10] crypto: sun8i-ce - pass task descriptor to cipher prepare/unprepare
Date: Thu, 26 Jun 2025 12:58:10 +0300
Message-ID: <20250626095813.83963-8-ovidiu.panait.oss@gmail.com>
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

