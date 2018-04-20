From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/5] ThunderX ZIP driver bug fixes
Date: Sat, 21 Apr 2018 00:51:57 +0800
Message-ID: <20180420165157.zvrb5bjvszftmzs6@gondor.apana.org.au>
References: <20180409154554.7578-1-jglauber@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mahipal Challa <Mahipal.Challa@cavium.com>,
        Robert Richter <rrichter@cavium.com>
To: Jan Glauber <jglauber@cavium.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180409154554.7578-1-jglauber@cavium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Apr 09, 2018 at 05:45:49PM +0200, Jan Glauber wrote:
> Some bug fixes for this driver after it stopped working with virtual mapped
> stacks. I think the first two patches qualify for stable.
> 
> Jan Glauber (5):
>   crypto: thunderx_zip: Fix fallout from CONFIG_VMAP_STACK
>   crypto: thunderx_zip: Limit result reading attempts
>   crypto: thunderx_zip: Prevent division by zero
>   crypto: thunderx_zip: Fix statistics pending request value
>   crypto: thunderx_zip: Fix smp_processor_id() warnings
> 
>  drivers/crypto/cavium/zip/common.h      | 21 +++++++++++++++++++++
>  drivers/crypto/cavium/zip/zip_crypto.c  | 22 ++++++++++++++--------
>  drivers/crypto/cavium/zip/zip_deflate.c |  4 ++--
>  drivers/crypto/cavium/zip/zip_device.c  |  4 ++--
>  drivers/crypto/cavium/zip/zip_inflate.c |  4 ++--
>  drivers/crypto/cavium/zip/zip_main.c    | 24 +++++++++++-------------
>  drivers/crypto/cavium/zip/zip_main.h    |  1 -
>  7 files changed, 52 insertions(+), 28 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
