From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: api - Unexport crypto_larval_lookup()
Date: Fri, 22 Dec 2017 19:42:09 +1100
Message-ID: <20171222084209.GA31165@gondor.apana.org.au>
References: <20171207185559.17087-1-ebiggers3@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ebiggers@google.com
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46302 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1755853AbdLVImL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 03:42:11 -0500
Content-Disposition: inline
In-Reply-To: <20171207185559.17087-1-ebiggers3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Eric Biggers <ebiggers3@gmail.com> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> crypto_larval_lookup() is not used outside of crypto/api.c, so unexport
> it and mark it 'static'.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
