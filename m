Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859151718;
	Thu,  7 Dec 2023 20:05:31 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1rBS6u-008Icd-VH; Fri, 08 Dec 2023 12:05:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 Dec 2023 12:05:18 +0800
Date: Fri, 8 Dec 2023 12:05:18 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	davem@davemloft.net, conor.dooley@microchip.com,
	ebiggers@kernel.org, ardb@kernel.org, heiko@sntech.de,
	phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 05/13] crypto: simd - Update `walksize` in simd
 skcipher
Message-ID: <ZXKV/nLAQpUx6AX0@gondor.apana.org.au>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-6-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231127070703.1697-6-jerry.shih@sifive.com>

On Mon, Nov 27, 2023 at 03:06:55PM +0800, Jerry Shih wrote:
> The `walksize` assignment is missed in simd skcipher.
> 
> Signed-off-by: Jerry Shih <jerry.shih@sifive.com>
> ---
>  crypto/cryptd.c | 1 +
>  crypto/simd.c   | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/crypto/cryptd.c b/crypto/cryptd.c
> index bbcc368b6a55..253d13504ccb 100644
> --- a/crypto/cryptd.c
> +++ b/crypto/cryptd.c
> @@ -405,6 +405,7 @@ static int cryptd_create_skcipher(struct crypto_template *tmpl,
>  		(alg->base.cra_flags & CRYPTO_ALG_INTERNAL);
>  	inst->alg.ivsize = crypto_skcipher_alg_ivsize(alg);
>  	inst->alg.chunksize = crypto_skcipher_alg_chunksize(alg);
> +	inst->alg.walksize = crypto_skcipher_alg_walksize(alg);
>  	inst->alg.min_keysize = crypto_skcipher_alg_min_keysize(alg);
>  	inst->alg.max_keysize = crypto_skcipher_alg_max_keysize(alg);

Sorry but this patch doesn't apply any more now that we have
lskcipher.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
