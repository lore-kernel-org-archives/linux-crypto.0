Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1597DC001B0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Aug 2023 11:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236434AbjHKL2t (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Aug 2023 07:28:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236416AbjHKL2s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Aug 2023 07:28:48 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF34E62
        for <linux-crypto@vger.kernel.org>; Fri, 11 Aug 2023 04:28:47 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qUQJo-00247f-Ck; Fri, 11 Aug 2023 19:28:37 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 11 Aug 2023 19:28:36 +0800
Date:   Fri, 11 Aug 2023 19:28:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Bourgoin <thomas.bourgoin@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        linux-crypto@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de
Subject: Re: [PATCH 0/3] stm32/hash - Convert to platform remove callback
 returning void
Message-ID: <ZNYbZNe+oJDMov2w@gondor.apana.org.au>
References: <20230731165456.799784-1-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230731165456.799784-1-u.kleine-koenig@pengutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 31, 2023 at 06:54:53PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> this patch series converts the stm32-hash driver to use .remove_new. The
> first patch is a fix that could be backported to stable, but it's not
> very urgent. It's only problematic if such a device is unbound (which
> happens rarely) and then clk_prepare_enable() fails. Up to you if you
> want to tag it as stable material.
> 
> The overall goal is to reduce the number of drivers using the irritating
> .remove() callback by one. See the commit log of the third patch for the
> reasoning.
> 
> Best regards
> Uwe
> 
> Uwe Kleine-König (3):
>   crypto: stm32/hash - Properly handle pm_runtime_get failing
>   crypto: stm32/hash - Drop if block with always false condition
>   crypto: stm32/hash - Convert to platform remove callback returning
>     void
> 
>  drivers/crypto/stm32/stm32-hash.c | 19 ++++++-------------
>  1 file changed, 6 insertions(+), 13 deletions(-)
> 
> base-commit: 3de0152bf26ff0c5083ef831ba7676fc4c92e63a
> -- 
> 2.39.2

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
