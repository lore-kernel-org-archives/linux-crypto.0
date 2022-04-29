Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0054C433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Apr 2022 08:44:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348910AbiD2IsP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Apr 2022 04:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351140AbiD2IsO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Apr 2022 04:48:14 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B342EC400A
        for <linux-crypto@vger.kernel.org>; Fri, 29 Apr 2022 01:44:56 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nkMF2-008CAp-7E; Fri, 29 Apr 2022 18:44:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Apr 2022 16:44:44 +0800
Date:   Fri, 29 Apr 2022 16:44:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     Tudor Ambarus <tudor.ambarus@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: atmel - Avoid flush_scheduled_work() usage
Message-ID: <YmulfBqsSON47lDR@gondor.apana.org.au>
References: <35da6cb2-910f-f892-b27a-4a8bac9fd1b1@I-love.SAKURA.ne.jp>
 <Ymt4BfQXbXkY2qo0@gondor.apana.org.au>
 <5de198b9-7488-13e4-bf22-6c58c1c8b401@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5de198b9-7488-13e4-bf22-6c58c1c8b401@I-love.SAKURA.ne.jp>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 29, 2022 at 03:26:07PM +0900, Tetsuo Handa wrote:
>
> Since drivers/crypto/Makefile has lines in
> 
> obj-$(CONFIG_CRYPTO_DEV_ATMEL_I2C) += atmel-i2c.o
> obj-$(CONFIG_CRYPTO_DEV_ATMEL_ECC) += atmel-ecc.o
> obj-$(CONFIG_CRYPTO_DEV_ATMEL_SHA204A) += atmel-sha204a.o
> 
> order (which will be used as link order for built-in.o), module_init()
> is processed in this order. Also, module_exit() is no-op if built-in.
> Therefore, I think there is no need to explicitly boost the priority
> of atmel_i2c_init().

If we're going to rely on the Makefile ordering please make it
explicit and add a comment in the Makefile.  Otherwise this is way
too fragile.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
