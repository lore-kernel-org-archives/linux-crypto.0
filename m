From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Wed, 19 May 2010 15:54:43 +0300
Message-ID: <AANLkTiky-saTpv6Vq2ipIWC39b5eox92qQGE0QcACEBR@mail.gmail.com>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <1274224834.6930.8361.camel@macbook.infradead.org>
	 <20100519010524.GB18813@gondor.apana.org.au>
	 <1274266725.6930.9823.camel@macbook.infradead.org>
	 <AANLkTikLhmQ2oYnYS2KblEayg6x1ZAmUnBvYfNu0yFh9@mail.gmail.com>
	 <1274267805.6930.9877.camel@macbook.infradead.org>
	 <20100519114609.GA26610@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Woodhouse <dwmw2@infradead.org>,
	David Miller <davem@davemloft.net>, mpm@selenic.com,
	ken@codelabs.ch, geert@linux-m68k.org, michael-dev@fami-braun.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	anemo@mba.ocn.ne.jp
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42525 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab0ESMyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 08:54:45 -0400
In-Reply-To: <20100519114609.GA26610@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 19, 2010 at 2:46 PM, Herbert Xu <herbert@gondor.apana.org.a=
u> wrote:
> On Wed, May 19, 2010 at 12:16:45PM +0100, David Woodhouse wrote:
>>
>> I don't mind. Feel free to apply them to slab.git, but be aware that
>> Herbert wanted to see a patch fixing sparc32 ARCH_SLAB_MINALIGN befo=
re
>> the crypto one is applied.
>>
>> Although arguably SLOB was broken on sparc32 even before the crypto
>> patch -- so perhaps that fix shouldn't _have_ to go in first?
>
> Well prior to this crypto on sparc32 did work with SLAB/SLUB. =A0If
> you change it without including the sparc pach, then sparc32 would
> be broken regardless of which allocator you used.

OK, I'll pick up David's patches and just wait for sparc changes to
hit Linus' tree first. Herbert, do I have your ACK for the crypto
patches?
