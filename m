Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:45632 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726979AbeKTRAj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 12:00:39 -0500
Date: Tue, 20 Nov 2018 14:33:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: remove useless initializations of cra_list
Message-ID: <20181120063310.kxlidc5pwbxcniej@gondor.apana.org.au>
References: <20181114193548.54811-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181114193548.54811-1-ebiggers@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 14, 2018 at 11:35:48AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Some algorithms initialize their .cra_list prior to registration.
> But this is unnecessary since crypto_register_alg() will overwrite
> .cra_list when adding the algorithm to the 'crypto_alg_list'.
> Apparently the useless assignment has just been copy+pasted around.
> 
> So, remove the useless assignments.
> 
> Exception: paes_s390.c uses cra_list to check whether the algorithm is
> registered or not, so I left that as-is for now.
> 
> This patch shouldn't change any actual behavior.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/sparc/crypto/aes_glue.c      | 5 -----
>  arch/sparc/crypto/camellia_glue.c | 5 -----
>  arch/sparc/crypto/des_glue.c      | 5 -----
>  crypto/lz4.c                      | 1 -
>  crypto/lz4hc.c                    | 1 -
>  drivers/crypto/bcm/cipher.c       | 2 --
>  drivers/crypto/omap-aes.c         | 2 --
>  drivers/crypto/omap-des.c         | 1 -
>  drivers/crypto/qce/ablkcipher.c   | 1 -
>  drivers/crypto/qce/sha.c          | 1 -
>  drivers/crypto/sahara.c           | 1 -
>  11 files changed, 25 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
