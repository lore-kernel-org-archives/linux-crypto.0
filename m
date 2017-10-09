From: walter harms <wharms@bfs.de>
Subject: Re: [PATCH 1/2] crypto: lrw - Fix an error handling path in 'create()'
Date: Mon, 09 Oct 2017 23:22:36 +0200
Message-ID: <59DBE89C.3090700@bfs.de>
References: <cover.1507445539.git.christophe.jaillet@wanadoo.fr> <53e4cc621176b8aeeb58e493b133be853c66ef49.1507445539.git.christophe.jaillet@wanadoo.fr>
Reply-To: wharms@bfs.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <53e4cc621176b8aeeb58e493b133be853c66ef49.1507445539.git.christophe.jaillet@wanadoo.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



Am 08.10.2017 11:39, schrieb Christophe JAILLET:
> All error handling paths 'goto err_drop_spawn' except this one.
> In order to avoid some resources leak, we should do it as well here.
> 
> Fixes: 700cb3f5fe75 ("crypto: lrw - Convert to skcipher")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  crypto/lrw.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/crypto/lrw.c b/crypto/lrw.c
> index a8bfae4451bf..eb681e9fe574 100644
> --- a/crypto/lrw.c
> +++ b/crypto/lrw.c
> @@ -610,8 +610,10 @@ static int create(struct crypto_template *tmpl, struct rtattr **tb)
>  		ecb_name[len - 1] = 0;
>  
>  		if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
> -			     "lrw(%s)", ecb_name) >= CRYPTO_MAX_ALG_NAME)

	this check can be done more easy,
	the length of ecb_name is len
	the length of inst->alg.base.cra_name is CRYPTO_MAX_ALG_NAME
	if CRYPTO_MAX_ALG_NAME-len < "lrw()" < 5
		no need to involve snprintf()

	just my 2 cents
	re,
 		wh

> -			return -ENAMETOOLONG;
> +			     "lrw(%s)", ecb_name) >= CRYPTO_MAX_ALG_NAME) {
> +			err = -ENAMETOOLONG;
> +			goto err_drop_spawn;
> +		}
>  	}
>  
>  	inst->alg.base.cra_flags = alg->base.cra_flags & CRYPTO_ALG_ASYNC;
