Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534871F4E5F
	for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2025 16:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004916; cv=none; b=hYobjAuF5vMYgZaYxrL+cylC73ePyqr2wj2QH9yYVKJQcq0b0GDyW/eU0t7pP8mIZXHJfDaAKRIXNWIWe+h3JN52U9f7NYHJl7jC/pwWyduK2TZ12jvUcSGq3a3NgIhxnCVPcGI2j+ZfSHoWfb37RzzOtz2EOQYBcfE8Nv4jzAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004916; c=relaxed/simple;
	bh=eGo7xeBJzyh1fmwqEBuHctInfryYD1Pcr94GRXHnuZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMVMazy1HRjVkDmG2HWLRNN2f8rQ7KRtcjCxUP6N9VUGSUp59R3wH0FbpMw6PiBESG0wZesHqBMkOdGFBg+VXm1+3wzFEBDuv9nDGYqWGIYfYCNbasWANnA54q2xHZumpxNByXeAB4EC0qflp6Swe0ndD80XSXQGeQXydv094vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l8n5pPPI; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l8n5pPPI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743004915; x=1774540915;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eGo7xeBJzyh1fmwqEBuHctInfryYD1Pcr94GRXHnuZY=;
  b=l8n5pPPIhEbqk4baaWlCie/xho7h02XkALwCnS8XkaKGwqdCgliBUzuE
   DC+QCMRiQ2s73ltkE2NGRJRyyc41Z1WykNBrx+oJDGMEyc5zbXWagF/UK
   PoSit2/EKyRONjn1iT10bE/rm0ChVXqgsaNuQWuzDmBJYHp5SWBy+ErAu
   pVe5N7YlbaIn4LSgKCULsFpp/FTPy8JDlaSsS6gwPS386Bg1G9JWnqwGD
   v8eSP5bLSTPrQTuzwks+k4x2vCDsaQWhGN+xziKHifY5Xkep3/pJ4d4Qh
   N2vocdRP2tYmhjrSCKyQcDrvF8V8IBQP4YF8xJe6x1tPHHCPUnbOD2ZKC
   w==;
X-CSE-ConnectionGUID: GPIT45OwQ1GwEOFzkCCINQ==
X-CSE-MsgGUID: U/NgVi5LTnyGNcV8zCiXNA==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="61823920"
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="61823920"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 09:01:55 -0700
X-CSE-ConnectionGUID: vRzVSEzGQHW2i5NQyQYLBw==
X-CSE-MsgGUID: NI35G9bKSea/BTMQBIiPXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="129928595"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa004.fm.intel.com with ESMTP; 26 Mar 2025 09:01:53 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 7/8] crypto: qat - remove redundant prototypes in qat_c3xxx
Date: Wed, 26 Mar 2025 15:59:52 +0000
Message-ID: <20250326160116.102699-9-giovanni.cabiddu@intel.com>
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
qat_c3xxx driver.

Also move the pci_device_id table close to where it is used and drop the
inner comma as it is not required.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c | 33 +++++++++-----------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
index b825b35ab4bf..260f34d0d541 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
@@ -19,24 +19,6 @@
 #include <adf_dbgfs.h>
 #include "adf_c3xxx_hw_data.h"
 
-static const struct pci_device_id adf_pci_tbl[] = {
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C3XXX), },
-	{ }
-};
-MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
-
-static int adf_probe(struct pci_dev *dev, const struct pci_device_id *ent);
-static void adf_remove(struct pci_dev *dev);
-
-static struct pci_driver adf_driver = {
-	.id_table = adf_pci_tbl,
-	.name = ADF_C3XXX_DEVICE_NAME,
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
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_C3XXX) },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
+
+static struct pci_driver adf_driver = {
+	.id_table = adf_pci_tbl,
+	.name = ADF_C3XXX_DEVICE_NAME,
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

