From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 04/10] staging: ccree: staging: ccree: replace sysfs by
 debugfs interface
Date: Thu, 14 Dec 2017 14:02:41 +0000
Message-ID: <1513260170-26346-5-git-send-email-gilad@benyossef.com>
References: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
 driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
 Ofir Drang <ofir.drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1513260170-26346-1-git-send-email-gilad@benyossef.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

The ccree driver has had a none standard sysfs interface for debugging.
Replace it with a proper debugfs interface.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/staging/ccree/Makefile          |   3 +-
 drivers/staging/ccree/cc_debugfs.c      | 114 +++++++++++++++++++
 drivers/staging/ccree/cc_debugfs.h      |  45 ++++++++
 drivers/staging/ccree/ssi_aead.c        |   1 -
 drivers/staging/ccree/ssi_cipher.c      |   1 -
 drivers/staging/ccree/ssi_config.h      |   2 -
 drivers/staging/ccree/ssi_driver.c      |  27 ++---
 drivers/staging/ccree/ssi_driver.h      |   2 +-
 drivers/staging/ccree/ssi_hash.c        |   1 -
 drivers/staging/ccree/ssi_pm.c          |   1 -
 drivers/staging/ccree/ssi_request_mgr.c |   1 -
 drivers/staging/ccree/ssi_sysfs.c       | 192 --------------------------------
 drivers/staging/ccree/ssi_sysfs.h       |  32 ------
 13 files changed, 176 insertions(+), 246 deletions(-)
 create mode 100644 drivers/staging/ccree/cc_debugfs.c
 create mode 100644 drivers/staging/ccree/cc_debugfs.h
 delete mode 100644 drivers/staging/ccree/ssi_sysfs.c
 delete mode 100644 drivers/staging/ccree/ssi_sysfs.h

diff --git a/drivers/staging/ccree/Makefile b/drivers/staging/ccree/Makefile
index ae702f3..ab9f073 100644
--- a/drivers/staging/ccree/Makefile
+++ b/drivers/staging/ccree/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_CRYPTO_DEV_CCREE) := ccree.o
-ccree-y := ssi_driver.o ssi_sysfs.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_aead.o ssi_ivgen.o ssi_sram_mgr.o ssi_pm.o
+ccree-y := ssi_driver.o ssi_buffer_mgr.o ssi_request_mgr.o ssi_cipher.o ssi_hash.o ssi_aead.o ssi_ivgen.o ssi_sram_mgr.o ssi_pm.o
 ccree-$(CONFIG_CRYPTO_FIPS) += ssi_fips.o
+ccree-$(CONFIG_DEBUG_FS) += cc_debugfs.o
diff --git a/drivers/staging/ccree/cc_debugfs.c b/drivers/staging/ccree/cc_debugfs.c
new file mode 100644
index 0000000..7768a7b
--- /dev/null
+++ b/drivers/staging/ccree/cc_debugfs.c
@@ -0,0 +1,114 @@
+/*
+ * Copyright (C) 2012-2017 ARM Limited or its affiliates.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/kernel.h>
+#include <linux/debugfs.h>
+#include <linux/stringify.h>
+#include "ssi_config.h"
+#include "ssi_driver.h"
+#include "cc_crypto_ctx.h"
+
+struct cc_debugfs_ctx {
+	struct dentry *dir;
+};
+
+#define CC_DEBUG_REG(_X) {	\
+	.name = __stringify(_X),\
+	.offset = CC_REG(_X)	\
+	}
+
+/*
+ * This is a global var for the dentry of the
+ * debugfs ccree/ dir. It is not tied down to
+ * a specific instance of ccree, hence it is
+ * global.
+ */
+static struct dentry *cc_debugfs_dir;
+
+struct debugfs_reg32 debug_regs[] = {
+	CC_DEBUG_REG(HOST_SIGNATURE),
+	CC_DEBUG_REG(HOST_IRR),
+	CC_DEBUG_REG(HOST_POWER_DOWN_EN),
+	CC_DEBUG_REG(AXIM_MON_ERR),
+	CC_DEBUG_REG(DSCRPTR_QUEUE_CONTENT),
+	CC_DEBUG_REG(HOST_IMR),
+	CC_DEBUG_REG(AXIM_CFG),
+	CC_DEBUG_REG(AXIM_CACHE_PARAMS),
+	CC_DEBUG_REG(HOST_VERSION),
+	CC_DEBUG_REG(GPR_HOST),
+	CC_DEBUG_REG(AXIM_MON_COMP),
+};
+
+int cc_debugfs_global_init(void)
+{
+	cc_debugfs_dir = debugfs_create_dir("ccree", NULL);
+
+	return !cc_debugfs_dir;
+}
+
+void cc_debugfs_global_fini(void)
+{
+	debugfs_remove(cc_debugfs_dir);
+}
+
+int cc_debugfs_init(struct cc_drvdata *drvdata)
+{
+	struct device *dev = drvdata_to_dev(drvdata);
+	struct cc_debugfs_ctx *ctx;
+	struct debugfs_regset32 *regset;
+	struct dentry *file;
+
+	ctx = devm_kzalloc(dev, sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return -ENOMEM;
+
+	regset = devm_kzalloc(dev, sizeof(*regset), GFP_KERNEL);
+	if (!regset)
+		return -ENOMEM;
+
+	regset->regs = debug_regs;
+	regset->nregs = ARRAY_SIZE(debug_regs);
+	regset->base = drvdata->cc_base;
+
+	ctx->dir = debugfs_create_dir(drvdata->plat_dev->name, cc_debugfs_dir);
+	if (!ctx->dir)
+		return -ENFILE;
+
+	file = debugfs_create_regset32("regs", 0400, ctx->dir, regset);
+	if (!file) {
+		debugfs_remove(ctx->dir);
+		return -ENFILE;
+	}
+
+	file = debugfs_create_bool("coherent", 0400, ctx->dir,
+				   &drvdata->coherent);
+
+	if (!file) {
+		debugfs_remove_recursive(ctx->dir);
+		return -ENFILE;
+	}
+
+	drvdata->debugfs = ctx;
+
+	return 0;
+}
+
+void cc_debugfs_fini(struct cc_drvdata *drvdata)
+{
+	struct cc_debugfs_ctx *ctx = (struct cc_debugfs_ctx *)drvdata->debugfs;
+
+	debugfs_remove_recursive(ctx->dir);
+}
diff --git a/drivers/staging/ccree/cc_debugfs.h b/drivers/staging/ccree/cc_debugfs.h
new file mode 100644
index 0000000..edfe9ba
--- /dev/null
+++ b/drivers/staging/ccree/cc_debugfs.h
@@ -0,0 +1,45 @@
+/*
+ * Copyright (C) 2012-2017 ARM Limited or its affiliates.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __CC_DEBUGFS_H__
+#define __CC_DEBUGFS_H__
+
+#ifdef CONFIG_DEBUG_FS
+int cc_debugfs_global_init(void);
+void cc_debugfs_global_fini(void);
+
+int cc_debugfs_init(struct cc_drvdata *drvdata);
+void cc_debugfs_fini(struct cc_drvdata *drvdata);
+
+#else
+
+int cc_debugfs_global_init(void)
+{
+	return 0;
+}
+
+void cc_debugfs_global_fini(void) {}
+
+int cc_debugfs_init(struct cc_drvdata *drvdata)
+{
+	return 0;
+}
+
+void cc_debugfs_fini(struct cc_drvdata *drvdata) {}
+
+#endif
+
+#endif /*__CC_SYSFS_H__*/
diff --git a/drivers/staging/ccree/ssi_aead.c b/drivers/staging/ccree/ssi_aead.c
index 12ceb119..dde6797 100644
--- a/drivers/staging/ccree/ssi_aead.c
+++ b/drivers/staging/ccree/ssi_aead.c
@@ -34,7 +34,6 @@
 #include "ssi_aead.h"
 #include "ssi_request_mgr.h"
 #include "ssi_hash.h"
-#include "ssi_sysfs.h"
 #include "ssi_sram_mgr.h"
 
 #define template_aead	template_u.aead
diff --git a/drivers/staging/ccree/ssi_cipher.c b/drivers/staging/ccree/ssi_cipher.c
index 791fe75..f940568 100644
--- a/drivers/staging/ccree/ssi_cipher.c
+++ b/drivers/staging/ccree/ssi_cipher.c
@@ -32,7 +32,6 @@
 #include "ssi_buffer_mgr.h"
 #include "ssi_cipher.h"
 #include "ssi_request_mgr.h"
-#include "ssi_sysfs.h"
 
 #define MAX_ABLKCIPHER_SEQ_LEN 6
 
diff --git a/drivers/staging/ccree/ssi_config.h b/drivers/staging/ccree/ssi_config.h
index ee2d310..15725cc 100644
--- a/drivers/staging/ccree/ssi_config.h
+++ b/drivers/staging/ccree/ssi_config.h
@@ -28,8 +28,6 @@
 //#define CC_DUMP_DESCS
 // #define CC_DUMP_BYTES
 // #define CC_DEBUG
-/* Enable sysfs interface for debugging REE driver */
-#define ENABLE_CC_SYSFS
 //#define CC_IRQ_DELAY 100000
 /* was 32 bit, but for juno's sake it was enlarged to 48 bit */
 #define DMA_BIT_MASK_LEN	48
diff --git a/drivers/staging/ccree/ssi_driver.c b/drivers/staging/ccree/ssi_driver.c
index 5427c7f..14705dc 100644
--- a/drivers/staging/ccree/ssi_driver.c
+++ b/drivers/staging/ccree/ssi_driver.c
@@ -63,7 +63,7 @@
 #include "ssi_driver.h"
 #include "ssi_request_mgr.h"
 #include "ssi_buffer_mgr.h"
-#include "ssi_sysfs.h"
+#include "cc_debugfs.h"
 #include "ssi_cipher.h"
 #include "ssi_aead.h"
 #include "ssi_hash.h"
@@ -299,18 +299,16 @@ static int init_cc_resources(struct platform_device *plat_dev)
 		goto post_clk_err;
 	}
 
-#ifdef ENABLE_CC_SYSFS
-	rc = ssi_sysfs_init(&dev->kobj, new_drvdata);
+	rc = cc_debugfs_init(new_drvdata);
 	if (rc) {
-		dev_err(dev, "init_stat_db failed\n");
+		dev_err(dev, "Failed registering debugfs interface\n");
 		goto post_regs_err;
 	}
-#endif
 
 	rc = cc_fips_init(new_drvdata);
 	if (rc) {
 		dev_err(dev, "CC_FIPS_INIT failed 0x%x\n", rc);
-		goto post_sysfs_err;
+		goto post_debugfs_err;
 	}
 	rc = cc_sram_mgr_init(new_drvdata);
 	if (rc) {
@@ -394,10 +392,8 @@ static int init_cc_resources(struct platform_device *plat_dev)
 	cc_sram_mgr_fini(new_drvdata);
 post_fips_init_err:
 	cc_fips_fini(new_drvdata);
-post_sysfs_err:
-#ifdef ENABLE_CC_SYSFS
-	ssi_sysfs_fini();
-#endif
+post_debugfs_err:
+	cc_debugfs_fini(new_drvdata);
 post_regs_err:
 	fini_cc_regs(new_drvdata);
 post_clk_err:
@@ -425,9 +421,7 @@ static void cleanup_cc_resources(struct platform_device *plat_dev)
 	cc_req_mgr_fini(drvdata);
 	cc_sram_mgr_fini(drvdata);
 	cc_fips_fini(drvdata);
-#ifdef ENABLE_CC_SYSFS
-	ssi_sysfs_fini();
-#endif
+	cc_debugfs_fini(drvdata);
 	fini_cc_regs(drvdata);
 	cc_clk_off(drvdata);
 }
@@ -520,6 +514,12 @@ static struct platform_driver cc7x_driver = {
 
 static int __init ccree_init(void)
 {
+	int ret;
+
+	ret = cc_debugfs_global_init();
+	if (ret)
+		return ret;
+
 	return platform_driver_register(&cc7x_driver);
 }
 module_init(ccree_init);
@@ -527,6 +527,7 @@ module_init(ccree_init);
 static void __exit ccree_exit(void)
 {
 	platform_driver_unregister(&cc7x_driver);
+	cc_debugfs_global_fini();
 }
 module_exit(ccree_exit);
 
diff --git a/drivers/staging/ccree/ssi_driver.h b/drivers/staging/ccree/ssi_driver.h
index 35e1b72..4e05386 100644
--- a/drivers/staging/ccree/ssi_driver.h
+++ b/drivers/staging/ccree/ssi_driver.h
@@ -44,7 +44,6 @@
 #include "dx_reg_common.h"
 #define CC_SUPPORT_SHA CC_DEV_SHA_MAX
 #include "cc_crypto_ctx.h"
-#include "ssi_sysfs.h"
 #include "hash_defs.h"
 #include "cc_hw_queue_defs.h"
 #include "ssi_sram_mgr.h"
@@ -127,6 +126,7 @@ struct cc_drvdata {
 	void *fips_handle;
 	void *ivgen_handle;
 	void *sram_mgr_handle;
+	void *debugfs;
 	struct clk *clk;
 	bool coherent;
 };
diff --git a/drivers/staging/ccree/ssi_hash.c b/drivers/staging/ccree/ssi_hash.c
index 5794ab6..0aea404 100644
--- a/drivers/staging/ccree/ssi_hash.c
+++ b/drivers/staging/ccree/ssi_hash.c
@@ -27,7 +27,6 @@
 #include "ssi_driver.h"
 #include "ssi_request_mgr.h"
 #include "ssi_buffer_mgr.h"
-#include "ssi_sysfs.h"
 #include "ssi_hash.h"
 #include "ssi_sram_mgr.h"
 
diff --git a/drivers/staging/ccree/ssi_pm.c b/drivers/staging/ccree/ssi_pm.c
index 0db935d..abc715e 100644
--- a/drivers/staging/ccree/ssi_pm.c
+++ b/drivers/staging/ccree/ssi_pm.c
@@ -24,7 +24,6 @@
 #include "ssi_buffer_mgr.h"
 #include "ssi_request_mgr.h"
 #include "ssi_sram_mgr.h"
-#include "ssi_sysfs.h"
 #include "ssi_ivgen.h"
 #include "ssi_hash.h"
 #include "ssi_pm.h"
diff --git a/drivers/staging/ccree/ssi_request_mgr.c b/drivers/staging/ccree/ssi_request_mgr.c
index 480e6d3..07b9404 100644
--- a/drivers/staging/ccree/ssi_request_mgr.c
+++ b/drivers/staging/ccree/ssi_request_mgr.c
@@ -27,7 +27,6 @@
 #include "ssi_driver.h"
 #include "ssi_buffer_mgr.h"
 #include "ssi_request_mgr.h"
-#include "ssi_sysfs.h"
 #include "ssi_ivgen.h"
 #include "ssi_pm.h"
 
diff --git a/drivers/staging/ccree/ssi_sysfs.c b/drivers/staging/ccree/ssi_sysfs.c
deleted file mode 100644
index b2e58f5..0000000
--- a/drivers/staging/ccree/ssi_sysfs.c
+++ /dev/null
@@ -1,192 +0,0 @@
-/*
- * Copyright (C) 2012-2017 ARM Limited or its affiliates.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/kernel.h>
-#include "ssi_config.h"
-#include "ssi_driver.h"
-#include "cc_crypto_ctx.h"
-#include "ssi_sysfs.h"
-
-#ifdef ENABLE_CC_SYSFS
-
-static struct cc_drvdata *sys_get_drvdata(void);
-
-static ssize_t ssi_sys_regdump_show(struct kobject *kobj,
-				    struct kobj_attribute *attr, char *buf)
-{
-	struct cc_drvdata *drvdata = sys_get_drvdata();
-	u32 register_value;
-	int offset = 0;
-
-	register_value = cc_ioread(drvdata, CC_REG(HOST_SIGNATURE));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
-			    "%s \t(0x%lX)\t 0x%08X\n", "HOST_SIGNATURE       ",
-			    CC_HOST_SIGNATURE_REG_OFFSET, register_value);
-	register_value = cc_ioread(drvdata, CC_REG(HOST_IRR));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
-			    "%s \t(0x%lX)\t 0x%08X\n", "HOST_IRR             ",
-			    CC_HOST_IRR_REG_OFFSET, register_value);
-	register_value = cc_ioread(drvdata, CC_REG(HOST_POWER_DOWN_EN));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
-			    "%s \t(0x%lX)\t 0x%08X\n", "HOST_POWER_DOWN_EN   ",
-			    CC_HOST_POWER_DOWN_EN_REG_OFFSET, register_value);
-	register_value =  cc_ioread(drvdata, CC_REG(AXIM_MON_ERR));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
-			    "%s \t(0x%lX)\t 0x%08X\n", "AXIM_MON_ERR         ",
-			    CC_AXIM_MON_ERR_REG_OFFSET, register_value);
-	register_value = cc_ioread(drvdata, CC_REG(DSCRPTR_QUEUE_CONTENT));
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset,
-			    "%s \t(0x%lX)\t 0x%08X\n", "DSCRPTR_QUEUE_CONTENT",
-			    CC_DSCRPTR_QUEUE_CONTENT_REG_OFFSET,
-			    register_value);
-	return offset;
-}
-
-static ssize_t ssi_sys_help_show(struct kobject *kobj,
-				 struct kobj_attribute *attr, char *buf)
-{
-	static const char * const help_str[] = {
-				"cat reg_dump              ",
-				"Print several of CC register values",
-				};
-	int i = 0, offset = 0;
-
-	offset += scnprintf(buf + offset, PAGE_SIZE - offset, "Usage:\n");
-	for (i = 0; i < ARRAY_SIZE(help_str); i += 2) {
-		offset += scnprintf(buf + offset, PAGE_SIZE - offset,
-				    "%s\t\t%s\n", help_str[i],
-				    help_str[i + 1]);
-	}
-
-	return offset;
-}
-
-/********************************************************
- *		SYSFS objects				*
- ********************************************************/
-/*
- * Structure used to create a directory
- * and its attributes in sysfs.
- */
-struct sys_dir {
-	struct kobject *sys_dir_kobj;
-	struct attribute_group sys_dir_attr_group;
-	struct attribute **sys_dir_attr_list;
-	u32 num_of_attrs;
-	struct cc_drvdata *drvdata; /* Associated driver context */
-};
-
-/* top level directory structures */
-static struct sys_dir sys_top_dir;
-
-/* TOP LEVEL ATTRIBUTES */
-static struct kobj_attribute ssi_sys_top_level_attrs[] = {
-	__ATTR(dump_regs, 0444, ssi_sys_regdump_show, NULL),
-	__ATTR(help, 0444, ssi_sys_help_show, NULL),
-#if defined CC_CYCLE_COUNT
-	__ATTR(stats_host, 0664, ssi_sys_stat_host_db_show,
-	       ssi_sys_stats_host_db_clear),
-	__ATTR(stats_cc, 0664, ssi_sys_stat_cc_db_show,
-	       ssi_sys_stats_cc_db_clear),
-#endif
-
-};
-
-static struct cc_drvdata *sys_get_drvdata(void)
-{
-	/* TODO: supporting multiple SeP devices would require avoiding
-	 * global "top_dir" and finding associated "top_dir" by traversing
-	 * up the tree to the kobject which matches one of the top_dir's
-	 */
-	return sys_top_dir.drvdata;
-}
-
-static int sys_init_dir(struct sys_dir *sys_dir, struct cc_drvdata *drvdata,
-			struct kobject *parent_dir_kobj, const char *dir_name,
-			struct kobj_attribute *attrs, u32 num_of_attrs)
-{
-	int i;
-
-	memset(sys_dir, 0, sizeof(struct sys_dir));
-
-	sys_dir->drvdata = drvdata;
-
-	/* initialize directory kobject */
-	sys_dir->sys_dir_kobj =
-		kobject_create_and_add(dir_name, parent_dir_kobj);
-
-	if (!(sys_dir->sys_dir_kobj))
-		return -ENOMEM;
-	/* allocate memory for directory's attributes list */
-	sys_dir->sys_dir_attr_list =
-		kcalloc(num_of_attrs + 1, sizeof(struct attribute *),
-			GFP_KERNEL);
-
-	if (!(sys_dir->sys_dir_attr_list)) {
-		kobject_put(sys_dir->sys_dir_kobj);
-		return -ENOMEM;
-	}
-
-	sys_dir->num_of_attrs = num_of_attrs;
-
-	/* initialize attributes list */
-	for (i = 0; i < num_of_attrs; ++i)
-		sys_dir->sys_dir_attr_list[i] = &attrs[i].attr;
-
-	/* last list entry should be NULL */
-	sys_dir->sys_dir_attr_list[num_of_attrs] = NULL;
-
-	sys_dir->sys_dir_attr_group.attrs = sys_dir->sys_dir_attr_list;
-
-	return sysfs_create_group(sys_dir->sys_dir_kobj,
-			&sys_dir->sys_dir_attr_group);
-}
-
-static void sys_free_dir(struct sys_dir *sys_dir)
-{
-	if (!sys_dir)
-		return;
-
-	kfree(sys_dir->sys_dir_attr_list);
-
-	if (sys_dir->sys_dir_kobj) {
-		sysfs_remove_group(sys_dir->sys_dir_kobj,
-				   &sys_dir->sys_dir_attr_group);
-		kobject_put(sys_dir->sys_dir_kobj);
-	}
-}
-
-int ssi_sysfs_init(struct kobject *sys_dev_obj, struct cc_drvdata *drvdata)
-{
-	int retval;
-	struct device *dev = drvdata_to_dev(drvdata);
-
-	dev_info(dev, "setup sysfs under %s\n", sys_dev_obj->name);
-
-	/* Initialize top directory */
-	retval = sys_init_dir(&sys_top_dir, drvdata, sys_dev_obj, "cc_info",
-			      ssi_sys_top_level_attrs,
-			      ARRAY_SIZE(ssi_sys_top_level_attrs));
-	return retval;
-}
-
-void ssi_sysfs_fini(void)
-{
-	sys_free_dir(&sys_top_dir);
-}
-
-#endif /*ENABLE_CC_SYSFS*/
-
diff --git a/drivers/staging/ccree/ssi_sysfs.h b/drivers/staging/ccree/ssi_sysfs.h
deleted file mode 100644
index 9833d18..0000000
--- a/drivers/staging/ccree/ssi_sysfs.h
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * Copyright (C) 2012-2017 ARM Limited or its affiliates.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, see <http://www.gnu.org/licenses/>.
- */
-
-/* \file ssi_sysfs.h
- * ARM CryptoCell sysfs APIs
- */
-
-#ifndef __CC_SYSFS_H__
-#define __CC_SYSFS_H__
-
-#include <asm/timex.h>
-
-/* forward declaration */
-struct cc_drvdata;
-
-int ssi_sysfs_init(struct kobject *sys_dev_obj, struct cc_drvdata *drvdata);
-void ssi_sysfs_fini(void);
-
-#endif /*__CC_SYSFS_H__*/
-- 
2.7.4
