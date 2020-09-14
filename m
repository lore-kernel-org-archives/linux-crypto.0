Return-Path: <SRS0=QXJz=CX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14B4C43461
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 07:45:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F95B207C3
	for <linux-crypto@archiver.kernel.org>; Mon, 14 Sep 2020 07:45:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jYUciHsl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbgINHpv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Sep 2020 03:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgINHpu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Sep 2020 03:45:50 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA4E9C06174A;
        Mon, 14 Sep 2020 00:45:49 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id g4so17544648wrs.5;
        Mon, 14 Sep 2020 00:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3R77E9EeU0q3+YiyfWBGCJYkWETSW8Cgd6Iyt7BfdgE=;
        b=jYUciHslOoIXrMwFXOQv4b5M8AsToUU8/l5vkYm2QT5xAu7sNR6sNZDK2205SNQZrV
         i7WYk4nuem/SEOwPVmXPm0SHMFfrmuvJlSU1WaUtyssLaCqbqn6e+SDkrOuU3w4i4B7S
         Mjh5wGmMZZRgBaOEFd3h55RXeIYCw++8imnge28YULTYKgpTZTyI80KGfGVhn5hIYqC0
         zVp24Mv4Rucev2EhqWJLlzIpK31pOlRlhMUah31fJ7uBDWG7qVd6uePxhfTo+JzoyaMr
         nb1IR8WtkeErSHBMMi4rjew1T0ecfunSMV+SG/UbSevutlK51FcFT/GTW1L3ExRn7B49
         zUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3R77E9EeU0q3+YiyfWBGCJYkWETSW8Cgd6Iyt7BfdgE=;
        b=HMyDD+789mbkEqV1kaTgu4xCFqNJEbdQRZjyHRSu3HCzNeuq1M1Hg3fg+55ftnqZ7z
         wPfJcLnSnwx4woISNkkEMwS3yX5rw5SHmknngojzB2REUs2AgczwAVfb0Mqtae4fp6h8
         c2uaJTxp/8Q20hUQUNrxG2oeaCHDQeGbPln6Yg827N8QJINE91pwLa1/VUq5dhoQgoLf
         kzNtdBtHvUqBVZPxHCDFe3y4FJbUjqj79NTHn1QIjiiJn0vOPW2rAgSN/47ygAJfsSJt
         K/qRe2aRD7Pm69tIlIMVGSel3rUCS+FR/4X+8aSqj9MeWz0HIX/uoXY3Y2mcLnOQs9C3
         oRuw==
X-Gm-Message-State: AOAM530wt1qeQ8MNeu6VLlH7XyJvdT/VKEoUTsihnPJkIVPiS8B3Xa+Z
        1Kr6QAxT3JRDFHT7qTviu1Q=
X-Google-Smtp-Source: ABdhPJzgC1plQU3KLNxPE2pqVjKuloNGrXcm89L8bQcQmJCzuHaT0bS+D6RLsdRdTotZn/LDB2WHrQ==
X-Received: by 2002:adf:e9c3:: with SMTP id l3mr14261614wrn.63.1600069545827;
        Mon, 14 Sep 2020 00:45:45 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id y1sm17455186wma.36.2020.09.14.00.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:45:45 -0700 (PDT)
Date:   Mon, 14 Sep 2020 09:45:43 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     kernel test robot <lkp@intel.com>, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [v2 PATCH] crypto: sun4i-ss - Fix sparse endianness markers
Message-ID: <20200914074543.GA8698@Red>
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

It happens without your patch, so your patch is unrelated to this issue.
You can add:
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
