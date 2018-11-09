Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:37302 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbeKIT0V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:26:21 -0500
Date: Fri, 9 Nov 2018 17:46:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Stafford Horne <shorne@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] crypto: crypto_user reporting fixes and cleanups
Message-ID: <20181109094628.qdpiykue7eogzcx5@gondor.apana.org.au>
References: <20181103215603.16250-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181103215603.16250-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Nov 03, 2018 at 02:55:59PM -0700, Eric Biggers wrote:
> This series fixes all the information leaks in crypto_user reporting,
> removes some redundant reporting functions, and makes some changes to
> reduce the chance of similar information leaks in the future.  Patch 2
> is based on a patch already sent by Corentin Labbe, but it was
> incomplete so I fixed it.
> 
> Corentin Labbe (1):
>   crypto: crypto_user_stat - Zeroize whole structure given to user space
> 
> Eric Biggers (3):
>   crypto: crypto_user - fix leaking uninitialized memory to userspace
>   crypto: crypto_user - remove redundant reporting functions
>   crypto: crypto_user - clean up report structure copying
> 
>  crypto/ablkcipher.c       |  32 ++++------
>  crypto/acompress.c        |  10 +---
>  crypto/aead.c             |  14 ++---
>  crypto/ahash.c            |  12 ++--
>  crypto/akcipher.c         |  11 ++--
>  crypto/blkcipher.c        |  16 ++---
>  crypto/crypto_user_base.c |  95 +++++------------------------
>  crypto/crypto_user_stat.c | 123 ++++++++++++++------------------------
>  crypto/kpp.c              |  10 +---
>  crypto/rng.c              |  12 ++--
>  crypto/scompress.c        |  11 ++--
>  crypto/shash.c            |  12 ++--
>  crypto/skcipher.c         |  15 ++---
>  13 files changed, 116 insertions(+), 257 deletions(-)

All applied.  Patches 1-2 went into crypto and 3-4 are in cryptodev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
