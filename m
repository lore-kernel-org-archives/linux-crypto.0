Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABC9C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Mar 2022 02:53:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbiCNCzE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 13 Mar 2022 22:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbiCNCzE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 13 Mar 2022 22:55:04 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769193A723;
        Sun, 13 Mar 2022 19:53:55 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nTaqB-0003Aw-KF; Mon, 14 Mar 2022 13:53:48 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 14 Mar 2022 14:53:47 +1200
Date:   Mon, 14 Mar 2022 14:53:47 +1200
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     Matt Mackall <mpm@selenic.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwrng: nomadik: Change clk_disable to
 clk_disable_unprepare
Message-ID: <Yi6uOygG1Egb1GVt@gondor.apana.org.au>
References: <20220307110728.15635-1-linmq006@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307110728.15635-1-linmq006@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 07, 2022 at 11:07:24AM +0000, Miaoqian Lin wrote:
> The corresponding API for clk_prepare_enable is clk_disable_unprepare,
> other than clk_disable_unprepare.
> 
> Fix this by changing clk_disable to clk_disable_unprepare.
> 
> Fixes: beca35d05cc2 ("hwrng: nomadik - use clk_prepare_enable()")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> ---
>  drivers/char/hw_random/nomadik-rng.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
