Return-Path: <SRS0=FsAa=P2=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:34072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726834AbfARC6D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Jan 2019 21:58:03 -0500
Date: Thu, 17 Jan 2019 18:58:01 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, ard.biesheuvel@linaro.org,
        jonathan.cameron@huawei.com
Subject: Re: [PATCH V2 4/5] crypto: ctr - use template array registering API
 to simplify the code
Message-ID: <20190118025800.GB737@sol.localdomain>
References: <1547707683-45878-1-git-send-email-wangxiongfeng2@huawei.com>
 <1547707683-45878-5-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547707683-45878-5-git-send-email-wangxiongfeng2@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 17, 2019 at 02:48:02PM +0800, Xiongfeng Wang wrote:
> Use crypto template array registering API to simplify the code.
> 
> Signed-off-by: Xiongfeng Wang <xiongfeng.wang@linaro.org>
> ---
>  crypto/ctr.c | 43 +++++++++++++++----------------------------
>  1 file changed, 15 insertions(+), 28 deletions(-)
> 
> diff --git a/crypto/ctr.c b/crypto/ctr.c
> index 4c743a9..d9f9d65 100644
> --- a/crypto/ctr.c
> +++ b/crypto/ctr.c
> @@ -171,12 +171,6 @@ static int crypto_ctr_create(struct crypto_template *tmpl, struct rtattr **tb)
>  	return err;
>  }
>  
> -static struct crypto_template crypto_ctr_tmpl = {
> -	.name = "ctr",
> -	.create = crypto_ctr_create,
> -	.module = THIS_MODULE,
> -};
> -
>  static int crypto_rfc3686_setkey(struct crypto_skcipher *parent,
>  				 const u8 *key, unsigned int keylen)
>  {
> @@ -366,36 +360,29 @@ static int crypto_rfc3686_create(struct crypto_template *tmpl,
>  	goto out;
>  }
>  
> -static struct crypto_template crypto_rfc3686_tmpl = {
> -	.name = "rfc3686",
> -	.create = crypto_rfc3686_create,
> -	.module = THIS_MODULE,
> +static struct crypto_template crypto_ctr_tmpls[] = {
> +	{
> +		.name = "ctr",
> +		.create = crypto_ctr_create,
> +		.module = THIS_MODULE,
> +	}, {
> +		.name = "rfc3686",
> +		.create = crypto_rfc3686_create,
> +		.module = THIS_MODULE,
> +	},
>  };
>  
> +

If you resend please also remove the extra blank line here.

- Eric
