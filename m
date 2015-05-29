From: Marek Vasut <marex@denx.de>
Subject: Re: Crypto driver -DCP
Date: Fri, 29 May 2015 15:02:59 +0200
Message-ID: <201505291502.59208.marex@denx.de>
References: <554BBD05.3050807@freescale.com> <201505290329.59713.marex@denx.de> <20150529013211.GA15566@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:45388 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbbE2NDC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2015 09:03:02 -0400
In-Reply-To: <20150529013211.GA15566@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, May 29, 2015 at 03:32:11 AM, Herbert Xu wrote:
> On Fri, May 29, 2015 at 03:29:59AM +0200, Marek Vasut wrote:
> > On Friday, May 29, 2015 at 03:23:59 AM, Herbert Xu wrote:
> > > On Fri, May 29, 2015 at 03:00:35AM +0200, Marek Vasut wrote:
> > > > My understanding (!) is that everyone should be able to use this key
> > > > to encrypt/decrypt their data using the AES128 engine in the DCP.
> > > 
> > > If that's the case just make it the key you use if setkey has never
> > > been called.
> > 
> > Shouldn't you always call setkey when using symetric crypto ?
> 
> Normally yes but we don't require it so in this case it should
> be fine.

This does look somewhat hacky to me. Wouldn't it make more sense to
add a CRYPTO_TFM_REQ flag ?

Best regards,
Marek Vasut
