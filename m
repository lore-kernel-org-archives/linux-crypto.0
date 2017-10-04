From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH] iommu/vt-d: Fix scatterlist offset handling
Date: Wed, 4 Oct 2017 12:18:45 +0100
Message-ID: <69e5e981-ab16-39d4-87dd-9c6b2b1c926d@arm.com>
References: <644c3e01654f8bd48d669c36e424959d6ef0e27e.1506607370.git.robin.murphy@arm.com>
 <1507035334.29211.105.camel@infradead.org>
 <db8c70d7-5978-20e8-d29a-91a4312f97dd@arm.com>
 <1507068976.29211.156.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: ashok.raj@intel.com, leedom@chelsio.com, Harsh@chelsio.com,
        herbert@gondor.apana.org.au, iommu@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>, joro@8bytes.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1507068976.29211.156.camel@infradead.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03/10/17 23:16, David Woodhouse wrote:
> On Tue, 2017-10-03 at 19:05 +0100, Robin Murphy wrote:
>>
>> Now, there are indeed plenty of drivers and subsystems which do work on
>> lists of explicitly single pages - anything doing some variant of
>> "addr = kmap_atomic(sg_page(sg)) + sg->offset;" is easy to spot - but I
>> don't think DMA API implementations are in a position to make any kind
>> of assumption; nearly all of them just shut up and handle sg->length
>> bytes from sg_phys(sg) without questioning the caller, and I reckon
>> that's exactly what they should be doing.
> 
> So what's the point in sg->page in the first place? If even the
> *offset* can be greater than page size, it isn't even the *first* page
> (as you called it). Why aren't we just using a physical address,
> instead of an arbitrary page and an offset from that?

To nitpick, "the first of one or more contiguous pages" does not imply
"the first page of the buffer" - the buffer just lies *somewhere* within
that run of pages.

Historically, it looks like page+offset first came about in the 2.5 era
to support highmem[1] - note that scatterlist users still only really
care about virtual and DMA address, not physical. Sure, it wouldn't be
entirely impossible to use phys_addr_t instead, but at this point it
would be a massively invasive change, and would make implementations of
one DMA API callback a tiny bit simpler at the cost of pushing rather
more complexity out to hundreds of other users, some of whom might not
even call dma_map_sg().

The fact is, regardless of how much sense it does or doesn't make, a
fair amount of scatterlist-mangling code exists that is capable of
generating silly offsets, and it's so simple to make sure the DMA API
implementations don't care that I'd rather just keep on top of that than
go off on a crusade in attempt to wipe out the grey areas.

> Can we have *negative* sg->offset too? :)

	unsigned int	offset;

I'm gonna say no ;)

Robin.


[1]:https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/tree/include/asm-i386/scatterlist.h?h=v2.5.0
