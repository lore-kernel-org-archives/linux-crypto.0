Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB7D280024;
	Fri, 26 Sep 2025 03:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758857723; cv=none; b=EWN33f6h3BlW16TYosEdZyrvRrvv5M0KG49/AOpkg/wlg2H/nY1JLnFh+t6+5BzEMC3qqA6GwXIGkWtADywF7kEzl7zAA1PUm1/IpIdH4Jopj1rVUbh3g5iRytCJVvfAS+kNKDBwpgkL77F7UUlZl95QJRxl7DCdNrMSLoEngCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758857723; c=relaxed/simple;
	bh=RdtG4oYnaUiZ1ttzY4avkjog/6/16IXF7YMAS9x4VlM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SwM1A4BBRs9IHgSeKs2ZsrSd+C1iPIOgnoiP7Ty2YmlISeZ3jLt6YwpoU8nYRnrz1jonYjVJijcf+icARtgWLho+Ea93NGuPGKUbcrbSc7zhDR09iWsZlT3QhEZzNjwUw2acTkNVhBXiUhAMT9pol2k2XpvQFxqiUwsO9wGYipE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SmL3JIGP; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SmL3JIGP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758857721; x=1790393721;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RdtG4oYnaUiZ1ttzY4avkjog/6/16IXF7YMAS9x4VlM=;
  b=SmL3JIGPDGbhIytW4lTutUywBoaQidBPEF+Tch33u/EOfKy5UjvLm6kV
   qv76gGWK6S4Q0h6ChaPMtrcX6iSrVTb4oC7IkyVjgzgn5J5H+Vfe+geCj
   dbEWMPITM9ANuB6TcDJUUWxTVfyZt/HDBIV4P5YbttxeWnokRj1pMtPO2
   cAS8OqgnusUdUmKEx7Dyq/G3H7mn9541CVen5G1zUNZ37ykmZ1IRgsJdw
   DUpfKvN6kK8+lDd5qMOTpW/1m2FeNSBFKoeGkOH4PaOCxceBjxHoBjkti
   jjSvVRBn7YwIer0H17JqkdW4b+QmzMLr5d/2uz0YY1TBM+kYww7fY0ywf
   w==;
X-CSE-ConnectionGUID: b5HhuYFqQ5mwmPqgnkrpmA==
X-CSE-MsgGUID: vmLXtCFyST2T8PotRSiUVw==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="63819621"
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="63819621"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 20:35:07 -0700
X-CSE-ConnectionGUID: cAKDv1LcRUqGg49d9GbJ8g==
X-CSE-MsgGUID: YeuClNc0QHeBobxThiltsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,294,1751266800"; 
   d="scan'208";a="214636602"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa001.jf.intel.com with ESMTP; 25 Sep 2025 20:35:06 -0700
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
Subject: [PATCH v12 17/23] crypto: iaa - Submit the two largest source buffers first in decompress batching.
Date: Thu, 25 Sep 2025 20:34:56 -0700
Message-Id: <20250926033502.7486-18-kanchana.p.sridhar@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
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
index 5b933c138e50..0669ae155e90 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -2379,6 +2379,36 @@ static int iaa_comp_acompress_batch(
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
@@ -2401,12 +2431,13 @@ static int iaa_comp_adecompress_batch(
 	unsigned int unit_size)
 {
 	struct iaa_batch_ctx *cpu_ctx = raw_cpu_ptr(iaa_batch_ctx);
+	bool max_processed = false, next_max_processed = false;
 	int nr_reqs = parent_req->dlen / unit_size;
 	int errors[IAA_CRYPTO_MAX_BATCH_SIZE];
+	int i = 0, max_i, next_max_i, err = 0;
 	bool decompressions_done = false;
 	struct scatterlist *sg;
 	struct iaa_req **reqs;
-	int i, err = 0;
 
 	mutex_lock(&cpu_ctx->mutex);
 
@@ -2425,11 +2456,28 @@ static int iaa_comp_adecompress_batch(
 
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
@@ -2444,6 +2492,15 @@ static int iaa_comp_adecompress_batch(
 		} else {
 			*parent_req->dlens[i] = reqs[i]->dlen;
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

