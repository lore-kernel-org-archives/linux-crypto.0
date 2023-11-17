Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E73131;
	Fri, 17 Nov 2023 02:29:02 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3w5k-000bqL-KA; Fri, 17 Nov 2023 18:28:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Nov 2023 18:29:00 +0800
Date: Fri, 17 Nov 2023 18:29:00 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Chen Ni <nichen@iscas.ac.cn>
Cc: davem@davemloft.net, t-kristo@ti.com, j-keerthy@ti.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	nichen@iscas.ac.cn
Subject: Re: [PATCH] crypto: sa2ul - Add check for crypto_aead_setkey
Message-ID: <ZVdAbHSItfzhl++h@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231107063152.529830-1-nichen@iscas.ac.cn>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Chen Ni <nichen@iscas.ac.cn> wrote:
> Add check for crypto_aead_setkey() and return the error if it fails
> in order to transfer the error.
> 
> Fixes: d2c8ac187fc9 ("crypto: sa2ul - Add AEAD algorithm support")
> Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
> ---
> drivers/crypto/sa2ul.c | 5 ++++-
> 1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
> index 6846a8429574..6bac2382e261 100644
> --- a/drivers/crypto/sa2ul.c
> +++ b/drivers/crypto/sa2ul.c
> @@ -1806,6 +1806,7 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
>        int cmdl_len;
>        struct sa_cmdl_cfg cfg;
>        int key_idx;
> +       int error;
> 
>        if (crypto_authenc_extractkeys(&keys, key, keylen) != 0)
>                return -EINVAL;
> @@ -1869,7 +1870,9 @@ static int sa_aead_setkey(struct crypto_aead *authenc,
>        crypto_aead_set_flags(ctx->fallback.aead,
>                              crypto_aead_get_flags(authenc) &
>                              CRYPTO_TFM_REQ_MASK);
> -       crypto_aead_setkey(ctx->fallback.aead, key, keylen);
> +       error = crypto_aead_setkey(ctx->fallback.aead, key, keylen);
> +       if (error)
> +               return error;

This should be

	return crypto_aead_setkey(ctx->fallback.aead, key, keylen);

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
