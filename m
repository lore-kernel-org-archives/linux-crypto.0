Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723EFC4332F
	for <linux-crypto@archiver.kernel.org>; Thu,  7 Apr 2022 16:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345842AbiDGQxc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 7 Apr 2022 12:53:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345853AbiDGQx0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 7 Apr 2022 12:53:26 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925171C133
        for <linux-crypto@vger.kernel.org>; Thu,  7 Apr 2022 09:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649350285; x=1680886285;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/9/qcng75Ezz2SGAPjfP4k11I0BtkR+oLcgbI4DhnGc=;
  b=cnJ7swjGOvg3Fwlt/E5DmFo2/PT7cEIfcZeV2saxZ6SQqWP/kKokV0Ih
   59XohZQvFSu9fgnEEiI9h4eEzhoFzTBRPYyTBh3A9r9oGNv0kqTc2u1Hd
   BfwDHg3V+pWczMtTOaQ3VaflLfyz3idUcIaQplecJCULpdyKzYDQtMTbV
   KiYBcRaGMGklTIeRSohveRRP8zUydn4Y19SlZq7DERi6GWZxoNoCwvi5q
   14sB0HnvTGyG7/PEbkSbEaeFbQJPt0xmLgRmANv2QphI6dwTWEfVRKsNt
   I6zX1vAqsEqAuxYFRfEX23L1u0FDKqxcA12vtRgHE6NOapILU1Z7WsN7n
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10310"; a="241312104"
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="241312104"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2022 09:51:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,242,1643702400"; 
   d="scan'208";a="652898396"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by fmsmga002.fm.intel.com with ESMTP; 07 Apr 2022 09:51:23 -0700
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com,
        Marco Chiappero <marco.chiappero@intel.com>
Subject: [PATCH v2 14/16] crypto: qat - replace disable_vf2pf_interrupts()
Date:   Thu,  7 Apr 2022 17:54:53 +0100
Message-Id: <20220407165455.256777-15-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220407165455.256777-1-marco.chiappero@intel.com>
References: <20220407165455.256777-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As a consequence of the refactored VF2PF interrupt handling logic, a
function that disables specific VF2PF interrupts is no longer needed.
Instead, a simpler function that disables all the interrupts, also
hiding the device specific amount of VFs to be disabled from the
pfvf_ops users, would be sufficient.

This patch replaces disable_vf2pf_interrupts() with the new
disable_all_vf2pf_interrupts(), which doesn't need any argument and
disables all the VF2PF interrupts.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_common/adf_accel_devices.h |  2 +-
 .../crypto/qat/qat_common/adf_common_drv.h    |  3 +--
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c | 13 ++++-------
 drivers/crypto/qat/qat_common/adf_gen4_pfvf.c | 10 +++-----
 drivers/crypto/qat/qat_common/adf_isr.c       |  4 ++--
 drivers/crypto/qat/qat_common/adf_sriov.c     |  2 +-
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   | 23 ++++++++-----------
 7 files changed, 23 insertions(+), 34 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index dfa7ee41c5e9..e927799a8e6c 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -153,7 +153,7 @@ struct adf_pfvf_ops {
 	u32 (*get_pf2vf_offset)(u32 i);
 	u32 (*get_vf2pf_offset)(u32 i);
 	void (*enable_vf2pf_interrupts)(void __iomem *pmisc_addr, u32 vf_mask);
-	void (*disable_vf2pf_interrupts)(void __iomem *pmisc_addr, u32 vf_mask);
+	void (*disable_all_vf2pf_interrupts)(void __iomem *pmisc_addr);
 	u32 (*disable_pending_vf2pf_interrupts)(void __iomem *pmisc_addr);
 	int (*send_msg)(struct adf_accel_dev *accel_dev, struct pfvf_message msg,
 			u32 pfvf_offset, struct mutex *csr_lock);
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index feecf1035a90..da9d765834f0 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -195,10 +195,9 @@ bool adf_misc_wq_queue_work(struct work_struct *work);
 #if defined(CONFIG_PCI_IOV)
 int adf_sriov_configure(struct pci_dev *pdev, int numvfs);
 void adf_disable_sriov(struct adf_accel_dev *accel_dev);
-void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
-				  u32 vf_mask);
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				 u32 vf_mask);
+void adf_disable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev);
 bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev);
 bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr);
 int adf_pf2vf_handle_pf_restarting(struct adf_accel_dev *accel_dev);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index 8df952df18ef..606409533409 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -62,15 +62,12 @@ static void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr,
 	}
 }
 
-static void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr,
-					      u32 vf_mask)
+static void adf_gen2_disable_all_vf2pf_interrupts(void __iomem *pmisc_addr)
 {
 	/* Disable VF2PF interrupts for VFs 0 through 15 per vf_mask[15:0] */
-	if (vf_mask & ADF_GEN2_VF_MSK) {
-		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
-			  | ADF_GEN2_ERR_MSK_VF2PF(vf_mask);
-		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
-	}
+	u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
+		  | ADF_GEN2_ERR_MSK_VF2PF(ADF_GEN2_VF_MSK);
+	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
 }
 
 static u32 adf_gen2_disable_pending_vf2pf_interrupts(void __iomem *pmisc_addr)
@@ -385,7 +382,7 @@ void adf_gen2_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 	pfvf_ops->get_pf2vf_offset = adf_gen2_pf_get_pfvf_offset;
 	pfvf_ops->get_vf2pf_offset = adf_gen2_pf_get_pfvf_offset;
 	pfvf_ops->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
-	pfvf_ops->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
+	pfvf_ops->disable_all_vf2pf_interrupts = adf_gen2_disable_all_vf2pf_interrupts;
 	pfvf_ops->disable_pending_vf2pf_interrupts = adf_gen2_disable_pending_vf2pf_interrupts;
 	pfvf_ops->send_msg = adf_gen2_pf2vf_send;
 	pfvf_ops->recv_msg = adf_gen2_vf2pf_recv;
diff --git a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
index 4061725b926d..8091fc52e13a 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen4_pfvf.c
@@ -46,13 +46,9 @@ static void adf_gen4_enable_vf2pf_interrupts(void __iomem *pmisc_addr,
 	ADF_CSR_WR(pmisc_addr, ADF_4XXX_VM2PF_MSK, val);
 }
 
-static void adf_gen4_disable_vf2pf_interrupts(void __iomem *pmisc_addr,
-					      u32 vf_mask)
+static void adf_gen4_disable_all_vf2pf_interrupts(void __iomem *pmisc_addr)
 {
-	unsigned int val;
-
-	val = ADF_CSR_RD(pmisc_addr, ADF_4XXX_VM2PF_MSK) | vf_mask;
-	ADF_CSR_WR(pmisc_addr, ADF_4XXX_VM2PF_MSK, val);
+	ADF_CSR_WR(pmisc_addr, ADF_4XXX_VM2PF_MSK, ADF_GEN4_VF_MSK);
 }
 
 static u32 adf_gen4_disable_pending_vf2pf_interrupts(void __iomem *pmisc_addr)
@@ -144,7 +140,7 @@ void adf_gen4_init_pf_pfvf_ops(struct adf_pfvf_ops *pfvf_ops)
 	pfvf_ops->get_pf2vf_offset = adf_gen4_pf_get_pf2vf_offset;
 	pfvf_ops->get_vf2pf_offset = adf_gen4_pf_get_vf2pf_offset;
 	pfvf_ops->enable_vf2pf_interrupts = adf_gen4_enable_vf2pf_interrupts;
-	pfvf_ops->disable_vf2pf_interrupts = adf_gen4_disable_vf2pf_interrupts;
+	pfvf_ops->disable_all_vf2pf_interrupts = adf_gen4_disable_all_vf2pf_interrupts;
 	pfvf_ops->disable_pending_vf2pf_interrupts = adf_gen4_disable_pending_vf2pf_interrupts;
 	pfvf_ops->send_msg = adf_gen4_pfvf_send;
 	pfvf_ops->recv_msg = adf_gen4_pfvf_recv;
diff --git a/drivers/crypto/qat/qat_common/adf_isr.c b/drivers/crypto/qat/qat_common/adf_isr.c
index 23f7fff32c64..ad9e135b8560 100644
--- a/drivers/crypto/qat/qat_common/adf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_isr.c
@@ -66,13 +66,13 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
 
-void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev, u32 vf_mask)
+void adf_disable_all_vf2pf_interrupts(struct adf_accel_dev *accel_dev)
 {
 	void __iomem *pmisc_addr = adf_get_pmisc_base(accel_dev);
 	unsigned long flags;
 
 	spin_lock_irqsave(&accel_dev->pf.vf2pf_ints_lock, flags);
-	GET_PFVF_OPS(accel_dev)->disable_vf2pf_interrupts(pmisc_addr, vf_mask);
+	GET_PFVF_OPS(accel_dev)->disable_all_vf2pf_interrupts(pmisc_addr);
 	spin_unlock_irqrestore(&accel_dev->pf.vf2pf_ints_lock, flags);
 }
 
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 71d75f65b504..d4e7d002a6e4 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -107,7 +107,7 @@ void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 	pci_disable_sriov(accel_to_pci_dev(accel_dev));
 
 	/* Disable VF to PF interrupts */
-	adf_disable_vf2pf_interrupts(accel_dev, GENMASK(31, 0));
+	adf_disable_all_vf2pf_interrupts(accel_dev);
 
 	/* Clear Valid bits in AE Thread to PCIe Function Mapping */
 	if (hw_data->configure_iov_threads)
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 86187671893c..cb3bdd3618fb 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -126,22 +126,19 @@ static void enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
 	}
 }
 
-static void disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask)
+static void disable_all_vf2pf_interrupts(void __iomem *pmisc_addr)
 {
+	u32 val;
+
 	/* Disable VF2PF interrupts for VFs 0 through 15 per vf_mask[15:0] */
-	if (vf_mask & 0xFFFF) {
-		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
-			  | ADF_DH895XCC_ERR_MSK_VF2PF_L(vf_mask);
-		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
-	}
+	val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK3)
+	      | ADF_DH895XCC_ERR_MSK_VF2PF_L(ADF_DH895XCC_VF_MSK);
+	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK3, val);
 
 	/* Disable VF2PF interrupts for VFs 16 through 31 per vf_mask[31:16] */
-	if (vf_mask >> 16) {
-		u32 val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK5)
-			  | ADF_DH895XCC_ERR_MSK_VF2PF_U(vf_mask);
-
-		ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, val);
-	}
+	val = ADF_CSR_RD(pmisc_addr, ADF_GEN2_ERRMSK5)
+	      | ADF_DH895XCC_ERR_MSK_VF2PF_U(ADF_DH895XCC_VF_MSK);
+	ADF_CSR_WR(pmisc_addr, ADF_GEN2_ERRMSK5, val);
 }
 
 static u32 disable_pending_vf2pf_interrupts(void __iomem *pmisc_addr)
@@ -240,7 +237,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	hw_data->pfvf_ops.enable_vf2pf_interrupts = enable_vf2pf_interrupts;
-	hw_data->pfvf_ops.disable_vf2pf_interrupts = disable_vf2pf_interrupts;
+	hw_data->pfvf_ops.disable_all_vf2pf_interrupts = disable_all_vf2pf_interrupts;
 	hw_data->pfvf_ops.disable_pending_vf2pf_interrupts = disable_pending_vf2pf_interrupts;
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
 }
-- 
2.34.1

