From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 3/4] fsl-dma: support attribute of DMA_MEMORY when
 async_tx enabled
Date: Tue, 10 Jul 2012 12:39:29 -0700
Message-ID: <CABE8wws80A3ne7ay+i5+WeuAnZcwLQoyM4RC7B8UMoHJknGLSQ@mail.gmail.com>
References: <1341899997-20879-1-git-send-email-qiang.liu@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	leoli@freescale.com, kim.phillips@freescale.com,
	Vinod Koul <vinod.koul@intel.com>
To: Qiang Liu <qiang.liu@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:51455 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751987Ab2GJTjb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Jul 2012 15:39:31 -0400
Received: by qabj34 with SMTP id j34so447368qab.4
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jul 2012 12:39:30 -0700 (PDT)
In-Reply-To: <1341899997-20879-1-git-send-email-qiang.liu@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jul 9, 2012 at 10:59 PM, Qiang Liu <qiang.liu@freescale.com> wrote:
> - delete attribute of DMA_INTERRUPT because fsl-dma doesn't support
> this function, exception will be thrown if talitos is used to compute xor
> at the same time;
> - change the release process of dma descriptor for avoiding exception when
> enable config NET_DMA, release dma descriptor from 1st to last second, the
> last descriptor which is reserved in current descriptor register may not be
> completed, race condition will be raised if free current descriptor;
> - use spin_lock_bh to instead of spin_lock_irqsave for improving performance;
>
> A race condition which is raised when use both of talitos and dmaengine to
> offload xor is because napi scheduler will sync all pending requests in dma
> channels, it will affect the process of raid operations. The descriptor is
> freed which is submitted just now, but async_tx must check whether this depend
> tx descriptor is acked, there are poison contents in the invalid address,
> then BUG_ON() is thrown, so this descriptor will be freed in the next time.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Li Yang <leoli@freescale.com>
> Signed-off-by: Qiang Liu <qiang.liu@freescale.com>
> ---

>From the description this sounds like 3 or 4 patches.  Can you split it up?
