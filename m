Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A433C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Feb 2022 02:47:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234474AbiBWCra (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Feb 2022 21:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237733AbiBWCrU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Feb 2022 21:47:20 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1E8193F5;
        Tue, 22 Feb 2022 18:46:15 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nMhfM-00060X-S4; Wed, 23 Feb 2022 13:46:10 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Feb 2022 14:46:08 +1200
Date:   Wed, 23 Feb 2022 14:46:08 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     mpm@selenic.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next] hwrng: core: Remove duplicated include in core.c
Message-ID: <YhWf8ANo+yyLpIYi@gondor.apana.org.au>
References: <20220215005505.80430-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220215005505.80430-1-yang.lee@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 15, 2022 at 08:55:05AM +0800, Yang Li wrote:
> Fix following includecheck warning:
> ./drivers/char/hw_random/core.c: linux/random.h is included more than
> once.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/char/hw_random/core.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index be2953aa5145..94626f533361 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -21,7 +21,6 @@
>  #include <linux/sched/signal.h>
>  #include <linux/miscdevice.h>
>  #include <linux/module.h>
> -#include <linux/random.h>

This file does not appear to have been included twice.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
