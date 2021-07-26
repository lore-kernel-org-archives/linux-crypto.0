Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A030C4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 08:29:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8288A60F48
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 08:29:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbhGZHsp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jul 2021 03:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232279AbhGZHso (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jul 2021 03:48:44 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D285FC061757;
        Mon, 26 Jul 2021 01:29:12 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id j2so9994430wrx.9;
        Mon, 26 Jul 2021 01:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=n22KqpPAazgSksARsAU/X44h7JM3fyV54ywJMdrH1Wg=;
        b=MQOyJgGP3H0Qwd3EZsdIBT7b6O/W9S9SsA0h4t425dME6/6e1ft+IXDbzCuMfqbFbs
         uhN3HGZ2DvMHJQaNwadAe6kkc3PkMqa9J/Edh68+Kju0Yu/Qdiu1I2/FcJzqWQkReyUA
         6vZUAD+4dz6ULTV+vxYPsQCBQ2JZQx62BtW2i3ZmxVz+0OPneDsy5PxoblS+7oyRAvGk
         bV0Hp5E1HFrpiQ1cNi0159EnMdwHd6e4BO5mkG52bqcFmuRTRN48QQ/BmPPsZKZkfHEa
         qpNTxXTtO+RBNQAOJ41TX3QuYN9yHP4SGv/gB0SR6827E6Zzy3OraznJCGsmBqPALV7q
         Hqog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=n22KqpPAazgSksARsAU/X44h7JM3fyV54ywJMdrH1Wg=;
        b=Klrw7nHIgWJNXSRD3Qa4fTBS9JKS1MlD5Duu31rS1VO1K6QvpAPXhgNA9H7JoOZNHL
         GpFfYcY6C6hu5X05WAZH51IsRJtyCSYnSWAqYLR2a2cO90Mvt7VUhjUjruaHCFnNWwAZ
         Tn11wJs2ltbi+S4885X6DkWze3l2sTQx4JjK2r5eYyrmOi7/JVrZofqr7xd8FxEBTHTa
         AZ0B6KKoNmgEPFJfLuraZzwRTcmceQZvVmHKPwFlC+eMCFNamU/oLpK1KJYVSGMJT11T
         ByzKhKr6wcvciJxt4/X81YK0+UcoZY7eVADvNOCNSAVNOWL+cXknOW7dycUsQMCG+hcQ
         Masw==
X-Gm-Message-State: AOAM532w+OxxTv902TgCAmZI51nU3R/xKn6FxHQGqyPRk7NeK/7W4R/1
        3Agm84K2SbDYjG1irxDh+o0=
X-Google-Smtp-Source: ABdhPJx2CObKDuRvwR8Y7nZ6jwmf6jEfBwMYvNyPgZtIdXaevpTVTg7oe+aKZLOi/9UY6KXdvGlUgA==
X-Received: by 2002:a5d:4527:: with SMTP id j7mr17958282wra.137.1627288151479;
        Mon, 26 Jul 2021 01:29:11 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id l39sm9877874wms.1.2021.07.26.01.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 01:29:11 -0700 (PDT)
Date:   Mon, 26 Jul 2021 10:29:08 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: sun8i-ce: fix memory leak and return value of
 sun8i_ce_hash_run
Message-ID: <YP5yVIVTmNM7yMLZ@Red>
References: <20210726075957.2231287-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210726075957.2231287-1-mudongliangabcd@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Mon, Jul 26, 2021 at 03:59:36PM +0800, Dongliang Mu a écrit :
> This patch fixes some memory leak caused by dma_mmap_sg/single
> in the error handling code. In addition, it fixes the return value
> when errors related with dma_mmap_sg/single occur.
> 

Hello

"some" is too imprecise, exactly which allocation is leaked ?
In fact it will be easier to say that all dma_map_xx are leaked, I just saw that my code is really bad.

Furthermore, you should have two fixes, one for the memory leak, one for the error code.

But for the error code, I am not sure it is needed, error code is already given to user via crypto_finalize_hash_request().
The "return 0" is for crypto/crypto_engine API, returning an error will not change anything since we dont have retry_support.

So I propose you to focus on dma_map_xxx() fix patch.

> Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>

"Reported-by:" is for credit when someone else give you informations.

> Fixes: 732b764099f65 ("crypto: sun8i-ce - fix two error path's memory leak")
This is not the patch which introduces the problem, the problem is from the beginning ("crypto: sun8i-ss - support hash algorithms")

> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
> v1->v2: move crypto_finalize_hash_request to the end of function; move
> the memcpy after the dma_mmap_sg/single functions. 
>  .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 28 +++++++++----------
>  1 file changed, 14 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
> index 3c073eb3db03..fe5db3c84754 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
> @@ -324,11 +324,10 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
>  	struct sun8i_ss_alg_template *algt;
>  	struct sun8i_ss_dev *ss;
>  	struct scatterlist *sg;
> -	int nr_sgs, err, digestsize;
> +	int j, i, todo, nr_sgs, digestsize, err;
>  	unsigned int len;
>  	u64 fill, min_fill, byte_count;
>  	void *pad, *result;
> -	int j, i, todo;

This is a change unrelated with the subject.

>  	__be64 *bebits;
>  	__le64 *lebits;
>  	dma_addr_t addr_res, addr_pad;
> @@ -368,14 +367,14 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
>  	if (nr_sgs <= 0 || nr_sgs > MAX_SG) {
>  		dev_err(ss->dev, "Invalid sg number %d\n", nr_sgs);
>  		err = -EINVAL;
> -		goto theend;
> +		goto err_result;
>  	}
>  
>  	addr_res = dma_map_single(ss->dev, result, digestsize, DMA_FROM_DEVICE);
>  	if (dma_mapping_error(ss->dev, addr_res)) {
>  		dev_err(ss->dev, "DMA map dest\n");
>  		err = -EINVAL;
> -		goto theend;
> +		goto err_unmap_sg;
>  	}
>  
>  	len = areq->nbytes;
> @@ -390,7 +389,7 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
>  	if (len > 0) {
>  		dev_err(ss->dev, "remaining len %d\n", len);
>  		err = -EINVAL;
> -		goto theend;
> +		goto err_addr_res;
>  	}
>  
>  	byte_count = areq->nbytes;
> @@ -421,27 +420,28 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
>  	}
>  
>  	addr_pad = dma_map_single(ss->dev, pad, j * 4, DMA_TO_DEVICE);
> -	rctx->t_src[i].addr = addr_pad;
> -	rctx->t_src[i].len = j;
> -	rctx->t_dst[i].addr = addr_res;
> -	rctx->t_dst[i].len = digestsize / 4;
>  	if (dma_mapping_error(ss->dev, addr_pad)) {
>  		dev_err(ss->dev, "DMA error on padding SG\n");
>  		err = -EINVAL;
> -		goto theend;
> +		goto err_addr_res;
>  	}
> +	rctx->t_src[i].addr = addr_pad;
> +	rctx->t_src[i].len = j;
> +	rctx->t_dst[i].addr = addr_res;
> +	rctx->t_dst[i].len = digestsize / 4;

This is right, it is useless to set addr_pad if it is "bad".
But this is a change unrelated with the subject.

Regards
