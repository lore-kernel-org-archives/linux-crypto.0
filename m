Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF51C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Sep 2022 06:16:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiI3GQE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Sep 2022 02:16:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiI3GP0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Sep 2022 02:15:26 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7814A109502;
        Thu, 29 Sep 2022 23:15:18 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oe9Ib-00A54y-1i; Fri, 30 Sep 2022 16:15:02 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 30 Sep 2022 14:15:00 +0800
Date:   Fri, 30 Sep 2022 14:15:00 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     neal_liu@aspeedtech.com, davem@davemloft.net, joel@jms.id.au,
        andrew@aj.id.au, johnny_huang@aspeedtech.com,
        dphadke@linux.microsoft.com, linux-aspeed@lists.ozlabs.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] crypto: aspeed - Fix check for platform_get_irq()
 errors
Message-ID: <YzaJZBDyZioUf36l@gondor.apana.org.au>
References: <20220920032118.6440-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220920032118.6440-1-yuehaibing@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Sep 20, 2022 at 11:21:18AM +0800, YueHaibing wrote:
> The platform_get_irq() function returns negative on error and
> positive non-zero values on success. It never returns zero, but if it
> did then treat that as a success.
> 
> Also remove redundant dev_err() print as platform_get_irq() already
> prints an error.
> 
> Fixes: 108713a713c7 ("crypto: aspeed - Add HACE hash driver")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  drivers/crypto/aspeed/aspeed-hace.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
