Return-Path: <SRS0=6Tes=CG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B230C433E2
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Aug 2020 11:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78A8D207DF
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Aug 2020 11:04:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="Kl1YlxrH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729211AbgH1LE0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Aug 2020 07:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729187AbgH1LDu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Aug 2020 07:03:50 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35676C061264
        for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2020 04:03:50 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id o21so532066wmc.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Aug 2020 04:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WkYKtHcsfdGBTwOSvpUN4IPqKRwqr8sxsEZDEkArh/w=;
        b=Kl1YlxrHJ1+oYx4+Ljs3UTzpqqfCLAyNtzTXkW1/eO1vUUAIaMTLIQydcnjdiFbC9D
         Toy+6xK2162UWdyh06VYmfKEPBKL7ersCXcLXsr1r33u4wzPrzFCFtRPhSeITPaoDvJ9
         uUzR0saKw6TnKc9iTYNEYXy+efCpAEthoXOurpeRRhD+1/JZJipjZCFArPJ4iXXjYhCy
         bulqnE1/dkV1NAE+/rJKrDFakSMwWsBM2w3GjpW9OVGyL1M6/CA5aLL4kun4mIdBAHoI
         xrOtmHrZsVHazxJ3lCl2mmObBs1wutSmU3U4PRy6iHFztY+NR9W+3UoBPWQ9Z31hr68l
         3XGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WkYKtHcsfdGBTwOSvpUN4IPqKRwqr8sxsEZDEkArh/w=;
        b=o40E50/GjHjNkxcwURrs+Spu5MSSnuYpjp6nKYAFo7PCcc5pLGsA/LGYM0BWdqRxEx
         7kuYzje9Wpo/0dXF5p/u1+CEF3HLtNHYEpLkzjdB9//0yFqF9GgSJcO44KQA+Nz+IxqB
         Mf3zYytBy2FO1AFK1CvXo2oLTii8zpf7DGuPZNaIJIE7HwFrdq9hWl+8FDJ7DLqAfJfP
         wyop9bhK86U/sHZ7A/rrcL3uH9F9zKEUEz826lZ4mJchQ4FFxwzWkKTdmDleMQIjerIo
         Cub6y9gpR7dZv/tizM4YkYVEx+adXjwAWNqtpQGPfoUV1VyVffuiJv0SAjKRhxM4bRg/
         AEMg==
X-Gm-Message-State: AOAM5300LNBgn6SNPPGZMBNQWm4GDce9WBeLQmCWdNFk1SLTTcZVJ2Sc
        +cMt9RTCdcQ4o6BEc4FOqaEihsppP3dduvCK
X-Google-Smtp-Source: ABdhPJyb1bIRnajFEhHShNaWkVQTpyqQpJXaBh9VROQc2ttvDqZGJ9kPhaMmcqrLX986sVTCsNZ08g==
X-Received: by 2002:a7b:c772:: with SMTP id x18mr1111928wmk.32.1598612628719;
        Fri, 28 Aug 2020 04:03:48 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id x2sm1527596wrg.73.2020.08.28.04.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 04:03:48 -0700 (PDT)
Date:   Fri, 28 Aug 2020 13:03:45 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: amlogic - Fix endianness marker
Message-ID: <20200828110345.GA11849@Red>
References: <20200828071833.GA28003@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200828071833.GA28003@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 28, 2020 at 05:18:33PM +1000, Herbert Xu wrote:
> The endianness marking on the variable v in meson_cipher is wrong.
> It is actually in CPU-order, not little-endian.
> 
> This patch fixes it.
> 
> Fixes: 3d04158814e7 ("crypto: amlogic - enable working on big...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/amlogic/amlogic-gxl-cipher.c b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> index d93210726697..fcf3fc0c01d0 100644
> --- a/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> +++ b/drivers/crypto/amlogic/amlogic-gxl-cipher.c
> @@ -99,7 +99,7 @@ static int meson_cipher(struct skcipher_request *areq)
>  	unsigned int keyivlen, ivsize, offset, tloffset;
>  	dma_addr_t phykeyiv;
>  	void *backup_iv = NULL, *bkeyiv;
> -	__le32 v;
> +	u32 v;
>  
>  	algt = container_of(alg, struct meson_alg_template, alg.skcipher);
>  

Hello

Acked-by: Corentin Labbe <clabbe@baylibre.com>
Tested-by: Corentin Labbe <clabbe@baylibre.com>

Thanks
