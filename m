From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC HIFN 00/02]: RNG support
Date: Sun, 18 Nov 2007 11:14:02 +0800
Message-ID: <20071118031402.GA25388@gondor.apana.org.au>
References: <20071117192949.19399.75523.sendpatchset@localhost.localdomain> <20071117195324.GA4010@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4269 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754176AbXKRDOP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 17 Nov 2007 22:14:15 -0500
Content-Disposition: inline
In-Reply-To: <20071117195324.GA4010@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Nov 17, 2007 at 07:53:25PM +0000, Evgeniy Polyakov wrote:
>
> > The second patch adds hw_random support. The ugly part is finding out
> > when to allow reads from the RNG. It currently translates the public
> > key engine clock cycles to CPU cycles based on a 4GHz CPU and uses
> > get_cycles(). The problems with this are obvious, it only works on CPUs
> > that actually have some kind of cycle counter, has problems with
> > unsynchronized TSCs and the 4GHz assumption is not very nice either,
> > but I was reluctant to use ktime for this since it seems rather
> > expensive to call ktime_get once per 4 bytes of random. Suggestion
> > for improvement of this are also welcome :)
> 
> It will not work on arm, but I'm not sure this is relevant...
> Another option is to directly access xtime without all wrappers in the
> ktime_get().

Is it really that bad? You're most likely going to be spinning
for 10us in udelay() or worse busy-looping anyway so I'm not sure
if we need to worry about that overhead too much.

Otherwise these patches look pretty nice to me.  Thanks Patrick!

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
