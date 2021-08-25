Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35B9AC4320A
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Aug 2021 14:56:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1121460FD7
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Aug 2021 14:56:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236512AbhHYO4r (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Aug 2021 10:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbhHYO4r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Aug 2021 10:56:47 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A56ADC0613D9
        for <linux-crypto@vger.kernel.org>; Wed, 25 Aug 2021 07:56:01 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id i8so48510173ybt.7
        for <linux-crypto@vger.kernel.org>; Wed, 25 Aug 2021 07:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wvL1J8KEhyvF/ZLVKb8SP9iGmx/rrgPK1Hb5hBuqIvo=;
        b=L7jPwTZZT3jOI6gXuF9VZTYs592tZM+gktGr8MUWZIcKJjVlKdUag4gOINbV8YIZIk
         PRvoI+0GPDaLYpQKItO/lsUAJAUgrnfbV48dIv74TezzcZjQiLs/ZNImptNNOsbjfGcX
         a5lngTlixGTPXYqpLRus2JepcNK2FxaoOdvb80MPkiiCb4qDTKZJci4SzwTBqHzvzJl5
         5wx5Tn9GUbQ0NBZXHbKlp3zUDtwhJObYAlS0+LJGulL2eVjSvAuqZHd5GKBXff9DnC2T
         82J4aTjwEHrOJFWeFYaeOgYGbNxxMIEec7ttnkuC9jfwwbPbNatiG+GH/oDJcVGRfCAT
         nbdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wvL1J8KEhyvF/ZLVKb8SP9iGmx/rrgPK1Hb5hBuqIvo=;
        b=pI2Nee5r303xgHDzk1C3fN+dLr61nTr9fGDORr2zB+Cw3qn9Qcxx+B0SWXjeZypsRv
         pdJVyNzUJPORbbTVowgjxCfyImUteYXLMgpeI84AROqjJXF186fB0S4neKYrZcU5D/Kw
         pzwQFBsK33JsUZ+6CXWDOkgokwunDuVrLVLNV8+BxrmUvqHtztDTGHKa4sQWKjXR7qv1
         Px6Amu9azNh3vKzDIdm1tP0z0gHFyFtE2W2e6tY9oezHtTGVgtR15XiDXa92wd7Vvt5m
         R19uBWw3/RkK2N2FSwJIGvOQzMkmbymKQUufSrAt5z3LYdvpkeRozuLvmZeHXn7KxqFc
         jCjg==
X-Gm-Message-State: AOAM530woiQibqwIOrFn0knLBelDBhQ3EYHxJ6RPkk/20BIuQ6Ksg9MS
        aYfDzwAg6DVSprDNWDvypyUjE7XukFfaFTmNZQfmpg==
X-Google-Smtp-Source: ABdhPJytkuWEAuWWUZYWrEP18lJu5G82NnUjEtQyDV/rrZApkbTZLLyvruD/dE6vR4XM4BrtoHrV6JslnrM+TOpdsL4=
X-Received: by 2002:a25:2cd5:: with SMTP id s204mr10240667ybs.452.1629903360317;
 Wed, 25 Aug 2021 07:56:00 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1629840814.git.cdleonard@gmail.com> <abb720b34b9eef1cc52ef68017334e27a2af83c6.1629840814.git.cdleonard@gmail.com>
 <30f73293-ea03-d18f-d923-0cf499d4b208@gmail.com> <20210825080817.GA19149@gondor.apana.org.au>
In-Reply-To: <20210825080817.GA19149@gondor.apana.org.au>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 25 Aug 2021 07:55:49 -0700
Message-ID: <CANn89iKc-=x-15M8pkfOJazZHXY8ziD+PMH4z4C+eGL6_atbrA@mail.gmail.com>
Subject: Re: [RFCv3 05/15] tcp: authopt: Add crypto initialization
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>,
        Menglong Dong <dong.menglong@zte.com.cn>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 25, 2021 at 1:08 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Aug 24, 2021 at 04:34:58PM -0700, Eric Dumazet wrote:
> >
> > On 8/24/21 2:34 PM, Leonard Crestez wrote:
> > > The crypto_shash API is used in order to compute packet signatures. The
> > > API comes with several unfortunate limitations:
> > >
> > > 1) Allocating a crypto_shash can sleep and must be done in user context.
> > > 2) Packet signatures must be computed in softirq context
> > > 3) Packet signatures use dynamic "traffic keys" which require exclusive
> > > access to crypto_shash for crypto_setkey.
> > >
> > > The solution is to allocate one crypto_shash for each possible cpu for
> > > each algorithm at setsockopt time. The per-cpu tfm is then borrowed from
> > > softirq context, signatures are computed and the tfm is returned.
> > >
> >
> > I could not see the per-cpu stuff that you mention in the changelog.
>
> Perhaps it's time we moved the key information from the tfm into
> the request structure for hashes? Or at least provide a way for
> the key to be in the request structure in addition to the tfm as
> the tfm model still works for IPsec.  Ard/Eric, what do you think
> about that?

What is the typical size of a ' tfm' and associated data ?

per-cpu tfm might still make sense, if we had proper NUMA affinities.
AFAIK, currently we can not provide a numa node to crypto allocations.

So using construct like this ends up allocating all data on one single NUMA node

for_each_possible_cpu(cpu) {
    tfm = crypto_alloc_shash(algo->name, 0, 0);
    if (IS_ERR(tfm))
        return PTR_ERR(tfm);
    p_tfm = per_cpu_ptr(algo->tfms, cpu);
    *p_tfm = tfm;
}
