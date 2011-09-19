From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: Kernel OOPS with Freescale talitos driver on ppc
Date: Mon, 19 Sep 2011 16:20:01 -0500
Message-ID: <20110919162001.e296597e.kim.phillips@freescale.com>
References: <877h544vh6.fsf@begreifnix.stackframe.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Sven Schnelle <svens@stackframe.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:5879
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756495Ab1ISVUu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Sep 2011 17:20:50 -0400
In-Reply-To: <877h544vh6.fsf@begreifnix.stackframe.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 19 Sep 2011 13:33:57 +0200
Sven Schnelle <svens@stackframe.org> wrote:

> Hi Kim,
> 
> i'm seeing the following oops on ppc (Freescale P1020):
> 
> talitos ffe30000.crypto: cur_desc: (channel 1) 00000000
> Unable to handle kernel paging request for data at address 0x00000000

You should have seen the "couldn't locate current descriptor" error
message right before it crashed.

> This happens due to the fact that the SEC engine returns NULL in the
> CDPR register, so current_desc() returns NULL, which gets dereferenced
> in report_eu_error().
> I've fixed that with the attached patch, however, i have no idea why the
> SEC engine doesn't return a descriptor pointer in CDPR. As i understand
> the documentation, it should put the 'currently processed' descriptor
> there. Can someone shed some light on this?

I believe the CDPR may be overwritten by the time the core gets to
it if there is another descriptor queued in the channel's fetch
FIFO.  You may be able to glean more information about what happened
by looking at the ISR execution units done/error bits in isr_lo, the
descriptor buffer (displayed at the end of report_eu_error), or the
EU ISRs themselves (see below).

fwiw, I just booted a vanilla 3.1-rc6 kernel on a p1020 with your
config and CONFIG_CRYPTO_MANAGER_DISABLE_TESTS not set, and the
selftests passed.  IPSec isn't enabled in your config.  Are you
implementing a new algorithm?  If not, how to reproduce?

Kim

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 8a0bb41..568847e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -442,64 +442,55 @@ static void report_eu_error(struct device *dev, int ch,
 			    struct talitos_desc *desc)
 {
 	struct talitos_private *priv = dev_get_drvdata(dev);
+	u32 eu = desc ? desc->hdr : ~0;
 	int i;
 
-	switch (desc->hdr & DESC_HDR_SEL0_MASK) {
+	switch (eu & DESC_HDR_SEL0_MASK) {
 	case DESC_HDR_SEL0_AFEU:
 		dev_err(dev, "AFEUISR 0x%08x_%08x\n",
 			in_be32(priv->reg + TALITOS_AFEUISR),
 			in_be32(priv->reg + TALITOS_AFEUISR_LO));
-		break;
 	case DESC_HDR_SEL0_DEU:
 		dev_err(dev, "DEUISR 0x%08x_%08x\n",
 			in_be32(priv->reg + TALITOS_DEUISR),
 			in_be32(priv->reg + TALITOS_DEUISR_LO));
-		break;
 	case DESC_HDR_SEL0_MDEUA:
 	case DESC_HDR_SEL0_MDEUB:
 		dev_err(dev, "MDEUISR 0x%08x_%08x\n",
 			in_be32(priv->reg + TALITOS_MDEUISR),
 			in_be32(priv->reg + TALITOS_MDEUISR_LO));
-		break;
 	case DESC_HDR_SEL0_RNG:
 		dev_err(dev, "RNGUISR 0x%08x_%08x\n",
 			in_be32(priv->reg + TALITOS_RNGUISR),
 			in_be32(priv->reg + TALITOS_RNGUISR_LO));
-		break;
 	case DESC_HDR_SEL0_PKEU:
 		dev_err(dev, "PKEUISR 0x%08x_%08x\n",
 			in_be32(priv->reg + TALITOS_PKEUISR),
 			in_be32(priv->reg + TALITOS_PKEUISR_LO));
-		break;
 	case DESC_HDR_SEL0_AESU:
 		dev_err(dev, "AESUISR 0x%08x_%08x\n",
 			in_be32(priv->reg + TALITOS_AESUISR),
 			in_be32(priv->reg + TALITOS_AESUISR_LO));
-		break;
 	case DESC_HDR_SEL0_CRCU:
 		dev_err(dev, "CRCUISR 0x%08x_%08x\n",
 			in_be32(priv->reg + TALITOS_CRCUISR),
 			in_be32(priv->reg + TALITOS_CRCUISR_LO));
-		break;
 	case DESC_HDR_SEL0_KEU:
 		dev_err(dev, "KEUISR 0x%08x_%08x\n",
 			in_be32(priv->reg + TALITOS_KEUISR),
 			in_be32(priv->reg + TALITOS_KEUISR_LO));
-		break;
 	}
 
-	switch (desc->hdr & DESC_HDR_SEL1_MASK) {
+	switch (eu & DESC_HDR_SEL1_MASK) {
 	case DESC_HDR_SEL1_MDEUA:
 	case DESC_HDR_SEL1_MDEUB:
 		dev_err(dev, "MDEUISR 0x%08x_%08x\n",
 			in_be32(priv->reg + TALITOS_MDEUISR),
 			in_be32(priv->reg + TALITOS_MDEUISR_LO));
-		break;
 	case DESC_HDR_SEL1_CRCU:
 		dev_err(dev, "CRCUISR 0x%08x_%08x\n",
 			in_be32(priv->reg + TALITOS_CRCUISR),
 			in_be32(priv->reg + TALITOS_CRCUISR_LO));
-		break;
 	}
 
 	for (i = 0; i < 8; i++)
