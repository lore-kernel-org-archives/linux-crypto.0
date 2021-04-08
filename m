Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A7D3C433ED
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 07:37:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0681F61177
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Apr 2021 07:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhDHHhN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Apr 2021 03:37:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41919 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229586AbhDHHhN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Apr 2021 03:37:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617867422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SVnxZGgW9Qxm2H1d4NzfReZMQBZ6OMN/TWyOftpZfrI=;
        b=H5CDE7UprVo1o7oY9LlMRZdRHS7DwIsjYTcU6nK1jjfA3VuKdxdRyP0ibQPN/F5JcoCIca
        2hHoTQ55q0nFXoU6P4SVpnbqIcRn2B1NVMDpuny6Z3VdNhCR7Hg/SWMKW/cVedYsX/UAnT
        lJk5pC6+Ul/YbaD+7OzLTb0z1MDvJHA=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-lQa5bD9MN0C2JjbAmXKBrQ-1; Thu, 08 Apr 2021 03:36:58 -0400
X-MC-Unique: lQa5bD9MN0C2JjbAmXKBrQ-1
Received: by mail-yb1-f199.google.com with SMTP id n13so1340253ybp.14
        for <linux-crypto@vger.kernel.org>; Thu, 08 Apr 2021 00:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SVnxZGgW9Qxm2H1d4NzfReZMQBZ6OMN/TWyOftpZfrI=;
        b=m0ObsOvwwYUrwKCUqyLp84tLDAN8oE22Pf6Q34Vyx8ijmLXIIcWGskrfihqzyVbSAX
         gwPmUHjhXcdF0BS4GE9zWdtpRrlkuU2i2s2n36qYCncnoShE5vgGHMM0svvb/lYkc6QJ
         JbT8Wh6uJpzj6m6c0hrOlabRRG82XSQnkbwKPKw326ntnp4oU8Oo73xDb7hyCQiwiKSp
         b+Gm0vsNzxTZu2iJycraOVJks6patdxyh7KkBK8SofglvidLJGwF7kD17ZvTE2yFz0Pv
         VpRvP10V5UA0Y2wYIT3AHN3QRJu0VtITOGo8Jrj3b9rD8SucL06abtm5Wx4cMbUJIIC/
         sprg==
X-Gm-Message-State: AOAM530xysd4wZON6W/wTFYe8zloAIeZ04EfuteluhQrUfN0RK6xJeAa
        E0GxFGhHvxRpIpLixEysDWUOUL5PITGrLSXmhVkrYjvXQVAzutfECqeuI3mqIA4v60ETSrC6soR
        WbNoz+ryr0pYlfQWvTtTl1vmb2+v/D6YfGLmGLKc+
X-Received: by 2002:a5b:8c9:: with SMTP id w9mr10259913ybq.289.1617867418315;
        Thu, 08 Apr 2021 00:36:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwyk1DLKIzXwiqHwH4GxtDWZM43edW9uuwjBBqA2y9GHE2IfNOz7vaODTT3FsioURaRTBFHXsrK/F9LuEcIcDE=
X-Received: by 2002:a5b:8c9:: with SMTP id w9mr10259896ybq.289.1617867418074;
 Thu, 08 Apr 2021 00:36:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210407113920.3735505-1-liuhangbin@gmail.com>
 <CAHmME9p40M5oHDZXnFDXfO4-JuJ7bUB5BnsccGV1pksguz73sg@mail.gmail.com> <20210408065231.GI2900@Leo-laptop-t470s>
In-Reply-To: <20210408065231.GI2900@Leo-laptop-t470s>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Thu, 8 Apr 2021 09:36:44 +0200
Message-ID: <CAFqZXNuk6wqTb+m4ttyU_4UN5TjqSdvUiOJ=peztUUiyY+ReJQ@mail.gmail.com>
Subject: Re: [PATCH net-next] [RESEND] wireguard: disable in FIPS mode
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Apr 8, 2021 at 8:52 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> On Wed, Apr 07, 2021 at 03:15:51PM -0600, Jason A. Donenfeld wrote:
> > Hi Hangbin,
> >
> > On Wed, Apr 7, 2021 at 5:39 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> > >
> > > As the cryptos(BLAKE2S, Curve25519, CHACHA20POLY1305) in WireGuard are not
> > > FIPS certified, the WireGuard module should be disabled in FIPS mode.
> >
> > I'm not sure this makes so much sense to do _in wireguard_. If you
> > feel like the FIPS-allergic part is actually blake, 25519, chacha, and
> > poly1305, then wouldn't it make most sense to disable _those_ modules
> > instead? And then the various things that rely on those (such as
> > wireguard, but maybe there are other things too, like
> > security/keys/big_key.c) would be naturally disabled transitively?
>
> Hi Jason,
>
> I'm not familiar with the crypto code. From wg_noise_init() it looks the init
> part is in header file. So I just disabled wireguard directly.
>
> For disabling the modules. Hi Ondrej, do you know if there is any FIPS policy
> in crypto part? There seems no handler when load not allowed crypto modules
> in FIPS mode.

If I understand your question correctly, yes, there is a mechanism
that disables not-FIPS-approved algorithms/drivers in FIPS mode (not
kernel modules themselves, AFAIK). So if any part of the kernel tries
to use e.g. chacha20 via the Crypto API (the bits in crypto/...), it
will fail. I'm not sure about the direct library interface (the bits
in lib/crypto/...) though... That's relatively new and I haven't been
following the upstream development in this area that closely for some
time now...

>
> BTW, I also has a question, apart from the different RFC standard, what's the
> relation/difference between crypto/chacha20poly1305.c and lib/crypto/chacha20poly1305.c?
>
> Thanks
> Hangbin
>

-- 
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

