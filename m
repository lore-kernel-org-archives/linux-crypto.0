From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 00/10] crypto: inside-secure - AEAD support
Date: Sun, 27 May 2018 00:26:03 +0800
Message-ID: <20180526162603.a64gtx3sxjwjadf7@gondor.apana.org.au>
References: <20180514131104.25552-1-antoine.tenart@bootlin.com>
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
In-Reply-To: <20180514131104.25552-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 14, 2018 at 03:10:54PM +0200, Antoine Tenart wrote:
> This series brings AEAD algorithms to the Inside Secure SafeXcel driver.
> The first 7 commits rework the driver to allow the future AEAD addition,
> and then 3 commits add AEAD functions and 3 algorithms.
> 
> This is based on top of v4.17-rc5.
> 
> Thanks!
> Antoine
> 
> Since v1:
>   - Reworked the driver to remove VLA's and added a custom on-stack
>     request definition in the driver, to be used in the invalidation
>     process. (Patch 1/10 was replaced, patch 8/10 was reworked).
>   - Rebased on top of v4.17-rc5 (was -rc3).
> 
> Antoine Tenart (10):
>   crypto: inside-secure - remove VLAs
>   crypto: inside-secure - rework cipher functions for future AEAD
>     support
>   crypto: inside-secure - rework the alg type settings in the context
>   crypto: inside-secure - make the context control size dynamic
>   crypto: inside-secure - make the key and context size computation
>     dynamic
>   crypto: inside-secure - fix the hash then encrypt/decrypt types
>   crypto: inside-secure - improve error reporting
>   crypto: inside-secure - authenc(hmac(sha256),cbc(aes)) support
>   crypto: inside-secure - authenc(hmac(sha224),cbc(aes)) support
>   crypto: inside-secure - authenc(hmac(sha1),cbc(aes)) support
> 
>  drivers/crypto/Kconfig                        |   1 +
>  drivers/crypto/inside-secure/safexcel.c       |  32 +
>  drivers/crypto/inside-secure/safexcel.h       |  44 +-
>  .../crypto/inside-secure/safexcel_cipher.c    | 642 ++++++++++++++----
>  drivers/crypto/inside-secure/safexcel_hash.c  |  23 +-
>  5 files changed, 600 insertions(+), 142 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
