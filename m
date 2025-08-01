Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F6A219A9B;
	Fri,  1 Aug 2025 04:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754023021; cv=none; b=QShJLkhHis+Cy+zwQyaT8E00EZMYSSbbL18AkL0CnvF4MPy18VqHzlOy65sbS7b1VoVtH0g6m1WlvTnckgegazu8wFrbTGDW8lIcU0GvIiMFXK2cTXvcNPoza32wsqoU6oMLWjazp5Suz4DizjoJ5pcRH+rvjTRhaY/RFZCTky0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754023021; c=relaxed/simple;
	bh=+ZLjGS9LPh5l1NRnF8BWKlxrZG59dvvl5zxuiBF/lbw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LrNKEnZpovyU9yckTcftxMHgzibwCM8ztPp2puD8lBNTFlVwofSaNz0Z2eFWfGB6Lptv0xs1b0KEq8JzZvg3b8iUmQu7CdheDTp+hd6NQQVm2GOerYJeBHEYjTkneyKX2AjfZ2zp7Q0XGi7h6gSKGz8bmYKrrk4/4GsCCieaAcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VQN0kz8F; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VQN0kz8F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754023019; x=1785559019;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+ZLjGS9LPh5l1NRnF8BWKlxrZG59dvvl5zxuiBF/lbw=;
  b=VQN0kz8FpUTnBAqpi4Z/2E1U12sv+HId0kOSaXdaVAh4jG8lcAoTTVnS
   D+QOehtwvLnbK2yVSAxRQn7AgUniTo0CXatvyC793NkfaTEVRQNOYEApi
   NNX1Sn0+9yHf3FpHSKh6LiAeCFfzbdsY5BUlS0DcFMumr8RMJgOD5rjMY
   gbXGwqURhiMvwLnPlE0sObd8fq1KFEfNyrU8Supnvs3e9rZfw9Eaig51Z
   IKeLNOnxkq1SfU4Mj6P48SqteQRvRBYs8TTcUqQIT6EPARF1vtYPwtqTs
   69CMYuyVWUIMZ+P1FDMAZdSUZt82aVrfTc0USJoDaOKwKOw8H+A3JEeQM
   g==;
X-CSE-ConnectionGUID: 8ipR41k3TBWygKjIIxA16A==
X-CSE-MsgGUID: mfo4pSwLTHeohaJY74QSyA==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="73820346"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="73820346"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 21:36:46 -0700
X-CSE-ConnectionGUID: f2WOmrJLSqu26xYnHRLdSA==
X-CSE-MsgGUID: eKot6YdyR7uHM4tuWqMcIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163796288"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa008.jf.intel.com with ESMTP; 31 Jul 2025 21:36:45 -0700
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
Subject: [PATCH v11 16/24] crypto: iaa - Submit the two largest source buffers first in decompress batching.
Date: Thu, 31 Jul 2025 21:36:34 -0700
Message-Id: <20250801043642.8103-17-kanchana.p.sridhar@intel.com>
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
index 1166077900522..2f25e02ca0aa3 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2377,6 +2377,35 @@ static int iaa_comp_acompress_batch(
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
@@ -2409,18 +2438,36 @@ static int iaa_comp_adecompress_batch(
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
@@ -2441,6 +2488,15 @@ static int iaa_comp_adecompress_batch(
 			err = -EINVAL;
 		else
 			dlens[i] = reqs[i]->dlen;
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

