From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/8] crypto: drbg - Add stdrng alias and increase priority
Date: Wed, 3 Jun 2015 15:01:39 +0800
Message-ID: <20150603070138.GA5081@gondor.apana.org.au>
References: <20150603064641.GA4655@gondor.apana.org.au>
 <E1Z02US-0001Gy-Hd@gondolin.me.apana.org.au>
 <1663398.CPqnxUufLz@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40793 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbbFCHBl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 03:01:41 -0400
Content-Disposition: inline
In-Reply-To: <1663398.CPqnxUufLz@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 03, 2015 at 08:59:13AM +0200, Stephan Mueller wrote:
> 
> Considering the patch 8/8 which removes krng, wouldn't it make sense to remove 
> the following code from the DRBG:
> 
>         /*
>          * If FIPS mode enabled, the selected DRBG shall have the
>          * highest cra_priority over other stdrng instances to ensure
>          * it is selected.
>          */
>         if (fips_enabled)
>                 alg->base.cra_priority += 200;
> 
> That code was added to get a higher prio than the krng in FIPS mode. As this 
> is not needed any more (krng is gone), I would say it is safe to remove this 
> code too.

You'd have to remove it from ansi_cprng first.  Feel free to send
patches to do that.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
