Return-Path: <SRS0=7GLU=YC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487E1C47404
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Oct 2019 12:13:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 149C0206BB
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Oct 2019 12:13:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729575AbfJIMNx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Oct 2019 08:13:53 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:33569 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727219AbfJIMNx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Oct 2019 08:13:53 -0400
X-Originating-IP: 86.250.200.211
Received: from localhost (lfbn-1-17395-211.w86-250.abo.wanadoo.fr [86.250.200.211])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id D87CD1BF209;
        Wed,  9 Oct 2019 12:13:50 +0000 (UTC)
Date:   Wed, 9 Oct 2019 14:13:49 +0200
From:   Antoine Tenart <antoine.tenart@bootlin.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Antoine Tenart <antoine.tenart@bootlin.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] crypto: Use PTR_ERR_OR_ZERO in
 safexcel_xcbcmac_cra_init()
Message-ID: <20191009121349.GA2969@kwain>
References: <20191009120621.45834-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191009120621.45834-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 09, 2019 at 12:06:21PM +0000, YueHaibing wrote:
> Use PTR_ERR_OR_ZERO rather than if(IS_ERR(...)) + PTR_ERR
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Antoine Tenart <antoine.tenart@ack.tf>

Thanks,
Antoine

> ---
>  drivers/crypto/inside-secure/safexcel_hash.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
> index 85c3a075f283..a07a2915fab1 100644
> --- a/drivers/crypto/inside-secure/safexcel_hash.c
> +++ b/drivers/crypto/inside-secure/safexcel_hash.c
> @@ -2109,10 +2109,7 @@ static int safexcel_xcbcmac_cra_init(struct crypto_tfm *tfm)
>  
>  	safexcel_ahash_cra_init(tfm);
>  	ctx->kaes = crypto_alloc_cipher("aes", 0, 0);
> -	if (IS_ERR(ctx->kaes))
> -		return PTR_ERR(ctx->kaes);
> -
> -	return 0;
> +	return PTR_ERR_OR_ZERO(ctx->kaes);
>  }
>  
>  static void safexcel_xcbcmac_cra_exit(struct crypto_tfm *tfm)
> 
> 
> 
> 
> 

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
