From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Wed, 19 May 2010 08:44:43 +0300
Message-ID: <AANLkTimjyRdzK3gXptoheWQGEdzdQlJjSdpCTXSbGseV@mail.gmail.com>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: mpm@selenic.com, herbert@gondor.apana.org.au, ken@codelabs.ch,
	geert@linux-m68k.org, michael-dev@fami-braun.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	anemo@mba.ocn.ne.jp
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64799 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab0ESFor convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 01:44:47 -0400
In-Reply-To: <20100518.142021.135951273.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David,

On Wed, May 19, 2010 at 12:20 AM, David Miller <davem@davemloft.net> wr=
ote:
>> Why? It doesn't make much sense for SLOB, which tries to be as space
>> efficient as possible, as a default. If things break on sparc, it
>> really needs to set ARCH_KMALLOC_MINALIGN as slab default alignment =
is
>> not something you really want to depend on.
>
> I think it does make sense to expect that, whatever my architecture
> defines or does not define, I can expect the allocators to provide th=
e
> same minimum alignment guarentee. =A0Otherwise it is no guarantee at =
all.

They're not a guarantee, the default values are just "oh, you don't
care about alignment, let me provide one for you".

> I'll add the define for sparc, but saying "sparc's fault" is bogus
> because I defined what was necessary to get SLAB/SLUB to provide the
> necessary alignment. =A0SLOB pays for choosing not to use the same
> calculations for minimum alignment as the other allocators, and
> therefore pays for being different in this regard.
>
> And in fact I do know that the ifdef'ery in SLAB/SLUB is derived from
> a change long ago that was specifically added to handle platforms lik=
e
> sparc.
>
> So one of two things should happen:
>
> 1) SLOB conforms to SLAB/SLUB in it's test
>
> 2) SLAB/SLUB conforms to SLOB in it's test
>
> And yes this is an either-or, you can't say they are both valid.

I don't agree with that. The default values are subject to change and
as pointed out by Paul, they have done so in the past. If you
architecture has alignment requirements for _correctness_ you
absolutely need to define ARCH_KMALLOC_MINALIGN.

                         Pekka
