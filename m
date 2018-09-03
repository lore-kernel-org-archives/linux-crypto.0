From: Kenneth Lee <nek.in.cn@gmail.com>
Subject: [PATCH 3/7] vfio: add sdmdev support
Date: Mon,  3 Sep 2018 08:52:00 +0800
Message-ID: <20180903005204.26041-4-nek.in.cn@gmail.com>
References: <20180903005204.26041-1-nek.in.cn@gmail.com>
Cc: linuxarm@huawei.com
To: Jonathan Corbet <corbet@lwn.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, linux-accelerators@lists.ozlabs.org,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180903005204.26041-1-nek.in.cn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Kenneth Lee <liguozhu@hisilicon.com>

SDMDEV is "Share Domain Mdev". It is a vfio-mdev. But differ from
the general vfio-mdev, it shares its parent's IOMMU. If Multi-PASID
support is enabled in the IOMMU (not yet in the current kernel HEAD),
multiple process can share the IOMMU by different PASID. If it is not
support, only one process can share the IOMMU with the kernel driver.

Currently only the vfio type-1 driver is updated to make it to be aware
of.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/vfio/Kconfig              |   1 +
 drivers/vfio/Makefile             |   1 +
 drivers/vfio/sdmdev/Kconfig       |  10 +
 drivers/vfio/sdmdev/Makefile      |   3 +
 drivers/vfio/sdmdev/vfio_sdmdev.c | 363 ++++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c   | 151 ++++++++++++-
 include/linux/vfio_sdmdev.h       |  96 ++++++++
 include/uapi/linux/vfio_sdmdev.h  |  29 +++
 8 files changed, 648 insertions(+), 6 deletions(-)
 create mode 100644 drivers/vfio/sdmdev/Kconfig
 create mode 100644 drivers/vfio/sdmdev/Makefile
 create mode 100644 drivers/vfio/sdmdev/vfio_sdmdev.c
 create mode 100644 include/linux/vfio_sdmdev.h
 create mode 100644 include/uapi/linux/vfio_sdmdev.h

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index c84333eb5eb5..5af7d1db505e 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -47,4 +47,5 @@ menuconfig VFIO_NOIOMMU
 source "drivers/vfio/pci/Kconfig"
 source "drivers/vfio/platform/Kconfig"
 source "drivers/vfio/mdev/Kconfig"
+source "drivers/vfio/sdmdev/Kconfig"
 source "virt/lib/Kconfig"
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index de67c4725cce..678592360a7a 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
 obj-$(CONFIG_VFIO_PCI) += pci/
 obj-$(CONFIG_VFIO_PLATFORM) += platform/
 obj-$(CONFIG_VFIO_MDEV) += mdev/
+obj-$(CONFIG_VFIO_SDMDEV) += sdmdev/
diff --git a/drivers/vfio/sdmdev/Kconfig b/drivers/vfio/sdmdev/Kconfig
new file mode 100644
index 000000000000..51474272870d
--- /dev/null
+++ b/drivers/vfio/sdmdev/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+config VFIO_SDMDEV
+	tristate "Support for Share Domain MDEV"
+	depends on VFIO_MDEV_DEVICE
+	help
+	  Support for VFIO Share Domain MDEV, which enables the kernel to
+	  support light weight hardware accelerator framework, WarpDrive.
+
+	  To compile this as a module, choose M here: the module will be called
+	  sdmdev.
diff --git a/drivers/vfio/sdmdev/Makefile b/drivers/vfio/sdmdev/Makefile
new file mode 100644
index 000000000000..ccaaa03f3184
--- /dev/null
+++ b/drivers/vfio/sdmdev/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+sdmdev-y := sdmdev.o
+obj-$(CONFIG_VFIO_SDMDEV) += vfio_sdmdev.o
diff --git a/drivers/vfio/sdmdev/vfio_sdmdev.c b/drivers/vfio/sdmdev/vfio_sdmdev.c
new file mode 100644
index 000000000000..c6eb5d4bdab0
--- /dev/null
+++ b/drivers/vfio/sdmdev/vfio_sdmdev.c
@@ -0,0 +1,363 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include <linux/module.h>
+#include <linux/vfio_sdmdev.h>
+
+static struct class *sdmdev_class;
+
+static int vfio_sdmdev_dev_exist(struct device *dev, void *data)
+{
+	return !strcmp(dev_name(dev), dev_name((struct device *)data));
+}
+
+#ifdef CONFIG_IOMMU_SVA
+static bool vfio_sdmdev_is_valid_pasid(int pasid)
+{
+	struct mm_struct *mm;
+
+	mm = iommu_sva_find(pasid);
+	if (mm) {
+		mmput(mm);
+		return mm == current->mm;
+	}
+
+	return false;
+}
+#endif
+
+/* Check if the device is a mediated device belongs to vfio_sdmdev */
+int vfio_sdmdev_is_sdmdev(struct device *dev)
+{
+	struct mdev_device *mdev;
+	struct device *pdev;
+
+	mdev = mdev_from_dev(dev);
+	if (!mdev)
+		return 0;
+
+	pdev = mdev_parent_dev(mdev);
+	if (!pdev)
+		return 0;
+
+	return class_for_each_device(sdmdev_class, NULL, pdev,
+			vfio_sdmdev_dev_exist);
+}
+EXPORT_SYMBOL_GPL(vfio_sdmdev_is_sdmdev);
+
+struct vfio_sdmdev *vfio_sdmdev_pdev_sdmdev(struct device *dev)
+{
+	struct device *class_dev;
+
+	if (!dev)
+		return ERR_PTR(-EINVAL);
+
+	class_dev = class_find_device(sdmdev_class, NULL, dev,
+		(int(*)(struct device *, const void *))vfio_sdmdev_dev_exist);
+	if (!class_dev)
+		return ERR_PTR(-ENODEV);
+
+	return container_of(class_dev, struct vfio_sdmdev, cls_dev);
+}
+EXPORT_SYMBOL_GPL(vfio_sdmdev_pdev_sdmdev);
+
+struct vfio_sdmdev *mdev_sdmdev(struct mdev_device *mdev)
+{
+	struct device *pdev = mdev_parent_dev(mdev);
+
+	return vfio_sdmdev_pdev_sdmdev(pdev);
+}
+EXPORT_SYMBOL_GPL(mdev_sdmdev);
+
+static ssize_t iommu_type_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct vfio_sdmdev *sdmdev = vfio_sdmdev_pdev_sdmdev(dev);
+
+	if (!sdmdev)
+		return -ENODEV;
+
+	return sprintf(buf, "%d\n", sdmdev->iommu_type);
+}
+
+static DEVICE_ATTR_RO(iommu_type);
+
+static ssize_t dma_flag_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct vfio_sdmdev *sdmdev = vfio_sdmdev_pdev_sdmdev(dev);
+
+	if (!sdmdev)
+		return -ENODEV;
+
+	return sprintf(buf, "%d\n", sdmdev->dma_flag);
+}
+
+static DEVICE_ATTR_RO(dma_flag);
+
+/* mdev->dev_attr_groups */
+static struct attribute *vfio_sdmdev_attrs[] = {
+	&dev_attr_iommu_type.attr,
+	&dev_attr_dma_flag.attr,
+	NULL,
+};
+static const struct attribute_group vfio_sdmdev_group = {
+	.name  = VFIO_SDMDEV_PDEV_ATTRS_GRP_NAME,
+	.attrs = vfio_sdmdev_attrs,
+};
+const struct attribute_group *vfio_sdmdev_groups[] = {
+	&vfio_sdmdev_group,
+	NULL,
+};
+
+/* default attributes for mdev->supported_type_groups, used by registerer*/
+#define MDEV_TYPE_ATTR_RO_EXPORT(name) \
+		MDEV_TYPE_ATTR_RO(name); \
+		EXPORT_SYMBOL_GPL(mdev_type_attr_##name);
+
+#define DEF_SIMPLE_SDMDEV_ATTR(_name, sdmdev_member, format) \
+static ssize_t _name##_show(struct kobject *kobj, struct device *dev, \
+			    char *buf) \
+{ \
+	struct vfio_sdmdev *sdmdev = vfio_sdmdev_pdev_sdmdev(dev); \
+	if (!sdmdev) \
+		return -ENODEV; \
+	return sprintf(buf, format, sdmdev->sdmdev_member); \
+} \
+MDEV_TYPE_ATTR_RO_EXPORT(_name)
+
+DEF_SIMPLE_SDMDEV_ATTR(flags, flags, "%d");
+DEF_SIMPLE_SDMDEV_ATTR(name, name, "%s"); /* this should be algorithm name, */
+		/* but you would not care if you have only one algorithm */
+DEF_SIMPLE_SDMDEV_ATTR(device_api, api_ver, "%s");
+
+static ssize_t
+available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	struct vfio_sdmdev *sdmdev = vfio_sdmdev_pdev_sdmdev(dev);
+	int nr_inst = 0;
+
+	nr_inst = sdmdev->ops->get_available_instances ?
+		sdmdev->ops->get_available_instances(sdmdev) : 0;
+	return sprintf(buf, "%d", nr_inst);
+}
+MDEV_TYPE_ATTR_RO_EXPORT(available_instances);
+
+static int vfio_sdmdev_mdev_create(struct kobject *kobj,
+	struct mdev_device *mdev)
+{
+	struct device *pdev = mdev_parent_dev(mdev);
+	struct vfio_sdmdev_queue *q;
+	struct vfio_sdmdev *sdmdev = mdev_sdmdev(mdev);
+	int ret;
+
+	if (!sdmdev->ops->get_queue)
+		return -ENODEV;
+
+	ret = sdmdev->ops->get_queue(sdmdev, &q);
+	if (ret)
+		return ret;
+
+	q->sdmdev = sdmdev;
+	q->mdev = mdev;
+	init_waitqueue_head(&q->wait);
+
+	mdev_set_drvdata(mdev, q);
+	get_device(pdev);
+
+	return 0;
+}
+
+static int vfio_sdmdev_mdev_remove(struct mdev_device *mdev)
+{
+	struct vfio_sdmdev_queue *q =
+		(struct vfio_sdmdev_queue *)mdev_get_drvdata(mdev);
+	struct vfio_sdmdev *sdmdev = q->sdmdev;
+	struct device *pdev = mdev_parent_dev(mdev);
+
+	put_device(pdev);
+
+	if (sdmdev->ops->put_queue);
+		sdmdev->ops->put_queue(q);
+
+	return 0;
+}
+
+/* Wake up the process who is waiting this queue */
+void vfio_sdmdev_wake_up(struct vfio_sdmdev_queue *q)
+{
+	wake_up_all(&q->wait);
+}
+EXPORT_SYMBOL_GPL(vfio_sdmdev_wake_up);
+
+static int vfio_sdmdev_mdev_mmap(struct mdev_device *mdev,
+				 struct vm_area_struct *vma)
+{
+	struct vfio_sdmdev_queue *q =
+		(struct vfio_sdmdev_queue *)mdev_get_drvdata(mdev);
+	struct vfio_sdmdev *sdmdev = q->sdmdev;
+
+	if (sdmdev->ops->mmap)
+		return sdmdev->ops->mmap(q, vma);
+
+	dev_err(sdmdev->dev, "no driver mmap!\n");
+	return -EINVAL;
+}
+
+static inline int vfio_sdmdev_wait(struct vfio_sdmdev_queue *q,
+				   unsigned long timeout)
+{
+	int ret;
+	struct vfio_sdmdev *sdmdev = q->sdmdev;
+
+	if (!sdmdev->ops->mask_notify)
+		return -ENODEV;
+
+	sdmdev->ops->mask_notify(q, VFIO_SDMDEV_EVENT_Q_UPDATE);
+
+	ret = timeout ?  wait_event_interruptible_timeout(q->wait,
+			sdmdev->ops->is_q_updated(q), timeout) :
+		     wait_event_interruptible(q->wait,
+			sdmdev->ops->is_q_updated(q));
+
+	sdmdev->ops->mask_notify(q, 0);
+
+	return ret;
+}
+
+static long vfio_sdmdev_mdev_ioctl(struct mdev_device *mdev, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct vfio_sdmdev_queue *q =
+		(struct vfio_sdmdev_queue *)mdev_get_drvdata(mdev);
+	struct vfio_sdmdev *sdmdev = q->sdmdev;
+
+	switch (cmd) {
+	case VFIO_SDMDEV_CMD_WAIT:
+		return vfio_sdmdev_wait(q, arg);
+
+#ifdef CONFIG_IOMMU_SVA
+	case VFIO_SDMDEV_CMD_BIND_PASID:
+		int ret;
+
+		if (!vfio_sdmdev_is_valid_pasid(arg))
+			return -EINVAL;
+
+		mutex_lock(&q->mutex);
+		q->pasid = arg;
+
+		if (sdmdev->ops->start_queue)
+			ret = sdmdev->ops->start_queue(q);
+
+		mutex_unlock(&q->mutex);
+
+		return ret;
+#endif
+
+	default:
+		if (sdmdev->ops->ioctl)
+			return sdmdev->ops->ioctl(q, cmd, arg);
+
+		dev_err(sdmdev->dev, "ioctl cmd (%d) is not supported!\n", cmd);
+		return -EINVAL;
+	}
+}
+
+static void vfio_sdmdev_release(struct device *dev) { }
+
+static void vfio_sdmdev_mdev_release(struct mdev_device *mdev)
+{
+	struct vfio_sdmdev_queue *q =
+		(struct vfio_sdmdev_queue *)mdev_get_drvdata(mdev);
+	struct vfio_sdmdev *sdmdev = q->sdmdev;
+
+	if (sdmdev->ops->stop_queue)
+		sdmdev->ops->stop_queue(q);
+}
+
+static int vfio_sdmdev_mdev_open(struct mdev_device *mdev)
+{
+#ifndef CONFIG_IOMMU_SVA
+	struct vfio_sdmdev_queue *q =
+		(struct vfio_sdmdev_queue *)mdev_get_drvdata(mdev);
+	struct vfio_sdmdev *sdmdev = q->sdmdev;
+
+	if (sdmdev->ops->start_queue)
+		sdmdev->ops->start_queue(q);
+#endif
+
+	return 0;
+}
+
+/**
+ *	vfio_sdmdev_register - register a sdmdev
+ *	@sdmdev: device structure
+ */
+int vfio_sdmdev_register(struct vfio_sdmdev *sdmdev)
+{
+	int ret;
+
+	if (!sdmdev->dev)
+		return -ENODEV;
+
+	atomic_set(&sdmdev->ref, 0);
+	sdmdev->cls_dev.parent = sdmdev->dev;
+	sdmdev->cls_dev.class = sdmdev_class;
+	sdmdev->cls_dev.release = vfio_sdmdev_release;
+	dev_set_name(&sdmdev->cls_dev, "%s", dev_name(sdmdev->dev));
+	ret = device_register(&sdmdev->cls_dev);
+	if (ret)
+		goto err;
+
+	sdmdev->mdev_fops.owner			= THIS_MODULE;
+	sdmdev->mdev_fops.dev_attr_groups	= vfio_sdmdev_groups;
+	WARN_ON(!sdmdev->mdev_fops.supported_type_groups);
+	sdmdev->mdev_fops.create		= vfio_sdmdev_mdev_create;
+	sdmdev->mdev_fops.remove		= vfio_sdmdev_mdev_remove;
+	sdmdev->mdev_fops.ioctl			= vfio_sdmdev_mdev_ioctl;
+	sdmdev->mdev_fops.open			= vfio_sdmdev_mdev_open;
+	sdmdev->mdev_fops.release		= vfio_sdmdev_mdev_release;
+	sdmdev->mdev_fops.mmap			= vfio_sdmdev_mdev_mmap,
+
+	ret = mdev_register_device(sdmdev->dev, &sdmdev->mdev_fops);
+	if (ret)
+		goto err_with_cls_dev;
+
+	return 0;
+
+err_with_cls_dev:
+	device_unregister(&sdmdev->cls_dev);
+err:
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_sdmdev_register);
+
+/**
+ * vfio_sdmdev_unregister - unregisters a sdmdev
+ * @sdmdev: device to unregister
+ *
+ * Unregister a sdmdev that wat previously successully registered with
+ * vfio_sdmdev_register().
+ */
+void vfio_sdmdev_unregister(struct vfio_sdmdev *sdmdev)
+{
+	mdev_unregister_device(sdmdev->dev);
+	device_unregister(&sdmdev->cls_dev);
+}
+EXPORT_SYMBOL_GPL(vfio_sdmdev_unregister);
+
+static int __init vfio_sdmdev_init(void)
+{
+	sdmdev_class = class_create(THIS_MODULE, VFIO_SDMDEV_CLASS_NAME);
+	return PTR_ERR_OR_ZERO(sdmdev_class);
+}
+
+static __exit void vfio_sdmdev_exit(void)
+{
+	class_destroy(sdmdev_class);
+}
+
+module_init(vfio_sdmdev_init);
+module_exit(vfio_sdmdev_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Hisilicon Tech. Co., Ltd.");
+MODULE_DESCRIPTION("VFIO Share Domain Mediated Device");
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index d9fd3188615d..ba73231d8692 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -41,6 +41,7 @@
 #include <linux/notifier.h>
 #include <linux/dma-iommu.h>
 #include <linux/irqdomain.h>
+#include <linux/vfio_sdmdev.h>
 
 #define DRIVER_VERSION  "0.2"
 #define DRIVER_AUTHOR   "Alex Williamson <alex.williamson@redhat.com>"
@@ -89,6 +90,8 @@ struct vfio_dma {
 };
 
 struct vfio_group {
+	/* iommu_group of mdev's parent device */
+	struct iommu_group	*parent_group;
 	struct iommu_group	*iommu_group;
 	struct list_head	next;
 };
@@ -1327,6 +1330,109 @@ static bool vfio_iommu_has_sw_msi(struct iommu_group *group, phys_addr_t *base)
 	return ret;
 }
 
+/* return 0 if the device is not sdmdev.
+ * return 1 if the device is sdmdev, the data will be updated with parent
+ *	device's group.
+ * return -errno if other error.
+ */
+static int vfio_sdmdev_type(struct device *dev, void *data)
+{
+	struct iommu_group **group = data;
+	struct iommu_group *pgroup;
+	int (*_is_sdmdev)(struct device *dev);
+	struct device *pdev;
+	int ret = 1;
+
+	/* vfio_sdmdev module is not configurated */
+	_is_sdmdev = symbol_get(vfio_sdmdev_is_sdmdev);
+	if (!_is_sdmdev)
+		return 0;
+
+	/* check if it belongs to vfio_sdmdev device */
+	if (!_is_sdmdev(dev)) {
+		ret = 0;
+		goto out;
+	}
+
+	pdev = dev->parent;
+	pgroup = iommu_group_get(pdev);
+	if (!pgroup) {
+		ret = -ENODEV;
+		goto out;
+	}
+
+	if (group) {
+		/* check if all parent devices is the same */
+		if (*group && *group != pgroup)
+			ret = -ENODEV;
+		else
+			*group = pgroup;
+	}
+
+	iommu_group_put(pgroup);
+
+out:
+	symbol_put(vfio_sdmdev_is_sdmdev);
+
+	return ret;
+}
+
+/* return 0 or -errno */
+static int vfio_sdmdev_bus(struct device *dev, void *data)
+{
+	struct bus_type **bus = data;
+
+	if (!dev->bus)
+		return -ENODEV;
+
+	/* ensure all devices has the same bus_type */
+	if (*bus && *bus != dev->bus)
+		return -EINVAL;
+
+	*bus = dev->bus;
+	return 0;
+}
+
+/* return 0 means it is not sd group, 1 means it is, or -EXXX for error */
+static int vfio_iommu_type1_attach_sdgroup(struct vfio_domain *domain,
+					    struct vfio_group *group,
+					    struct iommu_group *iommu_group)
+{
+	int ret;
+	struct bus_type *pbus = NULL;
+	struct iommu_group *pgroup = NULL;
+
+	ret = iommu_group_for_each_dev(iommu_group, &pgroup,
+				       vfio_sdmdev_type);
+	if (ret < 0)
+		goto out;
+	else if (ret > 0) {
+		domain->domain = iommu_group_share_domain(pgroup);
+		if (IS_ERR(domain->domain))
+			goto out;
+		ret = iommu_group_for_each_dev(pgroup, &pbus,
+				       vfio_sdmdev_bus);
+		if (ret < 0)
+			goto err_with_share_domain;
+
+		if (pbus && iommu_capable(pbus, IOMMU_CAP_CACHE_COHERENCY))
+			domain->prot |= IOMMU_CACHE;
+
+		group->parent_group = pgroup;
+		INIT_LIST_HEAD(&domain->group_list);
+		list_add(&group->next, &domain->group_list);
+
+		return 1;
+	}
+
+	return 0;
+
+err_with_share_domain:
+	iommu_group_unshare_domain(pgroup);
+out:
+	return ret;
+}
+
 static int vfio_iommu_type1_attach_group(void *iommu_data,
 					 struct iommu_group *iommu_group)
 {
@@ -1335,8 +1441,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	struct vfio_domain *domain, *d;
 	struct bus_type *bus = NULL, *mdev_bus;
 	int ret;
-	bool resv_msi, msi_remap;
-	phys_addr_t resv_msi_base;
+	bool resv_msi = false, msi_remap;
+	phys_addr_t resv_msi_base = 0;
 
 	mutex_lock(&iommu->lock);
 
@@ -1373,6 +1479,14 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 	if (mdev_bus) {
 		if ((bus == mdev_bus) && !iommu_present(bus)) {
 			symbol_put(mdev_bus_type);
+
+			ret = vfio_iommu_type1_attach_sdgroup(domain, group,
+					iommu_group);
+			if (ret < 0)
+				goto out_free;
+			else if (ret > 0)
+				goto replay_check;
+
 			if (!iommu->external_domain) {
 				INIT_LIST_HEAD(&domain->group_list);
 				iommu->external_domain = domain;
@@ -1451,12 +1565,13 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	vfio_test_domain_fgsp(domain);
 
+replay_check:
 	/* replay mappings on new domains */
 	ret = vfio_iommu_replay(iommu, domain);
 	if (ret)
 		goto out_detach;
 
-	if (resv_msi) {
+	if (!group->parent_group && resv_msi) {
 		ret = iommu_get_msi_cookie(domain->domain, resv_msi_base);
 		if (ret)
 			goto out_detach;
@@ -1471,7 +1586,10 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 out_detach:
 	iommu_detach_group(domain->domain, iommu_group);
 out_domain:
-	iommu_domain_free(domain->domain);
+	if (group->parent_group)
+		iommu_group_unshare_domain(group->parent_group);
+	else
+		iommu_domain_free(domain->domain);
 out_free:
 	kfree(domain);
 	kfree(group);
@@ -1527,12 +1645,25 @@ static void vfio_sanity_check_pfn_list(struct vfio_iommu *iommu)
 	WARN_ON(iommu->notifier.head);
 }
 
+static void vfio_iommu_undo(struct vfio_iommu *iommu,
+			    struct iommu_domain *domain)
+{
+	struct rb_node *n = rb_first(&iommu->dma_list);
+	struct vfio_dma *dma;
+
+	for (; n; n = rb_next(n)) {
+		dma = rb_entry(n, struct vfio_dma, node);
+		iommu_unmap(domain, dma->iova, dma->size);
+	}
+}
+
 static void vfio_iommu_type1_detach_group(void *iommu_data,
 					  struct iommu_group *iommu_group)
 {
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_domain *domain;
 	struct vfio_group *group;
+	struct iommu_domain *sdomain = NULL;
 
 	mutex_lock(&iommu->lock);
 
@@ -1560,7 +1691,12 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		if (!group)
 			continue;
 
-		iommu_detach_group(domain->domain, iommu_group);
+		if (group->parent_group)
+			sdomain = iommu_group_unshare_domain(
+					group->parent_group);
+		else
+			iommu_detach_group(domain->domain, iommu_group);
+
 		list_del(&group->next);
 		kfree(group);
 		/*
@@ -1577,7 +1713,10 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 				else
 					vfio_iommu_unmap_unpin_reaccount(iommu);
 			}
-			iommu_domain_free(domain->domain);
+			if (domain->domain != sdomain)
+				iommu_domain_free(domain->domain);
+			else
+				vfio_iommu_undo(iommu, sdomain);
 			list_del(&domain->next);
 			kfree(domain);
 		}
diff --git a/include/linux/vfio_sdmdev.h b/include/linux/vfio_sdmdev.h
new file mode 100644
index 000000000000..fbc9fb3f4abc
--- /dev/null
+++ b/include/linux/vfio_sdmdev.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef __VFIO_SDMDEV_H
+#define __VFIO_SDMDEV_H
+
+#include <linux/device.h>
+#include <linux/iommu.h>
+#include <linux/mdev.h>
+#include <linux/vfio.h>
+#include <uapi/linux/vfio_sdmdev.h>
+
+struct vfio_sdmdev_queue;
+struct vfio_sdmdev;
+
+/* event bit used to mask the hardware irq */
+#define VFIO_SDMDEV_EVENT_Q_UPDATE BIT(0) /* irq if queue is updated */
+
+/**
+ * struct vfio_sdmdev_ops - WD device operations
+ * @get_queue: get a queue from the device according to algorithm
+ * @put_queue: free a queue to the device
+ * @start_queue: put queue into action with current process's pasid.
+ * @stop_queue: stop queue from running state
+ * @is_q_updated: check whether the task is finished
+ * @mask_notify: mask the task irq of queue
+ * @mmap: mmap addresses of queue to user space
+ * @reset: reset the WD device
+ * @reset_queue: reset the queue
+ * @ioctl:   ioctl for user space users of the queue
+ * @get_available_instances: get numbers of the queue remained
+ */
+struct vfio_sdmdev_ops {
+	int (*get_queue)(struct vfio_sdmdev *sdmdev,
+			 struct vfio_sdmdev_queue **q);
+	void (*put_queue)(struct vfio_sdmdev_queue *q);
+	int (*start_queue)(struct vfio_sdmdev_queue *q);
+	void (*stop_queue)(struct vfio_sdmdev_queue *q);
+	int (*is_q_updated)(struct vfio_sdmdev_queue *q);
+	void (*mask_notify)(struct vfio_sdmdev_queue *q, int event_mask);
+	int (*mmap)(struct vfio_sdmdev_queue *q, struct vm_area_struct *vma);
+	int (*reset)(struct vfio_sdmdev *sdmdev);
+	int (*reset_queue)(struct vfio_sdmdev_queue *q);
+	long (*ioctl)(struct vfio_sdmdev_queue *q, unsigned int cmd,
+			unsigned long arg);
+	int (*get_available_instances)(struct vfio_sdmdev *sdmdev);
+};
+
+struct vfio_sdmdev_queue {
+	struct mutex mutex;
+	struct vfio_sdmdev *sdmdev;
+	__u32 flags;
+	void *priv;
+	wait_queue_head_t wait;
+	struct mdev_device *mdev;
+	int fd;
+	int container;
+#ifdef CONFIG_IOMMU_SVA
+	int pasid;
+#endif
+};
+
+struct vfio_sdmdev {
+	const char *name;
+	int status;
+	atomic_t ref;
+	const struct vfio_sdmdev_ops *ops;
+	struct device *dev;
+	struct device cls_dev;
+	bool is_vf;
+	u32 iommu_type;
+	u32 dma_flag;
+	void *priv;
+	int flags;
+	const char *api_ver;
+	struct mdev_parent_ops mdev_fops;
+};
+
+int vfio_sdmdev_register(struct vfio_sdmdev *sdmdev);
+void vfio_sdmdev_unregister(struct vfio_sdmdev *sdmdev);
+void vfio_sdmdev_wake_up(struct vfio_sdmdev_queue *q);
+int vfio_sdmdev_is_sdmdev(struct device *dev);
+struct vfio_sdmdev *vfio_sdmdev_pdev_sdmdev(struct device *dev);
+struct vfio_sdmdev *mdev_sdmdev(struct mdev_device *mdev);
+
+extern struct mdev_type_attribute mdev_type_attr_flags;
+extern struct mdev_type_attribute mdev_type_attr_name;
+extern struct mdev_type_attribute mdev_type_attr_device_api;
+extern struct mdev_type_attribute mdev_type_attr_available_instances;
+#define VFIO_SDMDEV_DEFAULT_MDEV_TYPE_ATTRS \
+	&mdev_type_attr_name.attr, \
+	&mdev_type_attr_device_api.attr, \
+	&mdev_type_attr_available_instances.attr, \
+	&mdev_type_attr_flags.attr
+
+#define _VFIO_SDMDEV_REGION(vm_pgoff)	(vm_pgoff & 0xf)
+
+#endif
diff --git a/include/uapi/linux/vfio_sdmdev.h b/include/uapi/linux/vfio_sdmdev.h
new file mode 100644
index 000000000000..79fa33fbc8c0
--- /dev/null
+++ b/include/uapi/linux/vfio_sdmdev.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef _UAPIVFIO_SDMDEV_H
+#define _UAPIVFIO_SDMDEV_H
+
+#include <linux/ioctl.h>
+
+#define VFIO_SDMDEV_CLASS_NAME		"sdmdev"
+
+/* Device ATTRs in parent dev SYSFS DIR */
+#define VFIO_SDMDEV_PDEV_ATTRS_GRP_NAME	"params"
+
+/* Parent device attributes */
+#define SDMDEV_IOMMU_TYPE	"iommu_type"
+#define SDMDEV_DMA_FLAG		"dma_flag"
+
+/* Maximum length of algorithm name string */
+#define VFIO_SDMDEV_ALG_NAME_SIZE		64
+
+/* the bits used in SDMDEV_DMA_FLAG attributes */
+#define VFIO_SDMDEV_DMA_INVALID			0
+#define	VFIO_SDMDEV_DMA_SINGLE_PROC_MAP		1
+#define	VFIO_SDMDEV_DMA_MULTI_PROC_MAP		2
+#define	VFIO_SDMDEV_DMA_SVM			4
+#define	VFIO_SDMDEV_DMA_SVM_NO_FAULT		8
+#define	VFIO_SDMDEV_DMA_PHY			16
+
+#define VFIO_SDMDEV_CMD_WAIT		_IO('W', 1)
+#define VFIO_SDMDEV_CMD_BIND_PASID	_IO('W', 2)
+#endif
-- 
2.17.1
