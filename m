From: Andreas Westin <andreas.westin@stericsson.com>
Subject: [PATCH 1/2] mach-ux500: Crypto: core support for CRYP/HASH module.
Date: Tue, 8 May 2012 13:28:32 +0200
Message-ID: <1336476513-17145-2-git-send-email-andreas.westin@stericsson.com>
References: <1336476513-17145-1-git-send-email-andreas.westin@stericsson.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>, <arnd@arndb.de>,
	<sfr@canb.auug.org.au>, <lee.jones@linaro.org>,
	Andreas Westin <andreas.westin@stericsson.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:36379 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753624Ab2EHL3V (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 8 May 2012 07:29:21 -0400
In-Reply-To: <1336476513-17145-1-git-send-email-andreas.westin@stericsson.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This adds the required platform data and calls to enable
the CRYP/HASH driver.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Andreas Westin <andreas.westin@stericsson.com>
---
 arch/arm/mach-ux500/board-mop500.c              |   48 ++++++++++++++++++++
 arch/arm/mach-ux500/clock.c                     |   18 ++++----
 arch/arm/mach-ux500/devices-common.h            |   54 +++++++++++++++++++++++
 arch/arm/mach-ux500/devices-db8500.h            |    4 ++
 arch/arm/mach-ux500/id.c                        |    3 ++
 arch/arm/mach-ux500/include/mach/crypto-ux500.h |    1 +
 arch/arm/mach-ux500/include/mach/devices.h      |    3 ++
 7 files changed, 123 insertions(+), 8 deletions(-)

diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
index 77d03c1..d622606 100644
--- a/arch/arm/mach-ux500/board-mop500.c
+++ b/arch/arm/mach-ux500/board-mop500.c
@@ -47,6 +47,7 @@
 #include <mach/setup.h>
 #include <mach/devices.h>
 #include <mach/irqs.h>
+#include <mach/crypto-ux500.h>
 
 #include "pins-db8500.h"
 #include "ste-dma40-db8500.h"
@@ -417,6 +418,45 @@ static void mop500_prox_deactivate(struct device *dev)
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
@@ -602,6 +642,12 @@ static void __init mop500_uart_init(struct device *parent)
 	db8500_add_uart2(parent, &uart2_plat);
 }
 
+static void __init u8500_cryp1_hash1_init(struct device *parent)
+{
+	db8500_add_cryp1(parent, &u8500_cryp1_platform_data);
+	db8500_add_hash1(parent, &u8500_hash1_platform_data);
+}
+
 static struct platform_device *snowball_platform_devs[] __initdata = {
 	&snowball_led_dev,
 	&snowball_key_dev,
@@ -633,6 +679,8 @@ static void __init mop500_init_machine(void)
 	mop500_spi_init(parent);
 	mop500_uart_init(parent);
 
+	u8500_cryp1_hash1_init(parent);
+
 	i2c0_devs = ARRAY_SIZE(mop500_i2c0_devices);
 
 	i2c_register_board_info(0, mop500_i2c0_devices, i2c0_devs);
diff --git a/arch/arm/mach-ux500/clock.c b/arch/arm/mach-ux500/clock.c
index ec35f0a..2efc1fe 100644
--- a/arch/arm/mach-ux500/clock.c
+++ b/arch/arm/mach-ux500/clock.c
@@ -382,14 +382,15 @@ static DEFINE_PRCC_CLK(5, usb,		0,  0, NULL);
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
@@ -431,6 +432,7 @@ static struct clk_lookup u8500_clks[] = {
 	CLK(pka,	"pka",		NULL),
 	CLK(hash0,	"hash0",	NULL),
 	CLK(cryp0,	"cryp0",	NULL),
+	CLK(cryp1,  "cryp1",    NULL),
 
 	/* PRCMU level clock gating */
 
diff --git a/arch/arm/mach-ux500/devices-common.h b/arch/arm/mach-ux500/devices-common.h
index 39c74ec..89c5a59 100644
--- a/arch/arm/mach-ux500/devices-common.h
+++ b/arch/arm/mach-ux500/devices-common.h
@@ -12,12 +12,17 @@
 #include <linux/dma-mapping.h>
 #include <linux/sys_soc.h>
 #include <plat/i2c.h>
+#include <mach/crypto-ux500.h>
 
 extern struct amba_device *
 dbx500_add_amba_device(struct device *parent, const char *name,
 		       resource_size_t base, int irq, void *pdata,
 		       unsigned int periphid);
 
+extern struct platform_device *
+dbx500_add_platform_device_noirq(const char *name, int id,
+		resource_size_t base, void *pdata);
+
 struct spi_master_cntlr;
 
 static inline struct amba_device *
@@ -88,6 +93,55 @@ dbx500_add_rtc(struct device *parent, resource_size_t base, int irq)
 	return dbx500_add_amba_device(parent, "rtc-pl031", base, irq, NULL, 0);
 }
 
+struct cryp_platform_data;
+
+static inline struct platform_device *
+dbx500_add_cryp1(struct device *parent, int id, resource_size_t base, int irq,
+		struct cryp_platform_data *pdata)
+{
+	struct resource res[] = {
+			DEFINE_RES_MEM(base, SZ_4K),
+			DEFINE_RES_IRQ(irq),
+	};
+
+	struct platform_device_info pdevinfo = {
+			.parent = parent,
+			.name = "cryp1",
+			.id = id,
+			.res = res,
+			.num_res = ARRAY_SIZE(res),
+			.data = pdata,
+			.size_data = sizeof(*pdata),
+			.dma_mask = DMA_BIT_MASK(32),
+	};
+
+	return platform_device_register_full(&pdevinfo);
+}
+
+struct hash_platform_data;
+
+static inline struct platform_device *
+dbx500_add_hash1(struct device *parent, int id, resource_size_t base,
+		struct hash_platform_data *pdata)
+{
+	struct resource res[] = {
+			DEFINE_RES_MEM(base, SZ_4K),
+	};
+
+	struct platform_device_info pdevinfo = {
+			.parent = parent,
+			.name = "hash1",
+			.id = id,
+			.res = res,
+			.num_res = ARRAY_SIZE(res),
+			.data = pdata,
+			.size_data = sizeof(*pdata),
+			.dma_mask = DMA_BIT_MASK(32),
+	};
+
+	return platform_device_register_full(&pdevinfo);
+}
+
 struct nmk_gpio_platform_data;
 
 void dbx500_add_gpios(struct device *parent, resource_size_t *base, int num,
diff --git a/arch/arm/mach-ux500/devices-db8500.h b/arch/arm/mach-ux500/devices-db8500.h
index 9fd93e9..cdf5ca8 100644
--- a/arch/arm/mach-ux500/devices-db8500.h
+++ b/arch/arm/mach-ux500/devices-db8500.h
@@ -124,4 +124,8 @@ db8500_add_ssp(struct device *parent, const char *name, resource_size_t base,
 	dbx500_add_uart(parent, "uart2", U8500_UART2_BASE, \
 			IRQ_DB8500_UART2, pdata)
 
+#define db8500_add_cryp1(parent, pdata) \
+	dbx500_add_cryp1(parent, -1, U8500_CRYP1_BASE, IRQ_DB8500_CRYP1, pdata)
+#define db8500_add_hash1(parent, pdata) \
+	dbx500_add_hash1(parent, -1, U8500_HASH1_BASE, pdata)
 #endif
diff --git a/arch/arm/mach-ux500/id.c b/arch/arm/mach-ux500/id.c
index 15a0f63..a69db46 100644
--- a/arch/arm/mach-ux500/id.c
+++ b/arch/arm/mach-ux500/id.c
@@ -17,7 +17,10 @@
 #include <mach/hardware.h>
 #include <mach/setup.h>
 
+#include <linux/module.h>
+
 struct dbx500_asic_id dbx500_id;
+EXPORT_SYMBOL(dbx500_id);
 
 static unsigned int ux500_read_asicid(phys_addr_t addr)
 {
diff --git a/arch/arm/mach-ux500/include/mach/crypto-ux500.h b/arch/arm/mach-ux500/include/mach/crypto-ux500.h
index de40add..5b2d081 100644
--- a/arch/arm/mach-ux500/include/mach/crypto-ux500.h
+++ b/arch/arm/mach-ux500/include/mach/crypto-ux500.h
@@ -5,6 +5,7 @@
  * License terms: GNU General Public License (GPL) version 2
  */
 #ifndef _CRYPTO_UX500_H
+#define _CRYPTO_UX500_H
 #include <linux/dmaengine.h>
 #include <plat/ste_dma40.h>
 
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
 
-- 
1.7.10
