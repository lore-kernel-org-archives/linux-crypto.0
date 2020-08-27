Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DF9C433E3
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 14:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 974DE22D01
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 14:50:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I4kiOtbl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgH0OuK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 10:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727926AbgH0OuI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 10:50:08 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186EDC061264;
        Thu, 27 Aug 2020 07:50:07 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id a65so5431487wme.5;
        Thu, 27 Aug 2020 07:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j7RgArUIdyb6K9ojVFFA7woS4UMvYBf7NMDG3Mq1690=;
        b=I4kiOtbl8+KzJiLw2dUrng+hSfv7rVlkWOHvjTZ+Oqn4w3X/XJ/jCuqLqVuO/BvT01
         foN5AsRNsbABbPU11ejczLMcrZ+IqOx1Hyd2QZSHyo5y+pmQu/8YsSGFf8LqC0lJN1jz
         VQInWjxhcKPd/BVCxkx424nha0WygTxzq5xAwxxfshmbxeBtxcHFH/KamQe3wuLzs75M
         iOsME+rjVOPzu/S75HJZY07xY/eZX+fZWvPL1G6k7LIsRpWTedO2NK6lvVahUTIY52QZ
         mVzVhMkvgIyI2Tu6S4pkNu4YZu9cRZnRF3fkMrMlCp6MoK5FUQOLi03z083Osw00j8y4
         4g4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j7RgArUIdyb6K9ojVFFA7woS4UMvYBf7NMDG3Mq1690=;
        b=PYQlJjjV2kY+NgAYmtNC7bv5um9N6IhE590e4hYPa0gH5awpcu0QWUaBCj1ZeYvTC7
         HArM60clyHAzcH3pYnF4yqRXsiOJPSNIgVWdublQeBrRBHyiOoiaaROIsEppDItJWZka
         qFF786UrQLCOq3/P9B7KHmUA4lX5E5X1RkW1wpjLj1avSzkZoO+mU4MvHbNI17w2JeS+
         gTaJ/GNUewBwHSNE6kseYCsfV2KarVvE+5a38wJ6LkpjohlHDBpmH5MKDJmjli+xbkuR
         BXZU0TcINzon7O5aqjeCYDhFX2mIYwi5Tv51l79CoXSoSaaTq4bdmgqfRQfNJwGWBIfC
         JKJg==
X-Gm-Message-State: AOAM531XQQtqx4ybXOS9FE58V1NNJCbzZ/GEZEpX7f8031UYI1CF22ll
        kklyqwJHJ7EYDmGiZ4gbhrsYBeYBJXM=
X-Google-Smtp-Source: ABdhPJwAU1+738BsCoTc559Y03dIntXC8fpqeC6ZU4c3XtTfTRt7SMjbEB9Pt9cLJkCrR9rf2FPcAw==
X-Received: by 2002:a1c:1b43:: with SMTP id b64mr12806944wmb.6.1598539805859;
        Thu, 27 Aug 2020 07:50:05 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id q6sm5858770wma.22.2020.08.27.07.50.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 07:50:05 -0700 (PDT)
Date:   Thu, 27 Aug 2020 16:50:03 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] crypto: amlogic - use kfree_sensitive()
Message-ID: <20200827145003.GA14173@Red>
References: <20200827064402.7130-1-efremov@linux.com>
 <20200827064402.7130-3-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827064402.7130-3-efremov@linux.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 09:44:00AM +0300, Denis Efremov wrote:
> Use kfree_sensitive() instead of open-coding it.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  drivers/crypto/amlogic/amlogic-gxl-cipher.c | 10 ++--------
>  1 file changed, 2 insertions(+), 8 deletions(-)
> 

For the whole serie you didnt use getmaintainers, so nor sunxi and amlogic maintainers where CC.
And my baylibre address which is the address for this driver.

Anyway, for this case the patch is trivial enough.

Tested-by: Corentin Labbe <clabbe@baylibre.com>
Acked-by: Corentin Labbe <clabbe@baylibre.com>

Regards
