Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DA2FEE6456
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Sep 2023 10:45:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbjIOKpR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Sep 2023 06:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjIOKpR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Sep 2023 06:45:17 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8939DA1
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 03:45:12 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-59c26aa19b7so423017b3.2
        for <linux-crypto@vger.kernel.org>; Fri, 15 Sep 2023 03:45:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1694774711; x=1695379511; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J4u4XYCgTvBFoGtqFUvIv4FTJYL4gt5M/WcSROwbSvU=;
        b=Atb/mMOfapPkdqr7LCRR+tUfF39KczwmLyRJMXoHs0v6jJWkNIrR/+R+HgInIL/f9y
         sEUCXDnSPHzr3y8GsponWiz6cG26cN3N2TWENt9uLSTVJveTdLAhvRQ2YJ0yIrbiCtmE
         JbAKTrumDLo5LuPxS6wbID7JVDNBzJvBIYO7ORKGW8tG5n6Pe92KOoIG3geiLvmEZ1B7
         E9MDNGOEJWXkgElztlB6N2QRpVhEKnc9ybjdlBC/DBZO6FoPbXgrwsAcbs8yZ3Qrvx7m
         Ke0x357uPRMghH/03pohgi1AuAvVlLKJAlcOcCF6x1PAZrWQsileWy+v8xV/DM75UhNq
         Xl+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694774712; x=1695379512;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J4u4XYCgTvBFoGtqFUvIv4FTJYL4gt5M/WcSROwbSvU=;
        b=uu49sL76FZ7gy0v9256iK1H3d2DXY6zef+1FDiRxCWOnHXAGwGueTlAe+jUXZAH9aK
         6aXrHPlrOGoEVQL9xEfjQPqQ8zo9KjZusIfW507A/SU6YIp7RRRjwetCFQ4iSZ5rqenF
         YEsN3DZigiZMz2G2Kn67wU8004l307MsvpPDK7JBG9z8FKL5+22S3L2a1gFHy3nuQZhy
         gwbAMdy1X7223EZ2A2z+gJEhqgd4GCWcZqK344OS+ihj+fZJ7RwfKg5P7MOBdhu+byav
         cy6n6wmajOafITS+j5Bj1M+hXnWRdMLr4/whA/BRgJnLgNlMdJqYPj1z94pDgWGUnTAu
         yA/Q==
X-Gm-Message-State: AOJu0YzSF9d/hNOdLgoZi0tawC0Gn1qqEwj3x6Za6EYb5XkqPQ+/0f/J
        EtnxddPDw8wJ7ZoEL79VyGU=
X-Google-Smtp-Source: AGHT+IEwe/s1/zpZj+nNuo0haZZBOT++TTQgYSOpkXHByc61qcZbJdSYif1STCODvO7FWiAbUcYxbw==
X-Received: by 2002:a81:ac5f:0:b0:59c:1880:18e0 with SMTP id z31-20020a81ac5f000000b0059c188018e0mr681288ywj.21.1694774711631;
        Fri, 15 Sep 2023 03:45:11 -0700 (PDT)
Received: from gondor.apana.org.au ([2404:c804:1b2a:5507:c00a:8aff:fe00:b003])
        by smtp.gmail.com with ESMTPSA id k22-20020aa790d6000000b0068fdb59e9d6sm2722627pfk.78.2023.09.15.03.45.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Sep 2023 03:45:11 -0700 (PDT)
Sender: Herbert Xu <herbertx@gmail.com>
Date:   Fri, 15 Sep 2023 18:45:10 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Stefan Wahren <wahrenst@gmx.net>
Cc:     Olivia Mackall <olivia@selenic.com>,
        Florian Fainelli <florian.fainelli@broadcom.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Mark Brown <broonie@kernel.org>, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH V2] hwrng: bcm2835: Fix hwrng throughput regression
Message-ID: <ZQQ1tgDEGGXwfu/4@gondor.apana.org.au>
References: <20230905232757.36459-1-wahrenst@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230905232757.36459-1-wahrenst@gmx.net>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 06, 2023 at 01:27:57AM +0200, Stefan Wahren wrote:
> The last RCU stall fix caused a massive throughput regression of the
> hwrng on Raspberry Pi 0 - 3. hwrng_msleep doesn't sleep precisely enough
> and usleep_range doesn't allow scheduling. So try to restore the
> best possible throughput by introducing hwrng_yield which interruptable
> sleeps for one jiffy.
> 
> Some performance measurements on Raspberry Pi 3B+ (arm64/defconfig):
> 
> sudo dd if=/dev/hwrng of=/dev/null count=1 bs=10000
> 
> cpu_relax              ~138025 Bytes / sec
> hwrng_msleep(1000)         ~13 Bytes / sec
> hwrng_yield              ~2510 Bytes / sec
> 
> Fixes: 96cb9d055445 ("hwrng: bcm2835 - use hwrng_msleep() instead of cpu_relax()")
> Link: https://lore.kernel.org/linux-arm-kernel/bc97ece5-44a3-4c4e-77da-2db3eb66b128@gmx.net/
> Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
> ---
> 
> Changes in V2:
> - introduce hwrng_yield and use it
> 
>  drivers/char/hw_random/bcm2835-rng.c | 2 +-
>  drivers/char/hw_random/core.c        | 6 ++++++
>  include/linux/hw_random.h            | 1 +
>  3 files changed, 8 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
