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
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8A16C4320A
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Aug 2021 18:25:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C0D1610A2
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Aug 2021 18:25:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbhHBSZn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Aug 2021 14:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhHBSZn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Aug 2021 14:25:43 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B849C06175F;
        Mon,  2 Aug 2021 11:25:32 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id c9so2253292wri.8;
        Mon, 02 Aug 2021 11:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=2PmZEzitR5QCFfVulNWIgxV1Tcx/s/ZuM62LoiFh3Nw=;
        b=t9WFOobW+5UA5d2UYmSatS4axpFhxEATNH3Fn4mwpxah92vkxPkZa7vAw0Di16hDaR
         jI9y03eCpaf5jbH40U4DdtWJxmP9aKD/OlfWStyS78uh0mDN3BOomJDP5/uyV39rzdJL
         cDCV0UZ1eM4eca9j95z5Aznn+OvE7TPIH6sSqB0afAOijc6HIsuBc1t1HZXiyn8AE71z
         iMm/4zq4T8ryUO+f9afiTI38ftuXPwQFCx6joFnbdkq4EiS7aBAGccu1tPyuwe4y5NU+
         QqN1iNTiFB2J9JrOenHXj4cX+8+860Lr78SC0YzMLXXzHGQ3RLjz/44TM0ttaoUpn0LK
         bVCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=2PmZEzitR5QCFfVulNWIgxV1Tcx/s/ZuM62LoiFh3Nw=;
        b=DTLASbLnPFKdxFtG9xbDUmMy/NHtuivLmeIMsJ6fo8obD0ERBzjSvsmRhKvESMn5vd
         qhzk0QljirNbc2A5giCKpw2TsodQf4BrqzlAndQ3QmylAYUy75x5Zkiu0I1cP3IrAa4e
         lyd++UFBMTM4iFqYhGV9j6ew+MPYN8nXXVXrkOUoCF3yzimomG/PflYKsVqffpIddhaz
         y6U6r8UBLsrDwk9IFjKRzWNd/gPIqpWIz1R2Sn4oNw2aFjUZE4JMXhxMk0lm3r51eDzz
         ErC4emJf1OxfjkRPIuNWfpo/QuZfeOoIN4oRuKsPwtoavTmFN6KUWqJGsxw5OrZvWQm+
         MQww==
X-Gm-Message-State: AOAM533N1XNDCOjJ9fv8wrfFNnVgmp+rkloMTJayNYl7O1TO6663Uilr
        dShbdoBetMVtz3ZyrptYsiA=
X-Google-Smtp-Source: ABdhPJwOlRAo6UE/hfBKpzqdbr70Ac0w6M+TUi3HSMpfBx75Rn9kGrj0DNXn2tRbGfuTCVnVrT4GGA==
X-Received: by 2002:adf:fd90:: with SMTP id d16mr20056591wrr.105.1627928730671;
        Mon, 02 Aug 2021 11:25:30 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id z12sm10663448wml.18.2021.08.02.11.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 11:25:29 -0700 (PDT)
Date:   Mon, 2 Aug 2021 20:25:25 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Dongliang Mu <mudongliangabcd@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Biggers <ebiggers@google.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Corentin Labbe <clabbe@baylibre.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sun8i-ce: fix multiple memory leaks in
 sun8i_ce_hash_run
Message-ID: <YQg4lehajLpQjyPd@Red>
References: <20210726152724.2281408-1-mudongliangabcd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210726152724.2281408-1-mudongliangabcd@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Mon, Jul 26, 2021 at 11:27:12PM +0800, Dongliang Mu a écrit :
> In sun8i_ce_hash_run, all the dma_mmap_sg/single will cause memory leak
> due to no corresponding unmap operation if errors happen.
> 
> Fix this by adding error handling part for all the dma_mmap_sg/single.
> 

I think it could be better worded, error handling is already there (but bad).

> Fixes: 56f6d5aee88d ("crypto: sun8i-ce - support hash algorithms")
> Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
> ---
>  .../crypto/allwinner/sun8i-ce/sun8i-ce-hash.c | 28 +++++++++----------
>  1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> index 88194718a806..d454ad99deee 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c
> @@ -286,16 +286,14 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
>  
>  	/* the padding could be up to two block. */
>  	buf = kzalloc(bs * 2, GFP_KERNEL | GFP_DMA);
> -	if (!buf) {
> -		err = -ENOMEM;
> -		goto theend;

Please keep all goto error for being consistent.

> -	}
> +	if (!buf)
> +		return -ENOMEM;
>  	bf = (__le32 *)buf;
>  
>  	result = kzalloc(digestsize, GFP_KERNEL | GFP_DMA);
>  	if (!result) {
> -		err = -ENOMEM;
> -		goto theend;
> +		kfree(buf);
> +		return -ENOMEM;
>  	}
>  
>  	flow = rctx->flow;
> @@ -321,7 +319,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
>  	if (nr_sgs <= 0 || nr_sgs > MAX_SG) {
>  		dev_err(ce->dev, "Invalid sg number %d\n", nr_sgs);
>  		err = -EINVAL;
> -		goto theend;
> +		goto err_result;
>  	}
>  
>  	len = areq->nbytes;
> @@ -334,7 +332,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
>  	if (len > 0) {
>  		dev_err(ce->dev, "remaining len %d\n", len);
>  		err = -EINVAL;
> -		goto theend;
> +		goto err_unmap_sg;
>  	}
>  	addr_res = dma_map_single(ce->dev, result, digestsize, DMA_FROM_DEVICE);
>  	cet->t_dst[0].addr = cpu_to_le32(addr_res);
> @@ -342,7 +340,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
>  	if (dma_mapping_error(ce->dev, addr_res)) {
>  		dev_err(ce->dev, "DMA map dest\n");
>  		err = -EINVAL;
> -		goto theend;
> +		goto err_unmap_sg;
>  	}
>  
>  	byte_count = areq->nbytes;
> @@ -392,7 +390,7 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
>  	if (dma_mapping_error(ce->dev, addr_pad)) {
>  		dev_err(ce->dev, "DMA error on padding SG\n");
>  		err = -EINVAL;
> -		goto theend;
> +		goto err_addr_res;
>  	}
>  
>  	if (ce->variant->hash_t_dlen_in_bits)
> @@ -405,15 +403,15 @@ int sun8i_ce_hash_run(struct crypto_engine *engine, void *breq)
>  	err = sun8i_ce_run_task(ce, flow, crypto_tfm_alg_name(areq->base.tfm));
>  
>  	dma_unmap_single(ce->dev, addr_pad, j * 4, DMA_TO_DEVICE);
> +err_addr_res:
> +	dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
> +err_unmap_sg:
>  	dma_unmap_sg(ce->dev, areq->src, sg_nents(areq->src),
>  		     DMA_TO_DEVICE);
> -	dma_unmap_single(ce->dev, addr_res, digestsize, DMA_FROM_DEVICE);
> -
> -
>  	memcpy(areq->result, result, algt->alg.hash.halg.digestsize);

The result should be copied only when everything is ok. Please add a "if (!err)"

Thanks for your work
Regards
