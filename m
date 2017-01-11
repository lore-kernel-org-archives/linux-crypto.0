From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] crypto: mediatek - remove ARM dependencies
Date: Wed, 11 Jan 2017 14:50:19 +0100
Message-ID: <20170111135104.3961730-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Building the mediatek driver on an older ARM architecture results in a
harmless warning:

warning: (ARCH_OMAP2PLUS_TYPICAL && CRYPTO_DEV_MEDIATEK) selects NEON which has unmet direct dependencies (VFPv3 && CPU_V7)

We could add an explicit dependency on CPU_V7, but it seems nicer to
open up the build to additional configurations. This replaces the ARM
optimized algorithm selection with the normal one that all other drivers
use, and that in turn lets us relax the dependency on ARM and drop
a number of the unrelated 'select' statements.

Obviously a real user would still select those other optimized drivers
as a fallback, but as there is no strict dependency, we can leave that
up to the user.

Fixes: 785e5c616c84 ("crypto: mediatek - Add crypto driver support for some MediaTek chips")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/Kconfig | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8ded3af88b16..9d37ae07b4ce 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -555,15 +555,12 @@ config CRYPTO_DEV_ROCKCHIP
 
 config CRYPTO_DEV_MEDIATEK
 	tristate "MediaTek's EIP97 Cryptographic Engine driver"
-	depends on ARM && (ARCH_MEDIATEK || COMPILE_TEST)
-	select NEON
-	select KERNEL_MODE_NEON
-	select ARM_CRYPTO
+	depends on (ARM && ARCH_MEDIATEK) || COMPILE_TEST
 	select CRYPTO_AES
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_SHA1_ARM_NEON
-	select CRYPTO_SHA256_ARM
-	select CRYPTO_SHA512_ARM
+	select CRYPTO_SHA1
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
 	select CRYPTO_HMAC
 	help
 	  This driver allows you to utilize the hardware crypto accelerator
-- 
2.9.0
