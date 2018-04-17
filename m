From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH/RFC] crypto: Add platform dependencies for CRYPTO_DEV_CCREE
Date: Tue, 17 Apr 2018 20:14:25 +0200
Message-ID: <1523988865-26848-1-git-send-email-geert@linux-m68k.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The ARM TrustZone CryptoCell is found on ARM SoCs only.  Hence make it
depend on ARM or ARM64, unless compile-testing.

Drop the dependency on HAS_DMA, as DMA is always available on ARM and
ARM64 platforms, and doing so will increase compile coverage.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Is ARM || ARM64 OK?
Or should this be limited to either ARM or ARM64? Or something else?
---
 drivers/crypto/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 3dbc47528667b77c..104640b72354d93a 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -719,7 +719,8 @@ config CRYPTO_DEV_ARTPEC6
 
 config CRYPTO_DEV_CCREE
 	tristate "Support for ARM TrustZone CryptoCell family of security processors"
-	depends on CRYPTO && CRYPTO_HW && OF && HAS_DMA
+	depends on CRYPTO && CRYPTO_HW && OF
+	depends on ARM || ARM64 || COMPILE_TEST
 	default n
 	select CRYPTO_HASH
 	select CRYPTO_BLKCIPHER
-- 
2.7.4
