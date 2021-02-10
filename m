Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53EC1C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 14:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15B1A64E0B
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Feb 2021 14:26:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbhBJO0W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Feb 2021 09:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbhBJO0T (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Feb 2021 09:26:19 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E219C06174A
        for <linux-crypto@vger.kernel.org>; Wed, 10 Feb 2021 06:25:39 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id g10so2833833wrx.1
        for <linux-crypto@vger.kernel.org>; Wed, 10 Feb 2021 06:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4XM+OC4tEMQhllExIWHM2Z90/SpwG0aE0vvUDH0ec1c=;
        b=qcyDNs5cQ0Gxvt4YcpPKri0nPrNJWIL6mtGae+kml9AyzGfK+ORzRHgLg3PuxvKvOu
         DZfcqjGVFRcXVkTFVyfymASTAIZEspb/z4QQl8BtQlLwIAHed6ZA8OAQcAO4P5v4uJRq
         j/OhDGMAWQkN0U4YannT3lG4SJeZvbFatsy5ELrKu886meKkOMnbAh6WRRhl5wmZ/+yP
         FYq6foW2pb/9wEa6/ZpJOIqywykqDw7m+p+ekUEVrlhWDhEpiAieF3Earb1q310ZW6pl
         qnx6rg3HxbwP4oN+M++Bp5TyIlmxwo+P8mHmtHNJyTPjQIcX62gHSYqomAoeGt6I4Sdn
         slMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4XM+OC4tEMQhllExIWHM2Z90/SpwG0aE0vvUDH0ec1c=;
        b=aXrYdexn51k/Cj1Axfo7kPjGYZNWeK1FGwFJqArN1rhIvNKC7jMDVXaD7wADvi+0rB
         6yeKzoSpGgwhJn440FhU3ZSuT/d2cM/s2jBualrj34zu8c9yqJApJVvAqkx+qsfGXYXU
         QgLYOoFi5OPG54d9/5PaM6QOXzV9TbtrK8o8x3u6401BkC4nP/87SrDgvIyF1UAJW9W0
         2akWq76Qe8pCKokco7bKSu1Fp3FZEK0RaqrldQerq8EA1Vn3n1YKTOsJcJPri6Ep9ABX
         0O1gc6A6GDn7grZ/X0BJTHXacxQzF8u9Ze0bK7Yk0zMIdYvNco5BnHB9kcFZIXtxL1f4
         dX1w==
X-Gm-Message-State: AOAM531Bz3t5IQFzmqVIwFxTCHLfob4AntqulaB7GK6a3RA9iQ/ou191
        CZOBp33SA3i/CKtEjdle8vI=
X-Google-Smtp-Source: ABdhPJzE5GWdUN+WrfLFY5s3mKRaG8sZJcSml+ZtRlkfPOrJ1KZceJjRPZlTO+itsJbsbfunSHpvOQ==
X-Received: by 2002:adf:fe0d:: with SMTP id n13mr3951209wrr.258.1612967138014;
        Wed, 10 Feb 2021 06:25:38 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id 17sm2675288wmf.32.2021.02.10.06.25.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 06:25:37 -0800 (PST)
Date:   Wed, 10 Feb 2021 15:25:35 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     chenxiang <chenxiang66@hisilicon.com>
Cc:     clabbe@baylibre.com, gcherian@marvell.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linuxarm@openeuler.org,
        prime.zeng@huawei.com
Subject: Re: [PATCH 4/4] crypto: allwinner - Fix the parameter of
 dma_unmap_sg()
Message-ID: <YCPs3wAF8D0yDKZN@Red>
References: <1612853965-67777-1-git-send-email-chenxiang66@hisilicon.com>
 <1612853965-67777-5-git-send-email-chenxiang66@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1612853965-67777-5-git-send-email-chenxiang66@hisilicon.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Tue, Feb 09, 2021 at 02:59:25PM +0800, chenxiang a écrit :
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> For function dma_unmap_sg(), the <nents> parameter should be number of
> elements in the scatterlist prior to the mapping, not after the mapping.
> So fix this usage.
> 
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-cipher.c | 9 ++++++---
>  drivers/crypto/allwinner/sun8i-ce/sun8i-ce-hash.c   | 3 ++-
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 9 ++++++---
>  drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c   | 3 ++-
>  4 files changed, 16 insertions(+), 8 deletions(-)
> 

Hello

Acked-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Tested-by: Corentin LABBE <clabbe.montjoie@gmail.com>
Tested-on: sun8i-a83t-bananapi-m3
Tested-on: sun50i-h6-pine-h64
Tested-on: sun50i-h6-orangepi-one-plus

Thanks
