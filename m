Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E64C7EE23
	for <linux-crypto@archiver.kernel.org>; Fri, 26 May 2023 16:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236801AbjEZQtP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 May 2023 12:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjEZQtO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 May 2023 12:49:14 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B49D3
        for <linux-crypto@vger.kernel.org>; Fri, 26 May 2023 09:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685119751; x=1716655751;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TyYZh5lPcUJrd3SiZYTdrj3j5wGezrSV0KNuDNSB4X8=;
  b=T56vji97+zfS1VwZKdwzk16LCBmlgXMB6V7lsC19RYID5wR6u6WGI+Y8
   Kl9tnymfYUfcYiPfhXwa7Zb1hJ7BlDWWDoprmV5aU7XJO8vd5s8EQVWSa
   +SD0AYPcDkpot+yq7Jrg+7NhOS4DjW17inyTK7TujMDlgwxGE8kLLAfmy
   eTdnm3pVc5u9xJBiTkQnStIZ3av1aklfgftelBDvTcllmDTY6GkZzw5hb
   ZOdTGmFf2MS6a7S7RyViPjwaPwR0LVNRgadh3tITjxQ2U4xd6qLcVwc8n
   0nAcj9yocZEm6B7dkbsvrAZ8ihg4zevu3CS/kjVkoH+h0RSIIwgzH8wfj
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="356629266"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="356629266"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2023 09:49:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10722"; a="1035430122"
X-IronPort-AV: E=Sophos;i="6.00,194,1681196400"; 
   d="scan'208";a="1035430122"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.175])
  by fmsmga005.fm.intel.com with ESMTP; 26 May 2023 09:49:08 -0700
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        Damian Muszynski <damian.muszynski@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH] crypto: qat - move dbgfs init to separate file
Date:   Fri, 26 May 2023 17:48:59 +0100
Message-Id: <20230526164859.49095-1-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Damian Muszynski <damian.muszynski@intel.com>

Move initialization of debugfs entries to a separate file.
This simplifies the exclusion of the debugfs logic in the QAT driver
when the kernel is built with CONFIG_DEBUG_FS=n.
In addition, it will allow to consolidate the addition of debugfs
entries to a single location in the code.

This implementation adds infrastructure to create (and remove) debugfs
entries at two different stages. The first, done when a device is probed,
allows to keep debugfs entries persistent between a transition in device
state (up to down or vice versa). The second, done after the initialization
phase, allows to have debugfs entries that are accessible only when
the device is up.

In addition, move the creation of debugfs entries for configuration
to the newly created function adf_dbgfs_init() and replace symbolic
permissions with octal permissions when creating the debugfs files.
This is to resolve the following warning reported by checkpatch:

  WARNING: Symbolic permissions 'S_IRUSR' are not preferred. Consider using octal permissions '0400'.

Signed-off-by: Damian Muszynski <damian.muszynski@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/intel/qat/qat_4xxx/adf_drv.c   | 12 ++--
 drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c  | 12 ++--
 .../crypto/intel/qat/qat_c3xxxvf/adf_drv.c    | 12 ++--
 drivers/crypto/intel/qat/qat_c62x/adf_drv.c   | 12 ++--
 drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c | 12 ++--
 drivers/crypto/intel/qat/qat_common/Makefile  |  4 +-
 drivers/crypto/intel/qat/qat_common/adf_cfg.c | 24 +++++--
 drivers/crypto/intel/qat/qat_common/adf_cfg.h |  2 +
 .../crypto/intel/qat/qat_common/adf_dbgfs.c   | 69 +++++++++++++++++++
 .../crypto/intel/qat/qat_common/adf_dbgfs.h   | 29 ++++++++
 .../crypto/intel/qat/qat_common/adf_init.c    |  6 ++
 .../crypto/intel/qat/qat_dh895xcc/adf_drv.c   | 12 ++--
 .../crypto/intel/qat/qat_dh895xccvf/adf_drv.c | 12 ++--
 13 files changed, 156 insertions(+), 62 deletions(-)
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
 create mode 100644 drivers/crypto/intel/qat/qat_common/adf_dbgfs.h

diff --git a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
index ceb87327a5fe..3ecc19087780 100644
--- a/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_4xxx/adf_drv.c
@@ -7,6 +7,7 @@
 #include <adf_accel_devices.h>
 #include <adf_cfg.h>
 #include <adf_common_drv.h>
+#include <adf_dbgfs.h>
 
 #include "adf_4xxx_hw_data.h"
 #include "qat_compression.h"
@@ -37,8 +38,8 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 		adf_clean_hw_data_4xxx(accel_dev->hw_device);
 		accel_dev->hw_device = NULL;
 	}
+	adf_dbgfs_exit(accel_dev);
 	adf_cfg_dev_remove(accel_dev);
-	debugfs_remove(accel_dev->debugfs_dir);
 	adf_devmgr_rm_dev(accel_dev, NULL);
 }
 
@@ -289,7 +290,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct adf_accel_dev *accel_dev;
 	struct adf_accel_pci *accel_pci_dev;
 	struct adf_hw_device_data *hw_data;
-	char name[ADF_DEVICE_NAME_LENGTH];
 	unsigned int i, bar_nr;
 	unsigned long bar_mask;
 	struct adf_bar *bar;
@@ -348,12 +348,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err;
 	}
 
-	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
-		 hw_data->dev_class->name, pci_name(pdev));
-
-	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
 	if (ret)
@@ -410,6 +404,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err;
 	}
 
+	adf_dbgfs_init(accel_dev);
+
 	ret = adf_dev_up(accel_dev, true);
 	if (ret)
 		goto out_err_dev_stop;
diff --git a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
index bb4dca735ab5..468c9102093f 100644
--- a/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxx/adf_drv.c
@@ -16,6 +16,7 @@
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
 #include <adf_cfg.h>
+#include <adf_dbgfs.h>
 #include "adf_c3xxx_hw_data.h"
 
 static const struct pci_device_id adf_pci_tbl[] = {
@@ -65,8 +66,8 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 		kfree(accel_dev->hw_device);
 		accel_dev->hw_device = NULL;
 	}
+	adf_dbgfs_exit(accel_dev);
 	adf_cfg_dev_remove(accel_dev);
-	debugfs_remove(accel_dev->debugfs_dir);
 	adf_devmgr_rm_dev(accel_dev, NULL);
 }
 
@@ -75,7 +76,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct adf_accel_dev *accel_dev;
 	struct adf_accel_pci *accel_pci_dev;
 	struct adf_hw_device_data *hw_data;
-	char name[ADF_DEVICE_NAME_LENGTH];
 	unsigned int i, bar_nr;
 	unsigned long bar_mask;
 	int ret;
@@ -142,12 +142,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err;
 	}
 
-	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
-		 hw_data->dev_class->name, pci_name(pdev));
-
-	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
 	if (ret)
@@ -199,6 +193,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_free_reg;
 	}
 
+	adf_dbgfs_init(accel_dev);
+
 	ret = adf_dev_up(accel_dev, true);
 	if (ret)
 		goto out_err_dev_stop;
diff --git a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
index e8cc10f64134..d5a0ecca9d0b 100644
--- a/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c3xxxvf/adf_drv.c
@@ -16,6 +16,7 @@
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
 #include <adf_cfg.h>
+#include <adf_dbgfs.h>
 #include "adf_c3xxxvf_hw_data.h"
 
 static const struct pci_device_id adf_pci_tbl[] = {
@@ -64,8 +65,8 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 		kfree(accel_dev->hw_device);
 		accel_dev->hw_device = NULL;
 	}
+	adf_dbgfs_exit(accel_dev);
 	adf_cfg_dev_remove(accel_dev);
-	debugfs_remove(accel_dev->debugfs_dir);
 	pf = adf_devmgr_pci_to_accel_dev(accel_pci_dev->pci_dev->physfn);
 	adf_devmgr_rm_dev(accel_dev, pf);
 }
@@ -76,7 +77,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct adf_accel_dev *pf;
 	struct adf_accel_pci *accel_pci_dev;
 	struct adf_hw_device_data *hw_data;
-	char name[ADF_DEVICE_NAME_LENGTH];
 	unsigned int i, bar_nr;
 	unsigned long bar_mask;
 	int ret;
@@ -123,12 +123,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw_data->ae_mask = hw_data->get_ae_mask(hw_data);
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 
-	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
-		 hw_data->dev_class->name, pci_name(pdev));
-
-	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
 	if (ret)
@@ -173,6 +167,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.msg_received);
 
+	adf_dbgfs_init(accel_dev);
+
 	ret = adf_dev_up(accel_dev, false);
 	if (ret)
 		goto out_err_dev_stop;
diff --git a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
index ca18ae14c099..0186921be936 100644
--- a/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62x/adf_drv.c
@@ -16,6 +16,7 @@
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
 #include <adf_cfg.h>
+#include <adf_dbgfs.h>
 #include "adf_c62x_hw_data.h"
 
 static const struct pci_device_id adf_pci_tbl[] = {
@@ -65,8 +66,8 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 		kfree(accel_dev->hw_device);
 		accel_dev->hw_device = NULL;
 	}
+	adf_dbgfs_exit(accel_dev);
 	adf_cfg_dev_remove(accel_dev);
-	debugfs_remove(accel_dev->debugfs_dir);
 	adf_devmgr_rm_dev(accel_dev, NULL);
 }
 
@@ -75,7 +76,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct adf_accel_dev *accel_dev;
 	struct adf_accel_pci *accel_pci_dev;
 	struct adf_hw_device_data *hw_data;
-	char name[ADF_DEVICE_NAME_LENGTH];
 	unsigned int i, bar_nr;
 	unsigned long bar_mask;
 	int ret;
@@ -142,12 +142,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err;
 	}
 
-	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
-		 hw_data->dev_class->name, pci_name(pdev));
-
-	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
 	if (ret)
@@ -199,6 +193,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_free_reg;
 	}
 
+	adf_dbgfs_init(accel_dev);
+
 	ret = adf_dev_up(accel_dev, true);
 	if (ret)
 		goto out_err_dev_stop;
diff --git a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
index 37566309df94..c9ae6c0d0dca 100644
--- a/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_c62xvf/adf_drv.c
@@ -16,6 +16,7 @@
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
 #include <adf_cfg.h>
+#include <adf_dbgfs.h>
 #include "adf_c62xvf_hw_data.h"
 
 static const struct pci_device_id adf_pci_tbl[] = {
@@ -64,8 +65,8 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 		kfree(accel_dev->hw_device);
 		accel_dev->hw_device = NULL;
 	}
+	adf_dbgfs_exit(accel_dev);
 	adf_cfg_dev_remove(accel_dev);
-	debugfs_remove(accel_dev->debugfs_dir);
 	pf = adf_devmgr_pci_to_accel_dev(accel_pci_dev->pci_dev->physfn);
 	adf_devmgr_rm_dev(accel_dev, pf);
 }
@@ -76,7 +77,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct adf_accel_dev *pf;
 	struct adf_accel_pci *accel_pci_dev;
 	struct adf_hw_device_data *hw_data;
-	char name[ADF_DEVICE_NAME_LENGTH];
 	unsigned int i, bar_nr;
 	unsigned long bar_mask;
 	int ret;
@@ -123,12 +123,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw_data->ae_mask = hw_data->get_ae_mask(hw_data);
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 
-	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
-		 hw_data->dev_class->name, pci_name(pdev));
-
-	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
 	if (ret)
@@ -173,6 +167,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.msg_received);
 
+	adf_dbgfs_init(accel_dev);
+
 	ret = adf_dev_up(accel_dev, false);
 	if (ret)
 		goto out_err_dev_stop;
diff --git a/drivers/crypto/intel/qat/qat_common/Makefile b/drivers/crypto/intel/qat/qat_common/Makefile
index 1fb8d50f509f..38de3aba6e8c 100644
--- a/drivers/crypto/intel/qat/qat_common/Makefile
+++ b/drivers/crypto/intel/qat/qat_common/Makefile
@@ -27,7 +27,9 @@ intel_qat-objs := adf_cfg.o \
 	qat_hal.o \
 	qat_bl.o
 
-intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o
+intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o \
+				adf_dbgfs.o
+
 intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_vf_isr.o adf_pfvf_utils.o \
 			       adf_pfvf_pf_msg.o adf_pfvf_pf_proto.o \
 			       adf_pfvf_vf_msg.o adf_pfvf_vf_proto.o \
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.c b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
index 1931e5b37f2b..8836f015c39c 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.c
@@ -74,15 +74,30 @@ int adf_cfg_dev_add(struct adf_accel_dev *accel_dev)
 	INIT_LIST_HEAD(&dev_cfg_data->sec_list);
 	init_rwsem(&dev_cfg_data->lock);
 	accel_dev->cfg = dev_cfg_data;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_cfg_dev_add);
 
-	/* accel_dev->debugfs_dir should always be non-NULL here */
-	dev_cfg_data->debug = debugfs_create_file("dev_cfg", S_IRUSR,
+void adf_cfg_dev_dbgfs_add(struct adf_accel_dev *accel_dev)
+{
+	struct adf_cfg_device_data *dev_cfg_data = accel_dev->cfg;
+
+	dev_cfg_data->debug = debugfs_create_file("dev_cfg", 0400,
 						  accel_dev->debugfs_dir,
 						  dev_cfg_data,
 						  &qat_dev_cfg_fops);
-	return 0;
 }
-EXPORT_SYMBOL_GPL(adf_cfg_dev_add);
+
+void adf_cfg_dev_dbgfs_rm(struct adf_accel_dev *accel_dev)
+{
+	struct adf_cfg_device_data *dev_cfg_data = accel_dev->cfg;
+
+	if (!dev_cfg_data)
+		return;
+
+	debugfs_remove(dev_cfg_data->debug);
+	dev_cfg_data->debug = NULL;
+}
 
 static void adf_cfg_section_del_all(struct list_head *head);
 
@@ -116,7 +131,6 @@ void adf_cfg_dev_remove(struct adf_accel_dev *accel_dev)
 	down_write(&dev_cfg_data->lock);
 	adf_cfg_section_del_all(&dev_cfg_data->sec_list);
 	up_write(&dev_cfg_data->lock);
-	debugfs_remove(dev_cfg_data->debug);
 	kfree(dev_cfg_data);
 	accel_dev->cfg = NULL;
 }
diff --git a/drivers/crypto/intel/qat/qat_common/adf_cfg.h b/drivers/crypto/intel/qat/qat_common/adf_cfg.h
index 376cde61a60e..c0c9052b2213 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_cfg.h
+++ b/drivers/crypto/intel/qat/qat_common/adf_cfg.h
@@ -31,6 +31,8 @@ struct adf_cfg_device_data {
 
 int adf_cfg_dev_add(struct adf_accel_dev *accel_dev);
 void adf_cfg_dev_remove(struct adf_accel_dev *accel_dev);
+void adf_cfg_dev_dbgfs_add(struct adf_accel_dev *accel_dev);
+void adf_cfg_dev_dbgfs_rm(struct adf_accel_dev *accel_dev);
 int adf_cfg_section_add(struct adf_accel_dev *accel_dev, const char *name);
 void adf_cfg_del_all(struct adf_accel_dev *accel_dev);
 int adf_cfg_add_key_value_param(struct adf_accel_dev *accel_dev,
diff --git a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
new file mode 100644
index 000000000000..d0a2f892e6eb
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.c
@@ -0,0 +1,69 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Intel Corporation */
+
+#include <linux/debugfs.h>
+#include "adf_accel_devices.h"
+#include "adf_cfg.h"
+#include "adf_common_drv.h"
+#include "adf_dbgfs.h"
+
+/**
+ * adf_dbgfs_init() - add persistent debugfs entries
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * This function creates debugfs entries that are persistent through a device
+ * state change (from up to down or vice versa).
+ */
+void adf_dbgfs_init(struct adf_accel_dev *accel_dev)
+{
+	char name[ADF_DEVICE_NAME_LENGTH];
+	void *ret;
+
+	/* Create dev top level debugfs entry */
+	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
+		 accel_dev->hw_device->dev_class->name,
+		 pci_name(accel_dev->accel_pci_dev.pci_dev));
+
+	ret = debugfs_create_dir(name, NULL);
+	if (IS_ERR_OR_NULL(ret))
+		return;
+
+	accel_dev->debugfs_dir = ret;
+
+	adf_cfg_dev_dbgfs_add(accel_dev);
+}
+EXPORT_SYMBOL_GPL(adf_dbgfs_init);
+
+/**
+ * adf_dbgfs_exit() - remove persistent debugfs entries
+ * @accel_dev:  Pointer to acceleration device.
+ */
+void adf_dbgfs_exit(struct adf_accel_dev *accel_dev)
+{
+	adf_cfg_dev_dbgfs_rm(accel_dev);
+	debugfs_remove(accel_dev->debugfs_dir);
+}
+EXPORT_SYMBOL_GPL(adf_dbgfs_exit);
+
+/**
+ * adf_dbgfs_add() - add non-persistent debugfs entries
+ * @accel_dev:  Pointer to acceleration device.
+ *
+ * This function creates debugfs entries that are not persistent through
+ * a device state change (from up to down or vice versa).
+ */
+void adf_dbgfs_add(struct adf_accel_dev *accel_dev)
+{
+	if (!accel_dev->debugfs_dir)
+		return;
+}
+
+/**
+ * adf_dbgfs_rm() - remove non-persistent debugfs entries
+ * @accel_dev:  Pointer to acceleration device.
+ */
+void adf_dbgfs_rm(struct adf_accel_dev *accel_dev)
+{
+	if (!accel_dev->debugfs_dir)
+		return;
+}
diff --git a/drivers/crypto/intel/qat/qat_common/adf_dbgfs.h b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.h
new file mode 100644
index 000000000000..1d64ad1a0037
--- /dev/null
+++ b/drivers/crypto/intel/qat/qat_common/adf_dbgfs.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Intel Corporation */
+
+#ifndef ADF_DBGFS_H
+#define ADF_DBGFS_H
+
+#ifdef CONFIG_DEBUG_FS
+void adf_dbgfs_init(struct adf_accel_dev *accel_dev);
+void adf_dbgfs_add(struct adf_accel_dev *accel_dev);
+void adf_dbgfs_rm(struct adf_accel_dev *accel_dev);
+void adf_dbgfs_exit(struct adf_accel_dev *accel_dev);
+#else
+static inline void adf_dbgfs_init(struct adf_accel_dev *accel_dev)
+{
+}
+
+static inline void adf_dbgfs_add(struct adf_accel_dev *accel_dev)
+{
+}
+
+static inline void adf_dbgfs_rm(struct adf_accel_dev *accel_dev)
+{
+}
+
+static inline void adf_dbgfs_cleanup(struct adf_accel_dev *accel_dev)
+{
+}
+#endif
+#endif
diff --git a/drivers/crypto/intel/qat/qat_common/adf_init.c b/drivers/crypto/intel/qat/qat_common/adf_init.c
index 0985f64ab11a..826179c98524 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_init.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_init.c
@@ -7,6 +7,7 @@
 #include "adf_accel_devices.h"
 #include "adf_cfg.h"
 #include "adf_common_drv.h"
+#include "adf_dbgfs.h"
 
 static LIST_HEAD(service_table);
 static DEFINE_MUTEX(service_lock);
@@ -216,6 +217,9 @@ static int adf_dev_start(struct adf_accel_dev *accel_dev)
 		clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 		return -EFAULT;
 	}
+
+	adf_dbgfs_add(accel_dev);
+
 	return 0;
 }
 
@@ -240,6 +244,8 @@ static void adf_dev_stop(struct adf_accel_dev *accel_dev)
 	    !test_bit(ADF_STATUS_STARTING, &accel_dev->status))
 		return;
 
+	adf_dbgfs_rm(accel_dev);
+
 	clear_bit(ADF_STATUS_STARTING, &accel_dev->status);
 	clear_bit(ADF_STATUS_STARTED, &accel_dev->status);
 
diff --git a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
index e18860ab5c8e..1e748e8ce12d 100644
--- a/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xcc/adf_drv.c
@@ -16,6 +16,7 @@
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
 #include <adf_cfg.h>
+#include <adf_dbgfs.h>
 #include "adf_dh895xcc_hw_data.h"
 
 static const struct pci_device_id adf_pci_tbl[] = {
@@ -65,8 +66,8 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 		kfree(accel_dev->hw_device);
 		accel_dev->hw_device = NULL;
 	}
+	adf_dbgfs_exit(accel_dev);
 	adf_cfg_dev_remove(accel_dev);
-	debugfs_remove(accel_dev->debugfs_dir);
 	adf_devmgr_rm_dev(accel_dev, NULL);
 }
 
@@ -75,7 +76,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct adf_accel_dev *accel_dev;
 	struct adf_accel_pci *accel_pci_dev;
 	struct adf_hw_device_data *hw_data;
-	char name[ADF_DEVICE_NAME_LENGTH];
 	unsigned int i, bar_nr;
 	unsigned long bar_mask;
 	int ret;
@@ -140,12 +140,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err;
 	}
 
-	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
-		 hw_data->dev_class->name, pci_name(pdev));
-
-	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
 	if (ret)
@@ -199,6 +193,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_err_free_reg;
 	}
 
+	adf_dbgfs_init(accel_dev);
+
 	ret = adf_dev_up(accel_dev, true);
 	if (ret)
 		goto out_err_dev_stop;
diff --git a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
index 96854a1cd87e..fefb85ceaeb9 100644
--- a/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
+++ b/drivers/crypto/intel/qat/qat_dh895xccvf/adf_drv.c
@@ -16,6 +16,7 @@
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
 #include <adf_cfg.h>
+#include <adf_dbgfs.h>
 #include "adf_dh895xccvf_hw_data.h"
 
 static const struct pci_device_id adf_pci_tbl[] = {
@@ -64,8 +65,8 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 		kfree(accel_dev->hw_device);
 		accel_dev->hw_device = NULL;
 	}
+	adf_dbgfs_exit(accel_dev);
 	adf_cfg_dev_remove(accel_dev);
-	debugfs_remove(accel_dev->debugfs_dir);
 	pf = adf_devmgr_pci_to_accel_dev(accel_pci_dev->pci_dev->physfn);
 	adf_devmgr_rm_dev(accel_dev, pf);
 }
@@ -76,7 +77,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	struct adf_accel_dev *pf;
 	struct adf_accel_pci *accel_pci_dev;
 	struct adf_hw_device_data *hw_data;
-	char name[ADF_DEVICE_NAME_LENGTH];
 	unsigned int i, bar_nr;
 	unsigned long bar_mask;
 	int ret;
@@ -123,12 +123,6 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw_data->ae_mask = hw_data->get_ae_mask(hw_data);
 	accel_pci_dev->sku = hw_data->get_sku(hw_data);
 
-	/* Create dev top level debugfs entry */
-	snprintf(name, sizeof(name), "%s%s_%s", ADF_DEVICE_NAME_PREFIX,
-		 hw_data->dev_class->name, pci_name(pdev));
-
-	accel_dev->debugfs_dir = debugfs_create_dir(name, NULL);
-
 	/* Create device configuration table */
 	ret = adf_cfg_dev_add(accel_dev);
 	if (ret)
@@ -173,6 +167,8 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Completion for VF2PF request/response message exchange */
 	init_completion(&accel_dev->vf.msg_received);
 
+	adf_dbgfs_init(accel_dev);
+
 	ret = adf_dev_up(accel_dev, false);
 	if (ret)
 		goto out_err_dev_stop;
-- 
2.40.1

