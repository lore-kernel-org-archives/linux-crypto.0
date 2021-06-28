Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C709C48BC2
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jun 2021 03:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21EC361465
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jun 2021 03:32:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhF1Des (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jun 2021 23:34:48 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51018 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231933AbhF1Der (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jun 2021 23:34:47 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lxi0N-0001tZ-5x; Mon, 28 Jun 2021 11:32:15 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lxi0G-0002oI-TC; Mon, 28 Jun 2021 11:32:08 +0800
Date:   Mon, 28 Jun 2021 11:32:08 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Corentin Labbe <clabbe@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH 1/2] crypto: Typo s/Stormlink/Storlink/
Message-ID: <20210628033208.GC10694@gondor.apana.org.au>
References: <20210625132724.1165706-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210625132724.1165706-1-geert@linux-m68k.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 25, 2021 at 03:27:23PM +0200, Geert Uytterhoeven wrote:
> From: Geert Uytterhoeven <geert+renesas@glider.be>
> 
> According to Documentation/devicetree/bindings/arm/gemini.txt, the
> company was originally named "Storlink Semiconductor", and later renamed
> to "Storm Semiconductor".
> 
> Fixes: 46c5338db7bd45b2 ("crypto: sl3516 - Add sl3516 crypto engine")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/crypto/Kconfig                   | 2 +-
>  drivers/crypto/gemini/sl3516-ce-cipher.c | 2 +-
>  drivers/crypto/gemini/sl3516-ce-core.c   | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
