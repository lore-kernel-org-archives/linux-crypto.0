Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307F2ECAAD5
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Sep 2022 10:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231310AbiIBKOn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Sep 2022 06:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232619AbiIBKOT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Sep 2022 06:14:19 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36633C1A;
        Fri,  2 Sep 2022 03:14:17 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1oU3gT-000KYi-9s; Fri, 02 Sep 2022 20:13:58 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Sep 2022 18:13:57 +0800
Date:   Fri, 2 Sep 2022 18:13:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jack Wang <jinpu.wang@ionos.com>
Cc:     linux-crypto@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] crypto: gemin: Fix error check for dma_map_sg
Message-ID: <YxHXZbKnfe+5pIYz@gondor.apana.org.au>
References: <20220825072421.29020-1-jinpu.wang@ionos.com>
 <20220825072421.29020-2-jinpu.wang@ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220825072421.29020-2-jinpu.wang@ionos.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 25, 2022 at 09:24:16AM +0200, Jack Wang wrote:
> dma_map_sg return 0 on error.
> 
> Cc: Corentin Labbe <clabbe@baylibre.com>
> Cc: Hans Ulli Kroll <ulli.kroll@googlemail.com>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Fixes: 46c5338db7bd ("crypto: sl3516 - Add sl3516 crypto engine")
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
>  drivers/crypto/gemini/sl3516-ce-cipher.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/gemini/sl3516-ce-cipher.c b/drivers/crypto/gemini/sl3516-ce-cipher.c
> index 14d0d83d388d..34fea8aa91b6 100644
> --- a/drivers/crypto/gemini/sl3516-ce-cipher.c
> +++ b/drivers/crypto/gemini/sl3516-ce-cipher.c
> @@ -149,7 +149,7 @@ static int sl3516_ce_cipher(struct skcipher_request *areq)
>  	if (areq->src == areq->dst) {
>  		nr_sgs = dma_map_sg(ce->dev, areq->src, sg_nents(areq->src),
>  				    DMA_BIDIRECTIONAL);
> -		if (nr_sgs <= 0 || nr_sgs > MAXDESC / 2) {
> +		if (!nr_sgs || nr_sgs > MAXDESC / 2) {
>  			dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
>  			err = -EINVAL;
>  			goto theend;

The original code is correct and this patch is arguably making it
less robust.  So I'll drop this particular patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
