Return-Path: <SRS0=WCFZ=OI=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:52908 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727521AbeK2Rxe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Nov 2018 12:53:34 -0500
Date: Thu, 29 Nov 2018 14:49:13 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David CARLIER <devnexen@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: use memzero_explicit instead of memset to clear
 contexts.
Message-ID: <20181129064913.wbudlexjzszpa7dq@gondor.apana.org.au>
References: <CA+XhMqz7ZaGVNpkrRM-t4h2f9UZVQPjLVB5Txco4bKGRm8k=mA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+XhMqz7ZaGVNpkrRM-t4h2f9UZVQPjLVB5Txco4bKGRm8k=mA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Nov 28, 2018 at 07:36:50PM +0000, David CARLIER wrote:
> There might be a little performance drop but to make sure it stands
> by it comments, we really wipe the whole context after usage.
> ---
>  crypto/chacha20poly1305.c | 3 ++-
>  crypto/md5.c              | 2 +-
>  crypto/rmd128.c           | 3 ++-
>  crypto/rmd160.c           | 3 ++-
>  crypto/rmd256.c           | 3 ++-
>  crypto/rmd320.c           | 3 ++-
>  crypto/sha3_generic.c     | 3 ++-
>  7 files changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/crypto/chacha20poly1305.c b/crypto/chacha20poly1305.c
> index 600afa99941f..6e93d998109e 100644
> --- a/crypto/chacha20poly1305.c
> +++ b/crypto/chacha20poly1305.c
> @@ -19,6 +19,7 @@
>  #include <linux/init.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/string.h>
> 
>  #include "internal.h"
> 
> @@ -388,7 +389,7 @@ static int poly_genkey(struct aead_request *req)
>         }
> 
>         sg_init_table(creq->src, 1);
> -       memset(rctx->key, 0, sizeof(rctx->key));
> +       memzero_explicit(rctx->key, sizeof(rctx->key));

Please explain the purpose of this patch.  As it stands this
makes no sense.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
