Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88418C64E90
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 23:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3184A22261
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 23:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgLAXm3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 18:42:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:51670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727046AbgLAXm3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 18:42:29 -0500
X-Gm-Message-State: AOAM530C8aXBtWOi6SMLgKNTK5AKy1NmXHSKKUV431YmsApovkvlhZCU
        2dQcPVn+78LCaB2JtT0+vB/yKMV+wUe0fk3IO4U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606866108;
        bh=S0e8qOgN+iRW8W/+JNaIHLOYPv7to3nrUyCAxe7bt34=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fVbWXn/HypZpWTgRBEOnji3/wE0wWGoVkjq7EZ2TZOPSr52WKQFWLtZmTeK4JqJrB
         uCpiXiTBNO9GXEO/dREUURnrA3dmOEwDuE2/T8ikOKlcOpnXqMa1cW4aNJtngFzb/D
         avjEHxprq7w297OlaVPEj7tfp1nzLf3ylTG9mnXg=
X-Google-Smtp-Source: ABdhPJyx5r0pF+BTklx7f09deGmXgLmyAKLazg98T7LCwCts0zXi5hJMUiZneTySA5DytNC3NLgkyh0Egv9UQytq7Lc=
X-Received: by 2002:a05:6830:214c:: with SMTP id r12mr3647640otd.90.1606866107385;
 Tue, 01 Dec 2020 15:41:47 -0800 (PST)
MIME-Version: 1.0
References: <20201201194556.5220-1-ardb@kernel.org> <20201201215722.GA31941@gondor.apana.org.au>
 <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
 <20201201220431.GA32072@gondor.apana.org.au> <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au> <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
 <20201201231158.GA32274@gondor.apana.org.au> <CAMj1kXE2RULwwxAGRTeACQVCpYoeuY3LmMK0hw4BOQo1gH5d8Q@mail.gmail.com>
 <20201201233024.GB32382@gondor.apana.org.au>
In-Reply-To: <20201201233024.GB32382@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 2 Dec 2020 00:41:36 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEfRCNuaz_sX29CQ=JsUF6niYbYceXUjy9cq3=eF77mvg@mail.gmail.com>
Message-ID: <CAMj1kXEfRCNuaz_sX29CQ=JsUF6niYbYceXUjy9cq3=eF77mvg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@cal-sierra.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2 Dec 2020 at 00:30, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Dec 02, 2020 at 12:24:47AM +0100, Ard Biesheuvel wrote:
> >
> > True. But the fallback only gets executed if the scheduler is stupid
> > enough to schedule the TX task onto the core that is overloaded doing
> > RX softirqs. So in the general case, both TX and RX will be using
> > AES-NI instructions (unless the CCMP is done in hardware which is the
> > most common case by far)
>
> I don't think this makes sense.  TX is typically done in response
> to RX so the natural alignment is for it to be on the same CPU.
>

You just explained that TX typically runs in process context, whereas
RX is handled in softirq context. So how exactly are these going to
end up on the same core?

> > Wireless is very different. Wifi uses a medium that is fundamentally
> > shared, and so the load it can induce is bounded. There is no way a
> > wifi interface is going to saturate a 64-bit AES-NI core doing CCMP in
> > software.
>
> This sounds pretty tenuous.  In any case, even if wireless itself
> doesn't get you, there could be loads running on top of it, for
> example, IPsec.
>

Yes, but IPsec will not use the synchronous interface.

> > Given the above, can't we be pragmatic here? This code addresses a
> > niche use case, which is not affected by the general concerns
> > regarding async crypto.
>
> We already have a framework for acceleration that works properly
> in aesni, I don't want to see us introduce another broken model
> within the same driver.
>
> So either just leave the whole thing along or do it properly by
> making wireless async.
>

Fair enough. But it is unfortunate that we cannot support Ben's use
case without a lot of additional work that serves no purpose
otherwise.
