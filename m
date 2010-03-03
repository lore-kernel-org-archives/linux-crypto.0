From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: tip: origin tree boot crash
Date: Wed, 3 Mar 2010 22:42:40 +0800
Message-ID: <20100303144240.GA14373@gondor.apana.org.au>
References: <20081225001724.GA2813@gondor.apana.org.au> <20081225002020.GA2912@gondor.apana.org.au> <20090324044932.GA18245@gondor.apana.org.au> <20091204135530.GA29371@gondor.apana.org.au> <20100226004914.GA20812@gondor.apana.org.au> <20100301075024.GA4753@elte.hu> <20100301145519.GB20729@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:54388 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754424Ab0CCOnF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Mar 2010 09:43:05 -0500
Content-Disposition: inline
In-Reply-To: <20100301145519.GB20729@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 01, 2010 at 03:55:19PM +0100, Steffen Klassert wrote:
> 
> On Mon, Mar 01, 2010 at 08:50:24AM +0100, Ingo Molnar wrote:
> > 
> > * Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > 
> > >       crypto: pcrypt - Add pcrypt crypto parallelization wrapper
> > 
> > -tip testing started triggering the following frequent boot crash yesterday, 
> > on 64-bit x86:
> > 
> >  |  calling  pcrypt_init+0x0/0xee @ 1
> >  |  BUG: unable to handle kernel NULL pointer dereference at (null)
> >  |  IP: [<ffffffff8126550b>] memcpy+0xb/0xb0
> >  |  Call Trace:
> >  |   [<ffffffff810c2f38>] ? padata_alloc+0x98/0x150
> >  |   [<ffffffff82158c51>] ? pcrypt_init+0x0/0xee
> >  |   [<ffffffff82158ccc>] pcrypt_init+0x7b/0xee
> > 
> 
> Ugh, it seems that I forgot to allocate one of the cpumasks. Looking at the
> configs of my test systems I noticed, that CONFIG_CPUMASK_OFFSTACK was
> not set on all the configs, so I did not notice it.
> 
> The patch below fixes the boot crash if CONFIG_CPUMASK_OFFSTACK is
> enabled on my test systems. Does the patch fix it for you too?

Ingo, any luck with this patch from Steffen?

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
