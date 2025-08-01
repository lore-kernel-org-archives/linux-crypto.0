Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42ECB223328;
	Fri,  1 Aug 2025 04:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023023; cv=none; b=IXg1m2vVgjf1jcG8dG7QRnaYkcrlqVHyPRiNVedNIwIMMxPUPkaeBVY4/1/UxzSe0WfpBbzVIjFoDHLSTOlufzkhqh+H9j3khSt687woIh4B7rNCZvT0I4/8Req1XmNyTUw/7PBEv2NDJ53wuRUSsGZaTWNQzk84T+Q/hWmB+qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023023; c=relaxed/simple;
	bh=jBYqtIdn2g/qmc5lPRJuQdSpcp+B6gPWEJvQ/KJK+XM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JAPAYfAwpUvwqwdQ71r/W9FsSFZHKP+yXnP2akDqEoP6KxwuNu/GcNv7hHmCENtO9g9sHmoRKzxuBF3/h7ly02zq3OwahiHWFM5w9GF54WxVW2CMhXWyQwBHPfs1xZ7fwcnpfzxkHLUflL2U4McmBlYvc0RhwzPSCBh1A2sbopY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PIQlGDnK; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PIQlGDnK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023021; x=1785559021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jBYqtIdn2g/qmc5lPRJuQdSpcp+B6gPWEJvQ/KJK+XM=;
  b=PIQlGDnKTUGwlcPor3Rr6q6ig+YvHQ5y7DSf+gwZhp6S9ndybHeRUG9v
   T1dG1ft/0iaG82aobjwI/j72yAQNXM/D+8QQFKSYWCb4cIrFQAacOxN4S
   GREe6o8itd9k9Vmh8k8arpKk1sqcWlMqgniK2P4JGpikQNCsqls5eoS9e
   AGTzPXJ0svk4lmydAEItnpvY7UDv8Vi3hX2fEdA0XNvl10k379AXvJj55
   n+HLI4WEYM2UJAErDyl06l1qd5GAJ0OEb3fO+bnQtBwkJICj3lX/qOgIs
   IWVgI7iRXVWbvmeQixSY+Ft1Ojec2Hg2d12VAJjSqWyOUHv4U39nMpcQ4
   Q==;
X-CSE-ConnectionGUID: 6kbD6ELzSbOASLJHOExurA==
X-CSE-MsgGUID: Bv2dv1GhRqSEMr6kd/GpSA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820374"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820374"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:46 -0700
X-CSE-ConnectionGUID: 67ys5ai6RRu463egZMl72A==
X-CSE-MsgGUID: LkB5nBh/SRCjfrvI35zSqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796297"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:46 -0700
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
	senozhatsky@chromium.org,
	linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	clabbe@baylibre.com,
	ardb@kernel.org,
	ebiggers@google.com,
	surenb@google.com,
	kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com
Cc: wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v11 18/24] crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's batch-size.
Date: Thu, 31 Jul 2025 21:36:36 -0700
Message-Id: <20250801043642.8103-19-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
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
and decompressions must provide an implementation for this API to return
the maximum batch-size that the compressor supports, so that kernel
users of crypto_acomp, such as zswap, can allocate resources for
submitting multiple compress/decompress jobs that can be batched, and
invoke batching of [de]compressions.

A new helper function acomp_has_async_batching() can be invoked to query
if a crypto_acomp implements get_batch_size().

The new crypto_acomp_batch_size() API uses this helper function to return
the batch-size for compressors that implement get_batch_size(). If no
implementation is provided by the crypto_acomp, a default of "1" is
returned for the batch-size.

zswap can invoke crypto_acomp_batch_size() to query the maximum number
of requests that can be batch [de]compressed. Based on this, zswap
can use the minimum of any zswap-specific upper limits for batch-size
and the compressor's max batch-size, to allocate batching resources.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 crypto/acompress.c                  |  1 +
 include/crypto/acompress.h          | 27 +++++++++++++++++++++++++++
 include/crypto/internal/acompress.h |  3 +++
 3 files changed, 31 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e32..f440724719655 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -105,6 +105,7 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->compress = alg->compress;
 	acomp->decompress = alg->decompress;
+	acomp->get_batch_size = alg->get_batch_size;
 	acomp->reqsize = alg->base.cra_reqsize;
 
 	acomp->base.exit = crypto_acomp_exit_tfm;
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 0312322d2ca03..898104745cd24 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -108,6 +108,8 @@ struct acomp_req {
  *
  * @compress:		Function performs a compress operation
  * @decompress:		Function performs a de-compress operation
+ * @get_batch_size:	Maximum batch-size for batching compress/decompress
+ *			operations.
  * @reqsize:		Context size for (de)compression requests
  * @fb:			Synchronous fallback tfm
  * @base:		Common crypto API algorithm data structure
@@ -115,6 +117,7 @@ struct acomp_req {
 struct crypto_acomp {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int (*get_batch_size)(void);
 	unsigned int reqsize;
 	struct crypto_tfm base;
 };
@@ -205,6 +208,13 @@ static inline bool acomp_is_async(struct crypto_acomp *tfm)
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
@@ -545,6 +555,23 @@ int crypto_acomp_compress(struct acomp_req *req);
  */
 int crypto_acomp_decompress(struct acomp_req *req);
 
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
 static inline struct acomp_req *acomp_request_on_stack_init(
 	char *buf, struct crypto_acomp *tfm)
 {
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index ffffd88bbbad3..2325ee18e7a10 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -28,6 +28,8 @@
  *
  * @compress:	Function performs a compress operation
  * @decompress:	Function performs a de-compress operation
+ * @get_batch_size:	Maximum batch-size for batching compress/decompress
+ *			operations.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -46,6 +48,7 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int (*get_batch_size)(void);
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.27.0

