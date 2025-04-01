Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FE5214221;
	Tue,  1 Apr 2025 19:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743535445; cv=none; b=mkX1tX0KSk0mVKzWKTXsxMvPSoNJh9E3ZaPTJO67vPWbxr3/0kGQqxdlinpos8NVhgcEmibrriatDEoPCMaGFn53HZtfiWbtxHVNubL5BiMEALtlbLvOmeQ1yKQ34KvYszdiBAYIxmc1Hte/nUCeFUhiZyTYugOrofMaCU7ZP9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743535445; c=relaxed/simple;
	bh=8ZKDGGf8d4/6E2eiXmvJNyK8cfqVo2y1RKH/3zxXGNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m59d6ZugYhJDpNrX5jVZmJc3M0U0UQxrkkPT2cep2LQw1QLWp5MM33oBtDJsH3gN4gwVMUcPjsQqBO4RoLBTIn8CypM4hZJ3J57hNk9xNE9K/TRSaPJwQC3UtIJGDTsBggRy4hkJP4W5QwKLxOS6+qoNPURzamnzdDG4+1JYceI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WIgYYR7t; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WIgYYR7t"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-39bf44be22fso3090451f8f.0;
        Tue, 01 Apr 2025 12:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743535441; x=1744140241; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8z+fSx5TSn2FrXLNFfU/1u/JP6JDm+uKA06s523rtI=;
        b=WIgYYR7ttKSP3JYkfCqRtqCuLiRCqMfIp+oDjR43J18mnP60Vcsfwb1I5CtNxOaiNd
         1hz4WVRsqO5+atNPchLLdqUO8r01YNgZRhb0jxj5YgjzIr7wSTjcAtTGC3X0kEt8VBPe
         IfOdTZVDPh0PbiiY0sWcd+rg5GxZOB6CUbSe/FdoJpdwdbhpz/VdmDSLFzAEcm76PRab
         9sWH8G35wFS/VQalifmG/fW2YUbxWG+XhuWlHDOFxJDf6lPsroiGguRJWawx1qKiIwN0
         keSfJDVFzfMCLeUv/ebD04T7KhaVncc6FUgrlb17cvex0u9XC8yVhhgucyIy5Xoarvpa
         mSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743535441; x=1744140241;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i8z+fSx5TSn2FrXLNFfU/1u/JP6JDm+uKA06s523rtI=;
        b=WLU2GvctshDsDR4GZiY4rAres6Q82NlI4FZ7p/7Q69+8cWZQ3jDz13JuN10G6Fbqu0
         9HPn2isjU1ejCuxZf2i1TywNKl5GeX6NkCp/E6bxzO7NICfEriwTvirMNjV36CuNzrZ1
         JwkqMHem+vCHNrK6iAJqELyBTccO0B2bzm7zxwqH/Vhu/rnzm+G0H4TWJTfZKoJQ6gU/
         ZVxjYDCsbziVxWelkUw9Xi5dZsjyexse4GY3qtUVNjcF/Q2r0jWzpVSjMlGK/G2gyrbr
         tKGFx0B5mkjMLMGM55JxNNTpyDdz8sJ7KYmi/5WRwHW7Kbc8HT1l3hI3cfhNTBUQCxLD
         ohYA==
X-Forwarded-Encrypted: i=1; AJvYcCW++VHtgmgt4SxCdhBrXVolht852xaESyogSRokUdHsHpUR1Uxuhiuo27bw4l+80BJWgOLUqnWM1zs6ffE=@vger.kernel.org, AJvYcCXttQepzN+A0hQS9NvoG+neHn8KeArBFFDC3IM4QUy7CXxys0KkVkSyFeY6Eu6k8FTtvQAdyGJKZxcpq5XZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwZU42/TPJAYpxA51oGcc8VTMuKh6N3IzqFE1FPr/0MfontwPQj
	9ov1gQN0VzwmkUx2OZgAypzv5iuo06wl2OZT/IWK0KyDE861mNd4
X-Gm-Gg: ASbGncsy8mXDT4eZEx4Xv6rvD9hp4M1SKNROI06UWiSJLIzJRsKbPgSm7ofAygBOTlG
	7HZSL645zwEojH4NQIKUuLluaJ9qI/OvakaD/kpPT27uzz7aEpYdGCuD2yD7j+Wj71SjdVu9hLy
	9TZmCIHRnHkBeUIY38wtVShWDFEwmJ5Z95IbDq4j2mPcsguSi6FgzqUvhfZALA40+ALjIddG8ks
	ap+dgItKXweqIha18TaSm9KPiPKiGJelnite2AaaoRzS/bGvxafk//vssoEZ+zZAhqL7HNREQBP
	RZBP/813c2t9YCniHvLIGNqbxfzGD0A051/bt6xMEd/dQCIVbaN092p6RKsn+QvBLWXaJbMe
X-Google-Smtp-Source: AGHT+IHEh+OGGdBfpbw9Ezhf9HsQaZImvcYBc/BECi3M6V/8EKmHii6CQkGoC7DxQblK6JTqZon8Ig==
X-Received: by 2002:a05:6000:418a:b0:391:22e2:cd21 with SMTP id ffacd0b85a97d-39c12117df4mr9452334f8f.36.1743535441394;
        Tue, 01 Apr 2025 12:24:01 -0700 (PDT)
Received: from localhost.localdomain ([2a02:2f0e:c50a:8800:cf9e:ee0b:4a01:37f6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c0b66aa32sm15353438f8f.50.2025.04.01.12.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 12:24:00 -0700 (PDT)
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
Subject: [PATCH 5/6] crypto: sun8i-ce-hash - add IS_ENABLED() checks to debugfs stats
Date: Tue,  1 Apr 2025 22:23:20 +0300
Message-ID: <20250401192321.3370188-5-ovidiu.panait.oss@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>
References: <20250401192321.3370188-1-ovidiu.panait.oss@gmail.com>
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

Signed-off-by: Ovidiu Panait <ovidiu.panait.oss@gmail.com>
---
 .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
index 530c5181d73c..f2481e1585ba 100644
--- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
+++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
@@ -60,8 +60,10 @@ int sun8i_ce_hash_init_tfm(struct crypto_ahash *tfm)
 				 sizeof(struct sun8i_ce_hash_reqctx) +
 				 crypto_ahash_reqsize(op->fallback_tfm));
 
-	memcpy(algt->fbname, crypto_ahash_driver_name(op->fallback_tfm),
-	       CRYPTO_MAX_ALG_NAME);
+	if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+		memcpy(algt->fbname,
+		       crypto_ahash_driver_name(op->fallback_tfm),
+		       CRYPTO_MAX_ALG_NAME);
 
 	err = pm_runtime_get_sync(op->ce->dev);
 	if (err < 0)
@@ -198,22 +200,30 @@ static bool sun8i_ce_hash_need_fallback(struct ahash_request *areq)
 	algt = container_of(alg, struct sun8i_ce_alg_template, alg.hash.base);
 
 	if (areq->nbytes == 0) {
-		algt->stat_fb_len0++;
+		if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+			algt->stat_fb_len0++;
+
 		return true;
 	}
 	/* we need to reserve one SG for padding one */
 	if (sg_nents_for_len(areq->src, areq->nbytes) > MAX_SG - 1) {
-		algt->stat_fb_maxsg++;
+		if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+			algt->stat_fb_maxsg++;
+
 		return true;
 	}
 	sg = areq->src;
 	while (sg) {
 		if (sg->length % 4) {
-			algt->stat_fb_srclen++;
+			if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+				algt->stat_fb_srclen++;
+
 			return true;
 		}
 		if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
-			algt->stat_fb_srcali++;
+			if (IS_ENABLED(CONFIG_CRYPTO_DEV_SUN8I_CE_DEBUG))
+				algt->stat_fb_srcali++;
+
 			return true;
 		}
 		sg = sg_next(sg);
-- 
2.48.1

