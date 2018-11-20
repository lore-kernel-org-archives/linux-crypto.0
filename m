Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:45644 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbeKTRA6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 12:00:58 -0500
Date: Tue, 20 Nov 2018 14:33:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: drop mask=CRYPTO_ALG_ASYNC from 'shash' tfm
 allocations
Message-ID: <20181120063329.t2cqseeo6ys4eu47@gondor.apana.org.au>
References: <20181114202111.99005-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114202111.99005-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 14, 2018 at 12:21:11PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> 'shash' algorithms are always synchronous, so passing CRYPTO_ALG_ASYNC
> in the mask to crypto_alloc_shash() has no effect.  Many users therefore
> already don't pass it, but some still do.  This inconsistency can cause
> confusion, especially since the way the 'mask' argument works is
> somewhat counterintuitive.
> 
> Thus, just remove the unneeded CRYPTO_ALG_ASYNC flags.
> 
> This patch shouldn't change any actual behavior.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  drivers/block/drbd/drbd_receiver.c          | 2 +-
>  drivers/md/dm-integrity.c                   | 2 +-
>  drivers/net/wireless/intersil/orinoco/mic.c | 6 ++----
>  fs/ubifs/auth.c                             | 5 ++---
>  net/bluetooth/smp.c                         | 2 +-
>  security/apparmor/crypto.c                  | 2 +-
>  security/integrity/evm/evm_crypto.c         | 3 +--
>  security/keys/encrypted-keys/encrypted.c    | 4 ++--
>  security/keys/trusted.c                     | 4 ++--
>  9 files changed, 13 insertions(+), 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
