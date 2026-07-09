Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFDA3BED70
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jul 2026 19:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783626061; cv=none; b=RuEzN4E7ivvNE7bEngiODpGhVT0ULH6qQAzmksioynzj3nuw/e/R6l9gVWy2uvm8XFZgfrHSprmekWTRtUHt+Zy3q66p7nTi0jFV5Y3E8fFYyJPoTfOwbVxxhDLleTuVpiRTBrBxDG+yhmP344URVe4GxtEXv87tbBWjuDUVCts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783626061; c=relaxed/simple;
	bh=65Idyz1sDs9eWG2wgPYu7Qcgmm8fUR/7vH9Y0/N6jM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODXMYdOkxt1Lquke3UPurs6Z0SfujZRm1UsTJS5wrJc+D55RtwIoMXDfl2g0tAClpCeN9NbXfydNHmapuciXfctwqA1qNeqk7IP//ZseLoMgBSWLbcUOAA7JS3wlkdOlYHUkGPAZGrfmCo/r6krGY+1jnaog7B9Ku1nsPuQ4EwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LCd77N5C; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LCd77N5C"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493b27c7451so16566455e9.0
        for <linux-crypto@vger.kernel.org>; Thu, 09 Jul 2026 12:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783626058; x=1784230858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4x0XMO7ZOolpmBLxmTy2H2GAqq0zcQmA38pNAG6AsLI=;
        b=LCd77N5CIvdkHfctwufaX5ziHRIczsJnStcnRFZS1t3LgspBj4fKT4TUnpUnlcbH9C
         nRZh9aAyu/vPcFlv5dGh4hxJyYLgQqfNXGgQvrBnAzRE2lZAEo8UxQ3XHju+1qdb0dSK
         mkyfshatvKyG8uXG3cAxzsPUZSi5qzv6EmFCwhqsR2mQuXSp0ywqyI3zHoOw99dbzD2i
         Cn++tgqbpF/6PNUrbgbTBrgOpSC1lXF0hkfeTDQ3Xf1dFJJgrZUfZL4GCWqwLCEZb3CN
         e0ejhINUdZjw9zAh1Qm6vmj+B7tMrP8NQGCLGCE6xmHlZGX1+Z7j6/hAzewIlUQ4l4vM
         ZZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783626058; x=1784230858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4x0XMO7ZOolpmBLxmTy2H2GAqq0zcQmA38pNAG6AsLI=;
        b=bDVuUmWQOjdrhCAmf99i3la+mwsUJSWxKVc07gEVKtfNAlNCSZmDRlmVJLdWv8iTRo
         o/+n6X8ePOe80RB902VTdB6vnJdui933sVnWy9Xk+HEsBPvEaxjDzX5R6/vJBeegL3OF
         p4aIdvxF7gnoPA6doMzzNz+3ThYBhu8uHGx0Se7kJpL3YFE+rgZpeZXwoeFgYuxatoGN
         43pXEvo/oC0NBfFQuKQtBHhVCi+vDF4d4U91a8Qdezq6166U3qA71RzpsJN/COSZ5ouO
         jspcDZEzH/pAEldSo9+h699UWo7ixjCPKAWKIq7P5eY2yEGA1csr4Z6ZSxqiBM81cn2W
         JxZw==
X-Forwarded-Encrypted: i=1; AHgh+RpLpoqA2FeCVwaapuPpIeg5DjCUmwo9XBo+NdV/t8sn1IjsRKcLr4fbYbBU8SK52NWw71uJYpy+tmGTbYo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwztmWkqY462kcuS7b6/wQH5y94lV/ZLPRJ0fAm+znd0f0joEr8
	mVIde+ad2IuD0l4hgpC5aNd6M8TkicH4w1fTW6SY/cOQNuYCycW2SS82
X-Gm-Gg: AfdE7cn0tGu2/dwmscz548rbMIxTG76nLWfwJhSeaW01yCfdACq16I2HiuMVMjhrQrB
	qG0hYBSbxGDRBmr9hw+P0eQn9u3VYP1PhVp0sCgaQ+u0mWiA1K6YZMQ3/YUnIuQ+/B9PvJDFFt5
	akOMzyDBOs9r4rqD4pq/LB6N4jusHlSplfsIxOWucB6Lb9QdG2vwg4aM/F58C+rbQLqbeP/LLnX
	ZpGHEqb8PdwuQetXA+A3sbmTh+zctyigONkA+g5blRox3qwEpWHQCRF+hfvW9ELg6cGeSkk7VkS
	kJiJeCgAvbBoVS3lRGmqNhuKcm2HH05JHuolYQDX/dVdefHugDVfmc/DK9lPJkT+OV69PnHU3cf
	HuC94dhuAVU3R3aTUssaS1USvlwcDZG8RpjaJ4qp5oIbws+tAehojARgyWxAfzniXObDFdFUtsU
	I5V41swNa3aTBJqskUJq3NOmSg
X-Received: by 2002:a05:6000:40e0:b0:470:8e2b:9c84 with SMTP id ffacd0b85a97d-47ef695b55dmr753432f8f.7.1783626057578;
        Thu, 09 Jul 2026 12:40:57 -0700 (PDT)
Received: from mini.main.internal ([2a02:908:c211:cd18:d9f3:ab2b:ac6e:fc84])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0a558easm53986441f8f.27.2026.07.09.12.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 12:40:56 -0700 (PDT)
From: Goetz Goerisch <ggoerisch@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ggoerisch@gmail.com,
	herbert@gondor.apana.org.au,
	herve.codina@bootlin.com,
	linux-crypto@vger.kernel.org,
	miquel.raynal@bootlin.com,
	paul.louvel@bootlin.com,
	sashal@kernel.org,
	stable@vger.kernel.org,
	thomas.petazzoni@bootlin.com,
	Eric Biggers <ebiggers@google.com>
Subject: [PATCH 3/5] crypto: talitos - stop using crypto_ahash::init
Date: Thu,  9 Jul 2026 21:39:54 +0200
Message-ID: <20260709193956.15619-4-ggoerisch@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260709193956.15619-1-ggoerisch@gmail.com>
References: <2026070912-pluck-bagful-2a71@gregkh>
 <20260709193956.15619-1-ggoerisch@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

commit 9826d1d6ed5f86cb3d61610b3b1fe31e96a40418 upstream.

The function pointer crypto_ahash::init is an internal implementation
detail of the ahash API that exists to help it support both ahash and
shash algorithms.  With an upcoming refactoring of how the ahash API
supports shash algorithms, this field will be removed.

Some drivers are invoking crypto_ahash::init to call into their own
code, which is unnecessary and inefficient.  The talitos driver is one
of those drivers.  Make it just call its own code directly.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/talitos.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 4ca4fbd227bc..a941ec08817e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2119,13 +2119,14 @@ static int ahash_finup(struct ahash_request *areq)
 
 static int ahash_digest(struct ahash_request *areq)
 {
-	struct talitos_ahash_req_ctx *req_ctx = ahash_request_ctx(areq);
-	struct crypto_ahash *ahash = crypto_ahash_reqtfm(areq);
-
-	ahash->init(areq);
-	req_ctx->last = 1;
+	ahash_init(areq);
+	return ahash_finup(areq);
+}
 
-	return ahash_process_req(areq, areq->nbytes);
+static int ahash_digest_sha224_swinit(struct ahash_request *areq)
+{
+	ahash_init_sha224_swinit(areq);
+	return ahash_finup(areq);
 }
 
 static int ahash_export(struct ahash_request *areq, void *out)
@@ -3242,6 +3243,8 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 		    (!strcmp(alg->cra_name, "sha224") ||
 		     !strcmp(alg->cra_name, "hmac(sha224)"))) {
 			t_alg->algt.alg.hash.init = ahash_init_sha224_swinit;
+			t_alg->algt.alg.hash.digest =
+				ahash_digest_sha224_swinit;
 			t_alg->algt.desc_hdr_template =
 					DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU |
 					DESC_HDR_SEL0_MDEUA |
-- 
2.55.0

