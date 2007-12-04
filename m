From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [crypto] Make crypto core API modular
Date: Tue, 4 Dec 2007 12:10:35 +1100
Message-ID: <20071204011035.GA29403@gondor.apana.org.au>
References: <20071201121910.GA8048@Chamillionaire.breakpoint.cc> <20071202150950.GA15213@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:2667 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060AbXLDBKi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Dec 2007 20:10:38 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IzMJ1-0008Oy-VI
	for <linux-crypto@vger.kernel.org>; Tue, 04 Dec 2007 12:10:36 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IzMJ1-0007f0-00
	for <linux-crypto@vger.kernel.org>; Tue, 04 Dec 2007 12:10:35 +1100
Content-Disposition: inline
In-Reply-To: <20071202150950.GA15213@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 02, 2007 at 04:09:50PM +0100, Sebastian Siewior wrote:
> * Sebastian Siewior | 2007-12-01 13:19:10 [+0100]:
> 
> >This patch makes the whole crypto API is modular.
> Ups, I forgot to put a MODULE_VERSION("GPL") inside of the module.
> Herbert, do you nack that patch due to non-sense or do you think that
> this might be usefull and I should send an updated one?

Yes I like the idea.

However, could you please fix all the crypto users to select CRYPTO
first? We can then do the modularisation for the next release.

I think we should also get rid of the ifdef CONFIG_CRYPTO because it
has no legitimate uses.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
