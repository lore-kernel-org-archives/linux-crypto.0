From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 2/5] crypto: ccp - Update CCP build support
Date: Tue, 3 Feb 2015 13:07:11 -0600
Message-ID: <20150203190711.15045.94912.stgit@tlendack-t1.amdoffice.net>
References: <20150203190659.15045.21329.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0109.outbound.protection.outlook.com ([207.46.100.109]:21040
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965959AbbBCTVr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Feb 2015 14:21:47 -0500
In-Reply-To: <20150203190659.15045.21329.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add HAS_IOMEM as a Kconfig dependency. Always include ccp-platform.c
in the CCP build and conditionally include ccp-pci.c.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/Kconfig      |    2 +-
 drivers/crypto/ccp/Makefile |    9 ++-------
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 2fb0fdf..b840b79 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -391,7 +391,7 @@ config CRYPTO_DEV_ATMEL_SHA
 
 config CRYPTO_DEV_CCP
 	bool "Support for AMD Cryptographic Coprocessor"
-	depends on (X86 && PCI) || ARM64
+	depends on ((X86 && PCI) || ARM64) && HAS_IOMEM
 	default n
 	help
 	  The AMD Cryptographic Coprocessor provides hardware support
diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
index 7f592d8..55a1f39 100644
--- a/drivers/crypto/ccp/Makefile
+++ b/drivers/crypto/ccp/Makefile
@@ -1,11 +1,6 @@
 obj-$(CONFIG_CRYPTO_DEV_CCP_DD) += ccp.o
-ccp-objs := ccp-dev.o ccp-ops.o
-ifdef CONFIG_X86
-ccp-objs += ccp-pci.o
-endif
-ifdef CONFIG_ARM64
-ccp-objs += ccp-platform.o
-endif
+ccp-objs := ccp-dev.o ccp-ops.o ccp-platform.o
+ccp-$(CONFIG_PCI) += ccp-pci.o
 
 obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
 ccp-crypto-objs := ccp-crypto-main.o \
