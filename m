Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73F5BC433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Feb 2022 04:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379296AbiBEEDU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Feb 2022 23:03:20 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33954 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1379299AbiBEEDT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Feb 2022 23:03:19 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nGCI3-0001kj-W9; Sat, 05 Feb 2022 15:03:13 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 05 Feb 2022 15:03:11 +1100
Date:   Sat, 5 Feb 2022 15:03:11 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: engine: disable BH during completion
Message-ID: <Yf32/7Vi/Y7VtE3/@gondor.apana.org.au>
References: <20220127133332.4011509-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127133332.4011509-1-clabbe@baylibre.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 27, 2022 at 01:33:32PM +0000, Corentin Labbe wrote:
> When doing iperf over ipsec with crypto hardware sun8i-ce, I hit some
> spinlock recursion bug.
> 
> This is due to crypto/crypto_engine not disabling BH when calling
> completion function.
> 
> Fixes: 735d37b5424b ("crypto: engine - Introduce the block request crypto engine framework")
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
>  crypto/crypto_engine.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
> index fb07da9920ee..b3844f6d98a3 100644
> --- a/crypto/crypto_engine.c
> +++ b/crypto/crypto_engine.c
> @@ -7,6 +7,7 @@
>   * Author: Baolin Wang <baolin.wang@linaro.org>
>   */
>  
> +#include <linux/bottom_half.h>
>  #include <linux/err.h>
>  #include <linux/delay.h>
>  #include <linux/device.h>
> @@ -53,7 +54,9 @@ static void crypto_finalize_request(struct crypto_engine *engine,
>  				dev_err(engine->dev, "failed to unprepare request\n");
>  		}
>  	}
> +	local_bh_disable();
>  	req->complete(req, err);
> +	local_bh_enable();

Most other drivers call this function in softirq context.  In
general crypto API callback functions expect to be called in softirq
context.

So I think we should fix the driver to do the bh disable instead.

However, it's probably a good idea to add a check in this spot to
detect drivers that are calling this in the wrong context, e.g.,
lockdep_assert_in_softirq().

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
