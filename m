Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F04827056D
	for <linux-crypto@vger.kernel.org>; Tue, 13 May 2025 10:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747131939; cv=none; b=nTHdhos7b5vrYdUWwXsbGwATqubU+42HK8BJTBL7Yi2xn+NOCQBWOWlOvINMLaiUiRfvENehEXyDuCE3yp66NbmWlh71NWDX4HsMup7yRMzxd+eRwVvFdhhmb5LWDdPV5KGY4z8TYw51rI1Xg/ihb5YbyROHmCTKgNFoJrglzPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747131939; c=relaxed/simple;
	bh=afy3gUW1afOEJQkLuhDV/WUQx6m0aJNpWS36ogG5MBA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dCsNsnFytYPQ7Zgzfz6erQPV5iVAYU9rT0ctcJ/dnJqhUB4CL4vh/WJ+CbxaoNcnFq07qHF0etTkALdtUSIkig6Jmm9H4nO+nl7n1idBuoHkJHoj4p0z5ya4ej7yiWu9qXg1Qrwfia+nW9ONd9DTsSdy/DmR97jtn1NDgzMrF08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hmFIKXui; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hmFIKXui"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747131937; x=1778667937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=afy3gUW1afOEJQkLuhDV/WUQx6m0aJNpWS36ogG5MBA=;
  b=hmFIKXuiAqwp2dWRR6XXNd5+kdQkZiCUQTuKHFCImP8NxVBUaDfXSNlf
   /YkJmQs9IuVYZ4zYk1IlsDCWKDyOhxh/NtoynPyVFC+cBYxSFsIo+C3KC
   i3TRfI3pp+rmbK8E61BtID4QM9muZg0SgVynyx9W2mQNGsY2MAkEaUmyY
   qa1msttxho7D7YeeK4GvzNwXhvXu13nt9Vahs4pYUhEg3ZjrER13ZHxcZ
   ksfHgbH6iQBReqw8Qy80ZUi5UKe3t4TeEHiIf7iQ5wIxtFptZVizDx4B8
   rYlEmyXsdtzLqQoyqBm/DjjLNhsU8GrgbVkKAm0YC1bbSCzuCxZw+QjaX
   w==;
X-CSE-ConnectionGUID: 1YWNxOkUQiqWw/FjkpycgA==
X-CSE-MsgGUID: Mpixb1CGTj+bJWI1Vn734A==
X-IronPort-AV: E=McAfee;i="6700,10204,11431"; a="48076419"
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="48076419"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 03:25:37 -0700
X-CSE-ConnectionGUID: fwbeBCsqTVSNRzbklp/OOg==
X-CSE-MsgGUID: uXFHpwo0SxW1o30bSecOIg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,284,1739865600"; 
   d="scan'208";a="142786422"
Received: from t21-qat.iind.intel.com ([10.49.15.35])
  by orviesa005.jf.intel.com with ESMTP; 13 May 2025 03:25:36 -0700
From: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com
Subject: [PATCH 2/2] crypto: qat - enable reporting of error counters for GEN6 devices
Date: Tue, 13 May 2025 11:25:27 +0100
Message-Id: <20250513102527.1181096-3-suman.kumar.chakraborty@intel.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20250513102527.1181096-1-suman.kumar.chakraborty@intel.com>
References: <20250513102527.1181096-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable the reporting of error counters through sysfs for QAT GEN6
devices and update the ABI documentation.

This enables the reporting of the following:
   - errors_correctable - hardware correctable errors that allow the
     system to recover without data loss.
   - errors_nonfatal: errors that can be isolated to specific in-flight
     requests.
   - errors_fatal: errors that cannot be contained to a request,
     requiring a Function Level Reset (FLR) upon occurrence.

Signed-off-by: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 Documentation/ABI/testing/sysfs-driver-qat_ras | 8 ++++----
 drivers/crypto/intel/qat/qat_6xxx/adf_drv.c    | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-driver-qat_ras b/Documentation/ABI/testing/sysfs-driver-qat_ras
index 176dea1e9c0a..82ceb04445ec 100644
--- a/Documentation/ABI/testing/sysfs-driver-qat_ras
+++ b/Documentation/ABI/testing/sysfs-driver-qat_ras
@@ -4,7 +4,7 @@ KernelVersion:	6.7
 Contact:	qat-linux@intel.com
 Description:	(RO) Reports the number of correctable errors detected by the device.
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is only available for qat_4xxx and qat_6xxx devices.
 
 What:		/sys/bus/pci/devices/<BDF>/qat_ras/errors_nonfatal
 Date:		January 2024
@@ -12,7 +12,7 @@ KernelVersion:	6.7
 Contact:	qat-linux@intel.com
 Description:	(RO) Reports the number of non fatal errors detected by the device.
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is only available for qat_4xxx and qat_6xxx devices.
 
 What:		/sys/bus/pci/devices/<BDF>/qat_ras/errors_fatal
 Date:		January 2024
@@ -20,7 +20,7 @@ KernelVersion:	6.7
 Contact:	qat-linux@intel.com
 Description:	(RO) Reports the number of fatal errors detected by the device.
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is only available for qat_4xxx and qat_6xxx devices.
 
 What:		/sys/bus/pci/devices/<BDF>/qat_ras/reset_error_counters
 Date:		January 2024
@@ -38,4 +38,4 @@ Description:	(WO) Write to resets all error counters of a device.
 			# cat /sys/bus/pci/devices/<BDF>/qat_ras/errors_fatal
 			0
 
-		This attribute is only available for qat_4xxx devices.
+		This attribute is only available for qat_4xxx and qat_6xxx devices.
diff --git a/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
index 2531c337e0dd..d40030b585d3 100644
--- a/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_6xxx/adf_drv.c
@@ -173,6 +173,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (ret)
 		return dev_err_probe(dev, ret, "Failed to save pci state.\n");
 
+	accel_dev->ras_errors.enabled = true;
+
 	adf_dbgfs_init(accel_dev);
 
 	ret = devm_add_action_or_reset(dev, adf_dbgfs_cleanup, accel_dev);
-- 
2.40.1

