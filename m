From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IV copy strategy
Date: Fri, 16 Nov 2007 17:30:31 +0800
Message-ID: <20071116093031.GA8644@gondor.apana.org.au>
References: <20071113231132.GA10680@Chamillionaire.breakpoint.cc> <20071114142253.GA15201@gondor.apana.org.au> <20071115211005.GA21159@Chamillionaire.breakpoint.cc> <20071116020851.GC32509@gondor.apana.org.au> <20071116081913.GA24538@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1347 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752749AbXKPJae (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 Nov 2007 04:30:34 -0500
Content-Disposition: inline
In-Reply-To: <20071116081913.GA24538@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Nov 16, 2007 at 09:19:13AM +0100, Sebastian Siewior wrote:
> Not only in hfin. My SPU-AES has the same bug. Do you know someone who
> wants to chain? I can remember that you said once "that this is
> currently the case but we can change this since IPsec brings a new IV
> for ever packet".
> So, both of us have to fix it or must the crypto users complete their
> encryption/decryption process in one go once they use async (we have no
> documentation so we are very flexible here I guess :) )?

IPsec wouldn't need to chain but it is conceivable that others
may wish to chain.  More importantly if you don't copy it out
then chaining would be impossible in general so you're taking
the choice away from the user.

I just did a grep and RXKAD seems to be the only user that uses
the IV (apart from IPsec that is).  So if we take chaining away
then we might lose the ability to ever convert RXKAD to the
ablkcipher interface.

I do recognise that for DMA devices copying the IV back may be
expensive so perhaps we can add a request flag for this.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
