Return-Path: <SRS0=2Pww=CN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E9EC28E83
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 10:40:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F8FD20770
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Sep 2020 10:40:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RvoRZmGk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgIDKkV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Sep 2020 06:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730126AbgIDKkP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Sep 2020 06:40:15 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81501C061246
        for <linux-crypto@vger.kernel.org>; Fri,  4 Sep 2020 03:40:14 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id z9so5630059wmk.1
        for <linux-crypto@vger.kernel.org>; Fri, 04 Sep 2020 03:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yqml3tY5jWsOhi5Kt4Kt274KoaP+bTsL8NP8m4B7cHU=;
        b=RvoRZmGkZ0Snq7dQLlqGtRKIpOhPW/n8xfqNBlMts7hvaovzwnwoM+yAfPzckZjJim
         gB1H8HmEb2mM1SDjhuV+CmNQ95LBGr8w9KMFYXDXLc4eajmqGgHV+tY2vQ5OCszISSqG
         kJs0niYrCojmftXbWoQwZt2AeUveeewuQgmKxJw4pW19NBti6yC8bMY8rGWBFCs+fbH9
         xp9Rv4D3d44Q9OXySJ3gc1inLfM2pIknYPdYmmS6CvOkVz+SA8W6qZORIipxU7YUPKgQ
         FdK1AT0ELXFjCi+3l8iG/AvjydwILg3b+AjUT2D5nyzqOKfGdFsZW5b/vyNNU9bPoLDt
         Aaww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yqml3tY5jWsOhi5Kt4Kt274KoaP+bTsL8NP8m4B7cHU=;
        b=mKxv03BSD+p+sU+2Asex/HKrDKp7rNcAypTuNBjrj1PvzS190q1FACMMk7srYDiyfh
         1XdtfPsp2a4ezALbTKZf2mhpoVwvQle/OIOIj47ePht8LNGBgtA69bd7Z4b+Wk4UyoTG
         sZGBooodLtp/Khs7Lg1FptdfryHmiBs5wogpGPOtVMZx7Uf+PJMPPceatBchQoOd5bmY
         HGiiJVJdCvJKDPMJFrlLD920UUIPBS921ipEckSBEuWZioRy5o2T+N/oRA/DBSWogSxA
         4cBWaNqhk4KibwilbYK2bjw1iEamZyHlRNftjgjNZuvIFcd9YBV4t3vJk7ICYrqnrD0a
         vdFQ==
X-Gm-Message-State: AOAM531Jgh8kTM8QE3PDmfyzVEyQtkCwPlX8hVxrqAEonvBwOaOsQrJb
        94waFMNDWgOBxM0cXD8JfW4=
X-Google-Smtp-Source: ABdhPJyUbRf2yoJspwXosQXqBdlcydiZyeqNL+vr7aX2aFhY6QAPsgLoM0Hrt7BqYiBzFdLXbCC4Kg==
X-Received: by 2002:a7b:cb19:: with SMTP id u25mr6637169wmj.113.1599216013206;
        Fri, 04 Sep 2020 03:40:13 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id a74sm10892359wme.11.2020.09.04.03.40.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 03:40:12 -0700 (PDT)
Date:   Fri, 4 Sep 2020 12:40:11 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH] crypto: sun8i-ce - Fix big-endian read of t_common_ctl
Message-ID: <20200904104011.GA8045@Red>
References: <20200904081122.GA23618@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200904081122.GA23618@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 04, 2020 at 06:11:22PM +1000, Herbert Xu wrote:
> The field t_common_ctl is supposed to be little-endian and indeed
> when it is filled in we've already done a cpu_to_le32 on it.
> However, in sun8i_ce_run_task it is taken as CPU-endian which is
> obviously wrong on BE.  This patch fixes it.
> 
> Fixes: 93c7f4d357de ("crypto: sun8i-ce - enable working on big...")
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> index 138759dc8190..703a60d4e2f6 100644
> --- a/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> +++ b/drivers/crypto/allwinner/sun8i-ce/sun8i-ce-core.c
> @@ -120,7 +120,7 @@ int sun8i_ce_run_task(struct sun8i_ce_dev *ce, int flow, const char *name)
>  	/* Be sure all data is written before enabling the task */
>  	wmb();
>  
> -	v = 1 | (ce->chanlist[flow].tl->t_common_ctl & 0x7F) << 8;
> +	v = 1 | (le32_to_cpu(ce->chanlist[flow].tl->t_common_ctl) & 0x7F) << 8;
>  	writel(v, ce->base + CE_TLR);
>  	mutex_unlock(&ce->mlock);
>  

This patch is in my hash/rng serie, I will resend it today.
