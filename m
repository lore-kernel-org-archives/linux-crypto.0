From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v1 3/4] crypto: ccp - Change references to accelerator to
 offload
Date: Thu, 1 Oct 2015 16:32:44 -0500
Message-ID: <20151001213244.4286.64872.stgit@tlendack-t1.amdoffice.net>
References: <20151001213225.4286.44278.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0066.outbound.protection.outlook.com ([207.46.100.66]:12752
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750866AbbJAVct (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 17:32:49 -0400
In-Reply-To: <20151001213225.4286.44278.stgit@tlendack-t1.amdoffice.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The CCP is meant to be more of an offload engine than an accelerator
engine. To avoid any confusion, change references to accelerator to
offload.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/Kconfig     |    2 +-
 drivers/crypto/ccp/Kconfig |   13 ++++++-------
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index e7f24a8..ab7e3b6 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -420,7 +420,7 @@ config CRYPTO_DEV_CCP
 	bool "Support for AMD Cryptographic Coprocessor"
 	depends on ((X86 && PCI) || (ARM64 && (OF_ADDRESS || ACPI))) && HAS_IOMEM
 	help
-	  The AMD Cryptographic Coprocessor provides hardware support
+	  The AMD Cryptographic Coprocessor provides hardware offload support
 	  for encryption, hashing and related operations.
 
 if CRYPTO_DEV_CCP
diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
index ae38f6b..3cd8481 100644
--- a/drivers/crypto/ccp/Kconfig
+++ b/drivers/crypto/ccp/Kconfig
@@ -5,12 +5,12 @@ config CRYPTO_DEV_CCP_DD
 	select HW_RANDOM
 	help
 	  Provides the interface to use the AMD Cryptographic Coprocessor
-	  which can be used to accelerate or offload encryption operations
-	  such as SHA, AES and more. If you choose 'M' here, this module
-	  will be called ccp.
+	  which can be used to offload encryption operations such as SHA,
+	  AES and more. If you choose 'M' here, this module will be called
+	  ccp.
 
 config CRYPTO_DEV_CCP_CRYPTO
-	tristate "Encryption and hashing acceleration support"
+	tristate "Encryption and hashing offload support"
 	depends on CRYPTO_DEV_CCP_DD
 	default m
 	select CRYPTO_HASH
@@ -18,6 +18,5 @@ config CRYPTO_DEV_CCP_CRYPTO
 	select CRYPTO_AUTHENC
 	help
 	  Support for using the cryptographic API with the AMD Cryptographic
-	  Coprocessor. This module supports acceleration and offload of SHA
-	  and AES algorithms.  If you choose 'M' here, this module will be
-	  called ccp_crypto.
+	  Coprocessor. This module supports offload of SHA and AES algorithms.
+	  If you choose 'M' here, this module will be called ccp_crypto.
