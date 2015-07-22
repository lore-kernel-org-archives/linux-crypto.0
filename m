From: Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 8/8] crypto: nx - make platform drivers directly register with crypto
Date: Wed, 22 Jul 2015 14:26:38 -0400
Message-ID: <1437589598-23917-9-git-send-email-ddstreet@ieee.org>
References: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Dan Streetman <ddstreet@ieee.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437589598-23917-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Remove the common 'platform' registration module, and move the crypto
compression driver registration into each of the pSeries and PowerNV
platform NX 842 drivers.  Change the nx-842.c code into simple common
functions that each platform driver uses to perform constraints-based
buffer changes, i.e. realigning and/or resizing buffers to match the
driver's hardware requirements.

The common 'platform' module was my mistake to create - since each
platform driver will only load/operate when running on its own
platform (i.e. a pSeries platform or a PowerNV platform), they can
directly register with the crypto subsystem, using the same alg and
driver name.  This removes unneeded complexity.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
---
 drivers/crypto/nx/Makefile          |   6 +--
 drivers/crypto/nx/nx-842-platform.c |  84 -----------------------------
 drivers/crypto/nx/nx-842-powernv.c  |  29 ++++++++--
 drivers/crypto/nx/nx-842-pseries.c  |  38 ++++++++++---
 drivers/crypto/nx/nx-842.c          | 105 +++++++-----------------------------
 drivers/crypto/nx/nx-842.h          |  43 ++++++++++++---
 6 files changed, 114 insertions(+), 191 deletions(-)
 delete mode 100644 drivers/crypto/nx/nx-842-platform.c

diff --git a/drivers/crypto/nx/Makefile b/drivers/crypto/nx/Makefile
index ffcc86c..b727821 100644
--- a/drivers/crypto/nx/Makefile
+++ b/drivers/crypto/nx/Makefile
@@ -10,10 +10,8 @@ nx-crypto-objs := nx.o \
 		  nx-sha256.o \
 		  nx-sha512.o
 
-obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS) += nx-compress.o nx-compress-platform.o
-obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_PSERIES) += nx-compress-pseries.o
-obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_POWERNV) += nx-compress-powernv.o
+obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_PSERIES) += nx-compress-pseries.o nx-compress.o
+obj-$(CONFIG_CRYPTO_DEV_NX_COMPRESS_POWERNV) += nx-compress-powernv.o nx-compress.o
 nx-compress-objs := nx-842.o
-nx-compress-platform-objs := nx-842-platform.o
 nx-compress-pseries-objs := nx-842-pseries.o
 nx-compress-powernv-objs := nx-842-powernv.o
diff --git a/drivers/crypto/nx/nx-842-platform.c b/drivers/crypto/nx/nx-842-platform.c
deleted file mode 100644
index 664f13d..0000000
--- a/drivers/crypto/nx/nx-842-platform.c
+++ /dev/null
@@ -1,84 +0,0 @@
-
-#include "nx-842.h"
-
-/* this is needed, separate from the main nx-842.c driver, because that main
- * driver loads the platform drivers during its init(), and it expects one
- * (or none) of the platform drivers to set this pointer to its driver.
- * That means this pointer can't be in the main nx-842 driver, because it
- * wouldn't be accessible until after the main driver loaded, which wouldn't
- * be possible as it's waiting for the platform driver to load.  So place it
- * here.
- */
-static struct nx842_driver *driver;
-static DEFINE_SPINLOCK(driver_lock);
-
-struct nx842_driver *nx842_platform_driver(void)
-{
-	return driver;
-}
-EXPORT_SYMBOL_GPL(nx842_platform_driver);
-
-bool nx842_platform_driver_set(struct nx842_driver *_driver)
-{
-	bool ret = false;
-
-	spin_lock(&driver_lock);
-
-	if (!driver) {
-		driver = _driver;
-		ret = true;
-	} else
-		WARN(1, "can't set platform driver, already set to %s\n",
-		     driver->name);
-
-	spin_unlock(&driver_lock);
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nx842_platform_driver_set);
-
-/* only call this from the platform driver exit function */
-void nx842_platform_driver_unset(struct nx842_driver *_driver)
-{
-	spin_lock(&driver_lock);
-
-	if (driver == _driver)
-		driver = NULL;
-	else if (driver)
-		WARN(1, "can't unset platform driver %s, currently set to %s\n",
-		     _driver->name, driver->name);
-	else
-		WARN(1, "can't unset platform driver, already unset\n");
-
-	spin_unlock(&driver_lock);
-}
-EXPORT_SYMBOL_GPL(nx842_platform_driver_unset);
-
-bool nx842_platform_driver_get(void)
-{
-	bool ret = false;
-
-	spin_lock(&driver_lock);
-
-	if (driver)
-		ret = try_module_get(driver->owner);
-
-	spin_unlock(&driver_lock);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(nx842_platform_driver_get);
-
-void nx842_platform_driver_put(void)
-{
-	spin_lock(&driver_lock);
-
-	if (driver)
-		module_put(driver->owner);
-
-	spin_unlock(&driver_lock);
-}
-EXPORT_SYMBOL_GPL(nx842_platform_driver_put);
-
-MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
-MODULE_DESCRIPTION("842 H/W Compression platform driver");
diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 7e47456..684ce51 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -26,6 +26,8 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
 MODULE_DESCRIPTION("842 H/W Compression driver for IBM PowerNV processors");
+MODULE_ALIAS_CRYPTO("842");
+MODULE_ALIAS_CRYPTO("842-nx");
 
 #define WORKMEM_ALIGN	(CRB_ALIGN)
 #define CSB_WAIT_MAX	(5000) /* ms */
@@ -581,9 +583,29 @@ static struct nx842_driver nx842_powernv_driver = {
 	.decompress =	nx842_powernv_decompress,
 };
 
+static int nx842_powernv_crypto_init(struct crypto_tfm *tfm)
+{
+	return nx842_crypto_init(tfm, &nx842_powernv_driver);
+}
+
+static struct crypto_alg nx842_powernv_alg = {
+	.cra_name		= "842",
+	.cra_driver_name	= "842-nx",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct nx842_crypto_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_init		= nx842_powernv_crypto_init,
+	.cra_exit		= nx842_crypto_exit,
+	.cra_u			= { .compress = {
+	.coa_compress		= nx842_crypto_compress,
+	.coa_decompress		= nx842_crypto_decompress } }
+};
+
 static __init int nx842_powernv_init(void)
 {
 	struct device_node *dn;
+	int ret;
 
 	/* verify workmem size/align restrictions */
 	BUILD_BUG_ON(WORKMEM_ALIGN % CRB_ALIGN);
@@ -600,7 +622,8 @@ static __init int nx842_powernv_init(void)
 	if (!nx842_ct)
 		return -ENODEV;
 
-	if (!nx842_platform_driver_set(&nx842_powernv_driver)) {
+	ret = crypto_register_alg(&nx842_powernv_alg);
+	if (ret) {
 		struct nx842_coproc *coproc, *n;
 
 		list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
@@ -608,7 +631,7 @@ static __init int nx842_powernv_init(void)
 			kfree(coproc);
 		}
 
-		return -EEXIST;
+		return ret;
 	}
 
 	return 0;
@@ -619,7 +642,7 @@ static void __exit nx842_powernv_exit(void)
 {
 	struct nx842_coproc *coproc, *n;
 
-	nx842_platform_driver_unset(&nx842_powernv_driver);
+	crypto_unregister_alg(&nx842_powernv_alg);
 
 	list_for_each_entry_safe(coproc, n, &nx842_coprocs, list) {
 		list_del(&coproc->list);
diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 4b7bd8f..b6a26907 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -29,6 +29,8 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Robert Jennings <rcj@linux.vnet.ibm.com>");
 MODULE_DESCRIPTION("842 H/W Compression driver for IBM Power processors");
+MODULE_ALIAS_CRYPTO("842");
+MODULE_ALIAS_CRYPTO("842-nx");
 
 static struct nx842_constraints nx842_pseries_constraints = {
 	.alignment =	DDE_BUFFER_ALIGN,
@@ -957,6 +959,25 @@ static struct nx842_driver nx842_pseries_driver = {
 	.decompress =	nx842_pseries_decompress,
 };
 
+static int nx842_pseries_crypto_init(struct crypto_tfm *tfm)
+{
+	return nx842_crypto_init(tfm, &nx842_pseries_driver);
+}
+
+static struct crypto_alg nx842_pseries_alg = {
+	.cra_name		= "842",
+	.cra_driver_name	= "842-nx",
+	.cra_priority		= 300,
+	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize		= sizeof(struct nx842_crypto_ctx),
+	.cra_module		= THIS_MODULE,
+	.cra_init		= nx842_pseries_crypto_init,
+	.cra_exit		= nx842_crypto_exit,
+	.cra_u			= { .compress = {
+	.coa_compress		= nx842_crypto_compress,
+	.coa_decompress		= nx842_crypto_decompress } }
+};
+
 static int nx842_probe(struct vio_dev *viodev,
 		       const struct vio_device_id *id)
 {
@@ -1002,6 +1023,12 @@ static int nx842_probe(struct vio_dev *viodev,
 	if (ret)
 		goto error;
 
+	ret = crypto_register_alg(&nx842_pseries_alg);
+	if (ret) {
+		dev_err(&viodev->dev, "could not register comp alg: %d\n", ret);
+		goto error;
+	}
+
 	rcu_read_lock();
 	dev_set_drvdata(&viodev->dev, rcu_dereference(devdata));
 	rcu_read_unlock();
@@ -1031,6 +1058,8 @@ static int nx842_remove(struct vio_dev *viodev)
 	pr_info("Removing IBM Power 842 compression device\n");
 	sysfs_remove_group(&viodev->dev.kobj, &nx842_attribute_group);
 
+	crypto_unregister_alg(&nx842_pseries_alg);
+
 	spin_lock_irqsave(&devdata_mutex, flags);
 	old_devdata = rcu_dereference_check(devdata,
 			lockdep_is_held(&devdata_mutex));
@@ -1083,12 +1112,6 @@ static int __init nx842_pseries_init(void)
 		return ret;
 	}
 
-	if (!nx842_platform_driver_set(&nx842_pseries_driver)) {
-		vio_unregister_driver(&nx842_vio_driver);
-		kfree(new_devdata);
-		return -EEXIST;
-	}
-
 	return 0;
 }
 
@@ -1099,7 +1122,8 @@ static void __exit nx842_pseries_exit(void)
 	struct nx842_devdata *old_devdata;
 	unsigned long flags;
 
-	nx842_platform_driver_unset(&nx842_pseries_driver);
+	crypto_unregister_alg(&nx842_pseries_alg);
+
 	spin_lock_irqsave(&devdata_mutex, flags);
 	old_devdata = rcu_dereference_check(devdata,
 			lockdep_is_held(&devdata_mutex));
diff --git a/drivers/crypto/nx/nx-842.c b/drivers/crypto/nx/nx-842.c
index 4472e20..046c1c4 100644
--- a/drivers/crypto/nx/nx-842.c
+++ b/drivers/crypto/nx/nx-842.c
@@ -57,12 +57,8 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/crypto.h>
 #include <linux/vmalloc.h>
 #include <linux/sw842.h>
-#include <linux/ratelimit.h>
 #include <linux/spinlock.h>
 
 #include "nx-842.h"
@@ -74,7 +70,6 @@
  * buffer, and passed directly to the hardware to decompress.
  */
 #define NX842_CRYPTO_MAGIC	(0xf842)
-#define NX842_CRYPTO_GROUP_MAX	(0x20)
 #define NX842_CRYPTO_HEADER_SIZE(g)				\
 	(sizeof(struct nx842_crypto_header) +			\
 	 sizeof(struct nx842_crypto_header_group) * (g))
@@ -90,19 +85,6 @@
 #define COMP_BUSY_TIMEOUT	(250) /* ms */
 #define DECOMP_BUSY_TIMEOUT	(50) /* ms */
 
-struct nx842_crypto_header_group {
-	__be16 padding;			/* unused bytes at start of group */
-	__be32 compressed_length;	/* compressed bytes in group */
-	__be32 uncompressed_length;	/* bytes after decompression */
-} __packed;
-
-struct nx842_crypto_header {
-	__be16 magic;		/* NX842_CRYPTO_MAGIC */
-	__be16 ignore;		/* decompressed end bytes to ignore */
-	u8 groups;		/* total groups in this header */
-	struct nx842_crypto_header_group group[];
-} __packed;
-
 struct nx842_crypto_param {
 	u8 *in;
 	unsigned int iremain;
@@ -128,22 +110,13 @@ static int update_param(struct nx842_crypto_param *p,
 	return 0;
 }
 
-struct nx842_crypto_ctx {
-	spinlock_t lock;
-
-	u8 *wmem;
-	u8 *sbounce, *dbounce;
-
-	struct nx842_crypto_header header;
-	struct nx842_crypto_header_group group[NX842_CRYPTO_GROUP_MAX];
-};
-
-static int nx842_crypto_init(struct crypto_tfm *tfm)
+int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver)
 {
 	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 
 	spin_lock_init(&ctx->lock);
-	ctx->wmem = kmalloc(nx842_workmem_size(), GFP_KERNEL);
+	ctx->driver = driver;
+	ctx->wmem = kmalloc(driver->workmem_size, GFP_KERNEL);
 	ctx->sbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	ctx->dbounce = (u8 *)__get_free_pages(GFP_KERNEL, BOUNCE_BUFFER_ORDER);
 	if (!ctx->wmem || !ctx->sbounce || !ctx->dbounce) {
@@ -155,8 +128,9 @@ static int nx842_crypto_init(struct crypto_tfm *tfm)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(nx842_crypto_init);
 
-static void nx842_crypto_exit(struct crypto_tfm *tfm)
+void nx842_crypto_exit(struct crypto_tfm *tfm)
 {
 	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 
@@ -164,6 +138,7 @@ static void nx842_crypto_exit(struct crypto_tfm *tfm)
 	free_page((unsigned long)ctx->sbounce);
 	free_page((unsigned long)ctx->dbounce);
 }
+EXPORT_SYMBOL_GPL(nx842_crypto_exit);
 
 static void check_constraints(struct nx842_constraints *c)
 {
@@ -250,9 +225,7 @@ nospc:
 	timeout = ktime_add_ms(ktime_get(), COMP_BUSY_TIMEOUT);
 	do {
 		dlen = tmplen; /* reset dlen, if we're retrying */
-		ret = nx842_platform_driver()->compress(src, slen,
-							dst, &dlen,
-							ctx->wmem);
+		ret = ctx->driver->compress(src, slen, dst, &dlen, ctx->wmem);
 		/* possibly we should reduce the slen here, instead of
 		 * retrying with the dbounce buffer?
 		 */
@@ -282,14 +255,14 @@ nospc:
 	return update_param(p, slen, dskip + dlen);
 }
 
-static int nx842_crypto_compress(struct crypto_tfm *tfm,
-				 const u8 *src, unsigned int slen,
-				 u8 *dst, unsigned int *dlen)
+int nx842_crypto_compress(struct crypto_tfm *tfm,
+			  const u8 *src, unsigned int slen,
+			  u8 *dst, unsigned int *dlen)
 {
 	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct nx842_crypto_header *hdr = &ctx->header;
 	struct nx842_crypto_param p;
-	struct nx842_constraints c = *nx842_platform_driver()->constraints;
+	struct nx842_constraints c = *ctx->driver->constraints;
 	unsigned int groups, hdrsize, h;
 	int ret, n;
 	bool add_header;
@@ -366,6 +339,7 @@ unlock:
 	spin_unlock_bh(&ctx->lock);
 	return ret;
 }
+EXPORT_SYMBOL_GPL(nx842_crypto_compress);
 
 static int decompress(struct nx842_crypto_ctx *ctx,
 		      struct nx842_crypto_param *p,
@@ -429,9 +403,7 @@ static int decompress(struct nx842_crypto_ctx *ctx,
 	timeout = ktime_add_ms(ktime_get(), DECOMP_BUSY_TIMEOUT);
 	do {
 		dlen = tmplen; /* reset dlen, if we're retrying */
-		ret = nx842_platform_driver()->decompress(src, slen,
-							  dst, &dlen,
-							  ctx->wmem);
+		ret = ctx->driver->decompress(src, slen, dst, &dlen, ctx->wmem);
 	} while (ret == -EBUSY && ktime_before(ktime_get(), timeout));
 	if (ret) {
 usesw:
@@ -467,14 +439,14 @@ usesw:
 	return update_param(p, slen + padding, dlen);
 }
 
-static int nx842_crypto_decompress(struct crypto_tfm *tfm,
-				   const u8 *src, unsigned int slen,
-				   u8 *dst, unsigned int *dlen)
+int nx842_crypto_decompress(struct crypto_tfm *tfm,
+			    const u8 *src, unsigned int slen,
+			    u8 *dst, unsigned int *dlen)
 {
 	struct nx842_crypto_ctx *ctx = crypto_tfm_ctx(tfm);
 	struct nx842_crypto_header *hdr;
 	struct nx842_crypto_param p;
-	struct nx842_constraints c = *nx842_platform_driver()->constraints;
+	struct nx842_constraints c = *ctx->driver->constraints;
 	int n, ret, hdr_len;
 	u16 ignore = 0;
 
@@ -552,49 +524,8 @@ unlock:
 
 	return ret;
 }
-
-static struct crypto_alg alg = {
-	.cra_name		= "842",
-	.cra_driver_name	= "842-nx",
-	.cra_priority		= 300,
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct nx842_crypto_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_init		= nx842_crypto_init,
-	.cra_exit		= nx842_crypto_exit,
-	.cra_u			= { .compress = {
-	.coa_compress		= nx842_crypto_compress,
-	.coa_decompress		= nx842_crypto_decompress } }
-};
-
-static int __init nx842_crypto_mod_init(void)
-{
-	request_module("nx-compress-powernv");
-	request_module("nx-compress-pseries");
-
-	/* we prevent loading/registering if there's no platform driver,
-	 * and we get the platform module that set it so it won't unload,
-	 * so we don't need to check if it's set in any of our functions
-	 */
-	if (!nx842_platform_driver_get()) {
-		pr_err("no nx842 platform driver found.\n");
-		return -ENODEV;
-	}
-
-	return crypto_register_alg(&alg);
-}
-module_init(nx842_crypto_mod_init);
-
-static void __exit nx842_crypto_mod_exit(void)
-{
-	crypto_unregister_alg(&alg);
-
-	nx842_platform_driver_put();
-}
-module_exit(nx842_crypto_mod_exit);
+EXPORT_SYMBOL_GPL(nx842_crypto_decompress);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("IBM PowerPC Nest (NX) 842 Hardware Compression Driver");
-MODULE_ALIAS_CRYPTO("842");
-MODULE_ALIAS_CRYPTO("842-nx");
 MODULE_AUTHOR("Dan Streetman <ddstreet@ieee.org>");
diff --git a/drivers/crypto/nx/nx-842.h b/drivers/crypto/nx/nx-842.h
index c7dd0a4..a4eee3b 100644
--- a/drivers/crypto/nx/nx-842.h
+++ b/drivers/crypto/nx/nx-842.h
@@ -3,8 +3,9 @@
 #define __NX_842_H__
 
 #include <linux/kernel.h>
+#include <linux/init.h>
 #include <linux/module.h>
-#include <linux/sw842.h>
+#include <linux/crypto.h>
 #include <linux/of.h>
 #include <linux/slab.h>
 #include <linux/io.h>
@@ -145,10 +146,40 @@ struct nx842_driver {
 			  void *wrkmem);
 };
 
-struct nx842_driver *nx842_platform_driver(void);
-bool nx842_platform_driver_set(struct nx842_driver *driver);
-void nx842_platform_driver_unset(struct nx842_driver *driver);
-bool nx842_platform_driver_get(void);
-void nx842_platform_driver_put(void);
+struct nx842_crypto_header_group {
+	__be16 padding;			/* unused bytes at start of group */
+	__be32 compressed_length;	/* compressed bytes in group */
+	__be32 uncompressed_length;	/* bytes after decompression */
+} __packed;
+
+struct nx842_crypto_header {
+	__be16 magic;		/* NX842_CRYPTO_MAGIC */
+	__be16 ignore;		/* decompressed end bytes to ignore */
+	u8 groups;		/* total groups in this header */
+	struct nx842_crypto_header_group group[];
+} __packed;
+
+#define NX842_CRYPTO_GROUP_MAX	(0x20)
+
+struct nx842_crypto_ctx {
+	spinlock_t lock;
+
+	u8 *wmem;
+	u8 *sbounce, *dbounce;
+
+	struct nx842_crypto_header header;
+	struct nx842_crypto_header_group group[NX842_CRYPTO_GROUP_MAX];
+
+	struct nx842_driver *driver;
+};
+
+int nx842_crypto_init(struct crypto_tfm *tfm, struct nx842_driver *driver);
+void nx842_crypto_exit(struct crypto_tfm *tfm);
+int nx842_crypto_compress(struct crypto_tfm *tfm,
+			  const u8 *src, unsigned int slen,
+			  u8 *dst, unsigned int *dlen);
+int nx842_crypto_decompress(struct crypto_tfm *tfm,
+			    const u8 *src, unsigned int slen,
+			    u8 *dst, unsigned int *dlen);
 
 #endif /* __NX_842_H__ */
-- 
2.1.0
