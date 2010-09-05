From: Tobias Karnat <tobias.karnat@googlemail.com>
Subject: Re: [PATCH 1/2] crypto: updates to enable omap aes
Date: Sun, 05 Sep 2010 03:09:11 +0200
Message-ID: <1283648951.12080.19.camel@Tobias-Karnat>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62678 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0IEBJO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 4 Sep 2010 21:09:14 -0400
Received: by bwz11 with SMTP id 11so2545736bwz.19
        for <linux-crypto@vger.kernel.org>; Sat, 04 Sep 2010 18:09:12 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I have patched the omap-aes driver so I can use it as a module on the Nokia N900 (2.6.28).

However cryptsetup does not work with aes-cbc-essiv:rmd256, this locks the cpu and I have to stop it with ctrl-c.

[ 1377.739746] omap_aes_mod_init: loading omap-aes driver
[ 1377.745452] omap-aes omap-aes: OMAP AES hw accel rev: 2.6
[ 1377.753326] omap_aes_probe: probe() done
[ 1611.270080] device-mapper: table: 253:0: crypt: Block size of ESSIV cipher does not match IV size of block cipher
[ 1611.270141] device-mapper: ioctl: error adding target to table
[ 1611.282684] device-mapper: ioctl: device doesn't appear to be in the dev hash table.
[ 1790.802093] Spurious irq 95: 0xffffffdf, please flush posted write for irq 86
[ 1790.802124] Spurious irq 95: 0xffffffdf, please flush posted write for irq 86
[ 2082.879272] omap_aes_mod_init: loading omap-aes driver
[ 2082.882843] omap-aes omap-aes: OMAP AES hw accel rev: 2.6
[ 2082.890594] omap_aes_probe: probe() done
[ 2134.589508] wlan0: deauthenticated
[ 2135.824554] wlan0: authenticate with AP 00:1a:4f:98:7e:a7
[ 2135.827941] wlan0: authenticated
[ 2135.827972] wlan0: associate with AP 00:1a:4f:98:7e:a7
[ 2135.834014] wlan0: RX AssocResp from 00:1a:4f:98:7e:a7 (capab=0x411 status=0 aid=2)
[ 2135.834045] wlan0: associated
[ 2284.492431] Spurious irq 95: 0xffffffdf, please flush posted write for irq 86
[ 2284.492462] Spurious irq 95: 0xffffffdf, please flush posted write for irq 86
[ 2468.053894] omap_aes_mod_init: loading omap-aes driver
[ 2468.057128] omap-aes omap-aes: OMAP AES hw accel rev: 2.6
[ 2468.063903] omap_aes_probe: probe() done
[ 2608.637451] DMA transaction error with device 66
[ 2630.361602] ------------[ cut here ]------------
[ 2630.361633] WARNING: at crypto/algapi.c:293 crypto_wait_for_test+0x60/0x70()
[ 2630.361633] Modules linked in: omap_aes rmd256 dm_crypt dm_mod vfat fat sd_mod scsi_mod iphb rfcomm panic_info_buff sco l2cap ext3 jbd omaplfb pvrsrvkm bridgedriver g_file_storage uinput board_rx51_camera omap_previewer_hack omap34xxcam_mod isp_mod iovmm videobuf_dma_sg videobuf_core omap3_iommu iommu2 iommu dspbridge ssi_mcsaab_imp phonet cmt_speech smc91x mii wl12xx mmc_block omap_wdt omap_ssi mac80211 crc7 tsc2005 omap_hsmmc nokia_av mmc_core hci_h4p bluetooth fmtx_si4713 et8ek8 lis302dl videodev v4l1_compat compat_ioctl32 ad5820 leds_lp5523 adp1653 tsl2563 smia_sensor smiaregs v4l2_int_device rtc_twl4030 rtc_core twl4030_wdt leds_twl4030_vibra led_class jfs fuse [last unloaded: omap_aes]
[ 2630.361907] [<c003039c>] (dump_stack+0x0/0x14) from [<c0056ac8>] (warn_on_slowpath+0x4c/0x68)
[ 2630.361968] [<c0056a7c>] (warn_on_slowpath+0x0/0x68) from [<c0135c00>] (crypto_wait_for_test+0x60/0x70)
[ 2630.361999]  r6:c7d38800 r5:c036d474 r4:c7d38800
[ 2630.362030] [<c0135ba0>] (crypto_wait_for_test+0x0/0x70) from [<c0136008>] (crypto_register_instance+0x98/0xa4)
[ 2630.362060]  r5:c036d474 r4:cc554800
[ 2630.362060] [<c0135f70>] (crypto_register_instance+0x0/0xa4) from [<c0137450>] (crypto_lookup_skcipher+0x138/0x180)
[ 2630.362091]  r9:0000000c r8:c7d38700 r7:bf3402d0 r6:c036d474 r5:00000000
[ 2630.362121] r4:cc554800
[ 2630.362152] [<c0137318>] (crypto_lookup_skcipher+0x0/0x180) from [<c013763c>] (crypto_alloc_ablkcipher+0x44/0x9c)
[ 2630.362182] [<c01375f8>] (crypto_alloc_ablkcipher+0x0/0x9c) from [<bf2fb478>] (crypt_ctr+0x17c/0x644 [dm_crypt])
[ 2630.362243] [<bf2fb2fc>] (crypt_ctr+0x0/0x644 [dm_crypt]) from [<bf2ea228>] (dm_table_add_target+0x150/0x310 [dm_mod])
[ 2630.362335] [<bf2ea0d8>] (dm_table_add_target+0x0/0x310 [dm_mod]) from [<bf2ec030>] (table_load+0xc4/0x1cc [dm_mod])
[ 2630.362426] [<bf2ebf6c>] (table_load+0x0/0x1cc [dm_mod]) from [<bf2ecc94>] (dm_ctl_ioctl+0x2dc/0x364 [dm_mod])
[ 2630.362518] [<bf2ec9b8>] (dm_ctl_ioctl+0x0/0x364 [dm_mod]) from [<c00c6a50>] (vfs_ioctl+0x34/0x94)
[ 2630.362579] [<c00c6a1c>] (vfs_ioctl+0x0/0x94) from [<c00c7044>] (do_vfs_ioctl+0x498/0x4d8)
[ 2630.362609]  r7:00000003 r6:00084080 r5:00000003 r4:c68e2240
[ 2630.362640] [<c00c6bac>] (do_vfs_ioctl+0x0/0x4d8) from [<c00c70dc>] (sys_ioctl+0x58/0x7c)
[ 2630.362670]  r9:cdf30000 r8:c68e2240 r6:c138fd09 r5:00084080 r4:00000000
[ 2630.362701] [<c00c7084>] (sys_ioctl+0x0/0x7c) from [<c002c920>] (ret_fast_syscall+0x0/0x2c)
[ 2630.362731]  r8:c002caa4 r7:00000036 r6:4002dfb8 r5:0000004f r4:0000acd8
[ 2630.362762] ---[ end trace a05c43357cccf48d ]---
[ 2630.362792] device-mapper: table: 253:0: crypt: Error allocating crypto tfm
[ 2630.362823] device-mapper: ioctl: error adding target to table
[ 2656.537902] device-mapper: table: 253:1: crypt: Error allocating crypto tfm
[ 2656.537933] device-mapper: ioctl: error adding target to table

Using cryptsetup with aes-cbc-essiv:rmd128 is successful, but the N900 does not wake up from powersaving, while the module is loaded.

The module compiles without warnings, I have no idea.

Tobias

--- omap-aes.c	2010-08-22 00:44:23.000000000 +0200
+++ patched/omap-aes.c	2010-08-23 18:47:51.526382224 +0200
@@ -29,8 +29,11 @@
 #include <crypto/scatterwalk.h>
 #include <crypto/aes.h>
 
-#include <plat/cpu.h>
-#include <plat/dma.h>
+#include <mach/cpu.h>
+#include <mach/dma.h>
+
+#define OMAP34XX_SEC_BASE	(L4_34XX_BASE + 0xA0000)
+#define OMAP34XX_SEC_AES_BASE	(OMAP34XX_SEC_BASE + 0x25000)
 
 /* OMAP TRM gives bitfields as start:end, where start is the higher bit
    number. For example 7:0 */
@@ -80,6 +83,13 @@
 #define FLAGS_FAST		BIT(7)
 #define FLAGS_BUSY		8
 
+#ifdef CONFIG_ARCH_OMAP24XX
+#define AES_ICLK	"aes_ick"
+#endif
+#ifdef CONFIG_ARCH_OMAP34XX
+#define AES_ICLK	"aes2_ick"
+#endif
+
 struct omap_aes_ctx {
 	struct omap_aes_dev *dd;
 
@@ -829,7 +839,7 @@
 		dd->dma_in = res->start;
 
 	/* Initializing the clock */
-	dd->iclk = clk_get(dev, "ick");
+	dd->iclk = clk_get(NULL, AES_ICLK);
 	if (!dd->iclk) {
 		dev_err(dev, "clock intialization failed.\n");
 		err = -ENODEV;
@@ -913,6 +923,53 @@
 	return 0;
 }
 
+#ifdef CONFIG_ARCH_OMAP24XX
+static struct resource aes_resources[] = {
+	{
+		.start	= OMAP24XX_SEC_AES_BASE,
+		.end	= OMAP24XX_SEC_AES_BASE + 0x4C,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= OMAP24XX_DMA_AES_TX,
+		.flags	= IORESOURCE_DMA,
+	},
+	{
+		.start	= OMAP24XX_DMA_AES_RX,
+		.flags	= IORESOURCE_DMA,
+	}
+};
+#endif
+#ifdef CONFIG_ARCH_OMAP34XX
+static struct resource aes_resources[] = {
+	{
+		.start	= OMAP34XX_SEC_AES_BASE,
+		.end	= OMAP34XX_SEC_AES_BASE + 0x4C,
+		.flags	= IORESOURCE_MEM,
+	},
+	{
+		.start	= OMAP34XX_DMA_AES2_TX,
+		.flags	= IORESOURCE_DMA,
+	},
+	{
+		.start	= OMAP34XX_DMA_AES2_RX,
+		.flags	= IORESOURCE_DMA,
+	}
+};
+#endif
+
+static void omap_aes_release(struct device *dev)
+{
+}
+
+static struct platform_device aes_device = {
+	.name		= "omap-aes",
+	.id		= -1,
+	.num_resources	= ARRAY_SIZE(aes_resources),
+	.resource	= aes_resources,
+	.dev.release	= omap_aes_release,
+};
+
 static struct platform_driver omap_aes_driver = {
 	.probe	= omap_aes_probe,
 	.remove	= omap_aes_remove,
@@ -924,18 +981,35 @@
 
 static int __init omap_aes_mod_init(void)
 {
+	int ret;
+
 	pr_info("loading %s driver\n", "omap-aes");
 
-	if (!cpu_class_is_omap2() || omap_type() != OMAP2_DEVICE_TYPE_SEC) {
+	if (!cpu_class_is_omap2() ||
+		omap_type() != OMAP2_DEVICE_TYPE_SEC) {
 		pr_err("Unsupported cpu\n");
 		return -ENODEV;
 	}
 
-	return  platform_driver_register(&omap_aes_driver);
+	ret = platform_driver_register(&omap_aes_driver);
+	if (ret)
+		return ret;
+
+	ret = platform_device_register(&aes_device);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	platform_driver_unregister(&omap_aes_driver);
+
+	return ret;
 }
 
 static void __exit omap_aes_mod_exit(void)
 {
+	platform_device_unregister(&aes_device);
 	platform_driver_unregister(&omap_aes_driver);
 }
 
