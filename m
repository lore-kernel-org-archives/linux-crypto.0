From: Patrick McHardy <kaber@trash.net>
Subject: [HIFN 03/03]: Add support for using the random number generator
Date: Sun, 18 Nov 2007 22:32:57 +0100 (MET)
Message-ID: <20071118213246.9217.6165.sendpatchset@localhost.localdomain>
References: <20071118213241.9217.7696.sendpatchset@localhost.localdomain>
Cc: johnpol@2ka.mipt.ru, Patrick McHardy <kaber@trash.net>,
	linux-crypto@vger.kernel.org, mb@bu3sch.de,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46266 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754206AbXKRVc7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 16:32:59 -0500
In-Reply-To: <20071118213241.9217.7696.sendpatchset@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[HIFN]: Add support for using the random number generator

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 352a65d036f53c1e124bef4205d6fcedb78eac2c
tree 190bb0b4a1795e55096552f743af996df2766070
parent 70467fae3a656562f86adefdfe6d54e3ca20feeb
author Patrick McHardy <kaber@trash.net> Sun, 18 Nov 2007 22:09:17 +0100
committer Patrick McHardy <kaber@trash.net> Sun, 18 Nov 2007 22:09:17 +0100

 drivers/crypto/hifn_795x.c |   82 +++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 81 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index de594bc..1a19700 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -31,6 +31,8 @@
 #include <linux/highmem.h>
 #include <linux/interrupt.h>
 #include <linux/crypto.h>
+#include <linux/hw_random.h>
+#include <linux/ktime.h>
 
 #include <crypto/algapi.h>
 #include <crypto/des.h>
@@ -458,6 +460,14 @@ struct hifn_device
 
 	struct crypto_queue 	queue;
 	struct list_head	alg_list;
+
+	unsigned int		pk_clk_freq;
+
+#if defined(CONFIG_HW_RANDOM) || defined(CONFIG_HW_RANDOM_MODULE)
+	unsigned int		rng_wait_time;
+	ktime_t			rngtime;
+	struct hwrng		rng;
+#endif
 };
 
 #define	HIFN_D_LENGTH			0x0000ffff
@@ -785,6 +795,56 @@ static struct pci2id {
 	}
 };
 
+#if defined(CONFIG_HW_RANDOM) || defined(CONFIG_HW_RANDOM_MODULE)
+static int hifn_rng_data_present(struct hwrng *rng, int wait)
+{
+	struct hifn_device *dev = (struct hifn_device *)rng->priv;
+	s64 nsec;
+
+	nsec = ktime_to_ns(ktime_sub(ktime_get(), dev->rngtime));
+	nsec -= dev->rng_wait_time;
+	if (nsec <= 0)
+		return 1;
+	if (!wait)
+		return 0;
+	ndelay(nsec);
+	return 1;
+}
+
+static int hifn_rng_data_read(struct hwrng *rng, u32 *data)
+{
+	struct hifn_device *dev = (struct hifn_device *)rng->priv;
+
+	*data = hifn_read_1(dev, HIFN_1_RNG_DATA);
+	dev->rngtime = ktime_get();
+	return 4;
+}
+
+static int hifn_register_rng(struct hifn_device *dev)
+{
+	/*
+	 * We must wait at least 256 Pk_clk cycles between two reads of the rng.
+	 */
+	dev->rng_wait_time	= DIV_ROUND_UP(NSEC_PER_SEC, dev->pk_clk_freq) *
+				  256;
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
@@ -820,6 +880,11 @@ static int hifn_init_pubrng(struct hifn_device *dev)
 	dprintk("Chip %s: RNG engine has been successfully initialised.\n",
 			dev->name);
 
+#if defined(CONFIG_HW_RANDOM) || defined(CONFIG_HW_RANDOM_MODULE)
+	/* First value must be discarded */
+	hifn_read_1(dev, HIFN_1_RNG_DATA);
+	dev->rngtime = ktime_get();
+#endif
 	return 0;
 }
 
@@ -952,6 +1017,14 @@ static void hifn_init_pll(struct hifn_device *dev)
 	/* Switch the engines to the PLL */
 	hifn_write_1(dev, HIFN_1_PLL, pllcfg |
 		     HIFN_PLL_PK_CLK_PLL | HIFN_PLL_PE_CLK_PLL);
+
+	/*
+	 * The Fpk_clk runs at half the total speed. Its frequency is needed to
+	 * calculate the minimum time between two reads of the rng. Since 33MHz
+	 * is actually 33.333... we overestimate the frequency here, resulting
+	 * in slightly larger intervals.
+	 */
+	dev->pk_clk_freq = 1000000 * (freq + 1) * m / 2;
 }
 
 static void hifn_init_registers(struct hifn_device *dev)
@@ -2609,10 +2682,14 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_out_stop_device;
 
-	err = hifn_register_alg(dev);
+	err = hifn_register_rng(dev);
 	if (err)
 		goto err_out_stop_device;
 
+	err = hifn_register_alg(dev);
+	if (err)
+		goto err_out_unregister_rng;
+
 	INIT_DELAYED_WORK(&dev->work, hifn_work);
 	schedule_delayed_work(&dev->work, HZ);
 
@@ -2622,6 +2699,8 @@ static int hifn_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
+err_out_unregister_rng:
+	hifn_unregister_rng(dev);
 err_out_stop_device:
 	hifn_reset_dma(dev, 1);
 	hifn_stop_device(dev);
@@ -2662,6 +2741,7 @@ static void hifn_remove(struct pci_dev *pdev)
 		cancel_delayed_work(&dev->work);
 		flush_scheduled_work();
 
+		hifn_unregister_rng(dev);
 		hifn_unregister_alg(dev);
 		hifn_reset_dma(dev, 1);
 		hifn_stop_device(dev);
