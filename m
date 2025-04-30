Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060A42D110A;
	Wed, 30 Apr 2025 20:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746046399; cv=none; b=FX/1Ua75MOugR0JrSYMeiB8I1J6lbuIoaUShGs6bMGafd7QEOiNimmUmpjOYzMk2iE4TuDqYMEmBCZ/4z/5R3uUYbWQWW+8CS4kmTflfWRwMBLmnHgg0+Vle8v1aw1cDLAQhXuALO/gQ8paLGMCEJ0E0duRO1hVcwoOjE5CAAkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746046399; c=relaxed/simple;
	bh=cw35xIKM3GQ7IYN44nqMVxUAoNpG2Du37jUAD6lMlcs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kqO763J3AA3ptKlxA0k6H7QX7Cc07H0Hb/vyAWgVNF5S242msQOTmffGCt5Wo8opI7hgUMOYDZynbd2XBdw1PNdKM84uJsFLPEPu1GHvnO5894wajwoUmOFHoi373Z+IKUnrIUxZO8YCmXDCDfgsBc9nqCEYXurl/Bb7TGy2gKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jLIWPHHy; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jLIWPHHy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746046397; x=1777582397;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cw35xIKM3GQ7IYN44nqMVxUAoNpG2Du37jUAD6lMlcs=;
  b=jLIWPHHyAIRk+Hy6zGg/xU/Fjbf6/4nEfk4+Z4Ej1k8Ph5ElN5zvGFJt
   zQy9TOrfyo2gULOCP2XW+IKl+QBQ8sZ/tpi9dFrvtvPxGEWGnid2/A4tx
   mh2YudDFRca+7PD7gGMVX09765ING5imsrUhxI2kVRX1DMUEuSUxduSjL
   rCFvwyjavHfB/bPXFvwCJf4BmA73Hi7pE3K12sagFgRUYmNSnwdxKd7Th
   zedOrgRE1DiBadrIexndQxHQAZzyZy+25DOSFMFm1/z8Ubv9oIDZIVQ2W
   pltCZlX/NWKyNV22AhjnITbVthNBGl1pAY7vZrsO8ByTIb/BUQGjTrtoa
   w==;
X-CSE-ConnectionGUID: RoG6lHofTBu06Z/Ms4x+0Q==
X-CSE-MsgGUID: FkGHmILHT2+omEnjqbG9bQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11419"; a="51388617"
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="51388617"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 13:53:16 -0700
X-CSE-ConnectionGUID: C9ygkhUwTwOT2d3kS0vE7w==
X-CSE-MsgGUID: uvHeYmr0TfapwvOC9nZ26g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,252,1739865600"; 
   d="scan'208";a="138248918"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 30 Apr 2025 13:53:14 -0700
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
	ying.huang@linux.alibaba.com,
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
Subject: [PATCH v9 10/19] crypto: acomp - New interfaces to facilitate batching support in acomp & drivers.
Date: Wed, 30 Apr 2025 13:52:56 -0700
Message-Id: <20250430205305.22844-11-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
References: <20250430205305.22844-1-kanchana.p.sridhar@intel.com>
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
and decompressions must provide implementations for these API, so that a
higher level module based on crypto_acomp, such as zswap, can allocate
resources for submitting multiple compress/decompress jobs that can be
batched, and invoke batching of [de]compressions.

A new helper function acomp_has_async_batching() can be invoked to query if
a crypto_acomp has registered these batching interfaces.

Further, zswap can invoke the newly added "crypto_acomp_batch_size()"
API to query the maximum number of requests that can be batch
[de]compressed. crypto_acomp_batch_size() returns 1 if the acomp has not
provided an implementation for get_batch_size(). Based on this, zswap
can use the minimum of any zswap-specific upper limits for batch-size
and the compressor's max batch-size, to allocate batching resources.

This allows the iaa_crypto Intel IAA driver to register implementations for
the get_batch_size(), batch_compress() and batch_decompress() acomp_alg
interfaces, that can subsequently be invoked from zswap to
compress/decompress pages in parallel in the IAA hardware accelerator to
improve swapout/swapin performance, through these newly added
corresponding crypto_acomp API:

  crypto_acomp_batch_size()
  crypto_acomp_batch_compress()
  crypto_acomp_batch_decompress()

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 crypto/acompress.c                  |   3 +
 include/crypto/acompress.h          | 107 ++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |  20 ++++++
 3 files changed, 130 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index d08e0fe8cd9e..c7cca5596acf 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -95,6 +95,9 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
+	acomp->get_batch_size = alg->get_batch_size;
+	acomp->batch_compress = alg->batch_compress;
+	acomp->batch_decompress = alg->batch_decompress;
 	acomp->reqsize = alg->reqsize;
 
 	acomp->base.exit = crypto_acomp_exit_tfm;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 939e51d122b0..e50f3e71ba58 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -120,6 +120,10 @@ struct acomp_req {
  *
  * @compress:		Function performs a compress operation
  * @decompress:		Function performs a de-compress operation
+ * @get_batch_size:	Maximum batch-size for batching compress/decompress
+ *			operations.
+ * @batch_compress:	Function performs a batch compress operation.
+ * @batch_decompress:	Function performs a batch decompress operation.
  * @reqsize:		Context size for (de)compression requests
  * @fb:			Synchronous fallback tfm
  * @base:		Common crypto API algorithm data structure
@@ -127,6 +131,22 @@ struct acomp_req {
 struct crypto_acomp {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int (*get_batch_size)(void);
+	bool (*batch_compress)(
+		struct acomp_req *reqs[],
+		struct page *pages[],
+		u8 *dsts[],
+		unsigned int dlens[],
+		int errors[],
+		int nr_reqs);
+	bool (*batch_decompress)(
+		struct acomp_req *reqs[],
+		u8 *srcs[],
+		struct page *pages[],
+		unsigned int slens[],
+		unsigned int dlens[],
+		int errors[],
+		int nr_reqs);
 	unsigned int reqsize;
 	struct crypto_acomp *fb;
 	struct crypto_tfm base;
@@ -224,6 +244,13 @@ static inline bool acomp_is_async(struct crypto_acomp *tfm)
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
@@ -595,4 +622,84 @@ static inline struct acomp_req *acomp_request_on_stack_init(
 	return req;
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
+ * crypto_acomp_batch_compress() -- Invoke asynchronous compress of a batch
+ * of requests.
+ *
+ * @reqs: @nr_reqs asynchronous compress requests.
+ * @pages: Pages to be compressed by IAA.
+ * @dsts: Pre-allocated destination buffers to store results of compression.
+ *        Each element of @dsts must be of size "PAGE_SIZE * 2".
+ * @dlens: Will contain the compressed lengths for @pages.
+ * @errors: zero on successful compression of the corresponding
+ *          req, or error code in case of error.
+ * @nr_reqs: The number of requests in @reqs, up to IAA_CRYPTO_MAX_BATCH_SIZE,
+ *           to be compressed.
+ *
+ * Returns true if all compress requests in the batch complete successfully,
+ * false otherwise.
+ */
+static inline bool crypto_acomp_batch_compress(
+	struct acomp_req *reqs[],
+	struct page *pages[],
+	u8 *dsts[],
+	unsigned int dlens[],
+	int errors[],
+	int nr_reqs)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(reqs[0]);
+
+	return tfm->batch_compress(reqs, pages, dsts, dlens, errors, nr_reqs);
+}
+
+/**
+ * crypto_acomp_batch_decompress() -- Invoke asynchronous decompress of a batch
+ * of requests.
+ *
+ * @reqs: @nr_reqs asynchronous decompress requests.
+ * @srcs: Source buffers to to be decompressed.
+ * @pages: Destination pages corresponding to @srcs.
+ * @slens: Buffer lengths for @srcs.
+ * @dlens: Will contain the decompressed lengths for @srcs.
+ *	   For batch decompressions, the caller must enforce additional
+ *	   semantics such as, BUG_ON(dlens[i] != PAGE_SIZE) assertions.
+ * @errors: zero on successful decompression of the corresponding
+ *          req, or error code in case of error.
+ * @nr_reqs: The number of requests in @reqs, up to IAA_CRYPTO_MAX_BATCH_SIZE,
+ *           to be decompressed.
+ *
+ * Returns true if all decompress requests in the batch complete successfully,
+ * false otherwise.
+ */
+static inline bool crypto_acomp_batch_decompress(
+	struct acomp_req *reqs[],
+	u8 *srcs[],
+	struct page *pages[],
+	unsigned int slens[],
+	unsigned int dlens[],
+	int errors[],
+	int nr_reqs)
+{
+	struct crypto_acomp *tfm = crypto_acomp_reqtfm(reqs[0]);
+
+	return tfm->batch_decompress(reqs, srcs, pages, slens, dlens, errors, nr_reqs);
+}
+
 #endif
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index b69d818d7e68..891e40831af8 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -23,6 +23,10 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @get_batch_size:	Maximum batch-size for batching compress/decompress
+ *			operations.
+ * @batch_compress:	Function performs a batch compress operation.
+ * @batch_decompress:	Function performs a batch decompress operation.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -43,6 +47,22 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int (*get_batch_size)(void);
+	bool (*batch_compress)(
+		struct acomp_req *reqs[],
+		struct page *pages[],
+		u8 *dsts[],
+		unsigned int dlens[],
+		int errors[],
+		int nr_reqs);
+	bool (*batch_decompress)(
+		struct acomp_req *reqs[],
+		u8 *srcs[],
+		struct page *pages[],
+		unsigned int slens[],
+		unsigned int dlens[],
+		int errors[],
+		int nr_reqs);
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.27.0

