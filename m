From: Kenneth Lee <nek.in.cn@gmail.com>
Subject: [RFC PATCH 3/7] vfio: add spimdev support
Date: Wed,  1 Aug 2018 18:22:17 +0800
Message-ID: <20180801102221.5308-4-nek.in.cn@gmail.com>
References: <20180801102221.5308-1-nek.in.cn@gmail.com>
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
In-Reply-To: <20180801102221.5308-1-nek.in.cn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Kenneth Lee <liguozhu@hisilicon.com>

SPIMDEV is "Share Parent IOMMU Mdev". It is a vfio-mdev. But differ from
the general vfio-mdev:

1. It shares its parent's IOMMU.
2. There is no hardware resource attached to the mdev is created. The
hardware resource (A `queue') is allocated only when the mdev is
opened.

Currently only the vfio type-1 driver is updated to make it to be aware
of.

Signed-off-by: Kenneth Lee <liguozhu@hisilicon.com>
Signed-off-by: Zaibo Xu <xuzaibo@huawei.com>
Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
---
 drivers/vfio/Kconfig                |   1 +
 drivers/vfio/Makefile               |   1 +
 drivers/vfio/spimdev/Kconfig        |  10 +
 drivers/vfio/spimdev/Makefile       |   3 +
 drivers/vfio/spimdev/vfio_spimdev.c | 421 ++++++++++++++++++++++++++++
 drivers/vfio/vfio_iommu_type1.c     | 136 ++++++++-
 include/linux/vfio_spimdev.h        |  95 +++++++
 include/uapi/linux/vfio_spimdev.h   |  28 ++
 8 files changed, 689 insertions(+), 6 deletions(-)
 create mode 100644 drivers/vfio/spimdev/Kconfig
 create mode 100644 drivers/vfio/spimdev/Makefile
 create mode 100644 drivers/vfio/spimdev/vfio_spimdev.c
 create mode 100644 include/linux/vfio_spimdev.h
 create mode 100644 include/uapi/linux/vfio_spimdev.h

diff --git a/drivers/vfio/Kconfig b/drivers/vfio/Kconfig
index c84333eb5eb5..3719eba72ef1 100644
--- a/drivers/vfio/Kconfig
+++ b/drivers/vfio/Kconfig
@@ -47,4 +47,5 @@ menuconfig VFIO_NOIOMMU
 source "drivers/vfio/pci/Kconfig"
 source "drivers/vfio/platform/Kconfig"
 source "drivers/vfio/mdev/Kconfig"
+source "drivers/vfio/spimdev/Kconfig"
 source "virt/lib/Kconfig"
diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index de67c4725cce..28f3ef0cdce1 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -9,3 +9,4 @@ obj-$(CONFIG_VFIO_SPAPR_EEH) += vfio_spapr_eeh.o
 obj-$(CONFIG_VFIO_PCI) += pci/
 obj-$(CONFIG_VFIO_PLATFORM) += platform/
 obj-$(CONFIG_VFIO_MDEV) += mdev/
+obj-$(CONFIG_VFIO_SPIMDEV) += spimdev/
diff --git a/drivers/vfio/spimdev/Kconfig b/drivers/vfio/spimdev/Kconfig
new file mode 100644
index 000000000000..1226301f9d0e
--- /dev/null
+++ b/drivers/vfio/spimdev/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0
+config VFIO_SPIMDEV
+	tristate "Support for Share Parent IOMMU MDEV"
+	depends on VFIO_MDEV_DEVICE
+	help
+	  Support for VFIO Share Parent IOMMU MDEV, which enable the kernel to
+	  support for the light weight hardware accelerator framework, WrapDrive.
+
+	  To compile this as a module, choose M here: the module will be called
+	  spimdev.
diff --git a/drivers/vfio/spimdev/Makefile b/drivers/vfio/spimdev/Makefile
new file mode 100644
index 000000000000..d02fb69c37e4
--- /dev/null
+++ b/drivers/vfio/spimdev/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+spimdev-y := spimdev.o
+obj-$(CONFIG_VFIO_SPIMDEV) += vfio_spimdev.o
diff --git a/drivers/vfio/spimdev/vfio_spimdev.c b/drivers/vfio/spimdev/vfio_spimdev.c
new file mode 100644
index 000000000000..1b6910c9d27d
--- /dev/null
+++ b/drivers/vfio/spimdev/vfio_spimdev.c
@@ -0,0 +1,421 @@
+// SPDX-License-Identifier: GPL-2.0+
+#include <linux/anon_inodes.h>
+#include <linux/idr.h>
+#include <linux/module.h>
+#include <linux/poll.h>
+#include <linux/vfio_spimdev.h>
+
+struct spimdev_mdev_state {
+	struct vfio_spimdev *spimdev;
+};
+
+static struct class *spimdev_class;
+static DEFINE_IDR(spimdev_idr);
+
+static int vfio_spimdev_dev_exist(struct device *dev, void *data)
+{
+	return !strcmp(dev_name(dev), dev_name((struct device *)data));
+}
+
+#ifdef CONFIG_IOMMU_SVA
+static bool vfio_spimdev_is_valid_pasid(int pasid)
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
+/* Check if the device is a mediated device belongs to vfio_spimdev */
+int vfio_spimdev_is_spimdev(struct device *dev)
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
+	return class_for_each_device(spimdev_class, NULL, pdev,
+			vfio_spimdev_dev_exist);
+}
+EXPORT_SYMBOL_GPL(vfio_spimdev_is_spimdev);
+
+struct vfio_spimdev *vfio_spimdev_pdev_spimdev(struct device *dev)
+{
+	struct device *class_dev;
+
+	if (!dev)
+		return ERR_PTR(-EINVAL);
+
+	class_dev = class_find_device(spimdev_class, NULL, dev,
+		(int(*)(struct device *, const void *))vfio_spimdev_dev_exist);
+	if (!class_dev)
+		return ERR_PTR(-ENODEV);
+
+	return container_of(class_dev, struct vfio_spimdev, cls_dev);
+}
+EXPORT_SYMBOL_GPL(vfio_spimdev_pdev_spimdev);
+
+struct vfio_spimdev *mdev_spimdev(struct mdev_device *mdev)
+{
+	struct device *pdev = mdev_parent_dev(mdev);
+
+	return vfio_spimdev_pdev_spimdev(pdev);
+}
+EXPORT_SYMBOL_GPL(mdev_spimdev);
+
+static ssize_t iommu_type_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct vfio_spimdev *spimdev = vfio_spimdev_pdev_spimdev(dev);
+
+	if (!spimdev)
+		return -ENODEV;
+
+	return sprintf(buf, "%d\n", spimdev->iommu_type);
+}
+
+static DEVICE_ATTR_RO(iommu_type);
+
+static ssize_t dma_flag_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct vfio_spimdev *spimdev = vfio_spimdev_pdev_spimdev(dev);
+
+	if (!spimdev)
+		return -ENODEV;
+
+	return sprintf(buf, "%d\n", spimdev->dma_flag);
+}
+
+static DEVICE_ATTR_RO(dma_flag);
+
+/* mdev->dev_attr_groups */
+static struct attribute *vfio_spimdev_attrs[] = {
+	&dev_attr_iommu_type.attr,
+	&dev_attr_dma_flag.attr,
+	NULL,
+};
+static const struct attribute_group vfio_spimdev_group = {
+	.name  = VFIO_SPIMDEV_PDEV_ATTRS_GRP_NAME,
+	.attrs = vfio_spimdev_attrs,
+};
+const struct attribute_group *vfio_spimdev_groups[] = {
+	&vfio_spimdev_group,
+	NULL,
+};
+
+/* default attributes for mdev->supported_type_groups, used by registerer*/
+#define MDEV_TYPE_ATTR_RO_EXPORT(name) \
+		MDEV_TYPE_ATTR_RO(name); \
+		EXPORT_SYMBOL_GPL(mdev_type_attr_##name);
+
+#define DEF_SIMPLE_SPIMDEV_ATTR(_name, spimdev_member, format) \
+static ssize_t _name##_show(struct kobject *kobj, struct device *dev, \
+			    char *buf) \
+{ \
+	struct vfio_spimdev *spimdev = vfio_spimdev_pdev_spimdev(dev); \
+	if (!spimdev) \
+		return -ENODEV; \
+	return sprintf(buf, format, spimdev->spimdev_member); \
+} \
+MDEV_TYPE_ATTR_RO_EXPORT(_name)
+
+DEF_SIMPLE_SPIMDEV_ATTR(flags, flags, "%d");
+DEF_SIMPLE_SPIMDEV_ATTR(name, name, "%s"); /* this should be algorithm name, */
+		/* but you would not care if you have only one algorithm */
+DEF_SIMPLE_SPIMDEV_ATTR(device_api, api_ver, "%s");
+
+/* this return total queue left, not mdev left */
+static ssize_t
+available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
+{
+	struct vfio_spimdev *spimdev = vfio_spimdev_pdev_spimdev(dev);
+
+	return sprintf(buf, "%d",
+			spimdev->ops->get_available_instances(spimdev));
+}
+MDEV_TYPE_ATTR_RO_EXPORT(available_instances);
+
+static int vfio_spimdev_mdev_create(struct kobject *kobj,
+	struct mdev_device *mdev)
+{
+	struct device *dev = mdev_dev(mdev);
+	struct device *pdev = mdev_parent_dev(mdev);
+	struct spimdev_mdev_state *mdev_state;
+	struct vfio_spimdev *spimdev = mdev_spimdev(mdev);
+
+	if (!spimdev->ops->get_queue)
+		return -ENODEV;
+
+	mdev_state = devm_kzalloc(dev, sizeof(struct spimdev_mdev_state),
+				  GFP_KERNEL);
+	if (!mdev_state)
+		return -ENOMEM;
+	mdev_set_drvdata(mdev, mdev_state);
+	mdev_state->spimdev = spimdev;
+	dev->iommu_fwspec = pdev->iommu_fwspec;
+	get_device(pdev);
+	__module_get(spimdev->owner);
+
+	return 0;
+}
+
+static int vfio_spimdev_mdev_remove(struct mdev_device *mdev)
+{
+	struct device *dev = mdev_dev(mdev);
+	struct device *pdev = mdev_parent_dev(mdev);
+	struct vfio_spimdev *spimdev = mdev_spimdev(mdev);
+
+	put_device(pdev);
+	module_put(spimdev->owner);
+	dev->iommu_fwspec = NULL;
+	mdev_set_drvdata(mdev, NULL);
+
+	return 0;
+}
+
+/* Wake up the process who is waiting this queue */
+void vfio_spimdev_wake_up(struct vfio_spimdev_queue *q)
+{
+	wake_up(&q->wait);
+}
+EXPORT_SYMBOL_GPL(vfio_spimdev_wake_up);
+
+static int vfio_spimdev_q_file_open(struct inode *inode, struct file *file)
+{
+	return 0;
+}
+
+static int vfio_spimdev_q_file_release(struct inode *inode, struct file *file)
+{
+	struct vfio_spimdev_queue *q =
+		(struct vfio_spimdev_queue *)file->private_data;
+	struct vfio_spimdev *spimdev = q->spimdev;
+	int ret;
+
+	ret = spimdev->ops->put_queue(q);
+	if (ret) {
+		dev_err(spimdev->dev, "drv put queue fail (%d)!\n", ret);
+		return ret;
+	}
+
+	put_device(mdev_dev(q->mdev));
+
+	return 0;
+}
+
+static long vfio_spimdev_q_file_ioctl(struct file *file, unsigned int cmd,
+	unsigned long arg)
+{
+	struct vfio_spimdev_queue *q =
+		(struct vfio_spimdev_queue *)file->private_data;
+	struct vfio_spimdev *spimdev = q->spimdev;
+
+	if (spimdev->ops->ioctl)
+		return spimdev->ops->ioctl(q, cmd, arg);
+
+	dev_err(spimdev->dev, "ioctl cmd (%d) is not supported!\n", cmd);
+
+	return -EINVAL;
+}
+
+static int vfio_spimdev_q_file_mmap(struct file *file,
+		struct vm_area_struct *vma)
+{
+	struct vfio_spimdev_queue *q =
+		(struct vfio_spimdev_queue *)file->private_data;
+	struct vfio_spimdev *spimdev = q->spimdev;
+
+	if (spimdev->ops->mmap)
+		return spimdev->ops->mmap(q, vma);
+
+	dev_err(spimdev->dev, "no driver mmap!\n");
+	return -EINVAL;
+}
+
+static __poll_t vfio_spimdev_q_file_poll(struct file *file, poll_table *wait)
+{
+	struct vfio_spimdev_queue *q =
+		(struct vfio_spimdev_queue *)file->private_data;
+	struct vfio_spimdev *spimdev = q->spimdev;
+
+	poll_wait(file, &q->wait, wait);
+	if (spimdev->ops->is_q_updated(q))
+		return EPOLLIN | EPOLLRDNORM;
+
+	return 0;
+}
+
+static const struct file_operations spimdev_q_file_ops = {
+	.owner = THIS_MODULE,
+	.open = vfio_spimdev_q_file_open,
+	.unlocked_ioctl = vfio_spimdev_q_file_ioctl,
+	.release = vfio_spimdev_q_file_release,
+	.poll = vfio_spimdev_q_file_poll,
+	.mmap = vfio_spimdev_q_file_mmap,
+};
+
+static long vfio_spimdev_mdev_get_queue(struct mdev_device *mdev,
+		struct vfio_spimdev *spimdev, unsigned long arg)
+{
+	struct vfio_spimdev_queue *q;
+	int ret;
+
+#ifdef CONFIG_IOMMU_SVA
+	int pasid = arg;
+
+	if (!vfio_spimdev_is_valid_pasid(pasid))
+		return -EINVAL;
+#endif
+
+	if (!spimdev->ops->get_queue)
+		return -EINVAL;
+
+	ret = spimdev->ops->get_queue(spimdev, arg, &q);
+	if (ret < 0) {
+		dev_err(spimdev->dev, "get_queue failed\n");
+		return -ENODEV;
+	}
+
+	ret = anon_inode_getfd("spimdev_q", &spimdev_q_file_ops,
+			q, O_CLOEXEC | O_RDWR);
+	if (ret < 0) {
+		dev_err(spimdev->dev, "getfd fail %d\n", ret);
+		goto err_with_queue;
+	}
+
+	q->fd = ret;
+	q->spimdev = spimdev;
+	q->mdev = mdev;
+	q->container = arg;
+	init_waitqueue_head(&q->wait);
+	get_device(mdev_dev(mdev));
+
+	return ret;
+
+err_with_queue:
+	spimdev->ops->put_queue(q);
+	return ret;
+}
+
+static long vfio_spimdev_mdev_ioctl(struct mdev_device *mdev, unsigned int cmd,
+			       unsigned long arg)
+{
+	struct spimdev_mdev_state *mdev_state;
+	struct vfio_spimdev *spimdev;
+
+	if (!mdev)
+		return -ENODEV;
+
+	mdev_state = mdev_get_drvdata(mdev);
+	if (!mdev_state)
+		return -ENODEV;
+
+	spimdev = mdev_state->spimdev;
+	if (!spimdev)
+		return -ENODEV;
+
+	if (cmd == VFIO_SPIMDEV_CMD_GET_Q)
+		return vfio_spimdev_mdev_get_queue(mdev, spimdev, arg);
+
+	dev_err(spimdev->dev,
+		"%s, ioctl cmd (0x%x) is not supported!\n", __func__, cmd);
+	return -EINVAL;
+}
+
+static void vfio_spimdev_release(struct device *dev) { }
+static void vfio_spimdev_mdev_release(struct mdev_device *mdev) { }
+static int vfio_spimdev_mdev_open(struct mdev_device *mdev) { return 0; }
+
+/**
+ *	vfio_spimdev_register - register a spimdev
+ *	@spimdev: device structure
+ */
+int vfio_spimdev_register(struct vfio_spimdev *spimdev)
+{
+	int ret;
+	const char *drv_name;
+
+	if (!spimdev->dev)
+		return -ENODEV;
+
+	drv_name = dev_driver_string(spimdev->dev);
+	if (strstr(drv_name, "-")) {
+		pr_err("spimdev: parent driver name cannot include '-'!\n");
+		return -EINVAL;
+	}
+
+	spimdev->dev_id = idr_alloc(&spimdev_idr, spimdev, 0, 0, GFP_KERNEL);
+	if (spimdev->dev_id < 0)
+		return spimdev->dev_id;
+
+	atomic_set(&spimdev->ref, 0);
+	spimdev->cls_dev.parent = spimdev->dev;
+	spimdev->cls_dev.class = spimdev_class;
+	spimdev->cls_dev.release = vfio_spimdev_release;
+	dev_set_name(&spimdev->cls_dev, "%s", dev_name(spimdev->dev));
+	ret = device_register(&spimdev->cls_dev);
+	if (ret)
+		return ret;
+
+	spimdev->mdev_fops.owner		= spimdev->owner;
+	spimdev->mdev_fops.dev_attr_groups	= vfio_spimdev_groups;
+	WARN_ON(!spimdev->mdev_fops.supported_type_groups);
+	spimdev->mdev_fops.create		= vfio_spimdev_mdev_create;
+	spimdev->mdev_fops.remove		= vfio_spimdev_mdev_remove;
+	spimdev->mdev_fops.ioctl		= vfio_spimdev_mdev_ioctl;
+	spimdev->mdev_fops.open			= vfio_spimdev_mdev_open;
+	spimdev->mdev_fops.release		= vfio_spimdev_mdev_release;
+
+	ret = mdev_register_device(spimdev->dev, &spimdev->mdev_fops);
+	if (ret)
+		device_unregister(&spimdev->cls_dev);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(vfio_spimdev_register);
+
+/**
+ * vfio_spimdev_unregister - unregisters a spimdev
+ * @spimdev: device to unregister
+ *
+ * Unregister a miscellaneous device that wat previously successully registered
+ * with vfio_spimdev_register().
+ */
+void vfio_spimdev_unregister(struct vfio_spimdev *spimdev)
+{
+	mdev_unregister_device(spimdev->dev);
+	device_unregister(&spimdev->cls_dev);
+}
+EXPORT_SYMBOL_GPL(vfio_spimdev_unregister);
+
+static int __init vfio_spimdev_init(void)
+{
+	spimdev_class = class_create(THIS_MODULE, VFIO_SPIMDEV_CLASS_NAME);
+	return PTR_ERR_OR_ZERO(spimdev_class);
+}
+
+static __exit void vfio_spimdev_exit(void)
+{
+	class_destroy(spimdev_class);
+	idr_destroy(&spimdev_idr);
+}
+
+module_init(vfio_spimdev_init);
+module_exit(vfio_spimdev_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Hisilicon Tech. Co., Ltd.");
+MODULE_DESCRIPTION("VFIO Share Parent's IOMMU Mediated Device");
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 3e5b17710a4f..0ec38a17c98c 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -41,6 +41,7 @@
 #include <linux/notifier.h>
 #include <linux/dma-iommu.h>
 #include <linux/irqdomain.h>
+#include <linux/vfio_spimdev.h>
 
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
 
+/* return 0 if the device is not spimdev.
+ * return 1 if the device is spimdev, the data will be updated with parent
+ * 	device's group.
+ * return -errno if other error.
+ */
+static int vfio_spimdev_type(struct device *dev, void *data)
+{
+	struct iommu_group **group = data;
+	struct iommu_group *pgroup;
+	int (*spimdev_mdev)(struct device *dev);
+	struct device *pdev;
+	int ret = 1;
+
+	/* vfio_spimdev module is not configurated */
+	spimdev_mdev = symbol_get(vfio_spimdev_is_spimdev);
+	if (!spimdev_mdev)
+		return 0;
+
+	/* check if it belongs to vfio_spimdev device */
+	if (!spimdev_mdev(dev)) {
+		ret = 0;
+		goto get_exit;
+	}
+
+	pdev = dev->parent;
+	pgroup = iommu_group_get(pdev);
+	if (!pgroup) {
+		ret = -ENODEV;
+		goto get_exit;
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
+get_exit:
+	symbol_put(vfio_spimdev_is_spimdev);
+
+	return ret;
+}
+
+/* return 0 or -errno */
+static int vfio_spimdev_bus(struct device *dev, void *data)
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
+/* return 0 means it is not spi group, 1 means it is, or -EXXX for error */
+static int vfio_iommu_type1_attach_spigroup(struct vfio_domain *domain,
+					    struct vfio_group *group,
+					    struct iommu_group *iommu_group)
+{
+	int ret;
+	struct bus_type *pbus = NULL;
+	struct iommu_group *pgroup = NULL;
+
+	ret = iommu_group_for_each_dev(iommu_group, &pgroup,
+				       vfio_spimdev_type);
+	if (ret < 0)
+		goto out;
+	else if (ret > 0) {
+		domain->domain = iommu_group_share_domain(pgroup);
+		if (IS_ERR(domain->domain))
+			goto out;
+		ret = iommu_group_for_each_dev(pgroup, &pbus,
+				       vfio_spimdev_bus);
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
+			ret = vfio_iommu_type1_attach_spigroup(domain, group,
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
@@ -1533,6 +1651,7 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 	struct vfio_iommu *iommu = iommu_data;
 	struct vfio_domain *domain;
 	struct vfio_group *group;
+	int ret;
 
 	mutex_lock(&iommu->lock);
 
@@ -1560,7 +1679,11 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 		if (!group)
 			continue;
 
-		iommu_detach_group(domain->domain, iommu_group);
+		if (group->parent_group)
+			iommu_group_unshare_domain(group->parent_group);
+		else
+			iommu_detach_group(domain->domain, iommu_group);
+
 		list_del(&group->next);
 		kfree(group);
 		/*
@@ -1577,7 +1700,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 				else
 					vfio_iommu_unmap_unpin_reaccount(iommu);
 			}
-			iommu_domain_free(domain->domain);
+			if (!ret)
+				iommu_domain_free(domain->domain);
 			list_del(&domain->next);
 			kfree(domain);
 		}
diff --git a/include/linux/vfio_spimdev.h b/include/linux/vfio_spimdev.h
new file mode 100644
index 000000000000..f7e7d90013e1
--- /dev/null
+++ b/include/linux/vfio_spimdev.h
@@ -0,0 +1,95 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef __VFIO_SPIMDEV_H
+#define __VFIO_SPIMDEV_H
+
+#include <linux/device.h>
+#include <linux/iommu.h>
+#include <linux/mdev.h>
+#include <linux/vfio.h>
+#include <uapi/linux/vfio_spimdev.h>
+
+struct vfio_spimdev_queue;
+struct vfio_spimdev;
+
+/**
+ * struct vfio_spimdev_ops - WD device operations
+ * @get_queue: get a queue from the device according to algorithm
+ * @put_queue: free a queue to the device
+ * @is_q_updated: check whether the task is finished
+ * @mask_notify: mask the task irq of queue
+ * @mmap: mmap addresses of queue to user space
+ * @reset: reset the WD device
+ * @reset_queue: reset the queue
+ * @ioctl:   ioctl for user space users of the queue
+ * @get_available_instances: get numbers of the queue remained
+ */
+struct vfio_spimdev_ops {
+	int (*get_queue)(struct vfio_spimdev *spimdev, unsigned long arg,
+		struct vfio_spimdev_queue **q);
+	int (*put_queue)(struct vfio_spimdev_queue *q);
+	int (*is_q_updated)(struct vfio_spimdev_queue *q);
+	void (*mask_notify)(struct vfio_spimdev_queue *q, int event_mask);
+	int (*mmap)(struct vfio_spimdev_queue *q, struct vm_area_struct *vma);
+	int (*reset)(struct vfio_spimdev *spimdev);
+	int (*reset_queue)(struct vfio_spimdev_queue *q);
+	long (*ioctl)(struct vfio_spimdev_queue *q, unsigned int cmd,
+			unsigned long arg);
+	int (*get_available_instances)(struct vfio_spimdev *spimdev);
+};
+
+struct vfio_spimdev_queue {
+	struct mutex mutex;
+	struct vfio_spimdev *spimdev;
+	int qid;
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
+struct vfio_spimdev {
+	const char *name;
+	int status;
+	atomic_t ref;
+	struct module *owner;
+	const struct vfio_spimdev_ops *ops;
+	struct device *dev;
+	struct device cls_dev;
+	bool is_vf;
+	u32 iommu_type;
+	u32 dma_flag;
+	u32 dev_id;
+	void *priv;
+	int flags;
+	const char *api_ver;
+	struct mdev_parent_ops mdev_fops;
+};
+
+int vfio_spimdev_register(struct vfio_spimdev *spimdev);
+void vfio_spimdev_unregister(struct vfio_spimdev *spimdev);
+void vfio_spimdev_wake_up(struct vfio_spimdev_queue *q);
+int vfio_spimdev_is_spimdev(struct device *dev);
+struct vfio_spimdev *vfio_spimdev_pdev_spimdev(struct device *dev);
+int vfio_spimdev_pasid_pri_check(int pasid);
+int vfio_spimdev_get(struct device *dev);
+int vfio_spimdev_put(struct device *dev);
+struct vfio_spimdev *mdev_spimdev(struct mdev_device *mdev);
+
+extern struct mdev_type_attribute mdev_type_attr_flags;
+extern struct mdev_type_attribute mdev_type_attr_name;
+extern struct mdev_type_attribute mdev_type_attr_device_api;
+extern struct mdev_type_attribute mdev_type_attr_available_instances;
+#define VFIO_SPIMDEV_DEFAULT_MDEV_TYPE_ATTRS \
+	&mdev_type_attr_name.attr, \
+	&mdev_type_attr_device_api.attr, \
+	&mdev_type_attr_available_instances.attr, \
+	&mdev_type_attr_flags.attr
+
+#define _VFIO_SPIMDEV_REGION(vm_pgoff)	(vm_pgoff & 0xf)
+
+#endif
diff --git a/include/uapi/linux/vfio_spimdev.h b/include/uapi/linux/vfio_spimdev.h
new file mode 100644
index 000000000000..3435e5c345b4
--- /dev/null
+++ b/include/uapi/linux/vfio_spimdev.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef _UAPIVFIO_SPIMDEV_H
+#define _UAPIVFIO_SPIMDEV_H
+
+#include <linux/ioctl.h>
+
+#define VFIO_SPIMDEV_CLASS_NAME		"spimdev"
+
+/* Device ATTRs in parent dev SYSFS DIR */
+#define VFIO_SPIMDEV_PDEV_ATTRS_GRP_NAME	"params"
+
+/* Parent device attributes */
+#define SPIMDEV_IOMMU_TYPE	"iommu_type"
+#define SPIMDEV_DMA_FLAG	"dma_flag"
+
+/* Maximum length of algorithm name string */
+#define VFIO_SPIMDEV_ALG_NAME_SIZE		64
+
+/* the bits used in SPIMDEV_DMA_FLAG attributes */
+#define VFIO_SPIMDEV_DMA_INVALID		0
+#define	VFIO_SPIMDEV_DMA_SINGLE_PROC_MAP	1
+#define	VFIO_SPIMDEV_DMA_MULTI_PROC_MAP		2
+#define	VFIO_SPIMDEV_DMA_SVM			4
+#define	VFIO_SPIMDEV_DMA_SVM_NO_FAULT		8
+#define	VFIO_SPIMDEV_DMA_PHY			16
+
+#define VFIO_SPIMDEV_CMD_GET_Q	_IO('W', 1)
+#endif
-- 
2.17.1
