Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6B6C25B4E
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Jan 2023 10:33:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjATKdZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Jan 2023 05:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjATKdZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Jan 2023 05:33:25 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD75B2D28;
        Fri, 20 Jan 2023 02:33:19 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pIohu-002BXi-0Q; Fri, 20 Jan 2023 18:33:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Jan 2023 18:33:14 +0800
Date:   Fri, 20 Jan 2023 18:33:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: Re: [PATCH] crypto: stm32/cryp: Use accelerated readsl/writesl
Message-ID: <Y8pt6rjuW0yXO0V6@gondor.apana.org.au>
References: <20230110194307.657918-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110194307.657918-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 10, 2023 at 08:43:07PM +0100, Linus Walleij wrote:
> When reading or writing crypto buffers the inner loops can
> be replaced with readsl and writesl which will on ARM result
> in a tight assembly loop, speeding up encryption/decryption
> a little bit. This optimization was in the Ux500 driver so
> let's carry it over to the STM32 driver.
> 
> Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
> Cc: Lionel Debieve <lionel.debieve@foss.st.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
>  drivers/crypto/stm32/stm32-cryp.c | 37 +++++++++----------------------
>  1 file changed, 11 insertions(+), 26 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
