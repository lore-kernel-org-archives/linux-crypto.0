From: Marek Vasut <marex@denx.de>
Subject: Re: Crypto driver -DCP
Date: Wed, 3 Jun 2015 14:54:54 +0200
Message-ID: <201506031454.54763.marex@denx.de>
References: <554BBD05.3050807@freescale.com> <201506011524.03531.marex@denx.de> <20150601145014.GA16400@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:60218 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759488AbbFCMzD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 08:55:03 -0400
In-Reply-To: <20150601145014.GA16400@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Monday, June 01, 2015 at 04:50:15 PM, Herbert Xu wrote:
> On Mon, Jun 01, 2015 at 03:24:03PM +0200, Marek Vasut wrote:
> > On Friday, May 29, 2015 at 03:30:18 PM, Herbert Xu wrote:
> > > On Fri, May 29, 2015 at 03:02:59PM +0200, Marek Vasut wrote:
> > > > This does look somewhat hacky to me. Wouldn't it make more sense to
> > > > add a CRYPTO_TFM_REQ flag ?
> > > 
> > > What are you going to do when you have more than one hard-coded
> > > key? A flag is a non-starter.
> > 
> > Well, abusing a non-well-defined part of the API is also not a nice
> > way to do it. Maybe we should consider some other -- third -- option ?
> 
> I'm waiting to hear it :)

I cannot tell, I wasn't digging in the API for a while now, so I forgot
the details. Maybe someone else can chime in ?

Best regards,
Marek Vasut
