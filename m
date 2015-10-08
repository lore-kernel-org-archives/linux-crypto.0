From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH V2] crypto/nx842: Add CRC and validation support
Date: Thu, 8 Oct 2015 21:23:40 +0800
Message-ID: <20151008132340.GB24362@gondor.apana.org.au>
References: <1443933331.28024.35.camel@hbabu-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, ddstreet@ieee.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Haren Myneni <haren@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443933331.28024.35.camel@hbabu-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Oct 03, 2015 at 09:35:31PM -0700, Haren Myneni wrote:
>
> diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
> index 5446ff0..b0db568 100644
> --- a/lib/842/842_decompress.c
> +++ b/lib/842/842_decompress.c
> @@ -285,6 +285,7 @@ int sw842_decompress(const u8 *in, unsigned int
> ilen,
>  	struct sw842_param p;
>  	int ret;
>  	u64 op, rep, tmp, bytes, total;
> +	u64 crc;
>  
>  	p.in = (u8 *)in;
>  	p.bit = 0;
> @@ -375,6 +376,22 @@ int sw842_decompress(const u8 *in, unsigned int
> ilen,
>  		}
>  	} while (op != OP_END);

Your patch is white-space corrupted.  Please resend.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
