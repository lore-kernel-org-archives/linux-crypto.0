From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: caam/qi2 - avoid double export
Date: Tue,  2 Oct 2018 22:56:19 +0200
Message-ID: <20181002205720.2255567-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Both the caam ctrl file and dpaa2_caam export a couple of flags. They
use an #ifdef check to make sure that each flag is only built once,
but this fails if they are both loadable modules:

WARNING: drivers/crypto/caam/dpaa2_caam: 'caam_little_end' exported twice. Previous export was in drivers/crypto/caam/caam.ko
WARNING: drivers/crypto/caam/dpaa2_caam: 'caam_imx' exported twice. Previous export was in drivers/crypto/caam/caam.ko

Change the #ifdef to an IS_ENABLED() check in order to make it work in
all configurations. It may be better to redesign this aspect of the
two drivers in a cleaner way.

Fixes: 8d818c105501 ("crypto: caam/qi2 - add DPAA2-CAAM driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/caam/caamalg_qi2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamalg_qi2.c b/drivers/crypto/caam/caamalg_qi2.c
index 2f569d0231f9..7d8ac0222fa3 100644
--- a/drivers/crypto/caam/caamalg_qi2.c
+++ b/drivers/crypto/caam/caamalg_qi2.c
@@ -25,7 +25,7 @@
 #define CAAM_MAX_KEY_SIZE	(AES_MAX_KEY_SIZE + CTR_RFC3686_NONCE_SIZE + \
 				 SHA512_DIGEST_SIZE * 2)
 
-#ifndef CONFIG_CRYPTO_DEV_FSL_CAAM
+#if !IS_ENABLED(CONFIG_CRYPTO_DEV_FSL_CAAM)
 bool caam_little_end;
 EXPORT_SYMBOL(caam_little_end);
 bool caam_imx;
-- 
2.18.0
