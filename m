Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 479DD220F3F;
	Mon, 28 Jul 2025 06:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753682879; cv=none; b=KIoMVQ5fWemkr+IpgPFhrDvNo1bHXVpm69nbwJZwjo1zPyxOZVi3P90rMHmQ/grWy4j2W25mO/kS/1InZX2QShwNdQPL5oQbxGndkHZlrZg4nUhE5y3jD42Zen58Y9GQVH2VUcYqa3rpZ4Sd8SjtByhGaqHYIY/dmJvLxz+sb4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753682879; c=relaxed/simple;
	bh=kyASvvV0C6502P156s4uvhgiJ2anCkqmkQU+DPnmJLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QTpHj/qZXCqbs7PVIBXQzTMY1a6JMNB3VvVP0JrHqVH6LOc6ktXYg1zDUa1yCLuY5Plkh2z7Xgxp4fFsjRokNmTifFpi+eNn1vHhSdIeQVuy+4WdRtiLFtltijiWy9NFa6pUof4PMDaXjjVR5OHnJa4EbJMLmys7OEmYs+R3AJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wcn8NKTW; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wcn8NKTW"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4561514c7f0so39360275e9.0;
        Sun, 27 Jul 2025 23:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753682877; x=1754287677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ElWdGUyg9Q9uvasE/0knQrvGqeT+AHFO5zlC/AHADc=;
        b=Wcn8NKTWYIDkuAxuKpbcM4BOzGYoatTcmPt8r1DRjJQ22juXC+ahub3x/YF3vkyVrj
         5SNYmv7DiR1wtXksyDLsxAc7HdtZXNAlci8sLGOQU79cYpEyj3Bbs9xHQMp1zku4r3Qh
         ZlEsVtdacGNpIhmK/79tBKR1JyrqsAKMjEgTpN7HSSqXIu0TqcfHif/+ZWnsX921NNs9
         bHXfn8iGIAFABIrtQllKexOmvfnwf/MAtltq1yBBZsEv40PoRbKtaJsnMCp1Fb+1m231
         fCoKAbCusodKOwpfYikEI+N8QK1FAQEsWmDhDp/32Y/m5sl+IiHQl4unhKCv54QrNioT
         Npzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753682877; x=1754287677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ElWdGUyg9Q9uvasE/0knQrvGqeT+AHFO5zlC/AHADc=;
        b=bzADD9NhRQjKpKhZDYX/sGVoT+HcT7rL1glmegeWUoS24TcldpLgBnYB1mn3aVYIW6
         YksZ9xNwSFZ9R78Ksu+IRIjY1WcMJZwZuFuyWdbfpdOxIqpOKraj+GAd7sAxy6wOQhii
         lNKig7rvqFI1hTtibAo0HK7O1hx49P5ocMWzzOqxFNXY6nReyAb/svDKDMKfHBzL4+/j
         AMYBe7EAtXtIzWoHl4SzGox1+przasapsKZx8YygJW5BLjKNh711RfjGjoDqVwkI+S35
         08MDaM9u0b84n555T/eQbIqH3coewjvjXPxVoxUKyHyf1dNZPZWB8TO5ukZMrMzKcEqz
         mdBw==
X-Forwarded-Encrypted: i=1; AJvYcCUc7GdmntMAvS5LcKr1iE+CmwJlWnMCyB38mJWT1SM12A0ps6cwK/zr2bJ6Di2l1cyvMCddGWp3fWjCyurK@vger.kernel.org, AJvYcCUrOrGWliBeQI/EQP5Db/BDE2L5G2pwK/aKsICVs5lUuUbGmvLH9OoyYQ7WqLE1MQLYoMEoIqb6VhYlke8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPSbGmwVbGtQr/1iFOImXvvhuEAoMO/LB4OWGazmPBMNqyLsXm
	F5pPHsIQ4YeQUCfEc0vnsvQGT4O4y9wKGQGoaObsYlV59D6rwuQtZurk
X-Gm-Gg: ASbGncsftmrfb57BvYfVhwaO2WfkewIU52/kS9bi5QVJSMdOE1v4qeWG09O7gdEfroy
	wor6dOTIwZquWGMEAB2SBzVVLno4vFKFb/JyB3XX+nnv1tZ+8ApuZLPSB8A8QpLYhY1NwbTbN81
	vzJqfNcqeIw70QTpwjA/FkgIAyMHv5AWvfK5YW5kncb0ftaD2/0KUW8vfPEGdFyvLJDpFUIlZA4
	NLFCwor4hCUMYPHnnJIpfl/kiQ4MYViLCAltW/8O13vUB8J7XwhZnCh/dsE88FKXhvUN0vgqFuT
	laEaoPEd9n1zjAN5NzsiwDLhHKHOtcsm4ISQSrWkTq6yMfkpgMODaWqWeEFVBHBSXu9dSTd3H17
	0N7owrhUcoRvMD0hycI42zaX82Bq3KlxauQ==
X-Google-Smtp-Source: AGHT+IFJw3EbsUDLtQA1ecwg56WxcbMEO+eyP+FEUWh83ffWtoZBkFf3rr8tJhzBHJdAJ6osjr0sWQ==
X-Received: by 2002:a05:600c:1e1d:b0:450:d4a6:799d with SMTP id 5b1f17b1804b1-45877445e1bmr70270965e9.7.1753682876514;
        Sun, 27 Jul 2025 23:07:56 -0700 (PDT)
Received: from ws-linux01 ([2a02:2f0e:ca0d:f700:1210:b727:adc8:716])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587abe6ba0sm86195215e9.9.2025.07.27.23.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jul 2025 23:07:56 -0700 (PDT)
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
Subject: [PATCH 2/9] crypto: sun8i-ce - remove boilerplate in sun8i_ce_hash_digest()
Date: Mon, 28 Jul 2025 09:06:54 +0300
Message-ID: <20250728060701.1787607-3-ovidiu.panait.oss@gmail.com>
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

