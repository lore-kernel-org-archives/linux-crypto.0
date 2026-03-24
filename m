Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7667138423C
	for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2026 18:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774376385; cv=none; b=nkLJNtXL1ESLHB2bZXBxhpDhl5o2qkyWC9VUuMjhr1WhOSxhUeU46ANy3pMaUoMIz1rfeJ2AOKODla7LeakG0hFP3CwhB8tIo86iHnxJuCJeeHVeK3H3xnRE/2g9VGw72eldXiDa8YiAR7E7TPfacaHFz7iTaC8Sngq0FVT9Ghc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774376385; c=relaxed/simple;
	bh=5Vz4E956yHjZIPFsxvaJb/PxVJ+4F/osD3QqwH/0lRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQ0QVFNhVcmg3Blbq9z+F2c+XXEQoO5Tf3NkGTQ8ZnXj/yij6icUQI9yjjfZDf/fadjGLHIWtlzvIhHIjWtH8JyBl8vBS4ZMHLwSz62QrEbssOtWv+WrmQyCSV28NiMZ0748GXYydVp6oMIZad4W6NzZ338opBMmtCQNXgT8d7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YSR7xrJv; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YSR7xrJv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774376382; x=1805912382;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5Vz4E956yHjZIPFsxvaJb/PxVJ+4F/osD3QqwH/0lRI=;
  b=YSR7xrJvkByMO8ZzuXD5LYyrO3FlSdGFNvew1D214rOSbRTtvCNkz6at
   rP5JU3zbQU0V/5dgqxHqSC2rm69fdHzEcIZQza/hDgv2kN18I/mX/x1RL
   ZThuspuLMSIrHExBwDoKYcXnfSqPBnGq4OdAYLxoigfWrhCTXxmz6uFqE
   ZKiFMoxtlUZtEWlPl9TwA70nrQcKnxBnVIpsuqZY6qldSfjygy/r4I6/K
   tc4BKvUmjwI36hxPRnEdU15I3GFI4jXyPDReAb/f8u9+UFHldp6fz9OMB
   icWUG/j8fI/dnYpWU55g2p3UENzsYr2lX5UNqHwBbhWmszcyQKij3Qogd
   w==;
X-CSE-ConnectionGUID: 7+bVs7+QS6+OR0YPShFw2w==
X-CSE-MsgGUID: Rv+lhlZsRg6so/39z0USdg==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="86480286"
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="86480286"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 11:19:42 -0700
X-CSE-ConnectionGUID: yJuyCay4RFmr72INuff2eQ==
X-CSE-MsgGUID: 62k8eoN9TC6D/xBQWN36rA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,138,1770624000"; 
   d="scan'208";a="247489434"
Received: from silpixa00401971.ir.intel.com ([10.20.226.106])
  by fmviesa002.fm.intel.com with ESMTP; 24 Mar 2026 11:19:42 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	atharvd440@gmail.com,
	andriy.shevchenko@intel.com,
	ahsan.atta@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 2/2] crypto: qat - replace scnprintf() with sysfs_emit()
Date: Tue, 24 Mar 2026 18:17:24 +0000
Message-ID: <20260324181936.122027-3-giovanni.cabiddu@intel.com>
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

From: Atharv Dubey <atharvd440@gmail.com>

Replace scnprintf() with sysfs_emit() in the three RAS error counter
sysfs show callbacks. sysfs_emit() is the recommended API for sysfs show
functions as per Documentation/filesystems/sysfs.rst; it enforces the
PAGE_SIZE limit implicitly, removing the need to pass it explicitly.

Signed-off-by: Atharv Dubey <atharvd440@gmail.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 .../crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c    | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
index 6abb57bfd328..ef1420199210 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sysfs_ras_counters.c
@@ -20,7 +20,7 @@ static ssize_t errors_correctable_show(struct device *dev,
 		return -EINVAL;
 
 	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_CORR);
-	return scnprintf(buf, PAGE_SIZE, "%d\n", counter);
+	return sysfs_emit(buf, "%d\n", counter);
 }
 
 static ssize_t errors_nonfatal_show(struct device *dev,
@@ -35,7 +35,7 @@ static ssize_t errors_nonfatal_show(struct device *dev,
 		return -EINVAL;
 
 	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_UNCORR);
-	return scnprintf(buf, PAGE_SIZE, "%d\n", counter);
+	return sysfs_emit(buf, "%d\n", counter);
 }
 
 static ssize_t errors_fatal_show(struct device *dev,
@@ -50,7 +50,7 @@ static ssize_t errors_fatal_show(struct device *dev,
 		return -EINVAL;
 
 	counter = ADF_RAS_ERR_CTR_READ(accel_dev->ras_errors, ADF_RAS_FATAL);
-	return scnprintf(buf, PAGE_SIZE, "%d\n", counter);
+	return sysfs_emit(buf, "%d\n", counter);
 }
 
 static ssize_t reset_error_counters_store(struct device *dev,
-- 
2.53.0

