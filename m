From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2 v2] talitos: Freescale integrated security engine (SEC) driver
Date: Thu, 5 Jun 2008 15:22:24 +1000
Message-ID: <20080605052224.GA23150@gondor.apana.org.au>
References: <20080530185830.60f4e1d4.kim.phillips@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org,
	Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:39707 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751645AbYFEFWb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Jun 2008 01:22:31 -0400
Content-Disposition: inline
In-Reply-To: <20080530185830.60f4e1d4.kim.phillips@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 30, 2008 at 06:58:30PM -0500, Kim Phillips wrote:
>
> +	/* get random IV */
> +	get_random_bytes(req->giv, crypto_aead_ivsize(authenc));

Sorry but this is unworkable given our current RNG infrastructure.
Draining 16 bytes for every packet is going to make /dev/random
unuseable (if it wasn't already :).

Perhaps just use eseqiv (it should be pretty cheap sinec it just
tacks on an extra block to the encryption) for now until we have
a PRNG?

We'll need to extend eseqiv to support AEAD first though.  Perhaps
change it so that it can be called as a library by AEAD algorithms?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
