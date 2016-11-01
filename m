From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: skcipher - Get rid of crypto_spawn_skcipher2()
Date: Tue, 1 Nov 2016 08:46:02 +0800
Message-ID: <20161101004602.GG7375@gondor.apana.org.au>
References: <1477673539-85391-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48435 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S948330AbcKAAqF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 31 Oct 2016 20:46:05 -0400
Content-Disposition: inline
In-Reply-To: <1477673539-85391-1-git-send-email-ebiggers@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Oct 28, 2016 at 09:52:19AM -0700, Eric Biggers wrote:
> Since commit 3a01d0ee2b99 ("crypto: skcipher - Remove top-level
> givcipher interface"), crypto_spawn_skcipher2() and
> crypto_spawn_skcipher() are equivalent.  So switch callers of
> crypto_spawn_skcipher2() to crypto_spawn_skcipher() and remove it.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
