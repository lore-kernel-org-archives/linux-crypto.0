From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: skcipher - noop for enc/dec with NULL data
Date: Sat, 7 Oct 2017 10:46:35 +0800
Message-ID: <20171007024635.GB28489@gondor.apana.org.au>
References: <3874163.dZU00zCVt8@positron.chronox.de>
 <1612247.TXa8PiMVpk@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:57036 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdJGCqz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Oct 2017 22:46:55 -0400
Content-Disposition: inline
In-Reply-To: <1612247.TXa8PiMVpk@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Sep 24, 2017 at 08:24:58AM +0200, Stephan Müller wrote:
> The encryption / decryption operation is a noop in case the caller
> provides zero input data. As this noop is a "valid" operation, the API
> calls will return no error, but simply skip any processing.
> 
> This fixes a kernel crash with authenc() ciphers and zero plaintext /
> ciphertext that can be triggered via AF_ALG from unprivileged user
> space.
> 
> Fixes: 7a7ffe65c8c5f ("crypto: skcipher - Add top-level skcipher
> interface")
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: <stable@vger.kernel.org>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Hmm this just papers over bugs in the underlying code.  Which
algorithm is causing the crash with a zero input? They're supposed
to handle this case.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
