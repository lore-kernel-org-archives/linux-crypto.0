Return-Path: <SRS0=9Gyh=PA=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:39024 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731916AbeLWEDq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Dec 2018 23:03:46 -0500
Date: Sun, 23 Dec 2018 12:03:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: remove remnants of internal IV generators
Message-ID: <20181223040344.2746xfu7fif2a2fz@gondor.apana.org.au>
References: <20181216235506.8680-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181216235506.8680-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 16, 2018 at 03:55:06PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Remove dead code related to internal IV generators, which are no longer
> used since they've been replaced with the "seqiv" and "echainiv"
> templates.  The removed code includes:
> 
> - The "givcipher" (GIVCIPHER) algorithm type.  No algorithms are
>   registered with this type anymore, so it's unneeded.
> 
> - The "const char *geniv" member of aead_alg, ablkcipher_alg, and
>   blkcipher_alg.  A few algorithms still set this, but it isn't used
>   anymore except to show via /proc/crypto and CRYPTO_MSG_GETALG.
>   Just hardcode "<default>" or "<none>" in those cases.
> 
> - The 'skcipher_givcrypt_request' structure, which is never used.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Documentation/crypto/api.rst          |  9 ----
>  Documentation/crypto/architecture.rst | 31 ++---------
>  crypto/ablkcipher.c                   | 76 +--------------------------
>  crypto/blkcipher.c                    |  6 +--
>  crypto/cryptd.c                       |  4 +-
>  crypto/ctr.c                          |  2 -
>  crypto/skcipher.c                     |  6 +--
>  drivers/crypto/bcm/cipher.c           |  1 -
>  drivers/crypto/chelsio/chcr_algo.c    |  1 -
>  drivers/crypto/ixp4xx_crypto.c        |  5 --
>  drivers/crypto/nx/nx-aes-ctr.c        |  1 -
>  drivers/crypto/omap-aes.c             |  1 -
>  drivers/crypto/picoxcell_crypto.c     |  3 +-
>  drivers/crypto/talitos.c              |  1 -
>  include/crypto/aead.h                 |  3 --
>  include/crypto/internal/skcipher.h    |  2 -
>  include/crypto/skcipher.h             | 13 -----
>  include/linux/crypto.h                | 34 ++----------
>  18 files changed, 17 insertions(+), 182 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
