Return-Path: <SRS0=lAP7=CQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C43C43461
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 07:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBB0F206D4
	for <linux-crypto@archiver.kernel.org>; Mon,  7 Sep 2020 07:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CeQdiFgF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgIGHQY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 7 Sep 2020 03:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgIGHQW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Sep 2020 03:16:22 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6936C061573;
        Mon,  7 Sep 2020 00:16:21 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g4so14604214wrs.5;
        Mon, 07 Sep 2020 00:16:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FDYoXw6R73nLiL24Ngv3nbnKg8vUmYVwbLYzsiw9DXw=;
        b=CeQdiFgFpsSlgQHs1+T/qdd3Z7lErXzyccZxs80VwvbS1U7yT3eGtFLuknqCpY8q4a
         XFxR8jFxaNYhRxq/tc3S9atGDtLAVeX6imfi6YHBlqbeStxIm2ZUK+GK8Gwulej5WY8M
         0xEbE9NxtYcDlqvNd9GSSZEV+Mx8fQWfVlojVa8ia9yI+toTkjpdwX0OxSOt6qRqZUxk
         uH19ZQE9dyb/aV7l9CZHxSwGiPu9+waMSkHyQO9+s2YqnG32Jony384nAGXed8pj5AUe
         ikh8UC0M1u00NrPbgvILnmBh9sl7L/XIhG1erbImGgAv8WjvGzhhgOLLUuuMwFQzJIr1
         F7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FDYoXw6R73nLiL24Ngv3nbnKg8vUmYVwbLYzsiw9DXw=;
        b=O/74I4ZtwkHL01DxOTnLwWY3gTD0+JHa/Mk2ZglWo6sFjEgBFyNYN6X/YtGoQtqAKn
         1NwHQrjNBmEqa3l5+Yg7iKeoNW35eVfAoGqGeHAZDpvPSs2cT9l5Khjvad+INicvUIYO
         2HpM0uPYghStchXEzu/eKYgpdvoeUYa2jfuJNsoW9nZPj9p6LnGbXaU/7bKHBkfox9Td
         zYTYv66fUN3cXjOt5KatCRLxQoLCPcaaRmnzbpAkJIHMJfGAQp0gzTu2hIX79H95zWnO
         AFfnSsLRKakX+Gnb/ppANXjHGpjob3NB/f2SAt7cNRJamzp4Kf89HMvf2fXe2ZFl4UMd
         sYNg==
X-Gm-Message-State: AOAM5310dAHBGuJbGg6Mycbw9Z6m5elk0yXjnmm/uu4CsK6735W5tW0m
        Cf9PN7LIcxcgd0cRU9C95YY=
X-Google-Smtp-Source: ABdhPJwjXANs2pFjJmj4HveZXsqwk+OFZKCtOAQyb5/uN3UUX5zI1oih8j7thCG9V0iTaXBx4rYLAw==
X-Received: by 2002:adf:cf01:: with SMTP id o1mr20348930wrj.421.1599462980417;
        Mon, 07 Sep 2020 00:16:20 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id k84sm25699323wmf.6.2020.09.07.00.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2020 00:16:19 -0700 (PDT)
Date:   Mon, 7 Sep 2020 09:16:17 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Joe Perches <joe@perches.com>, herbert@gondor.apana.org.au
Cc:     Corentin Labbe <clabbe@baylibre.com>, davem@davemloft.net,
        mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [linux-sunxi] Re: [PATCH v6 18/18] crypto: sun8i-ce: fix some
 style issue
Message-ID: <20200907071617.GA11894@Red>
References: <1599217803-29755-1-git-send-email-clabbe@baylibre.com>
 <1599217803-29755-19-git-send-email-clabbe@baylibre.com>
 <906c2ffb0ef6b2d87d6aecdf60b61833ea79e4fb.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <906c2ffb0ef6b2d87d6aecdf60b61833ea79e4fb.camel@perches.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 04, 2020 at 12:37:19PM -0700, Joe Perches wrote:
> On Fri, 2020-09-04 at 11:10 +0000, Corentin Labbe wrote:
> > This patch fix a double empty line issue reported by checkpatch.
> > While at it, since now the maximum line length is now 100, reorder some
> > wrapped line.
> []
> > diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c
> []
> > @@ -164,12 +164,10 @@ static int sun8i_ce_cipher_prepare(struct crypto_engine *engine, void *async_req
> >  				goto theend_key;
> >  			}
> >  			offset = areq->cryptlen - ivsize;
> > -			scatterwalk_map_and_copy(rctx->backup_iv, areq->src,
> > -						 offset, ivsize, 0);
> > +			scatterwalk_map_and_copy(rctx->backup_iv, areq->src, offset, ivsize, 0);
> >  		}
> >  		memcpy(rctx->bounce_iv, areq->iv, ivsize);
> > -		addr_iv = dma_map_single(ce->dev, rctx->bounce_iv, rctx->ivlen,
> > -					 DMA_TO_DEVICE);
> > +		addr_iv = dma_map_single(ce->dev, rctx->bounce_iv, rctx->ivlen, DMA_TO_DEVICE);
> 
> coding-style.rst:
> 
>    Statements longer than 80 columns should be broken into sensible chunks,
>    unless exceeding 80 columns significantly increases readability and does
>    not hide information.
> 
> Do these longer lines make the code significantly more readable?
> I don't think they do.
> 

Oh I saw the increase in checkpatch.pl but didnt saw that it was still 80 in coding-style.rst.
Anyway as maintainer of this driver, I prefer unwrapped lines.

I let Herbert to choose to apply the serie without this last patch or not.
