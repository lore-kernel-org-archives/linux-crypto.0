Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C268387356
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 18:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774376383; cv=none; b=X5d7vau5CYhrFd/mgiAO8SPahnXz9zAcMmmWiyWRAuPUwIUkjaQFgc2FudHsLZC/BLp+bRqMsTteMDnAuFu6Qu1bTrfKZYvNJuAUBB21/yha+fjHSVjXcj9qB9SGGs4tyCScjDYfVoobKxlmp9wfWDrw6gZSFtC3NkyYX280RCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774376383; c=relaxed/simple;
	bh=zNY8xeQrEOStQQps6UrXeQsWpesZCu7UKT6liSEuYEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXFOPqhtprOyVMC1bjzKlo+yRTa9aSnvnxhiHQ/FEf9Bhy9guZ7gCUs5CyrRFmfr4eBUrnrYohx3ZCZ60U0meH2wyTUjQfFETKUk7ySNufP776E0dPxNQDjDzxQ1J0OtaqFddwhU8nSDRkJKjG+hn8PPS4zc9UKZIsQtyq0VLLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IOZduRKH; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IOZduRKH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774376381; x=1805912381;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zNY8xeQrEOStQQps6UrXeQsWpesZCu7UKT6liSEuYEw=;
  b=IOZduRKHsi+vSqHIPQWFwxlM9vVJXs4+alJhJrkN2RtT5nB9cYH5Y7Ct
   QxsKg0AcxrWfbTfBiNzyKJAmxBGtrcocsrCr6KzB1XmkvWftIR9e99eU0
   iNBdAxwpvIuSPj/nnVhNk4pstIsPlZwrQp928Ue1ATflRsmCgK9uJ1t6K
   jHQUmxNt2LCLmDiVbeY0DFgiDQXw+ERsKNUwepehGnTc/rBrS6Ro14VCk
   YaVOC6poXDom4bontK9InIXX93UUB+Bd3uv7NmxbPaAL+4q7L705ZdaH6
   2VjlVQ1+NlTKLqmNJYjd8ibK6Ns9BzJJiMumQeq4RsBUQL7EYOBnTFccK
   A==;
X-CSE-ConnectionGUID: nac20hgTSa2F1X9neJ88Cg==
X-CSE-MsgGUID: p2sL+QASQ5ii07zI3VOaKQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="86480281"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="86480281"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 11:19:40 -0700
X-CSE-ConnectionGUID: ONqlXDvqR2GZWzewH4JQ5A==
X-CSE-MsgGUID: GFtLTmF9QAuGrTd1P8FlTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="247489428"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by fmviesa002.fm.intel.com with ESMTP; 24 Mar 2026 11:19:40 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	atharvd440@gmail.com,
	andriy.shevchenko@intel.com,
	ahsan.atta@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 1/2] crypto: qat - fix type mismatch in RAS sysfs show functions
Date: Tue, 24 Mar 2026 18:17:23 +0000
Message-ID: <20260324181936.122027-2-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260324181936.122027-1-giovanni.cabiddu@intel.com>
References: <20260324181936.122027-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

ADF_RAS_ERR_CTR_READ() expands to atomic_read(), which returns int.
The local variable 'counter' was declared as 'unsigned long', causing
a type mismatch on the assignment. The format specifier '%ld' was
consequently wrong in two ways: wrong length modifier and wrong
signedness.

Use int to match the return type of atomic_read() and update the
format specifier to '%d' accordingly.

Fixes: 532d7f6bc458 ("crypto: qat - add error counters")
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 .../intel/qat/qat_common/adf_sysfs_ras_counters.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
index e97c67c87b3c..6abb57bfd328 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
@@ -13,14 +13,14 @@ static ssize_t errors_correctable_show(struct device *dev,
 				       char *buf)
 {
 	struct adf_accel_dev *accel_dev;
-	unsigned long counter;
+	int counter;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
 	if (!accel_dev)
 		return -EINVAL;
 
 	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_CORR);
-	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", counter);
 }
 
 static ssize_t errors_nonfatal_show(struct device *dev,
@@ -28,14 +28,14 @@ static ssize_t errors_nonfatal_show(struct device *dev,
 				    char *buf)
 {
 	struct adf_accel_dev *accel_dev;
-	unsigned long counter;
+	int counter;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
 	if (!accel_dev)
 		return -EINVAL;
 
 	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_UNCORR);
-	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", counter);
 }
 
 static ssize_t errors_fatal_show(struct device *dev,
@@ -43,14 +43,14 @@ static ssize_t errors_fatal_show(struct device *dev,
 				 char *buf)
 {
 	struct adf_accel_dev *accel_dev;
-	unsigned long counter;
+	int counter;
 
 	accel_dev = adf_devmgr_pci_to_accel_dev(to_pci_dev(dev));
 	if (!accel_dev)
 		return -EINVAL;
 
 	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_FATAL);
-	return scnprintf(buf, PAGE_SIZE, "%ld\n", counter);
+	return scnprintf(buf, PAGE_SIZE, "%d\n", counter);
 }
 
 static ssize_t reset_error_counters_store(struct device *dev,
-- 
2.53.0

