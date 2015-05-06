From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 06/10] drivers/crypto/nx: add NX-842 platform frontend driver
Date: Wed,  6 May 2015 12:51:02 -0400
Message-ID: <1430931066-4536-7-git-send-email-ddstreet@ieee.org>
References: <1428428070-17803-1-git-send-email-ddstreet@ieee.org>
 <1430931066-4536-1-git-send-email-ddstreet@ieee.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
	Seth Jennings <sjennings@variantweb.net>,
	Robert Jennings <rob@pochix.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Arnd Bergmann <arnd@arndb.de>, Joe Perches <joe@perches.com>,
	linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430931066-4536-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add NX-842 frontend that allows using either the pSeries platform or
PowerNV platform driver (to be added by later patch) for the NX-842
hardware.  Update the MAINTAINERS file to include the new filenames.
Update Kconfig files to clarify titles and descriptions, and correct
dependencies.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 MAINTAINERS                        |   2 +-
 drivers/crypto/Kconfig             |  10 +--
 drivers/crypto/nx/Kconfig          |  35 ++++++---
 drivers/crypto/nx/Makefile         |   4 +-
 drivers/crypto/nx/nx-842-pseries.c |  57 +++++++--------
 drivers/crypto/nx/nx-842.c         | 144 +++++++++++++++++++++++++++++++++++++
 drivers/crypto/nx/nx-842.h         |  32 +++++++++
 include/linux/nx842.h              |  10 +--
 8 files changed, 245 insertions(+), 49 deletions(-)
 create mode 100644 drivers/crypto/nx/nx-842.c
 create mode 100644 drivers/crypto/nx/nx-842.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 5a5c1dc..e71855f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4870,7 +4870,7 @@ F:	drivers/crypto/nx/
 IBM Power 842 compression accelerator
 M:	Dan Streetman <ddstreet@us.ibm.com>
 S:	Supported
-F:	drivers/crypto/nx/nx-842.c
+F:	drivers/crypto/nx/nx-842*
 F:	include/linux/nx842.h
 F:	include/linux/sw842.h
 F:	crypto/842.c
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 033c0c8..872de26 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -312,11 +312,13 @@ config CRYPTO_DEV_S5P
 	  algorithms execution.
 
 config CRYPTO_DEV_NX
-	bool "Support for IBM Power7+ in-Nest cryptographic acceleration"
-	depends on PPC64 && IBMVIO && !CPU_LITTLE_ENDIAN
-	default n
+	bool "Support for IBM PowerPC Nest (NX) cryptographic acceleration"
+	depends on PPC64
 	help
-	  Support for Power7+ in-Nest cryptographic acceleration.
+	  This enables support for the NX hardware cryptographic accelerator
+	  coprocessor that is in IBM PowerPC P7+ or later processors.  This
+	  does not actually enable any drivers, it only allows you to select
+	  which acceleration type (encryption and/or compression) to enable.
 
 if CRYPTO_DEV_NX
 	source "drivers/crypto/nx/Kconfig"
diff --git a/drivers/crypto/nx/Kconfig b/drivers/crypto/nx/Kconfig
index f826166..34013f7 100644
--- a/drivers/crypto/nx/Kconfig
+++ b/drivers/crypto/nx/Kconfig
@@ -1,7 +1,9 @@
+
 config CRYPTO_DEV_NX_ENCRYPT
-	tristate "Encryption acceleration support"
-	depends on PPC64 && IBMVIO
+	tristate "Encryption acceleration support on pSeries platform"
+	depends on PPC_PSERIES && IBMVIO && !CPU_LITTLE_ENDIAN
 	default y
+	select CRYPTO_ALGAPI
 	select CRYPTO_AES
 	select CRYPTO_CBC
 	select CRYPTO_ECB
@@ -12,15 +14,30 @@ config CRYPTO_DEV_NX_ENCRYPT
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
 	help
-	  Support for Power7+ in-Nest encryption acceleration. This
-	  module supports acceleration for AES and SHA2 algorithms. If you
-	  choose 'M' here, this module will be called nx_crypto.
+	  Support for PowerPC Nest (NX) encryption acceleration. This
+	  module supports acceleration for AES and SHA2 algorithms on
+	  the pSeries platform.  If you choose 'M' here, this module
+	  will be called nx_crypto.
 
 config CRYPTO_DEV_NX_COMPRESS
 	tristate "Compression acceleration support"
-	depends on PPC64 && IBMVIO
 	default y
 	help
-	  Support for Power7+ in-Nest compression acceleration. This
-	  module supports acceleration for AES and SHA2 algorithms. If you
-	  choose 'M' here, this module will be called nx_compress.
+	  Support for PowerPC Nest (NX) compression acceleration. This
+	  module supports acceleration for compressing memory with the 842
+	  algorithm.  One of the platform drivers must be selected also.
+	  If you choose 'M' here, this module will be called nx_compress.
+
+if CRYPTO_DEV_NX_COMPRESS
+
+config CRYPTO_DEV_NX_COMPRESS_PSERIES
+	tristate "Compression acceleration support on pSeries platform"
+	depends on PPC_PSERIES && IBMVIO && !CPU_LITTLE_ENDIAN
+	default y
+	help
+	  Support for PowerPC Nest (NX) compression acceleration. This
+	  module supports acceleration for compressing memory with the 842
+	  algorithm.  This supports NX hardware on the pSeries platform.
+	  If you choose 'M' here, this module will be called nx_compress_pseries.
+
+endif
diff --git a/drivers/crypto/nx/Makefile b/drivers/crypto/nx/Makefile
index 8669ffa..5d9f4bc 100644
--- a/drivers/crypto/nx/Makefile
+++ b/drivers/crypto/nx/Makefile
@@ -11,4 +11,6 @@ nx-crypto-objs := nx.o \
 		  nx-sha512.o
 
 obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS) += nx-compress.o
-nx-compress-objs := nx-842-pseries.o
+obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_PSERIES) += nx-compress-pseries.o
+nx-compress-objs := nx-842.o
+nx-compress-pseries-objs := nx-842-pseries.o
diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 887196e..9b83c9e 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -21,18 +21,13 @@
  *          Seth Jennings <sjenning@linux.vnet.ibm.com>
  */
 
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/nx842.h>
-#include <linux/of.h>
-#include <linux/slab.h>
-
 #include <asm/page.h>
 #include <asm/vio.h>
 
+#include "nx-842.h"
 #include "nx_csbcpb.h" /* struct nx_csbcpb */
 
-#define MODULE_NAME "nx-compress"
+#define MODULE_NAME NX842_PSERIES_MODULE_NAME
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Robert Jennings <rcj@linux.vnet.ibm.com>");
 MODULE_DESCRIPTION("842 H/W Compression driver for IBM Power processors");
@@ -236,18 +231,6 @@ struct nx842_workmem {
 	};
 };
 
-int nx842_get_workmem_size(void)
-{
-	return sizeof(struct nx842_workmem) + NX842_HW_PAGE_SIZE;
-}
-EXPORT_SYMBOL_GPL(nx842_get_workmem_size);
-
-int nx842_get_workmem_size_aligned(void)
-{
-	return sizeof(struct nx842_workmem);
-}
-EXPORT_SYMBOL_GPL(nx842_get_workmem_size_aligned);
-
 static int nx842_validate_result(struct device *dev,
 	struct cop_status_block *csb)
 {
@@ -300,7 +283,7 @@ static int nx842_validate_result(struct device *dev,
 }
 
 /**
- * nx842_compress - Compress data using the 842 algorithm
+ * nx842_pseries_compress - Compress data using the 842 algorithm
  *
  * Compression provide by the NX842 coprocessor on IBM Power systems.
  * The input buffer is compressed and the result is stored in the
@@ -315,7 +298,7 @@ static int nx842_validate_result(struct device *dev,
  * @out: Pointer to output buffer
  * @outlen: Length of output buffer
  * @wrkmem: ptr to buffer for working memory, size determined by
- *          nx842_get_workmem_size()
+ *          NX842_MEM_COMPRESS
  *
  * Returns:
  *   0		Success, output of length @outlen stored in the buffer at @out
@@ -325,8 +308,9 @@ static int nx842_validate_result(struct device *dev,
  *   -EIO	Internal error
  *   -ENODEV	Hardware unavailable
  */
-int nx842_compress(const unsigned char *in, unsigned int inlen,
-		       unsigned char *out, unsigned int *outlen, void *wmem)
+static int nx842_pseries_compress(const unsigned char *in, unsigned int inlen,
+				  unsigned char *out, unsigned int *outlen,
+				  void *wmem)
 {
 	struct nx842_header *hdr;
 	struct nx842_devdata *local_devdata;
@@ -493,13 +477,12 @@ unlock:
 	rcu_read_unlock();
 	return ret;
 }
-EXPORT_SYMBOL_GPL(nx842_compress);
 
 static int sw842_decompress(const unsigned char *, int, unsigned char *, int *,
 			const void *);
 
 /**
- * nx842_decompress - Decompress data using the 842 algorithm
+ * nx842_pseries_decompress - Decompress data using the 842 algorithm
  *
  * Decompression provide by the NX842 coprocessor on IBM Power systems.
  * The input buffer is decompressed and the result is stored in the
@@ -515,7 +498,7 @@ static int sw842_decompress(const unsigned char *, int, unsigned char *, int *,
  * @out: Pointer to output buffer, must be page aligned
  * @outlen: Length of output buffer, must be PAGE_SIZE
  * @wrkmem: ptr to buffer for working memory, size determined by
- *          nx842_get_workmem_size()
+ *          NX842_MEM_COMPRESS
  *
  * Returns:
  *   0		Success, output of length @outlen stored in the buffer at @out
@@ -525,8 +508,9 @@ static int sw842_decompress(const unsigned char *, int, unsigned char *, int *,
  *   -EINVAL	Bad input data encountered when attempting decompress
  *   -EIO	Internal error
  */
-int nx842_decompress(const unsigned char *in, unsigned int inlen,
-			 unsigned char *out, unsigned int *outlen, void *wmem)
+static int nx842_pseries_decompress(const unsigned char *in, unsigned int inlen,
+				    unsigned char *out, unsigned int *outlen,
+				    void *wmem)
 {
 	struct nx842_header *hdr;
 	struct nx842_devdata *local_devdata;
@@ -694,7 +678,6 @@ unlock:
 	rcu_read_unlock();
 	return ret;
 }
-EXPORT_SYMBOL_GPL(nx842_decompress);
 
 /**
  * nx842_OF_set_defaults -- Set default (disabled) values for devdata
@@ -1130,6 +1113,12 @@ static struct attribute_group nx842_attribute_group = {
 	.attrs = nx842_sysfs_entries,
 };
 
+static struct nx842_driver nx842_pseries_driver = {
+	.owner =	THIS_MODULE,
+	.compress =	nx842_pseries_compress,
+	.decompress =	nx842_pseries_decompress,
+};
+
 static int __init nx842_probe(struct vio_dev *viodev,
 				  const struct vio_device_id *id)
 {
@@ -1192,6 +1181,8 @@ static int __init nx842_probe(struct vio_dev *viodev,
 		goto error;
 	}
 
+	nx842_register_driver(&nx842_pseries_driver);
+
 	return 0;
 
 error_unlock:
@@ -1222,11 +1213,14 @@ static int __exit nx842_remove(struct vio_dev *viodev)
 	if (old_devdata)
 		kfree(old_devdata->counters);
 	kfree(old_devdata);
+
+	nx842_unregister_driver(&nx842_pseries_driver);
+
 	return 0;
 }
 
 static struct vio_device_id nx842_driver_ids[] = {
-	{"ibm,compression-v1", "ibm,compression"},
+	{NX842_PSERIES_COMPAT_NAME "-v1", NX842_PSERIES_COMPAT_NAME},
 	{"", ""},
 };
 
@@ -1243,6 +1237,8 @@ static int __init nx842_init(void)
 	struct nx842_devdata *new_devdata;
 	pr_info("Registering IBM Power 842 compression driver\n");
 
+	BUILD_BUG_ON(sizeof(struct nx842_workmem) > NX842_MEM_COMPRESS);
+
 	RCU_INIT_POINTER(devdata, NULL);
 	new_devdata = kzalloc(sizeof(*new_devdata), GFP_KERNEL);
 	if (!new_devdata) {
@@ -1272,6 +1268,7 @@ static void __exit nx842_exit(void)
 	if (old_devdata)
 		dev_set_drvdata(old_devdata->dev, NULL);
 	kfree(old_devdata);
+	nx842_unregister_driver(&nx842_pseries_driver);
 	vio_unregister_driver(&nx842_driver);
 }
 
diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
new file mode 100644
index 0000000..f1f378e
--- /dev/null
+++ b/drivers/crypto/nx/nx-842.c
@@ -0,0 +1,144 @@
+/*
+ * Driver frontend for IBM Power 842 compression accelerator
+ *
+ * Copyright (C) 2015 Dan Streetman, IBM Corp
+ *
+ * Designer of the Power data compression engine:
+ *   Bulent Abali <abali@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include "nx-842.h"
+
+#define MODULE_NAME "nx-compress"
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
+MODULE_DESCRIPTION("842 H/W Compression driver for IBM Power processors");
+
+/* Only one driver is expected, based on the HW platform */
+static struct nx842_driver *nx842_driver;
+static DEFINE_SPINLOCK(nx842_driver_lock); /* protects driver pointers */
+
+void nx842_register_driver(struct nx842_driver *driver)
+{
+	spin_lock(&nx842_driver_lock);
+
+	if (nx842_driver) {
+		pr_err("can't register driver %s, already using driver %s\n",
+		       driver->owner->name, nx842_driver->owner->name);
+	} else {
+		pr_info("registering driver %s\n", driver->owner->name);
+		nx842_driver = driver;
+	}
+
+	spin_unlock(&nx842_driver_lock);
+}
+EXPORT_SYMBOL_GPL(nx842_register_driver);
+
+void nx842_unregister_driver(struct nx842_driver *driver)
+{
+	spin_lock(&nx842_driver_lock);
+
+	if (nx842_driver == driver) {
+		pr_info("unregistering driver %s\n", driver->owner->name);
+		nx842_driver = NULL;
+	} else if (nx842_driver) {
+		pr_err("can't unregister driver %s, using driver %s\n",
+		       driver->owner->name, nx842_driver->owner->name);
+	} else {
+		pr_err("can't unregister driver %s, no driver in use\n",
+		       driver->owner->name);
+	}
+
+	spin_unlock(&nx842_driver_lock);
+}
+EXPORT_SYMBOL_GPL(nx842_unregister_driver);
+
+static struct nx842_driver *get_driver(void)
+{
+	struct nx842_driver *driver = NULL;
+
+	spin_lock(&nx842_driver_lock);
+
+	driver = nx842_driver;
+
+	if (driver && !try_module_get(driver->owner))
+		driver = NULL;
+
+	spin_unlock(&nx842_driver_lock);
+
+	return driver;
+}
+
+static void put_driver(struct nx842_driver *driver)
+{
+	module_put(driver->owner);
+}
+
+int nx842_compress(const unsigned char *in, unsigned int in_len,
+		   unsigned char *out, unsigned int *out_len,
+		   void *wrkmem)
+{
+	struct nx842_driver *driver = get_driver();
+	int ret;
+
+	if (!driver)
+		return -ENODEV;
+
+	ret = driver->compress(in, in_len, out, out_len, wrkmem);
+
+	put_driver(driver);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nx842_compress);
+
+int nx842_decompress(const unsigned char *in, unsigned int in_len,
+		     unsigned char *out, unsigned int *out_len,
+		     void *wrkmem)
+{
+	struct nx842_driver *driver = get_driver();
+	int ret;
+
+	if (!driver)
+		return -ENODEV;
+
+	ret = driver->decompress(in, in_len, out, out_len, wrkmem);
+
+	put_driver(driver);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(nx842_decompress);
+
+static __init int nx842_init(void)
+{
+	pr_info("loading\n");
+
+	if (of_find_compatible_node(NULL, NULL, NX842_PSERIES_COMPAT_NAME))
+		request_module_nowait(NX842_PSERIES_MODULE_NAME);
+	else
+		pr_err("no nx842 driver found.\n");
+
+	pr_info("loaded\n");
+
+	return 0;
+}
+module_init(nx842_init);
+
+static void __exit nx842_exit(void)
+{
+	pr_info("NX842 unloaded\n");
+}
+module_exit(nx842_exit);
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
new file mode 100644
index 0000000..2a5d4e1
--- /dev/null
+++ b/drivers/crypto/nx/nx-842.h
@@ -0,0 +1,32 @@
+
+#ifndef __NX_842_H__
+#define __NX_842_H__
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/nx842.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/io.h>
+
+struct nx842_driver {
+	struct module *owner;
+
+	int (*compress)(const unsigned char *in, unsigned int in_len,
+			unsigned char *out, unsigned int *out_len,
+			void *wrkmem);
+	int (*decompress)(const unsigned char *in, unsigned int in_len,
+			  unsigned char *out, unsigned int *out_len,
+			  void *wrkmem);
+};
+
+void nx842_register_driver(struct nx842_driver *driver);
+void nx842_unregister_driver(struct nx842_driver *driver);
+
+
+/* To allow the main nx-compress module to load platform module */
+#define NX842_PSERIES_MODULE_NAME	"nx-compress-pseries"
+#define NX842_PSERIES_COMPAT_NAME	"ibm,compression"
+
+
+#endif /* __NX_842_H__ */
diff --git a/include/linux/nx842.h b/include/linux/nx842.h
index a4d324c..d919c22 100644
--- a/include/linux/nx842.h
+++ b/include/linux/nx842.h
@@ -1,11 +1,13 @@
 #ifndef __NX842_H__
 #define __NX842_H__
 
-int nx842_get_workmem_size(void);
-int nx842_get_workmem_size_aligned(void);
+#define __NX842_PSERIES_MEM_COMPRESS	((PAGE_SIZE * 2) + 10240)
+
+#define NX842_MEM_COMPRESS	__NX842_PSERIES_MEM_COMPRESS
+
 int nx842_compress(const unsigned char *in, unsigned int in_len,
-		unsigned char *out, unsigned int *out_len, void *wrkmem);
+		   unsigned char *out, unsigned int *out_len, void *wrkmem);
 int nx842_decompress(const unsigned char *in, unsigned int in_len,
-		unsigned char *out, unsigned int *out_len, void *wrkmem);
+		     unsigned char *out, unsigned int *out_len, void *wrkmem);
 
 #endif
-- 
2.1.0
