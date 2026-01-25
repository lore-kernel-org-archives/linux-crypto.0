Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBD523BF83;
	Sun, 25 Jan 2026 03:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769312176; cv=none; b=YUr//vTJwpIEP0uiyV0Yjl8O8Lx4PQ5iESKMa1s8z/SkUXlWbe99apjzmvtFy2Li+J9Sh0F/rZjOkMen5ljbnOVSOydBS9UYWwqH4zzQWFnBlvqqwPCOJ3jMft1QoI31logBF2OhzvjM0AHFo3pQ1y3VMBhoVachgLELeIFREDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769312176; c=relaxed/simple;
	bh=SaK461OE9N571yM1DigWyBRhAbZ7RXxHms5EPvXQKq8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=O6jCNA2texRTQte+JqQB0wJrMFUi9cOvkseh9chcUGbQug0Q2edrz8y/FGNlQPwfoUvlAtUfwLPsT2ZJwrU4Z1VtyUJxbiNwBuunvEJ1YYmiPMIc7s610TQQYE7w4cZsch9xSIVppgMes0Tpr+miv0ENLHrPFGuVxx3wRh1utNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UTi3LsXK; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UTi3LsXK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769312174; x=1800848174;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SaK461OE9N571yM1DigWyBRhAbZ7RXxHms5EPvXQKq8=;
  b=UTi3LsXKww2A2lFXIcWsIoUlOWd8uhGcPLzie22AORAmKGJX8OanRmV+
   +DP+ORT1e5LbLMO3zjFoeWvpCXGWqKuTAsDvoyuTppeuxVKIo+ylQfZ3s
   SN0p9dLsF+Lw1F/hzwQTQQbzbQJO9JUU3zlNM9O5+ma7sp5/yWAGf5+bh
   uu/5iX/b8q1RJJVvPcVoowbANY5qHWbRru9cJnbrUzuU7C80UjbK89ERQ
   YbmemBkYYpR5D7fTDwessnuWH/+W7kWUNEmEYNNdahhMwtxs4n80juDh6
   YUf1kwXOXS8sPaa7wIp0edawy4s9sg/JJgwT7F5tu8JGszpoQxkqTUjCm
   g==;
X-CSE-ConnectionGUID: qcDxsVGiRfiPFSp/n0ewag==
X-CSE-MsgGUID: ZzF5jYByQvqGjKnkv5HtvQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="81887634"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="81887634"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2026 19:36:11 -0800
X-CSE-ConnectionGUID: /MfoxdkxT5Ct5V0NNBDwbA==
X-CSE-MsgGUID: 4LQ/McmVTw2S0JQejqfk8g==
X-ExtLoop1: 1
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by fmviesa003.fm.intel.com with ESMTP; 24 Jan 2026 19:36:09 -0800
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
	vinicius.gomes@intel.com,
	giovanni.cabiddu@intel.com
Cc: wajdi.k.feghali@intel.com,
	kanchana.p.sridhar@intel.com
Subject: [PATCH v14 22/26] crypto: acomp - Add crypto_acomp_batch_size() to get an algorithm's batch-size.
Date: Sat, 24 Jan 2026 19:35:33 -0800
Message-Id: <20260125033537.334628-23-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
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
index c48a1a20e21f..02c25c79c0d4 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -387,6 +387,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
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
index fe9f59ede577..e735aa01dce8 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2729,6 +2729,7 @@ static struct acomp_alg iaa_acomp_fixed_deflate = {
 	.compress		= iaa_crypto_acomp_acompress_main,
 	.decompress		= iaa_crypto_acomp_adecompress_main,
 	.batch_completed	= iaa_crypto_acomp_batch_completed,
+	.batch_size		= IAA_CRYPTO_MAX_BATCH_SIZE,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa",
@@ -2755,6 +2756,7 @@ static struct acomp_alg iaa_acomp_dynamic_deflate = {
 	.compress		= iaa_crypto_acomp_acompress_main,
 	.decompress		= iaa_crypto_acomp_adecompress_main,
 	.batch_completed	= iaa_crypto_acomp_batch_completed,
+	.batch_size		= IAA_CRYPTO_MAX_BATCH_SIZE,
 	.base			= {
 		.cra_name		= "deflate",
 		.cra_driver_name	= "deflate-iaa-dynamic",
diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index 752110a7719c..1448b20de492 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -598,6 +598,18 @@ int crypto_acomp_compress(struct acomp_req *req);
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
index 7c4e14491d59..dc126a8cfea2 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -34,6 +34,8 @@
  *                      of all batch sub-requests having completed.
  *                      Returns an error code in @req->slen if any
  *                      of the sub-requests completed with an error.
+ * @batch_size:	Maximum batch-size for batching compress/decompress
+ *		operations.
  * @init:	Initialize the cryptographic transformation object.
  *		This function is used to initialize the cryptographic
  *		transformation object. This function is called only once at
@@ -53,6 +55,7 @@ struct acomp_alg {
 	int (*compress)(struct acomp_req *req);
 	int (*decompress)(struct acomp_req *req);
 	bool (*batch_completed)(struct acomp_req *req, bool comp);
+	unsigned int batch_size;
 	int (*init)(struct crypto_acomp *tfm);
 	void (*exit)(struct crypto_acomp *tfm);
 
-- 
2.27.0

