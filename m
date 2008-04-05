From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [crypto] AES shorten the Kconfig entry
Date: Sat, 5 Apr 2008 21:07:27 +0800
Message-ID: <20080405130727.GC4644@gondor.apana.org.au>
References: <20080328223952.GD24018@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34784 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbYDENH3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Apr 2008 09:07:29 -0400
Content-Disposition: inline
In-Reply-To: <20080328223952.GD24018@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Mar 28, 2008 at 11:39:52PM +0100, Sebastian Siewior wrote:
> Remove copied / duplicate entry from the assemble version and add a
> small hint that the assembly version performs better and is not
> a relict.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>

Looks OK but there is another one of these in drivers/crypto.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
