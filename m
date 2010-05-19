From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Wed, 19 May 2010 21:02:49 +0900
Message-ID: <20100519210506U.fujita.tomonori@lab.ntt.co.jp>
References: <1274253269.6930.9325.camel@macbook.infradead.org>
	<AANLkTimyUoAsculVFkEPwlRQEI3eLAwX5x7M0Yr9AdOs@mail.gmail.com>
	<1274269236.6930.9930.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: geert@linux-m68k.org, herbert@gondor.hengli.com.au,
	davem@davemloft.net, penberg@cs.helsinki.fi, mpm@selenic.com,
	ken@codelabs.ch, michael-dev@fami-braun.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	anemo@mba.ocn.ne.jp
To: dwmw2@infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:48801 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab0ESMHr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 08:07:47 -0400
In-Reply-To: <1274269236.6930.9930.camel@macbook.infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 19 May 2010 12:40:36 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Wed, 2010-05-19 at 13:32 +0200, Geert Uytterhoeven wrote:
> > Instead of having (different) defaults in sl[aou]b, perhaps we should
> > just remove the defaults completely, to ensure all architectures set
> > ARCH_SLAB_MINALIGN to the correct value? 
> 
> What is 'correct'? The architecture sets it to the minimum value that it
> can cope with, according to its own alignment constraints (and DMA/cache
> constraints, in the case of ARCH_KMALLOC_MINALIGN).

IIRC, not all the architectures do that; ARCH_KMALLOC_MINALIGN doesn't
mean "DMA-safe" alignment currently.
