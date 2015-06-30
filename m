From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH] crypto: ccp - Provide support to autoload CCP driver
Date: Tue, 30 Jun 2015 12:57:14 -0500
Message-ID: <20150630175714.17231.11110.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add the necessary module device tables to the platform support to allow
for autoloading of the CCP driver. This will allow for the CCP's hwrng
support to be available without having to manually load the driver. The
module device table entry for the pci support is already present.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/ccp/ccp-platform.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-platform.c b/drivers/crypto/ccp/ccp-platform.c
index f2e6de3..bb241c3 100644
--- a/drivers/crypto/ccp/ccp-platform.c
+++ b/drivers/crypto/ccp/ccp-platform.c
@@ -216,6 +216,7 @@ static const struct acpi_device_id ccp_acpi_match[] = {
 	{ "AMDI0C00", 0 },
 	{ },
 };
+MODULE_DEVICE_TABLE(acpi, ccp_acpi_match);
 #endif
 
 #ifdef CONFIG_OF
@@ -223,6 +224,7 @@ static const struct of_device_id ccp_of_match[] = {
 	{ .compatible = "amd,ccp-seattle-v1a" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ccp_of_match);
 #endif
 
 static struct platform_driver ccp_platform_driver = {
