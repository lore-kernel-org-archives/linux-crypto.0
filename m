From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/2] crypto: vmx - Remove overly verbose printk from AES
 XTS init
Date: Sat, 12 May 2018 00:19:26 +0800
Message-ID: <20180511161926.bboeiec6fjjrg2rk@gondor.apana.org.au>
References: <20180503122930.17448-1-mpe@ellerman.id.au>
 <20180503122930.17448-2-mpe@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, mhcerri@linux.vnet.ibm.com,
        pfsmorigo@linux.vnet.ibm.com
To: Michael Ellerman <mpe@ellerman.id.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180503122930.17448-2-mpe@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, May 03, 2018 at 10:29:30PM +1000, Michael Ellerman wrote:
> In p8_aes_xts_init() we do a printk(KERN_INFO ...) to report the
> fallback implementation we're using. However with a slow console this
> can significantly affect the speed of crypto operations. So remove it.
> 
> Fixes: c07f5d3da643 ("crypto: vmx - Adding support for XTS")
> Cc: stable@vger.kernel.org # v4.8+
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  drivers/crypto/vmx/aes_xts.c | 2 --
>  1 file changed, 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
