Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BC59C47096
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 12:30:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15B62610CB
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Jun 2021 12:30:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbhFCMcX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Jun 2021 08:32:23 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60890 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229966AbhFCMcX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Jun 2021 08:32:23 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lomUg-0001zr-3M; Thu, 03 Jun 2021 20:30:38 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lomUa-0001eU-Vf; Thu, 03 Jun 2021 20:30:33 +0800
Date:   Thu, 3 Jun 2021 20:30:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Corentin Labbe <clabbe@baylibre.com>,
        linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/3 v4] crypto: ixp4xx: convert to platform driver
Message-ID: <20210603123032.GE6161@gondor.apana.org.au>
References: <20210525083048.1113870-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525083048.1113870-1-linus.walleij@linaro.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 25, 2021 at 10:30:46AM +0200, Linus Walleij wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The ixp4xx_crypto driver traditionally registers a bare platform
> device without attaching it to a driver, and detects the hardware
> at module init time by reading an SoC specific hardware register.
> 
> Change this to the conventional method of registering the platform
> device from the platform code itself when the device is present,
> turning the module_init/module_exit functions into probe/release
> driver callbacks.
> 
> This enables compile-testing as well as potentially having ixp4xx
> coexist with other ARMv5 platforms in the same kernel in the future.
> 
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Tested-by: Corentin Labbe <clabbe@baylibre.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v3->v4:
> - No changes, just resending with the other patches.
> ChangeLog v2->v3:
> - No changes, just resending with the other patches.
> ChangeLog v1->v2:
> - Rebase on Corentin's patches in the cryptodev tree
> - Drop the compile test Kconfig, it will not compile for
>   anything not IXP4xx anyway because it needs the NPE and QMGR
>   to be compiled in and those only exist on IXP4xx.
> ---
>  arch/arm/mach-ixp4xx/common.c  | 26 ++++++++++++++++++++++++
>  drivers/crypto/ixp4xx_crypto.c | 37 ++++++++++++----------------------
>  2 files changed, 39 insertions(+), 24 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
