From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: null - Get rid of
 crypto_{get,put}_default_null_skcipher2()
Date: Fri, 22 Dec 2017 19:42:22 +1100
Message-ID: <20171222084222.GA31185@gondor.apana.org.au>
References: <20171207185634.17283-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ebiggers@google.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46308 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751514AbdLVIm0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 03:42:26 -0500
Content-Disposition: inline
In-Reply-To: <20171207185634.17283-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers3@gmail.com> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Since commit 499a66e6b689 ("crypto: null - Remove default null
> blkcipher"), crypto_get_default_null_skcipher2() and
> crypto_put_default_null_skcipher2() are the same as their non-2
> equivalents.  So switch callers of the "2" versions over to the original
> versions and remove the "2" versions.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
