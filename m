From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto driver -DCP
Date: Mon, 1 Jun 2015 22:50:15 +0800
Message-ID: <20150601145014.GA16400@gondor.apana.org.au>
References: <554BBD05.3050807@freescale.com>
 <201505291502.59208.marex@denx.de>
 <20150529133018.GB20596@gondor.apana.org.au>
 <201506011524.03531.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46211 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbbFAOu1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Jun 2015 10:50:27 -0400
Content-Disposition: inline
In-Reply-To: <201506011524.03531.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 01, 2015 at 03:24:03PM +0200, Marek Vasut wrote:
> On Friday, May 29, 2015 at 03:30:18 PM, Herbert Xu wrote:
> > On Fri, May 29, 2015 at 03:02:59PM +0200, Marek Vasut wrote:
> > > This does look somewhat hacky to me. Wouldn't it make more sense to
> > > add a CRYPTO_TFM_REQ flag ?
> > 
> > What are you going to do when you have more than one hard-coded
> > key? A flag is a non-starter.
> 
> Well, abusing a non-well-defined part of the API is also not a nice
> way to do it. Maybe we should consider some other -- third -- option ?

I'm waiting to hear it :)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
