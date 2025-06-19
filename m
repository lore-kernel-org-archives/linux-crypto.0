Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83D5242D96;
	Thu, 19 Jun 2025 12:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750335856; cv=none; b=Az2Y9lEkJNi2QROU+O+4IoHrxMrefbT3FlNuicW5OKcFNtmH8g6oVvwy0Q9YLzhGCwpajCxLwr0ki+EYcbI0wExuIxt8g/eG1wQS6kdzWPzB5ATcDAXZCjaPTEx/kRaiUYBt1NJ+Q7/sOUxnllBm/UfGXag2SPcReLCLFIGNe2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750335856; c=relaxed/simple;
	bh=D3Fpyml+Pwh/ot9LUtEAJrW9x78rJDQPnjdfBz8Z7cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=He/YaDgGg4z9K17mtADPHXwvRnGUwsYPyAdWPtYhRK9xxSJgzjgVcud3/7Pc7XfgQWQbkFaFCDuiIJ54ZXVRQh9X8xuwWQciRl92xOOE3Dlo1pz2anWM+wGfvMULA/XvCa86DzJaVL9IssnkjIRl/91yTqAtZCxsAtwwTjGu1d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HnifZLg5; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HnifZLg5"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-adb2e9fd208so138175466b.3;
        Thu, 19 Jun 2025 05:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750335853; x=1750940653; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0HrsFLSEEMdhGLUzZIYXTdJy0VycwWTY4NZmzeB9UZg=;
        b=HnifZLg5gZRBeUdIQ+zXxe5GXXU8mDQifJJJ8R+N3o81kwDmlYUSPJaZUMQauOf/U0
         HFLZlXjMw6ZgWUQIqQ61eg/Hl1QOXb6rqgDr9xvPXp2tUVsF2vIKnh6BYFgXikeTm4pa
         kR8PutDGwFim8hrOB+62dzxSOPRyqJ3wTKHAqUbkLM4kbKYIQqJJTkPmMwcUCtVUVF+x
         26IFg1BiLTRssnyB5DyMm3EZG3dK/Zdl6+2mhYZGTzBHHcCST0wTgdy9MvQou2G7oeEw
         TA2Ed+WKO1hZ8IflfAzHYBm/rEgVpWJGPOOKNwsyLFolWYsLgI6UJrTjqW5sSwJmfTaJ
         WQIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750335853; x=1750940653;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0HrsFLSEEMdhGLUzZIYXTdJy0VycwWTY4NZmzeB9UZg=;
        b=hi006VfJWvCvMAA3Acfo3Iv+a3zH8tgsDaawgDbv3GYaVXX1IvDBuO60MvFpOQyI8Z
         ctO9QOeMLTho8BMAUr+y1Tt9hGLLYK+40j3HJxwOkrFSFQIdz27sxAuGmP7enpfQwqXI
         zDVRBA8xfias+eRubd6+nb3U6ule/XUtnms249HR/lAuHA0ROEVuiwS8tyr4/lTP0Mto
         qzEB2reZsjqqMdZE518TiRTh6yjJiFeSMv/tQ8to+FCcttGBzSlsnQLcsunlGavVOKVf
         uqZbjCvzGi8GqiJbVjGb1Oh8fDKagPMktFUT43BHC0dscixWTx280PQv+Bk//eyIJGtn
         958g==
X-Forwarded-Encrypted: i=1; AJvYcCVATIFKfx0VC9rw6WxQ1f5vWywGQ1MLxcsieOiJoZyyrAWDmx5s/6FjaHCGpYawqqcUkpFngwHJFrlK7Iw=@vger.kernel.org, AJvYcCWoyLfiq1CRnnyZUFNnBZ/WAJ3BD0mJz7HCl/Ttf5Y/CmCG4QvPq4fSGowmUbm+NF31c2ZNAYosX9wa9ePS@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0IMrT4j1Hkk4W7oJbVi15GnvsoHhXDOvXoqmsvj0h9hyEgLk2
	hZLYttNTw85+nyzw/ouyPLYUbroD0H9WntPXnCcubm402YqdVNgiJHvi
X-Gm-Gg: ASbGnctmcqdEMW4G1sMEoZtX+Rq95O3LSOBpBw+T0pmapTXfIVcOHVax4b+zA5NVlOD
	TV+bCdTZ9HvjU/zhuPSFoRBexHC2Z2vs+4+nnrB1glP7ffbbCnz9KemQQeX4sVLo8ErkiZsrojC
	IoInhlQuiYTE3J/ttvyiLWrZS/8bQd9wrJVDqf/OjixhzNR/6P0yp0AlCN41RcSshQ4NFGAdpwW
	CvayP3VtaE+f1qTYPFxXgtrbJP4tITNw/X2XtblaKs454/ubg/hoSB+aMlFcJb/T87jwUKSjskL
	kti4L7SjkdhIDFQ2SXxfrERVMtHNYjWINNdIYyxYKb54ZmsBBWpkwVEy1pMASSK/9TC6qw5MmGz
	Jt44f7/GQa2wmQA==
X-Google-Smtp-Source: AGHT+IFHuWqBozXH71wulrFP//Y6OM4S5v5aSjrSOQKgs/LL1p2at57xIwfuaUeDkpt3vFS1Udqh+Q==
X-Received: by 2002:a17:907:3f1a:b0:ad8:8e56:3c5c with SMTP id a640c23a62f3a-adfad363d82mr1948037266b.11.1750335852861;
        Thu, 19 Jun 2025 05:24:12 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae000b02bd3sm504688066b.3.2025.06.19.05.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jun 2025 05:24:12 -0700 (PDT)
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
Subject: [PATCH 02/10] crypto: sun8i-ce - remove boilerplate in sun8i_ce_hash_digest()
Date: Thu, 19 Jun 2025 15:23:08 +0300
Message-ID: <20250619122316.2587236-3-ovidiu.panait.oss@gmail.com>
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

Retrieve the dev pointer from tfm context to eliminate some boilerplate
code in sun8i_ce_hash_digest().

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
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
2.49.0

