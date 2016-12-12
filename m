From: Andy Lutomirski <luto@kernel.org>
Subject: [PATCH] crypto: Make a few drivers depend on !VMAP_STACK
Date: Mon, 12 Dec 2016 12:55:20 -0800
Message-ID: <5e4b1fdd48e44acd5f3cfa25639b00f5c5906832.1481575835.git.luto@kernel.org>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
Cc: Eric Biggers <ebiggers3@gmail.com>, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Andy Lutomirski <luto@kernel.org>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Eric Biggers found several crypto drivers that point scatterlists at
the stack.  These drivers should never load on x86, but, for future
safety, make them depend on !VMAP_STACK.

No -stable backport should be needed as no released kernel
configuration should be affected.

Reported-by: Eric Biggers <ebiggers3@gmail.com>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 drivers/crypto/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 4d2b81f2b223..481e67e54ffd 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -245,7 +245,7 @@ config CRYPTO_DEV_TALITOS
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
 	select HW_RANDOM
-	depends on FSL_SOC
+	depends on FSL_SOC && !VMAP_STACK
 	help
 	  Say 'Y' here to use the Freescale Security Engine (SEC)
 	  to offload cryptographic algorithm computation.
@@ -357,7 +357,7 @@ config CRYPTO_DEV_PICOXCELL
 
 config CRYPTO_DEV_SAHARA
 	tristate "Support for SAHARA crypto accelerator"
-	depends on ARCH_MXC && OF
+	depends on ARCH_MXC && OF && !VMAP_STACK
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AES
 	select CRYPTO_ECB
@@ -410,7 +410,7 @@ endif # if CRYPTO_DEV_UX500
 
 config CRYPTO_DEV_BFIN_CRC
 	tristate "Support for Blackfin CRC hardware"
-	depends on BF60x
+	depends on BF60x && !VMAP_STACK
 	help
 	  Newer Blackfin processors have CRC hardware. Select this if you
 	  want to use the Blackfin CRC module.
@@ -487,7 +487,7 @@ source "drivers/crypto/qat/Kconfig"
 
 config CRYPTO_DEV_QCE
 	tristate "Qualcomm crypto engine accelerator"
-	depends on (ARCH_QCOM || COMPILE_TEST) && HAS_DMA && HAS_IOMEM
+	depends on (ARCH_QCOM || COMPILE_TEST) && HAS_DMA && HAS_IOMEM && !VMAP_STACK
 	select CRYPTO_AES
 	select CRYPTO_DES
 	select CRYPTO_ECB
-- 
2.9.3
