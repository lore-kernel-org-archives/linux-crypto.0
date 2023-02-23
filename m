Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742FBC636D7
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Feb 2023 09:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233966AbjBWJdB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Feb 2023 04:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbjBWJc5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2023 04:32:57 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5A44C2B;
        Thu, 23 Feb 2023 01:32:50 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pV7xe-00EopH-WC; Thu, 23 Feb 2023 17:32:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 23 Feb 2023 17:32:22 +0800
Date:   Thu, 23 Feb 2023 17:32:22 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Neal Liu <neal_liu@aspeedtech.com>
Cc:     Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: aspeed: add error handling if
 dmam_alloc_coherent() failed
Message-ID: <Y/cypg7zsGcs+szk@gondor.apana.org.au>
References: <20230223085830.605202-1-neal_liu@aspeedtech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223085830.605202-1-neal_liu@aspeedtech.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 23, 2023 at 04:58:30PM +0800, Neal Liu wrote:
> Since the acry_dev->buf_addr may be NULL, add error handling to
> prevent any additional access to avoid potential issues.
> 
> Signed-off-by: Neal Liu <neal_liu@aspeedtech.com>
> ---
>  drivers/crypto/aspeed/aspeed-acry.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/crypto/aspeed/aspeed-acry.c b/drivers/crypto/aspeed/aspeed-acry.c
> index 1f77ebd73489..85733e418c9e 100644
> --- a/drivers/crypto/aspeed/aspeed-acry.c
> +++ b/drivers/crypto/aspeed/aspeed-acry.c
> @@ -782,6 +782,11 @@ static int aspeed_acry_probe(struct platform_device *pdev)
>  	acry_dev->buf_addr = dmam_alloc_coherent(dev, ASPEED_ACRY_BUFF_SIZE,
>  						 &acry_dev->buf_dma_addr,
>  						 GFP_KERNEL);
> +	if (!acry_dev->buf_addr) {
> +		rc = -ENOMEM;
> +		goto err_engine_rsa_start;
> +	}
> +
>  	memzero_explicit(acry_dev->buf_addr, ASPEED_ACRY_BUFF_SIZE);

Please remove this memzero in a follow-up patch as
dmam_alloc_coherent returns memory that's already zeroed.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
