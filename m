From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Tue, 3 Oct 2017 19:05:17 +0100
Message-ID: <db8c70d7-5978-20e8-d29a-91a4312f97dd@arm.com>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
 <1507035334.29211.105.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: ashok.raj@intel.com, leedom@chelsio.com, Harsh@chelsio.com,
        herbert@gondor.apana.org.au, iommu@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>, joro@8bytes.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:52282 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750812AbdJCSFV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 14:05:21 -0400
In-Reply-To: <1507035334.29211.105.camel@infradead.org>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/10/17 13:55, David Woodhouse wrote:
> On Thu, 2017-09-28 at 15:14 +0100, Robin Murphy wrote:
>> The intel-iommu DMA ops fail to correctly handle scatterlists where
>> sg->offset is greater than PAGE_SIZE - the IOVA allocation is computed
>> appropriately based on the page-aligned portion of the offset, but the
>> mapping is set up relative to sg->page, which means it fails to actually
>> cover the whole buffer (and in the worst case doesn't cover it at all):
>>
>>     (sg->dma_address + sg->dma_len) ----+
>>     sg->dma_address ---------+          |
>>     iov_pfn------+           |          |
>>                  |           |          |
>>                  v           v          v
>> iova:   a        b        c        d        e        f
>>         |--------|--------|--------|--------|--------|
>>                           <...calculated....>
>>                  [_____mapped______]
>> pfn:    0        1        2        3        4        5
>>         |--------|--------|--------|--------|--------|
>>                  ^           ^          ^
>>                  |           |          |
>>     sg->page ----+           |          |
>>     sg->offset --------------+          |
>>     (sg->offset + sg->length) ----------+
> 
> I'd still dearly love to see some clear documentation of what it means
> for sg->offset to be outside the page referenced by sg->page.

I think the key is that for each SG segment, sg->page doesn't
necessarily represent "a" page, but the first of one or more contiguous
pages. Disregarding offsets for the moment, Here's a typical example of
a 120KB buffer from the block layer as processed by iommu_dma_map_sg():

[   16.092649] == initial (4) ==
[   16.095591]  0: virt ffff800001372000	phys 0x0000000081372000	dma 0x0000000000000000
[   16.095591] 		offset 0x00000000	length 0x0000e000	dma_len 0x00000000
[   16.109541]  1: virt ffff800001380000	phys 0x0000000081380000	dma 0x0000000000000000
[   16.109541] 		offset 0x00000000	length 0x0000d000	dma_len 0x00000000
[   16.123491]  2: virt ffff80000138e000	phys 0x000000008138e000	dma 0x0000000000000000
[   16.123491] 		offset 0x00000000	length 0x00002000	dma_len 0x00000000
[   16.137440]  3: virt ffff800001390000	phys 0x0000000081390000	dma 0x0000000000000000
[   16.137440] 		offset 0x00000000	length 0x00001000	dma_len 0x00000000
[   16.216167] == final   (2) ==
[   16.219106]  0: virt ffff800001372000	phys 0x0000000081372000	dma 0x00000000ffb60000
[   16.219106] 		offset 0x00000000	length 0x0000e000	dma_len 0x0000e000
[   16.233056]  1: virt ffff800001380000	phys 0x0000000081380000	dma 0x00000000ffb70000
[   16.233056] 		offset 0x00000000	length 0x0000d000	dma_len 0x00010000

i.e. segments of 14 pages, 13 pages, 2 pages and 1 page respectively
(and we further merge the resulting DMA-contiguous segments on top of
that).

Now, there are indeed plenty of drivers and subsystems which do work on
lists of explicitly single pages - anything doing some variant of
"addr = kmap_atomic(sg_page(sg)) + sg->offset;" is easy to spot - but I
don't think DMA API implementations are in a position to make any kind
of assumption; nearly all of them just shut up and handle sg->length
bytes from sg_phys(sg) without questioning the caller, and I reckon
that's exactly what they should be doing.

> Or is it really not "outside", and it's *only* valid for the offset to
> be > PAGE_OFFSET when it's a huge page, so we can check that with a
> BUG_ON() ? 
> 
> In particular, I'd like to know what is intended in the Xen PV case,
> where there isn't a straight correspondence between pfn and mfn. Is the
> out-of-range sg->offset intended to refer to the next *pfn* after sg-
>> page, or to the next *mfn* after sg->page? 

Logically, it should mean the same thing as whatever a length of more
than 1 page means to Xen - judging by blkif_queue_rw_req() at least,
that seems to be a BUG_ON() in both cases.

> I confess I've only followed this thread vaguely, but I haven't seen a
> *coherent* explanation except in the huge page case (in which case I
> want to see that BUG_ON in the patch) of why this isn't just totally
> bogus.

As I've said before, I'd certainly consider it a denormalised case, but
not a bogus one, and certainly not something that is the DMA API's job
to police. Having now audited every dma_map_ops::map_sg implementation I
could find, the only ones not using sg_phys()/sg_virt() or some other
construction immune to the absolute offset value (MIPS even explicitly
normalises it) are intel-iommu and arch/frv, and the latter is clearly
broken anyway as it ignores sg->length.

Robin.
