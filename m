From: Sinan Kaya <okaya@codeaurora.org>
Subject: Re: [PATCH 1/3] crypto: marvell/cesa - replace dma_to_phys with
 dma_map_single
Date: Fri, 18 Mar 2016 09:51:37 -0400
Message-ID: <56EC07E9.1000506@codeaurora.org>
References: <1458252137-24497-1-git-send-email-okaya@codeaurora.org>
 <20160317225459.GA19428@n2100.arm.linux.org.uk>
 <80402e2f82651814b1411a25b1740288@codeaurora.org>
 <20160317235020.GB19428@n2100.arm.linux.org.uk>
 <20160318103028.4be15b78@bbrezillon> <56EBE5BC.6000000@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org,
	Herbert Xu <herbert@gondor.apana.org.au>, timur@codeaurora.org,
	Arnaud Ebalard <arno@natisbad.org>,
	linux-kernel@vger.kernel.org, cov@codeaurora.org,
	"David S. Miller" <davem@davemloft.net>, nwatters@codeaurora.org,
	linux-crypto@vger.kernel.org
To: Robin Murphy <robin.murphy@arm.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38616 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbcCRNvl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Mar 2016 09:51:41 -0400
In-Reply-To: <56EBE5BC.6000000@arm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/18/2016 7:25 AM, Robin Murphy wrote:
> On 18/03/16 09:30, Boris Brezillon wrote:
>> On Thu, 17 Mar 2016 23:50:20 +0000
>> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>>
>>> On Thu, Mar 17, 2016 at 07:17:24PM -0400, okaya@codeaurora.org wrote:
>>>> What is the correct way? I don't want to write engine->sram_dma = sram
>>>
>>> Well, what the driver _is_ wanting to do is to go from a CPU physical
>>> address to a device DMA address.  phys_to_dma() looks like the correct
>>> thing there to me, but I guess that's just an offset and doesn't take
>>> account of any IOMMU that may be in the way.
>>>
>>> If you have an IOMMU, then the whole phys_to_dma() thing is a total
>>> failure as it only does a linear translation, and there are no
>>> interfaces in the kernel to take account of an IOMMU in the way.  So,
>>> it needs something designed for the job, implemented and discussed by
>>> the normal methods of proposing a new cross-arch interface for drivers
>>> to use.
>>>
>>> What I'm certain of, though, is that the change proposed in this patch
>>> will break current users of this driver: virt_to_page() on an address
>>> returned by ioremap() is completely undefined, and will result in
>>> either a kernel oops, or if not poking at memory which isn't a struct
>>> page, ultimately resulting in something that isn't SRAM being pointed
>>> to by "engine->sram_dma".
>>>
>>
>> Or we could just do
>>
>>     engine->sram_dma = res->start;
>>
>> which is pretty much what the SRAM/genalloc code is doing already.
> 
> As Russell points out this is yet another type of "set up a DMA master to access something other than kernel RAM" - there's already discussion in progress over how to handle this for dmaengine slaves[1], so gathering more use-cases might help distil exactly what the design of not-strictly-DMA-but-so-closely-coupled-it-can't-really-live-anywhere-else needs to be.
> 
> Robin.
> 
> [1]:http://lists.infradead.org/pipermail/linux-arm-kernel/2016-March/414422.html
> 

Thanks for the link. 

dma_map_resource looks like to be the correct way of doing things. Just from
the purist point of view, a driver is not supposed to know the physical address
of a DMA address. That kills the intent of using DMA API. When programming descriptors,
the DMA addresses should be programmed not physical addresses so that the same 
driver can be used in a system with IOMMU. The IOMMU DMA ops will remap the DMA 
address to a bus address that is not physical address. All of this operation needs
to be isolated from the device driver.


I don't know the architecture or the driver enough to write this. This is not ideally
right but I can do this if Boris you are OK with this. 

     engine->sram_dma = res->start;

Another option is I can write

     engine->sram_dma = swiotlb_dma_to_phys(res->start)

I agree that dma_map_single is not the right thing. 

-- 
Sinan Kaya
Qualcomm Technologies, Inc. on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
