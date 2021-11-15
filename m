Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22418C433F5
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:06:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06B416322C
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Nov 2021 12:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231278AbhKOMIk (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Nov 2021 07:08:40 -0500
Received: from mga09.intel.com ([134.134.136.24]:13648 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231626AbhKOMIL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Nov 2021 07:08:11 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10168"; a="233265622"
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="233265622"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2021 04:04:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,236,1631602800"; 
   d="scan'208";a="535486549"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.76])
  by orsmga001.jf.intel.com with ESMTP; 15 Nov 2021 04:04:24 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH v2 22/24] crypto: qat - do not rely on min version
Date:   Mon, 15 Nov 2021 12:03:34 +0000
Message-Id: <20211115120336.22292-23-giovanni.cabiddu@intel.com>
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

Remove min_iov_compat_ver field as for now all versions are compatible.

Compatibility is determined by a series of rules and dynamic conditions
such as specific configurations.
In any case the minimum version requirement for compatibility is
an inadequate and obsolete approach which should be removed.

At this time compatibility can be assured across the currently available
versions.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c |  2 --
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c   |  2 --
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c      |  2 --
 drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c |  2 --
 .../crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c |  2 --
 .../crypto/qat/qat_common/adf_accel_devices.h  |  1 -
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.c  | 18 ++++++------------
 .../crypto/qat/qat_common/adf_pfvf_vf_msg.c    |  7 ++-----
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c    |  2 --
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c    |  2 --
 10 files changed, 8 insertions(+), 32 deletions(-)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index 9e92adac2257..8ecda6a818f7 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -4,7 +4,6 @@
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
 #include <adf_gen4_hw_data.h>
-#include <adf_pfvf_msg.h>
 #include "adf_4xxx_hw_data.h"
 #include "icp_qat_hw.h"
 
@@ -250,7 +249,6 @@ void adf_init_hw_data_4xxx(struct adf_hw_device_data *hw_data)
 	hw_data->set_ssm_wdtimer = adf_gen4_set_ssm_wdtimer;
 	hw_data->pfvf_ops.enable_comms = adf_pfvf_comms_disabled;
 	hw_data->disable_iov = adf_disable_sriov;
-	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
 	adf_gen4_init_hw_csr_ops(&hw_data->csr_ops);
 }
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index 94a11e72edae..3987a44fa164 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -4,7 +4,6 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
-#include <adf_pfvf_msg.h>
 #include "adf_c3xxx_hw_data.h"
 #include "icp_qat_hw.h"
 
@@ -137,7 +136,6 @@ void adf_init_hw_data_c3xxx(struct adf_hw_device_data *hw_data)
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	hw_data->disable_iov = adf_disable_sriov;
-	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index 4c43a0d93fa6..85122013534d 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -4,7 +4,6 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
-#include <adf_pfvf_msg.h>
 #include <adf_pfvf_vf_msg.h>
 #include "adf_c3xxxvf_hw_data.h"
 
@@ -85,7 +84,6 @@ void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 	hw_data->get_misc_bar_id = get_misc_bar_id;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
-	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 	hw_data->dev_class->instances++;
 	adf_devmgr_update_class_index(hw_data);
 	adf_gen2_init_vf_pfvf_ops(&hw_data->pfvf_ops);
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index 3cb1a88d97ae..a76e33d7a215 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -4,7 +4,6 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
-#include <adf_pfvf_msg.h>
 #include "adf_c62x_hw_data.h"
 #include "icp_qat_hw.h"
 
@@ -139,7 +138,6 @@ void adf_init_hw_data_c62x(struct adf_hw_device_data *hw_data)
 	hw_data->reset_device = adf_reset_flr;
 	hw_data->set_ssm_wdtimer = adf_gen2_set_ssm_wdtimer;
 	hw_data->disable_iov = adf_disable_sriov;
-	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	adf_gen2_init_hw_csr_ops(&hw_data->csr_ops);
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index c4b23e2cd579..99c56405f88f 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -4,7 +4,6 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
-#include <adf_pfvf_msg.h>
 #include <adf_pfvf_vf_msg.h>
 #include "adf_c62xvf_hw_data.h"
 
@@ -85,7 +84,6 @@ void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 	hw_data->get_misc_bar_id = get_misc_bar_id;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
-	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 	hw_data->dev_class->instances++;
 	adf_devmgr_update_class_index(hw_data);
 	adf_gen2_init_vf_pfvf_ops(&hw_data->pfvf_ops);
diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 5ca9458d9158..80baf8666c8d 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -209,7 +209,6 @@ struct adf_hw_device_data {
 	u8 num_accel;
 	u8 num_logical_accel;
 	u8 num_engines;
-	u8 min_iov_compat_ver;
 };
 
 /* CSR write macro */
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index 3b0f298f99d4..2ffd1f442e35 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -40,7 +40,6 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 				u32 msg, u32 *response)
 {
 	struct adf_accel_vf_info *vf_info = &accel_dev->pf.vf_info[vf_nr];
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	u32 resp = 0;
 
 	switch ((msg & ADF_VF2PF_MSGTYPE_MASK) >> ADF_VF2PF_MSGTYPE_SHIFT) {
@@ -53,21 +52,16 @@ static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 			"Compatibility Version Request from VF%d vers=%u\n",
 			vf_nr + 1, vf_compat_ver);
 
-		if (vf_compat_ver < hw_data->min_iov_compat_ver) {
-			dev_err(&GET_DEV(accel_dev),
-				"VF (vers %d) incompatible with PF (vers %d)\n",
+		if (vf_compat_ver <= ADF_PFVF_COMPAT_THIS_VERSION) {
+			compat = ADF_PF2VF_VF_COMPATIBLE;
+			dev_dbg(&GET_DEV(accel_dev),
+				"VF (vers %d) compatible with PF (vers %d)\n",
 				vf_compat_ver, ADF_PFVF_COMPAT_THIS_VERSION);
-			compat = ADF_PF2VF_VF_INCOMPATIBLE;
-		} else if (vf_compat_ver > ADF_PFVF_COMPAT_THIS_VERSION) {
+		} else {
+			compat = ADF_PF2VF_VF_COMPAT_UNKNOWN;
 			dev_err(&GET_DEV(accel_dev),
 				"VF (vers %d) compat with PF (vers %d) unkn.\n",
 				vf_compat_ver, ADF_PFVF_COMPAT_THIS_VERSION);
-			compat = ADF_PF2VF_VF_COMPAT_UNKNOWN;
-		} else {
-			dev_dbg(&GET_DEV(accel_dev),
-				"VF (vers %d) compatible with PF (vers %d)\n",
-				vf_compat_ver, ADF_PFVF_COMPAT_THIS_VERSION);
-			compat = ADF_PF2VF_VF_COMPATIBLE;
 		}
 
 		resp =  ADF_PF2VF_MSGORIGIN_SYSTEM;
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
index d5cccec03a3b..763581839902 100644
--- a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
@@ -51,7 +51,6 @@ EXPORT_SYMBOL_GPL(adf_vf2pf_notify_shutdown);
 
 int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 {
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	u8 pf_version;
 	u32 msg = 0;
 	int compat;
@@ -80,10 +79,8 @@ int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
 	case ADF_PF2VF_VF_COMPATIBLE:
 		break;
 	case ADF_PF2VF_VF_COMPAT_UNKNOWN:
-		/* VF is newer than PF and decides whether it is compatible */
-		if (pf_version >= hw_data->min_iov_compat_ver)
-			break;
-		fallthrough;
+		/* VF is newer than PF - compatible for now */
+		break;
 	case ADF_PF2VF_VF_INCOMPATIBLE:
 		dev_err(&GET_DEV(accel_dev),
 			"PF (vers %d) and VF (vers %d) are not compatible\n",
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 37f43b8c29eb..27d4cab65dd8 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -4,7 +4,6 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
-#include <adf_pfvf_msg.h>
 #include "adf_dh895xcc_hw_data.h"
 #include "icp_qat_hw.h"
 
@@ -216,7 +215,6 @@ void adf_init_hw_data_dh895xcc(struct adf_hw_device_data *hw_data)
 	hw_data->enable_ints = adf_enable_ints;
 	hw_data->reset_device = adf_reset_sbr;
 	hw_data->disable_iov = adf_disable_sriov;
-	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 
 	adf_gen2_init_pf_pfvf_ops(&hw_data->pfvf_ops);
 	hw_data->pfvf_ops.get_vf2pf_sources = get_vf2pf_sources;
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index d3795bab3725..5489d6c02256 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -4,7 +4,6 @@
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
-#include <adf_pfvf_msg.h>
 #include <adf_pfvf_vf_msg.h>
 #include "adf_dh895xccvf_hw_data.h"
 
@@ -85,7 +84,6 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->get_misc_bar_id = get_misc_bar_id;
 	hw_data->get_sku = get_sku;
 	hw_data->enable_ints = adf_vf_void_noop;
-	hw_data->min_iov_compat_ver = ADF_PFVF_COMPAT_THIS_VERSION;
 	hw_data->dev_class->instances++;
 	adf_devmgr_update_class_index(hw_data);
 	adf_gen2_init_vf_pfvf_ops(&hw_data->pfvf_ops);
-- 
2.33.1

