From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH 1/3] crypto: qat - move vf2pf_init and vf2pf_exit to common
Date: Fri, 15 Apr 2016 10:37:58 -0700
Message-ID: <1460741880-9479-1-git-send-email-tadeusz.struk@intel.com>
Cc: <tadeusz.struk@intel.com>,
	<sumanx.bangalore.sathyanarayana@intel.com>,
	<linux-crypto@vger.kernel.org>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:61146 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbcDORnP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Apr 2016 13:43:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The vf2pf_init and vf2pf_exit are exactly the same for all VFs
so move them to common and reuse.

Tested-by: Suman Bangalore Sathyanarayana <sumanx.bangalore.sathyanarayana@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 .../crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c   | 23 ------
 drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c | 23 ------
 drivers/crypto/qat/qat_common/Makefile             |  2 +-
 drivers/crypto/qat/qat_common/adf_common_drv.h     | 12 +++
 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c      | 90 ++++++++++++++++++++++
 .../qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c    | 23 ------
 6 files changed, 103 insertions(+), 70 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/adf_vf2pf_msg.c

diff --git a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
index 1af321c..d2d0ae4 100644
--- a/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c3xxxvf/adf_c3xxxvf_hw_data.c
@@ -109,29 +109,6 @@ static void adf_vf_void_noop(struct adf_accel_dev *accel_dev)
 {
 }
 
-static int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
-{
-	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
-		(ADF_VF2PF_MSGTYPE_INIT << ADF_VF2PF_MSGTYPE_SHIFT));
-
-	if (adf_iov_putmsg(accel_dev, msg, 0)) {
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to send Init event to PF\n");
-		return -EFAULT;
-	}
-	return 0;
-}
-
-static void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
-{
-	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
-	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
-
-	if (adf_iov_putmsg(accel_dev, msg, 0))
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to send Shutdown event to PF\n");
-}
-
 void adf_init_hw_data_c3xxxiov(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class = &c3xxxiov_class;
diff --git a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
index baf4b509..38e4bc0 100644
--- a/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
+++ b/drivers/crypto/qat/qat_c62xvf/adf_c62xvf_hw_data.c
@@ -109,29 +109,6 @@ static void adf_vf_void_noop(struct adf_accel_dev *accel_dev)
 {
 }
 
-static int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
-{
-	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
-		(ADF_VF2PF_MSGTYPE_INIT << ADF_VF2PF_MSGTYPE_SHIFT));
-
-	if (adf_iov_putmsg(accel_dev, msg, 0)) {
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to send Init event to PF\n");
-		return -EFAULT;
-	}
-	return 0;
-}
-
-static void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
-{
-	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
-	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
-
-	if (adf_iov_putmsg(accel_dev, msg, 0))
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to send Shutdown event to PF\n");
-}
-
 void adf_init_hw_data_c62xiov(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class = &c62xiov_class;
diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index 29c7c53..5873d22 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -27,4 +27,4 @@ intel_qat-objs := adf_cfg.o \
 	qat_hal.o
 
 intel_qat-$(CONFIG_DEBUG_FS) += adf_transport_debug.o
-intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_pf2vf_msg.o
+intel_qat-$(CONFIG_PCI_IOV) += adf_sriov.o adf_pf2vf_msg.o adf_vf2pf_msg.o
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index fd096ed..a8100a3 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -238,6 +238,9 @@ void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				 uint32_t vf_mask);
 void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
+
+int adf_vf2pf_init(struct adf_accel_dev *accel_dev);
+void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev);
 #else
 static inline int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 {
@@ -255,5 +258,14 @@ static inline void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 static inline void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
 {
 }
+
+static inline int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
+{
+	return 0;
+}
+
+static inline void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
+{
+}
 #endif
 #endif
diff --git a/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
new file mode 100644
index 0000000..5f1d863
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/adf_vf2pf_msg.c
@@ -0,0 +1,90 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2015 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2015 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_pf2vf_msg.h"
+
+/**
+ * adf_vf2pf_init() - send init msg to PF
+ * @accel_dev:  Pointer to acceleration VF device.
+ *
+ * Function sends an init messge from the VF to a PF
+ *
+ * Return: 0 on success, error code otherwise.
+ */
+int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
+{
+	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
+		(ADF_VF2PF_MSGTYPE_INIT << ADF_VF2PF_MSGTYPE_SHIFT));
+
+	if (adf_iov_putmsg(accel_dev, msg, 0)) {
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send Init event to PF\n");
+		return -EFAULT;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(adf_vf2pf_init);
+
+/**
+ * adf_vf2pf_shutdown() - send shutdown msg to PF
+ * @accel_dev:  Pointer to acceleration VF device.
+ *
+ * Function sends a shutdown messge from the VF to a PF
+ *
+ * Return: void
+ */
+void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
+{
+	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
+	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
+
+	if (adf_iov_putmsg(accel_dev, msg, 0))
+		dev_err(&GET_DEV(accel_dev),
+			"Failed to send Shutdown event to PF\n");
+}
+EXPORT_SYMBOL_GPL(adf_vf2pf_shutdown);
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index dc04ab6..a3b4dd8 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -109,29 +109,6 @@ static void adf_vf_void_noop(struct adf_accel_dev *accel_dev)
 {
 }
 
-static int adf_vf2pf_init(struct adf_accel_dev *accel_dev)
-{
-	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
-		(ADF_VF2PF_MSGTYPE_INIT << ADF_VF2PF_MSGTYPE_SHIFT));
-
-	if (adf_iov_putmsg(accel_dev, msg, 0)) {
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to send Init event to PF\n");
-		return -EFAULT;
-	}
-	return 0;
-}
-
-static void adf_vf2pf_shutdown(struct adf_accel_dev *accel_dev)
-{
-	u32 msg = (ADF_VF2PF_MSGORIGIN_SYSTEM |
-	    (ADF_VF2PF_MSGTYPE_SHUTDOWN << ADF_VF2PF_MSGTYPE_SHIFT));
-
-	if (adf_iov_putmsg(accel_dev, msg, 0))
-		dev_err(&GET_DEV(accel_dev),
-			"Failed to send Shutdown event to PF\n");
-}
-
 void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 {
 	hw_data->dev_class = &dh895xcciov_class;
-- 
2.1.4
