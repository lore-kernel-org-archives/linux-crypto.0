Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94570C433E2
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 10:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57722207BB
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 10:41:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BInOJyjR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgINKlY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Sep 2020 06:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726474AbgINKlL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Sep 2020 06:41:11 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84CE1C06174A;
        Mon, 14 Sep 2020 03:41:02 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id m6so18178180wrn.0;
        Mon, 14 Sep 2020 03:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KK6ppy+gk7UiuxPQUTeMnH2C+XIbYHWEr8o1+X2zUXc=;
        b=BInOJyjRPk8YQPjXak4SQncm/Rnt8fnKX7KW2tMQ/nQFgfRwbs8qs6TnLWKjquskxH
         20X3fPs0KriO+DOKwTWqMn8pL5SXBUwuJo+ycG30xuFk6E6mRBuf/aK9XaQYA8k8/Zaj
         yW1MoQJ2Rq1MI1lrkZ9zin98cM6faweGYrxaMQcUU1wkyTgK35oBPBk49ApYIjm1xdos
         ANzm54kNz9mYsw+/s3Jlxd3F2qYNuLcqJo+bjt2hw+OUx5BqFOK6U53lq6bc1PSzNhLc
         0X8sAZ4hjlWhZ2Adyuj3ylvxzsxgEtoHWRFTHvlZvSfJM29zD6p8I7abQHNC8ascpd5j
         97Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KK6ppy+gk7UiuxPQUTeMnH2C+XIbYHWEr8o1+X2zUXc=;
        b=kcggpbOv2LPvJi+szcVW2nApU2qDVqgk0Ohek6tQ/vBNtlqKw1IoIYnzhF3rsVLAcr
         zV5WDZIr0uOI9o8WhLIESAz4xflqK3NJGStX66mEJ8BScbFSvuUfZHyL53QUnY/lgnzE
         hNpCF5UPHoEVLQNFstup/eFrqUObC5YONRC5hh2a3XySsvdU12bZXcrFqGoYDWbouJaR
         SohKxENFfNCWMP2CA1MFUJBRtsgm8fQqfAITwFlKQQ5by++xbFRJgsXIJmvZCT4I9nlr
         +9av3zQtuIcguQo/xzgmz/lnvN9vtJb2/5fr3ORKKobYEBzee5L9yLDyBI9WefA6OZAv
         +1ag==
X-Gm-Message-State: AOAM5306D8T2OFHi2hmKxXuO22J2LS95Q/nqFggt3JrIOBSXupxFqFun
        7ZDLpX8ucSEPeQ6NgnvPKwU=
X-Google-Smtp-Source: ABdhPJx9quePo/D3nopjLPPXnThJTb3/w0LqiOFeKU3H19JP8qXFQKfegHyv6mSo8JfrdYKfWGgNLg==
X-Received: by 2002:a5d:4f09:: with SMTP id c9mr14577754wru.427.1600080061284;
        Mon, 14 Sep 2020 03:41:01 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id j14sm19012868wmj.19.2020.09.14.03.41.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 03:41:00 -0700 (PDT)
Date:   Mon, 14 Sep 2020 12:40:58 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: sun4i-ss - Fix sparse endianness markers
Message-ID: <20200914104058.GA14265@Red>
References: <202009061621.J89kO43Q%lkp@intel.com>
 <20200907062400.GA15841@gondor.apana.org.au>
 <20200907160029.GC11894@Red>
 <20200908050036.GA19817@gondor.apana.org.au>
 <20200910122248.GA22506@Red>
 <20200911041354.GA5275@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200911041354.GA5275@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 11, 2020 at 02:13:55PM +1000, Herbert Xu wrote:
> On Thu, Sep 10, 2020 at 02:22:48PM +0200, Corentin Labbe wrote:
> >
> > I get some md5 error on both A20+BE:
> > alg: ahash: md5 test failed (wrong result) on test vector \"random: psize=129 ksize=0\", cfg=\"random: inplace use_finup nosimd src_divs=[<reimport,nosimd>85.99%@+3999, 5.85%@+30, <reimport>0.96%@+25, <reimport,nosimd>5.9%@+2263, <flush,nosimd>2.11%@+1950] iv_offset=2 key_offset=43\"
> > and A33+BE:
> > [   84.469045] alg: ahash: md5 test failed (wrong result) on test vector \"random: psize=322 ksize=0\", cfg=\"random: inplace may_sleep use_finup src_divs=[<reimport>99.1%@+2668, <reimport>0.88%@alignmask+3630, 0.11%@+3403] iv_offset=33\"
> > +[   84.469074] need:35966fc8 b31ea266 2bf064e9 f20f40ad
> > +[   84.469084] have:e29e4491 f3b6effc fa366691 00e04bd9
> > 
> > Thoses errors are random. (1 boot out of 2)
> 
> Do these really go away without this patch applied? AFAICS the
> generated code should be identical.
> 

I got this on next-20200910/multi_v7_defconfig BigEndian
[   12.137856] alg: hash: skipping comparison tests for md5-sun4i-ss because md5-generic is unavailable
md5-sun4i-ss md5 reqs=763
[   98.286632] alg: ahash: md5 test failed (wrong result) on test vector \"random: psize=65 ksize=0\", cfg=\"random: use_finup src_divs=[95.28%@+1052, <reimport>0.61%@+4046, 0.87%@+24, <reimport,nosimd>3.24%@+542] key_offset=54\"

So sun4i-ss is not involved.
Strangely /proc/crypto show:
name         : md5                                                                                  
driver       : md5-generic                                                                          
module       : md5                                                                                  
priority     : 0                                                                                    
refcnt       : 1                                                                                    
selftest     : passed                                                                               
internal     : no                                                                                   
type         : shash                                                                                
blocksize    : 64                                                                                   
digestsize   : 16

and I didnt see anything failed/unknow in /proc/crypto

Why the failed algorithm is not visible ?
