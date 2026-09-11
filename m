Received: from mail-lr2-f10.google.com (mail-lr2-f10.google.com [74.125.230.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7D47606B
	for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 12:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789129930; cv=none; b=MMdWr06ctLKpmVuSApBdVIVGqYX8hf+UphhVWf/Tbw9oK4QrEA9PjDwzVlplhWzTP+D5FqD3Y5KI5QZukcYXgy/DUiOZCsi2NvQRE5GuUu4XQIejoDr0V4RGLYqDAqpDuKnnaZ6j1r7HOMie7+KEItSTaVXIOBMfn74q+wyYzF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789129930; c=relaxed/simple;
	bh=A2CvdhG7/vIyoUeGkv5E4Ugr/imarWjFKS/kJBdETX0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aeGYlhifGdMaZ4oxFieEgnul6WHuwMSN/SIOuPQ6GtfzZkaqQ1EQbwp5Q3ExYLxf6PMokFYc9hpaRkFYfBOKs1ZSw7Ci7dsccukHeR/Y9RadUqOlvuUDnx0RUiLnBaM5sYFKSUfvLKx8H5RVe5Af3uNnZ/+Psc/6WsUIeAcw2gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OTeLwa6L; arc=none smtp.client-ip=74.125.230.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OTeLwa6L"
Received: by mail-lr2-f10.google.com with SMTP id 38308e7fff4ca-3a46d5c5bd7so5098151fa.1
        for <linux-crypto@vger.kernel.org>; Fri, 11 Sep 2026 05:32:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789129917; x=1789734717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QnJBFBfRn5myQJHTDGn3pEafZ8mzs7RtDdyu8ZdsQwo=;
        b=OTeLwa6LRDrdvM0CXgSsIkzWuO2Yf5+q1U55b8O8Qqd/AbLK4k7enyrGV2/RqenOEj
         V9X4RUQ7ELDWdYi02ArPQOXtf7XB1Swm1Tjjtl/T3a3/AJcHiy6BZUXTrcrmvlVFu84L
         zhBpIqa6SvG4eOvh0F+gBATF25vOkt7PqBn4rEa3fNpybAEuuOTVD0iPnfMRlK0D2uvb
         zaFiUABMEH8xSwsqxzg1ZQK/YdfX2ph38IynUMdFBGcO2VgRgJJgzBpBJ4pgpQjFu5QI
         cKLspNb4tk0W2qlQDl8Vsx/8NRZZoRz+GGCdz7LzTWseo6QZrlLbmfUeq8Tpv9lgYSgv
         vdeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789129917; x=1789734717;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QnJBFBfRn5myQJHTDGn3pEafZ8mzs7RtDdyu8ZdsQwo=;
        b=cWHWLDjXJmcp3CUDTljGfa0wLTBONNiuj0tJhL8UpYrwvMF32j2sLSNfDBKDtJIGLw
         9gd7av33syaXB2qrzdQL6w7JZ5d9/0pEJoo+DMPj7xTcqCC5MqVJN4MBoRqaMXucaI7i
         wfmbX1u12N8Aq92V/DU6J/C8cwaqnlizT2l8ponm+ZFTaS3TrhVhLgXuGjX1wqLDzLQW
         EKl93qSdObuhJToE8MHDbWD7ompVnTRKGawJNAGGX3Jch7Keya+Q0t3yK4z74b0nxNB1
         08dRCpr7Ur61uAW8BKYYR6hn+T7Ek4Q2nCdfzPzatfiXc6dpvoopoARzJ2JL1KpF5CqU
         vPOg==
X-Forwarded-Encrypted: i=1; AKwUvBxtQJ8x9vZ97n+egplus9Vk5aNScyXIfyxPQTvSuH3GGZzRBX12UYOmfugmiyzdIQRZQduiVHTX9GdGpbs=@vger.kernel.org
X-Gm-Message-State: AFuF++lLgutFApMqCWH/whd4kEUQV+p2wLfRK9G54hSFXn14CnXp4by6
	GmKoIcovv5rmFCMAoow2pA6c2GjZpvySHCLAd1SXVU0qRpI8RoQZBFdu
X-Gm-Gg: AYBFou1DbnZC8JP3HyuWJja5SLAXWJ7sGZkLUS2gTOc4Z0Qy8JiJJ1uqsSGI4TVllR+
	hPqyu/tA6QYWDieLDgk/XcFNCi4NZj6SicrRSIVa7n1u2pgS/JzAAFGBECEIlXsj7tPEmW5oejc
	OtGdv2CPXcDxAmXwVvIlbMg9L61zRq8arrtvHZvUE2bbuhgMyBXKkp6QVzzLrneJhXhbEYNyblA
	g1XrjDvm8veLrW0foUlxi4z4U124Zs4ZZH3WN5kQ24H+cKL/T/wchgWo3H8rC41kG7eWEp5lD1w
	DRT6aGZnY2rrtz1omAOSYUNN8VZD1IKLQKNXbdRwtS0gQeQZdDgoH7hxstOEF4kFeIhvASxhInC
	iXIgQOCf5UKq2TCjlE0i2RxPI/yEAkbhSzWb3Bxr+COtK/knCkhDhOMn9PQD8fuEJOe/UNj1AqG
	ZwbnhSjqPTUvsHcOcbQWWDgegmsr0ydf2t2wePhxJhwWAXhJl98TiWCkQsF10DNBgAi+Xv8Bfzf
	sIrj4c/4SLFWE7PXrbhkaZRGN0=
X-Received: by 2002:a05:6512:3f25:b0:5b6:1a7c:20 with SMTP id 2adb3069b0e04-5b8a032c8abmr874241e87.35.1789129916639;
        Fri, 11 Sep 2026 05:31:56 -0700 (PDT)
Received: from localhost.localdomain ([78.40.184.2])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8a033149fsm576697e87.0.2026.09.11.05.31.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 05:31:56 -0700 (PDT)
From: Roman Demidov <roman.demidov.nn@gmail.com>
To: stable@vger.kernel.org
Cc: Roman Demidov <roman.demidov.nn@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH 5.10] crypto: ecdh - explicitly zeroize private_key
Date: Fri, 11 Sep 2026 15:31:37 +0300
Message-ID: <20260911123140.137198-1-roman.demidov.nn@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joachim Vandersmissen <git@jvdsn.com>

commit 73e5984e540a76a2ee1868b91590c922da8c24c9 upstream.

private_key is overwritten with the key parameter passed in by the
caller (if present), or alternatively a newly generated private key.
However, it is possible that the caller provides a key (or the newly
generated key) which is shorter than the previous key. In that
scenario, some key material from the previous key would not be
overwritten. The easiest solution is to explicitly zeroize the entire
private_key array first.

Note that this patch slightly changes the behavior of this function:
previously, if the ecc_gen_privkey failed, the old private_key would
remain. Now, the private_key is always zeroized. This behavior is
consistent with the case where params.key is set and ecc_is_key_valid
fails.

Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[ Roman: The zeroing is performed before ecdh_supported_curve() which is
not present in upstream but this does not change the fix's logic. ]
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
---
Backport fix for BDU:2025-00987

 crypto/ecdh.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/ecdh.c b/crypto/ecdh.c
index 96f80c8f8e30..2e7acfc42155 100644
--- a/crypto/ecdh.c
+++ b/crypto/ecdh.c
@@ -43,6 +43,8 @@ static int ecdh_set_secret(struct crypto_kpp *tfm, const void *buf,
 	    params.key_size > sizeof(ctx->private_key))
 		return -EINVAL;
 
+	memset(ctx->private_key, 0, sizeof(ctx->private_key));
+
 	ndigits = ecdh_supported_curve(params.curve_id);
 	if (!ndigits)
 		return -EINVAL;
-- 
2.53.0

