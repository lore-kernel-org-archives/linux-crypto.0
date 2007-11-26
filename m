From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [patch 2/2] remove similar aes glue code
Date: Mon, 26 Nov 2007 18:32:22 +0800
Message-ID: <20071126103222.GA26178@gondor.apana.org.au>
References: <20071102180503.712394234@ml.breakpoint.cc> <20071102181036.701800933@ml.breakpoint.cc> <20071110111955.GB5485@gondor.apana.org.au> <20071110212000.GC15150@Chamillionaire.breakpoint.cc> <20071111011856.GA10745@gondor.apana.org.au> <20071126093500.GD18309@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:3274 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754450AbXKZKcZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Nov 2007 05:32:25 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1IwbGI-0004Y5-Pt
	for <linux-crypto@vger.kernel.org>; Mon, 26 Nov 2007 21:32:22 +1100
Received: from herbert by gondolin.me.apana.org.au with local (Exim 3.36 #1 (Debian))
	id 1IwbGI-0006og-00
	for <linux-crypto@vger.kernel.org>; Mon, 26 Nov 2007 18:32:22 +0800
Content-Disposition: inline
In-Reply-To: <20071126093500.GD18309@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Nov 26, 2007 at 10:35:00AM +0100, Sebastian Siewior wrote:
>
> I checked it and cra_driver_name is only used for compare. I think you
> could use something like "cbc(aes-asm)" but this would only work on x86.
> Is there something I am overlooking?

That's the whole point of cra_driver_name.  Consider the case
of someone who has a higher priority version of AES available,
e.g., padlock or an async device.  If they want to specify the
assembly version of AES then they would use cbc(aes-asm).  Just
as they would use cbc(aes-generic) to select the C version.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
