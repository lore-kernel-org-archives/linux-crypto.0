Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DA72139CE;
	Fri,  4 Jul 2025 04:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751603021; cv=none; b=uExhFkCApnFDFCDy9Pue5mbHgNQMs3Ry38BwUh9yjugNHYFgf/k2mv/Qa6nWH+inTBrLRo4X6NBliIdjCiLjoQ7AXhp6P5TKJ0oH2Pqi20gN+b3F+4WEmYXsv+chbl377ge7/fckF/sp92Up1IadiqQGaD3fX1a9HBnG6VW35fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751603021; c=relaxed/simple;
	bh=3e3UJSiDD0ePCp1UhoZ0QEgH6akJ/6LM7f1aXMoqR8U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C/kjFcItf1A4u+xvv0g9gvNC7ByrrdK2Em3kXseJAY+RGYbtBtfAEzOKhzRqpkmiOW+p2GfFG36w3QYr99HUH1ofsWUCF8NCeHIVJmUtk59KmRlisIcJphiaoPpmuSjFXpy5XFs4GNXnjBb7UyC1GgvTFjAwpXuB1rBDOOkt+sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kw7UVNkf; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kw7UVNkf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751603020; x=1783139020;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3e3UJSiDD0ePCp1UhoZ0QEgH6akJ/6LM7f1aXMoqR8U=;
  b=kw7UVNkfeG9iZ7NznNYrNHabAICG4dn+iDOG6DotxMC1JWtX01Sa8Ikr
   X23FACBIPuAGd7EeYiJXO0csESRE5D7AE+wX2A3iQkjmnioqX/Q8LnOuQ
   k0IDkS1UfvRwbZDVkbekVY55lyre+Ks3tA34ixsDaONlucvkfT35e3yR3
   pmIdRlHRYhy2ceXlLDTaSJOJGmLaJh/dGwIzz65i7t0dI5c8+jkIN7zUa
   vM2UUSilnVBB4Ob3xksEh5e2F17dcuTx3n16lwPXeilvUQoUDurkKcUar
   6M1KMhfYy6bK4Mqu1RMabVFcGN0rj1ZPTpjLPi4qHyaq0GYHmGZqzsSii
   w==;
X-CSE-ConnectionGUID: SfEH/Q3lRBGC9FZhTCkFjw==
X-CSE-MsgGUID: GEkkO2FWSbej4o19Jsu13A==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="53909154"
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="53909154"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 21:23:27 -0700
X-CSE-ConnectionGUID: fpQ2MfLjQCyYj/Lk6NMX7g==
X-CSE-MsgGUID: UUNqrK8TQdq0+7p7PZv2+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,286,1744095600"; 
   d="scan'208";a="153968708"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa006.jf.intel.com with ESMTP; 03 Jul 2025 21:23:26 -0700
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
Subject: [PATCH v10 16/25] crypto: iaa - Submit the two largest source buffers first in decompress batching.
Date: Thu,  3 Jul 2025 21:23:14 -0700
Message-Id: <20250704042323.10318-17-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250704042323.10318-1-kanchana.p.sridhar@intel.com>
References: <20250704042323.10318-1-kanchana.p.sridhar@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch finds the two largest source buffers in a given decompression
batch, and submits them first to the IAA decompress engines.

This improves decompress batching latency because the hardware has a
head start on decompressing the highest latency source buffers in the
batch. Workload performance is also significantly improved as a result
of this optimization.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 60 +++++++++++++++++++++-
 1 file changed, 58 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 09d786e85ab66..4ed56a69112a9 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2375,6 +2375,35 @@ static int iaa_comp_acompress_batch(
 	return err;
 }
 
+/*
+ * Find the two largest source buffers in @slens for a decompress batch,
+ * and pass their indices back in @idx_max and @idx_next_max.
+ *
+ * Returns true if there is no second largest source buffer, only a max buffer.
+ */
+static __always_inline bool decomp_batch_get_max_slens_idx(
+	unsigned int slens[],
+	int nr_pages,
+	int *idx_max,
+	int *idx_next_max)
+{
+	int i, max_i = 0, next_max_i = 0;
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (slens[i] >= slens[max_i]) {
+			next_max_i = max_i;
+			max_i = i;
+		} else if ((next_max_i == max_i) || (slens[i] > slens[next_max_i])) {
+			next_max_i = i;
+		}
+	}
+
+	*idx_max = max_i;
+	*idx_next_max = next_max_i;
+
+	return (next_max_i == max_i);
+}
+
 /**
  * This API provides IAA decompress batching functionality for use by swap
  * modules.
@@ -2407,18 +2436,36 @@ static int iaa_comp_adecompress_batch(
 {
 	struct scatterlist inputs[IAA_CRYPTO_MAX_BATCH_SIZE];
 	struct scatterlist outputs[IAA_CRYPTO_MAX_BATCH_SIZE];
+	bool max_processed = false, next_max_processed = false;
 	bool decompressions_done = false;
-	int i, err = 0;
+	int i, max_i, next_max_i, err = 0;
 
 	BUG_ON(nr_reqs > IAA_CRYPTO_MAX_BATCH_SIZE);
 
 	iaa_set_req_poll(reqs, nr_reqs, true);
 
+	/*
+	 * Get the indices of the two largest decomp buffers in the batch.
+	 * Submit them first. This improves latency of the batch.
+	 */
+	next_max_processed = decomp_batch_get_max_slens_idx(slens, nr_reqs,
+							    &max_i, &next_max_i);
+
+	i = max_i;
+
 	/*
 	 * Prepare and submit the batch of iaa_reqs to IAA. IAA will process
 	 * these decompress jobs in parallel.
 	 */
-	for (i = 0; i < nr_reqs; ++i) {
+	for (; i < nr_reqs; ++i) {
+		if ((i == max_i) && max_processed)
+			continue;
+		if ((i == next_max_i) && max_processed && next_max_processed)
+			continue;
+
+		if (max_processed && !next_max_processed)
+			i = next_max_i;
+
 		reqs[i]->src = &inputs[i];
 		reqs[i]->dst = &outputs[i];
 		sg_init_one(reqs[i]->src, srcs[i], slens[i]);
@@ -2437,6 +2484,15 @@ static int iaa_comp_adecompress_batch(
 			errors[i] = -EAGAIN;
 		else if (errors[i])
 			err = -EINVAL;
+
+		if (i == max_i) {
+			max_processed = true;
+			i = -1;
+		}
+		if (i == next_max_i) {
+			next_max_processed = true;
+			i = -1;
+		}
 	}
 
 	/*
-- 
2.27.0

