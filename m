From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Fix dma unmap direction in iMX sahara aes calculation
Date: Fri, 28 Jul 2017 17:57:45 +0800
Message-ID: <20170728095745.GA20566@gondor.apana.org.au>
References: <CACA-NJv69LnyR-xcJC8OU-_WRfg1Mtawq9UapswQczrdAonFDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mogens Lauridsen <mlauridsen171@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38046 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbdG1J5v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jul 2017 05:57:51 -0400
Content-Disposition: inline
In-Reply-To: <CACA-NJv69LnyR-xcJC8OU-_WRfg1Mtawq9UapswQczrdAonFDA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mogens Lauridsen <mlauridsen171@gmail.com> wrote:
> Hi,
> 
> The direction used in dma_unmap_sg in aes calc in sahara.c is wrong.
> This result in the cache not being invalidated correct when aes
> calculation is done and result is dma'ed to memory.
> This is seen as sporadic wrong result from aes calc.
> 
> Thanks,
> Mogens
> 
> Signed-off-by: Mogens Lauridsen <mlauridsen171@gmail.com>
> 
> diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
> index 1d9ecd3..9538c52 100644ae
> --- a/drivers/crypto/sahara.c
> +++ b/drivers/crypto/sahara.c
> @@ -543,10 +543,10 @@ static int sahara_hw_descriptor_create(struct sahara_dev *
> 
> unmap_out:
>        dma_unmap_sg(dev->device, dev->out_sg, dev->nb_out_sg,
> -               DMA_TO_DEVICE);
> +               DMA_FROM_DEVICE);

Your patch is space-damaged and does not apply.  Please send your
emails in a way that preserves white spaces.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
