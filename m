From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
Subject: [PATCH 1/5] ARM: AT91SAM9G45: add crypto peripherals
Date: Sun,  1 Jul 2012 19:19:43 +0200
Message-ID: <1341163187-14946-2-git-send-email-eric@eukrea.com>
References: <1341163187-14946-1-git-send-email-eric@eukrea.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au,
	davem@davemloft.net, plagnioj@jcrosoft.com, nicolas@eukrea.com,
	eric@eukrea.com
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1341163187-14946-1-git-send-email-eric@eukrea.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=46rom: Nicolas Royer <nicolas@eukrea.com>

Signed-off-by: Nicolas Royer <nicolas@eukrea.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Eric B=C3=A9nard <eric@eukrea.com>
Tested-by: Eric B=C3=A9nard <eric@eukrea.com>
---
 arch/arm/mach-at91/at91sam9g45.c              |   13 +++-
 arch/arm/mach-at91/at91sam9g45_devices.c      |  128 +++++++++++++++++=
++++++++
 arch/arm/mach-at91/include/mach/at91sam9g45.h |    2 +
 include/linux/platform_data/atmel-aes.h       |   22 ++++
 4 files changed, 164 insertions(+), 1 deletions(-)
 create mode 100644 include/linux/platform_data/atmel-aes.h

diff --git a/arch/arm/mach-at91/at91sam9g45.c b/arch/arm/mach-at91/at91=
sam9g45.c
index 4792682..da6dc0f 100644
--- a/arch/arm/mach-at91/at91sam9g45.c
+++ b/arch/arm/mach-at91/at91sam9g45.c
@@ -182,6 +182,13 @@ static struct clk adc_op_clk =3D {
 	.rate_hz	=3D 13200000,
 };
=20
+/* AES/TDES/SHA clock - Only for sam9m11/sam9g56 */
+static struct clk aestdessha_clk =3D {
+	.name		=3D "aestdessha_clk",
+	.pmc_mask	=3D 1 << AT91SAM9G45_ID_AESTDESSHA,
+	.type		=3D CLK_TYPE_PERIPHERAL,
+};
+
 static struct clk *periph_clocks[] __initdata =3D {
 	&pioA_clk,
 	&pioB_clk,
@@ -211,6 +218,7 @@ static struct clk *periph_clocks[] __initdata =3D {
 	&udphs_clk,
 	&mmc1_clk,
 	&adc_op_clk,
+	&aestdessha_clk,
 	// irq0
 };
=20
@@ -231,6 +239,9 @@ static struct clk_lookup periph_clocks_lookups[] =3D=
 {
 	CLKDEV_CON_DEV_ID("pclk", "ssc.0", &ssc0_clk),
 	CLKDEV_CON_DEV_ID("pclk", "ssc.1", &ssc1_clk),
 	CLKDEV_CON_DEV_ID(NULL, "atmel-trng", &trng_clk),
+	CLKDEV_CON_DEV_ID(NULL, "atmel_sha", &aestdessha_clk),
+	CLKDEV_CON_DEV_ID(NULL, "atmel_tdes", &aestdessha_clk),
+	CLKDEV_CON_DEV_ID(NULL, "atmel_aes", &aestdessha_clk),
 	/* more usart lookup table for DT entries */
 	CLKDEV_CON_DEV_ID("usart", "ffffee00.serial", &mck),
 	CLKDEV_CON_DEV_ID("usart", "fff8c000.serial", &usart0_clk),
@@ -387,7 +398,7 @@ static unsigned int at91sam9g45_default_irq_priorit=
y[NR_AIC_IRQS] __initdata =3D {
 	3,	/* Ethernet */
 	0,	/* Image Sensor Interface */
 	2,	/* USB Device High speed port */
-	0,
+	0,	/* AESTDESSHA Crypto HW Accelerators */
 	0,	/* Multimedia Card Interface 1 */
 	0,
 	0,	/* Advanced Interrupt Controller (IRQ0) */
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-a=
t91/at91sam9g45_devices.c
index 933fc9a..7102f62 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -18,6 +18,7 @@
 #include <linux/platform_device.h>
 #include <linux/i2c-gpio.h>
 #include <linux/atmel-mci.h>
+#include <linux/platform_data/atmel-aes.h>
=20
 #include <linux/platform_data/at91_adc.h>
=20
@@ -1830,6 +1831,130 @@ void __init at91_register_uart(unsigned id, uns=
igned portnr, unsigned pins) {}
 void __init at91_add_device_serial(void) {}
 #endif
=20
+/* -------------------------------------------------------------------=
-
+ *  SHA1/SHA256
+ * -------------------------------------------------------------------=
- */
+
+#if defined(CONFIG_CRYPTO_DEV_ATMEL_SHA) || defined(CONFIG_CRYPTO_DEV_=
ATMEL_SHA_MODULE)
+static struct resource sha_resources[] =3D {
+	{
+		.start	=3D AT91SAM9G45_BASE_SHA,
+		.end	=3D AT91SAM9G45_BASE_SHA + SZ_16K - 1,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	[1] =3D {
+		.start	=3D AT91SAM9G45_ID_AESTDESSHA,
+		.end	=3D AT91SAM9G45_ID_AESTDESSHA,
+		.flags	=3D IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91sam9g45_sha_device =3D {
+	.name	=3D "atmel_sha",
+	.id		=3D -1,
+	.resource	=3D sha_resources,
+	.num_resources	=3D ARRAY_SIZE(sha_resources),
+};
+
+static void __init at91_add_device_sha(void)
+{
+	platform_device_register(&at91sam9g45_sha_device);
+}
+#else
+static void __init at91_add_device_sha(void) {}
+#endif
+
+/* -------------------------------------------------------------------=
-
+ *  DES/TDES
+ * -------------------------------------------------------------------=
- */
+
+#if defined(CONFIG_CRYPTO_DEV_ATMEL_TDES) || defined(CONFIG_CRYPTO_DEV=
_ATMEL_TDES_MODULE)
+static struct resource tdes_resources[] =3D {
+	[0] =3D {
+		.start	=3D AT91SAM9G45_BASE_TDES,
+		.end	=3D AT91SAM9G45_BASE_TDES + SZ_16K - 1,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	[1] =3D {
+		.start	=3D AT91SAM9G45_ID_AESTDESSHA,
+		.end	=3D AT91SAM9G45_ID_AESTDESSHA,
+		.flags	=3D IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91sam9g45_tdes_device =3D {
+	.name	=3D "atmel_tdes",
+	.id		=3D -1,
+	.resource	=3D tdes_resources,
+	.num_resources	=3D ARRAY_SIZE(tdes_resources),
+};
+
+static void __init at91_add_device_tdes(void)
+{
+	platform_device_register(&at91sam9g45_tdes_device);
+}
+#else
+static void __init at91_add_device_tdes(void) {}
+#endif
+
+/* -------------------------------------------------------------------=
-
+ *  AES
+ * -------------------------------------------------------------------=
- */
+
+#if defined(CONFIG_CRYPTO_DEV_ATMEL_AES) || defined(CONFIG_CRYPTO_DEV_=
ATMEL_AES_MODULE)
+static struct aes_platform_data aes_data;
+static u64 aes_dmamask =3D DMA_BIT_MASK(32);
+
+static struct resource aes_resources[] =3D {
+	[0] =3D {
+		.start	=3D AT91SAM9G45_BASE_AES,
+		.end	=3D AT91SAM9G45_BASE_AES + SZ_16K - 1,
+		.flags	=3D IORESOURCE_MEM,
+	},
+	[1] =3D {
+		.start	=3D AT91SAM9G45_ID_AESTDESSHA,
+		.end	=3D AT91SAM9G45_ID_AESTDESSHA,
+		.flags	=3D IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device at91sam9g45_aes_device =3D {
+	.name	=3D "atmel_aes",
+	.id		=3D -1,
+	.dev	=3D {
+		.dma_mask		=3D &aes_dmamask,
+		.coherent_dma_mask	=3D DMA_BIT_MASK(32),
+		.platform_data		=3D &aes_data,
+	},
+	.resource	=3D aes_resources,
+	.num_resources	=3D ARRAY_SIZE(aes_resources),
+};
+
+static void __init at91_add_device_aes(void)
+{
+	struct at_dma_slave	*atslave;
+	struct aes_dma_data	*alt_atslave;
+
+	alt_atslave =3D kzalloc(sizeof(struct aes_dma_data), GFP_KERNEL);
+
+	/* DMA TX slave channel configuration */
+	atslave =3D &alt_atslave->txdata;
+	atslave->dma_dev =3D &at_hdmac_device.dev;
+	atslave->cfg =3D ATC_FIFOCFG_ENOUGHSPACE	| ATC_SRC_H2SEL_HW |
+						ATC_SRC_PER(AT_DMA_ID_AES_RX);
+
+	/* DMA RX slave channel configuration */
+	atslave =3D &alt_atslave->rxdata;
+	atslave->dma_dev =3D &at_hdmac_device.dev;
+	atslave->cfg =3D ATC_FIFOCFG_ENOUGHSPACE	| ATC_DST_H2SEL_HW |
+						ATC_DST_PER(AT_DMA_ID_AES_TX);
+
+	aes_data.dma_slave =3D alt_atslave;
+	platform_device_register(&at91sam9g45_aes_device);
+}
+#else
+static void __init at91_add_device_aes(void) {}
+#endif
=20
 /* -------------------------------------------------------------------=
- */
 /*
@@ -1847,6 +1972,9 @@ static int __init at91_add_standard_devices(void)
 	at91_add_device_trng();
 	at91_add_device_watchdog();
 	at91_add_device_tc();
+	at91_add_device_sha();
+	at91_add_device_tdes();
+	at91_add_device_aes();
 	return 0;
 }
=20
diff --git a/arch/arm/mach-at91/include/mach/at91sam9g45.h b/arch/arm/m=
ach-at91/include/mach/at91sam9g45.h
index 3a4da24..8eba102 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9g45.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9g45.h
@@ -136,6 +136,8 @@
 #define AT_DMA_ID_SSC1_RX	 8
 #define AT_DMA_ID_AC97_TX	 9
 #define AT_DMA_ID_AC97_RX	10
+#define AT_DMA_ID_AES_TX	11
+#define AT_DMA_ID_AES_RX	12
 #define AT_DMA_ID_MCI1		13
=20
 #endif
diff --git a/include/linux/platform_data/atmel-aes.h b/include/linux/pl=
atform_data/atmel-aes.h
new file mode 100644
index 0000000..e7a1949
--- /dev/null
+++ b/include/linux/platform_data/atmel-aes.h
@@ -0,0 +1,22 @@
+#ifndef __LINUX_ATMEL_AES_H
+#define __LINUX_ATMEL_AES_H
+
+#include <mach/at_hdmac.h>
+
+/**
+ * struct aes_dma_data - DMA data for AES
+ */
+struct aes_dma_data {
+	struct at_dma_slave	txdata;
+	struct at_dma_slave	rxdata;
+};
+
+/**
+ * struct aes_platform_data - board-specific AES configuration
+ * @dma_slave: DMA slave interface to use in data transfers.
+ */
+struct aes_platform_data {
+	struct aes_dma_data	*dma_slave;
+};
+
+#endif /* __LINUX_ATMEL_AES_H */
--=20
1.7.7.6
