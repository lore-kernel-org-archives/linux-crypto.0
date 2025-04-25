Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4846924DFF1;
	Fri, 25 Apr 2025 12:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745585152; cv=none; b=do4WPIx43NuGoaQNwUAoSRiRzJEAM8X6UTO3zkFafrcma7wqQR3dNmgg6+TxHV9Xsf6IkigR+RQUfSlEsdhF71MrLn41We30qQhgf1xxYgRliMkcLDlW5qEUO5a5Esp1bSFsNbyvhA3SK/pAyNSlAlZhYUeB7SwIO1JJVaCKhLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745585152; c=relaxed/simple;
	bh=1u4Z29Anp5j72oBtUya4T+wvp68KB3fipULiInA7Juw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rzl7RXeNYDDa51PE6GO5xrxMzYpQ+BsgQrEMnAKlP/umultzEdfBkEO+4UE0j1x8/5Hu3RzZGSppDkJeg8jlslhFFa1umpKd/0XIr4vOg4Gy1wJupEgrT8zS2Uq5kcbpG74s/vUbGLDaWQ/mJYtg6GSWrjX66dZ6pB/elyyqekw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hWLXV+mf; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hWLXV+mf"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-acb615228a4so567166566b.0;
        Fri, 25 Apr 2025 05:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745585148; x=1746189948; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QlIhz0JB5sRSfAD0HIOOevrgWFZ2yotgxE/TDOX4uAU=;
        b=hWLXV+mfiPnMbxu1xTPFeBw8faMrTZvETR+xzStOKHP0h+3BjzWZKEMPLdG9GazQNI
         A1wxCJ7Tv6nJZ4Whur2NXXZU236BxDNJWL3JK+Agnt1uQrSHQMGAxx7LzJ1UZ+oSVfU4
         2U78xBChEXL+KFnsHTbqoBvQSUGuf81HTP+pX8aw8l0aIK2tI0GWJbHe9Z02f2XXl4o7
         XYBtiX71C21c7mhol1vfNXqYj83Vh5SikicVJFV0SwqERmNT8EgH9yysGCLOPo5ixm8k
         2PMQImLqSR63r9e2BBFeDRRDc1kk7JuKBmaxHqzrXqtLd6aT2AtQNSMiWoAuxfP9yQ0q
         icyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745585148; x=1746189948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QlIhz0JB5sRSfAD0HIOOevrgWFZ2yotgxE/TDOX4uAU=;
        b=F5eI0yyoEv1w7tOxLJXEZA79Ed34yRYSP2hWHSxdflIUrsHWul5LLh8qYa+7qvaSjk
         8pa4eIPvri7RdKgjjMjr3QXZf9L/d3unwzOHHhWXI7NhAaXGFVRecsd8FKYe8kL3Nv2e
         gV9Vo4QOy46eN6dyLqaI0fUjuPTyQ05h/v5rQTW/9jzUaoYbNDTeuCK96bt7BAkjb+P3
         Ns0HuADDf0FIw6EUrRn76XZF4DqjKn9AAt6rDxSH6U/nzyXdnr+apg4cJzBEfb647jq7
         WQxCyAfl+kKQpqCcrwoIg2nu3UWR6/2jhW4ylkira7c+wBBYyUXauvQlYw3PGUGQBUVU
         Li8w==
X-Forwarded-Encrypted: i=1; AJvYcCVPq/nc45+Nj4Uzpw10qpcJ2mq6PUV719x8pvH3BIRjF3MLNyWanBSfoUrhSfV8yiZ+cPsCYwGaSGiR03Q=@vger.kernel.org, AJvYcCWQEiJ1HHsYtDCe5utF88FRja1v04QIuRtxfoL6K2plFWJKsZPB4zObs2HC6zmp+oZSP8m9qMKnQGlcq37k@vger.kernel.org
X-Gm-Message-State: AOJu0YyJii3QYQql+vdcDKEnXioIhCn4jIz8T27yt8AS9Bhc2WuDfl2a
	CJkF9pIgt2Gx0Qc1xEVLpB0l1awrte3/ifNcP0vTUK8E6a6Vgxow
X-Gm-Gg: ASbGncvE4V/vfpS0GnksxFV7l6LaiCvtBwa0l0I1yuZjZOPZcQXXCaDLtxTLOCu2DjH
	e/WCzvy4sB8btk5xEqqt1bF/2JNn5DKeIUhJbPhMnenEfmW1AST9omvBPqcWMtek4R05phzrdax
	O0a86SkxtiFY1K8wE8o+3UOOIEHziQ4/odjF3KeQStvYjHD0qElOtgOecr4XhGTTrKQ2TT/+mqK
	yWVVG94PwTOkC6mwxilSKM5p8TNCuvKT3M81yIbzTfaWZehOWKbG7IU7bBZcMJxk36+XHB3jp3x
	0XHxGCzbQdzkEYsptbjnpbvFc0Y77XFh3UhftPfkQiZlWotcPVtVn/YEaXG4QCCwH3CB
X-Google-Smtp-Source: AGHT+IHsRkfW4z8AS9Sjh3HauYzSDV+j3U5Ovg8Y3HzMxW6/Vp1c2OsJ8tuja5lsWTGyHhQu5GJEEA==
X-Received: by 2002:a17:907:cd0d:b0:ace:3291:751 with SMTP id a640c23a62f3a-ace5a2a87c2mr526981066b.14.1745585148502;
        Fri, 25 Apr 2025 05:45:48 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e4e7094sm134641766b.56.2025.04.25.05.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 05:45:48 -0700 (PDT)
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
Subject: [PATCH 3/4] crypto: sun8i-ce-cipher - use IS_ENABLED() checks for debugfs stats
Date: Fri, 25 Apr 2025 15:45:16 +0300
Message-ID: <20250425124517.2225963-3-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
References: <20250425124517.2225963-1-ovidiu.panait.oss@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG) checks before the
fallback counter updates to make sure the code is not included when
debugfs statistics support is not enabled.

Also, drop the existing ifdef guards, since 'struct sun8i_ce_alg_template'
is always defined, even with CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG disabled.

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../allwinner/sun8i-ce/sun8i-ce-cipher.c      | 46 ++++++++++++-------
 1 file changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
index f03a8fa7bfa2..433cd18f0b5b 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
@@ -34,22 +34,30 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
 
 	if (sg_nents_for_len(areq->src, areq->cryptlen) > MAX_SG ||
 	    sg_nents_for_len(areq->dst, areq->cryptlen) > MAX_SG) {
-		algt->stat_fb_maxsg++;
+		if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+			algt->stat_fb_maxsg++;
+
 		return true;
 	}
 
 	if (areq->cryptlen < crypto_skcipher_ivsize(tfm)) {
-		algt->stat_fb_leniv++;
+		if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+			algt->stat_fb_leniv++;
+
 		return true;
 	}
 
 	if (areq->cryptlen == 0) {
-		algt->stat_fb_len0++;
+		if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+			algt->stat_fb_len0++;
+
 		return true;
 	}
 
 	if (areq->cryptlen % 16) {
-		algt->stat_fb_mod16++;
+		if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+			algt->stat_fb_mod16++;
+
 		return true;
 	}
 
@@ -57,12 +65,16 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
 	sg = areq->src;
 	while (sg) {
 		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
-			algt->stat_fb_srcali++;
+			if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+				algt->stat_fb_srcali++;
+
 			return true;
 		}
 		todo = min(len, sg->length);
 		if (todo % 4) {
-			algt->stat_fb_srclen++;
+			if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+				algt->stat_fb_srclen++;
+
 			return true;
 		}
 		len -= todo;
@@ -73,12 +85,16 @@ static int sun8i_ce_cipher_need_fallback(struct skcipher_request *areq)
 	sg = areq->dst;
 	while (sg) {
 		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
-			algt->stat_fb_dstali++;
+			if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+				algt->stat_fb_dstali++;
+
 			return true;
 		}
 		todo = min(len, sg->length);
 		if (todo % 4) {
-			algt->stat_fb_dstlen++;
+			if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+				algt->stat_fb_dstlen++;
+
 			return true;
 		}
 		len -= todo;
@@ -101,9 +117,7 @@ static int sun8i_ce_cipher_fallback(struct skcipher_request *areq)
 		algt = container_of(alg, struct sun8i_ce_alg_template,
 				    alg.skcipher.base);
 
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
 		algt->stat_fb++;
-#endif
 	}
 
 	skcipher_request_set_tfm(&rctx->fallback_req, op->fallback_tfm);
@@ -147,9 +161,8 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
 		rctx->op_dir, areq->iv, crypto_skcipher_ivsize(tfm),
 		op->keylen);
 
-#ifdef CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG
-	algt->stat_req++;
-#endif
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+		algt->stat_req++;
 
 	flow = rctx->flow;
 
@@ -438,9 +451,10 @@ int sun8i_ce_cipher_init(struct crypto_tfm *tfm)
 	crypto_skcipher_set_reqsize(sktfm, sizeof(struct sun8i_cipher_req_ctx) +
 				    crypto_skcipher_reqsize(op->fallback_tfm));
 
-	memcpy(algt->fbname,
-	       crypto_skcipher_driver_name(op->fallback_tfm),
-	       CRYPTO_MAX_ALG_NAME);
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+		memcpy(algt->fbname,
+		       crypto_skcipher_driver_name(op->fallback_tfm),
+		       CRYPTO_MAX_ALG_NAME);
 
 	err = pm_runtime_get_sync(op->ce->dev);
 	if (err < 0)
-- 
2.48.1

