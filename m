Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC4E1EC4D3;
	Sat, 21 Dec 2024 06:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734762685; cv=none; b=ciHIpPFs3ivToRA0T2jjZXEAe2wPbixnmuWaJkBDufdl3RG8JTXyZE5lR7OJrAjQ2h/9xzh07aSkCPE4iDRUWlR5giQB6HHXEnhsjKpdj2OngZvp4ySLhcHTUTpSPVDkw1WzAV+/n11tp4thNBmZnSjq+yG0MpfDaVFpPpDR6UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734762685; c=relaxed/simple;
	bh=+lL68B5VDme0ssy20KVs9HZUu1uuo/887sCYSoPmBdw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dLyfE7GiNqKLeKTfk53w4G3GWV0MYSHjTIAbXU6jX8iprydGjxPbXOQHXPTZDk5u8WQYLhbS+rKHgRjBlH5dUIvY4GQF1JDwvgvVioKHTRrrucOT1oAh3YmrUYAJKdLyKkPM6iwD2S2EuLARs6W8HYOjn/snmakUsH72WEl4Qnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DVwM7O7y; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DVwM7O7y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734762683; x=1766298683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+lL68B5VDme0ssy20KVs9HZUu1uuo/887sCYSoPmBdw=;
  b=DVwM7O7yIaWDzhwBELsXyPGPeRxuWT4Z1EEeQaF2gm1+pWYMm12JVJWA
   AZkqRY32jtkOlg+xuIxRJ+FUH6Ub6DeThe+xVjASMgj8wZVyHbYdGyeZI
   duF7jsHYjhrFEUMd6GewN5w/WVxWrQSqbuK4lbMyixGdxfgWkrPz8OTxf
   FM10ckuSd/93tXY7R97RZA/O7C8cl+af39A2y2mrL5eWbkwvMU29nBckf
   ivZI4ut6153q4zRDG14lhAfjGmCJxW8kiRyC756ixZLfAETPR3N40yKP2
   pXD3Dgcb6xBRlnx83n/LPV3sDQ/dk9WPpAKWVFqmyIuPtUy6ObL4uNpAj
   Q==;
X-CSE-ConnectionGUID: 2XaK23BGSEq5S+T9g9btyg==
X-CSE-MsgGUID: bo1KG17AQCq2MAEEvjg5EQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11292"; a="35021628"
X-IronPort-AV: E=Sophos;i="6.12,253,1728975600"; 
   d="scan'208";a="35021628"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2024 22:31:20 -0800
X-CSE-ConnectionGUID: 6HJLpaqhT0G57N/dxD4MSQ==
X-CSE-MsgGUID: rOfRcOvhRUKUfVOelk1HHQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="99184578"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa007.jf.intel.com with ESMTP; 20 Dec 2024 22:31:20 -0800
From: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	yosryahmed@google.com,
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
Subject: [PATCH v5 02/12] crypto: acomp - Define new interfaces for compress/decompress batching.
Date: Fri, 20 Dec 2024 22:31:09 -0800
Message-Id: <20241221063119.29140-3-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
References: <20241221063119.29140-1-kanchana.p.sridhar@intel.com>
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

