From: Patrick McHardy <kaber@trash.net>
Subject: [RFC HIFN 02/02]: Add support for using the random number generator
Date: Sat, 17 Nov 2007 20:30:11 +0100 (MET)
Message-ID: <20071117192952.19399.90766.sendpatchset@localhost.localdomain>
References: <20071117192949.19399.75523.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, linux-crypto@vger.kernel.org
To: johnpol@2ka.mipt.ru
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48306 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762269AbXKQTaN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Nov 2007 14:30:13 -0500
In-Reply-To: <20071117192949.19399.75523.sendpatchset@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[HIFN]: Add support for using the random number generator

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ad6c98ed1e38edf4da775780b59a0faf56ff42a7
tree 7c733d13a387e18bace04fe904bed9937c0bb628
parent 3ca22e0c464bc84bffdf63d65c1094b2fed78bff
author Patrick McHardy <kaber@trash.net> Sat, 17 Nov 2007 20:15:40 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 17 Nov 2007 20:15:40 +0100

 drivers/crypto/hifn_795x.c |   65 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index 81306b7..fe5289a 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -31,6 +31,7 @@
 #include <linux/highmem.h>
 #include <linux/interrupt.h>
 #include <linux/crypto.h>
+#include <linux/hw_random.h>
 
 #include <crypto/algapi.h>
 #include <crypto/des.h>
@@ -458,6 +459,14 @@ struct hifn_device
 
 	struct crypto_queue 	queue;
 	struct list_head	alg_list;
+
+	unsigned int		pk_clk_freq;
+
+#if defined(CONFIG_HW_RANDOM) || defined(CONFIG_HW_RANDOM_MODULE)
+	cycles_t		rng_wait_cycles;
+	cycles_t		rngtime;
+	struct hwrng		rng;
+#endif
 };
 
 #define	HIFN_D_LENGTH			0x0000ffff
@@ -785,6 +794,49 @@ static struct pci2id {
 	}
 };
 
+#if defined(CONFIG_HW_RANDOM) || defined(CONFIG_HW_RANDOM_MODULE)
+static int hifn_rng_data_present(struct hwrng *rng)
+{
+	struct hifn_device *dev = (struct hifn_device *)rng->priv;
+
+	return get_cycles() - dev->rngtime > dev->rng_wait_cycles;
+}
+
+static int hifn_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	struct hifn_device *dev = (struct hifn_device *)rng->priv;
+
+	*data = hifn_read_1(dev, HIFN_1_RNG_DATA);
+	dev->rngtime = get_cycles();
+	return 4;
+}
+
+static int hifn_register_rng(struct hifn_device *dev)
+{
+	/*
+	 * We must wait at least 256 Pk_clk cycles between two reads of
+	 * the rng. Calculate corresponding amount CPU cycles based on
+	 * a CPU speed of 4GHz.
+	 */
+	dev->rng_wait_cycles	= 256 * DIV_ROUND_UP(4000U, dev->pk_clk_freq);
+
+	dev->rng.name		= dev->name;
+	dev->rng.data_present	= hifn_rng_data_present,
+	dev->rng.data_read	= hifn_rng_data_read,
+	dev->rng.priv		= (unsigned long)dev;
+
+	return hwrng_register(&dev->rng);
+}
+
+static void hifn_unregister_rng(struct hifn_device *dev)
+{
+	hwrng_unregister(&dev->rng);
+}
+#else
+#define hifn_register_rng(dev)		0
+#define hifn_unregister_rng(dev)
+#endif
+
 static int hifn_init_pubrng(struct hifn_device *dev)
 {
 	int i;
@@ -936,6 +988,14 @@ static void hifn_init_pll(struct hifn_device *dev)
 		pllcfg |= HIFN_PLL_IS_9_12;
 
 	hifn_write_1(dev, HIFN_1_PLL, pllcfg);
+
+	/*
+	 * The Fpk_clk runs at half the total speed. Its frequency is needed to
+	 * calculate the minimum time between two reads of the rng. Since 33MHz
+	 * is actually 33.333... we overestimate the frequency here, resulting
+	 * in slightly larger intervals.
+	 */
+	dev->pk_clk_freq = (freq + 1) * m / 2;
 }
 
 static void hifn_init_registers(struct hifn_device *dev)
@@ -2597,6 +2657,10 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_out_stop_device;
 
+	err = hifn_register_rng(dev);
+	if (err)
+		goto err_out_stop_device;
+
 	INIT_DELAYED_WORK(&dev->work, hifn_work);
 	schedule_delayed_work(&dev->work, HZ);
 
@@ -2647,6 +2711,7 @@ static void hifn_remove(struct pci_dev *pdev)
 		flush_scheduled_work();
 
 		hifn_unregister_alg(dev);
+		hifn_unregister_rng(dev);
 		hifn_reset_dma(dev, 1);
 		hifn_stop_device(dev);
 
