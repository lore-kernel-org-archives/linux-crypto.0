From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: crypto: marvell/CESA: Issues with non cache-line aligned
 buffers
Date: Fri, 3 Jul 2015 16:23:22 +0200
Message-ID: <20150703162322.1c02453a@bbrezillon>
References: <20150703114305.15611807@bbrezillon>
	<20150703095807.GS7557@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Will Deacon <will.deacon@arm.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:37603 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755456AbbGCOXb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Jul 2015 10:23:31 -0400
In-Reply-To: <20150703095807.GS7557@n2100.arm.linux.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 3 Jul 2015 10:58:07 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Fri, Jul 03, 2015 at 11:43:05AM +0200, Boris Brezillon wrote:
> > Which led us to think that this could be related to a non cache-line
> > aligned buffer problem: if we share the cache line with someone
> > modifying its data during the DMA transfer, we could experience data
> > loss when the cpu decide to flush the data from this cache line to the
> > memory.
> 
> There's really only two options when you have an overlapping cache line
> and the cache line contains CPU-dirty data, but the memory contains
> DMA-dirty data.  One of those dirty data has to win out, and the other
> has to be destroyed.  (Either you invalidate the CPU cache line, loosing
> the CPU-dirty data, or you write-back the cache line, overwriting the DMA-
> dirty data.)
> 
> What that means is that it's a _bug_ to end up in this situation, nothing
> more, nothing less.  There's nothing that arch code can do about it, it's
> a DMA-API user bug.
> 
> What you'll find is that this is well documented.  See
> Documentation/DMA-API.txt, part Id (Streaming DMA mappings):
> 
>   Warnings:  Memory coherency operates at a granularity called the cache
>   line width.  In order for memory mapped by this API to operate
>   correctly, the mapped region must begin exactly on a cache line
>   boundary and end exactly on one (to prevent two separately mapped
>   regions from sharing a single cache line).  Since the cache line size
>   may not be known at compile time, the API will not enforce this
>   requirement.  Therefore, it is recommended that driver writers who
>   don't take special care to determine the cache line size at run time
>   only map virtual regions that begin and end on page boundaries (which
>   are guaranteed also to be cache line boundaries).
> 
> The behaviour you're seeing here is not ARM specific - any CPU which
> uses cache lines and doesn't have hardware coherency will suffer from
> this problem.
> 

That's pretty much the answer I was expecting :-).
I'll wait for Herbert's feedback to know how this should be fixed (I
guess using the <alg>_walk_xxx functions is the right this to do, but
I'd like to be sure).

Thanks,

Boris

-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
