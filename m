Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBC6C433ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 07:11:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFB88611ED
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 07:11:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbhEUHMe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 May 2021 03:12:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55504 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234228AbhEUHMe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 May 2021 03:12:34 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1ljzJN-0003wW-44; Fri, 21 May 2021 15:11:09 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1ljzJN-0005lP-0l; Fri, 21 May 2021 15:11:09 +0800
Date:   Fri, 21 May 2021 15:11:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Matt Mackall <mpm@selenic.com>,
        Deepak Saxena <dsaxena@plexity.net>,
        linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 5/5] hw_random: ixp4xx: Add OF support
Message-ID: <20210521071108.jcy7ypnl36bnzxj7@gondor.apana.org.au>
References: <20210511132928.814697-1-linus.walleij@linaro.org>
 <20210511132928.814697-5-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210511132928.814697-5-linus.walleij@linaro.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 11, 2021 at 03:29:28PM +0200, Linus Walleij wrote:
> This makes the hardware random number generator found in
> the IXP46x SoCs probe from the device tree.
> 
> Cc: Deepak Saxena <dsaxena@plexity.net>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> The idea is to apply this through the ARM SoC tree along
> with other IXP4xx refactorings.
> Please tell me if you prefer another solution.
> ---
>  drivers/char/hw_random/ixp4xx-rng.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
