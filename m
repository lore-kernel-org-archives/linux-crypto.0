Return-Path: <SRS0=XejO=AL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2144C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 07:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A201120759
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Jun 2020 07:07:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BhR7jMFg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730581AbgF3HHc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Jun 2020 03:07:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730386AbgF3HHb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Jun 2020 03:07:31 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91CE8C03E979
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jun 2020 00:07:31 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z15so7697280wrl.8
        for <linux-crypto@vger.kernel.org>; Tue, 30 Jun 2020 00:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cbt8RXvND2R7NfXRVkB9C3T19Zq+4hqCDYLNIwxNyiY=;
        b=BhR7jMFgZlw5cQh00kFtL2pJSCn1hWja/Led3VfEYPsjIxBljrb+B4/CBOiQ5nnu9y
         /znBl9lg3qENbK4iLftHtGynyuEGD/9p0+RzwEAdIG7YVwlNNqhwnSOch0u9LYPSWl+i
         RnSks5rfX9g/xboxbo3oh2jy1jJPx9KioIBDiN4v6b7uKYm4T3FD86slPHd2xwNn6p89
         WSFO2Acw61/widLlMELCMPCZljptKR8cZkQv1yGtMDo9tyHAsnPopvfNh3oYWY7lmlWV
         qsQXXaa8SpcStFqpisCkb1JYs5vkb5X8dLe3xJ0X6+3n2ibWq+xQ7NhbiEikA40AKaZq
         j05g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cbt8RXvND2R7NfXRVkB9C3T19Zq+4hqCDYLNIwxNyiY=;
        b=Mu1YNhi5nq93AIL1+uOn1C/uSWgBr1wjesNvP59PGdGm01QtngnkQNmW3c2cuuy5b4
         oo0jcyJPjjOxgBmVPnBfgXGLBLrBNK3dkeLRZezTpRkJLEfDIOUalo/21YrOglXJBjxO
         w9iigLL0G1tcPcFTGN4XoVV1NcJKx4k7a9ViYf4zy+oCQTWnhRBWlFD/w0GilLYgd/JH
         pp9EZxIi4Caqt35QnAnjdLM1qx7FoB/jrca9lElIPNxSWnwfQg7Qc7IvZ2fq+qB8BVbg
         5tFOCjJMkm5x9rO85vVP3G8KAGaI5EXwfa8jMEPYHxSLzBlV+WCJHEjU242I2SrElIgt
         eXvg==
X-Gm-Message-State: AOAM530pwi5a/Yi2+/Z2O/ndWJasVGvwRIhbwpGcT1zQigoS8rDW0AOd
        izllK8k7eT/7cqgbK6xMMPePIA==
X-Google-Smtp-Source: ABdhPJyIxIvJd4Ymeeq0IQ887XAPkISAZdn0OrmMLkuxYxQP44rhKLPtXjZS5XRJcNb/i1cecRL42g==
X-Received: by 2002:adf:a396:: with SMTP id l22mr20309972wrb.24.1593500850292;
        Tue, 30 Jun 2020 00:07:30 -0700 (PDT)
Received: from dell ([2.27.35.144])
        by smtp.gmail.com with ESMTPSA id e8sm2551614wrp.26.2020.06.30.00.07.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 00:07:29 -0700 (PDT)
Date:   Tue, 30 Jun 2020 08:07:27 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: ux500: hash: Add namespacing to hash_init()
Message-ID: <20200630070727.GD1179328@dell>
References: <20200629123003.1014387-1-lee.jones@linaro.org>
 <20200630041029.GA20892@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200630041029.GA20892@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 30 Jun 2020, Herbert Xu wrote:

> On Mon, Jun 29, 2020 at 01:30:03PM +0100, Lee Jones wrote:
> > A recent change to the Regulator consumer API (which this driver
> > utilises) add prototypes for the some suspend functions.  These
> > functions require including header file include/linux/suspend.h.
> > 
> > The following tree of includes affecting this driver will be
> > present:
> > 
> >    In file included from include/linux/elevator.h:6,
> >                     from include/linux/blkdev.h:288,
> >                     from include/linux/blk-cgroup.h:23,
> >                     from include/linux/writeback.h:14,
> >                     from include/linux/memcontrol.h:22,
> >                     from include/linux/swap.h:9,
> >                     from include/linux/suspend.h:5,
> >                     from include/linux/regulator/consumer.h:35,
> >                     from drivers/crypto/ux500/hash/hash_core.c:28:
> > 
> > include/linux/elevator.h pulls in include/linux/hashtable.h which
> > contains its own version of hash_init().  This confuses the build
> > system and results in the following error (amongst others):
> > 
> >  drivers/crypto/ux500/hash/hash_core.c:1362:19: error: passing argument 1 of '__hash_init' from incompatible pointer type [-Werror=incompatible-pointer-types]
> >  1362 |  return hash_init(req);
> > 
> > Fix this by namespacing the local hash_init() such that the
> > source of confusion is removed.
> > 
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: linux-crypto@vger.kernel.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> > 
> > Ideally this should go into v5.8's -rcs else it runs the risk of
> > breaking when Linus pulls everything in for v5.9-rc1.

[...]

> I also dislike pulling in the kitchen sink when all you need in
> consumer.h is the definition of suspend_state_t.  A better solution
> would be to move the definition of suspend_state_t into linux/types.h
> and including that instead of suspend.h in consumer.h.

IMHO, including (whole) headers into source/header files is the norm.
Even if only a small portion is actually referenced.  Very seldom do
consumers of an API use more than a fraction of what is available.
Whether it's a couple of function calls, a struct or a type.

Pulling headers apart and placing items in more convenient places
i.e. into headers which are more commonly included, messes with the
compartmentalisation of subsystems and sounds like more of a hack than
simply saying "to enable suspend functions we need to reference the
suspend API" like we are here.

> I have no objections to this patch.  However, I'd rather put
> it on a topic branch which you could pull rather than pushing
> it into 5.8 straight away.

An immutable branch sounds like a sensible solution.  Thanks.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
