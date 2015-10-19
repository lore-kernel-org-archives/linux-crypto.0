From: arno@natisbad.org (Arnaud Ebalard)
Subject: Re: [PATCH 0/6] Sparse related fixes
Date: Tue, 20 Oct 2015 01:29:56 +0200
Message-ID: <87k2qicu8b.fsf@natisbad.org>
References: <20151009102904.GL32532@n2100.arm.linux.org.uk>
	<20151009104637.GA18798@n2100.arm.linux.org.uk>
	<20151009194309.GA7401@n2100.arm.linux.org.uk>
	<20151018161649.GA6651@n2100.arm.linux.org.uk>
	<20151018173039.GA9737@n2100.arm.linux.org.uk>
	<20151018194943.21a63743@bbrezillon>
Mime-Version: 1.0
Content-Type: text/plain
Cc: "David S. Miller" <davem@davemloft.net>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Jason Cooper <jason@lakedaemon.net>,
	linux-crypto@vger.kernel.org,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 36.223.133.77.rev.sfr.net ([77.133.223.36]:59747 "EHLO
	smtp.natisbad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbbJSXaR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Oct 2015 19:30:17 -0400
In-Reply-To: <20151018194943.21a63743@bbrezillon> (Boris Brezillon's message
	of "Sun, 18 Oct 2015 19:49:43 +0200")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Boris Brezillon <boris.brezillon@free-electrons.com> writes:

> On Sun, 18 Oct 2015 18:30:39 +0100
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>
>> Continuing on from the previous set of 18 patches, I also fixed a
>> number of sparse problems and other cleanups.  I don't deem these
>> suitable for -rc merging, especially now that we're basically at
>> -rc6.
>> 
>> The first patch switches the driver over to appropriately using
>> the relaxed IO accessors - this avoids calling out to the heavy
>> barrier on every read and write operation, but only calling out on
>> those which really matter.
>> 
>> We switch to using dma_addr_t for DMA addresses which are not accessed
>> by hardware, and using gfp_t for the get_free_page flags.  String-based
>> MMIO accesses are used instead of plain memcpy()/memset() which prevents
>> us potentially stumbling over GCC optimisations that it thinks it may
>> make with these functions.
>> 
>> We convert as much of the hardware state to __le32 endian markings,
>> and use cpu_to_le32() as appropriate.  A number of places are left
>> unfixed, as we temporarily store CPU native endian values at these
>> locations; these warnings should not be fixed (basically, only
>> appropriate sparse warnings should be fixed without penalising code.)
>
> To the whole series:
>
> Acked-by: Boris Brezillon <boris.brezillon@free-electrons.com>

Same here:

Acked-by: Arnaud Ebalard <arno@natisbad.org>
