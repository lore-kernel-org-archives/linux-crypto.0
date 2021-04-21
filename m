Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A5BC433B4
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Apr 2021 20:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D56CF61354
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Apr 2021 20:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245613AbhDUUDz (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Apr 2021 16:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245609AbhDUUDz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Apr 2021 16:03:55 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EFB0C06174A;
        Wed, 21 Apr 2021 13:03:20 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id c15so33608496wro.13;
        Wed, 21 Apr 2021 13:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=g/C0hGCYFxl4/Qr2LMGGYLp3TN7XZ7nv/5+pCYVeG7I=;
        b=O7fho6f5nhqb5B3JzKBMTkvefBc377OAxGKSC/Q7VttajQpqjiXQV360touKreN1CP
         4W7fxQYm4ZFm7AnpXrT9wECu04yRvh52HE/9y8jhdHcX1fTAV+pzRCm9vSTJymcHjTEd
         oA0lf1oOIMe76wxncDjfgVby3Fi/E6Kt24d8hApbPoat2h9jTTYOhE9RLw/adfKpn8eH
         LnKFJ1zz8zprzkXWD7txiEF208oWGbLP5P82ANKSwfAh/h0U6gc2nRN6VPqEjks37ndQ
         sDtN92XaSco6lkgfsNne9sqVNZLinY4kMhYmMUi290T406vLkPMdLpVEYdMJmk935Bp7
         luFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=g/C0hGCYFxl4/Qr2LMGGYLp3TN7XZ7nv/5+pCYVeG7I=;
        b=I5XxEO2/eekBajgabaq0wi1vkjBnZyEjdaH+iVJVCmfgCTg/nc7yUjlgIIpE1AuNHl
         fRrirJLwJqENlJsIPyCxN7ShvzD3mlxt+bQKYdjeL8YncQOK9AIic9As98NrrSudDabY
         +nFfZjUNO5sJMWKeaR2lzoy5YfE1ImfjLjam8XIVysmY7BvBr/81aPxAoGNVSA0yd7Zu
         P3XFdSTUznbmXZQQo0f6ILJEirsav7JM1IYqWQ6fEdXJGXXzXtVOSIZBkXtGhthVhak4
         W6cDPjgZowwS486dPvPhow2wKPYBDCIWK01fSMLUfdbhq3rcM9RQUAgYXc2CXN1JA+Uh
         ilHw==
X-Gm-Message-State: AOAM5333FxFpSXyePeTvgvNhfnvOKjr25S/LOGQwr2r2R/e4+xz8CICV
        npmxktYTU+gyB8kWQZ0+/zKQdUgaisI=
X-Google-Smtp-Source: ABdhPJzn7eFIA19T452EeOAnAcsm8CwotL2pkif6yFIwnWDZdp32y+fyBos86iAkOEnGyBhGO3EPog==
X-Received: by 2002:adf:ef84:: with SMTP id d4mr28892489wro.74.1619035399126;
        Wed, 21 Apr 2021 13:03:19 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id b12sm13085264wmj.1.2021.04.21.13.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 13:03:18 -0700 (PDT)
Date:   Wed, 21 Apr 2021 22:03:17 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
Cc:     linus.walleij@linaro.org, linux-kernel@vger.kernel.org
Subject: cortina/gemini: hwrng: what is its quality ?
Message-ID: <YICFBQ8mQRJ4zSh9@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

hello

I work on the crypto part of the cortina/gemini SL3516 SoC.
The datasheet mention a HWRNG in its IP but really briefly:
"""
The implementation is a 32-bit Hardware Random Number Generator that has a uniformed
distribution between 0 and 2^32 -1. The hardware randomness is created by sampling data from
different clock domains, and feeding it as input to the 32-bit maximum length LFSR (Linear Feedback
Shift Register)
"""

Piping its output to rngtest give:
dd if=/dev/hwrng count=2000 bs=2048 | rngtest
rngtest 6.11
rngtest: starting FIPS tests...
rngtest: entropy source drained
rngtest: bits received from input: 32768000
rngtest: FIPS 140-2 successes: 1191
rngtest: FIPS 140-2 failures: 447
rngtest: FIPS 140-2(2001-10-10) Monobit: 183
rngtest: FIPS 140-2(2001-10-10) Poker: 116
rngtest: FIPS 140-2(2001-10-10) Runs: 346
2000+0 records in
2000+0 records out
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=303.606; avg=3143.352; max=9712.208)Kibits/s
rngtest: FIPS tests speed: (min=7.104; avg=10.332; max=10.638)Mibits/s
rngtest: Program run time: 13303224 microseconds

That's a quite number of failure.
Can the hwrng still be used with some "hwrng->quality" setting ?
Or it is just too many failure to be used ?

Regards
