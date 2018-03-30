From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: brcm - explicitly cast cipher to hash type
Date: Sat, 31 Mar 2018 01:43:35 +0800
Message-ID: <20180330174335.GJ28120@gondor.apana.org.au>
References: <20180324110242.9474-1-stefan@agner.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, raveendra.padasalagi@broadcom.com,
        clabbe.montjoie@gmail.com, scott.branden@broadcom.com,
        steven.lin1@broadcom.com, garsilva@embeddedor.com,
        pravin.shedge4linux@gmail.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stefan Agner <stefan@agner.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180324110242.9474-1-stefan@agner.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Mar 24, 2018 at 12:02:42PM +0100, Stefan Agner wrote:
> In the AES cases enum spu_cipher_type and enum hash_type have
> the same values, so the assignment is fine. Explicitly cast
> the enum type conversion.
> 
> This fixes two warnings when building with clang:
>   drivers/crypto/bcm/cipher.c:821:34: warning: implicit conversion from
>       enumeration type 'enum spu_cipher_type' to different enumeration
>       type 'enum hash_type' [-Wenum-conversion]
>                 hash_parms.type = cipher_parms.type;
>                                 ~ ~~~~~~~~~~~~~^~~~
>   drivers/crypto/bcm/cipher.c:1412:26: warning: implicit conversion from
>       enumeration type 'enum spu_cipher_type' to different enumeration
>       type 'enum hash_type' [-Wenum-conversion]
>                 hash_parms.type = ctx->cipher_type;
>                                 ~ ~~~~~^~~~~~~~~~~
> 
> Signed-off-by: Stefan Agner <stefan@agner.ch>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
