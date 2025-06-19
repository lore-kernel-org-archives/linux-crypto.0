Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F80324EA9D;
	Thu, 19 Jun 2025 12:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750335861; cv=none; b=u3Nsz5am1N076BhiEZUQXtqxWyUvD++Pf/+N/jyJnLE4d7iZxiixfIXrfMM57NYLtXdTZnrTkoRNJalM/wJY98/2t2XdxtZ85WFafHo0sAMcFrq0TjTgUiFfUiH2yDbfWRplAumDeayJtiVV8A4KKxNGIm6bif6WnjYFslfOf6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750335861; c=relaxed/simple;
	bh=MVmmWlPksmaiBVibi00qDI48RIUv844ifSFHgrjus/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSq21hVmYGRc90ikTLSxvGk7bqYRrTyPYI7zNKbl5EcjZFYq0FKIuw6QtVz2AEfXUrpYJUZJmo8B88onqmR9jEsb+7U+J7jjhe8deH2QQhoxyW0pfYbjX3M8HREFGQQlsHmPw3DOuaajEX5UCAj8Komi+vDq5IdL/JWSAg8MtYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KGnZU3bb; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KGnZU3bb"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-60497d07279so1406120a12.3;
        Thu, 19 Jun 2025 05:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750335858; x=1750940658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nOCWgCxa5TuHqEzs7P/Xd0Uu+UeKSk+lfEEEEay9BLo=;
        b=KGnZU3bbiDwo3MXIXyFx4KmgC6ZE3Z/cp2mLaMm2iJQlrrnU1oQrUPOE7gAQ6xUpiz
         p0xwo3n9S5MVyTKd35ijwrEesjM3ZO3U36ZpxZFjYdirTELgWHh3rNoRe1HCshw+WgoI
         rrIxLXJ0GCWz4pRje2tZWQXZS7cm4Nhr3Zfiu6UrZWZiP3hC5iG4jDYlvynYCUX/ywI9
         HV4nUCkViENfD58bHY0msLmrBXuAZWv+U3jRwLOKcEUe1kXpDFSdvOU4giiuSpLCahA/
         A5AvjZlQbeEb/nJjFrz5XLGqDjBdnSm2AxmUEJuCDc7x/caXcy9PKCsXDZ+0eIFh8sDP
         xabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750335858; x=1750940658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nOCWgCxa5TuHqEzs7P/Xd0Uu+UeKSk+lfEEEEay9BLo=;
        b=wYmbLc2mMMVbFLqC6vsJCp0SOk3wptD8B+BaPZLY9QMmljtoUiUr6HOZOVlNtTluwf
         bIzv4ZP4XNSBEn6jwUDw8J7UJ8YxHBMjevrrR8FWMPVd85b+5B96OHgLrmt+gePUUQZ5
         MXanQ4q4qqrTrS7KK3+iPsNDiX3MotFTVsWi3tEMwgKFQIUOavLxpWh5oS+sVyW9wyts
         1DNaFiJLsfrQTeeEh7NCuRIOS62aaqWVosXvFfGrGhczQMiKQDv1hSLomKAZf7LLhyIm
         Zilcd/XIzjuNevtHx+UJh58y1IuNndFjKqd7rSR1bZrRRPM0OalWLl6k0WlFf0rtNQ21
         0org==
X-Forwarded-Encrypted: i=1; AJvYcCXidHTjCrH5TEkIJjf2YPX+SHywH6TWce8RHJffvfgtoqoPqjr3KttBi+0Kr6AfwoAU3vD6EtG8ez8BA6TX@vger.kernel.org, AJvYcCXw022C+gG26FtzMCilnlZRFLeX8whTDyTdFrps68hWpg+oaUDIUS7Pv1UlUooEK8AqcbxifuuWCeU1OSQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxoo3b7aMv5fT9YuZLZC96/czFqo09/nQrHpvd7l9dQjCuEIa5R
	vsRVbVo2WebQOHbmKL/BU41y50rm+rZVhRsO7QLx8PgHAaAXhkhVx0KN
X-Gm-Gg: ASbGncvoghhGVf5gvPBdaj2zRn8z2pq/WOQp3ZNXD9ixLexr8nPbu9roYXNITWCoNS2
	gPlL7mwT+rvW7TrlQDxSOh8PPYk2VSJqZJzJAzhnuqh3ztWpK+n9hjYXAXcOomus6zfqDz/TY7w
	z1x2Thha98tuq01X0jebh7B5GcxG32QxnXhTVfLRzVor14OUQAAgqNEwJMmApi+iXwRJYPTmL1y
	BltZrz2PrHLrtWaZvLt+TMKg5tjVmACmGGl95b0FKBWBXIYpe68GUXlQkuH7R49ab9hxiHEmiA6
	VDrAUMZxUMvsyPNNQhmeunzZdAK2S9zliR45BwhigNcE445QmJHN8IJqvjEKEGpnSjhIBl6XbxR
	eDNpyc+xYVpYQpw==
X-Google-Smtp-Source: AGHT+IE+a44JiT4pmaQaCPgiF4SiL6W/ZMs6YLvucyMriX+08QeWg5qDOEHlRbDj5alSx6vbOGHqPA==
X-Received: by 2002:a17:906:9fcb:b0:ad8:9e5b:9217 with SMTP id a640c23a62f3a-adfad60cb3bmr2167795566b.45.1750335857453;
        Thu, 19 Jun 2025 05:24:17 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae000b02bd3sm504688066b.3.2025.06.19.05.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 05:24:17 -0700 (PDT)
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
Subject: [PATCH 06/10] crypto: sun8i-ce - fold sun8i_ce_cipher_run() into sun8i_ce_cipher_do_one()
Date: Thu, 19 Jun 2025 15:23:12 +0300
Message-ID: <20250619122316.2587236-7-ovidiu.panait.oss@gmail.com>
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

