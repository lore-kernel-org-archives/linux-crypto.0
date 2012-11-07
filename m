From: Nicolas Royer <nicolas@eukrea.com>
Subject: [PATCH 2/5 v3] ARM: AT91SAM9G45: same platform data structure for all crypto peripherals
Date: Wed,  7 Nov 2012 18:34:27 +0100
Message-ID: <1352309667-30868-1-git-send-email-nicolas@eukrea.com>
References: <20121107164523.GG4576@game.jcrosoft.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, plagnioj@jcrosoft.com, eric@eukrea.com,
	Nicolas Royer <nicolas@eukrea.com>
To: linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:53506 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab2KGReJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 7 Nov 2012 12:34:09 -0500
In-Reply-To: <20121107164523.GG4576@game.jcrosoft.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Only AES use DMA in AT91SAM9G45 (TDES and SHA use PDC).

However latest Atmel TDES and SHA IP releases use DMA instead of PDC.
  --> Atmel TDES and SHA drivers need DMA platform data for those IP re=
leases.

Goal of this patch is to use the same platform data structure for all A=
tmel
crypto peripherals. This structure contains information about DMA inter=
face.

Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Eric B=C3=A9nard <eric@eukrea.com>
Tested-by: Eric B=C3=A9nard <eric@eukrea.com>
---
v2 : check kzalloc return value.

v3 : alt_atslave structure declared as static.

 arch/arm/mach-at91/at91sam9g45_devices.c   |   14 ++++++--------
 include/linux/platform_data/atmel-aes.h    |   22 --------------------=
--
 include/linux/platform_data/crypto-atmel.h |   22 ++++++++++++++++++++=
++
 3 files changed, 28 insertions(+), 30 deletions(-)
 delete mode 100644 include/linux/platform_data/atmel-aes.h
 create mode 100644 include/linux/platform_data/crypto-atmel.h

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-a=
t91/at91sam9g45_devices.c
index fcd233c..1501e58 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -18,7 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c-gpio.h>
 #include <linux/atmel-mci.h>
-#include <linux/platform_data/atmel-aes.h>
+#include <linux/platform_data/crypto-atmel.h>
=20
 #include <linux/platform_data/at91_adc.h>
=20
@@ -1900,7 +1900,8 @@ static void __init at91_add_device_tdes(void) {}
  * -------------------------------------------------------------------=
- */
=20
 #if defined(CONFIG_CRYPTO_DEV_ATMEL_AES) || defined(CONFIG_CRYPTO_DEV_=
ATMEL_AES_MODULE)
-static struct aes_platform_data aes_data;
+static struct crypto_platform_data aes_data;
+static struct crypto_dma_data alt_atslave;
 static u64 aes_dmamask =3D DMA_BIT_MASK(32);
=20
 static struct resource aes_resources[] =3D {
@@ -1931,23 +1932,20 @@ static struct platform_device at91sam9g45_aes_d=
evice =3D {
 static void __init at91_add_device_aes(void)
 {
 	struct at_dma_slave	*atslave;
-	struct aes_dma_data	*alt_atslave;
-
-	alt_atslave =3D kzalloc(sizeof(struct aes_dma_data), GFP_KERNEL);
=20
 	/* DMA TX slave channel configuration */
-	atslave =3D &alt_atslave->txdata;
+	atslave =3D &alt_atslave.txdata;
 	atslave->dma_dev =3D &at_hdmac_device.dev;
 	atslave->cfg =3D ATC_FIFOCFG_ENOUGHSPACE	| ATC_SRC_H2SEL_HW |
 						ATC_SRC_PER(AT_DMA_ID_AES_RX);
=20
 	/* DMA RX slave channel configuration */
-	atslave =3D &alt_atslave->rxdata;
+	atslave =3D &alt_atslave.rxdata;
 	atslave->dma_dev =3D &at_hdmac_device.dev;
 	atslave->cfg =3D ATC_FIFOCFG_ENOUGHSPACE	| ATC_DST_H2SEL_HW |
 						ATC_DST_PER(AT_DMA_ID_AES_TX);
=20
-	aes_data.dma_slave =3D alt_atslave;
+	aes_data.dma_slave =3D &alt_atslave;
 	platform_device_register(&at91sam9g45_aes_device);
 }
 #else
diff --git a/include/linux/platform_data/atmel-aes.h b/include/linux/pl=
atform_data/atmel-aes.h
deleted file mode 100644
index ab68082..0000000
--- a/include/linux/platform_data/atmel-aes.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#ifndef __LINUX_ATMEL_AES_H
-#define __LINUX_ATMEL_AES_H
-
-#include <linux/platform_data/dma-atmel.h>
-
-/**
- * struct aes_dma_data - DMA data for AES
- */
-struct aes_dma_data {
-	struct at_dma_slave	txdata;
-	struct at_dma_slave	rxdata;
-};
-
-/**
- * struct aes_platform_data - board-specific AES configuration
- * @dma_slave: DMA slave interface to use in data transfers.
- */
-struct aes_platform_data {
-	struct aes_dma_data	*dma_slave;
-};
-
-#endif /* __LINUX_ATMEL_AES_H */
diff --git a/include/linux/platform_data/crypto-atmel.h b/include/linux=
/platform_data/crypto-atmel.h
new file mode 100644
index 0000000..b46e0d9
--- /dev/null
+++ b/include/linux/platform_data/crypto-atmel.h
@@ -0,0 +1,22 @@
+#ifndef __LINUX_CRYPTO_ATMEL_H
+#define __LINUX_CRYPTO_ATMEL_H
+
+#include <linux/platform_data/dma-atmel.h>
+
+/**
+ * struct crypto_dma_data - DMA data for AES/TDES/SHA
+ */
+struct crypto_dma_data {
+	struct at_dma_slave	txdata;
+	struct at_dma_slave	rxdata;
+};
+
+/**
+ * struct crypto_platform_data - board-specific AES/TDES/SHA configura=
tion
+ * @dma_slave: DMA slave interface to use in data transfers.
+ */
+struct crypto_platform_data {
+	struct crypto_dma_data	*dma_slave;
+};
+
+#endif /* __LINUX_CRYPTO_ATMEL_H */
--=20
1.7.6.5
