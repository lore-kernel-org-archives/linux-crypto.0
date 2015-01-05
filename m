From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AEAD: add check for presence of auth tag
Date: Mon, 5 Jan 2015 21:19:01 +1100
Message-ID: <20150105101901.GA24736@gondor.apana.org.au>
References: <15957213.Wu7Np8vQse@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:44815 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbbAEKTJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Jan 2015 05:19:09 -0500
Content-Disposition: inline
In-Reply-To: <15957213.Wu7Np8vQse@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 30, 2014 at 10:16:03PM +0100, Stephan Mueller wrote:
> The AEAD decryption operation requires the authentication tag to be
> present as part of the cipher text buffer. The added check verifies that
> the caller provides a cipher text buffer with at least the
> authentication tag.
> 
> As the cipher text is provided as a scatterlist, loop through the
> scatterlist until we know we have sufficient cipher text bytes to invoke
> the AEAD decryption operation.

There is no need to vet the scatterlist.  For kernel users it's
up to them to ensure that the length is valid with respect to the
sg list.

For the user-space interface obviously you should ensure that a
valid length is supplied.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
