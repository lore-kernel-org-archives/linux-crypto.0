Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2994337171;
	Sat, 23 Nov 2024 07:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732345292; cv=none; b=Qdio1gqZh4eNCDFdSDrfD2PqEYELxMs3rtWJKcQJoj9QD3lXkJ+cvM9u4Ksgpm/U1JT73WunU/t/ahpH/mqqGfKBj+a4yqnYcw2Kyhs/BmMR5+38QUmuAt5z8xoQAIhfKfyTh8zZbsWZ03g8WSKIU2xps2Hwa37oRi3z9Jyi76Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732345292; c=relaxed/simple;
	bh=eLUZRvzAb/JMAqXqi3XSFoRGRNFvuqn37EsysAuIq7I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aFZNrU3NeQD5nDS6UB+qjkBlHHQUq4veIQ8LGow53XKwQckWcljoKmwn7k8ikIZEoYE+M0rrGREYfEUgtVg9QV2sMuTP8HwHM9XRJsElvN0hsjhotsfexIV5j+6osABv2kWZM/EztwuulZ/7pp3aFprnpSe6yhL+CElKDvsUWxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tq5juvSF; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tq5juvSF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732345291; x=1763881291;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eLUZRvzAb/JMAqXqi3XSFoRGRNFvuqn37EsysAuIq7I=;
  b=Tq5juvSFJtZoG+LWAuv46El/Hbrq44nUhemPbGmWiEmYy5OTSq5m1Qad
   IPAMLnR1rFYnS/N0Z7D3Tk0y5OdyokYbTC2qzZxEP93kTrQ+G2Wc51Yt1
   Jz+h53e83ACs1SVN9kLeHZaPKZojI83K/9++Cjp5fBk7YMnJ3QHOmI9bX
   6gz0Vvn+sFb7vhmDhZuK3KIcMN3mrqy1rD3cdBGsmGWfz2D2YNMbEIg2J
   l3AejDupT12OvB7tAia97lXRM+pvTnH7RCp0GmhiGRbEM9mYGDEjamknE
   rRYzrkKgkDClAJTMdQlay7AKZyGZcATg9XFfwit2xI8pj1RV31AhjvG9v
   Q==;
X-CSE-ConnectionGUID: tjQvXiUTS3GOOX1Sz4AhCg==
X-CSE-MsgGUID: 1tGfB3c3QRuU+gRht0pspA==
X-IronPort-AV: E=McAfee;i="6700,10204,11264"; a="32435459"
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="32435459"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Nov 2024 23:01:28 -0800
X-CSE-ConnectionGUID: nicOeVJqS2iI9cBEFnDBKg==
X-CSE-MsgGUID: +RhtWcv3QkidP9LiFSjxvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,178,1728975600"; 
   d="scan'208";a="91573547"
Received: from unknown (HELO JF5300-B11A338T.jf.intel.com) ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 22 Nov 2024 23:01:28 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
	ying.huang@intel.com,
	21cnbao@gmail.com,
	akpm@linux-foundation.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v4 01/10] crypto: acomp - Define two new interfaces for compress/decompress batching.
Date: Fri, 22 Nov 2024 23:01:18 -0800
Message-Id: <20241123070127.332773-2-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit adds batch_compress() and batch_decompress() interfaces to:

  struct acomp_alg
  struct crypto_acomp

This allows the iaa_crypto Intel IAA driver to register implementations for
the batch_compress() and batch_decompress() API, that can subsequently be
invoked from the kernel zswap/zram swap modules to compress/decompress
up to CRYPTO_BATCH_SIZE (i.e. 8) pages in parallel in the IAA hardware
accelerator to improve swapout/swapin performance.

A new helper function acomp_has_async_batching() can be invoked to query
if a crypto_acomp has registered these batch_compress and batch_decompress
interfaces.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 crypto/acompress.c                  |  2 +
 include/crypto/acompress.h          | 91 +++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h | 16 +++++
 3 files changed, 109 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 6fdf0ff9f3c0..a506db499a37 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -71,6 +71,8 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
+	acomp->batch_compress = alg->batch_compress;
+	acomp->batch_decompress = alg->batch_decompress;
 	acomp->dst_free = alg->dst_free;
 	acomp->reqsize = alg->reqsize;
 
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 54937b615239..4252bab3d0e1 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -37,12 +37,20 @@ struct acomp_req {
 	void *__ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
+/*
+ * The max compress/decompress batch size, for crypto algorithms
+ * that support batch_compress and batch_decompress API.
+ */
+#define CRYPTO_BATCH_SIZE 8UL
+
 /**
  * struct crypto_acomp - user-instantiated objects which encapsulate
  * algorithms and core processing logic
  *
  * @compress:		Function performs a compress operation
  * @decompress:		Function performs a de-compress operation
+ * @batch_compress:	Function performs a batch compress operation
+ * @batch_decompress:	Function performs a batch decompress operation
  * @dst_free:		Frees destination buffer if allocated inside the
  *			algorithm
  * @reqsize:		Context size for (de)compression requests
@@ -51,6 +59,20 @@ struct acomp_req {
 struct crypto_acomp {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	void (*batch_compress)(struct acomp_req *reqs[],
+			       struct crypto_wait *wait,
+			       struct page *pages[],
+			       u8 *dsts[],
+			       unsigned int dlens[],
+			       int errors[],
+			       int nr_pages);
+	void (*batch_decompress)(struct acomp_req *reqs[],
+				 struct crypto_wait *wait,
+				 u8 *srcs[],
+				 struct page *pages[],
+				 unsigned int slens[],
+				 int errors[],
+				 int nr_pages);
 	void (*dst_free)(struct scatterlist *dst);
 	unsigned int reqsize;
 	struct crypto_tfm base;
@@ -142,6 +164,13 @@ static inline bool acomp_is_async(struct crypto_acomp *tfm)
 	       CRYPTO_ALG_ASYNC;
 }
 
+static inline bool acomp_has_async_batching(struct crypto_acomp *tfm)
+{
+	return (acomp_is_async(tfm) &&
+		(crypto_comp_alg_common(tfm)->base.cra_flags & CRYPTO_ALG_TYPE_ACOMPRESS) &&
+		tfm->batch_compress && tfm->batch_decompress);
+}
+
 static inline struct crypto_acomp *crypto_acomp_reqtfm(struct acomp_req *req)
 {
 	return __crypto_acomp_tfm(req->base.tfm);
@@ -265,4 +294,66 @@ static inline int crypto_acomp_decompress(struct acomp_req *req)
 	return crypto_acomp_reqtfm(req)->decompress(req);
 }
 
+/**
+ * crypto_acomp_batch_compress() -- Invoke asynchronous compress of
+ *                                  a batch of requests
+ *
+ * Function invokes the asynchronous batch compress operation
+ *
+ * @reqs: @nr_pages asynchronous compress requests.
+ * @wait: crypto_wait for synchronous acomp batch compress. If NULL, the
+ *        driver must provide a way to process completions asynchronously.
+ * @pages: Pages to be compressed.
+ * @dsts: Pre-allocated destination buffers to store results of compression.
+ * @dlens: Will contain the compressed lengths.
+ * @errors: zero on successful compression of the corresponding
+ *          req, or error code in case of error.
+ * @nr_pages: The number of pages, up to CRYPTO_BATCH_SIZE,
+ *            to be compressed.
+ */
+static inline void crypto_acomp_batch_compress(struct acomp_req *reqs[],
+					       struct crypto_wait *wait,
+					       struct page *pages[],
+					       u8 *dsts[],
+					       unsigned int dlens[],
+					       int errors[],
+					       int nr_pages)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(reqs[0]);
+
+	return tfm->batch_compress(reqs, wait, pages, dsts,
+				   dlens, errors, nr_pages);
+}
+
+/**
+ * crypto_acomp_batch_decompress() -- Invoke asynchronous decompress of
+ *                                    a batch of requests
+ *
+ * Function invokes the asynchronous batch decompress operation
+ *
+ * @reqs: @nr_pages asynchronous decompress requests.
+ * @wait: crypto_wait for synchronous acomp batch decompress. If NULL, the
+ *        driver must provide a way to process completions asynchronously.
+ * @srcs: The src buffers to be decompressed.
+ * @pages: The pages to store the decompressed buffers.
+ * @slens: Compressed lengths of @srcs.
+ * @errors: zero on successful compression of the corresponding
+ *          req, or error code in case of error.
+ * @nr_pages: The number of pages, up to CRYPTO_BATCH_SIZE,
+ *            to be decompressed.
+ */
+static inline void crypto_acomp_batch_decompress(struct acomp_req *reqs[],
+						 struct crypto_wait *wait,
+						 u8 *srcs[],
+						 struct page *pages[],
+						 unsigned int slens[],
+						 int errors[],
+						 int nr_pages)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(reqs[0]);
+
+	return tfm->batch_decompress(reqs, wait, srcs, pages,
+				     slens, errors, nr_pages);
+}
+
 #endif
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 8831edaafc05..acfe2d9d5a83 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -17,6 +17,8 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @batch_compress:	Function performs a batch compress operation
+ * @batch_decompress:	Function performs a batch decompress operation
  * @dst_free:	Frees destination buffer if allocated inside the algorithm
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
@@ -37,6 +39,20 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	void (*batch_compress)(struct acomp_req *reqs[],
+			       struct crypto_wait *wait,
+			       struct page *pages[],
+			       u8 *dsts[],
+			       unsigned int dlens[],
+			       int errors[],
+			       int nr_pages);
+	void (*batch_decompress)(struct acomp_req *reqs[],
+				 struct crypto_wait *wait,
+				 u8 *srcs[],
+				 struct page *pages[],
+				 unsigned int slens[],
+				 int errors[],
+				 int nr_pages);
 	void (*dst_free)(struct scatterlist *dst);
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
-- 
2.27.0

