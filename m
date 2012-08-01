From: Liu Qiang-B32616 <B32616@freescale.com>
Subject: RE: [PATCH 0/7] fsl-dma: fixes for Freescale DMA driver
Date: Wed, 1 Aug 2012 03:47:00 +0000
Message-ID: <BCB48C05FCE8BC4D9E61E841ECBE6DB70C625B@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1343778352-5549-1-git-send-email-iws@ovro.caltech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
To: "Ira W. Snyder" <iws@ovro.caltech.edu>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:5002
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754294Ab2HADrG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 Jul 2012 23:47:06 -0400
In-Reply-To: <1343778352-5549-1-git-send-email-iws@ovro.caltech.edu>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Ira,

My comments inline.

> -----Original Message-----
> From: Ira W. Snyder [mailto:iws@ovro.caltech.edu]
> Sent: Wednesday, August 01, 2012 7:46 AM
> To: linux-crypto@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org; Liu Qiang-B32616; Ira W. Snyder
> Subject: [PATCH 0/7] fsl-dma: fixes for Freescale DMA driver
> 
> From: "Ira W. Snyder" <iws@ovro.caltech.edu>
> 
> Hello everyone,
> 
> This is my alternative (simpler) attempt at solving the problems reported
> by Qiang Liu with the async_tx API and MD RAID hardware offload support
> when using the Freescale DMA driver.
> 
> The bug is caused by this driver freeing descriptors before they have
> been ACKed by software using the async_tx API.
> 
> I don't like Qiang Liu's code to check where the hardware is in the
> processing of the descriptor chain, and try to free a partial list of
> descriptors. This was a source of bugs in this driver before I fixed them
> several years ago.
It's a bug which you think the whole list is completed when an interrupt is raised, there is a potential risk when an interrupt is raised by "Programmed Error". The "ld_running" is a s/w concept, we should not depend on it to judge the status of descriptors list.

I know you don't like this process, but it's a safe and common process. You can refer to other dma drivers, like ioap-adma, mv-xor and ibm-ppc440x-adma.
Said far point, usb also take this method to judge which descriptor is completed, I don't know which device can use a s/w list to free all descriptors, you can refer to the implement of dl_reverse_done_list().

If you find any problem in my patch, please point out, or you can give a link about the bug you mentioned many years ago.

Thanks.


> 
> Instead, the DMA controller raises an interrupt every time it has
> completed a descriptor chain. This means it is ready for new descriptors:
> no need to try and figure out where it is in the middle of a descriptor
> chain.
Attached again,
The interrupt is only report the state of hardware, we cannot assume all descriptors are finished when an interrupt is raised.

> 
> Qiang Liu: I do not have a hardware setup capable of using MD RAID.
> Please test these patches to see if they fix the bug you reported. You
> may use these patches as-is, or build upon them.
I hope we can discuss it based on my patch. If you think my patch will involve some issue, please point out. I'm willing to fix it.
Thanks.

> 
> I have tested this using the drivers/dma/dmatest.c driver, as well as the
> CARMA drivers. There are no regressions that I can find.
> 
> [  355.069679] dma0chan3-copy0: terminating after 100000 tests, 0
> failures (status 0) [  355.192278] dma0chan2-copy0: terminating after
> 100000 tests, 0 failures (status 0)
> 
> Ira W. Snyder (5):
>   fsl-dma: minimize locking overhead
>   fsl-dma: add fsl_dma_free_descriptor() to reduce code duplication
>   fsl-dma: move functions to avoid forward declarations
>   fsl-dma: fix support for async_tx API
>   carma: remove unnecessary DMA_INTERRUPT capability
> 
> Qiang Liu (2):
>   fsl-dma: remove attribute DMA_INTERRUPT of dmaengine
>   fsl-dma: fix a warning of unitialized cookie
> 
>  drivers/dma/fsldma.c                    |  318 +++++++++++++++----------
> ------
>  drivers/dma/fsldma.h                    |    1 +
>  drivers/misc/carma/carma-fpga-program.c |    1 -
>  drivers/misc/carma/carma-fpga.c         |    3 +-
>  4 files changed, 159 insertions(+), 164 deletions(-)
> 
> --
> 1.7.8.6
> 
