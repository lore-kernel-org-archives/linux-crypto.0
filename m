From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/2] crypto: constify test vectors
Date: Thu, 9 Mar 2017 18:47:38 +0800
Message-ID: <20170309104738.GF7185@gondor.apana.org.au>
References: <20170224234659.89423-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Eric Biggers <ebiggers@google.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55541 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932290AbdCISSW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2017 13:18:22 -0500
Content-Disposition: inline
In-Reply-To: <20170224234659.89423-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 24, 2017 at 03:46:57PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> These two patches mark all the cryptographic test vectors as 'const'.
> This has several potential advantages and moves a large amount of data
> from .data to .rodata when the tests are enabled.  The second patch does
> the real work; the first just prepares for it by updating a function to
> take a const buffer argument.
> 
> Eric Biggers (2):
>   crypto: kpp - constify buffer passed to crypto_kpp_set_secret()
>   crypto: testmgr - constify all test vectors

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
