Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4247D4F55BF
	for <linux-crypto@vger.kernel.org>; Thu,  8 Oct 2026 18:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791484127; cv=none; b=DGxBcjBmVU9MV8Yu7q7ue6SNuko1vB3IqYNNk2nKrC0/uG81eOJ7Mq9hJeB4ct2mxjCP7+8T94+NCvBlyE49LXA7wNZQxl4Zt92jK7IbrjYuy9QTuoSataPKPIemmajM232M93r8/imHFo2YgcWaeGMSc2R61aRgc6sReL3A3h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791484127; c=relaxed/simple;
	bh=rCtITXYowpLqhFRbUXPUKucGTlz+7E7YWeAElPfIAMs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BD/ZZzBkwPr3R9YoWJzJNu4o9S5GJxbbNHp91RVy3oBEf1AGcbI2FYDfyz0UDSSCnn2gdDNdcIWfksM4qkz6zH0GNGaF96gfW9M8qOOViB8vvay2mW7j6XF5sA+B6rgNGuhM8tUimYtyrDqQpMAn1ceEPAxGE/FtEnhot4K8VBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Bjz3Meml; arc=none smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Bjz3Meml"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-15dd124bbe7so4562432c88.1
        for <linux-crypto@vger.kernel.org>; Thu, 08 Oct 2026 11:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791484114; x=1792088914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4EAC3tfhBdLfYAd9CNDrPAiNc4+pBWw6wHTFnfZXC+o=;
        b=Bjz3Memlpozv+Qt8wTVrnoijMFq4mX9AAaAe45yeGNbcDOB5H8e7DeCI/TlT1+U/Kk
         ZVL05PrrQqPf9AVnjYuLqzAXUwVgfRBpaxskc3n5NJUebVBKKi59Yeqs2vzwrK9wSLva
         DhnUpRhQBa6K9oYWvHIEdwyts6TqtkzOUnkitwolujgJlglPUH9b3pOjHKeVa1W2vtVs
         Na3jfQ4gZklwiI0O2gpMH2FDMlU8awwMWrEt0+lHzDbFjj8ZVDMjHSUqrIIGEr5gsaVC
         4VkYi5v9gGl7iELeMDhuIZfbCduwWug/30qXxyxfK2452UfkJ9rvbvD06O88EJKRUhZ1
         iFCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791484114; x=1792088914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4EAC3tfhBdLfYAd9CNDrPAiNc4+pBWw6wHTFnfZXC+o=;
        b=vetLTE+HaXPez8XU6nrm631WLoju4SZKnwIwwGGE2GkEsQMGg9jBQbWhBNkkLBbsTU
         odpoCl6/7gMwR9w1rcpHTWjPLpk5FV0dcZC2C9fIR5BU9v/kBOcnVJT//f4q7DNZJYze
         ZQrCjXc6BdecfRjE2USDh6AgtHQWhfxty0IPCkmu1X2vJMwETEoFnla/D556XK3vh9tS
         9g8YhQEbnAiXFqyxLl1vtin2MkwuThXoQuOxr2e+ROfq5b+2mRlmtO5BUu2LcesXK0yl
         gjZUFrsS7N3RpIGPBaW7Sjip11wTVPhDUxVDIfbzhgwlhWGr4dKz5weoWdaPkiBtK430
         8fvA==
X-Forwarded-Encrypted: i=1; AKwUvBx9CEF4xnI70AWJD/gGN2CQiIPN/KLhSts7k6S5au25JZsMwCKhTgdw+pTFocOikFtyZpOaKYJR5sP+7D4=@vger.kernel.org
X-Gm-Message-State: AFuF++kq07WJ7/icOYEwpG6FHBKTWKk4WDSiFZhYa/g/2k1H/UrjI4qN
	rAdDgiW/iZZ+1YZ+QePG5yvKN5OzGwlTdVEC2S3Lr0UiSWsGJxq4aCsq
X-Gm-Gg: AYBFou04dxvB+PuE+t6zBQD2LLMUytrmRMmquIuEp+CmzPLdqDflM2odBVpiJrBTd39
	qdebGb58tCVLENOFLjND8NeISa1GLzKMeNHlcIN/4rNUPCm5rcR+8P1IXI4LjzfpOExEwEKLoSJ
	wSzB3Uma1u5/fu5WbsZcvI4GbpWP8Vc4PjHnSTc3OEiSs0IFJ16wmi9kZfFFfkyRxMuf8jFE3kI
	1fxvh3rfB+eflXlG8YuXBpQtQZ9H6tXkimsiFlaNSUmehapsgAnRvp/qr30mWXEiUSSbUHasy1A
	kTiYC4yd1ZZ+kGflwhEBrvWDNfGfmsKoP6UHfSwjNEHmjI3jSJPeqkrms87FcIbVJ0KG97iPLFW
	gaqf0BFnJAtwgccxntq2WHlIwkfDRGJ69NKqBWBPVE5jytZe2YSlxcniMyLanNa1dVSjCXdbEBp
	1pG3iuWUy3qGxb8e0IbpAGBGvTuujW7S4PucZpPrO6P57QDUPUL0QB0bhiJyt6Z3WtvHNjyiobK
	nCcCM88Xik=
X-Received: by 2002:a05:7022:296:10b0:168:3243:c90c with SMTP id a92af1059eb24-1683243cd45mr1540837c88.15.1791484113969;
        Thu, 08 Oct 2026 11:28:33 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-169a2d2db98sm57236c88.10.2026.10.08.11.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 11:28:33 -0700 (PDT)
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
Subject: [PATCH v1 4/8] crypto: acomp - Add API to get a compression algorithm's batch-size.
Date: Thu,  8 Oct 2026 11:28:10 -0700
Message-Id: <20261008182814.27450-5-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit adds a @batch_size data member to struct acomp_alg.

An acomp_alg compression algorithm that supports batching of
compressions and decompressions must provide a @batch_size greater
than 1, representing the maximum batch-size that the compressor
supports, so that kernel users of crypto_acomp, such as zswap, can
allocate resources for submitting multiple compress/decompress jobs that
can be batched, and invoke batching of [de]compressions.

The new crypto_acomp_batch_size() API queries the crypto_acomp's
acomp_alg for the batch-size. If the acomp_alg has registered a
@batch_size greater than 1, this is returned. If not, a default of "1"
is returned.

zswap can invoke crypto_acomp_batch_size() to query the maximum number
of requests that can be batch [de]compressed. Based on this, zswap
can use the minimum of any zswap-specific upper limits for batch-size
and the compressor's max @batch_size, to allocate batching resources.

This enables zswap to compress/decompress multiple pages as a batch
to improve swapout/swapin performance and memory savings.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
---
 crypto/acompress.c                  | 14 ++++++++++++++
 include/crypto/acompress.h          | 12 ++++++++++++
 include/crypto/internal/acompress.h |  3 +++
 3 files changed, 29 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 8c9a76073159..192ea996e779 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -318,6 +318,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
 
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
+{
+	if (acomp_is_async(tfm) &&
+		(crypto_comp_alg_common(tfm)->base.cra_flags & CRYPTO_ALG_TYPE_ACOMPRESS)) {
+		struct acomp_alg *alg = crypto_acomp_alg(tfm);
+
+		if (alg && alg->batch_size > 1)
+			return alg->batch_size;
+	}
+
+	return 1;
+}
+EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);
+
 void comp_prepare_alg(struct comp_alg_common *alg)
 {
 	struct crypto_alg *base = &alg->base;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index fc0665b77a8f..06578c4367f6 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -593,6 +593,18 @@ int crypto_acomp_compress(struct acomp_req *req);
  */
 int crypto_acomp_decompress(struct acomp_req *req);
 
+/**
+ * crypto_acomp_batch_size() -- Get the algorithm's batch size
+ *
+ * Function returns the algorithm's batch size for batching operations
+ *
+ * @tfm:	ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ *
+ * Return:	@tfm's acomp_alg's @batch_size, if it has defined a
+ *		@batch_size greater than 1; else return 1.
+ */
+unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm);
+
 static inline struct acomp_req *acomp_request_on_stack_init(
 	char *buf, struct crypto_acomp *tfm)
 {
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 93ae59623f13..b790722c263a 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -28,6 +28,8 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @batch_size:	Maximum batch-size for batching compress/decompress
+ *		operations.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -47,6 +49,7 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int batch_size;
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.39.5

