Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE13C433F5
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Feb 2022 09:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbiBAJk0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Feb 2022 04:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236102AbiBAJkZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Feb 2022 04:40:25 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E938BC061714
        for <linux-crypto@vger.kernel.org>; Tue,  1 Feb 2022 01:40:24 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id jx6so52650381ejb.0
        for <linux-crypto@vger.kernel.org>; Tue, 01 Feb 2022 01:40:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pEitmmMlk7JRN01vRO7CkyySFvB6L6owuApAYgofnxA=;
        b=DH3pfDwfrN7jtRrDc1FQ6b6r7G8zCK0jgBcojvleyQoOiGvH5rifEa02gXp6QsqlKt
         eZUFIzOcmqyACJA6b4VzRTYzv/+TcAboiTKRlWDDGIJosFTiOHkZ18k44jrIG2fXJjWp
         vGPpyUwPsj30FW8VGiK4as6fuqmzdDlge/HF07b6eAKyt9DIe0zfdKREXRSLux3TqWHp
         oFODjXHrnCRralt6YtjWpYEknIuLpXM/kRnCLTb2yrfWvBrTqq2Dyv8kPJ2natbWKkcj
         ZpWBna6v0qQaU7QVSDvDfK2MhAulfGY1aLw34x043SFtT/bjeepY9hIsV5siV4Qu/O2n
         FadA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pEitmmMlk7JRN01vRO7CkyySFvB6L6owuApAYgofnxA=;
        b=SllU8gUmGAa0h4WguExKQPseGt0KU6gaUSsVY2SHTJ4Z4dl7UBv1rGfiRjrgTCGmWc
         k1SToADucw89tosWLiPQidm1PDonsgAWTV6U8VB+FMA1kkjGwl+HYCdG2Vn1M1xeRbCF
         3KeGeh4IXud1uWKt9yhsg5gRtqqnucLVh2+q5eDYoKk+AhvolJvvacK8Aqce6HW13tiG
         g2/zaFfNd16ZMmfcCxJmyrvHg6NOEHHy6lWw+ipM/BTm9CJj955UaRDCnw9WY3SJbN9r
         9Niz1lSZxrD2CjcJ3GcP71ukxroWtLFoEc+bszmPi4BzPs+XdbbGraUtpLRMTM08TMGh
         esZg==
X-Gm-Message-State: AOAM532iPAi5LolSDTN1/Y1XN89+vswdoD2Hw5rR/M1MN/fGZBBT33gI
        qZnL2py7hYVVcT7O8x9gIndV9m+kLqDv+DWufjY=
X-Google-Smtp-Source: ABdhPJzGBqAb26W3v+dwau/8AEulCxhqWOt0u2Nz6+K4P3M3hmEUfGRCM5dfTBtzj3PYTMhRVhvUFHWRieSEAQVNoQY=
X-Received: by 2002:a17:906:5d16:: with SMTP id g22mr20169793ejt.753.1643708423456;
 Tue, 01 Feb 2022 01:40:23 -0800 (PST)
MIME-Version: 1.0
References: <CACXcFmnPumpkfLLzzjqkBmxwtpMa0izNj3LOtf2ycTugAKAUwQ@mail.gmail.com>
 <CAHmME9pUW1o_QPfs45Q0JWucA5Qu1jhgMV7x2PycxosYV2wV7A@mail.gmail.com>
In-Reply-To: <CAHmME9pUW1o_QPfs45Q0JWucA5Qu1jhgMV7x2PycxosYV2wV7A@mail.gmail.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 1 Feb 2022 17:40:11 +0800
Message-ID: <CACXcFmk049OXc16ynjHBa+OSEOMYB=nYE1MDM_oM=Maf8bfcEA@mail.gmail.com>
Subject: Re: [PATCH] random.c Remove locking in extract_buf()
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, m@ib.tc,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> Either way, I don't think this is safe to do. We want the feed forward
> there to totally separate generations of seeds.

Yes, but the right way to do that is to lock the chacha context
in the reseed function and call extract_buf() while that lock
is held. I'll send a patch for that soon.
