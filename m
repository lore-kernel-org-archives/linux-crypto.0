Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46131EDA2A;
	Sun,  3 Aug 2025 19:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754248267; cv=none; b=Brirx4EZ8rqelGByhEHXqCDBK06NsNlguqCk2EGSbADCbO0yjW/dlaxOjCiaBZ8qzFw3/IKmU+whwZx2xTv5BMj4TLNR4uapOG0P3OmYoVpL3O+OKjgmm7TdrlM4/mNwDXhCq+hRS+M3hxhSfvl0xesryREyMOcgJtz/3yhGRSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754248267; c=relaxed/simple;
	bh=kyASvvV0C6502P156s4uvhgiJ2anCkqmkQU+DPnmJLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaKQeJNrOytBPll3HuiUDqXAY1HjZZhKIjUUX+uVSQGaXCUAJ2Ggcelcb/K62IugB9rrx1TK4CCu7OamAjlBTT01bQ++bj+i2nXO7MwhtAjJxIOnQVRt70qHn5wEy+DJdPSitE6ZzHnwnFkZHfS43QjzqSakLEekOrMYMjssT9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dKhJfz18; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dKhJfz18"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-458baf449cbso13490245e9.0;
        Sun, 03 Aug 2025 12:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754248264; x=1754853064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ElWdGUyg9Q9uvasE/0knQrvGqeT+AHFO5zlC/AHADc=;
        b=dKhJfz18VAaT2rMb1Guh5q9yy3zAvedGz8rRPa6cFPRMJb+PpNsTGi/clKLtiFgh2A
         lTrBVfsPIuO+QVp7s0wAYJSHqYDQY7FkFB+k2avx+1QsKufXkarq+0o4Yg5uEWgQz+ld
         frxM0tUVgses9eo/GhXlKfVPX/BoB3lPtufhEMkdhEvMayXqI2tHFlAnjlOCZN3MXdXa
         OFQH6bcJ/5aURwpSL2Mt0Xby4sN/Ojr1dGJirgOrZBCGJcgNwEbZ3xEmJ/DMYLPAzxMU
         0JTzS54otcNCdFsoprZ8E8Cd6iUzbqXo4Loi17eF+EsIJS+RvsxJBEDzF5DxzfNV+bMQ
         tIfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754248264; x=1754853064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ElWdGUyg9Q9uvasE/0knQrvGqeT+AHFO5zlC/AHADc=;
        b=ndfpzlQ0KBWMACfZUkdL4xGS6BIgCc/ATDE6dEgQvMsO1Drf92bnQniIU2gASgWjdW
         OKMDEAyHiUdIrn6QAB34BsyRGuFnuwS8NBS5LHIqUPdmdmWCxxCjo8fIp5BPJYsf1Xr9
         q6xKoyB09Fc9laR7lL4dltcz7jzfU6k/8ZRfbgATKUNc6euAJo0BA1+Q/+H6RJ14E/d9
         N9/ikXVFwkAX5w+A9wzxJKoZzwFcaLxRPIiBsVkTPhdSNnSWonbvae5Jq92lQnaBIXhK
         Sc/5cJmLNuN+j558xv59/e2SAsizvafVva6lM/rjhsOPqjQmIJB/vZ1eplybtiDpRqF4
         ZrZg==
X-Forwarded-Encrypted: i=1; AJvYcCVnmTUWWiI5cNoNtssz4+l8oKk2sjTd5jsWYqC0v6foeiVdHFA+/EmbXpRscmiVcds6Lifw5RfV9Ljkdug=@vger.kernel.org, AJvYcCX2yYkgZtV/rknsVstqakhkL3JEmqaIE/BiQCjmAV+m5jXh5Osu4nzWvujbgrgsMxWDcRsX1h3ezqe7v8HJ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5aXvwTHHX4fsMzjqiLT+jneh//d3rCT1j5FLavGIjldReMoRz
	Qbwl8iuGWHdDY+MUTPgPetJTrbbCvg5XIRYohmUUosydO1ATr9ZOORUt
X-Gm-Gg: ASbGnctFjBtmGQgNXqEj7T7+8BScYZfS5rmq4cuhCHRc8Ep/s5NEH11PyK/OyoYWX4a
	kbqJ0K/FdWfEXxvrwc598vawb9R47zVYzHCB39x0FzO4boltmBDW7y1YYag2gZBD3UBiEdzEDeQ
	g50uAuePeB26Leke3G70uRazx0smC3qK7xyjdLhxHxBm7I3TafvxzykbhxB2mxdqVdcRFgoD4VY
	s4rLuNgMWr6ZXpKoqHj85r3ZVmpSt1mocoje6hJNHHGeQopr3EYLw6OXUb2T/KHLoB9BpFhojpW
	jKe+rJSfg5fTOwSJBgQMGURD7wLHn9uRXoWPRjW9q5Fs73y/Iq237EAN5mRdqZi9VKNCmLqn6LK
	5Jyqdsa33TT8vOiFZeFi49RsVo7eFyV/lEw==
X-Google-Smtp-Source: AGHT+IEuwtHoQB0DUIyO/0Z1tXMmBf/alEdLn9qmJWqD0USge+nGe1p/Rv0Bwaf6WNGkHFKl9ruVMA==
X-Received: by 2002:a05:6000:310c:b0:3b7:93d3:f478 with SMTP id ffacd0b85a97d-3b8d94ce4a7mr4645712f8f.51.1754248264043;
        Sun, 03 Aug 2025 12:11:04 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b79c45346asm13099210f8f.39.2025.08.03.12.11.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Aug 2025 12:11:03 -0700 (PDT)
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
Subject: [PATCH v2 2/9] crypto: sun8i-ce - remove boilerplate in sun8i_ce_hash_digest()
Date: Sun,  3 Aug 2025 22:10:22 +0300
Message-ID: <20250803191029.3592987-3-ovidiu.panait.oss@gmail.com>
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

