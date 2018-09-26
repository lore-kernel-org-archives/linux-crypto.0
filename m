From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] crypto: caam/qi2 - add CONFIG_NETDEVICES dependency
Date: Wed, 26 Sep 2018 15:00:34 +0200
Message-ID: <20180926130045.2295764-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This driver implements a (part of a) network driver, and fails to
build if we have turned off networking support:

drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_caam_fqdan_cb':
caamalg_qi2.c:(.text+0x577c): undefined reference to `napi_schedule_prep'
caamalg_qi2.c:(.text+0x578c): undefined reference to `__napi_schedule_irqoff'
drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_dpseci_poll':
caamalg_qi2.c:(.text+0x59b8): undefined reference to `napi_complete_done'
drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_caam_remove':
caamalg_qi2.c:(.text.unlikely+0x4e0): undefined reference to `napi_disable'
caamalg_qi2.c:(.text.unlikely+0x4e8): undefined reference to `netif_napi_del'
drivers/crypto/caam/caamalg_qi2.o: In function `dpaa2_dpseci_setup':
caamalg_qi2.c:(.text.unlikely+0xc98): undefined reference to `netif_napi_add'

>From what I can tell, CONFIG_NETDEVICES is the correct dependency here,
and adding it fixes the randconfig failures.

Fixes: 8d818c105501 ("crypto: caam/qi2 - add DPAA2-CAAM driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/crypto/caam/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/Kconfig b/drivers/crypto/caam/Kconfig
index ec42fb652167..619a2c929f3e 100644
--- a/drivers/crypto/caam/Kconfig
+++ b/drivers/crypto/caam/Kconfig
@@ -156,6 +156,7 @@ endif # CRYPTO_DEV_FSL_CAAM
 config CRYPTO_DEV_FSL_DPAA2_CAAM
 	tristate "QorIQ DPAA2 CAAM (DPSECI) driver"
 	depends on FSL_MC_DPIO
+	depends on NETDEVICES
 	select CRYPTO_DEV_FSL_CAAM_COMMON
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AUTHENC
-- 
2.18.0
