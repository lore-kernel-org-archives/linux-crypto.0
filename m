Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56CEC1F55FF
	for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2025 16:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004913; cv=none; b=Xpuewlh5v7yHwIXLghAgPErVYO0kFY102U3iUuuo9v7axeGC5dsYghNmCPPaQCt+x9VjCOY/VFVp7KO7Th6kkqfLr9cAuQVGhyreg139bhpPsMGrHScfL2t9Lqi5JJ28yiDNUK0VbqvJagI7e+mcxDrOQ9ka+Q6hYEVHeIyZwRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004913; c=relaxed/simple;
	bh=44zmwuI8YQm/iXiTLWjgJElktkIiKu8XNi6wl2TdTF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkTMV4PMi4829dgkIIKMKbbmHVGPH/OATKPCZHOi1vzNZRKw93ZpfB2MCX0ZftH+2O4/IW7npOXOFbwz50He7BguwMBhqGufrFtL6HsjaWpoGMEKFOJk+yukEHAW/KYAVjJalKEa04CgsrZvFFZR+7hvGyCVef31vjHDbUvKI3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JwNbib7F; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JwNbib7F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743004912; x=1774540912;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=44zmwuI8YQm/iXiTLWjgJElktkIiKu8XNi6wl2TdTF0=;
  b=JwNbib7FNcqZbXjdwbHFIFNZOAoLhlBglEVousz3CuQVXiy6EP7LnlCj
   QgwzmJmBZ5FurEO1So4k4BWF2FF9gqtD892gZu2QOBK40/Vv6heXeOnOu
   pRffyPpRLqn7ejI8/2HzwdG6sdp0gJe6KOUBZqzmj8R79XEMDUlU/3/mF
   ctMjSa2MuaGn5KahoNAme/q6nyS4MYC2lsw+JdPz3tYtKjDA7aivWGrzQ
   equPfsfCclp2NGpQIg4ZUtHBKw6iBi+GmKAdo0okuYvuF0FgxLKk/TAPG
   K1+8lKx8eo7v6FtAbhQ2w758cvSjAa8PMZU+0CAhKjwnxie/Rg3EumpI4
   Q==;
X-CSE-ConnectionGUID: T1OjyjkcSgGv7f7p67ucHg==
X-CSE-MsgGUID: 3vcN5TNOS1OrK+CqsU35Sg==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="61823900"
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="61823900"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 09:01:52 -0700
X-CSE-ConnectionGUID: 86s4DZIhQGC1nR0MhjdQ4Q==
X-CSE-MsgGUID: oujgEghNRFKqzs5Rn/VrEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="129928582"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa004.fm.intel.com with ESMTP; 26 Mar 2025 09:01:50 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5/8] crypto: qat - remove redundant prototypes in qat_c62x
Date: Wed, 26 Mar 2025 15:59:50 +0000
Message-ID: <20250326160116.102699-7-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250326160116.102699-2-giovanni.cabiddu@intel.com>
References: <20250326160116.102699-2-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit

Move the definition of the adf_driver structure and remove the redundant
prototypes for the functions adf_probe() and adf_remove() in the
qat_c62x driver.

Also move the pci_device_id table close to where it is used and drop the
inner comma as it is not required.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c | 33 ++++++++++-----------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
index 8a7bdec358d6..0bac717e88d9 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
@@ -19,24 +19,6 @@
 #include <adf_dbgfs.h>
 #include "adf_c62x_hw_data.h"
 
-static const struct pci_device_id adf_pci_tbl[] = {
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C62X), },
-	{ }
-};
-MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
-
-static int adf_probe(struct pci_dev *dev, const struct pci_device_id *ent);
-static void adf_remove(struct pci_dev *dev);
-
-static struct pci_driver adf_driver = {
-	.id_table = adf_pci_tbl,
-	.name = ADF_C62X_DEVICE_NAME,
-	.probe = adf_probe,
-	.remove = adf_remove,
-	.sriov_configure = adf_sriov_configure,
-	.err_handler = &adf_err_handler,
-};
-
 static void adf_cleanup_pci_dev(struct adf_accel_dev *accel_dev)
 {
 	pci_release_regions(accel_dev->accel_pci_dev.pci_dev);
@@ -227,6 +209,21 @@ static void adf_remove(struct pci_dev *pdev)
 	kfree(accel_dev);
 }
 
+static const struct pci_device_id adf_pci_tbl[] = {
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C62X) },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
+
+static struct pci_driver adf_driver = {
+	.id_table = adf_pci_tbl,
+	.name = ADF_C62X_DEVICE_NAME,
+	.probe = adf_probe,
+	.remove = adf_remove,
+	.sriov_configure = adf_sriov_configure,
+	.err_handler = &adf_err_handler,
+};
+
 static int __init adfdrv_init(void)
 {
 	request_module("intel_qat");
-- 
2.48.1

