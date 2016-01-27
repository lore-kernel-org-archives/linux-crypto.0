From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] crypto: Key Derivation Function (SP800-108)
Date: Wed, 27 Jan 2016 13:14:09 +0800
Message-ID: <20160127051409.GA30212@gondor.apana.org.au>
References: <4445045.XP4c23S4mB@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45557 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753486AbcA0FOO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 00:14:14 -0500
Content-Disposition: inline
In-Reply-To: <4445045.XP4c23S4mB@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 26, 2016 at 07:19:17AM +0100, Stephan Mueller wrote:
> Hi,
> 
> this patch set implements all three key derivation functions defined in
> SP800-108.
> 
> The implementation is provided as a template for random number generators,
> since a KDF can be considered a form of deterministic RNG where the key
> material is used as a seed.
> 
> With the KDF implemented as a template, all types of keyed hashes can be
> utilized, including HMAC and CMAC. The testmgr tests are derived from
> publicly available test vectors from NIST.
> 
> The KDF are all tested with a complete round of CAVS testing on 32 and 64 bit.
> 
> The patch set introduces an extension to the kernel crypto API in the first
> patch by adding a template handling for random number generators based on the
> same logic as for keyed hashes.

What is this going to use this inside the kernel?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
