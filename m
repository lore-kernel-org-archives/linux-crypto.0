Return-Path: <SRS0=CSIn=PT=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:33158 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728042AbfAKGJD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jan 2019 01:09:03 -0500
Date: Fri, 11 Jan 2019 14:08:59 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Zhou Wang <wangzhou1@hisilicon.com>
Cc: "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com, Shiju Jose <shiju.jose@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Hao Fang <fanghao11@huawei.com>
Subject: Re: [PATCH 3/4] crypto: hisilicon: Add HiSilicon ZIP accelerator
 support
Message-ID: <20190111060859.k647ltxukywjmi3l@gondor.apana.org.au>
References: <1545465105-133138-1-git-send-email-wangzhou1@hisilicon.com>
 <1545465105-133138-4-git-send-email-wangzhou1@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1545465105-133138-4-git-send-email-wangzhou1@hisilicon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 22, 2018 at 03:51:44PM +0800, Zhou Wang wrote:
>
> +static struct crypto_alg hisi_zip_zlib = {
> +	.cra_name		= "zlib-deflate",
> +	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
> +	.cra_ctxsize		= sizeof(struct hisi_zip_ctx),
> +	.cra_priority           = 300,
> +	.cra_module		= THIS_MODULE,
> +	.cra_init		= hisi_zip_alloc_comp_ctx,
> +	.cra_exit		= hisi_zip_free_comp_ctx,
> +	.cra_u			= {
> +		.compress = {
> +			.coa_compress	= hisi_zip_compress,
> +			.coa_decompress	= hisi_zip_decompress
> +		}
> +	}
> +};

Please do not add any new implementations using the compress
interface.  You should either use scomp or acomp depending on
whether your driver is synchronous or async.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
