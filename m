Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94BF33054D2;
	Tue,  2 Sep 2025 13:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819382; cv=none; b=ccrAlGpcYeUaG4GIEPWWLnQOdUsNR0UOGJmLUGk69EypmeirFWPKVXTyv98HqtsU+7qGEaGkvlVRF58utXHKIul9VnSQDIYsdH4u/J2mJfQiDK+N7TdavAoGn+HWVlDgwRJlPbmW9ZpqnggJnF4sxQrsTCUZo7cyW+rLjltek5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819382; c=relaxed/simple;
	bh=kyASvvV0C6502P156s4uvhgiJ2anCkqmkQU+DPnmJLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyGrOCZEt4yte6Da1aCpAOW4MY8P9zN+3tYCEE60ZUO86HVuVXz886SbsfcZpYe9i34WNKB61y8a9+vmZ6Qk/HAwwCbD5XUBPpaIWyv6IK4uRkMBRKiqpZnxMYi5artPTxMkP7sLQlmnygGYMBZazCp1FNRnh9J+kQNU6S4o8zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FqAiCLK9; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FqAiCLK9"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45b7d485173so33757285e9.0;
        Tue, 02 Sep 2025 06:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756819378; x=1757424178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ElWdGUyg9Q9uvasE/0knQrvGqeT+AHFO5zlC/AHADc=;
        b=FqAiCLK9mSUUf/fAPhJRKPgFIreIYu0YjhufTJOWE33BpF4IoxYdi6DeyfzEj3NjZw
         oSREHxovf5fob47z8jrbY1F6V2BO18fy1xGPCfR/mH5zwo/0F2JV7aqzP2bdd7Mn4FTr
         U0r3uuxgg/E/o8O0UfLEd5dZRgP2aiDUgkCQbL/+fxBAM2sOMW5obFkIdQYDUfh+xNl/
         z7dJYqqLrrZX1+xTGcdZuWa9cQLIhlwedgB14gbOm30QD9Ox134vTClr9BGzMgt9xWcn
         1Bc1BJ4zCQcxrTEbxMhYZzAcAAUCiJpxrM+9kqpjayvVC5PEQKtWcFdqPvQqmEdLXOHi
         kKFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819378; x=1757424178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ElWdGUyg9Q9uvasE/0knQrvGqeT+AHFO5zlC/AHADc=;
        b=drz1/VQFKxXWMBJIsvWRB1Z0EgWItRMlDROB0WILHiUFclKr/db5yRL+jkHwe720+H
         zGBGVL0XMoVgDpQucrmC/fOtYUVYKjZS+na/ppFF6fWr+DsPbvsRiGsqD6P9BiAWik19
         lCB+uPnlpvIR8PQR42p2tov4lb7AmW7XppJ0EHax9lXKLiaglbb0cHiJd9Y+zLEyoezz
         BQUuK5bKo99tIrEr5rJKhSSpvsC86aMADdO/Ax7ZZtWmMKGr0dHJ5aJcgsToroT8yGCy
         kdmsgVEnVX3ZlFR1RP7DrDjPBIy4u8COs7o3vdJ93eOkiPOlLvSrioNpPmYce0gtgH7M
         l4hQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpJRQZr4RXyCDv5/xBWAxjWUyAU+KfT6WPwSXHZE4rvyh1r615kjkmjQ5oB7SItugkqbOqg6lgcrZmoN6F@vger.kernel.org, AJvYcCW9PqwTtN/veYfsTLz71ARX5hEeA8sJMco2hByuPJ7MeT3chBNTUuZsvhmlthV5odeMcpJwUbmQe3K46y8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9yfgNTJ1gtulMh1xVXntWQ7NTPe/ltfKiFVrtErP2bD4sHLbb
	y4jw/AHw4/LTVWusupFw1ut2lbAIxTeBq2jYO3PzGXNtVp+FhzfZCpbo
X-Gm-Gg: ASbGncs06xyK18sTC94X0C5rWgesjf0crsfhfRCWtBC/O6TXUgrL4Qpa7tlsz+Dw7wd
	T18WuSDuOUp7rQi8mOqysgBE6+PoJpxQbE633PWl45GJciHwy9Tuf6vClJaitlskrkU2ovpGrms
	PXQ3V2TMLJNrgupKktJD1bQH07tIAkOIDirdwTyhbhShmdqPVlz2OUlBPBuuNKjdcfKdrRVvAGu
	4Eb4EY37cW9manvcYeQgjD+oUGemQQxeC8ZUZyUGRGVQ10GvdIjnF4Uxez/un6aoHhm/LHeM8Lj
	45uJ33mAmid5aEbfoZ/uWJSSRFO0RgTLM3tYC+Z5Z0cxTHU3Cd0PVTXCtpDU+Cpc19jHtJXU3P7
	kNAXMRBD4KH13GZRApaoB6vUF/95MDoju1w==
X-Google-Smtp-Source: AGHT+IHcyDVYiBnpcbLNKDERC0dfFteGZiJ+qGt3KiUljAkJChMcYHaPXwrQyaik6ZY9zKUEaa9wZw==
X-Received: by 2002:a05:600c:4c06:b0:45c:4470:270a with SMTP id 5b1f17b1804b1-45c447028b8mr66195e9.9.1756819377579;
        Tue, 02 Sep 2025 06:22:57 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:c207:b600:978:f6fa:583e:b091])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b945332adsm44452155e9.4.2025.09.02.06.22.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 06:22:57 -0700 (PDT)
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
Subject: [PATCH v3 2/9] crypto: sun8i-ce - remove boilerplate in sun8i_ce_hash_digest()
Date: Tue,  2 Sep 2025 16:21:27 +0300
Message-ID: <20250902132134.3287515-3-ovidiu.panait.oss@gmail.com>
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

Retrieve the dev pointer from tfm context to eliminate some boilerplate
code in sun8i_ce_hash_digest().

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Reviewed-by: Corentin LABBE <clabbe.montjoie@gmail.com>
---
 drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index b26f5427c1e0..61e8d968fdcc 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -238,19 +238,15 @@ static bool sun8i_ce_hash_need_fallback(struct ahash_request *areq)
 int sun8i_ce_hash_digest(struct ahash_request *areq)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(areq);
-	struct ahash_alg *alg = __crypto_ahash_alg(tfm->base.__crt_alg);
+	struct sun8i_ce_hash_tfm_ctx *ctx = crypto_ahash_ctx(tfm);
 	struct sun8i_ce_hash_reqctx *rctx = ahash_request_ctx(areq);
-	struct sun8i_ce_alg_template *algt;
-	struct sun8i_ce_dev *ce;
+	struct sun8i_ce_dev *ce = ctx->ce;
 	struct crypto_engine *engine;
 	int e;
 
 	if (sun8i_ce_hash_need_fallback(areq))
 		return sun8i_ce_hash_digest_fb(areq);
 
-	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash.base);
-	ce = algt->ce;
-
 	e = sun8i_ce_get_engine_number(ce);
 	rctx->flow = e;
 	engine = ce->chanlist[e].engine;
-- 
2.50.0

