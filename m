From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH 09/10] crytpo: CCP device driver build files
Date: Tue, 12 Nov 2013 11:46:51 -0600
Message-ID: <20131112174651.19746.28701.stgit@tlendack-t1.amdoffice.net>
References: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>
To: <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131112174558.19746.47262.stgit@tlendack-t1.amdoffice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

These files provide the ability to configure and build the
AMD CCP device driver and crypto API support.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 drivers/crypto/Kconfig      |   12 ++++++++++++
 drivers/crypto/Makefile     |    1 +
 drivers/crypto/ccp/Kconfig  |   23 +++++++++++++++++++++++
 drivers/crypto/ccp/Makefile |   10 ++++++++++
 4 files changed, 46 insertions(+)
 create mode 100644 drivers/crypto/ccp/Kconfig
 create mode 100644 drivers/crypto/ccp/Makefile

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f4fd837..4954d75 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -399,4 +399,16 @@ config CRYPTO_DEV_ATMEL_SHA
 	  To compile this driver as a module, choose M here: the module
 	  will be called atmel-sha.
 
+config CRYPTO_DEV_CCP
+	bool "Support for AMD Cryptographic Coprocessor"
+	depends on X86
+	default n
+	help
+	  The AMD Cryptographic Coprocessor provides hardware support
+	  for encryption, hashing and related operations.
+
+if CRYPTO_DEV_CCP
+	source "drivers/crypto/ccp/Kconfig"
+endif
+
 endif # CRYPTO_HW
diff --git a/drivers/crypto/Makefile b/drivers/crypto/Makefile
index b4946dd..8a6c86a 100644
--- a/drivers/crypto/Makefile
+++ b/drivers/crypto/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_CRYPTO_DEV_NX) += nx/
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_AES) += atmel-aes.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_TDES) += atmel-tdes.o
 obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA) += atmel-sha.o
+obj-$(CONFIG_CRYPTO_DEV_CCP) += ccp/
diff --git a/drivers/crypto/ccp/Kconfig b/drivers/crypto/ccp/Kconfig
new file mode 100644
index 0000000..335ed5c
--- /dev/null
+++ b/drivers/crypto/ccp/Kconfig
@@ -0,0 +1,23 @@
+config CRYPTO_DEV_CCP_DD
+	tristate "Cryptographic Coprocessor device driver"
+	depends on CRYPTO_DEV_CCP
+	default m
+	help
+	  Provides the interface to use the AMD Cryptographic Coprocessor
+	  which can be used to accelerate or offload encryption operations
+	  such as SHA, AES and more. If you choose 'M' here, this module
+	  will be called ccp.
+
+config CRYPTO_DEV_CCP_CRYPTO
+	tristate "Encryption and hashing acceleration support"
+	depends on CRYPTO_DEV_CCP_DD
+	default m
+	select CRYPTO_ALGAPI
+	select CRYPTO_HASH
+	select CRYPTO_BLKCIPHER
+	select CRYPTO_AUTHENC
+	help
+	  Support for using the cryptographic API with the AMD Cryptographic
+	  Coprocessor. This module supports acceleration and offload of SHA
+	  and AES algorithms.  If you choose 'M' here, this module will be
+	  called ccp_crypto.
diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
new file mode 100644
index 0000000..d3505a0
--- /dev/null
+++ b/drivers/crypto/ccp/Makefile
@@ -0,0 +1,10 @@
+obj-$(CONFIG_CRYPTO_DEV_CCP_DD) += ccp.o
+ccp-objs := ccp-dev.o ccp-ops.o
+ccp-objs += ccp-pci.o
+
+obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
+ccp-crypto-objs := ccp-crypto-main.o \
+		   ccp-crypto-aes.o \
+		   ccp-crypto-aes-cmac.o \
+		   ccp-crypto-aes-xts.o \
+		   ccp-crypto-sha.o
