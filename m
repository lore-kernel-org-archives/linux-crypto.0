Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878A4C4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 07:11:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EA4B2072E
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 07:11:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J/cJnSdn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbgJBHLa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 03:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725948AbgJBHL3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 03:11:29 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9ECFC0613D0;
        Fri,  2 Oct 2020 00:11:28 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id j136so552009wmj.2;
        Fri, 02 Oct 2020 00:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=l/AslFcI8o0tIrBRAfurd9q83mHu1ImdAYZFQ7SBMck=;
        b=J/cJnSdnnm0K3mV2PTCGEBTi1lofC2iZq70FUtde1Hza28OCY1enutx2mZ5VfOiyJa
         TbavxFH4a8TVQFiB5FgnPdKyKGC6zwLl8NRjtxGKN1KchMQXGi2lX15Kw68CPgblMt2U
         2KnYm3aGn9tR3PPV6U/n9ekuebZ6hRc+SJu9SkUgTsQR5B5sFCpfhsnQRNbBPbzGqk0l
         CUDq1siUaDcdUUIrayNrxInva20WYdA2WyTrgY9y2ys7HUWNrC3pDgeVWP55kksQhMU3
         ih8HDpTQjKYpWZa2yQsYx+0TNurvLr0Dyvad1hVnS5DZATe3H7WhM+RMX/JHEO/OSzBQ
         HLIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=l/AslFcI8o0tIrBRAfurd9q83mHu1ImdAYZFQ7SBMck=;
        b=WwRaATx3T/INtCyFkrOYm9bao1AiyIS4CiLZLlakA5kKaoD7QE9/hkg4uCaeJ58xq9
         +TmNxgeSSG4DFt389wedIYRLXZc14SPJuotjayXYf9PWo4QS0IuS4W6xWqsxIbE8y9Fh
         VgiSzSkluPKJO++e4LUqP9OFn7/9JEyjwk8RJBV6VgM8eTgPYYmcgK5qlpDiEfFWgFKw
         wfD5LwoRvjWP7ej3glJNsw1y4A/oyvDwgiMFKT/dLzAohUjyKsiqRP6EkLaRKpYxjuoJ
         37s2dUBGKPB3CoQERQqpp1uVZCjsqLAdEyhHTFc/6ATuzpHUsPZ0nM2kr4TY1znP0d/y
         RKzg==
X-Gm-Message-State: AOAM5303g16qs9pAEnabiyiZ5qn68vAv4fpSeezIhNGeZETcP5zthBPO
        KCyCvrphywmFYdBQ1VdDchU=
X-Google-Smtp-Source: ABdhPJwyvwxJtDY4aUnKoug3IveaE7MWK3ZSR6SvTGzqrruMA1ENCGgT0YL5LI2l9eIjEr/hNj/pwQ==
X-Received: by 2002:a7b:c0c1:: with SMTP id s1mr1234143wmh.73.1601622687477;
        Fri, 02 Oct 2020 00:11:27 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id e13sm669646wre.60.2020.10.02.00.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 00:11:26 -0700 (PDT)
Date:   Fri, 2 Oct 2020 09:11:25 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] crypto: sun8i-ss - Fix memory leak in
 sun8i_ss_prng_generate()
Message-ID: <20201002071125.GA15586@Red>
References: <20200928175945.GA11320@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200928175945.GA11320@embeddedor>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Sep 28, 2020 at 12:59:45PM -0500, Gustavo A. R. Silva wrote:
> Set _err_ to the return error code -EFAULT before jumping to the new
> label err_d, so resources for _d_ can be released before returning
> from function sun8i_ss_prng_generate().
> 
> Addresses-Coverity-ID: 1497459 ("Resource leak")
> Fixes: ac2614d721de ("crypto: sun8i-ss - Add support for the PRNG")
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
> index 08a1473b2145..0573f6289e8b 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
> @@ -103,7 +103,8 @@ int sun8i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
>  	dma_iv = dma_map_single(ss->dev, ctx->seed, ctx->slen, DMA_TO_DEVICE);
>  	if (dma_mapping_error(ss->dev, dma_iv)) {
>  		dev_err(ss->dev, "Cannot DMA MAP IV\n");
> -		return -EFAULT;
> +		err = -EFAULT;
> +		goto err_d;
>  	}
>  
>  	dma_dst = dma_map_single(ss->dev, d, todo, DMA_FROM_DEVICE);
> @@ -160,7 +161,7 @@ int sun8i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
>  	dma_unmap_single(ss->dev, dma_dst, todo, DMA_FROM_DEVICE);
>  err_iv:
>  	dma_unmap_single(ss->dev, dma_iv, ctx->slen, DMA_TO_DEVICE);
> -
> +err_d:
>  	if (!err) {
>  		memcpy(dst, d, dlen);
>  		/* Update seed */
> -- 
> 2.27.0
> 

Hello

The label could be better placed just before the kfree.
In error case, there are no need to memzero the not used "d".

But a patch with it, was already sent to the ML.
Anyway if you fix it, you could add "Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>"

Regards
