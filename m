Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65086C10F1B
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Dec 2022 11:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiLILI5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Dec 2022 06:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiLILI4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Dec 2022 06:08:56 -0500
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5469B3AC0A;
        Fri,  9 Dec 2022 03:08:55 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1p3bFJ-005glk-PB; Fri, 09 Dec 2022 19:08:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 09 Dec 2022 19:08:49 +0800
Date:   Fri, 9 Dec 2022 19:08:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>
Subject: Re: [PATCH v3 0/4] crypto: stm32 - reuse for Ux500
Message-ID: <Y5MXQSR7gd7xPUyC@gondor.apana.org.au>
References: <20221203091518.3235950-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221203091518.3235950-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Dec 03, 2022 at 10:15:14AM +0100, Linus Walleij wrote:
> Experimenting by taking some small portions of the Ux500
> CRYP driver and adding to the STM32 driver, it turns out
> we can support both platforms with the more modern STM32
> driver.
> 
> ChanegLog v2->v3:
> - Fix a kerneldoc warning.
> - Collect ACKs.
> ChangeLog v1->v2:
> - Minor changes to the base patches, see per-patch
>   ChangeLog.
> 
> Upsides:
> 
> - We delete ~2400 lines of code and 8 files with intact
>   crypto support for Ux500 and not properly maintained
>   and supported.
> 
> - The STM32 driver is more modern and compact thanks to
>   using things like the crypto engine.
> 
> Caveats:
> 
> - The STM32 driver does not support DMA. On the U8500
>   this only works with AES (DES support is broken with
>   DMA). If this is desired to be kept I can migrate
>   it to the STM32 driver as well.
> 
> I have looked at doing the same for the Ux500 hash, which
> is related but I am reluctant about this one, because
> the Ux500 hardware has no interrupt and only supports
> polling. I have a series of modernizations for that
> driver that I have worked on and will think about how
> to move forward.
> 
> 
> Linus Walleij (4):
>   dt-bindings: crypto: Let STM32 define Ux500 CRYP
>   crypto: stm32 - enable drivers to be used on Ux500
>   crypto: stm32/cryp - enable for use with Ux500
>   crypto: ux500/cryp - delete driver
> 
>  .../bindings/crypto/st,stm32-cryp.yaml        |   19 +
>  drivers/crypto/Makefile                       |    2 +-
>  drivers/crypto/stm32/Kconfig                  |    4 +-
>  drivers/crypto/stm32/stm32-cryp.c             |  413 ++++-
>  drivers/crypto/ux500/Kconfig                  |   10 -
>  drivers/crypto/ux500/Makefile                 |    1 -
>  drivers/crypto/ux500/cryp/Makefile            |   10 -
>  drivers/crypto/ux500/cryp/cryp.c              |  394 ----
>  drivers/crypto/ux500/cryp/cryp.h              |  315 ----
>  drivers/crypto/ux500/cryp/cryp_core.c         | 1600 -----------------
>  drivers/crypto/ux500/cryp/cryp_irq.c          |   45 -
>  drivers/crypto/ux500/cryp/cryp_irq.h          |   31 -
>  drivers/crypto/ux500/cryp/cryp_irqp.h         |  125 --
>  drivers/crypto/ux500/cryp/cryp_p.h            |  122 --
>  14 files changed, 344 insertions(+), 2747 deletions(-)
>  delete mode 100644 drivers/crypto/ux500/cryp/Makefile
>  delete mode 100644 drivers/crypto/ux500/cryp/cryp.c
>  delete mode 100644 drivers/crypto/ux500/cryp/cryp.h
>  delete mode 100644 drivers/crypto/ux500/cryp/cryp_core.c
>  delete mode 100644 drivers/crypto/ux500/cryp/cryp_irq.c
>  delete mode 100644 drivers/crypto/ux500/cryp/cryp_irq.h
>  delete mode 100644 drivers/crypto/ux500/cryp/cryp_irqp.h
>  delete mode 100644 drivers/crypto/ux500/cryp/cryp_p.h
> 
> -- 
> 2.38.1

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
