From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto driver -DCP
Date: Fri, 29 May 2015 09:32:11 +0800
Message-ID: <20150529013211.GA15566@gondor.apana.org.au>
References: <554BBD05.3050807@freescale.com>
 <201505290300.36019.marex@denx.de>
 <20150529012359.GA15471@gondor.apana.org.au>
 <201505290329.59713.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Marek Vasut <marex@denx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45236 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbbE2BcT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 May 2015 21:32:19 -0400
Content-Disposition: inline
In-Reply-To: <201505290329.59713.marex@denx.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 29, 2015 at 03:29:59AM +0200, Marek Vasut wrote:
> On Friday, May 29, 2015 at 03:23:59 AM, Herbert Xu wrote:
> > On Fri, May 29, 2015 at 03:00:35AM +0200, Marek Vasut wrote:
> > > My understanding (!) is that everyone should be able to use this key to
> > > encrypt/decrypt their data using the AES128 engine in the DCP.
> > 
> > If that's the case just make it the key you use if setkey has never
> > been called.
> 
> Shouldn't you always call setkey when using symetric crypto ?

Normally yes but we don't require it so in this case it should
be fine.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
