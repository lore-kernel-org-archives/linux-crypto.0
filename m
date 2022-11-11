Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25DDEC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Nov 2022 10:18:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233493AbiKKKSr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Nov 2022 05:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbiKKKSI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Nov 2022 05:18:08 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC1A87B13;
        Fri, 11 Nov 2022 02:17:54 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1otR6V-00Cyuz-KW; Fri, 11 Nov 2022 18:17:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Nov 2022 18:17:43 +0800
Date:   Fri, 11 Nov 2022 18:17:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     clabbe@baylibre.com, davem@davemloft.net, heiko@sntech.de,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH -next v2] crypto: rockchip: Remove surplus dev_err() when
 using platform_get_irq()
Message-ID: <Y24hRzqzzJIHq37O@gondor.apana.org.au>
References: <20221104074527.37353-1-yang.lee@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221104074527.37353-1-yang.lee@linux.alibaba.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 04, 2022 at 03:45:27PM +0800, Yang Li wrote:
> There is no need to call the dev_err() function directly to print a
> custom message when handling an error from either the platform_get_irq()
> or platform_get_irq_byname() functions as both are going to display an
> appropriate error message in case of a failure.
> 
> ./drivers/crypto/rockchip/rk3288_crypto.c:351:2-9: line 351 is
> redundant because platform_get_irq() already prints an error
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2677
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
> 
> change in v2:
> --According to Corentin's suggestion, make the subject started by "crypto: rockchip:".
> 
>  drivers/crypto/rockchip/rk3288_crypto.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
