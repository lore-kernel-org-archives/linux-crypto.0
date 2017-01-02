From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: [PATCH 1/3] crypto: picoxcell - Allow driver to build COMPILE_TEST is enabled
Date: Mon,  2 Jan 2017 14:06:57 -0300
Message-ID: <1483376819-26726-2-git-send-email-javier@osg.samsung.com>
References: <1483376819-26726-1-git-send-email-javier@osg.samsung.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483376819-26726-1-git-send-email-javier@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Driver only has runtime but no build time dependency with ARCH_PICOXCELL.
So it can be built for testing purposes if COMPILE_TEST option is enabled.

This is useful to have more build coverage and make sure that the driver
is not affected by changes that could cause build regressions.

Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
---

 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 79564785ae30..35b1c4829696 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -339,7 +339,7 @@ config CRYPTO_DEV_OMAP_DES
 
 config CRYPTO_DEV_PICOXCELL
 	tristate "Support for picoXcell IPSEC and Layer2 crypto engines"
-	depends on ARCH_PICOXCELL && HAVE_CLK
+	depends on (ARCH_PICOXCELL || COMPILE_TEST) && HAVE_CLK
 	select CRYPTO_AEAD
 	select CRYPTO_AES
 	select CRYPTO_AUTHENC
-- 
2.7.4
