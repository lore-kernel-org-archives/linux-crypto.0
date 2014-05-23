From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v7 0/6] SP800-90A Deterministic Random Bit Generator
Date: Sat, 24 May 2014 05:14:59 +0800
Message-ID: <20140523211459.GA21019@gondor.apana.org.au>
References: <16102625.1uoi9eJz6k@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	aquini@redhat.com, jeremy.wayne.powell@gmail.com,
	clemens@ladisch.de, pwalten@au1.ibm.com, joe@perches.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:41614 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaEWVPD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 May 2014 17:15:03 -0400
Content-Disposition: inline
In-Reply-To: <16102625.1uoi9eJz6k@myon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> wrote:
> Hi,
> 
> the following set of patches implements the deterministic random bit generator
> (DRBG) specified by SP800-90A.
> 
> The DRBG implementation offers the following:
> 
>        * All three DRBG types are implemented with a derivation function.
>        * All DRBG types are available with and without prediction resistance.
>        * All SHA types of SHA-1, SHA-256, SHA-384, SHA-512 are available
>          for the HMAC and Hash DRBGs.
>        * All AES types of AES-128, AES-192 and AES-256 are available for the
>          CTR DRBG.
>        * A self test is implemented with drbg_healthcheck().
>        * The FIPS 140-2 continuous self test is implemented.
>        * Additional cipher primitives, such as Serpent or Twofish, can be
>          added to the DRBG without changing the implementation. The only
>          change necessary is to the DRBG definition given in the cores[]
>          array.

Where is the code that actually uses this?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
