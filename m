From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH stable 3.16+] crypto: s5p-sss - Fix missed interrupts when
 working with 8 kB blocks
Date: Mon, 30 May 2016 12:09:28 +0200
Message-ID: <1464602968-7526-1-git-send-email-k.kozlowski@samsung.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

commit 79152e8d085fd64484afd473ef6830b45518acba upstream.

The tcrypt testing module on Exynos5422-based Odroid XU3/4 board failed on
testing 8 kB size blocks:

	$ sudo modprobe tcrypt sec=1 mode=500
	testing speed of async ecb(aes) (ecb-aes-s5p) encryption
	test 0 (128 bit key, 16 byte blocks): 21971 operations in 1 seconds (351536 bytes)
	test 1 (128 bit key, 64 byte blocks): 21731 operations in 1 seconds (1390784 bytes)
	test 2 (128 bit key, 256 byte blocks): 21932 operations in 1 seconds (5614592 bytes)
	test 3 (128 bit key, 1024 byte blocks): 21685 operations in 1 seconds (22205440 bytes)
	test 4 (128 bit key, 8192 byte blocks):

This was caused by a race issue of missed BRDMA_DONE ("Block cipher
Receiving DMA") interrupt. Device starts processing the data in DMA mode
immediately after setting length of DMA block: receiving (FCBRDMAL) or
transmitting (FCBTDMAL). The driver sets these lengths from interrupt
handler through s5p_set_dma_indata() function (or xxx_setdata()).

However the interrupt handler was first dealing with receive buffer
(dma-unmap old, dma-map new, set receive block length which starts the
operation), then with transmit buffer and finally was clearing pending
interrupts (FCINTPEND). Because of the time window between setting
receive buffer length and clearing pending interrupts, the operation on
receive buffer could end already and driver would miss new interrupt.

User manual for Exynos5422 confirms in example code that setting DMA
block lengths should be the last operation.

The tcrypt hang could be also observed in following blocked-task dmesg:

INFO: task modprobe:258 blocked for more than 120 seconds.
      Not tainted 4.6.0-rc4-next-20160419-00005-g9eac8b7b7753-dirty #42
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
modprobe        D c06b09d8     0   258    256 0x00000000
[<c06b09d8>] (__schedule) from [<c06b0f24>] (schedule+0x40/0xac)
[<c06b0f24>] (schedule) from [<c06b49f8>] (schedule_timeout+0x124/0x178)
[<c06b49f8>] (schedule_timeout) from [<c06b17fc>] (wait_for_common+0xb8/0x144)
[<c06b17fc>] (wait_for_common) from [<bf0013b8>] (test_acipher_speed+0x49c/0x740 [tcrypt])
[<bf0013b8>] (test_acipher_speed [tcrypt]) from [<bf003e8c>] (do_test+0x2240/0x30ec [tcrypt])
[<bf003e8c>] (do_test [tcrypt]) from [<bf008048>] (tcrypt_mod_init+0x48/0xa4 [tcrypt])
[<bf008048>] (tcrypt_mod_init [tcrypt]) from [<c010177c>] (do_one_initcall+0x3c/0x16c)
[<c010177c>] (do_one_initcall) from [<c0191ff0>] (do_init_module+0x5c/0x1ac)
[<c0191ff0>] (do_init_module) from [<c0185610>] (load_module+0x1a30/0x1d08)
[<c0185610>] (load_module) from [<c0185ab0>] (SyS_finit_module+0x8c/0x98)
[<c0185ab0>] (SyS_finit_module) from [<c01078c0>] (ret_fast_syscall+0x0/0x3c)

Fixes: a49e490c7a8a ("crypto: s5p-sss - add S5PV210 advanced crypto engine support")
Cc: <stable@vger.kernel.org> # 3.16+
Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
[k.kozlowski: Backport to v3.16]

---

Backporting to earlier kernels does not make much sense as the driver
differs and the testing won't be possible probably.
---
 drivers/crypto/s5p-sss.c | 53 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 4197ad9a711b..8a46de76b834 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -313,43 +313,55 @@ static int s5p_set_indata(struct s5p_aes_dev *dev, struct scatterlist *sg)
 	return err;
 }
 
-static void s5p_aes_tx(struct s5p_aes_dev *dev)
+/*
+ * Returns true if new transmitting (output) data is ready and its
+ * address+length have to be written to device (by calling
+ * s5p_set_dma_outdata()). False otherwise.
+ */
+static bool s5p_aes_tx(struct s5p_aes_dev *dev)
 {
 	int err = 0;
+	bool ret = false;
 
 	s5p_unset_outdata(dev);
 
 	if (!sg_is_last(dev->sg_dst)) {
 		err = s5p_set_outdata(dev, sg_next(dev->sg_dst));
-		if (err) {
+		if (err)
 			s5p_aes_complete(dev, err);
-			return;
-		}
-
-		s5p_set_dma_outdata(dev, dev->sg_dst);
+		else
+			ret = true;
 	} else {
 		s5p_aes_complete(dev, err);
 
 		dev->busy = true;
 		tasklet_schedule(&dev->tasklet);
 	}
+
+	return ret;
 }
 
-static void s5p_aes_rx(struct s5p_aes_dev *dev)
+/*
+ * Returns true if new receiving (input) data is ready and its
+ * address+length have to be written to device (by calling
+ * s5p_set_dma_indata()). False otherwise.
+ */
+static bool s5p_aes_rx(struct s5p_aes_dev *dev)
 {
 	int err;
+	bool ret = false;
 
 	s5p_unset_indata(dev);
 
 	if (!sg_is_last(dev->sg_src)) {
 		err = s5p_set_indata(dev, sg_next(dev->sg_src));
-		if (err) {
+		if (err)
 			s5p_aes_complete(dev, err);
-			return;
-		}
-
-		s5p_set_dma_indata(dev, dev->sg_src);
+		else
+			ret = true;
 	}
+
+	return ret;
 }
 
 static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
@@ -358,19 +370,32 @@ static irqreturn_t s5p_aes_interrupt(int irq, void *dev_id)
 	struct s5p_aes_dev     *dev  = platform_get_drvdata(pdev);
 	uint32_t                status;
 	unsigned long           flags;
+	bool			set_dma_tx = false;
+	bool			set_dma_rx = false;
 
 	spin_lock_irqsave(&dev->lock, flags);
 
 	if (irq == dev->irq_fc) {
 		status = SSS_READ(dev, FCINTSTAT);
 		if (status & SSS_FCINTSTAT_BRDMAINT)
-			s5p_aes_rx(dev);
+			set_dma_rx = s5p_aes_rx(dev);
 		if (status & SSS_FCINTSTAT_BTDMAINT)
-			s5p_aes_tx(dev);
+			set_dma_tx = s5p_aes_tx(dev);
 
 		SSS_WRITE(dev, FCINTPEND, status);
 	}
 
+	/*
+	 * Writing length of DMA block (either receiving or transmitting)
+	 * will start the operation immediately, so this should be done
+	 * at the end (even after clearing pending interrupts to not miss the
+	 * interrupt).
+	 */
+	if (set_dma_tx)
+		s5p_set_dma_outdata(dev, dev->sg_dst);
+	if (set_dma_rx)
+		s5p_set_dma_indata(dev, dev->sg_src);
+
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	return IRQ_HANDLED;
-- 
1.9.1
