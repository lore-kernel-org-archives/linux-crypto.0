From: Marc St-Jean <Marc_St-Jean@pmc-sierra.com>
Subject: Re: [PATCH 12/12] drivers: PMC MSP71xx security engine driver
Date: Fri, 15 Jun 2007 12:38:29 -0700
Message-ID: <4672EAB5.3000903@pmc-sierra.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="koi8-r"
Cc: Marc St-Jean <stjeanma@pmc-sierra.com>, davem@davemloft.net,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-mips@linux-mips.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from father.pmc-sierra.com ([216.241.224.13]:33635 "HELO
	father.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751577AbXFOTjK (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Jun 2007 15:39:10 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Evgeniy Polyakov wrote:
> Hi Marc.
> 
> On Thu, Jun 14, 2007 at 04:12:53PM -0600, Marc St-Jean 
> (stjeanma@pmc-sierra.com) wrote:
>  > [PATCH 12/12] drivers: PMC MSP71xx security engine driver
>  >
>  > Patch to add an security engien driver for the PMC-Sierra MSP71xx 
> devices.
> 
> Does this board have SMP config or can this adapter be found in SMP
> systems, since you only protect against interrupts, but not
> simultaneous SMP access to the engine.

It has been uni-processing only but SMP support is planned soon.

> 
> And as a minor nit: there is no check for dma_alloc_coherent() return 
> value.

I will look into it.

Thanks,
Marc
