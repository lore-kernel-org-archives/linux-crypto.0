Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:48468 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfARK4C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jan 2019 05:56:02 -0500
Date: Fri, 18 Jan 2019 18:56:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: shash - remove pointless checks of
 shash_alg::{export,import}
Message-ID: <20190118105600.nc3m4fcgw5veqi6h@gondor.apana.org.au>
References: <20190107030801.10096-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190107030801.10096-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Jan 06, 2019 at 07:08:01PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> crypto_init_shash_ops_async() only gives the ahash tfm non-NULL
> ->export() and ->import() if the underlying shash alg has these
> non-NULL.  This doesn't make sense because when an shash algorithm is
> registered, shash_prepare_alg() sets a default ->export() and ->import()
> if the implementor didn't provide them.  And elsewhere it's assumed that
> all shash algs and ahash tfms have non-NULL ->export() and ->import().
> 
> Therefore, remove these unnecessary, always-true conditions.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/shash.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
