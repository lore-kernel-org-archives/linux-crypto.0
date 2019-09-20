Return-Path: <SRS0=j/4y=XP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A5AC49ED7
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 13:27:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BBCD2086A
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Sep 2019 13:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727637AbfITN1K (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Sep 2019 09:27:10 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:32778 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbfITN1K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Sep 2019 09:27:10 -0400
Received: by mail-qt1-f195.google.com with SMTP id r5so8666884qtd.0;
        Fri, 20 Sep 2019 06:27:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Yu0bebIccH+12tZYtfI1e/8Z8n4TfOTtSvrlww5Bbo=;
        b=ZVgniuPoXwOlgH3C4DwNsS0ondEh2J5yRbSVamOYukONyu8SAoCtoX/T/yceUr7zBF
         3kzlwt0Zflcc7XDMO5sBTnC2ym2qfgZvPi52BQyojW2Jv4tiSU9kinX2MQabmBCUy3LB
         49Hyzzh9kpSuRS6ieYXrOzolgkEcAOqaT99rMnWhwi+YQdLvKPzAhD7VkqNFCbh5wnMk
         hALQruqOhPVTlApXGk18TSKc+Ms+hKql0iyp6AiZNSH8uvflXPKfM0b2qLAmpy5Tsgqx
         98AFhKa6/ekBcjoRtusZ5kNPu109Z8MKDoy4o/XwesZEZEzwiabvlCvOjFLvLmduof/V
         PhQg==
X-Gm-Message-State: APjAAAWKpd8ptyMJqQ0aaMj8G3yomONqu1SglNZfgOPC8qQQoqOkAC8c
        SlrlKxqK2+orBjpZgHF2KKycq9V759IZZkbl1Fb55x0T
X-Google-Smtp-Source: APXvYqzOT73jN4OJzz33BF88ETJkuCXtfXjyVPXMdN8s5FG4yTjaUGaOM98SouGMxAu0vPbtC9iDxEMPzgiGyYhNuT8=
X-Received: by 2002:aed:2842:: with SMTP id r60mr3277241qtd.142.1568986028586;
 Fri, 20 Sep 2019 06:27:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190919140650.1289963-2-arnd@arndb.de> <20190919140917.1290556-1-arnd@arndb.de>
 <f801a4c1-8fa6-8c14-120c-49c24ec84449@huawei.com>
In-Reply-To: <f801a4c1-8fa6-8c14-120c-49c24ec84449@huawei.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 20 Sep 2019 15:26:52 +0200
Message-ID: <CAK8P3a3jCv--VHu9r4ZTnLXXGaCjdJ6royP5LFk_9RCTTRsRBA@mail.gmail.com>
Subject: Re: [PATCH 2/2] [v2] crypto: hisilicon - allow compile-testing on x86
To:     John Garry <john.garry@huawei.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Kenneth Lee <liguozhu@hisilicon.com>,
        Mao Wenan <maowenan@huawei.com>,
        Hao Fang <fanghao11@huawei.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 20, 2019 at 10:34 AM John Garry <john.garry@huawei.com> wrote:

> > +     if (!IS_ENABLED(CONFIG_ARM64)) {
> > +             memcpy_toio(fun_base, src, 16);
> > +             wmb();
> > +             return;
> > +     }
> > +
> >       asm volatile("ldp %0, %1, %3\n"
> >                    "stp %0, %1, %2\n"
> >                    "dsb sy\n"
> >
>
> As I understand, this operation needs to be done atomically. So - even
> though your change is just for compile testing - the memcpy_to_io() may
> not do the same thing on other archs, right?
>
> I just wonder if it's right to make that change, or at least warn the
> imaginary user of possible malfunction for !arm64.

It's probably not necessary here. From what I can tell from the documentation,
this is only safe on ARMv8.4 or higher anyway, earlier ARMv8.x implementations
don't guarantee that an stp arrives on the bus in one piece either.

Usually, hardware like this has no hard requirement on an atomic store,
it just needs the individual bits to arrive in a particular order, and then
triggers the update on the last bit that gets stored. If that is the case here
as well, it might actually be better to use two writeq_relaxed() and
a barrier. This would also solve the endianess issue.

     Arnd
