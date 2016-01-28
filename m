From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: algif_skcipher - fix async callback after
 skcipher convertion
Date: Thu, 28 Jan 2016 12:56:18 +0800
Message-ID: <20160128045618.GB7782@gondor.apana.org.au>
References: <20160127171350.32579.49931.stgit@tstruk-mobl1>
 <20160127171401.32579.42285.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160127171401.32579.42285.stgit@tstruk-mobl1>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jan 27, 2016 at 09:14:01AM -0800, Tadeusz Struk wrote:
> Before the skcipher conversion the async callback used the
> crypto_async_request directly as the ablkcipher_request.
> It wasn't quite correct, but it worked fine since the
> crypto_async_request *base was the first member of the ablkcipher_request
> struct. After the skcipher conversion it is not the case anymore and
> a proper cast helper needs to be used.
> 
> Cc: <stable@vger.kernel.org> # 4.4.x-
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  crypto/algif_skcipher.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index 38c1aa8..78529ce 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -100,11 +100,12 @@ static void skcipher_free_async_sgls(struct skcipher_async_req *sreq)
>  	kfree(sreq->tsg);
>  }
>  
> -static void skcipher_async_cb(struct crypto_async_request *req, int err)
> +static void skcipher_async_cb(struct crypto_async_request *_req, int err)

Please call it req_base or something similar.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
