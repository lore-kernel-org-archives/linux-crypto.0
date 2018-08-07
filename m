From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/9] crypto: add zbufsize() interface
Date: Tue, 7 Aug 2018 17:45:13 +0800
Message-ID: <20180807094513.vstt5dhbb7n6kvds@gondor.apana.org.au>
References: <20180802215118.17752-1-keescook@chromium.org>
 <20180802215118.17752-2-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Geliang Tang <geliangtang@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Haren Myneni <haren@us.ibm.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180802215118.17752-2-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 02, 2018 at 02:51:10PM -0700, Kees Cook wrote:
> When pstore was refactored to use the crypto compress API in:
> 
>   commit cb3bee0369bc ("pstore: Use crypto compress API")
> 
> nearly all the pstore-specific compression routines were replaced with
> the existing crypto compression API. One case remained: calculating the
> "worst case" compression sizes ahead of time so it could have a buffer
> preallocated for doing compression (which was called "zbufsize").
> 
> To make pstore fully algorithm-agnostic, the compression API needs to
> grow this functionality. This adds the interface to support querying the
> "worst case" estimate, with a new "zbufsize" routine that each compressor
> can implement. The per-compressor implementations come in later commits.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  crypto/compress.c                   |  9 +++++++++
>  include/crypto/internal/scompress.h | 11 +++++++++++
>  include/linux/crypto.h              | 12 ++++++++++++
>  3 files changed, 32 insertions(+)
> 
> diff --git a/crypto/compress.c b/crypto/compress.c
> index f2d522924a07..29a80bb3b9d3 100644
> --- a/crypto/compress.c
> +++ b/crypto/compress.c
> @@ -33,12 +33,21 @@ static int crypto_decompress(struct crypto_tfm *tfm,
>  	                                                   dlen);
>  }
>  
> +static int crypto_zbufsize(struct crypto_tfm *tfm,
> +			   unsigned int slen, unsigned int *dlen)
> +{
> +	if (!tfm->__crt_alg->cra_compress.coa_zbufsize)
> +		return -ENOTSUPP;
> +	return tfm->__crt_alg->cra_compress.coa_zbufsize(tfm, slen, dlen);
> +}

Please don't add new features to the old compress interface.  Any
new improvements should be added to scomp/acomp only.  Users who
need new features should be converted.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
