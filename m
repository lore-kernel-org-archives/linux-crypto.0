From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Wed, 19 May 2010 17:45:50 +1000
Message-ID: <20100519074550.GA23863@gondor.apana.org.au>
References: <1274211235.11603.1205.camel@calx> <20100518.135945.180391159.davem@davemloft.net> <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com> <20100518.142021.135951273.davem@davemloft.net> <1274224834.6930.8361.camel@macbook.infradead.org> <20100519010524.GB18813@gondor.apana.org.au> <1274253269.6930.9325.camel@macbook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, penberg@cs.helsinki.fi,
	mpm@selenic.com, ken@codelabs.ch, geert@linux-m68k.org,
	michael-dev@fami-braun.de, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, anemo@mba.ocn.ne.jp
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:43058 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751353Ab0ESHq1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 03:46:27 -0400
Content-Disposition: inline
In-Reply-To: <1274253269.6930.9325.camel@macbook.infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 19, 2010 at 08:14:28AM +0100, David Woodhouse wrote:
>
> Yeah, but that's what ARCH_SLAB_MINALIGN is for.
> 
> ARM gets this right, and Dave has already said he's going to fix sparc.

Right, once that gets in I will fix crypto.h so that it'll work
correctly with SLOB.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
