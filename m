From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 5/5] crypto: ccp - Add ACPI support
Date: Tue, 3 Feb 2015 13:07:29 -0600
Message-ID: <20150203190729.15045.97370.stgit@tlendack-t1.amdoffice.net>
References: <20150203190659.15045.21329.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0111.outbound.protection.outlook.com ([157.56.110.111]:7968
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965921AbbBCTHf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Feb 2015 14:07:35 -0500
In-Reply-To: <20150203190659.15045.21329.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add support for ACPI to the CCP platform driver.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/Kconfig            |    2 -
 drivers/crypto/ccp/ccp-platform.c |   96 +++++++++++++++++++++++++++++++++++--
 2 files changed, 93 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index b840b79..7e94413 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -391,7 +391,7 @@ config CRYPTO_DEV_ATMEL_SHA
 
 config CRYPTO_DEV_CCP
 	bool "Support for AMD Cryptographic Coprocessor"
-	depends on ((X86 && PCI) || ARM64) && HAS_IOMEM
+	depends on ((X86 && PCI) || (ARM64 && (OF_ADDRESS || ACPI))) && HAS_IOMEM
 	default n
 	help
 	  The AMD Cryptographic Coprocessor provides hardware support
diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index 20661f0..b1c20b2 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -23,9 +23,16 @@
 #include <linux/delay.h>
 #include <linux/ccp.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/acpi.h>
 
 #include "ccp-dev.h"
 
+struct ccp_platform {
+	int use_acpi;
+	int coherent;
+};
+
 static int ccp_get_irq(struct ccp_device *ccp)
 {
 	struct device *dev = ccp->dev;
@@ -83,10 +90,64 @@ static struct resource *ccp_find_mmio_area(struct ccp_device *ccp)
 	return NULL;
 }
 
+#ifdef CONFIG_ACPI
+static int ccp_acpi_support(struct ccp_device *ccp)
+{
+	struct ccp_platform *ccp_platform = ccp->dev_specific;
+	struct acpi_device *adev = ACPI_COMPANION(ccp->dev);
+	acpi_handle handle;
+	acpi_status status;
+	unsigned long long data;
+	int cca;
+
+	/* Retrieve the device cache coherency value */
+	handle = adev->handle;
+	do {
+		status = acpi_evaluate_integer(handle, "_CCA", NULL, &data);
+		if (!ACPI_FAILURE(status)) {
+			cca = data;
+			break;
+		}
+	} while (!ACPI_FAILURE(status));
+
+	if (ACPI_FAILURE(status)) {
+		dev_err(ccp->dev, "error obtaining acpi coherency value\n");
+		return -EINVAL;
+	}
+
+	ccp_platform->coherent = !!cca;
+
+	return 0;
+}
+#else	/* CONFIG_ACPI */
+static int ccp_acpi_support(struct ccp_device *ccp)
+{
+	return -EINVAL;
+}
+#endif
+
+#ifdef CONFIG_OF
+static int ccp_of_support(struct ccp_device *ccp)
+{
+	struct ccp_platform *ccp_platform = ccp->dev_specific;
+
+	ccp_platform->coherent = of_dma_is_coherent(ccp->dev->of_node);
+
+	return 0;
+}
+#else
+static int ccp_of_support(struct ccp_device *ccp)
+{
+	return -EINVAL;
+}
+#endif
+
 static int ccp_platform_probe(struct platform_device *pdev)
 {
 	struct ccp_device *ccp;
+	struct ccp_platform *ccp_platform;
 	struct device *dev = &pdev->dev;
+	struct acpi_device *adev = ACPI_COMPANION(dev);
 	struct resource *ior;
 	int ret;
 
@@ -95,10 +156,16 @@ static int ccp_platform_probe(struct platform_device *pdev)
 	if (!ccp)
 		goto e_err;
 
-	ccp->dev_specific = NULL;
+	ccp_platform = devm_kzalloc(dev, sizeof(*ccp_platform), GFP_KERNEL);
+	if (!ccp_platform)
+		goto e_err;
+
+	ccp->dev_specific = ccp_platform;
 	ccp->get_irq = ccp_get_irqs;
 	ccp->free_irq = ccp_free_irqs;
 
+	ccp_platform->use_acpi = (!adev || acpi_disabled) ? 0 : 1;
+
 	ior = ccp_find_mmio_area(ccp);
 	ccp->io_map = devm_ioremap_resource(dev, ior);
 	if (IS_ERR(ccp->io_map)) {
@@ -115,7 +182,14 @@ static int ccp_platform_probe(struct platform_device *pdev)
 		goto e_err;
 	}
 
-	if (of_property_read_bool(dev->of_node, "dma-coherent"))
+	if (ccp_platform->use_acpi)
+		ret = ccp_acpi_support(ccp);
+	else
+		ret = ccp_of_support(ccp);
+	if (ret)
+		goto e_err;
+
+	if (ccp_platform->coherent)
 		ccp->axcache = CACHE_WB_NO_ALLOC;
 	else
 		ccp->axcache = CACHE_NONE;
@@ -197,15 +271,29 @@ static int ccp_platform_resume(struct platform_device *pdev)
 }
 #endif
 
-static const struct of_device_id ccp_platform_ids[] = {
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id ccp_acpi_match[] = {
+	{ "AMDI0C00", 0 },
+	{ },
+};
+#endif
+
+#ifdef CONFIG_OF
+static const struct of_device_id ccp_of_match[] = {
 	{ .compatible = "amd,ccp-seattle-v1a" },
 	{ },
 };
+#endif
 
 static struct platform_driver ccp_platform_driver = {
 	.driver = {
 		.name = "AMD Cryptographic Coprocessor",
-		.of_match_table = ccp_platform_ids,
+#ifdef CONFIG_ACPI
+		.acpi_match_table = ccp_acpi_match,
+#endif
+#ifdef CONFIG_OF
+		.of_match_table = ccp_of_match,
+#endif
 	},
 	.probe = ccp_platform_probe,
 	.remove = ccp_platform_remove,
