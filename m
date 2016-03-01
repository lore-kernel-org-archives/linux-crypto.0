From: Gary R Hook <gary.hook@amd.com>
Subject: [PATCH 3/4] crypto: ccp - CCP versioning support
Date: Tue, 1 Mar 2016 13:49:15 -0600
Message-ID: <20160301194915.6788.33941.stgit@taos.amd.com>
References: <20160301194831.6788.2154.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <thomas.lendacky@amd.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0077.outbound.protection.outlook.com ([65.55.169.77]:21849
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752499AbcCAUFd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Mar 2016 15:05:33 -0500
In-Reply-To: <20160301194831.6788.2154.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Future hardware may introduce new algorithms wherein the
driver will need to manage resources for different versions
of the cryptographic coprocessor. This precursor patch
determines the version of the available device, and marks
and registers algorithms accordingly. A structure is added
which manages the version-specific data.

Signed-off-by: Gary R Hook <gary.hook@amd.com>
---
 drivers/crypto/ccp/ccp-crypto-aes.c |   12 ++++++++++-
 drivers/crypto/ccp/ccp-crypto-sha.c |    9 +++++++-
 drivers/crypto/ccp/ccp-dev.c        |   27 ++++++++++++++++++++++++
 drivers/crypto/ccp/ccp-dev.h        |    8 +++++++
 drivers/crypto/ccp/ccp-pci.c        |    8 ++++++-
 drivers/crypto/ccp/ccp-platform.c   |   39 +++++++++++++++++++++++++++++++++--
 include/linux/ccp.h                 |   17 +++++++++++++++
 7 files changed, 115 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes.c b/drivers/crypto/ccp/ccp-crypto-aes.c
index 7984f91..89291c1 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) AES crypto API support
  *
- * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  *
@@ -259,6 +259,7 @@ static struct crypto_alg ccp_aes_rfc3686_defaults = {
 
 struct ccp_aes_def {
 	enum ccp_aes_mode mode;
+	unsigned int version;
 	const char *name;
 	const char *driver_name;
 	unsigned int blocksize;
@@ -269,6 +270,7 @@ struct ccp_aes_def {
 static struct ccp_aes_def aes_algs[] = {
 	{
 		.mode		= CCP_AES_MODE_ECB,
+		.version	= CCP_VERSION(3, 0),
 		.name		= "ecb(aes)",
 		.driver_name	= "ecb-aes-ccp",
 		.blocksize	= AES_BLOCK_SIZE,
@@ -277,6 +279,7 @@ static struct ccp_aes_def aes_algs[] = {
 	},
 	{
 		.mode		= CCP_AES_MODE_CBC,
+		.version	= CCP_VERSION(3, 0),
 		.name		= "cbc(aes)",
 		.driver_name	= "cbc-aes-ccp",
 		.blocksize	= AES_BLOCK_SIZE,
@@ -285,6 +288,7 @@ static struct ccp_aes_def aes_algs[] = {
 	},
 	{
 		.mode		= CCP_AES_MODE_CFB,
+		.version	= CCP_VERSION(3, 0),
 		.name		= "cfb(aes)",
 		.driver_name	= "cfb-aes-ccp",
 		.blocksize	= AES_BLOCK_SIZE,
@@ -293,6 +297,7 @@ static struct ccp_aes_def aes_algs[] = {
 	},
 	{
 		.mode		= CCP_AES_MODE_OFB,
+		.version	= CCP_VERSION(3, 0),
 		.name		= "ofb(aes)",
 		.driver_name	= "ofb-aes-ccp",
 		.blocksize	= 1,
@@ -301,6 +306,7 @@ static struct ccp_aes_def aes_algs[] = {
 	},
 	{
 		.mode		= CCP_AES_MODE_CTR,
+		.version	= CCP_VERSION(3, 0),
 		.name		= "ctr(aes)",
 		.driver_name	= "ctr-aes-ccp",
 		.blocksize	= 1,
@@ -309,6 +315,7 @@ static struct ccp_aes_def aes_algs[] = {
 	},
 	{
 		.mode		= CCP_AES_MODE_CTR,
+		.version	= CCP_VERSION(3, 0),
 		.name		= "rfc3686(ctr(aes))",
 		.driver_name	= "rfc3686-ctr-aes-ccp",
 		.blocksize	= 1,
@@ -357,8 +364,11 @@ static int ccp_register_aes_alg(struct list_head *head,
 int ccp_register_aes_algs(struct list_head *head)
 {
 	int i, ret;
+	unsigned int ccpversion = ccp_version();
 
 	for (i = 0; i < ARRAY_SIZE(aes_algs); i++) {
+		if (aes_algs[i].version > ccpversion)
+			continue;
 		ret = ccp_register_aes_alg(head, &aes_algs[i]);
 		if (ret)
 			return ret;
diff --git a/drivers/crypto/ccp/ccp-crypto-sha.c b/drivers/crypto/ccp/ccp-crypto-sha.c
index 8ef06fa..b5ad728 100644
--- a/drivers/crypto/ccp/ccp-crypto-sha.c
+++ b/drivers/crypto/ccp/ccp-crypto-sha.c
@@ -1,7 +1,7 @@
 /*
  * AMD Cryptographic Coprocessor (CCP) SHA crypto API support
  *
- * Copyright (C) 2013 Advanced Micro Devices, Inc.
+ * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
  *
  * Author: Tom Lendacky <thomas.lendacky@amd.com>
  *
@@ -341,6 +341,7 @@ static void ccp_hmac_sha_cra_exit(struct crypto_tfm *tfm)
 }
 
 struct ccp_sha_def {
+	unsigned int version;
 	const char *name;
 	const char *drv_name;
 	enum ccp_sha_type type;
@@ -350,6 +351,7 @@ struct ccp_sha_def {
 
 static struct ccp_sha_def sha_algs[] = {
 	{
+		.version	= CCP_VERSION(3, 0),
 		.name		= "sha1",
 		.drv_name	= "sha1-ccp",
 		.type		= CCP_SHA_TYPE_1,
@@ -357,6 +359,7 @@ static struct ccp_sha_def sha_algs[] = {
 		.block_size	= SHA1_BLOCK_SIZE,
 	},
 	{
+		.version	= CCP_VERSION(3, 0),
 		.name		= "sha224",
 		.drv_name	= "sha224-ccp",
 		.type		= CCP_SHA_TYPE_224,
@@ -364,6 +367,7 @@ static struct ccp_sha_def sha_algs[] = {
 		.block_size	= SHA224_BLOCK_SIZE,
 	},
 	{
+		.version	= CCP_VERSION(3, 0),
 		.name		= "sha256",
 		.drv_name	= "sha256-ccp",
 		.type		= CCP_SHA_TYPE_256,
@@ -480,8 +484,11 @@ static int ccp_register_sha_alg(struct list_head *head,
 int ccp_register_sha_algs(struct list_head *head)
 {
 	int i, ret;
+	unsigned int ccpversion = ccp_version();
 
 	for (i = 0; i < ARRAY_SIZE(sha_algs); i++) {
+		if (sha_algs[i].version > ccpversion)
+			continue;
 		ret = ccp_register_sha_alg(head, &sha_algs[i]);
 		if (ret)
 			return ret;
diff --git a/drivers/crypto/ccp/ccp-dev.c b/drivers/crypto/ccp/ccp-dev.c
index dd71e67..5348512 100644
--- a/drivers/crypto/ccp/ccp-dev.c
+++ b/drivers/crypto/ccp/ccp-dev.c
@@ -150,6 +150,29 @@ int ccp_present(void)
 EXPORT_SYMBOL_GPL(ccp_present);
 
 /**
+ * ccp_version - get the version of the CCP device
+ *
+ * Returns the version from the first unit on the list;
+ * otherwise a zero if no CCP device is present
+ */
+unsigned int ccp_version(void)
+{
+	struct ccp_device *dp;
+	unsigned long flags;
+	int ret = 0;
+
+	read_lock_irqsave(&ccp_unit_lock, flags);
+	if (!list_empty(&ccp_units)) {
+		dp = list_first_entry(&ccp_units, struct ccp_device, entry);
+		ret = dp->vdata->version;
+	}
+	read_unlock_irqrestore(&ccp_unit_lock, flags);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(ccp_version);
+
+/**
  * ccp_enqueue_cmd - queue an operation for processing by the CCP
  *
  * @cmd: ccp_cmd struct to be processed
@@ -664,6 +687,10 @@ bool ccp_queues_suspended(struct ccp_device *ccp)
 }
 #endif
 
+struct ccp_vdata ccpv3 = {
+	.version = CCP_VERSION(3, 0),
+};
+
 static int __init ccp_mod_init(void)
 {
 #ifdef CONFIG_X86
diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index 974dc05..90a8cc8 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -141,6 +141,13 @@
 #define CCP_ECC_RESULT_OFFSET		60
 #define CCP_ECC_RESULT_SUCCESS		0x0001
 
+/* Structure to hold CCP version-specific values */
+struct ccp_vdata {
+	unsigned int version;
+};
+
+extern struct ccp_vdata ccpv3;
+
 struct ccp_device;
 struct ccp_cmd;
 
@@ -187,6 +194,7 @@ struct ccp_cmd_queue {
 struct ccp_device {
 	struct list_head entry;
 
+	struct ccp_vdata *vdata;
 	unsigned int ord;
 	char name[MAX_CCP_NAME_LEN];
 	char rngname[MAX_CCP_NAME_LEN];
diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index 668e515..d1a36af 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -180,6 +180,12 @@ static int ccp_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto e_err;
 
 	ccp->dev_specific = ccp_pci;
+	ccp->vdata = (struct ccp_vdata *)id->driver_data;
+	if (!ccp->vdata || !ccp->vdata->version) {
+		ret = -ENODEV;
+		dev_err(dev, "missing driver data\n");
+		goto e_err;
+	}
 	ccp->get_irq = ccp_get_irqs;
 	ccp->free_irq = ccp_free_irqs;
 
@@ -313,7 +319,7 @@ static int ccp_pci_resume(struct pci_dev *pdev)
 #endif
 
 static const struct pci_device_id ccp_pci_table[] = {
-	{ PCI_VDEVICE(AMD, 0x1537), },
+	{ PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&ccpv3 },
 	/* Last entry must be zero */
 	{ 0, }
 };
diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index 4331318..6e1cf22 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -32,6 +32,33 @@ struct ccp_platform {
 	int coherent;
 };
 
+static const struct acpi_device_id ccp_acpi_match[];
+static const struct of_device_id ccp_of_match[];
+
+static struct ccp_vdata *ccp_get_of_version(struct platform_device *pdev)
+{
+#ifdef CONFIG_OF
+	const struct of_device_id *match;
+
+	match = of_match_node(ccp_of_match, pdev->dev.of_node);
+	if (match && match->data)
+		return (struct ccp_vdata *)match->data;
+#endif
+	return 0;
+}
+
+static struct ccp_vdata *ccp_get_acpi_version(struct platform_device *pdev)
+{
+#ifdef CONFIG_ACPI
+	const struct acpi_device_id *match;
+
+	match = acpi_match_device(ccp_acpi_match, &pdev->dev);
+	if (match && match->driver_data)
+		return (struct ccp_vdata *)match->driver_data;
+#endif
+	return 0;
+}
+
 static int ccp_get_irq(struct ccp_device *ccp)
 {
 	struct device *dev = ccp->dev;
@@ -106,6 +133,13 @@ static int ccp_platform_probe(struct platform_device *pdev)
 		goto e_err;
 
 	ccp->dev_specific = ccp_platform;
+	ccp->vdata = pdev->dev.of_node ? ccp_get_of_version(pdev)
+					 : ccp_get_acpi_version(pdev);
+	if (!ccp->vdata || !ccp->vdata->version) {
+		ret = -ENODEV;
+		dev_err(dev, "missing driver data\n");
+		goto e_err;
+	}
 	ccp->get_irq = ccp_get_irqs;
 	ccp->free_irq = ccp_free_irqs;
 
@@ -214,7 +248,7 @@ static int ccp_platform_resume(struct platform_device *pdev)
 
 #ifdef CONFIG_ACPI
 static const struct acpi_device_id ccp_acpi_match[] = {
-	{ "AMDI0C00", 0 },
+	{ "AMDI0C00", (kernel_ulong_t)&ccpv3 },
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, ccp_acpi_match);
@@ -222,7 +256,8 @@ MODULE_DEVICE_TABLE(acpi, ccp_acpi_match);
 
 #ifdef CONFIG_OF
 static const struct of_device_id ccp_of_match[] = {
-	{ .compatible = "amd,ccp-seattle-v1a" },
+	{ .compatible = "amd,ccp-seattle-v1a",
+	  .data = (const void *)&ccpv3 },
 	{ },
 };
 MODULE_DEVICE_TABLE(of, ccp_of_match);
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index 7f43703..915af30 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -33,6 +33,18 @@ struct ccp_cmd;
  */
 int ccp_present(void);
 
+#define	CCP_VSIZE 16
+#define	CCP_VMASK		((unsigned int)((1 << CCP_VSIZE) - 1))
+#define	CCP_VERSION(v, r)	((unsigned int)((v << CCP_VSIZE) \
+					       | (r & CCP_VMASK)))
+
+/**
+ * ccp_version - get the version of the CCP
+ *
+ * Returns a positive version number, or zero if no CCP
+ */
+unsigned int ccp_version(void);
+
 /**
  * ccp_enqueue_cmd - queue an operation for processing by the CCP
  *
@@ -65,6 +77,11 @@ static inline int ccp_present(void)
 	return -ENODEV;
 }
 
+static inline unsigned int ccp_version(void)
+{
+	return 0;
+}
+
 static inline int ccp_enqueue_cmd(struct ccp_cmd *cmd)
 {
 	return -ENODEV;
