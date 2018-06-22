From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 00/10] crypto: inside-secure - sha512/384 support
Date: Fri, 22 Jun 2018 23:22:10 +0800
Message-ID: <20180622152210.a733zyzzt7qtzq3j@gondor.apana.org.au>
References: <20180529121352.19490-1-antoine.tenart@bootlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        maxime.chevallier@bootlin.com, gregory.clement@bootlin.com,
        miquel.raynal@bootlin.com, nadavh@marvell.com, oferh@marvell.com,
        igall@marvell.com
To: Antoine Tenart <antoine.tenart@bootlin.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529121352.19490-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, May 29, 2018 at 02:13:42PM +0200, Antoine Tenart wrote:
> Hello Herbert,
> 
> This series adds support for the SHA512 and SHA384 algorithms in the
> Inside Secure SafeXcel driver. Variants of those two algorithms are also
> added as well (hmac, and AEAD).
> 
> Before doing so a few patches rework the driver to prepare for the new
> algorithms additions.
> 
> Thanks!
> Antoine
> 
> Antoine Tenart (10):
>   crypto: inside-secure - use the error handler for invalidation
>     requests
>   crypto: inside-secure - improve the counter computation
>   crypto: sha512_generic - add a sha512 0-length pre-computed hash
>   crypto: inside-secure - sha512 support
>   crypto: inside-secure - hmac(sha512) support
>   crypto: inside-secure - authenc(hmac(sha512),cbc(aes)) support
>   crypto: sha512_generic - add a sha384 0-length pre-computed hash
>   crypto: inside-secure - sha384 support
>   crypto: inside-secure - hmac(sha384) support
>   crypto: inside-secure - authenc(hmac(sha384),cbc(aes)) support
> 
>  crypto/sha512_generic.c                       |  22 +
>  drivers/crypto/inside-secure/safexcel.c       |   6 +
>  drivers/crypto/inside-secure/safexcel.h       |  23 +-
>  .../crypto/inside-secure/safexcel_cipher.c    |  89 +++-
>  drivers/crypto/inside-secure/safexcel_hash.c  | 381 ++++++++++++++++--
>  include/crypto/sha.h                          |   4 +
>  6 files changed, 469 insertions(+), 56 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
