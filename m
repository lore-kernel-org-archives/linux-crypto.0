From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: Re: [BUG] crypto: atmel-aes - erro when compiling with VERBOSE_DEBUG
 enable
Date: Tue, 27 Sep 2016 18:45:18 +0200
Message-ID: <de4c3d75-eb4f-f29b-5bde-e2b5ee79c8d9@atmel.com>
References: <20160922092629.GA5508@gondor.apana.org.au>
 <1474548357.12981.19.camel@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: <linux-crypto@vger.kernel.org>
To: levent demir <levent.demir@inria.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:14216 "EHLO
        eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933841AbcI0QpW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 27 Sep 2016 12:45:22 -0400
In-Reply-To: <1474548357.12981.19.camel@inria.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Levent,

there is a typo in the subject line: erroR.
Also it would be better to start the summary phrase of the subject line with a
verb:

crypto: atmel-aes: fix compiler error when VERBODE_DEBUG is defined

Le 22/09/2016 à 14:45, levent demir a écrit :
> Fix debug function call in atmel_aes_write
> 
> Signed-off-by: Levent DEMIR <levent.demir@inria.fr>
> ---
>  drivers/crypto/atmel-aes.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/atmel-aes.c b/drivers/crypto/atmel-aes.c
> index e3d40a8..2b0f926 100644
> --- a/drivers/crypto/atmel-aes.c
> +++ b/drivers/crypto/atmel-aes.c
> @@ -317,7 +317,7 @@ static inline void atmel_aes_write(struct
> atmel_aes_dev *dd,
>  		char tmp[16];
>  
>  		dev_vdbg(dd->dev, "write 0x%08x into %s\n", value,
> -			 atmel_aes_reg_name(offset, tmp));
> +			atmel_aes_reg_name(offset, tmp, sizeof(tmp)));
It looks like a space has been removed.

>  	}
>  #endif /* VERBOSE_DEBUG */
>  
> 


Best regards,

Cyrille
