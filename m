Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793156714;
	b=KaiKqwpcFgxIYOIMh9mFjLXzb4J7SfXIoFTRJYNcrbB3rYXH4ym3oywCo8HOqRDAyiI+
	 UnLmB0IcIYT7zGk2d3WJoPO+14hoc6IDIkAjGYRaF24zxRIsjIEAi6WeEt2VmfUVqSSYr
	 BWBjJuCGTKdhKG/m3uxr1CREV+SYa7c8A0quBSkYCr9B6Ib0tpsuYTax0TaxSuW4V7IDY
	 UX+efETxeMZZM5hHXX01VmBho0GYUqtR5Mr6z8K4euToWby+cHMRRInopfwJ9d0/izZ6p
	 vrgqxFMaQeJSaWGf0MhsK7hRjlfMOR3RYuuywU+bJmMkMjvHv8nVBjlwHhIp1MMQN5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793156714;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
	b=qiKr/Lk/IWHnfqYGgoXY7I6cSWgrag5glTDfj2Z6voueSdI+z05DHPnQodn2ml795oEz
	 8/p3s+FpuaRnLwT7xpiO9QizKh+vRa3nyTMIihU8WrJNbzSWGxo59Gmg8yo6BydzlAMhQ
	 AcoOCcHR3E6xRPxcqgDHNLPoAR0YUOEYMkTEvWv6ejGlXYDFtnU93yqBcgz/gQLMQf+ST
	 Tkt6gybCe9/EnHn0TeMLJlcalV/ndIS5Wt4znF31mA3EFNc8SvBpFm4vsCojDiNia2q31
	 JW3gUnf4Z9RDrtlFLF16abocd4uGUT0hg3sc40QLliAxkQQS6KtVVKrfD15xBdrTrSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xURDjvvS;
	arc=none smtp.remote-ip=74.125.82.42
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C309606A335
	for <linux-crypto@vger.kernel.org>; Wed, 28 Oct 2026 03:05:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C309606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=xURDjvvS
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-14fc585291cso374598c88.1
        for <linux-crypto@vger.kernel.org>; Tue, 27 Oct 2026 20:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793156714; x=1793761514; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=xURDjvvS5CeRpLr54S4UykhVVOvAKez0oUIJwugpJbvq/ogwZkRBpToytSyCSXXTl+
         eCsS+bRakCxscDujSK2i2DLCMQ3uGHTXoqTXZCHixawjWfpfek/Nvotc8if974EffshR
         mD9eMMv7GhBIzbSHhZ3nu5laoXR66/toRAf80rNIXI0rOqiWi2iP5QQNgAjBXl+qEMCw
         nG8RJAhyMD4Cf364zFYIMkIyG6Utpta32ZhRWRHBLPR+YBDbN1JisKOS++tjJ0BhEU0b
         wAonOm6t2wRDNxiLBEIXEZnTp0aubcoiNUi1E1q7Ix6Wz8pZbagWuUVil//E+rZoszmb
         I7SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793156714; x=1793761514;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=utdVWrZ7wDvsHiY5NKnbSY5PtnmQf+otNqNinuRgHkM=;
        b=MOGPnOdVLK7NQAVOGH8FIBZRQqJz9+QIQFtxda3cvGFlJiVDTpPOlWQRKXq5rFYaGu
         osua1LYK+ADf5/utHPjnPlPwNc0YJF59ltvjGpwycJQHe9IVyQ4GYJQdCAT5e0Rxobaq
         kpjQps+IK2jUBXgVVeaP12s0naZAS14YrFlOI/fHxHuwGXycjnV0tuvitSinf1If6bxN
         ECdfsa3W5yFfwajb8NnwZD2hmzwddlccGLUwuT1QJk/XcjqzVMNeCJqSLqPXcXda1yW5
         bReyKwwyA8URoBIs038Fjzy3xb1JrCZ/U9Mx4EipucCXj54hHYt+H4gcBnrAvNFu3pCV
         Nn9w==
X-Forwarded-Encrypted: i=1; AKwUvBxb+OQU1Qhy6Ez4JC/RPdiFOepMmPb4AwqD1p4HjfRBorVWjV9jXb+YuoZaHqCnt7q96Pxqjz2gJTpmAyY=@vger.kernel.org
X-Gm-Message-State: AFq9FYJPxki0bTrYnYCnBEan0FST/1Ql6dGsprqO9cQHhAk7WcyhWJMI
	6N0NlPAQPejHW1xWQdQcEcF2XoPKquN+sP8f1JazdGCujcmnVHFL5VwjfuX3yw==
X-Gm-Gg: AYBFou3q0a4nZcPDF2kT1wPtQT6LbBi15p6T8UgLOhE1Xx1FiZfDv5CUy8JjC6G57q7
	1XDoQgzFU1pQWKWZBvbps9CiUwe8RDY61EvpWtPGR9VL76/jCEoLVioJ1LnO1/pp5Tzji7KxTux
	O9CQiVpC6FUE9zcGARuq1/SH6NXPOjKmF/Pod6NuObPoZPa+uhv3UPqaNbCEsXgctc1s2qPtw2d
	QCwPYO55QCIWe4olGes34twsmXx0CBWVsdu9gTYFbzblYnB3w0Qh8621dFaMb5zOCZ4z5aj9jM2
	Fi3dc0Y0Xrus3d1Ry/EfIOHcQGGFQJ6B7RYR57iJy8rLDJyXdPRwgHrOHMFyshULwkD+DM7EEnE
	nZqnijdhxFFfz3BOhFamDQKEisqP6czmDYhVfiZlq3NAym014fJ5SX9tQOWp0IAApWkawEJD1yv
	u3RMjYOKe2LStBrrJkvX+KztBVB/e8h6jyWYFqhGx2HJW56ah3R9aBq90NaL8T9r6Cl2hS7PFOe
	LKomfaKF6wj0n2Rk1MMD9e/33sflyZTtS0Zz0kkS8uNm38jGUlDQo7kPUqzRMQEWzEO+XeuK3Vl
	f1ih1hhQ0Fq5gllW2ypX2wDVARGMYydE4GBii2r4rg==
X-Received: by 2002:a05:7022:404:b0:14f:b5ac:ace4 with SMTP id a92af1059eb24-1a6d00d22femr1741148c88.44.1793156713549;
        Tue, 27 Oct 2026 20:05:13 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm1150734c88.3.2026.10.27.20.05.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 20:05:12 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kanchanapsridhar2026@gmail.com,
	linux-kernel@vger.kernel.org
Cc: rientjes@google.com,
	willy@infradead.org,
	senozhatsky@chromium.org
Subject: [PATCH v2 2/8] crypto: acomp - Add bit to indicate segmentation support.
Date: Tue, 27 Oct 2026 20:04:57 -0700
Message-Id: <20261028030503.17923-3-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch adds segmentation support for compression.

Add a bit to the crypto_alg flags to indicate support for segmentation.
Also add a helper for acomp to test whether a given tfm supports
segmentation.

Co-developed-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 include/crypto/algapi.h             | 5 +++++
 include/crypto/internal/acompress.h | 5 +++++
 include/linux/crypto.h              | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 05deea9dac5e..7d406cfe5751 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -280,6 +280,11 @@ static inline bool crypto_tfm_req_virt(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_VIRT;
 }
 
+static inline bool crypto_tfm_req_seg(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_REQ_SEG;
+}
+
 static inline u32 crypto_request_flags(struct crypto_async_request *req)
 {
 	return req->flags & ~CRYPTO_TFM_REQ_ON_STACK;
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 9cd37df32dc4..93ae59623f13 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -189,6 +189,11 @@ static inline bool crypto_acomp_req_virt(struct crypto_acomp *tfm)
 	return crypto_tfm_req_virt(&tfm->base);
 }
 
+static inline bool crypto_acomp_req_seg(struct crypto_acomp *tfm)
+{
+	return crypto_tfm_req_seg(&tfm->base);
+}
+
 void crypto_acomp_free_streams(struct crypto_acomp_streams *s);
 int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s);
 
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index b7c97f1c47c9..78c699ac3f82 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -139,6 +139,9 @@
 /* Set if the algorithm cannot have a fallback (e.g., phmac). */
 #define CRYPTO_ALG_NO_FALLBACK		0x00080000
 
+/* Set if the algorithm supports segmentation. */
+#define CRYPTO_ALG_REQ_SEG		0x00100000
+
 /* The high bits 0xff000000 are reserved for type-specific flags. */
 
 /*
-- 
2.39.5

