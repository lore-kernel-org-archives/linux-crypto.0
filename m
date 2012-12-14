From: Alessio Igor Bogani <alessio.bogani@elettra.trieste.it>
Subject: crypto: omap-aes - fix a build error
Date: Fri, 14 Dec 2012 11:32:35 +0100
Message-ID: <1355481155-28621-1-git-send-email-alessio.bogani@elettra.trieste.it>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-omap@vger.kernel.org,
	Alessio Igor Bogani <alessio.bogani@elettra.trieste.it>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Tony Lindgren <tony@atomide.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[...]
  CC      init/version.o
  LD      init/built-in.o
drivers/built-in.o:(.data+0xbc6c): undefined reference to `crypto_ablkcipher_type'
drivers/built-in.o:(.data+0xbd4c): undefined reference to `crypto_ablkcipher_type'

The omap-aes driver uses crypto_ablkcipher_type symbol without selecting it.

Signed-off-by: Alessio Igor Bogani <alessio.bogani@elettra.trieste.it>
---
 drivers/crypto/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index f6644f5..b04d78f 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -254,6 +254,7 @@ config CRYPTO_DEV_OMAP_AES
 	tristate "Support for OMAP AES hw engine"
 	depends on ARCH_OMAP2 || ARCH_OMAP3
 	select CRYPTO_AES
+	select CRYPTO_BLKCIPHER
 	help
 	  OMAP processors have AES module accelerator. Select this if you
 	  want to use the OMAP module for AES algorithms.
-- 
1.7.9.5
