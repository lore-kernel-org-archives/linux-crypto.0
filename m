Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E291F5402
	for <linux-crypto@vger.kernel.org>; Wed, 26 Mar 2025 16:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743004909; cv=none; b=uV5kv3LKHi5zPMwrHlYNLZXntQNWJefsOCGL/NxyErKU1fA9iV4z5eFiayCpUnTPpoLJ66F9Tm3qDNod23pPo9nsACGm68SGMjuS2h/QqnxJrBtIU6MXSKwqpVPfRGIiNAbWkQNm4vsMUNAJJWV3wdIsI061gGalJ+XDoQaWI0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743004909; c=relaxed/simple;
	bh=0+b/cIBTDXTFDRK35uVzbq6vrAkuaVyshKTCzsyGe0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnLb+tPpdc/pMl0JlKJfVeis77Rihv3BntFif+OrV7fl5dTO1PuXenPbnqRrQ2mwudyVQ+FvohhUS425esIoy/7fYpzhmzml2yMqbjrJEn+x/ajB1u35HeCfgS8VSlz0W054UJwqr4ooGtfX08obPrpgQ7SA9PceqbIujSoKAo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U5h+RP8Y; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U5h+RP8Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743004908; x=1774540908;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0+b/cIBTDXTFDRK35uVzbq6vrAkuaVyshKTCzsyGe0A=;
  b=U5h+RP8YYaZ68uP3wKomVETMXjLDTBL7W93kTLOGr/AxtbUASjHtKSyx
   SndrDBgAmbQrGoPh3oOuhUE5hpB4PDAyoPx+qlNctJUGC1FLj8v8RmXnu
   nauTMn8Tmg5v+sq63tvIe7A2gr5x3cukegnb7396yxGgop60RTy29p1UG
   W/CJ9/H3HhrTDRa4P8D0snuAbCicwn3pBOn35B+YLcEzPIvmWfrOMCgIg
   fKvycN9lhRE5iETDU5l7m4Rpq2ocuC94t/NQLBdzE2tEL3ZV2APY5HFML
   u3/fS/P6pswIA65RpdRncs4BSF/3IQImsQIGu4Z+FX4yM1iEi0kulJ+Ml
   A==;
X-CSE-ConnectionGUID: PFwI3VPGQ3e93drFa3XpfQ==
X-CSE-MsgGUID: 1bp4EPJuR6WMGaneBU3PRw==
X-IronPort-AV: E=McAfee;i="6700,10204,11385"; a="61823886"
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="61823886"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Mar 2025 09:01:48 -0700
X-CSE-ConnectionGUID: DUBc0tt8SiywPlrhXe4RTw==
X-CSE-MsgGUID: 6SCksalBSumUNI/TKNdTRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,278,1736841600"; 
   d="scan'208";a="129928572"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.223.204])
  by fmviesa004.fm.intel.com with ESMTP; 26 Mar 2025 09:01:46 -0700
From: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	andriy.shevchenko@intel.com,
	qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 3/8] crypto: qat - remove redundant prototypes in qat_dh895xcc
Date: Wed, 26 Mar 2025 15:59:48 +0000
Message-ID: <20250326160116.102699-5-giovanni.cabiddu@intel.com>
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
qat_dh895xxcc driver.

Also move the pci_device_id table close to where it is used and drop the
inner comma as it is not required.

This does not introduce any functional change.

Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 .../crypto/intel/qat/qat_dh895xcc/adf_drv.c   | 33 +++++++++----------
 1 file changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
index 07e9d7e52861..730147404ceb 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
@@ -19,24 +19,6 @@
 #include <adf_dbgfs.h>
 #include "adf_dh895xcc_hw_data.h"
 
-static const struct pci_device_id adf_pci_tbl[] = {
-	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_DH895XCC), },
-	{ }
-};
-MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
-
-static int adf_probe(struct pci_dev *dev, const struct pci_device_id *ent);
-static void adf_remove(struct pci_dev *dev);
-
-static struct pci_driver adf_driver = {
-	.id_table = adf_pci_tbl,
-	.name = ADF_DH895XCC_DEVICE_NAME,
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
+	{ PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_QAT_DH895XCC) },
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, adf_pci_tbl);
+
+static struct pci_driver adf_driver = {
+	.id_table = adf_pci_tbl,
+	.name = ADF_DH895XCC_DEVICE_NAME,
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

