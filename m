Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C5B3A3E9C
	for <linux-crypto@vger.kernel.org>; Wed, 20 May 2026 12:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779281482; cv=none; b=ik8ulV4T2IG1jBwp3nhsdycGEP4N7z3nwsM0arrVhhNaknLb7RxB0ABMiG7X1dNv+AaxBzve6VsurFCsIwEaO/QFRYm4I/bMZeQ1HNUg4QYgkCZLIrdbKrg0jzqlByYGH6WBzI1N28kBmPbrwO735wV+p4x5/NevCSEjsxBb+fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779281482; c=relaxed/simple;
	bh=gvQqM9DBcBl9/abfK7dsONyOtiqZpiVyfor8CRVyjD8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bTsqLpWkKNO+1OcoStPhmpbzvGFItfW4+zKfuxdl6cj7SA2UwYtcZZPXJ21CZXsSUG5j8pfmQNYhKgMHad9pBDtLzOqbKFV3mYqPkDzVqJ6FoFAID2LRV/8YVlhQGZ0bFHXb3U8v5MVeE/HL9KqVO+rwTjOAVXtx/dfa+AdptV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cdMdN3Iq; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cdMdN3Iq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1779281481; x=1810817481;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=gvQqM9DBcBl9/abfK7dsONyOtiqZpiVyfor8CRVyjD8=;
  b=cdMdN3IqzjiZ2bqxpwaBVvyVpfy99YgwPGzDIq+kNwyknaKGeVAUOZBb
   lcAKPY44Q0ASyqJRcMlaiOihV6MZSxtIDkMPanBQW1hlaSLbfUpKifDqC
   vWbxTnvDViaIp21i5vFIwjbK3xgjnEmgGrX8g4vVZGNVKLz3d1vDXQzTM
   JSBE/YlnfnvBWu5jihVKdWRjfYb6rryAPlvz0AD1vvAcXEjQT2QH85nIg
   Wrx6IlMs/+ZzYrs34g1FHy4HcPu0xJcCLxWmEw/YWf0WzDiuxAuHnZuT3
   nUYa7EUIruTJtV5wKtkYuZS/wPrFj02Qve+q5btzpKLQG5nQhXuUUFPL9
   w==;
X-CSE-ConnectionGUID: fph/iULqRk6B4aXHWl9WXA==
X-CSE-MsgGUID: PY9CQousQ8Wpi7R4foAO0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11792"; a="80159033"
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="80159033"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2026 05:51:20 -0700
X-CSE-ConnectionGUID: yqXA+nPBSR28YNnPF5j29A==
X-CSE-MsgGUID: dcAuS8e3SV+IYUBUduGunw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,244,1770624000"; 
   d="scan'208";a="278267604"
Received: from silpixa00401812.ir.intel.com ([10.20.226.90])
  by orviesa001.jf.intel.com with ESMTP; 20 May 2026 05:51:18 -0700
From: Ahsan Atta <ahsan.atta@intel.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org,
	qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - use pci logging variants for PCI-specific messages
Date: Wed, 20 May 2026 13:51:50 +0100
Message-ID: <20260520125150.211802-1-ahsan.atta@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Replace dev_err(&pdev->dev, ...), dev_info(&pdev->dev, ...) and
dev_dbg(&pdev->dev, ...) with pci_err(), pci_info() and pci_dbg()
where the log message relates to a PCI subsystem operation such as
device enable, BAR mapping, PCI region requests, PCI state
save/restore, and SR-IOV management.

Messages about driver-level logic (NUMA topology, device matching,
accelerator units, capabilities, configuration, DMA) are intentionally
left as dev_err() even when a struct pci_dev pointer is in scope,
since those concern the device or driver rather than the PCI bus.

No functional change.

Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
---
 drivers/crypto/intel/qat/qat_420xx/adf_drv.c  |  8 +++----
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   |  8 +++----
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c  |  4 ++--
 .../crypto/intel/qat/qat_c3xxxvf/adf_drv.c    |  2 +-
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c   |  4 ++--
 drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c |  2 +-
 drivers/crypto/intel/qat/qat_common/adf_aer.c | 21 +++++++++----------
 .../crypto/intel/qat/qat_common/adf_sriov.c   |  2 +-
 .../crypto/intel/qat/qat_dh895xcc/adf_drv.c   |  4 ++--
 .../crypto/intel/qat/qat_dh895xccvf/adf_drv.c |  2 +-
 10 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
index 265bd52778c5..0f0827e2b0bd 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_drv.c
@@ -101,7 +101,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Enable PCI device */
 	ret = pcim_enable_device(pdev);
 	if (ret) {
-		dev_err(&pdev->dev, "Can't enable PCI device.\n");
+		pci_err(pdev, "Can't enable PCI device.\n");
 		goto out_err;
 	}
 
@@ -131,7 +131,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ret = pcim_request_all_regions(pdev, pci_name(pdev));
 	if (ret) {
-		dev_err(&pdev->dev, "Failed to request PCI regions.\n");
+		pci_err(pdev, "Failed to request PCI regions.\n");
 		goto out_err;
 	}
 
@@ -140,14 +140,14 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		bar = &accel_pci_dev->pci_bars[i++];
 		bar->virt_addr = pcim_iomap(pdev, bar_nr, 0);
 		if (!bar->virt_addr) {
-			dev_err(&pdev->dev, "Failed to ioremap PCI region.\n");
+			pci_err(pdev, "Failed to ioremap PCI region.\n");
 			ret = -ENOMEM;
 			goto out_err;
 		}
 	}
 
 	if (pci_save_state(pdev)) {
-		dev_err(&pdev->dev, "Failed to save pci state.\n");
+		pci_err(pdev, "Failed to save pci state.\n");
 		ret = -ENOMEM;
 		goto out_err;
 	}
diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index 681c4dd8f3d2..aa95f762cb4b 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -103,7 +103,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Enable PCI device */
 	ret = pcim_enable_device(pdev);
 	if (ret) {
-		dev_err(&pdev->dev, "Can't enable PCI device.\n");
+		pci_err(pdev, "Can't enable PCI device.\n");
 		goto out_err;
 	}
 
@@ -133,7 +133,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	ret = pcim_request_all_regions(pdev, pci_name(pdev));
 	if (ret) {
-		dev_err(&pdev->dev, "Failed to request PCI regions.\n");
+		pci_err(pdev, "Failed to request PCI regions.\n");
 		goto out_err;
 	}
 
@@ -142,14 +142,14 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		bar = &accel_pci_dev->pci_bars[i++];
 		bar->virt_addr = pcim_iomap(pdev, bar_nr, 0);
 		if (!bar->virt_addr) {
-			dev_err(&pdev->dev, "Failed to ioremap PCI region.\n");
+			pci_err(pdev, "Failed to ioremap PCI region.\n");
 			ret = -ENOMEM;
 			goto out_err;
 		}
 	}
 
 	if (pci_save_state(pdev)) {
-		dev_err(&pdev->dev, "Failed to save pci state.\n");
+		pci_err(pdev, "Failed to save pci state.\n");
 		ret = -ENOMEM;
 		goto out_err;
 	}
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
index ded52744b4fc..e816cc00632f 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
@@ -162,14 +162,14 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		bar->size = pci_resource_len(pdev, bar_nr);
 		bar->virt_addr = pci_iomap(accel_pci_dev->pci_dev, bar_nr, 0);
 		if (!bar->virt_addr) {
-			dev_err(&pdev->dev, "Failed to map BAR %d\n", bar_nr);
+			pci_err(pdev, "Failed to map BAR %d\n", bar_nr);
 			ret = -EFAULT;
 			goto out_err_free_reg;
 		}
 	}
 
 	if (pci_save_state(pdev)) {
-		dev_err(&pdev->dev, "Failed to save pci state\n");
+		pci_err(pdev, "Failed to save pci state\n");
 		ret = -ENOMEM;
 		goto out_err_free_reg;
 	}
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
index e7600d284ed3..1c77f0a1882b 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
@@ -158,7 +158,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		bar->size = pci_resource_len(pdev, bar_nr);
 		bar->virt_addr = pci_iomap(accel_pci_dev->pci_dev, bar_nr, 0);
 		if (!bar->virt_addr) {
-			dev_err(&pdev->dev, "Failed to map BAR %d\n", bar_nr);
+			pci_err(pdev, "Failed to map BAR %d\n", bar_nr);
 			ret = -EFAULT;
 			goto out_err_free_reg;
 		}
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
index 2ebff5855b01..f48f3b437545 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
@@ -162,14 +162,14 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		bar->size = pci_resource_len(pdev, bar_nr);
 		bar->virt_addr = pci_iomap(accel_pci_dev->pci_dev, bar_nr, 0);
 		if (!bar->virt_addr) {
-			dev_err(&pdev->dev, "Failed to map BAR %d\n", bar_nr);
+			pci_err(pdev, "Failed to map BAR %d\n", bar_nr);
 			ret = -EFAULT;
 			goto out_err_free_reg;
 		}
 	}
 
 	if (pci_save_state(pdev)) {
-		dev_err(&pdev->dev, "Failed to save pci state\n");
+		pci_err(pdev, "Failed to save pci state\n");
 		ret = -ENOMEM;
 		goto out_err_free_reg;
 	}
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
index 91e148bb4870..b96f19e31d05 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
@@ -158,7 +158,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		bar->size = pci_resource_len(pdev, bar_nr);
 		bar->virt_addr = pci_iomap(accel_pci_dev->pci_dev, bar_nr, 0);
 		if (!bar->virt_addr) {
-			dev_err(&pdev->dev, "Failed to map BAR %d\n", bar_nr);
+			pci_err(pdev, "Failed to map BAR %d\n", bar_nr);
 			ret = -EFAULT;
 			goto out_err_free_reg;
 		}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_aer.c b/drivers/crypto/intel/qat/qat_common/adf_aer.c
index 3fc7d13e882c..d58cd7fbf707 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_aer.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_aer.c
@@ -22,7 +22,7 @@ static pci_ers_result_t reset_prepare(struct pci_dev *pdev)
 	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
 
 	if (!accel_dev) {
-		dev_err(&pdev->dev, "Can't find acceleration device\n");
+		pci_err(pdev, "Can't find acceleration device\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -46,7 +46,7 @@ static pci_ers_result_t reset_done(struct pci_dev *pdev)
 	int res;
 
 	if (!accel_dev) {
-		dev_err(&pdev->dev, "Can't find acceleration device\n");
+		pci_err(pdev, "Can't find acceleration device\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -64,7 +64,7 @@ static pci_ers_result_t reset_done(struct pci_dev *pdev)
 	clear_bit(ADF_STATUS_RESTARTING, &accel_dev->status);
 
 reset_complete:
-	dev_info(&pdev->dev, "Device reset completed successfully\n");
+	pci_info(pdev, "Device reset completed successfully\n");
 
 	return PCI_ERS_RESULT_RECOVERED;
 }
@@ -74,14 +74,14 @@ static pci_ers_result_t adf_error_detected(struct pci_dev *pdev,
 {
 	struct adf_accel_dev *accel_dev = adf_devmgr_pci_to_accel_dev(pdev);
 
-	dev_info(&pdev->dev, "Acceleration driver hardware error detected.\n");
+	pci_info(pdev, "Acceleration driver hardware error detected.\n");
 	if (!accel_dev) {
-		dev_err(&pdev->dev, "Can't find acceleration device\n");
+		pci_err(pdev, "Can't find acceleration device\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
 	if (state == pci_channel_io_perm_failure) {
-		dev_err(&pdev->dev, "Can't recover from device error\n");
+		pci_err(pdev, "Can't recover from device error\n");
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
@@ -116,10 +116,9 @@ void adf_reset_sbr(struct adf_accel_dev *accel_dev)
 		parent = pdev;
 
 	if (!pci_wait_for_pending_transaction(pdev))
-		dev_info(&GET_DEV(accel_dev),
-			 "Transaction still in progress. Proceeding\n");
+		pci_info(pdev, "Transaction still in progress. Proceeding\n");
 
-	dev_info(&GET_DEV(accel_dev), "Secondary bus reset\n");
+	pci_info(pdev, "Secondary bus reset\n");
 
 	pci_read_config_word(parent, PCI_BRIDGE_CONTROL, &bridge_ctl);
 	bridge_ctl |= PCI_BRIDGE_CTL_BUS_RESET;
@@ -247,8 +246,8 @@ static pci_ers_result_t adf_slot_reset(struct pci_dev *pdev)
 
 static void adf_resume(struct pci_dev *pdev)
 {
-	dev_info(&pdev->dev, "Acceleration driver reset completed\n");
-	dev_info(&pdev->dev, "Device is up and running\n");
+	pci_info(pdev, "Acceleration driver reset completed\n");
+	pci_info(pdev, "Device is up and running\n");
 }
 
 static void adf_reset_prepare(struct pci_dev *pdev)
diff --git a/drivers/crypto/intel/qat/qat_common/adf_sriov.c b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
index f2011300a929..f45ca2eecc00 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_sriov.c
@@ -240,7 +240,7 @@ void adf_reenable_sriov(struct adf_accel_dev *accel_dev)
 	if (adf_add_sriov_configuration(accel_dev))
 		return;
 
-	dev_dbg(&pdev->dev, "Re-enabling SRIOV\n");
+	pci_dbg(pdev, "Re-enabling SRIOV\n");
 	adf_enable_sriov(accel_dev);
 }
 
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
index 97ad53eef38f..571f302edea3 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
@@ -162,14 +162,14 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		bar->size = pci_resource_len(pdev, bar_nr);
 		bar->virt_addr = pci_iomap(accel_pci_dev->pci_dev, bar_nr, 0);
 		if (!bar->virt_addr) {
-			dev_err(&pdev->dev, "Failed to map BAR %d\n", bar_nr);
+			pci_err(pdev, "Failed to map BAR %d\n", bar_nr);
 			ret = -EFAULT;
 			goto out_err_free_reg;
 		}
 	}
 
 	if (pci_save_state(pdev)) {
-		dev_err(&pdev->dev, "Failed to save pci state\n");
+		pci_err(pdev, "Failed to save pci state\n");
 		ret = -ENOMEM;
 		goto out_err_free_reg;
 	}
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
index a5edda8bad32..481551a08708 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
@@ -158,7 +158,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		bar->size = pci_resource_len(pdev, bar_nr);
 		bar->virt_addr = pci_iomap(accel_pci_dev->pci_dev, bar_nr, 0);
 		if (!bar->virt_addr) {
-			dev_err(&pdev->dev, "Failed to map BAR %d\n", bar_nr);
+			pci_err(pdev, "Failed to map BAR %d\n", bar_nr);
 			ret = -EFAULT;
 			goto out_err_free_reg;
 		}
-- 
2.50.1

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

