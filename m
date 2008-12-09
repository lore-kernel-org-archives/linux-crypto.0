From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Runaway loop with the current git.
Date: Tue, 9 Dec 2008 08:42:24 +0800
Message-ID: <20081209002451.GA31315@gondor.apana.org.au>
References: <20081207112335.0afd5192@lxorguk.ukuu.org.uk> <E1L9Kwp-0003tF-RR@gondolin.me.apana.org.au> <20081207155507.GA15355@gondor.apana.org.au> <20081208130646.GB15381@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, kay.sievers@vrfy.org,
	linux-kernel@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48141 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753806AbYLIAmi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2008 19:42:38 -0500
Content-Disposition: inline
In-Reply-To: <20081208130646.GB15381@ioremap.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 08, 2008 at 04:06:46PM +0300, Evgeniy Polyakov wrote:
>
> Your patch does not apply cleanly to the latest git and missed
> rng dependency to rng2.

Right it was against cryptodev-2.6 actually.  Thanks for fixing
it up and confirming.  I'll submit this to Linus.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
