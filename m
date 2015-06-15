From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: vmx - Remove duplicate PPC64 dependency
Date: Mon, 15 Jun 2015 16:55:07 +0800
Message-ID: <20150615085507.GA31503@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	"Marcelo H. Cerri" <mhcerri@linux.vnet.ibm.com>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40673 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbbFOIzM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Jun 2015 04:55:12 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The top-level CRYPTO_DEV_VMX option already depends on PPC64 so
there is no need to depend on it again at CRYPTO_DEV_VMX_ENCRYPT.

This patch also removes a redundant "default n".

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/Kconfig     |    1 -
 drivers/crypto/vmx/Kconfig |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 6b0579f..92c899f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -459,7 +459,6 @@ config CRYPTO_DEV_QCE
 config CRYPTO_DEV_VMX
 	bool "Support for VMX cryptographic acceleration instructions"
 	depends on PPC64
-	default n
 	help
 	  Support for VMX cryptographic acceleration instructions.
 
diff --git a/drivers/crypto/vmx/Kconfig b/drivers/crypto/vmx/Kconfig
index 771babf..89d8208 100644
--- a/drivers/crypto/vmx/Kconfig
+++ b/drivers/crypto/vmx/Kconfig
@@ -1,6 +1,6 @@
 config CRYPTO_DEV_VMX_ENCRYPT
 	tristate "Encryption acceleration support on P8 CPU"
-	depends on PPC64 && CRYPTO_DEV_VMX
+	depends on CRYPTO_DEV_VMX
 	default y
 	help
 	  Support for VMX cryptographic acceleration instructions on Power8 CPU.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
