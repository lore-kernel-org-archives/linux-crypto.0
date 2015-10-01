From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 4/4] crypto: ccp - Use module name in driver structures
Date: Thu, 1 Oct 2015 16:32:50 -0500
Message-ID: <20151001213250.4286.93151.stgit@tlendack-t1.amdoffice.net>
References: <20151001213225.4286.44278.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0059.outbound.protection.outlook.com ([207.46.100.59]:6656
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750866AbbJAVc5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 17:32:57 -0400
In-Reply-To: <20151001213225.4286.44278.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The convention is to use the name of the module in the driver structures
that are used for registering the device. The CCP module is currently
using a descriptive name. Replace the descriptive name with module name.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-pci.c      |    2 +-
 drivers/crypto/ccp/ccp-platform.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/ccp-pci.c
index af190d4..6ade02f 100644
--- a/drivers/crypto/ccp/ccp-pci.c
+++ b/drivers/crypto/ccp/ccp-pci.c
@@ -319,7 +319,7 @@ static const struct pci_device_id ccp_pci_table[] = {
 MODULE_DEVICE_TABLE(pci, ccp_pci_table);
 
 static struct pci_driver ccp_pci_driver = {
-	.name = "AMD Cryptographic Coprocessor",
+	.name = "ccp",
 	.id_table = ccp_pci_table,
 	.probe = ccp_pci_probe,
 	.remove = ccp_pci_remove,
diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index 4bc73d4..8b923b7 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -225,7 +225,7 @@ MODULE_DEVICE_TABLE(of, ccp_of_match);
 
 static struct platform_driver ccp_platform_driver = {
 	.driver = {
-		.name = "AMD Cryptographic Coprocessor",
+		.name = "ccp",
 #ifdef CONFIG_ACPI
 		.acpi_match_table = ccp_acpi_match,
 #endif
