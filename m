Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52326C433E6
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 06:46:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DEB765299
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Mar 2021 06:46:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhCIGqC (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Mar 2021 01:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhCIGqA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Mar 2021 01:46:00 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EFD0C06174A;
        Mon,  8 Mar 2021 22:46:00 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id l12so13972562wry.2;
        Mon, 08 Mar 2021 22:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=HSvFlw53ZQJ3UGmAhTTbZ6eZK5u9qhEy+Nh7KExbccc=;
        b=fy29+zfeZNIkS+o2CIi1qqh67fyRSIUwPGasxaXHbIs1vlhVx7gySfrZ+K0eFbadlf
         zVLHFAAHorvgDakN77jc+PQ19hU883vh3XcFLWHj7YE85LlfWIOArDAfSn0Nb3f0sWCM
         9pBaipmXlVkS/8KYbssiaNZoA20jxxYeEoFzBBCfpmLfpiaqJSSeyBVCntTmm4tupAla
         ZQ3l4N11Yn//zKlIWyYcS23CAcYgaaC1T5PtGnmEUM+emhvWdxGai7eXPHoHIOl71HUY
         9agn4bqkO+X4hmVXjrxyyKIfKRoCqdebXJm3KxV7dkeq6BAdGrJsNET8BueHiTTdeIZE
         TG0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=HSvFlw53ZQJ3UGmAhTTbZ6eZK5u9qhEy+Nh7KExbccc=;
        b=tY+Dm50klBacBZ5iHrhsy/wAmWyyQ+v9PSkWLuds6k8D4HBrwIQRFZ9xYAhQwO7I5f
         j1uu4p1Zj/xssi67noS/dTmWKwSILcSvt8PQPwJJc1glQomkuOO7vnDRxquj0iAuJrRj
         TdUSBVjTWrkt0DskzQtmts1j1U/h/4mQeNKKBgLoKUuUU1oCD3djbT9F9qAOfpS+Ggvp
         vnGJ9+CZhEHeS/C43SE58M36VN0nLlMyEXb0nYpzLcNAxwKH+sv1w8IqKH3R+s9US+7i
         wdbOQsxA8D3gDOuUajTLQjVVp84RuepzOiidS4dsrMnG3Gz/aPK2xdeTmCipgSDLCow1
         eezw==
X-Gm-Message-State: AOAM531StwEm5oVVvndmpc/o2BDtFp//0Pc7cQjFnV9fb5CB9MGtUK+O
        tBULK9ZuYkyE1OjaDMlqkXQ=
X-Google-Smtp-Source: ABdhPJzUHnqLkbm99mxf5QOHQ/QZEt2V1WJETLm9RyVeVyR3yjzlOIJJysXauA9TXWSPw+wEDKUPEA==
X-Received: by 2002:a05:6000:1547:: with SMTP id 7mr26513480wry.301.1615272359215;
        Mon, 08 Mar 2021 22:45:59 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id c128sm2414351wma.37.2021.03.08.22.45.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 22:45:58 -0800 (PST)
Date:   Tue, 9 Mar 2021 07:45:57 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: sun8i-ss: Fix memory leak of object d when
 dma_iv fails to map
Message-ID: <YEcZpUg1WJBm2/1S@Red>
References: <20210302163446.21047-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210302163446.21047-1-colin.king@canonical.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Tue, Mar 02, 2021 at 04:34:46PM +0000, Colin King a écrit :
> From: Colin Ian King <colin.king@canonical.com>
> 
> In the case where the dma_iv mapping fails, the return error path leaks
> the memory allocated to object d.  Fix this by adding a new error return
> label and jumping to this to ensure d is free'd before the return.
> 
> Addresses-Coverity: ("Resource leak")
> Fixes: ac2614d721de ("crypto: sun8i-ss - Add support for the PRNG")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
> index 08a1473b2145..3191527928e4 100644
> --- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
> +++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c
> @@ -103,7 +103,8 @@ int sun8i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
>  	dma_iv = dma_map_single(ss->dev, ctx->seed, ctx->slen, DMA_TO_DEVICE);
>  	if (dma_mapping_error(ss->dev, dma_iv)) {
>  		dev_err(ss->dev, "Cannot DMA MAP IV\n");
> -		return -EFAULT;
> +		err = -EFAULT;
> +		goto err_free;
>  	}
>  
>  	dma_dst = dma_map_single(ss->dev, d, todo, DMA_FROM_DEVICE);
> @@ -167,6 +168,7 @@ int sun8i_ss_prng_generate(struct crypto_rng *tfm, const u8 *src,
>  		memcpy(ctx->seed, d + dlen, ctx->slen);
>  	}
>  	memzero_explicit(d, todo);
> +err_free:
>  	kfree(d);
>  
>  	return err;
> -- 
> 2.30.0
> 
Hello

Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
