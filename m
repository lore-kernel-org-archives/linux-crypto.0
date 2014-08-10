From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: [PATCH 2/3] crypto: testmgr.c: white space removal on __test_skcipher
Date: Sun, 10 Aug 2014 11:57:19 +0300
Message-ID: <53E733EF.80003@freescale.com>
References: <53E496E4.9070207@freescale.com>
 <1407497272-9161-1-git-send-email-cristian.stoica@freescale.com>
 <1407497272-9161-2-git-send-email-cristian.stoica@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <linux-kernel@vger.kernel.org>,
	<davem@davemloft.net>
To: Cristian Stoica <cristian.stoica@freescale.com>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1407497272-9161-2-git-send-email-cristian.stoica@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 8/8/2014 2:27 PM, Cristian Stoica wrote:
> This patch inverts two if conditions to remove code blocks
> indentation. Several white space clean-ups follow.
> 
> Signed-off-by: Cristian Stoica <cristian.stoica@freescale.com>
> ---
>  crypto/testmgr.c | 283 ++++++++++++++++++++++++++-----------------------------
>  1 file changed, 136 insertions(+), 147 deletions(-)

Don't add more checkpatch warnings on top of existing ones.

> 
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index 51f47f2..36f45ff 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -974,73 +974,69 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
>  		else
>  			memset(iv, 0, MAX_IVLEN);
>  
> -		if (!(template[i].np) || (template[i].also_non_np)) {
> -			j++;
> +		if (template[i].np && !template[i].also_non_np)
> +			continue;
>  
> -			ret = -EINVAL;
> -			if (WARN_ON(align_offset + template[i].ilen >
> -				    PAGE_SIZE))
> -				goto out;
> +		j++;
>  
> -			data = xbuf[0];
> -			data += align_offset;
> -			memcpy(data, template[i].input, template[i].ilen);
> +		ret = -EINVAL;
> +		if (WARN_ON(align_offset + template[i].ilen > PAGE_SIZE))
> +			goto out;
>  
> -			crypto_ablkcipher_clear_flags(tfm, ~0);
> -			if (template[i].wk)
> -				crypto_ablkcipher_set_flags(
> -					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
> +		data = xbuf[0];
> +		data += align_offset;
> +		memcpy(data, template[i].input, template[i].ilen);
>  
> -			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
> -						       template[i].klen);
> -			if (!ret == template[i].fail) {
> -				pr_err("alg: skcipher%s: setkey failed on test %d for %s: flags=%x\n",
> -				       d, j, algo,
> -				       crypto_ablkcipher_get_flags(tfm));
> -				goto out;
> -			} else if (ret)
> -				continue;
> +		crypto_ablkcipher_clear_flags(tfm, ~0);
> +		if (template[i].wk)

WARNING: line over 80 characters
#58: FILE: crypto/testmgr.c:992:

> +			crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);

[...]

> @@ -1055,116 +1051,109 @@ static int __test_skcipher(struct crypto_ablkcipher *tfm, int enc,
>  		else
>  			memset(iv, 0, MAX_IVLEN);
>  
> -		if (template[i].np) {
> -			j++;
> +		if (!template[i].np)
> +			continue;
>  
> -			crypto_ablkcipher_clear_flags(tfm, ~0);
> -			if (template[i].wk)
> -				crypto_ablkcipher_set_flags(
> -					tfm, CRYPTO_TFM_REQ_WEAK_KEY);
> +		j++;
>  
> -			ret = crypto_ablkcipher_setkey(tfm, template[i].key,
> -						       template[i].klen);
> -			if (!ret == template[i].fail) {
> -				pr_err("alg: skcipher%s: setkey failed on chunk test %d for %s: flags=%x\n",
> -				       d, j, algo,
> -				       crypto_ablkcipher_get_flags(tfm));
> -				goto out;
> -			} else if (ret)
> -				continue;
> +		crypto_ablkcipher_clear_flags(tfm, ~0);
> +		if (template[i].wk)

WARNING: line over 80 characters
#170: FILE: crypto/testmgr.c:1061:

> +			crypto_ablkcipher_set_flags(tfm, CRYPTO_TFM_REQ_WEAK_KEY);

Thanks,
Horia
