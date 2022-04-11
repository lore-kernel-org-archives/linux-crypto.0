Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D562AC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 11 Apr 2022 08:33:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343855AbiDKIfq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 11 Apr 2022 04:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343846AbiDKIfl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 11 Apr 2022 04:35:41 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C5D3E5FB
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 01:33:26 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id t1so4153161wra.4
        for <linux-crypto@vger.kernel.org>; Mon, 11 Apr 2022 01:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=27lr1TeRoTWAFLVF9iWjZf9oxGgkBi1ijJ2WmnDVaWw=;
        b=FCiOpWwMz1l33QbeB+Jtt4vgr1FQhMBvYuXg9CwxMEZsIcuVknweKFjUN7iW+2i9cK
         6icNeAlKmv9KMrFKBYTeJzTuTaLQrqAz87rGMry1dWZXm4WaTRZD8qkPhMoBRQIgboJq
         gkDMBZ4Iywc5c8AWFqttqw8Mf9H62DLQn1ShJ5V1P9YTxEyxOqX6P+22Zz2p+H8QQk7b
         72SKN7Xp2UiqKy1gotmgGVAH985FbXgT7oZ+HcB5XzDQ6YLW+zqHRxDP9MiZ9FTJ2hbG
         /qFhqT7Bdal9IeLusenPQiG3Pw7Ma5BF2J+9ynOn0iiNwFlEPSEVFRAdzuuhc8ZgZNrz
         60Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=27lr1TeRoTWAFLVF9iWjZf9oxGgkBi1ijJ2WmnDVaWw=;
        b=BuWSwUesR55l8kimO3QAfGSFQb6pOMmIn5dlnX89ryKjoGp3nu0V+dCSu5vTVhfmHR
         s2QDI0NS9e6Kct1x7fs3QLVVQ1MIByzJ8kSusDayQiVIDHFie7rAAZ1tIRnDg9kHdSXQ
         Gx4zg0hRrTOK+aom+fg6GkhFfDGqVmXXwAOLCohtcAXIgWI89MJW5HwDcbJXZKPWUE0Y
         ZNAmbNDkSsZsvCiYuH5QxIEGRrFg97HEz0H7MzR50R3krnL9HwBN0X7xVgN4HHcqXRVR
         EGGwuNPVdS+gaHRQz9ghRBO2j7nl6BXaBrk56X7QQUeA9OIns/Dka6cfh0BnDeofg8XX
         D5Rg==
X-Gm-Message-State: AOAM533zEbP59TYhTTzwXvHGHQSHQbtzdmxrppB2cftIa/m7hI9npFXB
        mjvJ6d8WDfvEzZ1Ngywet+lEdA==
X-Google-Smtp-Source: ABdhPJyMduce5eskJ2Cz9CC/3y6wawMSFNfIrfesrt3XjKQQPdmm+A6C+5gLz1aqtTxhi5MfzzLSUg==
X-Received: by 2002:a05:6000:1c14:b0:207:9988:2af0 with SMTP id ba20-20020a0560001c1400b0020799882af0mr11267923wrb.324.1649666005486;
        Mon, 11 Apr 2022 01:33:25 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id z5-20020a05600c0a0500b0037fa93193a8sm20206956wmp.44.2022.04.11.01.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 01:33:24 -0700 (PDT)
Date:   Mon, 11 Apr 2022 10:33:22 +0200
From:   LABBE Corentin <clabbe@baylibre.com>
To:     John Keeping <john@metanate.com>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v4 17/33] crypto: rockchip: use read_poll_timeout
Message-ID: <YlPn0nevX6zdYWwG@Red>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
 <20220401201804.2867154-18-clabbe@baylibre.com>
 <YkrYs87bgWs7+tOm@donbot>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YkrYs87bgWs7+tOm@donbot>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Mon, Apr 04, 2022 at 12:38:27PM +0100, John Keeping a écrit :
> On Fri, Apr 01, 2022 at 08:17:48PM +0000, Corentin Labbe wrote:
> > Use read_poll_timeout instead of open coding it
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  drivers/crypto/rockchip/rk3288_crypto_ahash.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
> > index 137013bd4410..21c9a0327ddf 100644
> > --- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
> > +++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
> > @@ -10,6 +10,7 @@
> >   */
> >  #include <linux/device.h>
> >  #include <asm/unaligned.h>
> > +#include <linux/iopoll.h>
> >  #include "rk3288_crypto.h"
> >  
> >  /*
> > @@ -305,8 +306,8 @@ static int rk_hash_run(struct crypto_engine *engine, void *breq)
> >  		 * efficiency, and make it response quickly when dma
> >  		 * complete.
> >  		 */
> > -	while (!CRYPTO_READ(tctx->dev, RK_CRYPTO_HASH_STS))
> > -		udelay(10);
> > +	read_poll_timeout(readl, v, v == 0, 10, 1000, false,
> > +			  tctx->dev->dev + RK_CRYPTO_HASH_STS);
> 
> This can be simplified to:
> 
> 	readl_poll_timeout(tctx->dev->dev + RK_CRYPTO_HASH_STS,
> 			   v, v == 0, 10, 1000);

Thanks, this is better.

> 
> But shouldn't this be tctx->dev->reg ?!

Yes, I will fix it.

Thanks
Regards
