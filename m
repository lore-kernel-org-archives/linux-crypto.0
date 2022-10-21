Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718C6C4332F
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Oct 2022 11:38:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiJULiG (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Oct 2022 07:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiJULiF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Oct 2022 07:38:05 -0400
Received: from formenos.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A318BE2D4;
        Fri, 21 Oct 2022 04:38:04 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1olqKy-004dy3-8g; Fri, 21 Oct 2022 19:37:53 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Oct 2022 19:37:52 +0800
Date:   Fri, 21 Oct 2022 19:37:52 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-mediatek@lists.infradead.org,
        "Mingming.Su" <Mingming.Su@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Olivia Mackall <olivia@selenic.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>
Subject: Re: [PATCH] hwrng: mediatek: add mt7986 support
Message-ID: <Y1KEkFvOu3f2Lu3k@gondor.apana.org.au>
References: <20221008164553.113260-1-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221008164553.113260-1-linux@fw-web.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Oct 08, 2022 at 06:45:53PM +0200, Frank Wunderlich wrote:
> From: "Mingming.Su" <Mingming.Su@mediatek.com>
> 
> 1. Add trng compatible name for MT7986
> 2. Fix mtk_rng_wait_ready() function
> 
> Signed-off-by: Mingming.Su <Mingming.Su@mediatek.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---
>  drivers/char/hw_random/mtk-rng.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
