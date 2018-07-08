From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] crypto: inside-secure - support more algorithms
Date: Mon, 9 Jul 2018 00:44:57 +0800
Message-ID: <20180708164456.xuykt4v4ebod7cor@gondor.apana.org.au>
References: <20180628152157.23769-1-antoine.tenart@bootlin.com>
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
In-Reply-To: <20180628152157.23769-1-antoine.tenart@bootlin.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jun 28, 2018 at 05:21:52PM +0200, Antoine Tenart wrote:
> Hi all,
> 
> This series adds support for more algorithms in the Inside Secure
> SafeXcel cryptographic engine driver. Those new algorithms are:
> - MD5 (and its hmac).
> - DES (ECB and CBC).
> - 3DES (ECB and CBC).
> 
> The last patch was made on top of the algorithm additions, to enhance
> the driver's performances.
> 
> This series should be applied on top of another one:
> https://lkml.org/lkml/2018/6/28/516
> 
> Thanks!
> Antoine
> 
> Ofer Heifetz (5):
>   crypto: inside-secure - md5 support
>   crypto: inside-secure - hmac(md5) support
>   crypto: inside-secure - ecb(des) and cbc(des) support
>   crypto: inside-secure - ecb(des3_ede) and cbc(des3_ede) support
>   crypto: inside-secure - remove request list to improve performance
> 
>  drivers/crypto/Kconfig                        |   2 +
>  drivers/crypto/inside-secure/safexcel.c       | 100 ++---
>  drivers/crypto/inside-secure/safexcel.h       |  41 +-
>  .../crypto/inside-secure/safexcel_cipher.c    | 369 ++++++++++++++----
>  drivers/crypto/inside-secure/safexcel_hash.c  | 157 ++++++--
>  drivers/crypto/inside-secure/safexcel_ring.c  |  48 ++-
>  6 files changed, 553 insertions(+), 164 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
