From: David Woodhouse <dwmw2@infradead.org>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Wed, 19 May 2010 12:16:45 +0100
Message-ID: <1274267805.6930.9877.camel@macbook.infradead.org>
References: <1274211235.11603.1205.camel@calx>
	 <20100518.135945.180391159.davem@davemloft.net>
	 <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com>
	 <20100518.142021.135951273.davem@davemloft.net>
	 <1274224834.6930.8361.camel@macbook.infradead.org>
	 <20100519010524.GB18813@gondor.apana.org.au>
	 <1274266725.6930.9823.camel@macbook.infradead.org>
	 <AANLkTikLhmQ2oYnYS2KblEayg6x1ZAmUnBvYfNu0yFh9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>, mpm@selenic.com,
	ken@codelabs.ch, geert@linux-m68k.org, michael-dev@fami-braun.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	anemo@mba.ocn.ne.jp
To: Pekka Enberg <penberg@cs.helsinki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:47164 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab0ESLQz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 07:16:55 -0400
In-Reply-To: <AANLkTikLhmQ2oYnYS2KblEayg6x1ZAmUnBvYfNu0yFh9@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2010-05-19 at 14:08 +0300, Pekka Enberg wrote:
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> Are you sending the patches to Linus or do you want me to pull them in
> slab.git? 

I don't mind. Feel free to apply them to slab.git, but be aware that
Herbert wanted to see a patch fixing sparc32 ARCH_SLAB_MINALIGN before
the crypto one is applied.

Although arguably SLOB was broken on sparc32 even before the crypto
patch -- so perhaps that fix shouldn't _have_ to go in first?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation
