From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto driver -DCP
Date: Wed, 3 Jun 2015 10:11:35 +0800
Message-ID: <20150603021135.GA2451@gondor.apana.org.au>
References: <554BBD05.3050807@freescale.com>
 <201505290300.36019.marex@denx.de>
 <20150529012359.GA15471@gondor.apana.org.au>
 <201505290329.59713.marex@denx.de>
 <20150529013211.GA15566@gondor.apana.org.au>
 <556DFC98.10406@smoothsmoothie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Marek Vasut <marex@denx.de>,
	Jay Monkman <jay.monkman@freescale.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Jay Monkman <jtm@smoothsmoothie.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48499 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbbFCCLt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2015 22:11:49 -0400
Content-Disposition: inline
In-Reply-To: <556DFC98.10406@smoothsmoothie.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 02, 2015 at 01:57:28PM -0500, Jay Monkman wrote:
>
> I have another question. The DCP (and other crypto accelerators on
> other SOCs) supports key slots - basically write only RAM that's
> used to store keys so they can be used for encrypt/decrypt
> operations. DCP supports 4 key slots, other devices have different
> numbers. Do you have any suggestion for how to add support for
> something like that to the driver?

So these would allow faster switching of keys I presume?

If so that's a resource the driver should manage.  The simplest
would be some kind of LRU scheme where you expire the least recently
used key.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
