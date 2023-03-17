Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06D40C6FD1F
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Mar 2023 03:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjCQDE2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Mar 2023 23:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCQDE1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2023 23:04:27 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53DD3AAE;
        Thu, 16 Mar 2023 20:04:24 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pd0Nx-005aSb-HZ; Fri, 17 Mar 2023 11:04:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Mar 2023 11:04:05 +0800
Date:   Fri, 17 Mar 2023 11:04:05 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto - img-hash: Drop of_match_ptr for ID table
Message-ID: <ZBPYpYfd29YwN1Dy@gondor.apana.org.au>
References: <20230310223027.315954-1-krzysztof.kozlowski@linaro.org>
 <20230310223027.315954-2-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310223027.315954-2-krzysztof.kozlowski@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 10, 2023 at 11:30:27PM +0100, Krzysztof Kozlowski wrote:
>
> diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
> index fe93d19e3044..4e9a6660d791 100644
> --- a/drivers/crypto/img-hash.c
> +++ b/drivers/crypto/img-hash.c
> @@ -1106,7 +1106,7 @@ static struct platform_driver img_hash_driver = {
>  	.driver		= {
>  		.name	= "img-hash-accelerator",
>  		.pm	= &img_hash_pm_ops,
> -		.of_match_table	= of_match_ptr(img_hash_match),
> +		.of_match_table	= img_hash_match,

I think we should keep this because this driver doesn't explicitly
depend on OF.  Sure of_match_table is unconditionally defined but
I'd call that a bug instead of a feature :)

However, I would take this if you resend it with a Kconfig update
to add an explicit dependency on OF.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
