Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F752144A8;
	Thu,  6 Feb 2025 07:21:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826469; cv=none; b=H18IGq8tIZnIgwKM/ih513sG/238SNBDg0hVo/+dEnEWvfrexyuivcjEwgFApH4wE+ljuKU97M+6SBK2mNcfWE9way9eoyUgrhEqhH+LzcBqdn0GbdPz2s9kJvTQU773X4nnQ4yDqKMa8ZPGViDWQ8wz/Z2jeakhZLYKiWizCUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826469; c=relaxed/simple;
	bh=+lL68B5VDme0ssy20KVs9HZUu1uuo/887sCYSoPmBdw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=B558eIgBoPJLxg+sFNU4WGB+d/cWFufkO+QXWdv/CdvR8J9beFMWQrotWDbLV3qZw0eXZAK0IndfpFljUgNIfmHsjhFVujCCQGkziB+hy/qcHXM6eicgrARXWraxJXKJ67i/Vdzl6Bt+SLAkqRT2pc1AIe03tovy/VsZ4fQUjS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=E2gAs46d; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="E2gAs46d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738826468; x=1770362468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+lL68B5VDme0ssy20KVs9HZUu1uuo/887sCYSoPmBdw=;
  b=E2gAs46d6bgpctahzmsFVdb0sXg++QPbacl2X67VvWyJc8g1UMQkcKIw
   AWU9pRc9uQsGOHGd8MhT5bYzxwJqxpZIFvQqgEGy7mHa7HoIt3qLmO4U6
   vgA+KvPxdTxKY+q1KE9LA4Yy4+bhXvZdYE7QSWr+fN6MIAVe5ge6srmeh
   eKa9ar3qcE0V0zAyjr3l4hsNpyewspamrp0No/v5ErjCOMH6iqtQC7sMl
   RxVZ/rHvOovZ0c+lwvFA7zGOwS8eW7mIMXUXzt1VebJjnAy7EpOQPWyES
   niCN3piE27BuvK276TubkUQ5Tniqlov44b+h2mfUUP5LMzTz7saxCNm/y
   Q==;
X-CSE-ConnectionGUID: TxHKUeTaRRKh2bs0GrlAvQ==
X-CSE-MsgGUID: ViVvWixJSZO7AiTS9XFybQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11336"; a="56962615"
X-IronPort-AV: E=Sophos;i="6.13,263,1732608000"; 
   d="scan'208";a="56962615"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2025 23:21:04 -0800
X-CSE-ConnectionGUID: MlGTuHLKSGqLU3rmNEC52Q==
X-CSE-MsgGUID: xD8N+IO/Rm2SXpljUYj/EA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="112022596"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 05 Feb 2025 23:21:03 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	usamaarif642@gmail.com,
	ryan.roberts@arm.com,
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
Subject: [PATCH v6 02/16] crypto: acomp - Define new interfaces for compress/decompress batching.
Date: Wed,  5 Feb 2025 23:20:48 -0800
Message-Id: <20250206072102.29045-3-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit adds get_batch_size(), batch_compress() and batch_decompress()
interfaces to:

  struct acomp_alg
  struct crypto_acomp

A crypto_acomp compression algorithm that supports batching of compressions
and decompressions must provide implementations for these API.

A new helper function acomp_has_async_batching() can be invoked to query if
a crypto_acomp has registered these batching interfaces.

A higher level module like zswap can call acomp_has_async_batching() to
detect if the compressor supports batching, and if so, it can call
the new crypto_acomp_batch_size() to detect the maximum batch-size
supported by the compressor. Based on this, zswap can use the minimum of
any zswap-specific upper limits for batch-size and the compressor's max
batch-size, to allocate batching resources.

This allows the iaa_crypto Intel IAA driver to register implementations for
the get_batch_size(), batch_compress() and batch_decompress() acomp_alg
interfaces, that can subsequently be invoked from the kernel zswap/zram
modules to compress/decompress pages in parallel in the IAA hardware
accelerator to improve swapout/swapin performance through these newly added
corresponding crypto_acomp API:

  crypto_acomp_batch_size()
  crypto_acomp_batch_compress()
  crypto_acomp_batch_decompress()

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 crypto/acompress.c                  |   3 +
 include/crypto/acompress.h          | 111 ++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |  19 +++++
 3 files changed, 133 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index cb6444d09dd7..165559a8b9bd 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -84,6 +84,9 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
+	acomp->get_batch_size = alg->get_batch_size;
+	acomp->batch_compress = alg->batch_compress;
+	acomp->batch_decompress = alg->batch_decompress;
 	acomp->dst_free = alg->dst_free;
 	acomp->reqsize = alg->reqsize;
 
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index eadc24514056..8451ade70fd8 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -43,6 +43,10 @@ struct acomp_req {
  *
  * @compress:		Function performs a compress operation
  * @decompress:		Function performs a de-compress operation
+ * @get_batch_size:     Maximum batch-size for batching compress/decompress
+ *                      operations.
+ * @batch_compress:	Function performs a batch compress operation
+ * @batch_decompress:	Function performs a batch decompress operation
  * @dst_free:		Frees destination buffer if allocated inside the
  *			algorithm
  * @reqsize:		Context size for (de)compression requests
@@ -51,6 +55,21 @@ struct acomp_req {
 struct crypto_acomp {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int (*get_batch_size)(void);
+	bool (*batch_compress)(struct acomp_req *reqs[],
+			       struct crypto_wait *wait,
+			       struct page *pages[],
+			       u8 *dsts[],
+			       unsigned int dlens[],
+			       int errors[],
+			       int nr_pages);
+	bool (*batch_decompress)(struct acomp_req *reqs[],
+				 struct crypto_wait *wait,
+				 u8 *srcs[],
+				 struct page *pages[],
+				 unsigned int slens[],
+				 int errors[],
+				 int nr_pages);
 	void (*dst_free)(struct scatterlist *dst);
 	unsigned int reqsize;
 	struct crypto_tfm base;
@@ -142,6 +161,13 @@ static inline bool acomp_is_async(struct crypto_acomp *tfm)
 	       CRYPTO_ALG_ASYNC;
 }
 
+static inline bool acomp_has_async_batching(struct crypto_acomp *tfm)
+{
+	return (acomp_is_async(tfm) &&
+		(crypto_comp_alg_common(tfm)->base.cra_flags & CRYPTO_ALG_TYPE_ACOMPRESS) &&
+		tfm->get_batch_size && tfm->batch_compress && tfm->batch_decompress);
+}
+
 static inline struct crypto_acomp *crypto_acomp_reqtfm(struct acomp_req *req)
 {
 	return __crypto_acomp_tfm(req->base.tfm);
@@ -306,4 +332,89 @@ static inline int crypto_acomp_decompress(struct acomp_req *req)
 	return crypto_acomp_reqtfm(req)->decompress(req);
 }
 
+/**
+ * crypto_acomp_batch_size() -- Get the algorithm's batch size
+ *
+ * Function returns the algorithm's batch size for batching operations
+ *
+ * @tfm:	ACOMPRESS tfm handle allocated with crypto_alloc_acomp()
+ *
+ * Return:	crypto_acomp's batch size.
+ */
+static inline unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
+{
+	if (acomp_has_async_batching(tfm))
+		return tfm->get_batch_size();
+
+	return 1;
+}
+
+/**
+ * crypto_acomp_batch_compress() -- Invoke asynchronous compress of
+ *                                  a batch of requests
+ *
+ * Function invokes the asynchronous batch compress operation
+ *
+ * @reqs: @nr_pages asynchronous compress requests.
+ * @wait: crypto_wait for acomp batch compress with synchronous/asynchronous
+ *        request chaining. If NULL, the driver must provide a way to process
+ *        request completions asynchronously.
+ * @pages: Pages to be compressed.
+ * @dsts: Pre-allocated destination buffers to store results of compression.
+ * @dlens: Will contain the compressed lengths.
+ * @errors: zero on successful compression of the corresponding
+ *          req, or error code in case of error.
+ * @nr_pages: The number of pages to be compressed.
+ *
+ * Returns true if all compress requests complete successfully,
+ * false otherwise.
+ */
+static inline bool crypto_acomp_batch_compress(struct acomp_req *reqs[],
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
+ * @wait: crypto_wait for acomp batch decompress with synchronous/asynchronous
+ *        request chaining. If NULL, the driver must provide a way to process
+ *        request completions asynchronously.
+ * @srcs: The src buffers to be decompressed.
+ * @pages: The pages to store the decompressed buffers.
+ * @slens: Compressed lengths of @srcs.
+ * @errors: zero on successful compression of the corresponding
+ *          req, or error code in case of error.
+ * @nr_pages: The number of pages to be decompressed.
+ *
+ * Returns true if all decompress requests complete successfully,
+ * false otherwise.
+ */
+static inline bool crypto_acomp_batch_decompress(struct acomp_req *reqs[],
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
index 53b4ef59b48c..df0e192801ff 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -17,6 +17,10 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @get_batch_size:     Maximum batch-size for batching compress/decompress
+ *                      operations.
+ * @batch_compress:	Function performs a batch compress operation
+ * @batch_decompress:	Function performs a batch decompress operation
  * @dst_free:	Frees destination buffer if allocated inside the algorithm
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
@@ -37,6 +41,21 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int (*get_batch_size)(void);
+	bool (*batch_compress)(struct acomp_req *reqs[],
+			       struct crypto_wait *wait,
+			       struct page *pages[],
+			       u8 *dsts[],
+			       unsigned int dlens[],
+			       int errors[],
+			       int nr_pages);
+	bool (*batch_decompress)(struct acomp_req *reqs[],
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

