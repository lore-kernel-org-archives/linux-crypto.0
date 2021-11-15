Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD9D4C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3FF86322C
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:04:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhKOMHY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 07:07:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:13651 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231425AbhKOMHC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 07:07:02 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233265556"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="233265556"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 04:04:07 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="535486424"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga001.jf.intel.com with ESMTP; 15 Nov 2021 04:04:05 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 11/24] crypto: qat - relocate PFVF VF related logic
Date:   Mon, 15 Nov 2021 12:03:23 +0000
Message-Id: <20211115120336.22292-12-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115120336.22292-1-giovanni.cabiddu@intel.com>
References: <20211115120336.22292-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Move device specific PFVF logic related to the VF to the newly created
adf_gen2_pfvf.c.
This refactory is done to isolate the GEN2 PFVF code into its own file
in preparation for the introduction of support for PFVF for GEN4
devices.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |  2 +-
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c  |  8 ++------
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h  |  1 -
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c    |  2 +-
 .../crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c    |  8 ++------
 .../crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h    |  1 -
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c     | 15 +++++++++++----
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.h     |  3 ++-
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c       |  2 +-
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |  8 ++------
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h   |  1 -
 11 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 0bc528004f79..aaf8e65887b8 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -136,7 +136,7 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
-	hw_data->get_pf2vf_offset = adf_gen2_get_pf2vf_offset;
+	hw_data->get_pf2vf_offset = adf_gen2_pf_get_pf2vf_offset;
 	hw_data->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
 	hw_data->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
 	hw_data->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index 3e69b520e82f..ee61f69a8077 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -4,6 +4,7 @@
 #include <adf_pf2vf_msg.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
+#include <adf_gen2_pfvf.h>
 #include "adf_c3xxxvf_hw_data.h"
 
 static struct adf_hw_device_class c3xxxiov_class = {
@@ -47,11 +48,6 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 	return DEV_SKU_VF;
 }
 
-static u32 get_pf2vf_offset(u32 i)
-{
-	return ADF_C3XXXIOV_PF2VF_OFFSET;
-}
-
 static int adf_vf_int_noop(struct adf_accel_dev *accel_dev)
 {
 	return 0;
@@ -86,7 +82,7 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->get_pf2vf_offset = adf_gen2_vf_get_pf2vf_offset;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
 	hw_data->enable_pfvf_comms = adf_enable_vf2pf_comms;
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h
index f5de4ce66014..6b4bf181d15b 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.h
@@ -12,7 +12,6 @@
 #define ADF_C3XXXIOV_TX_RINGS_MASK 0xFF
 #define ADF_C3XXXIOV_ETR_BAR 0
 #define ADF_C3XXXIOV_ETR_MAX_BANKS 1
-#define ADF_C3XXXIOV_PF2VF_OFFSET	0x200
 
 void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data);
 void adf_clean_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data);
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index 9303f2dbcaf9..0d694c713797 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -138,7 +138,7 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
-	hw_data->get_pf2vf_offset = adf_gen2_get_pf2vf_offset;
+	hw_data->get_pf2vf_offset = adf_gen2_pf_get_pf2vf_offset;
 	hw_data->get_vf2pf_sources = adf_gen2_get_vf2pf_sources;
 	hw_data->enable_vf2pf_interrupts = adf_gen2_enable_vf2pf_interrupts;
 	hw_data->disable_vf2pf_interrupts = adf_gen2_disable_vf2pf_interrupts;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 3bee3e467363..407f3beee43c 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -4,6 +4,7 @@
 #include <adf_pf2vf_msg.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
+#include <adf_gen2_pfvf.h>
 #include "adf_c62xvf_hw_data.h"
 
 static struct adf_hw_device_class c62xiov_class = {
@@ -47,11 +48,6 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 	return DEV_SKU_VF;
 }
 
-static u32 get_pf2vf_offset(u32 i)
-{
-	return ADF_C62XIOV_PF2VF_OFFSET;
-}
-
 static int adf_vf_int_noop(struct adf_accel_dev *accel_dev)
 {
 	return 0;
@@ -86,7 +82,7 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->get_pf2vf_offset = adf_gen2_vf_get_pf2vf_offset;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
 	hw_data->enable_pfvf_comms = adf_enable_vf2pf_comms;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h
index 794778c48678..a1a62c003ebf 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.h
@@ -12,7 +12,6 @@
 #define ADF_C62XIOV_TX_RINGS_MASK 0xFF
 #define ADF_C62XIOV_ETR_BAR 0
 #define ADF_C62XIOV_ETR_MAX_BANKS 1
-#define ADF_C62XIOV_PF2VF_OFFSET	0x200
 
 void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data);
 void adf_clean_hw_data_c62xiov(struct adf_hw_device_data *hw_data);
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index d4d79419daaa..ea8d34922374 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -8,13 +8,20 @@
 #define ADF_GEN2_ERR_REG_VF2PF(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
 #define ADF_GEN2_ERR_MSK_VF2PF(vf_mask)	(((vf_mask) & 0xFFFF) << 9)
 
-#define ADF_GEN2_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
+#define ADF_GEN2_PF_PF2VF_OFFSET(i)	(0x3A000 + 0x280 + ((i) * 0x04))
+#define ADF_GEN2_VF_PF2VF_OFFSET	0x200
 
-u32 adf_gen2_get_pf2vf_offset(u32 i)
+u32 adf_gen2_pf_get_pf2vf_offset(u32 i)
 {
-	return ADF_GEN2_PF2VF_OFFSET(i);
+	return ADF_GEN2_PF_PF2VF_OFFSET(i);
 }
-EXPORT_SYMBOL_GPL(adf_gen2_get_pf2vf_offset);
+EXPORT_SYMBOL_GPL(adf_gen2_pf_get_pf2vf_offset);
+
+u32 adf_gen2_vf_get_pf2vf_offset(u32 i)
+{
+	return ADF_GEN2_VF_PF2VF_OFFSET;
+}
+EXPORT_SYMBOL_GPL(adf_gen2_vf_get_pf2vf_offset);
 
 u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_addr)
 {
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.h b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.h
index 0987e254e86b..a21787e3e550 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.h
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.h
@@ -11,7 +11,8 @@
 #define ADF_GEN2_ERRMSK3 (0x3A000 + 0x1C)
 #define ADF_GEN2_ERRMSK5 (0x3A000 + 0xDC)
 
-u32 adf_gen2_get_pf2vf_offset(u32 i);
+u32 adf_gen2_pf_get_pf2vf_offset(u32 i);
+u32 adf_gen2_vf_get_pf2vf_offset(u32 i);
 u32 adf_gen2_get_vf2pf_sources(void __iomem *pmisc_bar);
 void adf_gen2_enable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask);
 void adf_gen2_disable_vf2pf_interrupts(void __iomem *pmisc_addr, u32 vf_mask);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index e134385b76a8..5fc2e5a7f10b 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -215,7 +215,7 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->get_arb_mapping = adf_get_arbiter_mapping;
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->reset_device = adf_reset_sbr;
-	hw_data->get_pf2vf_offset = adf_gen2_get_pf2vf_offset;
+	hw_data->get_pf2vf_offset = adf_gen2_pf_get_pf2vf_offset;
 	hw_data->get_vf2pf_sources = get_vf2pf_sources;
 	hw_data->enable_vf2pf_interrupts = enable_vf2pf_interrupts;
 	hw_data->disable_vf2pf_interrupts = disable_vf2pf_interrupts;
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 7c6ed6bc8abf..30d862226026 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -4,6 +4,7 @@
 #include <adf_pf2vf_msg.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
+#include <adf_gen2_pfvf.h>
 #include "adf_dh895xccvf_hw_data.h"
 
 static struct adf_hw_device_class dh895xcciov_class = {
@@ -47,11 +48,6 @@ static enum dev_sku_info get_sku(struct adf_hw_device_data *self)
 	return DEV_SKU_VF;
 }
 
-static u32 get_pf2vf_offset(u32 i)
-{
-	return ADF_DH895XCCIOV_PF2VF_OFFSET;
-}
-
 static int adf_vf_int_noop(struct adf_accel_dev *accel_dev)
 {
 	return 0;
@@ -86,7 +82,7 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->get_num_aes = get_num_aes;
 	hw_data->get_etr_bar_id = get_etr_bar_id;
 	hw_data->get_misc_bar_id = get_misc_bar_id;
-	hw_data->get_pf2vf_offset = get_pf2vf_offset;
+	hw_data->get_pf2vf_offset = adf_gen2_vf_get_pf2vf_offset;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
 	hw_data->enable_pfvf_comms = adf_enable_vf2pf_comms;
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
index 306ebb71a408..6973fa967bc8 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.h
@@ -12,7 +12,6 @@
 #define ADF_DH895XCCIOV_TX_RINGS_MASK 0xFF
 #define ADF_DH895XCCIOV_ETR_BAR 0
 #define ADF_DH895XCCIOV_ETR_MAX_BANKS 1
-#define ADF_DH895XCCIOV_PF2VF_OFFSET	0x200
 
 void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data);
 void adf_clean_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data);
-- 
2.33.1

