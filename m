From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] crypto: qat - use list_for_each_entry*
Date: Wed, 16 Dec 2015 21:37:25 +0800
Message-ID: <3e2d6025c0fc919b4d4c5aa1850b8a224cb4f9e5.1450269229.git.geliangtang@163.com>
Cc: Geliang Tang <geliangtang@163.com>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Allan, Bruce W" <bruce.w.allan@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from m50-132.163.com ([123.125.50.132]:34295 "EHLO m50-132.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333AbbLPNi5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Dec 2015 08:38:57 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Use list_for_each_entry*() instead of list_for_each*() to simplify
the code.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/crypto/qat/qat_common/adf_cfg.c     | 35 +++++++------------
 drivers/crypto/qat/qat_common/adf_ctl_drv.c | 13 +++----
 drivers/crypto/qat/qat_common/adf_dev_mgr.c | 54 +++++++++--------------------
 drivers/crypto/qat/qat_common/adf_init.c    | 24 ++++---------
 drivers/crypto/qat/qat_common/qat_crypto.c  | 28 +++++----------
 5 files changed, 47 insertions(+), 107 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_cfg.c b/drivers/crypto/qat/qat_common/adf_cfg.c
index d087979..01f6051 100644
--- a/drivers/crypto/qat/qat_common/adf_cfg.c
+++ b/drivers/crypto/qat/qat_common/adf_cfg.c
@@ -64,16 +64,13 @@ static void *qat_dev_cfg_start(struct seq_file *sfile, loff_t *pos)
 
 static int qat_dev_cfg_show(struct seq_file *sfile, void *v)
 {
-	struct list_head *list;
+	struct adf_cfg_key_val *ptr;
 	struct adf_cfg_section *sec =
 				list_entry(v, struct adf_cfg_section, list);
 
 	seq_printf(sfile, "[%s]\n", sec->name);
-	list_for_each(list, &sec->param_head) {
-		struct adf_cfg_key_val *ptr =
-			list_entry(list, struct adf_cfg_key_val, list);
+	list_for_each_entry(ptr, &sec->param_head, list)
 		seq_printf(sfile, "%s = %s\n", ptr->key, ptr->val);
-	}
 	return 0;
 }
 
@@ -198,25 +195,21 @@ static void adf_cfg_keyval_add(struct adf_cfg_key_val *new,
 
 static void adf_cfg_keyval_del_all(struct list_head *head)
 {
-	struct list_head *list_ptr, *tmp;
+	struct adf_cfg_key_val *ptr, *tmp;
 
-	list_for_each_prev_safe(list_ptr, tmp, head) {
-		struct adf_cfg_key_val *ptr =
-			list_entry(list_ptr, struct adf_cfg_key_val, list);
-		list_del(list_ptr);
+	list_for_each_entry_safe_reverse(ptr, tmp, head, list) {
+		list_del(&ptr->list);
 		kfree(ptr);
 	}
 }
 
 static void adf_cfg_section_del_all(struct list_head *head)
 {
-	struct adf_cfg_section *ptr;
-	struct list_head *list, *tmp;
+	struct adf_cfg_section *ptr, *tmp;
 
-	list_for_each_prev_safe(list, tmp, head) {
-		ptr = list_entry(list, struct adf_cfg_section, list);
+	list_for_each_entry_safe_reverse(ptr, tmp, head, list) {
 		adf_cfg_keyval_del_all(&ptr->param_head);
-		list_del(list);
+		list_del(&ptr->list);
 		kfree(ptr);
 	}
 }
@@ -224,11 +217,9 @@ static void adf_cfg_section_del_all(struct list_head *head)
 static struct adf_cfg_key_val *adf_cfg_key_value_find(struct adf_cfg_section *s,
 						      const char *key)
 {
-	struct list_head *list;
+	struct adf_cfg_key_val *ptr;
 
-	list_for_each(list, &s->param_head) {
-		struct adf_cfg_key_val *ptr =
-			list_entry(list, struct adf_cfg_key_val, list);
+	list_for_each_entry(ptr, &s->param_head, list) {
 		if (!strcmp(ptr->key, key))
 			return ptr;
 	}
@@ -239,11 +230,9 @@ static struct adf_cfg_section *adf_cfg_sec_find(struct adf_accel_dev *accel_dev,
 						const char *sec_name)
 {
 	struct adf_cfg_device_data *cfg = accel_dev->cfg;
-	struct list_head *list;
+	struct adf_cfg_section *ptr;
 
-	list_for_each(list, &cfg->sec_list) {
-		struct adf_cfg_section *ptr =
-			list_entry(list, struct adf_cfg_section, list);
+	list_for_each_entry(ptr, &cfg->sec_list, list) {
 		if (!strcmp(ptr->name, sec_name))
 			return ptr;
 	}
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index 2e6d0c5..5c897e6 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -255,12 +255,9 @@ out:
 
 static int adf_ctl_is_device_in_use(int id)
 {
-	struct list_head *itr, *head = adf_devmgr_get_head();
-
-	list_for_each(itr, head) {
-		struct adf_accel_dev *dev =
-				list_entry(itr, struct adf_accel_dev, list);
+	struct adf_accel_dev *dev;
 
+	list_for_each_entry(dev, adf_devmgr_get_head(), list) {
 		if (id == dev->accel_id || id == ADF_CFG_ALL_DEVICES) {
 			if (adf_devmgr_in_reset(dev) || adf_dev_in_use(dev)) {
 				dev_info(&GET_DEV(dev),
@@ -275,12 +272,10 @@ static int adf_ctl_is_device_in_use(int id)
 
 static int adf_ctl_stop_devices(uint32_t id)
 {
-	struct list_head *itr, *head = adf_devmgr_get_head();
+	struct adf_accel_dev *accel_dev;
 	int ret = 0;
 
-	list_for_each_prev(itr, head) {
-		struct adf_accel_dev *accel_dev =
-				list_entry(itr, struct adf_accel_dev, list);
+	list_for_each_entry_reverse(accel_dev, adf_devmgr_get_head(), list) {
 		if (id == accel_dev->accel_id || id == ADF_CFG_ALL_DEVICES) {
 			if (!adf_dev_started(accel_dev))
 				continue;
diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index b3ebb25..259a9e6 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
@@ -77,12 +77,9 @@ static int adf_get_vf_num(struct adf_accel_dev *vf)
 
 static struct vf_id_map *adf_find_vf(u32 bdf)
 {
-	struct list_head *itr;
-
-	list_for_each(itr, &vfs_table) {
-		struct vf_id_map *ptr =
-			list_entry(itr, struct vf_id_map, list);
+	struct vf_id_map *ptr;
 
+	list_for_each_entry(ptr, &vfs_table, list) {
 		if (ptr->bdf == bdf)
 			return ptr;
 	}
@@ -91,11 +88,9 @@ static struct vf_id_map *adf_find_vf(u32 bdf)
 
 static int adf_get_vf_real_id(u32 fake)
 {
-	struct list_head *itr;
+	struct vf_id_map *ptr;
 
-	list_for_each(itr, &vfs_table) {
-		struct vf_id_map *ptr =
-			list_entry(itr, struct vf_id_map, list);
+	list_for_each_entry(ptr, &vfs_table, list) {
 		if (ptr->fake_id == fake)
 			return ptr->id;
 	}
@@ -111,12 +106,10 @@ static int adf_get_vf_real_id(u32 fake)
  */
 void adf_clean_vf_map(bool vf)
 {
-	struct vf_id_map *map;
-	struct list_head *ptr, *tmp;
+	struct vf_id_map *map, *tmp;
 
 	mutex_lock(&table_lock);
-	list_for_each_safe(ptr, tmp, &vfs_table) {
-		map = list_entry(ptr, struct vf_id_map, list);
+	list_for_each_entry_safe(map, tmp, &vfs_table, list) {
 		if (map->bdf != -1) {
 			id_map[map->id] = 0;
 			num_devices--;
@@ -125,7 +118,7 @@ void adf_clean_vf_map(bool vf)
 		if (vf && map->bdf == -1)
 			continue;
 
-		list_del(ptr);
+		list_del(&map->list);
 		kfree(map);
 	}
 	mutex_unlock(&table_lock);
@@ -141,13 +134,10 @@ EXPORT_SYMBOL_GPL(adf_clean_vf_map);
 void adf_devmgr_update_class_index(struct adf_hw_device_data *hw_data)
 {
 	struct adf_hw_device_class *class = hw_data->dev_class;
-	struct list_head *itr;
+	struct adf_accel_dev *ptr;
 	int i = 0;
 
-	list_for_each(itr, &accel_table) {
-		struct adf_accel_dev *ptr =
-				list_entry(itr, struct adf_accel_dev, list);
-
+	list_for_each_entry(ptr, &accel_table, list) {
 		if (ptr->hw_device->dev_class == class)
 			ptr->hw_device->instance_id = i++;
 
@@ -183,7 +173,6 @@ static unsigned int adf_find_free_id(void)
 int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 		       struct adf_accel_dev *pf)
 {
-	struct list_head *itr;
 	int ret = 0;
 
 	if (num_devices == ADF_MAX_DEVICES) {
@@ -198,11 +187,9 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 	/* PF on host or VF on guest */
 	if (!accel_dev->is_vf || (accel_dev->is_vf && !pf)) {
 		struct vf_id_map *map;
+		struct adf_accel_dev *ptr;
 
-		list_for_each(itr, &accel_table) {
-			struct adf_accel_dev *ptr =
-				list_entry(itr, struct adf_accel_dev, list);
-
+		list_for_each_entry(ptr, &accel_table, list) {
 			if (ptr == accel_dev) {
 				ret = -EEXIST;
 				goto unlock;
@@ -341,13 +328,10 @@ struct adf_accel_dev *adf_devmgr_get_first(void)
  */
 struct adf_accel_dev *adf_devmgr_pci_to_accel_dev(struct pci_dev *pci_dev)
 {
-	struct list_head *itr;
+	struct adf_accel_dev *ptr;
 
 	mutex_lock(&table_lock);
-	list_for_each(itr, &accel_table) {
-		struct adf_accel_dev *ptr =
-				list_entry(itr, struct adf_accel_dev, list);
-
+	list_for_each_entry(ptr, &accel_table, list) {
 		if (ptr->accel_pci_dev.pci_dev == pci_dev) {
 			mutex_unlock(&table_lock);
 			return ptr;
@@ -360,7 +344,7 @@ EXPORT_SYMBOL_GPL(adf_devmgr_pci_to_accel_dev);
 
 struct adf_accel_dev *adf_devmgr_get_dev_by_id(uint32_t id)
 {
-	struct list_head *itr;
+	struct adf_accel_dev *ptr;
 	int real_id;
 
 	mutex_lock(&table_lock);
@@ -370,9 +354,7 @@ struct adf_accel_dev *adf_devmgr_get_dev_by_id(uint32_t id)
 
 	id = real_id;
 
-	list_for_each(itr, &accel_table) {
-		struct adf_accel_dev *ptr =
-				list_entry(itr, struct adf_accel_dev, list);
+	list_for_each_entry(ptr, &accel_table, list) {
 		if (ptr->accel_id == id) {
 			mutex_unlock(&table_lock);
 			return ptr;
@@ -396,13 +378,11 @@ int adf_devmgr_verify_id(uint32_t id)
 
 static int adf_get_num_dettached_vfs(void)
 {
-	struct list_head *itr;
+	struct vf_id_map *ptr;
 	int vfs = 0;
 
 	mutex_lock(&table_lock);
-	list_for_each(itr, &vfs_table) {
-		struct vf_id_map *ptr =
-			list_entry(itr, struct vf_id_map, list);
+	list_for_each_entry(ptr, &vfs_table, list) {
 		if (ptr->bdf != ~0 && !ptr->attached)
 			vfs++;
 	}
diff --git a/drivers/crypto/qat/qat_common/adf_init.c b/drivers/crypto/qat/qat_common/adf_init.c
index ef5575e..91c2dea 100644
--- a/drivers/crypto/qat/qat_common/adf_init.c
+++ b/drivers/crypto/qat/qat_common/adf_init.c
@@ -99,7 +99,6 @@ int adf_service_unregister(struct service_hndl *service)
 int adf_dev_init(struct adf_accel_dev *accel_dev)
 {
 	struct service_hndl *service;
-	struct list_head *list_itr;
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 
 	if (!hw_data) {
@@ -155,8 +154,7 @@ int adf_dev_init(struct adf_accel_dev *accel_dev)
 	 * This is to facilitate any ordering dependencies between services
 	 * prior to starting any of the accelerators.
 	 */
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
+	list_for_each_entry(service, &service_table, list) {
 		if (service->event_hld(accel_dev, ADF_EVENT_INIT)) {
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to initialise service %s\n",
@@ -187,7 +185,6 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct service_hndl *service;
-	struct list_head *list_itr;
 
 	set_bit(ADF_STATUS_STARTING, &accel_dev->status);
 
@@ -202,8 +199,7 @@ int adf_dev_start(struct adf_accel_dev *accel_dev)
 		return -EFAULT;
 	}
 
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
+	list_for_each_entry(service, &service_table, list) {
 		if (service->event_hld(accel_dev, ADF_EVENT_START)) {
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to start service %s\n",
@@ -241,7 +237,6 @@ EXPORT_SYMBOL_GPL(adf_dev_start);
 int adf_dev_stop(struct adf_accel_dev *accel_dev)
 {
 	struct service_hndl *service;
-	struct list_head *list_itr;
 	bool wait = false;
 	int ret;
 
@@ -257,8 +252,7 @@ int adf_dev_stop(struct adf_accel_dev *accel_dev)
 		qat_asym_algs_unregister();
 	}
 
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
+	list_for_each_entry(service, &service_table, list) {
 		if (!test_bit(accel_dev->accel_id, &service->start_status))
 			continue;
 		ret = service->event_hld(accel_dev, ADF_EVENT_STOP);
@@ -295,7 +289,6 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 {
 	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
 	struct service_hndl *service;
-	struct list_head *list_itr;
 
 	if (!hw_data) {
 		dev_err(&GET_DEV(accel_dev),
@@ -317,8 +310,7 @@ void adf_dev_shutdown(struct adf_accel_dev *accel_dev)
 				  &accel_dev->status);
 	}
 
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
+	list_for_each_entry(service, &service_table, list) {
 		if (!test_bit(accel_dev->accel_id, &service->init_status))
 			continue;
 		if (service->event_hld(accel_dev, ADF_EVENT_SHUTDOWN))
@@ -353,10 +345,8 @@ EXPORT_SYMBOL_GPL(adf_dev_shutdown);
 int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
 {
 	struct service_hndl *service;
-	struct list_head *list_itr;
 
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
+	list_for_each_entry(service, &service_table, list) {
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTING))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to restart service %s.\n",
@@ -368,10 +358,8 @@ int adf_dev_restarting_notify(struct adf_accel_dev *accel_dev)
 int adf_dev_restarted_notify(struct adf_accel_dev *accel_dev)
 {
 	struct service_hndl *service;
-	struct list_head *list_itr;
 
-	list_for_each(list_itr, &service_table) {
-		service = list_entry(list_itr, struct service_hndl, list);
+	list_for_each_entry(service, &service_table, list) {
 		if (service->event_hld(accel_dev, ADF_EVENT_RESTARTED))
 			dev_err(&GET_DEV(accel_dev),
 				"Failed to restart service %s.\n",
diff --git a/drivers/crypto/qat/qat_common/qat_crypto.c b/drivers/crypto/qat/qat_common/qat_crypto.c
index 4d0c65b..3852d31 100644
--- a/drivers/crypto/qat/qat_common/qat_crypto.c
+++ b/drivers/crypto/qat/qat_common/qat_crypto.c
@@ -67,13 +67,10 @@ void qat_crypto_put_instance(struct qat_crypto_instance *inst)
 
 static int qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
 {
-	struct qat_crypto_instance *inst;
-	struct list_head *list_ptr, *tmp;
+	struct qat_crypto_instance *inst, *tmp;
 	int i;
 
-	list_for_each_safe(list_ptr, tmp, &accel_dev->crypto_list) {
-		inst = list_entry(list_ptr, struct qat_crypto_instance, list);
-
+	list_for_each_entry_safe(inst, tmp, &accel_dev->crypto_list, list) {
 		for (i = 0; i < atomic_read(&inst->refctr); i++)
 			qat_crypto_put_instance(inst);
 
@@ -89,7 +86,7 @@ static int qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
 		if (inst->pke_rx)
 			adf_remove_ring(inst->pke_rx);
 
-		list_del(list_ptr);
+		list_del(&inst->list);
 		kfree(inst);
 	}
 	return 0;
@@ -97,17 +94,13 @@ static int qat_crypto_free_instances(struct adf_accel_dev *accel_dev)
 
 struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 {
-	struct adf_accel_dev *accel_dev = NULL;
-	struct qat_crypto_instance *inst = NULL;
-	struct list_head *itr;
+	struct adf_accel_dev *accel_dev = NULL, *tmp_dev;
+	struct qat_crypto_instance *inst = NULL, *tmp_inst;
 	unsigned long best = ~0;
 
-	list_for_each(itr, adf_devmgr_get_head()) {
-		struct adf_accel_dev *tmp_dev;
+	list_for_each_entry(tmp_dev, adf_devmgr_get_head(), list) {
 		unsigned long ctr;
 
-		tmp_dev = list_entry(itr, struct adf_accel_dev, list);
-
 		if ((node == dev_to_node(&GET_DEV(tmp_dev)) ||
 		     dev_to_node(&GET_DEV(tmp_dev)) < 0) &&
 		    adf_dev_started(tmp_dev) &&
@@ -123,10 +116,7 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 	if (!accel_dev) {
 		pr_info("QAT: Could not find a device on node %d\n", node);
 		/* Get any started device */
-		list_for_each(itr, adf_devmgr_get_head()) {
-			struct adf_accel_dev *tmp_dev;
-
-			tmp_dev = list_entry(itr, struct adf_accel_dev, list);
+		list_for_each_entry(tmp_dev, adf_devmgr_get_head(), list) {
 			if (adf_dev_started(tmp_dev) &&
 			    !list_empty(&tmp_dev->crypto_list)) {
 				accel_dev = tmp_dev;
@@ -139,11 +129,9 @@ struct qat_crypto_instance *qat_crypto_get_instance_node(int node)
 		return NULL;
 
 	best = ~0;
-	list_for_each(itr, &accel_dev->crypto_list) {
-		struct qat_crypto_instance *tmp_inst;
+	list_for_each_entry(tmp_inst, &accel_dev->crypto_list, list) {
 		unsigned long ctr;
 
-		tmp_inst = list_entry(itr, struct qat_crypto_instance, list);
 		ctr = atomic_read(&tmp_inst->refctr);
 		if (best > ctr) {
 			inst = tmp_inst;
-- 
2.5.0
