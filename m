Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92E7531BC96;
	Tue,  4 Nov 2025 09:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247574; cv=none; b=IcZ+ffGXkNpsWvgTz+BRLyh3PYAI4vd+VmlOpvM4VHYomFxZIZ+OzfLtXxljSYfeusLBVokpNiuf3oI0FUhpRz676HExxcxvpMPTktd3I7HGinS3GJV1Nr/I0yevWnohvpR2p4OPQRn3VbdmNwtc79mE7Gvz6vM8T5lRVAVe3Fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247574; c=relaxed/simple;
	bh=vCApmtmMXoGN5S/Qb3qu/+sfAmKpMxg+chJJ85/VF+M=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pONcUVipPTsf0aSuRbXLmDPoVSV3HMzvcH6p25GGTVq9vRjOdnIu4/V8LpGQote/PsVRiN/bYNcVBWAg45HUu9uncokBbkFtJ2tonGgmYRhHhjfeBh2UV8B1D5Oh+PKoouUXYJ0PvCypbSww+w79+bmXZc396tYOmJqTLrSVPSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UfFGMb9G; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UfFGMb9G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247572; x=1793783572;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vCApmtmMXoGN5S/Qb3qu/+sfAmKpMxg+chJJ85/VF+M=;
  b=UfFGMb9G2R1h0+BnuN+evBor7WMqPWtzcuagnibImYKSPIok6MqUlBOy
   RzB/jATFuGqrqCq68Q/WuxAL71tzrL5OVEr99PyzK040rvtgsI4+h9yni
   F4eeRqY/Ns/QKlQs3YqEBx3p1hiZO1Q/U+pmnPlVoxo8iiD+/Xg8bYx1K
   ytWZ2J6twOJKKm+KhBkXV6gzfw/ezqwUquWaYh6OcV12CoAurcapkuKn6
   SpTg+biI0g0LggWAsYSRfKFzJgjvkWZKci8+YZBoKXCMGqR3EebTuNGrY
   mLkeqk7/SGy1ncR1P+2H8SCljEuSN3CKiJlobQy++8slcLQ1HhRXPRgdj
   w==;
X-CSE-ConnectionGUID: iCrMArO1QqKr3kMz2AtYoQ==
X-CSE-MsgGUID: c2EogSl2SYy47suq+wWy4g==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="89798690"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="89798690"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:39 -0800
X-CSE-ConnectionGUID: B5B5oAOhTrqeoAjYGQrftA==
X-CSE-MsgGUID: hO5Z+nCcQpKR/y3sWsGqpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795829"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:40 -0800
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
	sj@kernel.org,
	kasong@tencent.com,
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
Subject: [PATCH v13 18/22] crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's batch-size.
Date: Tue,  4 Nov 2025 01:12:31 -0800
Message-Id: <20251104091235.8793-19-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This commit adds a @batch_size data member to struct acomp_alg.

An acomp_alg compression algorithm that supports batching of
compressions and decompressions must provide a @batch_size greater than
one, representing the maximum batch-size that the compressor supports,
so that kernel users of crypto_acomp, such as zswap, can allocate
resources for submitting multiple compress/decompress jobs that can be
batched, and invoke batching of [de]compressions.

The new crypto_acomp_batch_size() API queries the crypto_acomp's
acomp_alg for the batch-size. If the acomp_alg has registered a
@batch_size greater than 1, this is returned. If not, a default of "1"
is returned.

zswap can invoke crypto_acomp_batch_size() to query the maximum number
of requests that can be batch [de]compressed. Based on this, zswap
can use the minimum of any zswap-specific upper limits for batch-size
and the compressor's max @batch_size, to allocate batching resources.

The IAA acomp_algs Fixed ("deflate-iaa") and Dynamic
("deflate-iaa-dynamic") register @batch_size as
IAA_CRYPTO_MAX_BATCH_SIZE.

This enables zswap to compress/decompress pages in parallel in the IAA
hardware accelerator to improve swapout/swapin performance and memory
savings.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 crypto/acompress.c                         | 14 ++++++++++++++
 drivers/crypto/intel/iaa/iaa_crypto_main.c |  2 ++
 include/crypto/acompress.h                 | 12 ++++++++++++
 include/crypto/internal/acompress.h        |  3 +++
 4 files changed, 31 insertions(+)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e3..61ad81b06f49 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -305,6 +305,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
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
diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 37e1cc720e5d..2db2ddd4cb49 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2671,6 +2671,7 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.init			= iaa_comp_init_fixed,
 	.compress		= iaa_comp_acompress_main,
 	.decompress		= iaa_comp_adecompress_main,
+	.batch_size		= IAA_CRYPTO_MAX_BATCH_SIZE,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
@@ -2696,6 +2697,7 @@ static struct acomp_alg iaa_acomp_dynamic_deflate = {
 	.init			= iaa_comp_init_dynamic,
 	.compress		= iaa_comp_acompress_main,
 	.decompress		= iaa_comp_adecompress_main,
+	.batch_size		= IAA_CRYPTO_MAX_BATCH_SIZE,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa-dynamic",
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 0f1334168f1b..6385f9b78a0d 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -578,6 +578,18 @@ int crypto_acomp_compress(struct acomp_req *req);
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
index 2d97440028ff..e451e0ae3b9b 100644
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
@@ -46,6 +48,7 @@
 struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
+	unsigned int batch_size;
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.27.0

