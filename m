From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RESEND] SHASH_DESC_ON_STACK macro
Date: Tue, 27 Mar 2018 18:07:09 +0800
Message-ID: <20180327100709.GA12961@gondor.apana.org.au>
References: <f662fa16-2cbb-a484-4efb-68bb3b39a792@embeddedor.com>
 <bda66faa-f52d-215d-f21b-763593b30f91@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <bda66faa-f52d-215d-f21b-763593b30f91@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Mar 23, 2018 at 02:09:46PM -0500, Gustavo A. R. Silva wrote:
> 
> Hi Herbert,
> 
> There is an ongoing effort to remove all VLAs from the code base [1] and
> while working on that I came across the following macro at
> include/crypto/hash.h:154:
> 
> #define SHASH_DESC_ON_STACK(shash, ctx)                           \
>         char __##shash##_desc[sizeof(struct shash_desc) +         \
>                 crypto_shash_descsize(ctx)] CRYPTO_MINALIGN_ATTR; \
>         struct shash_desc *shash = (struct shash_desc *)__##shash##_desc
> 
> 
> Currently, this macro is being used in 46 different places.
> 
> I wonder how big can tfm->descsize can get?

descsize is capped at PAGE_SIZE / 8.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
