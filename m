From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Date: Sat, 09 Jun 2007 16:23:27 -0400
Message-ID: <466B0C3F.3040300@garzik.org>
References: <20070608214242.23949.30350.stgit@dev> <20070608214253.23949.40465.stgit@dev> <20070609201159.GC11166@waste.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Benjamin Gilbert <bgilbert@cs.cmu.edu>, akpm@linux-foundation.org,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Matt Mackall <mpm@selenic.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:34672 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759347AbXFIUXk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jun 2007 16:23:40 -0400
In-Reply-To: <20070609201159.GC11166@waste.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Matt Mackall wrote:
> On Fri, Jun 08, 2007 at 05:42:53PM -0400, Benjamin Gilbert wrote:
>> Add x86-optimized implementation of the SHA-1 hash function, taken from
>> Nettle under the LGPL.  This code will be enabled on kernels compiled for
>> 486es or better; kernels which support 386es will use the generic
>> implementation (since we need BSWAP).
>>
>> We disable building lib/sha1.o when an optimized implementation is
>> available, as the library link order for x86 (and x86_64) would otherwise
>> ignore the optimized version.  The existing optimized implementation for ARM
>> does not do this; the library link order for that architecture appears to
>> favor the arch/arm/ version automatically.  I've left this situation alone
>> since I'm not familiar with the ARM code, but a !ARM condition could be
>> added to CONFIG_SHA1_GENERIC if it makes sense.
>>
>> The code has been tested with tcrypt and the NIST test vectors.
> 
> Have you benchmarked this against lib/sha1.c? Please post the results.
> Until then, I'm frankly skeptical that your unrolled version is faster
> because when I introduced lib/sha1.c the rolled version therein won by
> a significant margin and had 1/10th the cache footprint.

Yes. And it also depends on the CPU as well.  Testing on a server-class 
x86 CPU (often with bigger L2, and perhaps even L1, cache) will produce 
different result than from popular but less-capable "value" CPUs.

	Jeff
