From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH 3/4] crypto: bcm: Constify *hash_alg_name[]
Date: Fri, 09 Mar 2018 16:04:10 +0100
Message-ID: <0949d6d0-d62b-d724-f3ea-e7e86900fe3e@partner.samsung.com>
References: <1519768888-19866-1-git-send-email-hernan@vanguardiasur.com.ar>
        <CGME20180227220307epcas3p1ca4f0f8e178b7560f2105ca8b1bcef25@epcas3p1.samsung.com>
        <1519768888-19866-3-git-send-email-hernan@vanguardiasur.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: =?UTF-8?Q?Hern=c3=a1n_Gonzalez?= <hernan@vanguardiasur.com.ar>,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        steven.lin1@broadcom.com, arvind.yadav.cs@gmail.com,
        colin.king@canonical.com, raveendra.padasalagi@broadcom.com,
        ray.jui@broadcom.com, scott.branden@broadcom.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1519768888-19866-3-git-send-email-hernan@vanguardiasur.com.ar>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 27.02.2018 23:01, Hernán Gonzalez wrote:
> Note: This is compile only tested.
> No gain from this except some self-documenting.
> 
> Signed-off-by: Hernán Gonzalez <hernan@vanguardiasur.com.ar>
> ---
>  drivers/crypto/bcm/spu.c | 5 +++--
>  drivers/crypto/bcm/spu.h | 2 +-
>  2 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/bcm/spu.c b/drivers/crypto/bcm/spu.c
> index efaf3cf..c7bb79e 100644
> --- a/drivers/crypto/bcm/spu.c
> +++ b/drivers/crypto/bcm/spu.c
> @@ -23,8 +23,9 @@
>  #include "cipher.h"
>  
>  /* This array is based on the hash algo type supported in spu.h */
> -char *hash_alg_name[] = { "None", "md5", "sha1", "sha224", "sha256", "aes",

------------------------------------------------------------------------ ^^^

'aes' is not hash, so either remove 'aes' or change array name to crypto_alg_name

Or maybe I am missing something, or is it hardcoded in silicon ?

> -	"sha384", "sha512", "sha3_224", "sha3_256", "sha3_384", "sha3_512" };
> +char const * const hash_alg_name[] = { "None", "md5", "sha1", "sha224",
> +	"sha256", "aes", "sha384", "sha512", "sha3_224", "sha3_256", "sha3_384",
> +	"sha3_512" };
>  
>  /* Assumes SPU-M messages are in big endian */
>  void spum_dump_msg_hdr(u8 *buf, unsigned int buf_len)
> diff --git a/drivers/crypto/bcm/spu.h b/drivers/crypto/bcm/spu.h
> index f252367..71cf6b5 100644
> --- a/drivers/crypto/bcm/spu.h
> +++ b/drivers/crypto/bcm/spu.h
> @@ -111,7 +111,7 @@ enum aead_type {
>  	AEAD_TYPE_LAST
>  };
>  
> -extern char *hash_alg_name[HASH_ALG_LAST];
> +extern const char * const hash_alg_name[HASH_ALG_LAST];
>  
>  struct spu_request_opts {
>  	bool is_inbound;
> 

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
