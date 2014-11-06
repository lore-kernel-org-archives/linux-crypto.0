From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: [PATCH RFC 3/4] crypto: qat - Add userspace instances
Date: Thu, 06 Nov 2014 11:59:48 -0800
Message-ID: <20141106195948.13328.63754.stgit@tstruk-mobl1>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:33864 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaKFUDl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 15:03:41 -0500
In-Reply-To: <20141106195931.13328.90501.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add code that creates and manages userspace crypto instances.

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_accel_devices.h |   15 +
 drivers/crypto/qat/qat_common/adf_cfg_strings.h   |    1 
 drivers/crypto/qat/qat_common/adf_common_drv.h    |   21 ++
 drivers/crypto/qat/qat_common/qat_crypto.c        |  189 ++++++++++------
 drivers/crypto/qat/qat_common/qat_crypto_user.c   |  251 +++++++++++++++++++++
 drivers/crypto/qat/qat_dh895xcc/adf_drv.c         |   86 -------
 6 files changed, 417 insertions(+), 146 deletions(-)
 create mode 100644 drivers/crypto/qat/qat_common/qat_crypto_user.c

diff --git a/drivers/crypto/qat/qat_common/adf_accel_devices.h b/drivers/crypto/qat/qat_common/adf_accel_devices.h
index 9586e5e..a6d0300 100644
--- a/drivers/crypto/qat/qat_common/adf_accel_devices.h
+++ b/drivers/crypto/qat/qat_common/adf_accel_devices.h
@@ -176,6 +176,18 @@ struct adf_hw_device_data {
 #define GET_MAX_BANKS(accel_dev) (GET_HW_DATA(accel_dev)->num_banks)
 #define GET_MAX_ACCELENGINES(accel_dev) (GET_HW_DATA(accel_dev)->num_engines)
 #define accel_to_pci_dev(accel_ptr) accel_ptr->accel_pci_dev.pci_dev
+#define GET_INST(accel_dev) (&accel_dev->crypto_list)
+#ifdef CONFIG_CRYPTO_DEV_QAT_USERSPACE
+#define GET_USER_INST(accel_dev) (&accel_dev->crypto_user_list)
+#else
+static LIST_HEAD(empty);
+static inline struct list_head *__get_empty_list(void)
+{
+	return &empty;
+}
+
+#define GET_USER_INST(accel_dev) __get_empty_list()
+#endif
 
 struct adf_admin_comms;
 struct icp_qat_fw_loader_handle;
@@ -195,6 +207,9 @@ struct adf_accel_dev {
 	struct adf_fw_loader_data *fw_loader;
 	struct adf_admin_comms *admin;
 	struct list_head crypto_list;
+#ifdef CONFIG_CRYPTO_DEV_QAT_USERSPACE
+	struct list_head crypto_user_list;
+#endif
 	unsigned long status;
 	atomic_t ref_count;
 	struct dentry *debugfs_dir;
diff --git a/drivers/crypto/qat/qat_common/adf_cfg_strings.h b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
index c7ac758..eab645e 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg_strings.h
+++ b/drivers/crypto/qat/qat_common/adf_cfg_strings.h
@@ -49,6 +49,7 @@
 
 #define ADF_GENERAL_SEC "GENERAL"
 #define ADF_KERNEL_SEC "KERNEL"
+#define ADF_USER_SEC "USER"
 #define ADF_ACCEL_SEC "Accelerator"
 #define ADF_NUM_CY "NumberCyInstances"
 #define ADF_NUM_DC "NumberDcInstances"
diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index 5e8f9d4..9a00a07 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -131,7 +131,9 @@ int adf_init_etr_data(struct adf_accel_dev *accel_dev);
 void adf_cleanup_etr_data(struct adf_accel_dev *accel_dev);
 int qat_crypto_register(void);
 int qat_crypto_unregister(void);
-struct qat_crypto_instance *qat_crypto_get_instance_node(int node);
+int qat_crypto_configure_instances(struct adf_accel_dev *accel_dev);
+struct qat_crypto_instance *qat_crypto_get_kernel_instance(void);
+struct qat_crypto_instance *qat_crypto_get_user_instance(void);
 void qat_crypto_put_instance(struct qat_crypto_instance *inst);
 void qat_alg_callback(void *resp);
 int qat_algs_init(void);
@@ -189,4 +191,21 @@ int qat_uclo_wr_all_uimage(struct icp_qat_fw_loader_handle *handle);
 void qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle);
 int qat_uclo_map_uof_obj(struct icp_qat_fw_loader_handle *handle,
 			 void *addr_ptr, int mem_size);
+#ifdef CONFIG_CRYPTO_DEV_QAT_USERSPACE
+int qat_crypto_configure_user_instances(struct adf_accel_dev *accel_dev);
+int qat_crypto_create_user_instances(struct adf_accel_dev *accel_dev);
+void qat_crypto_free_user_instances(struct adf_accel_dev *accel_dev);
+#else
+static inline int qat_crypto_configure_user_instances(struct adf_accel_dev *dev)
+{
+	return 0;
+}
+
+static inline int qat_crypto_create_user_instances(struct adf_accel_dev *dev)
+{
+	return 0;
+}
+
+#define qat_crypto_free_user_instances(dev) do {} while (0)
+#endif
 #endif
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 828f2a6..17a0a0b 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -53,6 +53,7 @@
 #include "adf_cfg_strings.h"
 #include "qat_crypto.h"
 #include "icp_qat_fw.h"
+#include "adf_transport_access_macros.h"
 
 #define SEC ADF_KERNEL_SEC
 
@@ -64,13 +65,14 @@ void qat_crypto_put_instance(struct qat_crypto_instance *inst)
 		adf_dev_put(inst->accel_dev);
 }
 
-static int qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
+static void qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
 {
 	struct qat_crypto_instance *inst;
 	struct list_head *list_ptr, *tmp;
-	int i;
 
 	list_for_each_safe(list_ptr, tmp, &accel_dev->crypto_list) {
+		int i;
+
 		inst = list_entry(list_ptr, struct qat_crypto_instance, list);
 
 		for (i = 0; i < atomic_read(&inst->refctr); i++)
@@ -82,47 +84,60 @@ static int qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
 		if (inst->sym_rx)
 			adf_remove_ring(inst->sym_rx);
 
-		if (inst->pke_tx)
-			adf_remove_ring(inst->pke_tx);
-
-		if (inst->pke_rx)
-			adf_remove_ring(inst->pke_rx);
-
-		if (inst->rnd_tx)
-			adf_remove_ring(inst->rnd_tx);
-
-		if (inst->rnd_rx)
-			adf_remove_ring(inst->rnd_rx);
-
 		list_del(list_ptr);
 		kfree(inst);
 	}
-	return 0;
 }
 
-struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
+static inline int get_current_node(void)
+{
+	return cpu_data(current_thread_info()->cpu).phys_proc_id;
+}
+
+static struct adf_accel_dev *qat_crypto_get_dev_node(void)
 {
 	struct adf_accel_dev *accel_dev = NULL;
-	struct qat_crypto_instance *inst_best = NULL;
 	struct list_head *itr;
+	int node = get_current_node();
 	unsigned long best = ~0;
 
 	list_for_each(itr, adf_devmgr_get_head()) {
-		accel_dev = list_entry(itr, struct adf_accel_dev, list);
-		if ((node == dev_to_node(&GET_DEV(accel_dev)) ||
-			dev_to_node(&GET_DEV(accel_dev)) < 0)
-				&& adf_dev_started(accel_dev))
-			break;
-		accel_dev = NULL;
+		struct adf_accel_dev *accel_dev_curr =
+			list_entry(itr, struct adf_accel_dev, list);
+		unsigned long cur;
+
+		if ((node == dev_to_node(&GET_DEV(accel_dev_curr)) ||
+		     dev_to_node(&GET_DEV(accel_dev_curr)) < 0) &&
+		    adf_dev_started(accel_dev_curr)) {
+			cur = atomic_read(&accel_dev_curr->ref_count);
+			if (best > cur) {
+				accel_dev = accel_dev_curr;
+				best = cur;
+			}
+		}
 	}
 	if (!accel_dev) {
-		pr_err("QAT: Could not find device on node %d\n", node);
+		pr_err("QAT: Could not find a device on node %d\n", node);
 		accel_dev = adf_devmgr_get_first();
 	}
 	if (!accel_dev || !adf_dev_started(accel_dev))
 		return NULL;
 
-	list_for_each(itr, &accel_dev->crypto_list) {
+	return accel_dev;
+}
+
+static struct qat_crypto_instance *qat_crypto_get_instance(bool user)
+{
+	struct adf_accel_dev *accel_dev = qat_crypto_get_dev_node();
+	struct qat_crypto_instance *inst_best = NULL;
+	struct list_head *list, *itr;
+	unsigned long best = ~0;
+
+	if (!accel_dev)
+		return NULL;
+
+	list = user ? GET_USER_INST(accel_dev) : GET_INST(accel_dev);
+	list_for_each(itr, list) {
 		struct qat_crypto_instance *inst;
 		unsigned long cur;
 
@@ -137,7 +152,7 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 		if (atomic_add_return(1, &inst_best->refctr) == 1) {
 			if (adf_dev_get(accel_dev)) {
 				atomic_dec(&inst_best->refctr);
-				pr_err("QAT: Could increment dev refctr\n");
+				pr_err("QAT: Couldn't increment inst refctr\n");
 				return NULL;
 			}
 		}
@@ -145,15 +160,22 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 	return inst_best;
 }
 
+struct qat_crypto_instance *qat_crypto_get_kernel_instance()
+{
+	return qat_crypto_get_instance(false);
+}
+
+struct qat_crypto_instance *qat_crypto_get_user_instance()
+{
+	return qat_crypto_get_instance(true);
+}
+
 static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 {
-	int i;
-	unsigned long bank;
-	unsigned long num_inst, num_msg_sym, num_msg_asym;
-	int msg_size;
-	struct qat_crypto_instance *inst;
 	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
 	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+	unsigned long num_inst;
+	int i;
 
 	INIT_LIST_HEAD(&accel_dev->crypto_list);
 	strlcpy(key, ADF_NUM_CY, sizeof(key));
@@ -165,8 +187,11 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 
 	for (i = 0; i < num_inst; i++) {
-		inst = kzalloc_node(sizeof(*inst), GFP_KERNEL,
-				    dev_to_node(&GET_DEV(accel_dev)));
+		unsigned long bank, num_msg_sym;
+		int msg_size;
+		struct qat_crypto_instance *inst =
+				kzalloc_node(sizeof(*inst), GFP_KERNEL,
+					     dev_to_node(&GET_DEV(accel_dev)));
 		if (!inst)
 			goto err;
 
@@ -187,67 +212,103 @@ static int qat_crypto_create_instances(struct adf_accel_dev *accel_dev)
 		if (kstrtoul(val, 10, &num_msg_sym))
 			goto err;
 		num_msg_sym = num_msg_sym >> 1;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
-		if (adf_cfg_get_param_value(accel_dev, SEC, key, val))
-			goto err;
-
-		if (kstrtoul(val, 10, &num_msg_asym))
-			goto err;
-		num_msg_asym = num_msg_asym >> 1;
-
 		msg_size = ICP_QAT_FW_REQ_DEFAULT_SZ;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
 		if (adf_create_ring(accel_dev, SEC, bank, num_msg_sym,
 				    msg_size, key, NULL, 0, &inst->sym_tx))
 			goto err;
 
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_RND_TX, i);
-		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
-				    msg_size, key, NULL, 0, &inst->rnd_tx))
-			goto err;
-
-		msg_size = msg_size >> 1;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
-		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
-				    msg_size, key, NULL, 0, &inst->pke_tx))
-			goto err;
-
 		msg_size = ICP_QAT_FW_RESP_DEFAULT_SZ;
 		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
 		if (adf_create_ring(accel_dev, SEC, bank, num_msg_sym,
 				    msg_size, key, qat_alg_callback, 0,
 				    &inst->sym_rx))
 			goto err;
+	}
+	return 0;
+err:
+	qat_crypto_free_instances(accel_dev);
+	return -ENOMEM;
+}
 
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_RND_RX, i);
-		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
-				    msg_size, key, qat_alg_callback, 0,
-				    &inst->rnd_rx))
+/**
+ * qat_crypto_configure_instances() - Add instances configuration
+ * @accel_dev:    Pointer to acceleration device
+ *
+ * Function adds the configuration required to create crypto instances.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int qat_crypto_configure_instances(struct adf_accel_dev *accel_dev)
+{
+	int cpus = num_online_cpus();
+	int banks = GET_MAX_BANKS(accel_dev);
+	int i, instances = min(cpus, banks);
+	unsigned long val;
+
+	if (adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC))
+		goto err;
+
+	for (i = 0; i < instances; i++) {
+		char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
+
+		val = i;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						key, (void *)&val, ADF_DEC))
 			goto err;
 
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
-		if (adf_create_ring(accel_dev, SEC, bank, num_msg_asym,
-				    msg_size, key, qat_alg_callback, 0,
-				    &inst->pke_rx))
+		val = ADF_COALESCING_DEF_TIME;
+		snprintf(key, sizeof(key), ADF_ETRMGR_COALESCE_TIMER_FORMAT, i);
+		if (adf_cfg_add_key_value_param(accel_dev, "Accelerator0",
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 512;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 2;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 10;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+						key, (void *)&val, ADF_DEC))
 			goto err;
 	}
+	val = i;
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
+					ADF_NUM_CY, (void *)&val, ADF_DEC))
+		goto err;
 	return 0;
 err:
-	qat_crypto_free_instances(accel_dev);
-	return -ENOMEM;
+	return -EFAULT;
 }
+EXPORT_SYMBOL_GPL(qat_crypto_configure_instances);
 
 static int qat_crypto_init(struct adf_accel_dev *accel_dev)
 {
 	if (qat_crypto_create_instances(accel_dev))
 		return -EFAULT;
-
+	if (qat_crypto_create_user_instances(accel_dev)) {
+		qat_crypto_free_instances(accel_dev);
+		return -EFAULT;
+	}
 	return 0;
 }
 
 static int qat_crypto_shutdown(struct adf_accel_dev *accel_dev)
 {
-	return qat_crypto_free_instances(accel_dev);
+	qat_crypto_free_instances(accel_dev);
+	qat_crypto_free_user_instances(accel_dev);
+	return 0;
 }
 
 static int qat_crypto_event_handler(struct adf_accel_dev *accel_dev,
diff --git a/drivers/crypto/qat/qat_common/qat_crypto_user.c b/drivers/crypto/qat/qat_common/qat_crypto_user.c
new file mode 100644
index 0000000..536702a
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_crypto_user.c
@@ -0,0 +1,251 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
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
+  Copyright(c) 2014 Intel Corporation.
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
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "adf_transport.h"
+#include "adf_cfg.h"
+#include "adf_cfg_strings.h"
+#include "qat_crypto.h"
+#include "icp_qat_fw.h"
+#include "adf_transport_access_macros.h"
+
+#define SECUSR ADF_USER_SEC
+
+void qat_crypto_free_user_instances(struct adf_accel_dev *accel_dev)
+{
+	struct qat_crypto_instance *inst;
+	struct list_head *list_ptr, *tmp;
+
+	list_for_each_safe(list_ptr, tmp, &accel_dev->crypto_user_list) {
+		int i;
+
+		inst = list_entry(list_ptr, struct qat_crypto_instance, list);
+
+		for (i = 0; i < atomic_read(&inst->refctr); i++)
+			qat_crypto_put_instance(inst);
+
+		if (inst->sym_tx)
+			adf_remove_ring(inst->sym_tx);
+
+		if (inst->sym_rx)
+			adf_remove_ring(inst->sym_rx);
+
+		if (inst->pke_tx)
+			adf_remove_ring(inst->pke_tx);
+
+		if (inst->pke_rx)
+			adf_remove_ring(inst->pke_rx);
+
+		list_del(list_ptr);
+		kfree(inst);
+	}
+}
+
+int qat_crypto_create_user_instances(struct adf_accel_dev *accel_dev)
+{
+	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
+	char val[ADF_CFG_MAX_VAL_LEN_IN_BYTES];
+	unsigned long num_inst;
+	int i;
+
+	INIT_LIST_HEAD(&accel_dev->crypto_user_list);
+	strlcpy(key, ADF_NUM_CY, sizeof(key));
+
+	if (adf_cfg_get_param_value(accel_dev, SECUSR, key, val))
+		return -EFAULT;
+
+	if (kstrtoul(val, 0, &num_inst))
+		return -EFAULT;
+
+	for (i = 0; i < num_inst; i++) {
+		unsigned long bank, num_msg_sym, num_msg_asym;
+		int msg_size;
+		struct qat_crypto_instance *inst =
+				kzalloc_node(sizeof(*inst), GFP_KERNEL,
+					     dev_to_node(&GET_DEV(accel_dev)));
+		if (!inst)
+			goto err;
+
+		list_add_tail(&inst->list, &accel_dev->crypto_user_list);
+		inst->id = i;
+		atomic_set(&inst->refctr, 0);
+		inst->accel_dev = accel_dev;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
+		if (adf_cfg_get_param_value(accel_dev, SECUSR, key, val))
+			goto err;
+
+		if (kstrtoul(val, 10, &bank))
+			goto err;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
+		if (adf_cfg_get_param_value(accel_dev, SECUSR, key, val))
+			goto err;
+
+		if (kstrtoul(val, 10, &num_msg_sym))
+			goto err;
+		num_msg_sym = num_msg_sym >> 1;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
+		if (adf_cfg_get_param_value(accel_dev, SECUSR, key, val))
+			goto err;
+
+		if (kstrtoul(val, 10, &num_msg_asym))
+			goto err;
+		num_msg_asym = num_msg_asym >> 1;
+
+		msg_size = ICP_QAT_FW_REQ_DEFAULT_SZ;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
+		if (adf_create_ring(accel_dev, SECUSR, bank, num_msg_sym,
+				    msg_size, key, NULL, 0, &inst->sym_tx))
+			goto err;
+
+		msg_size = msg_size >> 1;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
+		if (adf_create_ring(accel_dev, SECUSR, bank, num_msg_asym,
+				    msg_size, key, NULL, 0, &inst->pke_tx))
+			goto err;
+
+		msg_size = ICP_QAT_FW_RESP_DEFAULT_SZ;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
+		if (adf_create_ring(accel_dev, SECUSR, bank, num_msg_sym,
+				    msg_size, key, qat_user_callback, 0,
+				    &inst->sym_rx))
+			goto err;
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
+		if (adf_create_ring(accel_dev, SECUSR, bank, num_msg_asym,
+				    msg_size, key, qat_user_asym_callback, 0,
+				    &inst->pke_rx))
+			goto err;
+	}
+	return 0;
+err:
+	qat_crypto_free_user_instances(accel_dev);
+	return -ENOMEM;
+}
+
+/**
+ * qat_crypto_configure_user_instances() - Add userspace instances configuration
+ * @accel_dev:    Pointer to acceleration device
+ *
+ * Function adds the configuration required to create user space instances.
+ * To be used by QAT device specific drivers.
+ *
+ * Return: 0 on success, error code othewise.
+ */
+int qat_crypto_configure_user_instances(struct adf_accel_dev *accel_dev)
+{
+	int cpus = num_online_cpus();
+	int banks = GET_MAX_BANKS(accel_dev);
+	int i, instances = min(cpus, banks);
+	unsigned long val;
+
+	if (adf_cfg_section_add(accel_dev, ADF_USER_SEC))
+		goto err;
+
+	for (i = 0; i < instances; i++) {
+		char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
+
+		val = (i + instances) % banks;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_USER_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = ADF_COALESCING_DEF_TIME;
+		snprintf(key, sizeof(key), ADF_ETRMGR_COALESCE_TIMER_FORMAT,
+			 (i + instances) % banks);
+		if (adf_cfg_add_key_value_param(accel_dev, "Accelerator0",
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
+		val = 128;
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_USER_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 512;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_USER_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 1;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_USER_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 3;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_USER_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 9;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_USER_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+
+		val = 11;
+		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
+		if (adf_cfg_add_key_value_param(accel_dev, ADF_USER_SEC,
+						key, (void *)&val, ADF_DEC))
+			goto err;
+	}
+
+	val = i;
+	if (adf_cfg_add_key_value_param(accel_dev, ADF_USER_SEC,
+					ADF_NUM_CY, (void *)&val, ADF_DEC))
+		goto err;
+	return 0;
+err:
+	return -EFAULT;
+}
+EXPORT_SYMBOL_GPL(qat_crypto_configure_user_instances);
diff --git a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
index 948f66b..8df453a 100644
--- a/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
+++ b/drivers/crypto/qat/qat_dh895xcc/adf_drv.c
@@ -60,7 +60,6 @@
 #include <adf_accel_devices.h>
 #include <adf_common_drv.h>
 #include <adf_cfg.h>
-#include <adf_transport_access_macros.h>
 #include "adf_dh895xcc_hw_data.h"
 #include "adf_drv.h"
 
@@ -121,88 +120,13 @@ static void adf_cleanup_accel(struct adf_accel_dev *accel_dev)
 
 static int qat_dev_start(struct adf_accel_dev *accel_dev)
 {
-	int cpus = num_online_cpus();
-	int banks = GET_MAX_BANKS(accel_dev);
-	int instances = min(cpus, banks);
-	char key[ADF_CFG_MAX_KEY_LEN_IN_BYTES];
-	int i;
-	unsigned long val;
-
-	if (adf_cfg_section_add(accel_dev, ADF_KERNEL_SEC))
-		goto err;
 	if (adf_cfg_section_add(accel_dev, "Accelerator0"))
 		goto err;
-	for (i = 0; i < instances; i++) {
-		val = i;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_BANK_NUM, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_ETRMGR_CORE_AFFINITY,
-			 i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_SIZE, i);
-		val = 128;
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = 512;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_SIZE, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = 0;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_TX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = 2;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_TX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = 4;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_RND_TX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = 8;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_ASYM_RX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = 10;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_SYM_RX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = 12;
-		snprintf(key, sizeof(key), ADF_CY "%d" ADF_RING_RND_RX, i);
-		if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-						key, (void *)&val, ADF_DEC))
-			goto err;
-
-		val = ADF_COALESCING_DEF_TIME;
-		snprintf(key, sizeof(key), ADF_ETRMGR_COALESCE_TIMER_FORMAT, i);
-		if (adf_cfg_add_key_value_param(accel_dev, "Accelerator0",
-						key, (void *)&val, ADF_DEC))
-			goto err;
-	}
 
-	val = i;
-	if (adf_cfg_add_key_value_param(accel_dev, ADF_KERNEL_SEC,
-					ADF_NUM_CY, (void *)&val, ADF_DEC))
+	if (qat_crypto_configure_instances(accel_dev))
+		goto err;
+
+	if (qat_crypto_configure_user_instances(accel_dev))
 		goto err;
 
 	set_bit(ADF_STATUS_CONFIGURED, &accel_dev->status);
@@ -239,7 +163,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	accel_dev = kzalloc_node(sizeof(*accel_dev), GFP_KERNEL,
-			         dev_to_node(&pdev->dev));
+				 dev_to_node(&pdev->dev));
 	if (!accel_dev)
 		return -ENOMEM;
 
