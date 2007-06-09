From: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/3] [CRYPTO] Add optimized SHA-1 implementation for i486+
Date: Sat, 9 Jun 2007 16:34:32 -0500
Message-ID: <20070609213432.GR11115@waste.org>
References: <20070608214242.23949.30350.stgit@dev> <20070608214253.23949.40465.stgit@dev> <20070609201159.GC11166@waste.org> <466B0C3F.3040300@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Benjamin Gilbert <bgilbert@cs.cmu.edu>, akpm@linux-foundation.org,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from waste.org ([66.93.16.53]:35417 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbXFIVfJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jun 2007 17:35:09 -0400
Content-Disposition: inline
In-Reply-To: <466B0C3F.3040300@garzik.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Jun 09, 2007 at 04:23:27PM -0400, Jeff Garzik wrote:
> Matt Mackall wrote:
> >On Fri, Jun 08, 2007 at 05:42:53PM -0400, Benjamin Gilbert wrote:
> >>Add x86-optimized implementation of the SHA-1 hash function, taken from
> >>Nettle under the LGPL.  This code will be enabled on kernels compiled for
> >>486es or better; kernels which support 386es will use the generic
> >>implementation (since we need BSWAP).
> >>
> >>We disable building lib/sha1.o when an optimized implementation is
> >>available, as the library link order for x86 (and x86_64) would otherwise
> >>ignore the optimized version.  The existing optimized implementation for 
> >>ARM
> >>does not do this; the library link order for that architecture appears to
> >>favor the arch/arm/ version automatically.  I've left this situation alone
> >>since I'm not familiar with the ARM code, but a !ARM condition could be
> >>added to CONFIG_SHA1_GENERIC if it makes sense.
> >>
> >>The code has been tested with tcrypt and the NIST test vectors.
> >
> >Have you benchmarked this against lib/sha1.c? Please post the results.
> >Until then, I'm frankly skeptical that your unrolled version is faster
> >because when I introduced lib/sha1.c the rolled version therein won by
> >a significant margin and had 1/10th the cache footprint.
> 
> Yes. And it also depends on the CPU as well.  Testing on a server-class 
> x86 CPU (often with bigger L2, and perhaps even L1, cache) will produce 
> different result than from popular but less-capable "value" CPUs.

In particular, any optimization made for "486+" CPUs is highly suspect
on any machine which runs the core at >1x the memory bus speeds.

-- 
Mathematics is the supreme nostalgia of our time.
