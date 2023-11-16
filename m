Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9863BD73;
	Wed, 15 Nov 2023 20:36:01 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1r3U6W-000CFS-Lr; Thu, 16 Nov 2023 12:35:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Nov 2023 12:35:56 +0800
Date: Thu, 16 Nov 2023 12:35:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: starfive - Pad adata with zeroes
Message-ID: <ZVWcLJOoLdElVsDd@gondor.apana.org.au>
References: <20231116021752.420680-1-jiajie.ho@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231116021752.420680-1-jiajie.ho@starfivetech.com>

On Thu, Nov 16, 2023 at 10:17:52AM +0800, Jia Jie Ho wrote:
>
> diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
> index 9378e6682f0e..e0fe599f8192 100644
> --- a/drivers/crypto/starfive/jh7110-aes.c
> +++ b/drivers/crypto/starfive/jh7110-aes.c
> @@ -500,7 +500,7 @@ static int starfive_aes_prepare_req(struct skcipher_request *req,
>  	scatterwalk_start(&cryp->out_walk, rctx->out_sg);
>  
>  	if (cryp->assoclen) {
> -		rctx->adata = kzalloc(ALIGN(cryp->assoclen, AES_BLOCK_SIZE), GFP_KERNEL);
> +		rctx->adata = kzalloc(cryp->assoclen + AES_BLOCK_SIZE, GFP_KERNEL);

Please explain why you're changing the allocation size here.

This needs to go into the patch description.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
