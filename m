Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86169313285;
	Tue,  4 Nov 2025 09:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762247564; cv=none; b=XPJx8NWc58CHJ71wVv6ZjUCwv1LyUcbVWSpDD7Xvywwml1BxssIljOyVkNatZq4j6MmxW8ib/dvjVSZfeeB6+3upxjS6OMBXVHgxAWGc6EpnaSivPRaiPEXKvAH/2G8axJ8KIIm0HcjW3C0zl8hr242+Ilu8g55qWt8Gvm2PCOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762247564; c=relaxed/simple;
	bh=azkrQ7DeSclQsaOR4GhI5QQ6G4Vd3RZf2l9aN/qPbMs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pmp9JrqrtOJ0LHUzA6mKvQ+OQITrh650KLGb/YDpwn4l1LEDYCXikcPmh1DFk6oPVO4BkqIcJ9v0kNEnp3DwsgnxAJJ7fYzupQ2v6iPFmBzlkwVQTBkgL4ATkieEUsOUkMhrKu4KfPb7pnZT65C8/iH9dIpJ+UOyaipPn2M1ixc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Pm/O19l3; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Pm/O19l3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762247562; x=1793783562;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=azkrQ7DeSclQsaOR4GhI5QQ6G4Vd3RZf2l9aN/qPbMs=;
  b=Pm/O19l3HguXKGvXv/bNDjIQh4PwytzeT5I8SBuZWyVSNe2WlKzcKR9b
   pnBy95/h2uWA37GQYxTmoibIdxifgwIvCLG8Ob7wMDbTCOGezIEo2FPKw
   46X0rOkFRoWDTps8vRNuiIuPzZKmGFPcsdZB8uELu/oblHPKlW9LfPGeP
   mZ+HVqSTCqlf2dzbJArI0ZFE7HhqY5Hij9dBMFUcRyngzxPKRunjzKkiD
   hEBzSnmTML9IuTHwWCjki6zG17vANtMi7rJu/mvvjFihs+ULwdlo155HK
   KbDv6WBfKOCy42w7No8R2lY8+s/QCg+OwmSTQk/gQnuMeEs4gM6P1qpvT
   Q==;
X-CSE-ConnectionGUID: d0DeCeVqQLuibrvMRVHFUw==
X-CSE-MsgGUID: dZIDuU62RlyJ+IJk6epDAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11602"; a="89798678"
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="89798678"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2025 01:12:37 -0800
X-CSE-ConnectionGUID: uin207E2SMetKzkN84VFlQ==
X-CSE-MsgGUID: DTES6r2LQ0W9RJcIblMVag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,278,1754982000"; 
   d="scan'208";a="186795791"
Received: from jf5300-b11a338t.jf.intel.com ([10.242.51.115])
  by orviesa009.jf.intel.com with ESMTP; 04 Nov 2025 01:12:38 -0800
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
Subject: [PATCH v13 06/22] crypto: iaa - Simplify the code flow in iaa_compress() and iaa_decompress().
Date: Tue,  4 Nov 2025 01:12:19 -0800
Message-Id: <20251104091235.8793-7-kanchana.p.sridhar@intel.com>
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

This commit simplifies and streamlines the logic in the core
iaa_compress() and iaa_decompress() routines, eliminates branches, etc.

This makes it easier to add improvements such as polling for job
completions, essential to accomplish batching with hardware
parallelism.

Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
---
 drivers/crypto/intel/iaa/iaa_crypto_main.c | 114 ++++++++++++---------
 1 file changed, 67 insertions(+), 47 deletions(-)

diff --git a/drivers/crypto/intel/iaa/iaa_crypto_main.c b/drivers/crypto/intel/iaa/iaa_crypto_main.c
index ca53445a0a7f..74d5b451e34b 100644
--- a/drivers/crypto/intel/iaa/iaa_crypto_main.c
+++ b/drivers/crypto/intel/iaa/iaa_crypto_main.c
@@ -1798,7 +1798,34 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc->src2_size = sizeof(struct aecs_comp_table_record);
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	if (ctx->use_irq) {
+	if (likely(!ctx->use_irq)) {
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto out;
+		}
+
+		/* Update stats */
+		update_total_comp_calls();
+		update_wq_comp_calls(wq);
+
+		if (ctx->async_mode)
+			return -EINPROGRESS;
+
+		ret = check_completion(dev, idxd_desc->iax_completion, true, false);
+		if (ret) {
+			dev_dbg(dev, "check_completion failed ret=%d\n", ret);
+			goto out;
+		}
+
+		*dlen = idxd_desc->iax_completion->output_size;
+
+		/* Update stats */
+		update_total_comp_bytes_out(*dlen);
+		update_wq_comp_bytes(wq, *dlen);
+
+		*compression_crc = idxd_desc->iax_completion->crc;
+	} else {
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
 		idxd_desc->crypto.req = req;
@@ -1806,40 +1833,23 @@ static int iaa_compress(struct crypto_tfm *tfm, struct acomp_req *req,
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = true;
-	}
-
-	ret = idxd_submit_desc(wq, idxd_desc);
-	if (ret) {
-		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-		goto err;
-	}
 
-	/* Update stats */
-	update_total_comp_calls();
-	update_wq_comp_calls(wq);
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto out;
+		}
 
-	if (ctx->async_mode) {
-		ret = -EINPROGRESS;
-		goto out;
-	}
+		/* Update stats */
+		update_total_comp_calls();
+		update_wq_comp_calls(wq);
 
-	ret = check_completion(dev, idxd_desc->iax_completion, true, false);
-	if (ret) {
-		dev_dbg(dev, "check_completion failed ret=%d\n", ret);
-		goto err;
+		return -EINPROGRESS;
 	}
 
-	*dlen = idxd_desc->iax_completion->output_size;
-
-	/* Update stats */
-	update_total_comp_bytes_out(*dlen);
-	update_wq_comp_bytes(wq, *dlen);
-
-	*compression_crc = idxd_desc->iax_completion->crc;
-
-err:
-	idxd_free_desc(wq, idxd_desc);
 out:
+	idxd_free_desc(wq, idxd_desc);
+
 	return ret;
 }
 
@@ -1894,7 +1904,22 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 	desc->src1_size = slen;
 	desc->completion_addr = idxd_desc->compl_dma;
 
-	if (ctx->use_irq) {
+	if (likely(!ctx->use_irq)) {
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto fallback_software_decomp;
+		}
+
+		/* Update stats */
+		update_total_decomp_calls();
+		update_wq_decomp_calls(wq);
+
+		if (ctx->async_mode)
+			return -EINPROGRESS;
+
+		ret = check_completion(dev, idxd_desc->iax_completion, false, false);
+	} else {
 		desc->flags |= IDXD_OP_FLAG_RCI;
 
 		idxd_desc->crypto.req = req;
@@ -1902,25 +1927,20 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		idxd_desc->crypto.src_addr = src_addr;
 		idxd_desc->crypto.dst_addr = dst_addr;
 		idxd_desc->crypto.compress = false;
-	}
 
-	ret = idxd_submit_desc(wq, idxd_desc);
-	if (ret) {
-		dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
-		goto fallback_software_decomp;
-	}
+		ret = idxd_submit_desc(wq, idxd_desc);
+		if (ret) {
+			dev_dbg(dev, "submit_desc failed ret=%d\n", ret);
+			goto fallback_software_decomp;
+		}
 
-	/* Update stats */
-	update_total_decomp_calls();
-	update_wq_decomp_calls(wq);
+		/* Update stats */
+		update_total_decomp_calls();
+		update_wq_decomp_calls(wq);
 
-	if (ctx->async_mode) {
-		ret = -EINPROGRESS;
-		goto out;
+		return -EINPROGRESS;
 	}
 
-	ret = check_completion(dev, idxd_desc->iax_completion, false, false);
-
 fallback_software_decomp:
 	if (ret) {
 		dev_dbg(dev, "%s: desc allocation/submission/check_completion failed ret=%d\n", __func__, ret);
@@ -1935,7 +1955,7 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 		if (ret) {
 			pr_err("%s: iaa decompress failed: deflate-generic fallback error ret=%d\n",
 			       __func__, ret);
-			goto err;
+			goto out;
 		}
 	} else {
 		req->dlen = idxd_desc->iax_completion->output_size;
@@ -1947,10 +1967,10 @@ static int iaa_decompress(struct crypto_tfm *tfm, struct acomp_req *req,
 
 	*dlen = req->dlen;
 
-err:
+out:
 	if (idxd_desc)
 		idxd_free_desc(wq, idxd_desc);
-out:
+
 	return ret;
 }
 
-- 
2.27.0

