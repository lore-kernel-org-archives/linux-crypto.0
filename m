Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D331ECAAD3
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Sep 2022 10:49:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbiISKtV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Sep 2022 06:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiISKsq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2022 06:48:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 401F1237FA
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 03:40:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1C956194C
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 10:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94D7C433D6
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 10:40:29 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="R4Mocjmo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1663584027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rKJHJGF2FSzK4SEwoZS/WLudBmKt7sV9Hh0wjdhk3Dc=;
        b=R4MocjmocevKbXuJ+axRCQr41SijqTxsc1wRjOsjLT/dfTw+rUfCB6vVNPe+6Uzs8A7x70
        p7lUXFrdjyLfhdU5yaOjmGzjsBcbiwHL7Q/HC2EYw9v1wf/OWC2I1FR/fOMoJEvEG7WpSU
        YDBeT2E6HOz4Dn3oHccF5meRKW0Egro=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a87f5d6b (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Mon, 19 Sep 2022 10:40:26 +0000 (UTC)
Received: by mail-ua1-f46.google.com with SMTP id e1so6238131uaa.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Sep 2022 03:40:26 -0700 (PDT)
X-Gm-Message-State: ACrzQf1kMYn3cw0VoIOKmdBuS6UqjgV+1+yUOUfywJR9gNlvdERG/eYp
        WAXKgm0ATVjXSFd+PrNlLXjALtwACiWA+wWEHpQ=
X-Google-Smtp-Source: AMsMyM4aKzJ93bR5xDR+7ZqV14Bo4Hp7Tx9BBQHWC6yVR1bnTC7fdGkjfmXqkkGq5pq4L6yjF1xAqDq+SmNlel/WYIM=
X-Received: by 2002:ab0:5a24:0:b0:3af:fbb1:2dfb with SMTP id
 l33-20020ab05a24000000b003affbb12dfbmr6001091uad.27.1663584025966; Mon, 19
 Sep 2022 03:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <a93995db-a738-8e4f-68f2-42d7efd3c77d@huawei.com>
 <Ytj3RnGtWqg18bxO@sol.localdomain> <YtksefZvcFiugeC1@zx2c4.com>
 <29c4a3ec-f23f-f17f-da49-7d79ad88e284@huawei.com> <Yt/LPr0uJVheDuuW@zx2c4.com>
 <4a794339-7aaa-8951-8d24-9bc8a79fa9f3@huawei.com> <761e849c-3b9d-418e-eb68-664f09b3c661@huawei.com>
 <CAHmME9qBs0EpBBrragaXFJJ+yKEfBdWGkkZp7T60vq8m8x+RdA@mail.gmail.com>
 <YxiWmiLP11UxyTzs@zx2c4.com> <efb1e667-d63a-ddb1-d003-f8ba5d506c29@huawei.com>
 <Yxm7OKZxT7tXsTgx@zx2c4.com> <ca31cb51-30b8-e970-c33c-7b848ae5ed45@huawei.com>
In-Reply-To: <ca31cb51-30b8-e970-c33c-7b848ae5ed45@huawei.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 19 Sep 2022 11:40:13 +0100
X-Gmail-Original-Message-ID: <CAHmME9qWQxkDRY+TG=QL_mSZqd+vNTn186L4kbZfKEbimQcD0Q@mail.gmail.com>
Message-ID: <CAHmME9qWQxkDRY+TG=QL_mSZqd+vNTn186L4kbZfKEbimQcD0Q@mail.gmail.com>
Subject: Re: Inquiry about the removal of flag O_NONBLOCK on /dev/random
To:     "Guozihua (Scott)" <guozihua@huawei.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        zhongguohua <zhongguohua1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On Mon, Sep 19, 2022 at 11:27 AM Guozihua (Scott) <guozihua@huawei.com> wrote:
>
> On 2022/9/8 17:51, Jason A. Donenfeld wrote:
> > Hi,
> >
> > On Thu, Sep 08, 2022 at 11:31:31AM +0800, Guozihua (Scott) wrote:
> >> For example:
> >>
> >>
> >> --
> >> Best
> >> GUO Zihua
> >>
> >> --
> >> Best
> >> GUO Zihua
> >
> > Looks like you forgot to paste the example...
> >
> >> Thank you for the timely respond and your patient. And sorry for the
> >> confusion.
> >>
> >> First of all, what we think is that this change (removing O_NONBLOCK) is
> >> reasonable. However, this do cause issue during the test on one of our
> >> product which uses O_NONBLOCK flag the way I presented earlier in the
> >> Linux 4.4 era. Thus our colleague suggests that returning -EINVAL when
> >> this flag is received would be a good way to indicate this change.
> >
> > No, I don't think it's wise to introduce yet *new* behavior (your
> > proposed -EINVAL). That would just exacerbate the (mostly) invisible
> > breakage from the 5.6-era change.
> >
> > The question now before us is whether to bring back the behavior that
> > was there pre-5.6, or to keep the behavior that has existed since 5.6.
> > Accidental regressions like this (I assume it was accidental, at least)
> > that are unnoticed for so long tend to ossify and become the new
> > expected behavior. It's been around 2.5 years since 5.6, and this is the
> > first report of breakage. But the fact that it does break things for you
> > *is* still significant.
> >
> > If this was just something you noticed during idle curiosity but doesn't
> > have a real impact on anything, then I'm inclined to think we shouldn't
> > go changing the behavior /again/ after 2.5 years. But it sounds like
> > actually you have a real user space in a product that stopped working
> > when you tried to upgrade the kernel from 4.4 to one >5.6. If this is
> > the case, then this sounds truly like a userspace-breaking regression,
> > which we should fix by restoring the old behavior. Can you confirm this
> > is the case? And in the meantime, I'll prepare a patch for restoring
> > that old behavior.
> >
> > Jason
> > .
>
> Hi Jason
>
> Thank for your patience.
>
> To answer your question, yes, we do have a userspace program reading
> /dev/random during early boot which relies on O_NONBLOCK. And this
> change do breaks it. The userspace program comes from 4.4 era, and as
> 4.4 is going EOL, we are switching to 5.10 and the breakage is reported.
>
> It would be great if the kernel is able to restore this flag for
> backward compatibility.

Alright then. Sounds like a clear case of userspace being broken. I'll
include https://git.zx2c4.com/linux-rng/commit/?id=b931eaf6ef5cef474a1171542a872a5e270e3491
or similar in my pull for 6.1, if that's okay with you. For 6.0, we're
already at rc6, so maybe better to let this one stew for a bit longer,
given the change, unless you feel strongly about having it earlier, I
guess.

Jason
