From: Paul Bolle <pebolle@tiscali.nl>
Subject: [PATCH] crypto: remove dependency on EXPERIMENTAL
Date: Sun, 12 May 2013 13:57:19 +0200
Message-ID: <1368359839.1350.10.camel@x61.thuisdomein>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The Kconfig symbol EXPERIMENTAL was removed in v3.9. So this dependency
makes it impossible to set CRYPTO_DEV_SAHARA. It's unlikely that this is
what is intended, so let's remove this dependency.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "make ARCH=arm menuconfig".

 drivers/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index dffb855..47c6f4d 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -278,7 +278,7 @@ config CRYPTO_DEV_PICOXCELL
 
 config CRYPTO_DEV_SAHARA
 	tristate "Support for SAHARA crypto accelerator"
-	depends on ARCH_MXC && EXPERIMENTAL && OF
+	depends on ARCH_MXC && OF
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AES
 	select CRYPTO_ECB
-- 
1.7.11.7
