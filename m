From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [RFC PATCH v2 3/4] crypto: dh - allow user to provide NULL privkey
Date: Sun, 28 May 2017 20:50:56 +0200
Message-ID: <6992577.D3h0M6ydbr@positron.chronox.de>
References: <1495034813-27143-1-git-send-email-tudor.ambarus@microchip.com> <1495034813-27143-4-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, marcel@holtmann.org,
        Nicolas.Ferre@microchip.com
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:59722 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750797AbdE1SvB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 May 2017 14:51:01 -0400
In-Reply-To: <1495034813-27143-4-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 17. Mai 2017, 17:26:52 CEST schrieb Tudor Ambarus:

Hi Tudor,

> If the user provides a NULL private key, the kernel will
> generate it and further use it for dh.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
> ---
>  crypto/dh.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/crypto/dh.c b/crypto/dh.c
> index 87e3542..7b4ac5b 100644
> --- a/crypto/dh.c
> +++ b/crypto/dh.c
> @@ -83,7 +83,9 @@ static int dh_set_secret(struct crypto_kpp *tfm, const
> void *buf, unsigned int len)
>  {
>  	struct dh_ctx *ctx = dh_get_ctx(tfm);
> +	u8 *rndbuf = NULL;
>  	struct dh params;
> +	int maxsize;
> 
>  	if (crypto_dh_decode_key(buf, len, &params) < 0)
>  		return -EINVAL;
> @@ -91,7 +93,26 @@ static int dh_set_secret(struct crypto_kpp *tfm, const
> void *buf, if (dh_set_params(ctx, &params) < 0)
>  		return -EINVAL;
> 
> +	if (!params.key || !params.key_size) {
> +		maxsize = crypto_kpp_maxsize(tfm);
> +		if (maxsize < 0) {
> +			dh_clear_params(ctx);
> +			return maxsize;
> +		}
> +
> +		rndbuf = kmalloc(maxsize, GFP_KERNEL);
> +		if (!rndbuf) {
> +			dh_clear_params(ctx);
> +			return -ENOMEM;
> +		}
> +
> +		get_random_bytes(rndbuf, maxsize);

Could you please use again the kernel crypto API RNG as mentioned for ECC?


> +		params.key = rndbuf;
> +		params.key_size = maxsize;
> +	}
> +
>  	ctx->xa = mpi_read_raw_data(params.key, params.key_size);
> +	kzfree(rndbuf);
>  	if (!ctx->xa) {
>  		dh_clear_params(ctx);
>  		return -EINVAL;


Ciao
Stephan
