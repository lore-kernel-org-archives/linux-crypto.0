Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A36225BAB6;
	Fri, 28 Feb 2025 10:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740736831; cv=none; b=JuzLVOJDfbLYCTlvVMN08YG8T7I+URwh3Oqj1FHdrC/IRGXpL6IA8oL7kZaQbTokeTAOyedMjdzrqvWI00xaps87MP1n0WxI3iiO3U7ooSpqJkQWWp+nEzKeH+PVHmRMQb7iJ+LTYwM5WmHY+IWC9m+DUDii1U67WTVLr/prOmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740736831; c=relaxed/simple;
	bh=2yHMsDkER4HjRnd6CZHCqrmnfsYRe9xtFBscYIAxqhQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eJ5cYdjHPpx+TpG2tuSxgCoN5/3ASVimFXN2aAPpdtX/5F8UILQh7czmF+RWkAkrptIKkzfMQ9WPtieBB1gBZXxj0tOraZRNqVh+uMezLUxfWWdoo7YfqN4kFp4dQQPvSvYy43gQm69ljRIxDdn0cJtTytGPPDjL5KHtD6kJSsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MUmAdtcy; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MUmAdtcy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740736829; x=1772272829;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2yHMsDkER4HjRnd6CZHCqrmnfsYRe9xtFBscYIAxqhQ=;
  b=MUmAdtcy3OLZQJXtL4H8L3I9HPg8SCaIOCViiizqLjm6at99eARpm5/5
   Ruo4Mm3VDTgqPIVhDrNbjQinaABuTj/acfQgDoUElAulA+9xZ2hKzNjOc
   /52tQlv4RtcHyNATrIyydlDQg5rSiP5+11n07q+qbhO8/gkWF+NADReXF
   cK3dU1eYYuzUAO8dX+rnSRbgEtPRto9aCaK7+IxXlkpxUOe41LJwJaF5+
   LgU6A9nQ/QuK/DgZi3wJyEk/ybbcUb8v7crUP/n7aKa0stSS9gTYMprg1
   c0wM/BYjAlulvobzQWAoJoB/0FEJmd23XwBleKnCS0GfXMzWS8JD4iu8Q
   Q==;
X-CSE-ConnectionGUID: idHMJg6zSLut+YCiKpEkuQ==
X-CSE-MsgGUID: I4cmoNRBTd2qoGFz6HuDAg==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="40902575"
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="40902575"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Feb 2025 02:00:26 -0800
X-CSE-ConnectionGUID: QvtWhEWqRwmK+E0N1RUkWg==
X-CSE-MsgGUID: eTAuQPsfQM6G6JzddUkWLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,322,1732608000"; 
   d="scan'208";a="117325694"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 28 Feb 2025 02:00:25 -0800
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
Subject: [PATCH v7 02/15] crypto: acomp - New interfaces to facilitate batching support in acomp & drivers.
Date: Fri, 28 Feb 2025 02:00:11 -0800
Message-Id: <20250228100024.332528-3-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
References: <20250228100024.332528-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit adds a get_batch_size() interface to:

  struct acomp_alg
  struct crypto_acomp

A crypto_acomp compression algorithm that supports batching of compressions
and decompressions must register and provide an implementation for this
API, so that higher level modules such as zswap and zram can allocate
resources for submitting multiple compress/decompress jobs that can be
batched.

A new helper function acomp_has_async_batching() can be invoked to query if
a crypto_acomp has registered this API. Further, the newly added
crypto_acomp API "crypto_acomp_batch_size()" is provided for use by higher
level modules like zswap and zram. crypto_acomp_batch_size() returns 1 if
the acomp has not provided an implementation for get_batch_size().

For instance, zswap can call crypto_acomp_batch_size() to get the maximum
batch-size supported by the compressor. Based on this, zswap can use the
minimum of any zswap-specific upper limits for batch-size and the
compressor's max batch-size, to allocate batching resources. Further,
the way that zswap can avail of the compressor's batching capability is by
using request chaining to create a list requests chained to a head request.
zswap can call crypto_acomp_compress() or crypto_acomp_decompress() with
the head request in the chain for processing the chain as a batch. The call
into crypto for compress/decompress will thus remain the same from zswap's
perspective for both, batching and sequential compressions/decompressions.

An acomp_is_reqchain() API is introduced, that a driver can call to query
if a request received from compress/decompress represents a request chain,
and accordingly, process the request chain using either one of:

  acomp_do_req_chain()
  acomp_do_async_req_chain()

These capabilities allow the iaa_crypto Intel IAA driver to register and
implement the get_batch_size() acomp_alg interface, that can subsequently
be invoked from the kernel zswap/zram modules to construct a request chain
to compress/decompress pages in parallel in the IAA hardware accelerator to
improve swapout/swapin performance.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 crypto/acompress.c                  |  1 +
 include/crypto/acompress.h          | 28 ++++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |  4 ++++
 3 files changed, 33 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index cb6444d09dd7..b2a6c06d7262 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -84,6 +84,7 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
+	acomp->get_batch_size = alg->get_batch_size;
 	acomp->dst_free = alg->dst_free;
 	acomp->reqsize = alg->reqsize;
 
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index e6783deba3ac..147f184b6bea 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -43,6 +43,9 @@ struct acomp_req {
  *
  * @compress:		Function performs a compress operation
  * @decompress:		Function performs a de-compress operation
+ * @get_batch_size:     Maximum batch-size for batching compress/decompress
+ *                      operations. If registered, the acomp must provide
+ *                      a batching implementation using request chaining.
  * @dst_free:		Frees destination buffer if allocated inside the
  *			algorithm
  * @reqsize:		Context size for (de)compression requests
@@ -51,6 +54,7 @@ struct acomp_req {
 struct crypto_acomp {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int (*get_batch_size)(void);
 	void (*dst_free)(struct scatterlist *dst);
 	unsigned int reqsize;
 	struct crypto_tfm base;
@@ -142,6 +146,13 @@ static inline bool acomp_is_async(struct crypto_acomp *tfm)
 	       CRYPTO_ALG_ASYNC;
 }
 
+static inline bool acomp_has_async_batching(struct crypto_acomp *tfm)
+{
+	return (acomp_is_async(tfm) &&
+		(crypto_comp_alg_common(tfm)->base.cra_flags & CRYPTO_ALG_TYPE_ACOMPRESS) &&
+		tfm->get_batch_size);
+}
+
 static inline struct crypto_acomp *crypto_acomp_reqtfm(struct acomp_req *req)
 {
 	return __crypto_acomp_tfm(req->base.tfm);
@@ -311,4 +322,21 @@ static inline int crypto_acomp_decompress(struct acomp_req *req)
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
 #endif
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 53b4ef59b48c..24b63db56dfb 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -17,6 +17,9 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @get_batch_size:     Maximum batch-size for batching compress/decompress
+ *                      operations. If registered, the acomp must provide
+ *                      a batching implementation using request chaining.
  * @dst_free:	Frees destination buffer if allocated inside the algorithm
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
@@ -37,6 +40,7 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int (*get_batch_size)(void);
 	void (*dst_free)(struct scatterlist *dst);
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
-- 
2.27.0

