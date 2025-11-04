Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CAF531A7E3;
	Tue,  4 Nov 2025 09:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247573; cv=none; b=NksyrVBC6WsnAfrvD6UAKSDuBCvoyGvFITxIieGYuzejxKZuGBVAlIvL5vFcxo8Tm8uH1rsX8tXliD19vHRa9opI5qNHCPujeOApzQ/tsm1mML6wxxdjQ3Ytx9OgEfhICXkRN2ZhNESbmX91SkI7jwXMxHxh4uLJoK28VMlF1ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247573; c=relaxed/simple;
	bh=y6UTZGxTCoeHJhxCck167UlocEl2a1qtxUU6EBdN9+Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=saoJFVJAhWc+F4sxQVNyQHQVZE/pdJ0br3ki257AtJnJCE+gJpIzyg5RmAVbmWB45/OQcOJr1CmpTWmh2vBR1TgtYeVjk/z5wVtTLh5c/tpXCq46fQYmIUxOqXdHdpIXYAbAz8gu7N7WrJeMcjBIFyxeuARo4zjROraGTO0Jvok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Y0Wmtcvh; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Y0Wmtcvh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247571; x=1793783571;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y6UTZGxTCoeHJhxCck167UlocEl2a1qtxUU6EBdN9+Y=;
  b=Y0WmtcvhlzGZFQ4/ZIwT89m0q2+v+og9Z9rnzn95bREYp70g1H2vYoD6
   Ncz43L105nYeZmcKUpn3va0mMcHsQv2z2w2mOmbXpWyNHPk1N5DWCN2dw
   eWbyEs141/AYd3RlYl0N8evHPjac48lrABD2SF+hEUqNog6P+ylMWJ4Mo
   XI4hWNCeHbMbQtvzU6doGGsUKPITtGRqsoCOlGrM3tAfARURFwzr9IaVC
   HLZrcZPNkBuDWeUb1HGn5WFZxtOeqAmGuWYkz+LI6rMoSvLH4o0LpMKXS
   bTT58H97Qd1YiziHHK+nP6/jQPr3A5hZxc6yyjfIGHbL9clK0/5kmYORs
   Q==;
X-CSE-ConnectionGUID: vlq3pdAaRIKKH1iL1R3ZPw==
X-CSE-MsgGUID: okLYOPcGS42N+bLTpX3aZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="89798688"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="89798688"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:39 -0800
X-CSE-ConnectionGUID: dtyy11KhTGyeNDo4ENzvdg==
X-CSE-MsgGUID: TRwWE9bGQaKWqmErNh7qyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795823"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:39 -0800
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
Subject: [PATCH v13 16/22] crypto: iaa - Submit the two largest source buffers first in decompress batching.
Date: Tue,  4 Nov 2025 01:12:29 -0800
Message-Id: <20251104091235.8793-17-kanchana.p.sridhar@intel.com>
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

This patch finds the two largest source buffers in a given decompression
batch, and submits them first to the IAA decompress engines.

This improves decompress batching latency because the hardware has a
head start on decompressing the highest latency source buffers in the
batch. Workload performance is also significantly improved as a result
of this optimization.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 61 +++++++++++++++++++++-
 1 file changed, 59 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index 349fea0af454..cc0d82154ff6 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2390,6 +2390,36 @@ static int iaa_comp_acompress_batch(
 	return err;
 }
 
+/*
+ * Find the two largest source buffers in @slens for a decompress batch,
+ * and pass their indices back in @idx_max and @idx_next_max.
+ *
+ * Returns true if there is no second largest source buffer, only a max buffer.
+ */
+static bool decomp_batch_get_max_slens_idx(
+	struct iaa_req *reqs[],
+	int nr_pages,
+	int *idx_max,
+	int *idx_next_max)
+{
+	int i, max_i = 0, next_max_i = 0;
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (reqs[i]->slen >= reqs[max_i]->slen) {
+			next_max_i = max_i;
+			max_i = i;
+		} else if ((next_max_i == max_i) ||
+			   (reqs[i]->slen > reqs[next_max_i]->slen)) {
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
@@ -2412,13 +2442,14 @@ static int iaa_comp_adecompress_batch(
 	unsigned int unit_size)
 {
 	struct iaa_batch_ctx *cpu_ctx = raw_cpu_ptr(iaa_batch_ctx);
+	bool max_processed = false, next_max_processed = false;
 	int nr_reqs = parent_req->dlen / unit_size;
 	int errors[IAA_CRYPTO_MAX_BATCH_SIZE];
 	int *dlens[IAA_CRYPTO_MAX_BATCH_SIZE];
+	int i = 0, max_i, next_max_i, err = 0;
 	bool decompressions_done = false;
 	struct scatterlist *sg;
 	struct iaa_req **reqs;
-	int i, err = 0;
 
 	mutex_lock(&cpu_ctx->mutex);
 
@@ -2437,11 +2468,28 @@ static int iaa_comp_adecompress_batch(
 
 	iaa_set_req_poll(reqs, nr_reqs, true);
 
+	/*
+	 * Get the indices of the two largest decomp buffers in the batch.
+	 * Submit them first. This improves latency of the batch.
+	 */
+	next_max_processed = decomp_batch_get_max_slens_idx(reqs, nr_reqs,
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
 		errors[i] = iaa_comp_adecompress(ctx, reqs[i]);
 
 		/*
@@ -2456,6 +2504,15 @@ static int iaa_comp_adecompress_batch(
 		} else {
 			*dlens[i] = reqs[i]->dlen;
 		}
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

