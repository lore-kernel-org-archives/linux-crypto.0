From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 2/4] crypto: ccp - Remove use ACPI field
Date: Thu, 1 Oct 2015 16:32:38 -0500
Message-ID: <20151001213238.4286.87015.stgit@tlendack-t1.amdoffice.net>
References: <20151001213225.4286.44278.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0058.outbound.protection.outlook.com ([207.46.100.58]:65376
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750745AbbJAVcn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 17:32:43 -0400
In-Reply-To: <20151001213225.4286.44278.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

With the creation of the device_dma_is_coherent API the "use_acpi" field
is no longer needed, so remove it.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-platform.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index bb241c3..4bc73d4 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -29,7 +29,6 @@
 #include "ccp-dev.h"
 
 struct ccp_platform {
-	int use_acpi;
 	int coherent;
 };
 
@@ -95,7 +94,6 @@ static int ccp_platform_probe(struct platform_device *pdev)
 	struct ccp_device *ccp;
 	struct ccp_platform *ccp_platform;
 	struct device *dev = &pdev->dev;
-	struct acpi_device *adev = ACPI_COMPANION(dev);
 	struct resource *ior;
 	int ret;
 
@@ -112,8 +110,6 @@ static int ccp_platform_probe(struct platform_device *pdev)
 	ccp->get_irq = ccp_get_irqs;
 	ccp->free_irq = ccp_free_irqs;
 
-	ccp_platform->use_acpi = (!adev || acpi_disabled) ? 0 : 1;
-
 	ior = ccp_find_mmio_area(ccp);
 	ccp->io_map = devm_ioremap_resource(dev, ior);
 	if (IS_ERR(ccp->io_map)) {
