From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 2/4] crypto: skcipher - Enforce non-ASYNC for on-stack
 requests
Date: Fri, 7 Sep 2018 11:42:42 +0800
Message-ID: <20180907034242.zhm4dglzkldhvh3x@gondor.apana.org.au>
References: <20180906225854.40989-1-keescook@chromium.org>
 <20180906225854.40989-3-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Arnaud Ebalard <arno@natisbad.org>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Christian Lamparter <chunkeey@gmail.com>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180906225854.40989-3-keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 06, 2018 at 03:58:52PM -0700, Kees Cook wrote:
>
> @@ -437,6 +442,12 @@ static inline struct crypto_skcipher *crypto_skcipher_reqtfm_check(
>  {
>  	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
>  
> +	if (req->__onstack) {
> +		if (WARN_ON(crypto_skcipher_alg(tfm)->base.cra_flags &
> +				CRYPTO_ALG_ASYNC))
> +			return ERR_PTR(-EINVAL);
> +	}

Sorry but I don't like imposing a run-time check on everybody when
stack-based requests are the odd ones out.  If we're going to make
this a run-time check (I'd much prefer a compile-time check, but I
understand that this may involve too much churn), then please do it
for stack-based request users only.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
