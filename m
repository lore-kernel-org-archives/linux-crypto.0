From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [linuxppc-release] [PATCH v3 4/4] fsl-dma: use spin_lock_bh to
 instead of spin_lock_irqsave
Date: Tue, 17 Jul 2012 04:23:22 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C2788@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1342411780-29930-1-git-send-email-qiang.liu@freescale.com>
 <5004244D.4000106@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
	Vinod Koul <vinod.koul@intel.com>,
	"herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
	Dan Williams <dan.j.williams@intel.com>,
	Li Yang-R58472 <r58472@freescale.com>,
	"davem@davemloft.net" <davem@davemloft.net>
To: Tabi Timur-B04825 <B04825@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:4844
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab2GQEX1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Jul 2012 00:23:27 -0400
In-Reply-To: <5004244D.4000106@freescale.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> -----Original Message-----
> From: Tabi Timur-B04825
> Sent: Monday, July 16, 2012 10:25 PM
> To: Liu Qiang-B32616
> Cc: linux-crypto@vger.kernel.org; linuxppc-dev@lists.ozlabs.org; Vinod
> Koul; herbert@gondor.hengli.com.au; Dan Williams; Li Yang-R58472;
> davem@davemloft.net
> Subject: Re: [linuxppc-release] [PATCH v3 4/4] fsl-dma: use spin_lock_bh
> to instead of spin_lock_irqsave
> 
> Qiang Liu wrote:
> > Use spin_lock_bh to instead of spin_lock_irqsave for improving
> performance.
> 
> You forgot to include the evidence that performance has improved, as well
> as an explanation why it's okay to use spin_lock_bh, and why it's faster.
>   I told you to respin the patch with that information in the patch
> description.
I attached the test result in v3 0/4, performance is improved by 2%.
For my understanding, there is not any place to access descriptor lists
in fsl-dma interrupt service handler except its tasklet, spin_lock_bh()
is born for this. Interrupts will be turned off and context will be save in
irqsave, there is needless to use irqsave in our case. You can refer to the
implement of mv_xor.c or ioap-adma.c.
If you think my explanation is ok, I can add it in the patch.
Thanks.

> 
> --
> Timur Tabi
> Linux kernel developer at Freescale
