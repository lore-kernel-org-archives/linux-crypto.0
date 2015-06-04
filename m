From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto driver -DCP
Date: Thu, 4 Jun 2015 11:24:00 +0800
Message-ID: <20150604032400.GA20967@gondor.apana.org.au>
References: <554BBD05.3050807@freescale.com>
 <201505290300.36019.marex@denx.de>
 <20150529012359.GA15471@gondor.apana.org.au>
 <201505290329.59713.marex@denx.de>
 <20150529013211.GA15566@gondor.apana.org.au>
 <556DFC98.10406@smoothsmoothie.com>
 <20150603021135.GA2451@gondor.apana.org.au>
 <556F5D45.9020809@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marek Vasut <marex@denx.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Jay Monkman <jay.monkman@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50776 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbbFDDYO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 23:24:14 -0400
Content-Disposition: inline
In-Reply-To: <556F5D45.9020809@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 03, 2015 at 03:02:13PM -0500, Jay Monkman wrote:
>
> That would be one use, but a more likely use would be to prevent
> access to the keys. A system could write keys to the key slots in
> the bootloader or in a TrustZone secure world. Then those keys could
> be used for crypto operations in Linux without ever exposing them.
> Key slots can be written to, but cannot be read from.
> 
> Even with keys stored in key slots, other keys may be used. For
> example, someone could do:
>     operation w/ key in slot 1
>     operation w/ key provided in descriptor
>     operation w/ key in slot 1
> 
> I don't think an LRU scheme would allow something like that.

In that case I would suggest using setkey with a length other
than that of a valid AES key.  For example, you could use a one-
byte value to select the key slot.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
