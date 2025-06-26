Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28A32C0327;
	Thu, 26 Jun 2025 09:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750931963; cv=none; b=r/Wk0w9AAOJBQRIV4a6MgE5wqQF+VrKLGROH95ZrtbpcQAy2eDLO7dm5/nnQaHfvPslQ+8pfICFezkisj3lciiH7Pc+GrZ0faTOwzbgpy/ZG7xYg7Ej+j0BtvjnYq43CNPxRCxI+aKNUiNvt2m1pXdy5nPNuQucdrY3prykD9P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750931963; c=relaxed/simple;
	bh=D3Fpyml+Pwh/ot9LUtEAJrW9x78rJDQPnjdfBz8Z7cI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bt94gvEVHFwI/r8A3HKBfaadfNXI16CdBXKeEupif5cZD0D6IG3JUDgvMkuW1xS+2y3lcu5XP4SVL9TuyWZivnfZefGQyir64VwkR85910OgJ2bbgwUuyEfOj6wGRc069Nzr1SxjfyycB1OHNTTLCeCEZcoPAIkPK5B+hPjGYqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YViZmS0d; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YViZmS0d"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ae0d4451a3fso127441666b.1;
        Thu, 26 Jun 2025 02:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750931960; x=1751536760; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0HrsFLSEEMdhGLUzZIYXTdJy0VycwWTY4NZmzeB9UZg=;
        b=YViZmS0dVixc53ysrn0eGJr6Z0D2YxLw20kNmaF1ToDOY6Pl41LZGoUhxp4OdzALmg
         vtKNVN18/RROUFXnFrIDVReLzTwKOXvINlSoYUsh+O9JVgrEKT+utJcN7EvIWubw75eL
         bYRljHJXR2SLj7hlZVUzUUHNrx6viHY9QN2HY3wXqTAVD/kwNkSPzPPM3aJVtrlHnAM8
         nDEDH62r48WkWA4X6K26xUXGLKBCmkdBE9lJOg4LARYLsIlsR/vQb41ul+lgGd49cckB
         Vh3jwneerVIjzeqhMf6id8jaswhtmSfI08JYeu+tYlqMdefg2gNWe2w88QxFYbhz7VL0
         OTuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750931960; x=1751536760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0HrsFLSEEMdhGLUzZIYXTdJy0VycwWTY4NZmzeB9UZg=;
        b=lEIIkHkKk0fdQ7lG8PzKJ223PG92LfMAgLSdQe9wJLu1X7/mcP0Jfu0dcDNyVzp7b+
         RITMe/WPzKAIky3KbHv2x6um/EpwH92a78xP5Cxxq/a1oNbGnnIg7FjIWYkSTo2rPmGp
         fbkglLGEjJFwPM01ysvrBGHJOvqEtgTGsQ2R4QSojM9S61V/mFv7ThlM8khpl+MnDeTW
         6hZkc7PVBKY2BgBYQYHbMBeWO8YUVPvrLlmaRLUlxlryRLehw05GvzG7NHKmnLfB+pSG
         HuK6i9l9bJiMaiKvVVlsG+/yngIcf6z9XgudeyWjSGrUUTAup9XU+xdF6JKOdD0h+sn1
         3pRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuWntltxTBrY/u4hUppMpCrV+cdShTD3f2t65X1mL8HCQWxYJUg7/wltoEoyXiToWqpk3xe0oRwgnyk8tu@vger.kernel.org, AJvYcCXDmAUif1+ZearZqzViQTxjfuVbFWBGGzJNBz2Isb/XoP6fJt1gP/WYVyKo77jfHkEKNYSbylN/1tRbCqQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyC4ehNiCYQxBji2f/8z2TpYfSeM8V7Hu+Apx0wxMMr4/xliIQJ
	fvP2lrQXb+nY54xa7/ZALW92aEUBkqTq2MyI7H6c+qs8/kuOsJrpJAvR
X-Gm-Gg: ASbGncvEBr8/Iy7oMd8fxmowaivBficygRihf8kGmBb9bzhLZSKgMvbRlNobFdJFMeP
	ek8zXj3opSlzBsUnSB5kWpxJN7GinBruGgkck68tuHh57hpx7I6GUCyrGKuC9PgYQVV5SsnTO7H
	eI7M7YAb/y80n6VRG/GdYZyW2dZxGbMEonfudbgPXQakIbOvlAKEvjFM2YXEbRyF4wVbsIv17Az
	WHUzLKwd/ZjzYFKOzr8Hf7FAtlrsNWsODQTiR+ZGgc2rR8Pnu1A5u7puhJ86VAZ6km0Z0QS9QJA
	W6MRb77mwNEcRmnZ4qK4LOEpXYtDmv41dJldjkHIuJi9+8sOws2uRHL4GHpaAFSTGRbr7phxnGQ
	A93umKPUG8N8dN67Z7X3gD6d/
X-Google-Smtp-Source: AGHT+IGcHkgMnqpZF93lLxs84Oee/gXcIKO2zDueULt6PM5LIPG4njAWAD+IiAyNDCajyksrQT6oWA==
X-Received: by 2002:a17:906:6ac1:b0:ae0:9fdf:25e8 with SMTP id a640c23a62f3a-ae0bee52de0mr552743566b.47.1750931959733;
        Thu, 26 Jun 2025 02:59:19 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c51b:8900:a03f:12cb:72f7:9069])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae06aa5ff34sm1014106166b.40.2025.06.26.02.59.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Jun 2025 02:59:19 -0700 (PDT)
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
Subject: [PATCH v2 02/10] crypto: sun8i-ce - remove boilerplate in sun8i_ce_hash_digest()
Date: Thu, 26 Jun 2025 12:58:05 +0300
Message-ID: <20250626095813.83963-3-ovidiu.panait.oss@gmail.com>
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

