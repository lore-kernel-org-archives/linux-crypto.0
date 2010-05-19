From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Wed, 19 May 2010 14:09:46 +1000
Message-ID: <20100519040946.GA21422@gondor.apana.org.au>
References: <1274211235.11603.1205.camel@calx> <20100518.135945.180391159.davem@davemloft.net> <AANLkTik3tKpPvilnWV6eVIm5_rUPeuCzXBDwmnZl9N6o@mail.gmail.com> <20100518.142021.135951273.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: penberg@cs.helsinki.fi, mpm@selenic.com, ken@codelabs.ch,
	geert@linux-m68k.org, michael-dev@fami-braun.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	anemo@mba.ocn.ne.jp
To: David Miller <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([216.59.3.182]:37089 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702Ab0ESEKT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 May 2010 00:10:19 -0400
Content-Disposition: inline
In-Reply-To: <20100518.142021.135951273.davem@davemloft.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, May 18, 2010 at 02:20:21PM -0700, David Miller wrote:
> 
> I'll add the define for sparc, but saying "sparc's fault" is bogus
> because I defined what was necessary to get SLAB/SLUB to provide the
> necessary alignment.  SLOB pays for choosing not to use the same
> calculations for minimum alignment as the other allocators, and
> therefore pays for being different in this regard.

Once that macro hits the main tree I'll push the crypto fix out.

Thanks!
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
