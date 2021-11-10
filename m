Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F2FC433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:53:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 561A260F9E
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Nov 2021 20:53:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhKJUzq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Nov 2021 15:55:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:55781 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233115AbhKJUzj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Nov 2021 15:55:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10164"; a="232611278"
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="232611278"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2021 12:52:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,224,1631602800"; 
   d="scan'208";a="642663296"
Received: from silpixa00400314.ir.intel.com (HELO silpixa00400314.ger.corp.intel.com) ([10.237.222.51])
  by fmsmga001.fm.intel.com with ESMTP; 10 Nov 2021 12:52:48 -0800
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, qat-linux@intel.com,
        marco.chiappero@intel.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Subject: [PATCH 17/24] crypto: qat - reorganize PFVF code
Date:   Wed, 10 Nov 2021 20:52:10 +0000
Message-Id: <20211110205217.99903-18-giovanni.cabiddu@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211110205217.99903-1-giovanni.cabiddu@intel.com>
References: <20211110205217.99903-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Organization: Intel Research and Development Ireland Ltd - Co. Reg. #308263 - Collinstown Industrial Park, Leixlip, County Kildare - Ireland
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Marco Chiappero <marco.chiappero@intel.com>

Reorganize the structure of the PFVF code by moving the content of
adf_pf2vf_msg.c and adf_vf2pf_msg.c.

The logic that handles high level messages has been moved to
adf_pfvf_pf_msg.c and adf_pfvf_vf_msg.c.
The implementation of low level communication primitives and the
protocol is now included in adf_pfvf_pf_proto.c and adf_pfvf_vf_proto.c.

In addition, the file adf_pf2vf_msg.h has been renamed in adf_pfvf_msg.h
since it common to PF and VF and the copyright date for the touched
files has been updated.

Signed-off-by: Marco Chiappero <marco.chiappero@intel.com>
Co-developed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
---
 .../crypto/qat/qat_4xxx/adf_4xxx_hw_data.c    |   4 +-
 .../crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c  |   4 +-
 .../qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c     |   5 +-
 .../crypto/qat/qat_c62x/adf_c62x_hw_data.c    |   4 +-
 .../qat/qat_c62xvf/adf_c62xvf_hw_data.c       |   5 +-
 drivers/crypto/qat/qat_common/Makefile        |   5 +-
 .../crypto/qat/qat_common/adf_common_drv.h    |  22 +--
 drivers/crypto/qat/qat_common/adf_gen2_pfvf.c |   4 +-
 .../{adf_pf2vf_msg.h => adf_pfvf_msg.h}       |   8 +-
 .../crypto/qat/qat_common/adf_pfvf_pf_msg.c   |  21 +++
 .../crypto/qat/qat_common/adf_pfvf_pf_msg.h   |  10 ++
 .../{adf_pf2vf_msg.c => adf_pfvf_pf_proto.c}  | 137 +-----------------
 .../crypto/qat/qat_common/adf_pfvf_pf_proto.h |  13 ++
 .../crypto/qat/qat_common/adf_pfvf_vf_msg.c   |  93 ++++++++++++
 .../crypto/qat/qat_common/adf_pfvf_vf_msg.h   |  21 +++
 .../crypto/qat/qat_common/adf_pfvf_vf_proto.c | 133 +++++++++++++++++
 .../crypto/qat/qat_common/adf_pfvf_vf_proto.h |  14 ++
 drivers/crypto/qat/qat_common/adf_sriov.c     |   4 +-
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c | 100 -------------
 drivers/crypto/qat/qat_common/adf_vf_isr.c    |   1 -
 .../qat/qat_dh895xcc/adf_dh895xcc_hw_data.c   |   4 +-
 .../qat_dh895xccvf/adf_dh895xccvf_hw_data.c   |   5 +-
 22 files changed, 341 insertions(+), 276 deletions(-)
 rename drivers/crypto/qat/qat_common/{adf_pf2vf_msg.h => adf_pfvf_msg.h} (96%)
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h
 rename drivers/crypto/qat/qat_common/{adf_pf2vf_msg.c => adf_pfvf_pf_proto.c} (53%)
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
 create mode 100644 drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.h
 delete mode 100644 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c

diff --git a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
index ac9c9cee8318..9e92adac2257 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_4xxx_hw_data.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
-/* Copyright(c) 2020 Intel Corporation */
+/* Copyright(c) 2020 - 2021 Intel Corporation */
 #include <linux/iopoll.h>
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
-#include <adf_pf2vf_msg.h>
 #include <adf_gen4_hw_data.h>
+#include <adf_pfvf_msg.h>
 #include "adf_4xxx_hw_data.h"
 #include "icp_qat_hw.h"
 
diff --git a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
index d25f78660b8c..94a11e72edae 100644
--- a/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxx/adf_c3xxx_hw_data.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
-/* Copyright(c) 2014 - 2020 Intel Corporation */
+/* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
-#include <adf_pf2vf_msg.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
+#include <adf_pfvf_msg.h>
 #include "adf_c3xxx_hw_data.h"
 #include "icp_qat_hw.h"
 
diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index c39733320063..4c43a0d93fa6 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -1,10 +1,11 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
-/* Copyright(c) 2015 - 2020 Intel Corporation */
+/* Copyright(c) 2015 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
-#include <adf_pf2vf_msg.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
+#include <adf_pfvf_msg.h>
+#include <adf_pfvf_vf_msg.h>
 #include "adf_c3xxxvf_hw_data.h"
 
 static struct adf_hw_device_class c3xxxiov_class = {
diff --git a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
index f24a01e1bc1a..3cb1a88d97ae 100644
--- a/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
+++ b/drivers/crypto/qat/qat_c62x/adf_c62x_hw_data.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
-/* Copyright(c) 2014 - 2020 Intel Corporation */
+/* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
-#include <adf_pf2vf_msg.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
+#include <adf_pfvf_msg.h>
 #include "adf_c62x_hw_data.h"
 #include "icp_qat_hw.h"
 
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index 03097bbe600a..c4b23e2cd579 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -1,10 +1,11 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
-/* Copyright(c) 2015 - 2020 Intel Corporation */
+/* Copyright(c) 2015 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
-#include <adf_pf2vf_msg.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
+#include <adf_pfvf_msg.h>
+#include <adf_pfvf_vf_msg.h>
 #include "adf_c62xvf_hw_data.h"
 
 static struct adf_hw_device_class c62xiov_class = {
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 676aef6533e0..1376504d16ff 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -19,6 +19,7 @@ intel_qat-objs := adf_cfg.o \
 	qat_hal.o
 
 intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o
-intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_pf2vf_msg.o \
-			       adf_vf2pf_msg.o adf_vf_isr.o \
+intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_vf_isr.o \
+			       adf_pfvf_pf_msg.o adf_pfvf_pf_proto.o \
+			       adf_pfvf_vf_msg.o adf_pfvf_vf_proto.o \
 			       adf_gen2_pfvf.o
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index dc5846e880fe..817a8d7773ef 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only) */
-/* Copyright(c) 2014 - 2020 Intel Corporation */
+/* Copyright(c) 2014 - 2021 Intel Corporation */
 #ifndef ADF_DRV_H
 #define ADF_DRV_H
 
@@ -62,8 +62,6 @@ int adf_dev_start(struct adf_accel_dev *accel_dev);
 void adf_dev_stop(struct adf_accel_dev *accel_dev);
 void adf_dev_shutdown(struct adf_accel_dev *accel_dev);
 
-void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev);
-int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev);
 void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data);
 void adf_clean_vf_map(bool);
 
@@ -198,13 +196,9 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev);
 bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr);
 int adf_pf2vf_handle_pf_restarting(struct adf_accel_dev *accel_dev);
-int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev);
 void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_schedule_vf2pf_handler(struct adf_accel_vf_info *vf_info);
-int adf_send_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 msg);
-int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev);
-void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev);
 int adf_init_pf_wq(void);
 void adf_exit_pf_wq(void);
 int adf_init_vf_wq(void);
@@ -213,11 +207,6 @@ void adf_flush_vf_wq(struct adf_accel_dev *accel_dev);
 #else
 #define adf_sriov_configure NULL
 
-static inline int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev)
-{
-	return 0;
-}
-
 static inline void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 {
 }
@@ -230,15 +219,6 @@ static inline void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 {
 }
 
-static inline int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
-{
-	return 0;
-}
-
-static inline void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
-{
-}
-
 static inline int adf_init_pf_wq(void)
 {
 	return 0;
diff --git a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
index 01dabac9ba28..b71230d8ec73 100644
--- a/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
+++ b/drivers/crypto/qat/qat_common/adf_gen2_pfvf.c
@@ -6,7 +6,9 @@
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
 #include "adf_gen2_pfvf.h"
-#include "adf_pf2vf_msg.h"
+#include "adf_pfvf_msg.h"
+#include "adf_pfvf_pf_proto.h"
+#include "adf_pfvf_vf_proto.h"
 
  /* VF2PF interrupts */
 #define ADF_GEN2_ERR_REG_VF2PF(vf_src)	(((vf_src) & 0x01FFFE00) >> 9)
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
similarity index 96%
rename from drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
rename to drivers/crypto/qat/qat_common/adf_pfvf_msg.h
index 73eb8f13ad09..0520466563fd 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.h
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_msg.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only) */
-/* Copyright(c) 2015 - 2020 Intel Corporation */
-#ifndef ADF_PF2VF_MSG_H
-#define ADF_PF2VF_MSG_H
+/* Copyright(c) 2015 - 2021 Intel Corporation */
+#ifndef ADF_PFVF_MSG_H
+#define ADF_PFVF_MSG_H
 
 /*
  * PF<->VF Messaging
@@ -91,4 +91,4 @@
 /* VF->PF Compatible Version Request */
 #define ADF_VF2PF_COMPAT_VER_REQ_SHIFT		22
 
-#endif /* ADF_IOV_MSG_H */
+#endif /* ADF_PFVF_MSG_H */
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
new file mode 100644
index 000000000000..647b82e6c4ba
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.c
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
+/* Copyright(c) 2015 - 2021 Intel Corporation */
+#include <linux/pci.h>
+#include "adf_accel_devices.h"
+#include "adf_pfvf_msg.h"
+#include "adf_pfvf_pf_msg.h"
+#include "adf_pfvf_pf_proto.h"
+
+void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
+{
+	struct adf_accel_vf_info *vf;
+	u32 msg = (ADF_PF2VF_MSGORIGIN_SYSTEM |
+		(ADF_PF2VF_MSGTYPE_RESTARTING << ADF_PF2VF_MSGTYPE_SHIFT));
+	int i, num_vfs = pci_num_vf(accel_to_pci_dev(accel_dev));
+
+	for (i = 0, vf = accel_dev->pf.vf_info; i < num_vfs; i++, vf++) {
+		if (vf->init && adf_send_pf2vf_msg(accel_dev, i, msg))
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to send restarting msg to VF%d\n", i);
+	}
+}
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h
new file mode 100644
index 000000000000..187807b1ff88
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_msg.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only) */
+/* Copyright(c) 2021 Intel Corporation */
+#ifndef ADF_PFVF_PF_MSG_H
+#define ADF_PFVF_PF_MSG_H
+
+#include "adf_accel_devices.h"
+
+void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev);
+
+#endif /* ADF_PFVF_PF_MSG_H */
diff --git a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
similarity index 53%
rename from drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
rename to drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
index c064e8bab50d..ac6a54cf17f6 100644
--- a/drivers/crypto/qat/qat_common/adf_pf2vf_msg.c
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.c
@@ -1,15 +1,11 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
-/* Copyright(c) 2015 - 2020 Intel Corporation */
+/* Copyright(c) 2015 - 2021 Intel Corporation */
+#include <linux/spinlock.h>
+#include <linux/types.h>
 #include "adf_accel_devices.h"
 #include "adf_common_drv.h"
-#include "adf_pf2vf_msg.h"
-
-#define ADF_PFVF_MSG_COLLISION_DETECT_DELAY	10
-#define ADF_PFVF_MSG_ACK_DELAY			2
-#define ADF_PFVF_MSG_ACK_MAX_RETRY		100
-#define ADF_PFVF_MSG_RESP_TIMEOUT	(ADF_PFVF_MSG_ACK_DELAY * \
-					 ADF_PFVF_MSG_ACK_MAX_RETRY + \
-					 ADF_PFVF_MSG_COLLISION_DETECT_DELAY)
+#include "adf_pfvf_msg.h"
+#include "adf_pfvf_pf_proto.h"
 
 /**
  * adf_send_pf2vf_msg() - send PF to VF message
@@ -21,25 +17,11 @@
  *
  * Return: 0 on success, error code otherwise.
  */
-static int adf_send_pf2vf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr, u32 msg)
+int adf_send_pf2vf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr, u32 msg)
 {
 	return GET_PFVF_OPS(accel_dev)->send_msg(accel_dev, msg, vf_nr);
 }
 
-/**
- * adf_send_vf2pf_msg() - send VF to PF message
- * @accel_dev:	Pointer to acceleration device
- * @msg:	Message to send
- *
- * This function allows the VF to send a message to the PF.
- *
- * Return: 0 on success, error code otherwise.
- */
-int adf_send_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 msg)
-{
-	return GET_PFVF_OPS(accel_dev)->send_msg(accel_dev, msg, 0);
-}
-
 /**
  * adf_recv_vf2pf_msg() - receive a VF to PF message
  * @accel_dev:	Pointer to acceleration device
@@ -54,42 +36,6 @@ static u32 adf_recv_vf2pf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr)
 	return GET_PFVF_OPS(accel_dev)->recv_msg(accel_dev, vf_nr);
 }
 
-/**
- * adf_send_vf2pf_req() - send VF2PF request message
- * @accel_dev:	Pointer to acceleration device.
- * @msg:	Request message to send
- *
- * This function sends a message that requires a response from the VF to the PF
- * and waits for a reply.
- *
- * Return: 0 on success, error code otherwise.
- */
-static int adf_send_vf2pf_req(struct adf_accel_dev *accel_dev, u32 msg)
-{
-	unsigned long timeout = msecs_to_jiffies(ADF_PFVF_MSG_RESP_TIMEOUT);
-	int ret;
-
-	reinit_completion(&accel_dev->vf.iov_msg_completion);
-
-	/* Send request from VF to PF */
-	ret = adf_send_vf2pf_msg(accel_dev, msg);
-	if (ret) {
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to send request msg to PF\n");
-		return ret;
-	}
-
-	/* Wait for response */
-	if (!wait_for_completion_timeout(&accel_dev->vf.iov_msg_completion,
-					 timeout)) {
-		dev_err(&GET_DEV(accel_dev),
-			"PFVF request/response message timeout expired\n");
-		return -EIO;
-	}
-
-	return 0;
-}
-
 static int adf_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr,
 				u32 msg, u32 *response)
 {
@@ -193,77 +139,6 @@ bool adf_recv_and_handle_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 vf_nr)
 	return true;
 }
 
-void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev)
-{
-	struct adf_accel_vf_info *vf;
-	u32 msg = (ADF_PF2VF_MSGORIGIN_SYSTEM |
-		(ADF_PF2VF_MSGTYPE_RESTARTING << ADF_PF2VF_MSGTYPE_SHIFT));
-	int i, num_vfs = pci_num_vf(accel_to_pci_dev(accel_dev));
-
-	for (i = 0, vf = accel_dev->pf.vf_info; i < num_vfs; i++, vf++) {
-		if (vf->init && adf_send_pf2vf_msg(accel_dev, i, msg))
-			dev_err(&GET_DEV(accel_dev),
-				"Failed to send restarting msg to VF%d\n", i);
-	}
-}
-
-static int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
-{
-	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
-	u32 msg = 0;
-	int ret;
-
-	msg = ADF_VF2PF_MSGORIGIN_SYSTEM;
-	msg |= ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ << ADF_VF2PF_MSGTYPE_SHIFT;
-	msg |= ADF_PFVF_COMPAT_THIS_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
-	BUILD_BUG_ON(ADF_PFVF_COMPAT_THIS_VERSION > 255);
-
-	ret = adf_send_vf2pf_req(accel_dev, msg);
-	if (ret) {
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to send Compatibility Version Request.\n");
-		return ret;
-	}
-
-	/* Response from PF received, check compatibility */
-	switch (accel_dev->vf.compatible) {
-	case ADF_PF2VF_VF_COMPATIBLE:
-		break;
-	case ADF_PF2VF_VF_COMPAT_UNKNOWN:
-		/* VF is newer than PF and decides whether it is compatible */
-		if (accel_dev->vf.pf_version >= hw_data->min_iov_compat_ver) {
-			accel_dev->vf.compatible = ADF_PF2VF_VF_COMPATIBLE;
-			break;
-		}
-		fallthrough;
-	case ADF_PF2VF_VF_INCOMPATIBLE:
-		dev_err(&GET_DEV(accel_dev),
-			"PF (vers %d) and VF (vers %d) are not compatible\n",
-			accel_dev->vf.pf_version,
-			ADF_PFVF_COMPAT_THIS_VERSION);
-		return -EINVAL;
-	default:
-		dev_err(&GET_DEV(accel_dev),
-			"Invalid response from PF; assume not compatible\n");
-		return -EINVAL;
-	}
-	return ret;
-}
-
-/**
- * adf_enable_vf2pf_comms() - Function enables communication from vf to pf
- *
- * @accel_dev: Pointer to acceleration device virtual function.
- *
- * Return: 0 on success, error code otherwise.
- */
-int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
-{
-	adf_enable_pf2vf_interrupts(accel_dev);
-	return adf_vf2pf_request_version(accel_dev);
-}
-EXPORT_SYMBOL_GPL(adf_enable_vf2pf_comms);
-
 /**
  * adf_enable_pf2vf_comms() - Function enables communication from pf to vf
  *
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.h b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.h
new file mode 100644
index 000000000000..63245407bfb6
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_pf_proto.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only) */
+/* Copyright(c) 2021 Intel Corporation */
+#ifndef ADF_PFVF_PF_PROTO_H
+#define ADF_PFVF_PF_PROTO_H
+
+#include <linux/types.h>
+#include "adf_accel_devices.h"
+
+int adf_send_pf2vf_msg(struct adf_accel_dev *accel_dev, u8 vf_nr, u32 msg);
+
+int adf_enable_pf2vf_comms(struct adf_accel_dev *accel_dev);
+
+#endif /* ADF_PFVF_PF_PROTO_H */
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
new file mode 100644
index 000000000000..7969a644e24b
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.c
@@ -0,0 +1,93 @@
+// SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
+/* Copyright(c) 2015 - 2021 Intel Corporation */
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_pfvf_msg.h"
+#include "adf_pfvf_vf_msg.h"
+#include "adf_pfvf_vf_proto.h"
+
+/**
+ * adf_vf2pf_notify_init() - send init msg to PF
+ * @accel_dev:  Pointer to acceleration VF device.
+ *
+ * Function sends an init message from the VF to a PF
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
+{
+	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
+		(ADF_VF2PF_MSGTYPE_INIT << ADF_VF2PF_MSGTYPE_SHIFT));
+
+	if (adf_send_vf2pf_msg(accel_dev, msg)) {
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send Init event to PF\n");
+		return -EFAULT;
+	}
+	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_vf2pf_notify_init);
+
+/**
+ * adf_vf2pf_notify_shutdown() - send shutdown msg to PF
+ * @accel_dev:  Pointer to acceleration VF device.
+ *
+ * Function sends a shutdown message from the VF to a PF
+ *
+ * Return: void
+ */
+void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
+{
+	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
+	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
+
+	if (test_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status))
+		if (adf_send_vf2pf_msg(accel_dev, msg))
+			dev_err(&GET_DEV(accel_dev),
+				"Failed to send Shutdown event to PF\n");
+}
+EXPORT_SYMBOL_GPL(adf_vf2pf_notify_shutdown);
+
+int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev)
+{
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	u32 msg = 0;
+	int ret;
+
+	msg = ADF_VF2PF_MSGORIGIN_SYSTEM;
+	msg |= ADF_VF2PF_MSGTYPE_COMPAT_VER_REQ << ADF_VF2PF_MSGTYPE_SHIFT;
+	msg |= ADF_PFVF_COMPAT_THIS_VERSION << ADF_VF2PF_COMPAT_VER_REQ_SHIFT;
+	BUILD_BUG_ON(ADF_PFVF_COMPAT_THIS_VERSION > 255);
+
+	ret = adf_send_vf2pf_req(accel_dev, msg);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send Compatibility Version Request.\n");
+		return ret;
+	}
+
+	/* Response from PF received, check compatibility */
+	switch (accel_dev->vf.compatible) {
+	case ADF_PF2VF_VF_COMPATIBLE:
+		break;
+	case ADF_PF2VF_VF_COMPAT_UNKNOWN:
+		/* VF is newer than PF and decides whether it is compatible */
+		if (accel_dev->vf.pf_version >= hw_data->min_iov_compat_ver) {
+			accel_dev->vf.compatible = ADF_PF2VF_VF_COMPATIBLE;
+			break;
+		}
+		fallthrough;
+	case ADF_PF2VF_VF_INCOMPATIBLE:
+		dev_err(&GET_DEV(accel_dev),
+			"PF (vers %d) and VF (vers %d) are not compatible\n",
+			accel_dev->vf.pf_version,
+			ADF_PFVF_COMPAT_THIS_VERSION);
+		return -EINVAL;
+	default:
+		dev_err(&GET_DEV(accel_dev),
+			"Invalid response from PF; assume not compatible\n");
+		return -EINVAL;
+	}
+	return ret;
+}
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h
new file mode 100644
index 000000000000..5091b5b2fd8f
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_msg.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only) */
+/* Copyright(c) 2021 Intel Corporation */
+#ifndef ADF_PFVF_VF_MSG_H
+#define ADF_PFVF_VF_MSG_H
+
+#if defined(CONFIG_PCI_IOV)
+int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev);
+void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev);
+int adf_vf2pf_request_version(struct adf_accel_dev *accel_dev);
+#else
+static inline int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
+{
+	return 0;
+}
+
+static inline void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
+{
+}
+#endif
+
+#endif /* ADF_PFVF_VF_MSG_H */
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
new file mode 100644
index 000000000000..62817bcec121
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.c
@@ -0,0 +1,133 @@
+// SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
+/* Copyright(c) 2015 - 2021 Intel Corporation */
+#include <linux/completion.h>
+#include <linux/types.h>
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_pfvf_msg.h"
+#include "adf_pfvf_vf_msg.h"
+#include "adf_pfvf_vf_proto.h"
+
+#define ADF_PFVF_MSG_COLLISION_DETECT_DELAY	10
+#define ADF_PFVF_MSG_ACK_DELAY			2
+#define ADF_PFVF_MSG_ACK_MAX_RETRY		100
+
+#define ADF_PFVF_MSG_RESP_TIMEOUT	(ADF_PFVF_MSG_ACK_DELAY * \
+					 ADF_PFVF_MSG_ACK_MAX_RETRY + \
+					 ADF_PFVF_MSG_COLLISION_DETECT_DELAY)
+
+/**
+ * adf_send_vf2pf_msg() - send VF to PF message
+ * @accel_dev:	Pointer to acceleration device
+ * @msg:	Message to send
+ *
+ * This function allows the VF to send a message to the PF.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_send_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 msg)
+{
+	return GET_PFVF_OPS(accel_dev)->send_msg(accel_dev, msg, 0);
+}
+
+/**
+ * adf_recv_pf2vf_msg() - receive a PF to VF message
+ * @accel_dev:	Pointer to acceleration device
+ *
+ * This function allows the VF to receive a message from the PF.
+ *
+ * Return: a valid message on success, zero otherwise.
+ */
+static u32 adf_recv_pf2vf_msg(struct adf_accel_dev *accel_dev)
+{
+	return GET_PFVF_OPS(accel_dev)->recv_msg(accel_dev, 0);
+}
+
+/**
+ * adf_send_vf2pf_req() - send VF2PF request message
+ * @accel_dev:	Pointer to acceleration device.
+ * @msg:	Request message to send
+ *
+ * This function sends a message that requires a response from the VF to the PF
+ * and waits for a reply.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_send_vf2pf_req(struct adf_accel_dev *accel_dev, u32 msg)
+{
+	unsigned long timeout = msecs_to_jiffies(ADF_PFVF_MSG_RESP_TIMEOUT);
+	int ret;
+
+	reinit_completion(&accel_dev->vf.iov_msg_completion);
+
+	/* Send request from VF to PF */
+	ret = adf_send_vf2pf_msg(accel_dev, msg);
+	if (ret) {
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send request msg to PF\n");
+		return ret;
+	}
+
+	/* Wait for response */
+	if (!wait_for_completion_timeout(&accel_dev->vf.iov_msg_completion,
+					 timeout)) {
+		dev_err(&GET_DEV(accel_dev),
+			"PFVF request/response message timeout expired\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static bool adf_handle_pf2vf_msg(struct adf_accel_dev *accel_dev, u32 msg)
+{
+	switch ((msg & ADF_PF2VF_MSGTYPE_MASK) >> ADF_PF2VF_MSGTYPE_SHIFT) {
+	case ADF_PF2VF_MSGTYPE_RESTARTING:
+		dev_dbg(&GET_DEV(accel_dev),
+			"Restarting msg received from PF 0x%x\n", msg);
+
+		adf_pf2vf_handle_pf_restarting(accel_dev);
+		return false;
+	case ADF_PF2VF_MSGTYPE_VERSION_RESP:
+		dev_dbg(&GET_DEV(accel_dev),
+			"Version resp received from PF 0x%x\n", msg);
+		accel_dev->vf.pf_version =
+			(msg & ADF_PF2VF_VERSION_RESP_VERS_MASK) >>
+			ADF_PF2VF_VERSION_RESP_VERS_SHIFT;
+		accel_dev->vf.compatible =
+			(msg & ADF_PF2VF_VERSION_RESP_RESULT_MASK) >>
+			ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
+		complete(&accel_dev->vf.iov_msg_completion);
+		return true;
+	default:
+		dev_err(&GET_DEV(accel_dev),
+			"Unknown PF2VF message(0x%x)\n", msg);
+	}
+
+	return false;
+}
+
+bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev)
+{
+	u32 msg;
+
+	msg = adf_recv_pf2vf_msg(accel_dev);
+	if (msg)
+		return adf_handle_pf2vf_msg(accel_dev, msg);
+
+	return true;
+}
+
+/**
+ * adf_enable_vf2pf_comms() - Function enables communication from vf to pf
+ *
+ * @accel_dev: Pointer to acceleration device virtual function.
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev)
+{
+	adf_enable_pf2vf_interrupts(accel_dev);
+	return adf_vf2pf_request_version(accel_dev);
+}
+EXPORT_SYMBOL_GPL(adf_enable_vf2pf_comms);
diff --git a/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.h b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.h
new file mode 100644
index 000000000000..a3ab24c7d18b
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_pfvf_vf_proto.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only) */
+/* Copyright(c) 2021 Intel Corporation */
+#ifndef ADF_PFVF_VF_PROTO_H
+#define ADF_PFVF_VF_PROTO_H
+
+#include <linux/types.h>
+#include "adf_accel_devices.h"
+
+int adf_send_vf2pf_msg(struct adf_accel_dev *accel_dev, u32 msg);
+int adf_send_vf2pf_req(struct adf_accel_dev *accel_dev, u32 msg);
+
+int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev);
+
+#endif /* ADF_PFVF_VF_PROTO_H */
diff --git a/drivers/crypto/qat/qat_common/adf_sriov.c b/drivers/crypto/qat/qat_common/adf_sriov.c
index 342063406c19..429990c5e0f3 100644
--- a/drivers/crypto/qat/qat_common/adf_sriov.c
+++ b/drivers/crypto/qat/qat_common/adf_sriov.c
@@ -1,12 +1,12 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
-/* Copyright(c) 2015 - 2020 Intel Corporation */
+/* Copyright(c) 2015 - 2021 Intel Corporation */
 #include <linux/workqueue.h>
 #include <linux/pci.h>
 #include <linux/device.h>
 #include <linux/iommu.h>
 #include "adf_common_drv.h"
 #include "adf_cfg.h"
-#include "adf_pf2vf_msg.h"
+#include "adf_pfvf_pf_msg.h"
 
 static struct workqueue_struct *pf2vf_resp_wq;
 
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
deleted file mode 100644
index f3660981ad6a..000000000000
--- a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
+++ /dev/null
@@ -1,100 +0,0 @@
-// SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
-/* Copyright(c) 2015 - 2020 Intel Corporation */
-#include "adf_accel_devices.h"
-#include "adf_common_drv.h"
-#include "adf_pf2vf_msg.h"
-
-/**
- * adf_vf2pf_notify_init() - send init msg to PF
- * @accel_dev:  Pointer to acceleration VF device.
- *
- * Function sends an init message from the VF to a PF
- *
- * Return: 0 on success, error code otherwise.
- */
-int adf_vf2pf_notify_init(struct adf_accel_dev *accel_dev)
-{
-	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
-		(ADF_VF2PF_MSGTYPE_INIT << ADF_VF2PF_MSGTYPE_SHIFT));
-
-	if (adf_send_vf2pf_msg(accel_dev, msg)) {
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to send Init event to PF\n");
-		return -EFAULT;
-	}
-	set_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(adf_vf2pf_notify_init);
-
-/**
- * adf_vf2pf_notify_shutdown() - send shutdown msg to PF
- * @accel_dev:  Pointer to acceleration VF device.
- *
- * Function sends a shutdown message from the VF to a PF
- *
- * Return: void
- */
-void adf_vf2pf_notify_shutdown(struct adf_accel_dev *accel_dev)
-{
-	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
-	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
-
-	if (test_bit(ADF_STATUS_PF_RUNNING, &accel_dev->status))
-		if (adf_send_vf2pf_msg(accel_dev, msg))
-			dev_err(&GET_DEV(accel_dev),
-				"Failed to send Shutdown event to PF\n");
-}
-EXPORT_SYMBOL_GPL(adf_vf2pf_notify_shutdown);
-
-/**
- * adf_recv_pf2vf_msg() - receive a PF to VF message
- * @accel_dev:	Pointer to acceleration device
- *
- * This function allows the VF to receive a message from the PF.
- *
- * Return: a valid message on success, zero otherwise.
- */
-static u32 adf_recv_pf2vf_msg(struct adf_accel_dev *accel_dev)
-{
-	return GET_PFVF_OPS(accel_dev)->recv_msg(accel_dev, 0);
-}
-
-static bool adf_handle_pf2vf_msg(struct adf_accel_dev *accel_dev, u32 msg)
-{
-	switch ((msg & ADF_PF2VF_MSGTYPE_MASK) >> ADF_PF2VF_MSGTYPE_SHIFT) {
-	case ADF_PF2VF_MSGTYPE_RESTARTING:
-		dev_dbg(&GET_DEV(accel_dev),
-			"Restarting msg received from PF 0x%x\n", msg);
-
-		adf_pf2vf_handle_pf_restarting(accel_dev);
-		return false;
-	case ADF_PF2VF_MSGTYPE_VERSION_RESP:
-		dev_dbg(&GET_DEV(accel_dev),
-			"Version resp received from PF 0x%x\n", msg);
-		accel_dev->vf.pf_version =
-			(msg & ADF_PF2VF_VERSION_RESP_VERS_MASK) >>
-			ADF_PF2VF_VERSION_RESP_VERS_SHIFT;
-		accel_dev->vf.compatible =
-			(msg & ADF_PF2VF_VERSION_RESP_RESULT_MASK) >>
-			ADF_PF2VF_VERSION_RESP_RESULT_SHIFT;
-		complete(&accel_dev->vf.iov_msg_completion);
-		return true;
-	default:
-		dev_err(&GET_DEV(accel_dev),
-			"Unknown PF2VF message(0x%x)\n", msg);
-	}
-
-	return false;
-}
-
-bool adf_recv_and_handle_pf2vf_msg(struct adf_accel_dev *accel_dev)
-{
-	u32 msg;
-
-	msg = adf_recv_pf2vf_msg(accel_dev);
-	if (msg)
-		return adf_handle_pf2vf_msg(accel_dev, msg);
-
-	return true;
-}
diff --git a/drivers/crypto/qat/qat_common/adf_vf_isr.c b/drivers/crypto/qat/qat_common/adf_vf_isr.c
index b17040b8a4b9..fe094178f065 100644
--- a/drivers/crypto/qat/qat_common/adf_vf_isr.c
+++ b/drivers/crypto/qat/qat_common/adf_vf_isr.c
@@ -15,7 +15,6 @@
 #include "adf_cfg_common.h"
 #include "adf_transport_access_macros.h"
 #include "adf_transport_internal.h"
-#include "adf_pf2vf_msg.h"
 
 #define ADF_VINTSOU_OFFSET	0x204
 #define ADF_VINTMSK_OFFSET	0x208
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
index 30216a987f72..489a14ca4fef 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_dh895xcc_hw_data.c
@@ -1,10 +1,10 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
-/* Copyright(c) 2014 - 2020 Intel Corporation */
+/* Copyright(c) 2014 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
-#include <adf_pf2vf_msg.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
+#include <adf_pfvf_msg.h>
 #include "adf_dh895xcc_hw_data.h"
 #include "icp_qat_hw.h"
 
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 2e2ef6b5bd2a..d3795bab3725 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -1,10 +1,11 @@
 // SPDX-License-Identifier: (BSD-3-Clause OR GPL-2.0-only)
-/* Copyright(c) 2015 - 2020 Intel Corporation */
+/* Copyright(c) 2015 - 2021 Intel Corporation */
 #include <adf_accel_devices.h>
-#include <adf_pf2vf_msg.h>
 #include <adf_common_drv.h>
 #include <adf_gen2_hw_data.h>
 #include <adf_gen2_pfvf.h>
+#include <adf_pfvf_msg.h>
+#include <adf_pfvf_vf_msg.h>
 #include "adf_dh895xccvf_hw_data.h"
 
 static struct adf_hw_device_class dh895xcciov_class = {
-- 
2.33.1

