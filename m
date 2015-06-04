From: Marek Vasut <marex@denx.de>
Subject: Re: Crypto driver -DCP
Date: Thu, 4 Jun 2015 17:34:39 +0200
Message-ID: <201506041734.40053.marex@denx.de>
References: <554BBD05.3050807@freescale.com> <556F5D45.9020809@freescale.com> <20150604032400.GA20967@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:46856 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbbFDPed (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Jun 2015 11:34:33 -0400
In-Reply-To: <20150604032400.GA20967@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, June 04, 2015 at 05:24:00 AM, Herbert Xu wrote:
> On Wed, Jun 03, 2015 at 03:02:13PM -0500, Jay Monkman wrote:
> > That would be one use, but a more likely use would be to prevent
> > access to the keys. A system could write keys to the key slots in
> > the bootloader or in a TrustZone secure world. Then those keys could
> > be used for crypto operations in Linux without ever exposing them.
> > Key slots can be written to, but cannot be read from.
> > 
> > Even with keys stored in key slots, other keys may be used. For
> > 
> > example, someone could do:
> >     operation w/ key in slot 1
> >     operation w/ key provided in descriptor
> >     operation w/ key in slot 1
> > 
> > I don't think an LRU scheme would allow something like that.
> 
> In that case I would suggest using setkey with a length other
> than that of a valid AES key.  For example, you could use a one-
> byte value to select the key slot.

Is this really a valid way to go about crypto -- introduce all kinds
of obscure nuances into the API which are driver specific at best ?

Best regards,
Marek Vasut
