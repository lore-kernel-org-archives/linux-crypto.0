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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 927DDC4338F
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 06:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7126F60F45
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Jul 2021 06:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbhGZGHs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Jul 2021 02:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbhGZGHr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Jul 2021 02:07:47 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3966C061757;
        Sun, 25 Jul 2021 23:48:15 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id n12so6167865wrr.2;
        Sun, 25 Jul 2021 23:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=HI8l9G1w/LmqJ+8NhRIG+Zn8YfnZKKj5vpdyiBzKi+s=;
        b=Wezx2tcrng+SV4TczyYEUaFp3bl3kB2dLc1cSxaviOLUlDyjjiHYCzb/SOC+UJC3Qq
         CYkSHQsvY+8+9F+IQNrnAlSk7SReAXhEmgcDnXfc/guqupHDZMC6erwOzAAfbgHdlxeY
         ZExeu9E94RwE4aEHV2aNlfDJMi4UyNa0Ek8B1Or96uByblHN7xV0d3Fn/Qa4DKHlcHOB
         4NUp+GOACNyWOsCy6OYEwh/OdaI/Sa/h0VTyowWpxlAB3OKn8chDxwtSic5jIH88IqLz
         JQYGvVr22sbI9cR4k88CdANHoFgSePtXCcaZAlfgf1aR2tPBrB7dzMjwI5qz+xfdlXKs
         P1GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HI8l9G1w/LmqJ+8NhRIG+Zn8YfnZKKj5vpdyiBzKi+s=;
        b=PiagmT0WSeqgbDVdVycPuFZ60Ubs8i5zWRAtDk8CT70A9OyHM+hwbT367i+JwkFjQU
         ii0bO6LSYFdk0QgSmIa/uxHXO4RrwTfKipMNkof04BqCBIaziAe67uMQ7p9Zo/iQNX/o
         DYxOxVB2Kh3t+H4MqB4p8YTuDOtPTPc6btLdtZfWP1UvkzIgeuf3Qx32mbHShnQ36ILC
         zyAsGlr5pLhWtkYTOjC1YDFm2DifDBCuI9IiYUqHklnUH+kXb6Sve/W73rzRO4zPtohU
         dXjnX68/pBPDA4EvaEXzuG9D6Ixblg6oCXCUNROmaXOv8OWX1zWbfj9BkLKNo3cJaS74
         z8LA==
X-Gm-Message-State: AOAM530Axn+MEZnlM3mivXi2QnRolPO7vZ7unyrJ/YXkui03qzkuBC/h
        95EtHipzsoa7m8dWh1+ujs4=
X-Google-Smtp-Source: ABdhPJzMyWdoXuVXC6olUVGS9xCVUUeG5T8ELSqi28A/n8Ujo3ogFvmxwZpZwlzWLvrIVx7tncogMw==
X-Received: by 2002:a5d:68cd:: with SMTP id p13mr3445295wrw.163.1627282093137;
        Sun, 25 Jul 2021 23:48:13 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id m15sm35003070wmc.20.2021.07.25.23.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jul 2021 23:48:12 -0700 (PDT)
Date:   Mon, 26 Jul 2021 08:48:10 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        dan.carpenter@oracle.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sun8i-ce: fix memory leak and return value of
 sun8i_ce_hash_run
Message-ID: <YP5aqtmAXS4xNtv/@Red>
References: <20210726062801.2078117-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210726062801.2078117-1-mudongliangabcd@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Mon, Jul 26, 2021 at 02:27:50PM +0800, Dongliang Mu a écrit :
> This patch fixes some memory leak caused by dma_mmap_sg/single
> in the error handling code. In addition, it fixes the return value
> when errors related with dma_mmap_sg/single occur.
> 
> Reported-by: Dongliang Mu <mudongliangabcd@gmail.com>
> Fixes: 732b764099f65 ("crypto: sun8i-ce - fix two error path's memory leak")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  .../crypto/allwinner/sun8i-ss/sun8i-ss-hash.c | 37 ++++++++++---------
>  1 file changed, 20 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
> index 3c073eb3db03..7c4ed19f5466 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c
> @@ -324,11 +324,11 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
>  	struct sun8i_ss_alg_template *algt;
>  	struct sun8i_ss_dev *ss;
>  	struct scatterlist *sg;
> -	int nr_sgs, err, digestsize;
> +	int j, i, todo, nr_sgs, tmp_err, digestsize;
> +	int err = 0;
>  	unsigned int len;
>  	u64 fill, min_fill, byte_count;
>  	void *pad, *result;
> -	int j, i, todo;
>  	__be64 *bebits;
>  	__le64 *lebits;
>  	dma_addr_t addr_res, addr_pad;
> @@ -368,14 +368,14 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
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
> @@ -390,7 +390,7 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
>  	if (len > 0) {
>  		dev_err(ss->dev, "remaining len %d\n", len);
>  		err = -EINVAL;
> -		goto theend;
> +		goto err_addr_res;
>  	}
>  
>  	byte_count = areq->nbytes;
> @@ -421,27 +421,30 @@ int sun8i_ss_hash_run(struct crypto_engine *engine, void *breq)
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
>  
> -	err = sun8i_ss_run_hash_task(ss, rctx, crypto_tfm_alg_name(areq->base.tfm));
> +	tmp_err = sun8i_ss_run_hash_task(ss, rctx, crypto_tfm_alg_name(areq->base.tfm));
> +
> +	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
> +
> +	crypto_finalize_hash_request(engine, breq, tmp_err);
>  
>  	dma_unmap_single(ss->dev, addr_pad, j * 4, DMA_TO_DEVICE);
> +err_addr_res:
> +	dma_unmap_single(ss->dev, addr_res, digestsize, DMA_FROM_DEVICE);
> +err_unmap_sg:
>  	dma_unmap_sg(ss->dev, areq->src, sg_nents(areq->src),
>  		     DMA_TO_DEVICE);
> -	dma_unmap_single(ss->dev, addr_res, digestsize, DMA_FROM_DEVICE);
> -
> -	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);
> -theend:
> +err_result:
>  	kfree(pad);
>  	kfree(result);
> -	crypto_finalize_hash_request(engine, breq, err);
> -	return 0;
> +	return err;
>  }

Hello

This is wrong, you need to always call crypto_finalize_hash_request()

Do you have tested your changes ? Copying results before dma_unmap() is also very wrong, this will lead to random cache fail.

Regards
