From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Wed, 19 May 2010 13:50:52 +0200
Message-ID: <AANLkTikZyfxBjXdvNzuVT2N9XIyJmY6JDiKRMRtAykeC@mail.gmail.com>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <1274224834.6930.8361.camel@macbook.infradead.org>
	 <20100519010524.GB18813@gondor.apana.org.au>
	 <1274253269.6930.9325.camel@macbook.infradead.org>
	 <AANLkTimyUoAsculVFkEPwlRQEI3eLAwX5x7M0Yr9AdOs@mail.gmail.com>
	 <1274269236.6930.9930.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
	David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
	mpm@selenic.com, ken@codelabs.ch, michael-dev@fami-braun.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	anemo@mba.ocn.ne.jp
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55899 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021Ab0ESLuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 07:50:55 -0400
In-Reply-To: <1274269236.6930.9930.camel@macbook.infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 19, 2010 at 13:40, David Woodhouse <dwmw2@infradead.org> wr=
ote:
> On Wed, 2010-05-19 at 13:32 +0200, Geert Uytterhoeven wrote:
>> Instead of having (different) defaults in sl[aou]b, perhaps we shoul=
d
>> just remove the defaults completely, to ensure all architectures set
>> ARCH_SLAB_MINALIGN to the correct value?
>
> What is 'correct'? The architecture sets it to the minimum value that=
 it
> can cope with, according to its own alignment constraints (and DMA/ca=
che
> constraints, in the case of ARCH_KMALLOC_MINALIGN).
>
> Some architectures don't _have_ any minimum required alignment, so th=
ey
> have no need to set it. If the architecture _does_ specify a minimum,
> the allocators must honour it. Otherwise, they're free to do their ow=
n
> thing. And slob chooses to use a smaller alignment than slab and slub
> do, in accordance with its design and its raison d'=C3=AAtre.

Currently 7 out of 20+ architectures set it.
Any bets on how many are missing, but should set it?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-=
m68k.org

In personal conversations with technical people, I call myself a hacker=
=2E But
when I'm talking to journalists I just say "programmer" or something li=
ke that.
							    -- Linus Torvalds
