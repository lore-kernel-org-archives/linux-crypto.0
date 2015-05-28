From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH] crypto: prevent nx 842 load if no hw driver
Date: Thu, 28 May 2015 16:21:31 -0400
Message-ID: <1432844491-27174-1-git-send-email-ddstreet@ieee.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35246 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbbE1UVo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 16:21:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change the nx-842 common driver to wait for loading of both platform
drivers, and fail loading if the platform driver pointer is not set.
Add an independent platform driver pointer, that the platform drivers
set if they find they are able to load (i.e. if they find their platform
devicetree node(s)).

The problem is currently, the main nx-842 driver will stay loaded even
if there is no platform driver and thus no possible way it can do any
compression or decompression.  This allows the crypto 842-nx driver
to load even if it won't actually work.  For crypto compression users
(e.g. zswap) that expect an available crypto compression driver to
actually work, this is bad.  This patch fixes that, so the 842-nx crypto
compression driver won't load if it doesn't have the driver and hardware
available to perform the compression.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/Makefile          |   3 +-
 drivers/crypto/nx/nx-842-platform.c |  84 +++++++++++++++++++++++
 drivers/crypto/nx/nx-842-powernv.c  |  17 +++--
 drivers/crypto/nx/nx-842-pseries.c  |  33 ++++++---
 drivers/crypto/nx/nx-842.c          | 130 ++++++------------------------------
 drivers/crypto/nx/nx-842.h          |  16 ++---
 6 files changed, 148 insertions(+), 135 deletions(-)
 create mode 100644 drivers/crypto/nx/nx-842-platform.c

diff --git a/drivers/crypto/nx/Makefile b/drivers/crypto/nx/Makefile
index 8e3512d..9d56205 100644
--- a/drivers/crypto/nx/Makefile
+++ b/drivers/crypto/nx/Makefile
@@ -10,12 +10,13 @@ nx-crypto-objs := nx.o \
 		  nx-sha256.o \
 		  nx-sha512.o
 
-obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS) += nx-compress.o
+obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS) += nx-compress.o nx-compress-platform.o
 obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_PSERIES) += nx-compress-pseries.o
 obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_POWERNV) += nx-compress-powernv.o
 obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_CRYPTO) += nx-compress-crypto.o
 obj-$(CONFIG_CRYPTO_DEV_NX_SELFTEST) += nx-compress-test.o
 nx-compress-objs := nx-842.o
+nx-compress-platform-objs := nx-842-platform.o
 nx-compress-pseries-objs := nx-842-pseries.o
 nx-compress-powernv-objs := nx-842-powernv.o
 nx-compress-crypto-objs := nx-842-crypto.o
diff --git a/drivers/crypto/nx/nx-842-platform.c b/drivers/crypto/nx/nx-842-platform.c
new file mode 100644
index 0000000..664f13d
--- /dev/null
+++ b/drivers/crypto/nx/nx-842-platform.c
@@ -0,0 +1,84 @@
+
+#include "nx-842.h"
+
+/* this is needed, separate from the main nx-842.c driver, because that main
+ * driver loads the platform drivers during its init(), and it expects one
+ * (or none) of the platform drivers to set this pointer to its driver.
+ * That means this pointer can't be in the main nx-842 driver, because it
+ * wouldn't be accessible until after the main driver loaded, which wouldn't
+ * be possible as it's waiting for the platform driver to load.  So place it
+ * here.
+ */
+static struct nx842_driver *driver;
+static DEFINE_SPINLOCK(driver_lock);
+
+struct nx842_driver *nx842_platform_driver(void)
+{
+	return driver;
+}
+EXPORT_SYMBOL_GPL(nx842_platform_driver);
+
+bool nx842_platform_driver_set(struct nx842_driver *_driver)
+{
+	bool ret = false;
+
+	spin_lock(&driver_lock);
+
+	if (!driver) {
+		driver = _driver;
+		ret = true;
+	} else
+		WARN(1, "can't set platform driver, already set to %s\n",
+		     driver->name);
+
+	spin_unlock(&driver_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nx842_platform_driver_set);
+
+/* only call this from the platform driver exit function */
+void nx842_platform_driver_unset(struct nx842_driver *_driver)
+{
+	spin_lock(&driver_lock);
+
+	if (driver == _driver)
+		driver = NULL;
+	else if (driver)
+		WARN(1, "can't unset platform driver %s, currently set to %s\n",
+		     _driver->name, driver->name);
+	else
+		WARN(1, "can't unset platform driver, already unset\n");
+
+	spin_unlock(&driver_lock);
+}
+EXPORT_SYMBOL_GPL(nx842_platform_driver_unset);
+
+bool nx842_platform_driver_get(void)
+{
+	bool ret = false;
+
+	spin_lock(&driver_lock);
+
+	if (driver)
+		ret = try_module_get(driver->owner);
+
+	spin_unlock(&driver_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nx842_platform_driver_get);
+
+void nx842_platform_driver_put(void)
+{
+	spin_lock(&driver_lock);
+
+	if (driver)
+		module_put(driver->owner);
+
+	spin_unlock(&driver_lock);
+}
+EXPORT_SYMBOL_GPL(nx842_platform_driver_put);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
+MODULE_DESCRIPTION("842 H/W Compression platform driver");
diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 6a9fb8b..c388dba 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -23,7 +23,6 @@
 #include <asm/prom.h>
 #include <asm/icswx.h>
 
-#define MODULE_NAME NX842_POWERNV_MODULE_NAME
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
 MODULE_DESCRIPTION("842 H/W Compression driver for IBM PowerNV processors");
@@ -571,6 +570,7 @@ static struct nx842_constraints nx842_powernv_constraints = {
 };
 
 static struct nx842_driver nx842_powernv_driver = {
+	.name =		KBUILD_MODNAME,
 	.owner =	THIS_MODULE,
 	.constraints =	&nx842_powernv_constraints,
 	.compress =	nx842_powernv_compress,
@@ -593,7 +593,7 @@ static __init int nx842_powernv_init(void)
 
 	pr_info("loading\n");
 
-	for_each_compatible_node(dn, NULL, NX842_POWERNV_COMPAT_NAME)
+	for_each_compatible_node(dn, NULL, "ibm,power-nx")
 		nx842_powernv_probe(dn);
 
 	if (!nx842_ct) {
@@ -601,7 +601,16 @@ static __init int nx842_powernv_init(void)
 		return -ENODEV;
 	}
 
-	nx842_register_driver(&nx842_powernv_driver);
+	if (!nx842_platform_driver_set(&nx842_powernv_driver)) {
+		struct nx842_coproc *coproc, *n;
+
+		list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
+			list_del(&coproc->list);
+			kfree(coproc);
+		}
+
+		return -EEXIST;
+	}
 
 	pr_info("loaded\n");
 
@@ -613,7 +622,7 @@ static void __exit nx842_powernv_exit(void)
 {
 	struct nx842_coproc *coproc, *n;
 
-	nx842_unregister_driver(&nx842_powernv_driver);
+	nx842_platform_driver_unset(&nx842_powernv_driver);
 
 	list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
 		list_del(&coproc->list);
diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 85837e9..17f1917 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -26,7 +26,6 @@
 #include "nx-842.h"
 #include "nx_csbcpb.h" /* struct nx_csbcpb */
 
-#define MODULE_NAME NX842_PSERIES_MODULE_NAME
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Robert Jennings <rcj@linux.vnet.ibm.com>");
 MODULE_DESCRIPTION("842 H/W Compression driver for IBM Power processors");
@@ -965,6 +964,7 @@ static struct attribute_group nx842_attribute_group = {
 };
 
 static struct nx842_driver nx842_pseries_driver = {
+	.name =		KBUILD_MODNAME,
 	.owner =	THIS_MODULE,
 	.constraints =	&nx842_pseries_constraints,
 	.compress =	nx842_pseries_compress,
@@ -1033,8 +1033,6 @@ static int __init nx842_probe(struct vio_dev *viodev,
 		goto error;
 	}
 
-	nx842_register_driver(&nx842_pseries_driver);
-
 	return 0;
 
 error_unlock:
@@ -1066,18 +1064,16 @@ static int __exit nx842_remove(struct vio_dev *viodev)
 		kfree(old_devdata->counters);
 	kfree(old_devdata);
 
-	nx842_unregister_driver(&nx842_pseries_driver);
-
 	return 0;
 }
 
 static struct vio_device_id nx842_vio_driver_ids[] = {
-	{NX842_PSERIES_COMPAT_NAME "-v1", NX842_PSERIES_COMPAT_NAME},
+	{"ibm,compression-v1", "ibm,compression"},
 	{"", ""},
 };
 
 static struct vio_driver nx842_vio_driver = {
-	.name = MODULE_NAME,
+	.name = KBUILD_MODNAME,
 	.probe = nx842_probe,
 	.remove = __exit_p(nx842_remove),
 	.get_desired_dma = nx842_get_desired_dma,
@@ -1087,10 +1083,15 @@ static struct vio_driver nx842_vio_driver = {
 static int __init nx842_init(void)
 {
 	struct nx842_devdata *new_devdata;
+	int ret;
+
 	pr_info("Registering IBM Power 842 compression driver\n");
 
 	BUILD_BUG_ON(sizeof(struct nx842_workmem) > NX842_MEM_COMPRESS);
 
+	if (!of_find_compatible_node(NULL, NULL, "ibm,compression"))
+		return -ENODEV;
+
 	RCU_INIT_POINTER(devdata, NULL);
 	new_devdata = kzalloc(sizeof(*new_devdata), GFP_KERNEL);
 	if (!new_devdata) {
@@ -1100,7 +1101,21 @@ static int __init nx842_init(void)
 	new_devdata->status = UNAVAILABLE;
 	RCU_INIT_POINTER(devdata, new_devdata);
 
-	return vio_register_driver(&nx842_vio_driver);
+	ret = vio_register_driver(&nx842_vio_driver);
+	if (ret) {
+		pr_err("Could not register VIO driver %d\n", ret);
+
+		kfree(new_devdata);
+		return ret;
+	}
+
+	if (!nx842_platform_driver_set(&nx842_pseries_driver)) {
+		vio_unregister_driver(&nx842_vio_driver);
+		kfree(new_devdata);
+		return -EEXIST;
+	}
+
+	return 0;
 }
 
 module_init(nx842_init);
@@ -1111,6 +1126,7 @@ static void __exit nx842_exit(void)
 	unsigned long flags;
 
 	pr_info("Exiting IBM Power 842 compression driver\n");
+	nx842_platform_driver_unset(&nx842_pseries_driver);
 	spin_lock_irqsave(&devdata_mutex, flags);
 	old_devdata = rcu_dereference_check(devdata,
 			lockdep_is_held(&devdata_mutex));
@@ -1120,7 +1136,6 @@ static void __exit nx842_exit(void)
 	if (old_devdata && old_devdata->dev)
 		dev_set_drvdata(old_devdata->dev, NULL);
 	kfree(old_devdata);
-	nx842_unregister_driver(&nx842_pseries_driver);
 	vio_unregister_driver(&nx842_vio_driver);
 }
 
diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index bf2823c..9f391d6 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -21,71 +21,10 @@
 
 #include "nx-842.h"
 
-#define MODULE_NAME "nx-compress"
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
 MODULE_DESCRIPTION("842 H/W Compression driver for IBM Power processors");
 
-/* Only one driver is expected, based on the HW platform */
-static struct nx842_driver *nx842_driver;
-static DEFINE_SPINLOCK(nx842_driver_lock); /* protects driver pointers */
-
-void nx842_register_driver(struct nx842_driver *driver)
-{
-	spin_lock(&nx842_driver_lock);
-
-	if (nx842_driver) {
-		pr_err("can't register driver %s, already using driver %s\n",
-		       driver->owner->name, nx842_driver->owner->name);
-	} else {
-		pr_info("registering driver %s\n", driver->owner->name);
-		nx842_driver = driver;
-	}
-
-	spin_unlock(&nx842_driver_lock);
-}
-EXPORT_SYMBOL_GPL(nx842_register_driver);
-
-void nx842_unregister_driver(struct nx842_driver *driver)
-{
-	spin_lock(&nx842_driver_lock);
-
-	if (nx842_driver == driver) {
-		pr_info("unregistering driver %s\n", driver->owner->name);
-		nx842_driver = NULL;
-	} else if (nx842_driver) {
-		pr_err("can't unregister driver %s, using driver %s\n",
-		       driver->owner->name, nx842_driver->owner->name);
-	} else {
-		pr_err("can't unregister driver %s, no driver in use\n",
-		       driver->owner->name);
-	}
-
-	spin_unlock(&nx842_driver_lock);
-}
-EXPORT_SYMBOL_GPL(nx842_unregister_driver);
-
-static struct nx842_driver *get_driver(void)
-{
-	struct nx842_driver *driver = NULL;
-
-	spin_lock(&nx842_driver_lock);
-
-	driver = nx842_driver;
-
-	if (driver && !try_module_get(driver->owner))
-		driver = NULL;
-
-	spin_unlock(&nx842_driver_lock);
-
-	return driver;
-}
-
-static void put_driver(struct nx842_driver *driver)
-{
-	module_put(driver->owner);
-}
-
 /**
  * nx842_constraints
  *
@@ -109,69 +48,38 @@ static void put_driver(struct nx842_driver *driver)
  */
 int nx842_constraints(struct nx842_constraints *c)
 {
-	struct nx842_driver *driver = get_driver();
-	int ret = 0;
-
-	if (!driver)
-		return -ENODEV;
-
-	BUG_ON(!c);
-	memcpy(c, driver->constraints, sizeof(*c));
-
-	put_driver(driver);
-
-	return ret;
+	memcpy(c, nx842_platform_driver()->constraints, sizeof(*c));
+	return 0;
 }
 EXPORT_SYMBOL_GPL(nx842_constraints);
 
-int nx842_compress(const unsigned char *in, unsigned int in_len,
-		   unsigned char *out, unsigned int *out_len,
-		   void *wrkmem)
+int nx842_compress(const unsigned char *in, unsigned int ilen,
+		   unsigned char *out, unsigned int *olen, void *wmem)
 {
-	struct nx842_driver *driver = get_driver();
-	int ret;
-
-	if (!driver)
-		return -ENODEV;
-
-	ret = driver->compress(in, in_len, out, out_len, wrkmem);
-
-	put_driver(driver);
-
-	return ret;
+	return nx842_platform_driver()->compress(in, ilen, out, olen, wmem);
 }
 EXPORT_SYMBOL_GPL(nx842_compress);
 
-int nx842_decompress(const unsigned char *in, unsigned int in_len,
-		     unsigned char *out, unsigned int *out_len,
-		     void *wrkmem)
+int nx842_decompress(const unsigned char *in, unsigned int ilen,
+		     unsigned char *out, unsigned int *olen, void *wmem)
 {
-	struct nx842_driver *driver = get_driver();
-	int ret;
-
-	if (!driver)
-		return -ENODEV;
-
-	ret = driver->decompress(in, in_len, out, out_len, wrkmem);
-
-	put_driver(driver);
-
-	return ret;
+	return nx842_platform_driver()->decompress(in, ilen, out, olen, wmem);
 }
 EXPORT_SYMBOL_GPL(nx842_decompress);
 
 static __init int nx842_init(void)
 {
-	pr_info("loading\n");
-
-	if (of_find_compatible_node(NULL, NULL, NX842_POWERNV_COMPAT_NAME))
-		request_module_nowait(NX842_POWERNV_MODULE_NAME);
-	else if (of_find_compatible_node(NULL, NULL, NX842_PSERIES_COMPAT_NAME))
-		request_module_nowait(NX842_PSERIES_MODULE_NAME);
-	else
+	request_module("nx-compress-powernv");
+	request_module("nx-compress-pseries");
+
+	/* we prevent loading if there's no platform driver, and we get the
+	 * module that set it so it won't unload, so we don't need to check
+	 * if it's set in any of the above functions
+	 */
+	if (!nx842_platform_driver_get()) {
 		pr_err("no nx842 driver found.\n");
-
-	pr_info("loaded\n");
+		return -ENODEV;
+	}
 
 	return 0;
 }
@@ -179,6 +87,6 @@ module_init(nx842_init);
 
 static void __exit nx842_exit(void)
 {
-	pr_info("NX842 unloaded\n");
+	nx842_platform_driver_put();
 }
 module_exit(nx842_exit);
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index 84b15b7..1730f4da 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -105,6 +105,7 @@ static inline unsigned long nx842_get_pa(void *addr)
 #define SET_FIELD(v, m, val)	(((v) & ~(m)) | (((val) << MASK_LSH(m)) & (m)))
 
 struct nx842_driver {
+	char *name;
 	struct module *owner;
 
 	struct nx842_constraints *constraints;
@@ -117,15 +118,10 @@ struct nx842_driver {
 			  void *wrkmem);
 };
 
-void nx842_register_driver(struct nx842_driver *driver);
-void nx842_unregister_driver(struct nx842_driver *driver);
-
-
-/* To allow the main nx-compress module to load platform module */
-#define NX842_POWERNV_MODULE_NAME	"nx-compress-powernv"
-#define NX842_POWERNV_COMPAT_NAME	"ibm,power-nx"
-#define NX842_PSERIES_MODULE_NAME	"nx-compress-pseries"
-#define NX842_PSERIES_COMPAT_NAME	"ibm,compression"
-
+struct nx842_driver *nx842_platform_driver(void);
+bool nx842_platform_driver_set(struct nx842_driver *driver);
+void nx842_platform_driver_unset(struct nx842_driver *driver);
+bool nx842_platform_driver_get(void);
+void nx842_platform_driver_put(void);
 
 #endif /* __NX_842_H__ */
-- 
2.1.0
