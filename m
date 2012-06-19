From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Tue, 19 Jun 2012 19:13:04 +0200
Message-ID: <20120619171304.GQ9122@philter.vipri.net>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
 <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
 <20120618134718.GL9122@philter.vipri.net>
 <20120618201235.GA20755@schnuecks.de>
 <20120619115123.GN9122@philter.vipri.net>
 <4FE09637.2020802@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="RASg3xLB4tUQ4RcS"
Content-Transfer-Encoding: 8bit
Cc: Simon Baatz <gmbnomis@gmail.com>, linux-crypto@vger.kernel.org,
	andrew@lunn.ch
To: "cloudy.linux" <cloudy.linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:40853 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751049Ab2FSRNN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Jun 2012 13:13:13 -0400
Content-Disposition: inline
In-Reply-To: <4FE09637.2020802@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

On Tue, Jun 19, 2012 at 11:09:43PM +0800, cloudy.linux wrote:
> On 2012-6-19 19:51, Phil Sutter wrote:
> > Hi Simon,
> >
> > On Mon, Jun 18, 2012 at 10:12:36PM +0200, Simon Baatz wrote:
> >> On Mon, Jun 18, 2012 at 03:47:18PM +0200, Phil Sutter wrote:
> >>> On Sat, Jun 16, 2012 at 02:20:19AM +0200, Simon Baatz wrote:
> >>>> thanks for providing these patches; it's great to finally see DMA
> >>>> support for CESA in the kernel. Additionally, the implementation seems
> >>>> to be fine regarding cache incoherencies (at least my test in [*]
> >>>> works).
> >>>
> >>> Thanks for testing and the fixes. Could you also specify the platform
> >>> you are testing on?
> >>
> >> This is a Marvell Kirkwood MV88F6281-A1.
> >
> > OK, thanks. Just wanted to be sure it's not already the Orion test I'm
> > hoping for. :)
> >
> 
> OK, here comes the Orion test result - Linkstation Pro with 88F5182 A2. 
> I didn't enable any debug option yet (I don't know what to be enabled in 
> fact). Hope the mv_cesa and mv_dma related kernel messages below could 
> be helpful though:
> 
> ...
> 
> MV-DMA: IDMA engine up and running, IRQ 23
> MV-DMA: idma_print_and_clear_irq: address miss @0!
> MV-DMA: tpg.reg + DMA_CTRL = 0x80001d04
> MV-DMA: tpg.reg + DMA_BYTE_COUNT = 0x80000010
> MV-DMA: tpg.reg + DMA_SRC_ADDR = 0x79b4008
> MV-DMA: tpg.reg + DMA_DST_ADDR = 0xf2200080
> MV-DMA: tpg.reg + DMA_NEXT_DESC = 0x79b1010
> MV-DMA: tpg.reg + DMA_CURR_DESC = 0x79b1000
> MV-DMA: DMA descriptor list:
> MV-DMA: entry 0 at 0xffdbb000: dma addr 0x79b1000, src 0x79b4000, dst 
> 0xf2200080, count 16, own 1, next 0x79b1010
> MV-DMA: entry 1 at 0xffdbb010: dma addr 0x79b1010, src 0x799c28c, dst 
> 0xf2200000, count 80, own 1, next 0x79b1020
> MV-DMA: entry 2 at 0xffdbb020: dma addr 0x79b1020, src 0x0, dst 0x0, 
> count 0, own 0, next 0x79b1030
> MV-DMA: entry 3 at 0xffdbb030: dma addr 0x79b1030, src 0xf2200080, dst 
> 0x79b4000, count 16, own 1, next 0x0
> MV-CESA:got an interrupt but no pending timer?
> alg: skcipher: Test 1 failed on encryption for mv-ecb-aes
> 00000000: 00 11 22 33 44 55 66 77 88 99 aa bb cc dd ee ff
> ...
> 
> MV-CESA:completion timer expired (CESA active), cleaning up.
> MV-CESA:mv_completion_timer_callback: waiting for engine finishing
> MV-CESA:mv_completion_timer_callback: waiting for engine finishing
> 
> Then the console was flooded by the "waiting for engine finshing" 
> message and the boot can't finish.
> 
> I'll be happy to help to debug this. Just tell me how.

OK. IDMA bailing out was more or less expected, but the error path
flooding the log makes me deserve the darwin award. ;)

I suspect address decoding to be the real problem here (kirkwood seems
not to need any setup, so I completely skipped that), at least the IDMA
interrupt cause points that out. OTOH I found out that CESA wasn't
exactly configured as stated in the specs, so could you please test the
attached diff? (Should also sanitise the error case a bit.)

In any case, thanks a lot for your time!



Phil Sutter
Software Engineer

-- 


Viprinet GmbH
Mainzer Str. 43
55411 Bingen am Rhein
Germany

Phone/Zentrale:         +49-6721-49030-0
Direct line/Durchwahl:  +49-6721-49030-134
Fax:                    +49-6721-49030-209

phil.sutter@viprinet.com
http://www.viprinet.com

Registered office/Sitz der Gesellschaft: Bingen am Rhein
Commercial register/Handelsregister: Amtsgericht Mainz HRB40380
CEO/Geschäftsführer: Simon Kissel

--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="cesa_test.diff"

diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index 2a9fe8a..4361dff 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -9,6 +9,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <linux/crypto.h>
+#include <linux/delay.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
 #include <linux/interrupt.h>
@@ -180,6 +181,7 @@ struct mv_req_hash_ctx {
 static void mv_completion_timer_callback(unsigned long unused)
 {
 	int active = readl(cpg->reg + SEC_ACCEL_CMD) & SEC_CMD_EN_SEC_ACCL0;
+	int count = 5;
 
 	printk(KERN_ERR MV_CESA
 	       "completion timer expired (CESA %sactive), cleaning up.\n",
@@ -187,8 +189,12 @@ static void mv_completion_timer_callback(unsigned long unused)
 
 	del_timer(&cpg->completion_timer);
 	writel(SEC_CMD_DISABLE_SEC, cpg->reg + SEC_ACCEL_CMD);
-	while(readl(cpg->reg + SEC_ACCEL_CMD) & SEC_CMD_DISABLE_SEC)
-		printk(KERN_INFO MV_CESA "%s: waiting for engine finishing\n", __func__);
+	while((readl(cpg->reg + SEC_ACCEL_CMD) & SEC_CMD_DISABLE_SEC) && count) {
+		printk(KERN_INFO MV_CESA "%s: waiting for engine finishing (%d)\n",
+				__func__, count--);
+		mdelay(1000);
+	}
+	BUG_ON(!count);
 	cpg->eng_st = ENGINE_W_DEQUEUE;
 	wake_up_process(cpg->queue_th);
 }
@@ -1288,9 +1294,9 @@ static int mv_probe(struct platform_device *pdev)
 		clk_prepare_enable(cp->clk);
 
 	writel(0, cpg->reg + SEC_ACCEL_INT_STATUS);
-	writel(SEC_INT_ACC0_IDMA_DONE, cpg->reg + SEC_ACCEL_INT_MASK);
-	writel((SEC_CFG_STOP_DIG_ERR | SEC_CFG_CH0_W_IDMA | SEC_CFG_MP_CHAIN |
-	        SEC_CFG_ACT_CH0_IDMA), cpg->reg + SEC_ACCEL_CFG);
+	writel(SEC_INT_ACC0_IDMA_DONE | SEC_INT_ACC1_IDMA_DONE, cpg->reg + SEC_ACCEL_INT_MASK);
+	writel((SEC_CFG_STOP_DIG_ERR | SEC_CFG_CH0_W_IDMA | SEC_CFG_CH1_W_IDMA | SEC_CFG_MP_CHAIN |
+	        SEC_CFG_ACT_CH0_IDMA | SEC_CFG_ACT_CH1_IDMA), cpg->reg + SEC_ACCEL_CFG);
 	writel(SRAM_CONFIG, cpg->reg + SEC_ACCEL_DESC_P0);
 
 	cp->sa_sram_dma = dma_map_single(&pdev->dev, &cp->sa_sram,

--RASg3xLB4tUQ4RcS--
