Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6124BE6
	for <linux-crypto@vger.kernel.org>; Sun,  3 Dec 2023 21:22:16 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
	by ex01.ufhost.com (Postfix) with ESMTP id CE56024E199;
	Mon,  4 Dec 2023 13:22:04 +0800 (CST)
Received: from EXMBX168.cuchost.com (172.16.6.78) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 4 Dec
 2023 13:22:04 +0800
Received: from [192.168.155.94] (202.188.176.82) by EXMBX168.cuchost.com
 (172.16.6.78) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 4 Dec
 2023 13:22:03 +0800
Message-ID: <0632d81e-724b-43b5-9aa5-6d9b69ba98f2@starfivetech.com>
Date: Mon, 4 Dec 2023 13:21:59 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 14/19] crypto: starfive - Remove cfb and ofb
To: Herbert Xu <herbert@gondor.apana.org.au>, Linux Crypto Mailing List
	<linux-crypto@vger.kernel.org>
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
 <E1r8g9J-005INy-8H@formenos.hmeau.com>
Content-Language: en-US
From: Jia Jie Ho <jiajie.ho@starfivetech.com>
In-Reply-To: <E1r8g9J-005INy-8H@formenos.hmeau.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX168.cuchost.com
 (172.16.6.78)
X-YovoleRuleAgent: yovoleflag

On 30/11/2023 8:28 pm, Herbert Xu wrote:
> Remove the unused CFB/OFB implementation.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  drivers/crypto/starfive/jh7110-aes.c |   62 -----------------------------------
>  1 file changed, 62 deletions(-)
> 
> diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
> index 9378e6682f0e..d1da9b366bbc 100644
> --- a/drivers/crypto/starfive/jh7110-aes.c
> +++ b/drivers/crypto/starfive/jh7110-aes.c
> @@ -783,26 +783,6 @@ static int starfive_aes_cbc_decrypt(struct skcipher_request *req)
>  	return starfive_aes_crypt(req, STARFIVE_AES_MODE_CBC);
>  }
>  
> -static int starfive_aes_cfb_encrypt(struct skcipher_request *req)
> -{
> -	return starfive_aes_crypt(req, STARFIVE_AES_MODE_CFB | FLG_ENCRYPT);
> -}
> -
> -static int starfive_aes_cfb_decrypt(struct skcipher_request *req)
> -{
> -	return starfive_aes_crypt(req, STARFIVE_AES_MODE_CFB);
> -}
> -
> -static int starfive_aes_ofb_encrypt(struct skcipher_request *req)
> -{
> -	return starfive_aes_crypt(req, STARFIVE_AES_MODE_OFB | FLG_ENCRYPT);
> -}
> -
> -static int starfive_aes_ofb_decrypt(struct skcipher_request *req)
> -{
> -	return starfive_aes_crypt(req, STARFIVE_AES_MODE_OFB);
> -}
> -
>  static int starfive_aes_ctr_encrypt(struct skcipher_request *req)
>  {
>  	return starfive_aes_crypt(req, STARFIVE_AES_MODE_CTR | FLG_ENCRYPT);
> @@ -908,48 +888,6 @@ static struct skcipher_engine_alg skcipher_algs[] = {
>  	.op = {
>  		.do_one_request = starfive_aes_do_one_req,
>  	},
> -}, {
> -	.base.init			= starfive_aes_init_tfm,
> -	.base.setkey			= starfive_aes_setkey,
> -	.base.encrypt			= starfive_aes_cfb_encrypt,
> -	.base.decrypt			= starfive_aes_cfb_decrypt,
> -	.base.min_keysize		= AES_MIN_KEY_SIZE,
> -	.base.max_keysize		= AES_MAX_KEY_SIZE,
> -	.base.ivsize			= AES_BLOCK_SIZE,
> -	.base.base = {
> -		.cra_name		= "cfb(aes)",
> -		.cra_driver_name	= "starfive-cfb-aes",
> -		.cra_priority		= 200,
> -		.cra_flags		= CRYPTO_ALG_ASYNC,
> -		.cra_blocksize		= 1,
> -		.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
> -		.cra_alignmask		= 0xf,
> -		.cra_module		= THIS_MODULE,
> -	},
> -	.op = {
> -		.do_one_request = starfive_aes_do_one_req,
> -	},
> -}, {
> -	.base.init			= starfive_aes_init_tfm,
> -	.base.setkey			= starfive_aes_setkey,
> -	.base.encrypt			= starfive_aes_ofb_encrypt,
> -	.base.decrypt			= starfive_aes_ofb_decrypt,
> -	.base.min_keysize		= AES_MIN_KEY_SIZE,
> -	.base.max_keysize		= AES_MAX_KEY_SIZE,
> -	.base.ivsize			= AES_BLOCK_SIZE,
> -	.base.base = {
> -		.cra_name		= "ofb(aes)",
> -		.cra_driver_name	= "starfive-ofb-aes",
> -		.cra_priority		= 200,
> -		.cra_flags		= CRYPTO_ALG_ASYNC,
> -		.cra_blocksize		= 1,
> -		.cra_ctxsize		= sizeof(struct starfive_cryp_ctx),
> -		.cra_alignmask		= 0xf,
> -		.cra_module		= THIS_MODULE,
> -	},
> -	.op = {
> -		.do_one_request = starfive_aes_do_one_req,
> -	},
>  },
>  };
>  
> 

Hi Herbert,
There are a few macros for ofb/cfb.
Could you please help include the following changes too?

diff --git a/drivers/crypto/starfive/jh7110-aes.c b/drivers/crypto/starfive/jh7110-aes.c
index be7fcd77b0f1..1ac15cc4ef3c 100644
--- a/drivers/crypto/starfive/jh7110-aes.c
+++ b/drivers/crypto/starfive/jh7110-aes.c
@@ -262,12 +262,7 @@ static int starfive_aes_hw_init(struct starfive_cryp_ctx *ctx)
 	rctx->csr.aes.mode  = hw_mode;
 	rctx->csr.aes.cmode = !is_encrypt(cryp);
 	rctx->csr.aes.ie = 1;
-
-	if (hw_mode == STARFIVE_AES_MODE_CFB ||
-	    hw_mode == STARFIVE_AES_MODE_OFB)
-		rctx->csr.aes.stmode = STARFIVE_AES_MODE_XFB_128;
-	else
-		rctx->csr.aes.stmode = STARFIVE_AES_MODE_XFB_1;
+	rctx->csr.aes.stmode = STARFIVE_AES_MODE_XFB_1;
 
 	if (cryp->side_chan) {
 		rctx->csr.aes.delay_aes = 1;
@@ -294,8 +289,6 @@ static int starfive_aes_hw_init(struct starfive_cryp_ctx *ctx)
 		starfive_aes_ccm_init(ctx);
 		starfive_aes_aead_hw_start(ctx, hw_mode);
 		break;
-	case STARFIVE_AES_MODE_OFB:
-	case STARFIVE_AES_MODE_CFB:
 	case STARFIVE_AES_MODE_CBC:
 	case STARFIVE_AES_MODE_CTR:
 		starfive_aes_write_iv(ctx, (void *)cryp->req.sreq->iv);
diff --git a/drivers/crypto/starfive/jh7110-cryp.h b/drivers/crypto/starfive/jh7110-cryp.h
index 8510f8c1f307..6cdf6db5d904 100644
--- a/drivers/crypto/starfive/jh7110-cryp.h
+++ b/drivers/crypto/starfive/jh7110-cryp.h
@@ -50,8 +50,6 @@ union starfive_aes_csr {
 		u32 ccm_start			:1;
 #define STARFIVE_AES_MODE_ECB			0x0
 #define STARFIVE_AES_MODE_CBC			0x1
-#define STARFIVE_AES_MODE_CFB			0x2
-#define STARFIVE_AES_MODE_OFB			0x3
 #define STARFIVE_AES_MODE_CTR			0x4
 #define STARFIVE_AES_MODE_CCM			0x5
 #define STARFIVE_AES_MODE_GCM			0x6

Thanks,
Jia Jie
