Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50F53C4320E
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Sep 2021 17:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 396E2610A2
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Sep 2021 17:50:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346695AbhIARv3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Sep 2021 13:51:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:16284 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347521AbhIARvE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Sep 2021 13:51:04 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10094"; a="215694370"
X-IronPort-AV: E=Sophos;i="5.84,370,1620716400"; 
   d="scan'208";a="215694370"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2021 10:49:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,370,1620716400"; 
   d="scan'208";a="499022493"
Received: from silpixa00400294.ir.intel.com ([10.237.222.100])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2021 10:49:51 -0700
From:   Wojciech Ziemba <wojciech.ziemba@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        qat-linux@intel.com, Maksim Lukoshkov <maksim.lukoshkov@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 3/4] crypto: qat - free irqs only if allocated
Date:   Wed,  1 Sep 2021 18:36:07 +0100
Message-Id: <20210901173608.16777-4-wojciech.ziemba@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210901173608.16777-1-wojciech.ziemba@intel.com>
References: <20210901173608.16777-1-wojciech.ziemba@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Maksim Lukoshkov <maksim.lukoshkov@intel.com>

Change the irq allocation logic so that it is possible to free only the
allocated irqs in case of error.
A new flag is introduced for every PF/VF interrupt. This flag is set to
"true" only when the interrupt is requested.
During clean up, devm_free_irq() is only called if this flag is set.

Signed-off-by: Maksim Lukoshkov <maksim.lukoshkov@intel.com>
Co-developed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Signed-off-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_devices.h | 10 +++-
 drivers/crypto/qat/qat_common/adf_isr.c       | 50 ++++++++-----------
 drivers/crypto/qat/qat_common/adf_vf_isr.c    | 12 ++---
 3 files changed, 35 insertions(+), 37 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 87de40d6c9a5..e391ca0662bc 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -44,8 +44,13 @@ struct adf_bar {
 	resource_size_t size;
 } __packed;
 
+struct adf_irq {
+	bool enabled;
+	char name[ADF_MAX_MSIX_VECTOR_NAME];
+};
+
 struct adf_accel_msix {
-	char **names;
+	struct adf_irq *irqs;
 	u32 num_entries;
 } __packed;
 
@@ -250,7 +255,8 @@ struct adf_accel_dev {
 			struct adf_accel_vf_info *vf_info;
 		} pf;
 		struct {
-			char *irq_name;
+			bool irq_enabled;
+			char irq_name[ADF_MAX_MSIX_VECTOR_NAME];
 			struct tasklet_struct pf2vf_bh_tasklet;
 			struct mutex vf2pf_lock; /* protect CSR access */
 			struct completion iov_msg_completion;
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index 26b546d3f821..861a9368b9db 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -130,6 +130,7 @@ static int adf_request_irqs(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_irq *irqs = pci_dev_info->msix_entries.irqs;
 	struct adf_etr_data *etr_data = accel_dev->transport;
 	int clust_irq = hw_data->num_banks;
 	int ret, irq, i = 0;
@@ -141,7 +142,7 @@ static int adf_request_irqs(struct adf_accel_dev *accel_dev)
 			struct adf_etr_bank_data *bank = &etr_data->banks[i];
 			unsigned int cpu, cpus = num_online_cpus();
 
-			name = *(pci_dev_info->msix_entries.names + i);
+			name = irqs[i].name;
 			snprintf(name, ADF_MAX_MSIX_VECTOR_NAME,
 				 "qat%d-bundle%d", accel_dev->accel_id, i);
 			irq = pci_irq_vector(pci_dev_info->pci_dev, i);
@@ -163,11 +164,12 @@ static int adf_request_irqs(struct adf_accel_dev *accel_dev)
 			cpu = ((accel_dev->accel_id * hw_data->num_banks) +
 			       i) % cpus;
 			irq_set_affinity_hint(irq, get_cpu_mask(cpu));
+			irqs[i].enabled = true;
 		}
 	}
 
 	/* Request msix irq for AE */
-	name = *(pci_dev_info->msix_entries.names + i);
+	name = irqs[i].name;
 	snprintf(name, ADF_MAX_MSIX_VECTOR_NAME,
 		 "qat%d-ae-cluster", accel_dev->accel_id);
 	irq = pci_irq_vector(pci_dev_info->pci_dev, clust_irq);
@@ -183,6 +185,7 @@ static int adf_request_irqs(struct adf_accel_dev *accel_dev)
 			"Failed to allocate IRQ %d for %s\n", irq, name);
 		return ret;
 	}
+	irqs[i].enabled = true;
 	return ret;
 }
 
@@ -190,60 +193,51 @@ static void adf_free_irqs(struct adf_accel_dev *accel_dev)
 {
 	struct adf_accel_pci *pci_dev_info = &accel_dev->accel_pci_dev;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_irq *irqs = pci_dev_info->msix_entries.irqs;
 	struct adf_etr_data *etr_data = accel_dev->transport;
 	int clust_irq = hw_data->num_banks;
 	int irq, i = 0;
 
 	if (pci_dev_info->msix_entries.num_entries > 1) {
 		for (i = 0; i < hw_data->num_banks; i++) {
-			irq = pci_irq_vector(pci_dev_info->pci_dev, i);
-			irq_set_affinity_hint(irq, NULL);
-			free_irq(irq, &etr_data->banks[i]);
+			if (irqs[i].enabled) {
+				irq = pci_irq_vector(pci_dev_info->pci_dev, i);
+				irq_set_affinity_hint(irq, NULL);
+				free_irq(irq, &etr_data->banks[i]);
+			}
 		}
 	}
 
-	irq = pci_irq_vector(pci_dev_info->pci_dev, clust_irq);
-	free_irq(irq, accel_dev);
+	if (irqs[i].enabled) {
+		irq = pci_irq_vector(pci_dev_info->pci_dev, clust_irq);
+		free_irq(irq, accel_dev);
+	}
 }
 
 static int adf_isr_alloc_msix_vectors_data(struct adf_accel_dev *accel_dev)
 {
-	int i;
-	char **names;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	u32 msix_num_entries = 1;
+	struct adf_irq *irqs;
 
 	/* If SR-IOV is disabled (vf_info is NULL), add entries for each bank */
 	if (!accel_dev->pf.vf_info)
 		msix_num_entries += hw_data->num_banks;
 
-	names = kcalloc(msix_num_entries, sizeof(char *), GFP_KERNEL);
-	if (!names)
+	irqs = kzalloc_node(msix_num_entries * sizeof(*irqs),
+			    GFP_KERNEL, dev_to_node(&GET_DEV(accel_dev)));
+	if (!irqs)
 		return -ENOMEM;
 
-	for (i = 0; i < msix_num_entries; i++) {
-		*(names + i) = kzalloc(ADF_MAX_MSIX_VECTOR_NAME, GFP_KERNEL);
-		if (!(*(names + i)))
-			goto err;
-	}
 	accel_dev->accel_pci_dev.msix_entries.num_entries = msix_num_entries;
-	accel_dev->accel_pci_dev.msix_entries.names = names;
+	accel_dev->accel_pci_dev.msix_entries.irqs = irqs;
 	return 0;
-err:
-	for (i = 0; i < msix_num_entries; i++)
-		kfree(*(names + i));
-	kfree(names);
-	return -ENOMEM;
 }
 
 static void adf_isr_free_msix_vectors_data(struct adf_accel_dev *accel_dev)
 {
-	char **names = accel_dev->accel_pci_dev.msix_entries.names;
-	int i;
-
-	for (i = 0; i < accel_dev->accel_pci_dev.msix_entries.num_entries; i++)
-		kfree(*(names + i));
-	kfree(names);
+	kfree(accel_dev->accel_pci_dev.msix_entries.irqs);
+	accel_dev->accel_pci_dev.msix_entries.irqs = NULL;
 }
 
 static int adf_setup_bh(struct adf_accel_dev *accel_dev)
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index 695c5050b6f3..07f81682c19b 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -61,10 +61,6 @@ static int adf_enable_msi(struct adf_accel_dev *accel_dev)
 		return stat;
 	}
 
-	accel_dev->vf.irq_name = kzalloc(ADF_MAX_MSIX_VECTOR_NAME, GFP_KERNEL);
-	if (!accel_dev->vf.irq_name)
-		return -ENOMEM;
-
 	return 0;
 }
 
@@ -72,7 +68,6 @@ static void adf_disable_msi(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
 
-	kfree(accel_dev->vf.irq_name);
 	pci_free_irq_vectors(pdev);
 }
 
@@ -240,6 +235,7 @@ static int adf_request_msi_irq(struct adf_accel_dev *accel_dev)
 	}
 	cpu = accel_dev->accel_id % num_online_cpus();
 	irq_set_affinity_hint(pdev->irq, get_cpu_mask(cpu));
+	accel_dev->vf.irq_enabled = true;
 
 	return ret;
 }
@@ -271,8 +267,10 @@ void adf_vf_isr_resource_free(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
 
-	irq_set_affinity_hint(pdev->irq, NULL);
-	free_irq(pdev->irq, (void *)accel_dev);
+	if (accel_dev->vf.irq_enabled) {
+		irq_set_affinity_hint(pdev->irq, NULL);
+		free_irq(pdev->irq, accel_dev);
+	}
 	adf_cleanup_bh(accel_dev);
 	adf_cleanup_pf2vf_bh(accel_dev);
 	adf_disable_msi(accel_dev);
-- 
2.29.2

--------------------------------------------------------------
Intel Research and Development Ireland Limited
Registered in Ireland
Registered Office: Collinstown Industrial Park, Leixlip, County Kildare
Registered Number: 308263


This e-mail and any attachments may contain confidential material for the sole
use of the intended recipient(s). Any review or distribution by others is
strictly prohibited. If you are not the intended recipient, please contact the
sender and delete all copies.

