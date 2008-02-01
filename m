From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Trouble with non modular ciphers
Date: Fri, 1 Feb 2008 11:12:18 +1100
Message-ID: <20080201001218.GA13596@gondor.apana.org.au>
References: <200801311021.24240.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:58305 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762747AbYBAAMV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Jan 2008 19:12:21 -0500
Content-Disposition: inline
In-Reply-To: <200801311021.24240.ak@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 31, 2008 at 10:21:24AM +0100, Andi Kleen wrote:
> 
> FYI -- with a linus git kernel of yesterday or so I ran into a problem where 
> one cipher module (CBC) was compiled in and the rest modular. dm_crypt 
> could not resolve the cipher module until I turned it into a module.
> I don't remember if cryptomanager was modular or not.
> 
> I don't have the exact configuration anymore unfortunately, but just
> wanted to report the problem.

OK, I couldn't find anything bad from looking through the Kconfig.
What happens if you try to build it in again?

> Also I found that cryptomanager is quite unhappy when CONFIG_KMOD
> is not defined. Perhaps it should Kconfig select it?

Good point.  Yes we should do that.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
