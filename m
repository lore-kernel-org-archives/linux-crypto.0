Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54700C433F5
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Dec 2021 09:11:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232596AbhLPJLw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Dec 2021 04:11:52 -0500
Received: from mga12.intel.com ([192.55.52.136]:9697 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232969AbhLPJLk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Dec 2021 04:11:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639645900; x=1671181900;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zcD/EJzDclOazBcN8BMmEiZp4G37t1bk3eGDWBNNGpM=;
  b=cmAcEddezW6O9JTsWagqkoHEar7m4QSl7X4x7t3xtKLcvA2KfeprZY3k
   KA6/sc/aTDPoKnIWLaG+an+MmYHH79GDZ2yRkrzq5FxXLCftVlXgIt2gb
   nvitykUF4pvowya6JBPdFam/qfdUra7jLigs++CQoVGzrwR3np+GLQ82v
   Y8PF9RmWVB/8g52B4gwpQtcRodrTYhDg6hFe/pF0EPsUnGxcYLffrfbEJ
   HnXiN79MkdOfCri4vjiqScOEnRWXeckV8s75hnakE5DHZ+JfRulHf1esN
   IqSbfH1dzLDO9y0xTJ7VJFY09QyC6g9DMiZKvNaC1F7aEwT17jx5iZVxp
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10199"; a="219458456"
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="219458456"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2021 01:11:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,211,1635231600"; 
   d="scan'208";a="465968538"
Received: from silpixa00393544.ir.intel.com ([10.237.213.118])
  by orsmga006.jf.intel.com with ESMTP; 16 Dec 2021 01:11:37 -0800
From:   Marco Chiappero <marco.chiappero@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        giovanni.cabiddu@intel.com, marco.chiappero@intel.com,
        Fiona Trahe <fiona.trahe@intel.com>
Subject: [PATCH 15/24] crypto: qat - store the ring-to-service mapping
Date:   Thu, 16 Dec 2021 09:13:25 +0000
Message-Id: <20211216091334.402420-16-marco.chiappero@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211216091334.402420-1-marco.chiappero@intel.com>
References: <20211216091334.402420-1-marco.chiappero@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This driver relies on either the FW (on the PF) or the PF (on the VF) to
know how crypto services and rings map to one another. Store this
information so that it can be referenced in the future at runtime for
checks or extensions.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Reviewed-by: Fiona Trahe <fiona.trahe@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c      |  1 +
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c    |  1 +
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c    |  1 +
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c      |  1 +
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c  |  1 +
 drivers/crypto/qat/qat_common/adf_accel_devices.h   |  8 ++++++++
 drivers/crypto/qat/qat_common/adf_cfg_common.h      | 13 +++++++++++++
 drivers/crypto/qat/qat_common/adf_gen2_hw_data.h    |  8 ++++++++
 drivers/crypto/qat/qat_common/adf_gen4_hw_data.h    |  8 ++++++++
 .../crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c  |  1 +
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c     |  1 +
 11 files changed, 44 insertions(+)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 0d1603894af4..67cd20f443ab 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -246,6 +246,7 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->num_logical_accel = 1;
 	hw_data->tx_rx_gap = ADF_4XXX_RX_RINGS_OFFSET;
 	hw_data->tx_rings_mask = ADF_4XXX_TX_RINGS_MASK;
+	hw_data->ring_to_svc_map = ADF_GEN4_DEFAULT_RING_TO_SRV_MAP;
 	hw_data->alloc_irq = adf_isr_resource_alloc;
 	hw_data->free_irq = adf_isr_resource_free;
 	hw_data->enable_error_correction = adf_enable_error_correction;
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 3987a44fa164..b941fe3713ff 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -109,6 +109,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->num_engines = ADF_C3XXX_MAX_ACCELENGINES;
 	hw_data->tx_rx_gap = ADF_GEN2_RX_RINGS_OFFSET;
 	hw_data->tx_rings_mask = ADF_GEN2_TX_RINGS_MASK;
+	hw_data->ring_to_svc_map = ADF_GEN2_DEFAULT_RING_TO_SRV_MAP;
 	hw_data->alloc_irq = adf_isr_resource_alloc;
 	hw_data->free_irq = adf_isr_resource_free;
 	hw_data->enable_error_correction = adf_gen2_enable_error_correction;
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index 85122013534d..a9fbe57b32ae 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -67,6 +67,7 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->num_engines = ADF_C3XXXIOV_MAX_ACCELENGINES;
 	hw_data->tx_rx_gap = ADF_C3XXXIOV_RX_RINGS_OFFSET;
 	hw_data->tx_rings_mask = ADF_C3XXXIOV_TX_RINGS_MASK;
+	hw_data->ring_to_svc_map = ADF_GEN2_DEFAULT_RING_TO_SRV_MAP;
 	hw_data->alloc_irq = adf_vf_isr_resource_alloc;
 	hw_data->free_irq = adf_vf_isr_resource_free;
 	hw_data->enable_error_correction = adf_vf_void_noop;
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index a76e33d7a215..b1eac2f81faa 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -111,6 +111,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->num_engines = ADF_C62X_MAX_ACCELENGINES;
 	hw_data->tx_rx_gap = ADF_GEN2_RX_RINGS_OFFSET;
 	hw_data->tx_rings_mask = ADF_GEN2_TX_RINGS_MASK;
+	hw_data->ring_to_svc_map = ADF_GEN2_DEFAULT_RING_TO_SRV_MAP;
 	hw_data->alloc_irq = adf_isr_resource_alloc;
 	hw_data->free_irq = adf_isr_resource_free;
 	hw_data->enable_error_correction = adf_gen2_enable_error_correction;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 99c56405f88f..0282038fca54 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -67,6 +67,7 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->num_engines = ADF_C62XIOV_MAX_ACCELENGINES;
 	hw_data->tx_rx_gap = ADF_C62XIOV_RX_RINGS_OFFSET;
 	hw_data->tx_rings_mask = ADF_C62XIOV_TX_RINGS_MASK;
+	hw_data->ring_to_svc_map = ADF_GEN2_DEFAULT_RING_TO_SRV_MAP;
 	hw_data->alloc_irq = adf_vf_isr_resource_alloc;
 	hw_data->free_irq = adf_vf_isr_resource_free;
 	hw_data->enable_error_correction = adf_vf_void_noop;
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 1fb32f3e78df..59f06e53d316 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -208,6 +208,7 @@ struct adf_hw_device_data {
 	u32 ae_mask;
 	u32 admin_ae_mask;
 	u16 tx_rings_mask;
+	u16 ring_to_svc_map;
 	u8 tx_rx_gap;
 	u8 num_banks;
 	u16 num_banks_per_vf;
@@ -224,12 +225,19 @@ struct adf_hw_device_data {
 /* CSR read macro */
 #define ADF_CSR_RD(csr_base, csr_offset) __raw_readl(csr_base + csr_offset)
 
+#define ADF_CFG_NUM_SERVICES	4
+#define ADF_SRV_TYPE_BIT_LEN	3
+#define ADF_SRV_TYPE_MASK	0x7
+
 #define GET_DEV(accel_dev) ((accel_dev)->accel_pci_dev.pci_dev->dev)
 #define GET_BARS(accel_dev) ((accel_dev)->accel_pci_dev.pci_bars)
 #define GET_HW_DATA(accel_dev) (accel_dev->hw_device)
 #define GET_MAX_BANKS(accel_dev) (GET_HW_DATA(accel_dev)->num_banks)
 #define GET_NUM_RINGS_PER_BANK(accel_dev) \
 	GET_HW_DATA(accel_dev)->num_rings_per_bank
+#define GET_SRV_TYPE(accel_dev, idx) \
+	(((GET_HW_DATA(accel_dev)->ring_to_svc_map) >> (ADF_SRV_TYPE_BIT_LEN * (idx))) \
+	& ADF_SRV_TYPE_MASK)
 #define GET_MAX_ACCELENGINES(accel_dev) (GET_HW_DATA(accel_dev)->num_engines)
 #define GET_CSR_OPS(accel_dev) (&(accel_dev)->hw_device->csr_ops)
 #define GET_PFVF_OPS(accel_dev) (&(accel_dev)->hw_device->pfvf_ops)
diff --git a/drivers/crypto/qat/qat_common/adf_cfg_common.h b/drivers/crypto/qat/qat_common/adf_cfg_common.h
index 4fabb70b1f18..6e5de1dab97b 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_common.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_common.h
@@ -19,6 +19,19 @@
 #define ADF_MAX_DEVICES (32 * 32)
 #define ADF_DEVS_ARRAY_SIZE BITS_TO_LONGS(ADF_MAX_DEVICES)
 
+#define ADF_CFG_SERV_RING_PAIR_0_SHIFT 0
+#define ADF_CFG_SERV_RING_PAIR_1_SHIFT 3
+#define ADF_CFG_SERV_RING_PAIR_2_SHIFT 6
+#define ADF_CFG_SERV_RING_PAIR_3_SHIFT 9
+enum adf_cfg_service_type {
+	UNUSED = 0,
+	CRYPTO,
+	COMP,
+	SYM,
+	ASYM,
+	USED
+};
+
 enum adf_cfg_val_type {
 	ADF_DEC,
 	ADF_HEX,
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
index 7c2c17366460..f2e0451b11c0 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_hw_data.h
@@ -4,6 +4,7 @@
 #define ADF_GEN2_HW_DATA_H_
 
 #include "adf_accel_devices.h"
+#include "adf_cfg_common.h"
 
 /* Transport access */
 #define ADF_BANK_INT_SRC_SEL_MASK_0	0x4444444CUL
@@ -116,6 +117,13 @@ do { \
 #define ADF_POWERGATE_DC		BIT(23)
 #define ADF_POWERGATE_PKE		BIT(24)
 
+/* Default ring mapping */
+#define ADF_GEN2_DEFAULT_RING_TO_SRV_MAP \
+	(CRYPTO << ADF_CFG_SERV_RING_PAIR_0_SHIFT | \
+	 CRYPTO << ADF_CFG_SERV_RING_PAIR_1_SHIFT | \
+	 UNUSED << ADF_CFG_SERV_RING_PAIR_2_SHIFT | \
+	   COMP << ADF_CFG_SERV_RING_PAIR_3_SHIFT)
+
 /* WDT timers
  *
  * Timeout is in cycles. Clock speed may vary across products but this
diff --git a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
index 449d6a5976a9..f0f71ca44ca3 100644
--- a/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
+++ b/drivers/crypto/qat/qat_common/adf_gen4_hw_data.h
@@ -4,6 +4,7 @@
 #define ADF_GEN4_HW_CSR_DATA_H_
 
 #include "adf_accel_devices.h"
+#include "adf_cfg_common.h"
 
 /* Transport access */
 #define ADF_BANK_INT_SRC_SEL_MASK	0x44UL
@@ -94,6 +95,13 @@ do { \
 		   ADF_RING_BUNDLE_SIZE * (bank) + \
 		   ADF_RING_CSR_RING_SRV_ARB_EN, (value))
 
+/* Default ring mapping */
+#define ADF_GEN4_DEFAULT_RING_TO_SRV_MAP \
+	(ASYM << ADF_CFG_SERV_RING_PAIR_0_SHIFT | \
+	  SYM << ADF_CFG_SERV_RING_PAIR_1_SHIFT | \
+	 ASYM << ADF_CFG_SERV_RING_PAIR_2_SHIFT | \
+	  SYM << ADF_CFG_SERV_RING_PAIR_3_SHIFT)
+
 /* WDT timers
  *
  * Timeout is in cycles. Clock speed may vary across products but this
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 2d18279191d7..09599fe4d2f3 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -191,6 +191,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->num_engines = ADF_DH895XCC_MAX_ACCELENGINES;
 	hw_data->tx_rx_gap = ADF_GEN2_RX_RINGS_OFFSET;
 	hw_data->tx_rings_mask = ADF_GEN2_TX_RINGS_MASK;
+	hw_data->ring_to_svc_map = ADF_GEN2_DEFAULT_RING_TO_SRV_MAP;
 	hw_data->alloc_irq = adf_isr_resource_alloc;
 	hw_data->free_irq = adf_isr_resource_free;
 	hw_data->enable_error_correction = adf_gen2_enable_error_correction;
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 5489d6c02256..31c14d7e1c11 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -67,6 +67,7 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->num_engines = ADF_DH895XCCIOV_MAX_ACCELENGINES;
 	hw_data->tx_rx_gap = ADF_DH895XCCIOV_RX_RINGS_OFFSET;
 	hw_data->tx_rings_mask = ADF_DH895XCCIOV_TX_RINGS_MASK;
+	hw_data->ring_to_svc_map = ADF_GEN2_DEFAULT_RING_TO_SRV_MAP;
 	hw_data->alloc_irq = adf_vf_isr_resource_alloc;
 	hw_data->free_irq = adf_vf_isr_resource_free;
 	hw_data->enable_error_correction = adf_vf_void_noop;
-- 
2.31.1

