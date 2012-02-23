From: Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH 2/2] mach-ux500: Crypto: core support for CRYP/HASH module.
Date: Thu, 23 Feb 2012 13:58:57 +0100
Message-ID: <1330001937-2108-3-git-send-email-andreas.westin@stericsson.com>
References: <1330001937-2108-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	Andreas Westin <andreas.westin@stericsson.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:52443 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752231Ab2BWNEh (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Feb 2012 08:04:37 -0500
In-Reply-To: <1330001937-2108-1-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds the required platform data and calls to enable
the CRYP/HASH driver.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andreas Westin <andreas.westin@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500.c         |   48 ++++++++++++++++++++++++++++
 arch/arm/mach-ux500/board-u5500.c          |   48 ++++++++++++++++++++++++++++
 arch/arm/mach-ux500/clock.c                |   18 ++++++-----
 arch/arm/mach-ux500/devices-common.c       |   16 +++++++++
 arch/arm/mach-ux500/devices-common.h       |   23 +++++++++++++
 arch/arm/mach-ux500/devices-db5500.h       |    4 ++
 arch/arm/mach-ux500/devices-db8500.h       |    4 ++
 arch/arm/mach-ux500/include/mach/devices.h |    3 ++
 arch/arm/mach-ux500/ste-dma40-db5500.h     |    9 +++--
 9 files changed, 162 insertions(+), 11 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 5c00712..4e9bcd6 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -44,6 +44,7 @@
 #include <mach/setup.h>
 #include <mach/devices.h>
 #include <mach/irqs.h>
+#include <mach/crypto-ux500.h>
 
 #include "pins-db8500.h"
 #include "ste-dma40-db8500.h"
@@ -409,6 +410,45 @@ static void mop500_prox_deactivate(struct device *dev)
 	regulator_put(prox_regulator);
 }
 
+static struct cryp_platform_data u8500_cryp1_platform_data = {
+		.mem_to_engine = {
+				.dir = STEDMA40_MEM_TO_PERIPH,
+				.src_dev_type = STEDMA40_DEV_SRC_MEMORY,
+				.dst_dev_type = DB8500_DMA_DEV48_CAC1_TX,
+				.src_info.data_width = STEDMA40_WORD_WIDTH,
+				.dst_info.data_width = STEDMA40_WORD_WIDTH,
+				.mode = STEDMA40_MODE_LOGICAL,
+				.src_info.psize = STEDMA40_PSIZE_LOG_4,
+				.dst_info.psize = STEDMA40_PSIZE_LOG_4,
+		},
+		.engine_to_mem = {
+				.dir = STEDMA40_PERIPH_TO_MEM,
+				.src_dev_type = DB8500_DMA_DEV48_CAC1_RX,
+				.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
+				.src_info.data_width = STEDMA40_WORD_WIDTH,
+				.dst_info.data_width = STEDMA40_WORD_WIDTH,
+				.mode = STEDMA40_MODE_LOGICAL,
+				.src_info.psize = STEDMA40_PSIZE_LOG_4,
+				.dst_info.psize = STEDMA40_PSIZE_LOG_4,
+		}
+};
+
+static struct stedma40_chan_cfg u8500_hash_dma_cfg_tx = {
+		.dir = STEDMA40_MEM_TO_PERIPH,
+		.src_dev_type = STEDMA40_DEV_SRC_MEMORY,
+		.dst_dev_type = DB8500_DMA_DEV50_HAC1_TX,
+		.src_info.data_width = STEDMA40_WORD_WIDTH,
+		.dst_info.data_width = STEDMA40_WORD_WIDTH,
+		.mode = STEDMA40_MODE_LOGICAL,
+		.src_info.psize = STEDMA40_PSIZE_LOG_16,
+		.dst_info.psize = STEDMA40_PSIZE_LOG_16,
+};
+
+static struct hash_platform_data u8500_hash1_platform_data = {
+		.mem_to_engine = &u8500_hash_dma_cfg_tx,
+		.dma_filter = stedma40_filter,
+};
+
 /* add any platform devices here - TODO */
 static struct platform_device *mop500_platform_devs[] __initdata = {
 	&mop500_gpio_keys_device,
@@ -594,6 +634,12 @@ static void __init mop500_uart_init(void)
 	db8500_add_uart2(&uart2_plat);
 }
 
+static void __init u8500_cryp1_hash1_init(void)
+{
+	db8500_add_cryp1(&u8500_cryp1_platform_data);
+	db8500_add_hash1(&u8500_hash1_platform_data);
+}
+
 static struct platform_device *snowball_platform_devs[] __initdata = {
 	&snowball_led_dev,
 	&snowball_key_dev,
@@ -611,6 +657,8 @@ static void __init mop500_init_machine(void)
 
 	mop500_pins_init();
 
+	u8500_cryp1_hash1_init();
+
 	platform_add_devices(mop500_platform_devs,
 			ARRAY_SIZE(mop500_platform_devs));
 
diff --git a/arch/arm/mach-ux500/board-u5500.c b/arch/arm/mach-ux500/board-u5500.c
index 9de9e9c..865aaf8 100644
--- a/arch/arm/mach-ux500/board-u5500.c
+++ b/arch/arm/mach-ux500/board-u5500.c
@@ -23,9 +23,11 @@
 #include <mach/hardware.h>
 #include <mach/devices.h>
 #include <mach/setup.h>
+#include <mach/crypto-ux500.h>
 
 #include "pins-db5500.h"
 #include "devices-db5500.h"
+#include "ste-dma40-db5500.h"
 #include <linux/led-lm3530.h>
 
 /*
@@ -89,6 +91,45 @@ static struct lm3530_platform_data u5500_als_platform_data = {
 	.brt_val = 0x7F,	/* Max brightness */
 };
 
+static struct cryp_platform_data u5500_cryp1_platform_data = {
+		.mem_to_engine = {
+				.dir = STEDMA40_MEM_TO_PERIPH,
+				.src_dev_type = STEDMA40_DEV_SRC_MEMORY,
+				.dst_dev_type = DB5500_DMA_DEV48_CRYPTO1_TX,
+				.src_info.data_width = STEDMA40_WORD_WIDTH,
+				.dst_info.data_width = STEDMA40_WORD_WIDTH,
+				.mode = STEDMA40_MODE_LOGICAL,
+				.src_info.psize = STEDMA40_PSIZE_LOG_4,
+				.dst_info.psize = STEDMA40_PSIZE_LOG_4,
+		},
+		.engine_to_mem = {
+				.dir = STEDMA40_PERIPH_TO_MEM,
+				.src_dev_type = DB5500_DMA_DEV48_CRYPTO1_RX,
+				.dst_dev_type = STEDMA40_DEV_DST_MEMORY,
+				.src_info.data_width = STEDMA40_WORD_WIDTH,
+				.dst_info.data_width = STEDMA40_WORD_WIDTH,
+				.mode = STEDMA40_MODE_LOGICAL,
+				.src_info.psize = STEDMA40_PSIZE_LOG_4,
+				.dst_info.psize = STEDMA40_PSIZE_LOG_4,
+		}
+};
+
+static struct stedma40_chan_cfg u5500_hash_dma_cfg_tx = {
+		.dir = STEDMA40_MEM_TO_PERIPH,
+		.src_dev_type = STEDMA40_DEV_SRC_MEMORY,
+		.dst_dev_type = DB5500_DMA_DEV50_HASH1_TX,
+		.src_info.data_width = STEDMA40_WORD_WIDTH,
+		.dst_info.data_width = STEDMA40_WORD_WIDTH,
+		.mode = STEDMA40_MODE_LOGICAL,
+		.src_info.psize = STEDMA40_PSIZE_LOG_16,
+		.dst_info.psize = STEDMA40_PSIZE_LOG_16,
+};
+
+static struct hash_platform_data u5500_hash1_platform_data = {
+		.mem_to_engine = &u5500_hash_dma_cfg_tx,
+		.dma_filter = stedma40_filter,
+};
+
 static struct i2c_board_info __initdata u5500_i2c2_devices[] = {
 	{
 		/* Backlight */
@@ -103,6 +144,12 @@ static void __init u5500_i2c_init(void)
 	i2c_register_board_info(2, ARRAY_AND_SIZE(u5500_i2c2_devices));
 }
 
+static void __init u5500_cryp1_hash1_init(void)
+{
+	db5500_add_cryp1(&u5500_cryp1_platform_data);
+	db5500_add_hash1(&u5500_hash1_platform_data);
+}
+
 static struct ab5500_platform_data ab5500_plf_data = {
 	.irq = {
 		.base = 0,
@@ -140,6 +187,7 @@ static void __init u5500_init_machine(void)
 	u5500_i2c_init();
 	u5500_sdi_init();
 	u5500_uart_init();
+	u5500_cryp1_hash1_init();
 
 	platform_add_devices(u5500_platform_devices,
 		ARRAY_SIZE(u5500_platform_devices));
diff --git a/arch/arm/mach-ux500/clock.c b/arch/arm/mach-ux500/clock.c
index 7379075..0b4e40c 100644
--- a/arch/arm/mach-ux500/clock.c
+++ b/arch/arm/mach-ux500/clock.c
@@ -375,14 +375,15 @@ static DEFINE_PRCC_CLK(5, usb,		0,  0, NULL);
 /* Peripheral Cluster #6 */
 
 /* MTU ID in data */
-static DEFINE_PRCC_CLK_CUSTOM(6, mtu1, 8, -1, NULL, clk_mtu_get_rate, 1);
-static DEFINE_PRCC_CLK_CUSTOM(6, mtu0, 7, -1, NULL, clk_mtu_get_rate, 0);
-static DEFINE_PRCC_CLK(6, cfgreg,	6,  6, NULL);
-static DEFINE_PRCC_CLK(6, hash1,	5, -1, NULL);
-static DEFINE_PRCC_CLK(6, unipro,	4,  1, &clk_uniproclk);
-static DEFINE_PRCC_CLK(6, pka,		3, -1, NULL);
-static DEFINE_PRCC_CLK(6, hash0,	2, -1, NULL);
-static DEFINE_PRCC_CLK(6, cryp0,	1, -1, NULL);
+static DEFINE_PRCC_CLK_CUSTOM(6, mtu1, 9, -1, NULL, clk_mtu_get_rate, 1);
+static DEFINE_PRCC_CLK_CUSTOM(6, mtu0, 8, -1, NULL, clk_mtu_get_rate, 0);
+static DEFINE_PRCC_CLK(6, cfgreg,	7,  7, NULL);
+static DEFINE_PRCC_CLK(6, hash1,	6, -1, NULL);
+static DEFINE_PRCC_CLK(6, unipro,	5,  1, &clk_uniproclk);
+static DEFINE_PRCC_CLK(6, pka,		4, -1, NULL);
+static DEFINE_PRCC_CLK(6, hash0,	3, -1, NULL);
+static DEFINE_PRCC_CLK(6, cryp0,	2, -1, NULL);
+static DEFINE_PRCC_CLK(6, cryp1,    1, -1, NULL);
 static DEFINE_PRCC_CLK(6, rng,	0,  0, &clk_rngclk);
 
 static struct clk clk_dummy_apb_pclk = {
@@ -424,6 +425,7 @@ static struct clk_lookup u8500_clks[] = {
 	CLK(pka,	"pka",		NULL),
 	CLK(hash0,	"hash0",	NULL),
 	CLK(cryp0,	"cryp0",	NULL),
+	CLK(cryp1,  "cryp1",    NULL),
 
 	/* PRCMU level clock gating */
 
diff --git a/arch/arm/mach-ux500/devices-common.c b/arch/arm/mach-ux500/devices-common.c
index c563e54..e2dbb4e 100644
--- a/arch/arm/mach-ux500/devices-common.c
+++ b/arch/arm/mach-ux500/devices-common.c
@@ -108,6 +108,22 @@ dbx500_add_platform_device_4k1irq(const char *name, int id,
 					  ARRAY_SIZE(resources));
 }
 
+struct platform_device *
+dbx500_add_platform_device_noirq(const char *name, int id,
+		resource_size_t base, void *pdata)
+{
+	struct resource resources[] = {
+			[0] = {
+					.start  = base,
+					.end    = base + SZ_4K - 1,
+					.flags  = IORESOURCE_MEM,
+			}
+	};
+
+	return dbx500_add_platform_device(name, id, pdata, resources,
+			ARRAY_SIZE(resources));
+}
+
 static struct platform_device *
 dbx500_add_gpio(int id, resource_size_t addr, int irq,
 		struct nmk_gpio_platform_data *pdata)
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 7825705..d4fea76 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -17,6 +17,10 @@ dbx500_add_platform_device_4k1irq(const char *name, int id,
 				  resource_size_t base,
 				  int irq, void *pdata);
 
+extern struct platform_device *
+dbx500_add_platform_device_noirq(const char *name, int id,
+		resource_size_t base, void *pdata);
+
 struct spi_master_cntlr;
 
 static inline struct amba_device *
@@ -79,6 +83,25 @@ dbx500_add_rtc(resource_size_t base, int irq)
 	return dbx500_add_amba_device("rtc-pl031", base, irq, NULL, 0);
 }
 
+struct cryp_platform_data;
+
+static inline struct platform_device *
+dbx500_add_cryp1(int id, resource_size_t base, int irq,
+		struct cryp_platform_data *pdata)
+{
+	return dbx500_add_platform_device_4k1irq("cryp1", id, base, irq,
+			pdata);
+}
+
+struct hash_platform_data;
+
+static inline struct platform_device *
+dbx500_add_hash1(int id, resource_size_t base,
+		struct hash_platform_data *pdata)
+{
+	return dbx500_add_platform_device_noirq("hash1", id, base, pdata);
+}
+
 struct nmk_gpio_platform_data;
 
 void dbx500_add_gpios(resource_size_t *base, int num, int irq,
diff --git a/arch/arm/mach-ux500/devices-db5500.h b/arch/arm/mach-ux500/devices-db5500.h
index 0c4bccd..d40ce40 100644
--- a/arch/arm/mach-ux500/devices-db5500.h
+++ b/arch/arm/mach-ux500/devices-db5500.h
@@ -76,4 +76,8 @@
 #define db5500_add_uart3(plat) \
 	dbx500_add_uart("uart3", U5500_UART3_BASE, IRQ_DB5500_UART3, plat)
 
+#define db5500_add_cryp1(pdata) \
+	dbx500_add_cryp1(-1, U5500_CRYP1_BASE, IRQ_DB5500_CRYP1, pdata)
+#define db5500_add_hash1(pdata) \
+	dbx500_add_hash1(-1, U5500_HASH1_BASE, pdata)
 #endif
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index cbd4a9a..8fa045c 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -98,4 +98,8 @@ db8500_add_ssp(const char *name, resource_size_t base, int irq,
 #define db8500_add_uart2(pdata) \
 	dbx500_add_uart("uart2", U8500_UART2_BASE, IRQ_DB8500_UART2, pdata)
 
+#define db8500_add_cryp1(pdata) \
+	dbx500_add_cryp1(-1, U8500_CRYP1_BASE, IRQ_DB8500_CRYP1, pdata)
+#define db8500_add_hash1(pdata) \
+	dbx500_add_hash1(-1, U8500_HASH1_BASE, pdata)
 #endif
diff --git a/arch/arm/mach-ux500/include/mach/devices.h b/arch/arm/mach-ux500/include/mach/devices.h
index 5f6cb71..a55454a 100644
--- a/arch/arm/mach-ux500/include/mach/devices.h
+++ b/arch/arm/mach-ux500/include/mach/devices.h
@@ -15,6 +15,9 @@ extern struct platform_device u8500_gpio_devs[];
 
 extern struct amba_device ux500_pl031_device;
 
+extern struct platform_device ux500_hash1_device;
+extern struct platform_device ux500_cryp1_device;
+
 extern struct platform_device u8500_dma40_device;
 extern struct platform_device ux500_ske_keypad_device;
 
diff --git a/arch/arm/mach-ux500/ste-dma40-db5500.h b/arch/arm/mach-ux500/ste-dma40-db5500.h
index cb2110c..c35f454 100644
--- a/arch/arm/mach-ux500/ste-dma40-db5500.h
+++ b/arch/arm/mach-ux500/ste-dma40-db5500.h
@@ -42,7 +42,10 @@ enum dma_src_dev_type {
 	DB5500_DMA_DEV26_SDMMC2_RX = 26,
 	DB5500_DMA_DEV27_SDMMC3_RX = 27,
 	DB5500_DMA_DEV28_SDMMC4_RX = 28,
-	/* 29 - 32 not used */
+	/* 29 not used */
+	DB5500_DMA_DEV30_HASH1_TX = 30, /* v2 */
+	DB5500_DMA_DEV31_CRYPTO1_RX = 31, /* v2 */
+	/* 32 not used */
 	DB5500_DMA_DEV33_SDMMC0_RX = 33,
 	DB5500_DMA_DEV34_SDMMC1_RX = 34,
 	DB5500_DMA_DEV35_SDMMC2_RX = 35,
@@ -56,10 +59,10 @@ enum dma_src_dev_type {
 	DB5500_DMA_DEV43_USB_OTG_IEP_5_13 = 43,
 	DB5500_DMA_DEV44_USB_OTG_IEP_6_14 = 44,
 	DB5500_DMA_DEV45_USB_OTG_IEP_7_15 = 45,
-	/* 46 not used */
+	DB5500_DMA_DEV46_CRYPTO1_RX = 46, /* v2 */
 	DB5500_DMA_DEV47_MCDE_RX = 47,
 	DB5500_DMA_DEV48_CRYPTO1_RX = 48,
-	/* 49, 50 not used */
+	/* 49 - 50 not used */
 	DB5500_DMA_DEV49_I2C1_RX = 51,
 	DB5500_DMA_DEV50_I2C3_RX = 52,
 	DB5500_DMA_DEV51_I2C2_RX = 53,
-- 
1.7.9
