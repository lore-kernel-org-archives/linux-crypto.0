From: Phil Sutter <phil.sutter@viprinet.com>
Subject: Re: [PATCH 0/2] Fixes for MV_CESA with IDMA or TDMA
Date: Mon, 25 Jun 2012 23:59:28 +0200
Message-ID: <20120625215928.GA3853@philter.vipri.net>
References: <1339521447-17721-1-git-send-email-phil.sutter@viprinet.com>
 <1339806021-14271-1-git-send-email-gmbnomis@gmail.com>
 <20120618134718.GL9122@philter.vipri.net>
 <20120618201235.GA20755@schnuecks.de>
 <4FE1D09E.4040104@gmail.com>
 <20120620154131.GR9122@philter.vipri.net>
 <20120625134050.GB12294@philter.vipri.net>
 <4FE874BD.2020909@gmail.com>
 <4FE88C63.8010103@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org, andrew@lunn.ch,
	Simon Baatz <gmbnomis@gmail.com>
To: "cloudy.linux" <cloudy.linux@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from zimbra.vipri.net ([89.207.250.15]:55764 "EHLO zimbra.vipri.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751791Ab2FYV7i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jun 2012 17:59:38 -0400
Content-Disposition: inline
In-Reply-To: <4FE88C63.8010103@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi,

On Tue, Jun 26, 2012 at 12:05:55AM +0800, cloudy.linux wrote:
> This time the machine can't finish the boot again and the console was 
> flooded by the message like below:

Oh well. I decided to drop that BUG_ON() again, since I saw it once
being triggered while in interrupt context. But since the error is
non-recovering anyway, I guess it may stay there as well.

> Also, I had to make some modifications to the 
> arch/arm/mach-orion5x/common.c to let it compile successfully:
> 1 Add including of mv_dma.h
> 2 Add macro to define TARGET_SRAM as 9 (which is defined in addr-map.c, 
> so I think the clean solution should be modify the addr-map.h? Anyway, 
> as a quick solution the source finally got compiled)

Hmm, yeah. Test-compiling for the platform one is writing code for is
still a good idea. But it's even worse than that: according to the
specs, for IDMA the SRAM target ID is 5, not 9 like it is for the CPU.

Please apply the attached patch on top of the one I sent earlier,
without your modifications (the necessary parts are contained in it).
Also, I've added some log output to the decode window setter, so we see
what's going on there.

Anyway, thanks a lot for your help so far! I hope next try shows some
progress at least.

Greetings, Phil


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

--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="mv_dma_fixup.diff"

diff --git a/arch/arm/mach-orion5x/common.c b/arch/arm/mach-orion5x/common.c
index 4734231..45450af 100644
--- a/arch/arm/mach-orion5x/common.c
+++ b/arch/arm/mach-orion5x/common.c
@@ -35,6 +35,7 @@
 #include <plat/time.h>
 #include <plat/common.h>
 #include <plat/addr-map.h>
+#include <plat/mv_dma.h>
 #include "common.h"
 
 /*****************************************************************************
@@ -203,7 +204,7 @@ static struct resource orion_idma_res[] = {
 static u64 mv_idma_dma_mask = DMA_BIT_MASK(32);
 
 static struct mv_dma_pdata mv_idma_pdata = {
-	.sram_target_id	= TARGET_SRAM,
+	.sram_target_id	= 5,
 	.sram_attr	= 0,
 	.sram_base	= ORION5X_SRAM_PHYS_BASE,
 };
diff --git a/drivers/crypto/mv_cesa.c b/drivers/crypto/mv_cesa.c
index b75fdf5..4f48c63 100644
--- a/drivers/crypto/mv_cesa.c
+++ b/drivers/crypto/mv_cesa.c
@@ -195,6 +195,7 @@ static void mv_completion_timer_callback(unsigned long unused)
 	if (count < 0) {
 		printk(KERN_ERR MV_CESA
 		       "%s: engine reset timed out!\n", __func__);
+		BUG();
 	}
 	cpg->eng_st = ENGINE_W_DEQUEUE;
 	wake_up_process(cpg->queue_th);
diff --git a/drivers/crypto/mv_dma.c b/drivers/crypto/mv_dma.c
index dd1ce02..176976e 100644
--- a/drivers/crypto/mv_dma.c
+++ b/drivers/crypto/mv_dma.c
@@ -318,6 +318,8 @@ static void setup_mbus_windows(void __iomem *regs, struct mv_dma_pdata *pdata,
 	for (chan = 0; chan < dram->num_cs; chan++) {
 		const struct mbus_dram_window *cs = &dram->cs[chan];
 
+		printk(KERN_INFO MV_DMA "window at bar%d: target %d, attr %d, base %x, size %x\n",
+				chan, dram->mbus_dram_target_id, cs->mbus_attr, cs->base, cs->size);
 		(*win_setter)(regs, chan, dram->mbus_dram_target_id,
 				cs->mbus_attr, cs->base, cs->size);
 	}
@@ -330,6 +332,8 @@ static void setup_mbus_windows(void __iomem *regs, struct mv_dma_pdata *pdata,
 		 * Size is in 64k granularity, max SRAM size is 8k -
 		 * so a single "unit" easily suffices.
 		 */
+		printk(KERN_INFO MV_DMA "window at bar%d: target %d, attr %d, base %x, size %x\n",
+				chan, pdata->sram_target_id, pdata->sram_attr, pdata->sram_base, 1 << 16);
 		(*win_setter)(regs, chan, pdata->sram_target_id,
 				pdata->sram_attr, pdata->sram_base, 1 << 16);
 	}

--17pEHd4RhPHOinZp--
