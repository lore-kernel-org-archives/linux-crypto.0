Return-Path: <SRS0=di3S=XW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB37C4360C
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 16:24:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1657D21850
	for <linux-crypto@archiver.kernel.org>; Fri, 27 Sep 2019 16:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1569601452;
	bh=kY+3GXp7gELL7DLAh7u7Htbuj28YpJK9nqVFdw/2w2U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=oivkC+Fa8r7nPSKcajYVIfap1mv8BWkMyi/ZwDLCBTU9evr6l4SsbIwoIRBhf2RF9
	 AhlcEbZmGK2AXy6azJEdzd40/uxzDfQXlWf3lhnN/grQ7pR3JCv31p6OtS1uH0+94I
	 qTC8XgVTSdp7lL2J3HNUwt8DHYci7kcgwUOppuVQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfI0QYL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 27 Sep 2019 12:24:11 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41070 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfI0QYK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 27 Sep 2019 12:24:10 -0400
Received: by mail-lj1-f194.google.com with SMTP id f5so3080610ljg.8
        for <linux-crypto@vger.kernel.org>; Fri, 27 Sep 2019 09:24:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0ZSEhf5bO/SF1c0tSKvmNNeWxWL147w5YdOvl2Gnjpw=;
        b=KU36TUyGvfLb65v10CffeuYRR2Y01pARWIeV/Vo2qTbklo0V+XA7MrpdKGqR8Ak/KF
         7xi3WhZMUWFK5wmMlbUFTMpDFM+pU5EJBRaIuZosAYuB/0qdZiP1XToldMkdMHQ3GmKk
         gv11WbFW6DUox0vozNZvM6ewmDOPeiEUTX56c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0ZSEhf5bO/SF1c0tSKvmNNeWxWL147w5YdOvl2Gnjpw=;
        b=mZd52DVlvtdhkyQQsN25BQRsNX82pInlP3GNpljIU3FJVO/SAivRMAqu9KehisRrIR
         Z8VL/w4D6qgq617H+0CBg5UcWDXO+HVLxwUjXQ7sPTz+9ga3gqRHBHm++Wum0cQM8a46
         a1xYDsixTDfx45p75XiKq0Gh8BnKleuXO0e3qUGh1Ug5cwFlek8x5sOvsirtbvA841i/
         p7nzqYyFNRWx2O55AFSflGmWZ76WMHrAtcbfFgTGewKql3hcJgtpJACFtxpDkF1/W931
         ZicXJ8T2GATuIErkiDfs2yKnK6l4Av77dP+JBWnpUULy5E2cULzrrLqfKoGXJ/Z2xmdT
         XAtQ==
X-Gm-Message-State: APjAAAWaK91lVP1a5EIjxsEYTpAiJwHjb8uygqaJdlW62X60zkY9z+Wc
        ctjQb9/ErM7AUNuNpk13ADWGgLzbhd8=
X-Google-Smtp-Source: APXvYqwtwiZIB7iRiGxLCCOwZ3z7kVL7BbseQP/7yPkCxqr5KJbSXyQ2tm4Iu5V+a73D1Ydiqk+o7g==
X-Received: by 2002:a2e:58a:: with SMTP id 132mr3360431ljf.132.1569601447364;
        Fri, 27 Sep 2019 09:24:07 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id x25sm550332ljb.60.2019.09.27.09.24.05
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 09:24:06 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id 7so3088173ljw.7
        for <linux-crypto@vger.kernel.org>; Fri, 27 Sep 2019 09:24:05 -0700 (PDT)
X-Received: by 2002:a2e:1208:: with SMTP id t8mr3435615lje.84.1569601445451;
 Fri, 27 Sep 2019 09:24:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190925161255.1871-1-ard.biesheuvel@linaro.org>
 <20190925161255.1871-19-ard.biesheuvel@linaro.org> <CAHk-=wjYsbxSiV_XKWV3BwGvau_hUvQiQHLOoc7vLUZt0Wqzfw@mail.gmail.com>
 <CH2PR20MB29680F87B32BBF0495720172CA860@CH2PR20MB2968.namprd20.prod.outlook.com>
 <CAHk-=wgR_KsYw2GmZwkG3GmtX6nbyj0LEi7rSqC+uFi3ScTYcw@mail.gmail.com>
 <MN2PR20MB297317D9870A3B93B5E506C9CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAHk-=wjr1w7x9Rjre_ALnDLASYNjsEHxu6VJpk4eUwZXN0ntqw@mail.gmail.com> <MN2PR20MB2973A696B92A8C5A74A738F1CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973A696B92A8C5A74A738F1CA810@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 27 Sep 2019 09:23:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj9BSMzoDD31R-ymjGpkpt0u-ndX6+p0ZWsrJFDTAN+zg@mail.gmail.com>
Message-ID: <CAHk-=wj9BSMzoDD31R-ymjGpkpt0u-ndX6+p0ZWsrJFDTAN+zg@mail.gmail.com>
Subject: Re: [RFC PATCH 18/18] net: wireguard - switch to crypto API for
 packet encryption
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 27, 2019 at 2:58 AM Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > I'd want to see wireguard in an end-to-end situation from the very
> > client hardware. So laptops, phones, desktops. Not the untrusted (to
> > me) hw in between.
> >
> I don't see why the crypto HW would deserve any less trust than, say,
> the CPU itself. I would say CPU's don't deserve that trust at the moment.

It's not the crypto engine that is part of the untrusted hardware.
It's the box itself, and the manufacturer, and you having to trust
that the manufacturer didn't set up some magic knocking sequence to
disable the encryption.

Maybe the company that makes them is trying to do a good job. But
maybe they are based in a country that has laws that require
backdoors.

Say, France. There's a long long history of that kind of thing.

It's all to "fight terrorism", but hey, a little industrial espionage
is good too, isn't it? So let's just disable GSM encryption based on
geographic locale and local regulation, shall we.

Yeah, yeah, GSM encryption wasn't all that strong to begin with, but
it was apparently strong enough that France didn't want it.

So tell me again why I should trust that box that I have no control over?

> Well, that's the general idea of abstraction. It also allows for
> swapping in any other cipher with minimal effort just _because_ the
> details were hidden from the application. So it may cost you some
> effort initially, but it may save you effort later.

We clearly disagree on the utility of crypto agility. You point to
things like ipsec as an argument for it.

And I point to ipsec as an argument *against* that horror. It's a
bloated, inefficient, horribly complex mess. And all the "agility" is
very much part of it.

I also point to GSM as a reason against "agility". It has caused way
more security problems than it has ever solved. The ":agility" is
often a way to turn off (or tune down) the encryption, not as a way to
say "ok, we can improve it later".

That "we can improve it later" is a bedtime story. It's not how it
gets used. Particularly as the weaknesses are often not primarily in
the crypto algorithm itself, but in how it gets used or other session
details.

When you actually want to *improve* security, you throw the old code
away, and start a new protocol entirely. Eg SSL -> TLS.

So cryptographic agility is way oversold, and often people are
actively lying about why they want it. And the people who aren't lying
are ignoring the costs.

One of the reasons _I_ like wireguard is that it just went for simple
and secure. No BS.

And you say

> Especially since all crypto it uses comes from a single
> source (DJB), which is frowned upon in the industry.

I'm perhaps not a fan of DJB in all respects, but there's no question
that he's at least competent.

The "industry practice" of having committees influenced by who knows
what isn't all that much better. Do you want to talk about NSA
elliptic curve constant choices?

Anyway, on the costs:

> >  - dynamically allocate buffers at "init time"
>
> Why is that so "wrong"? It sure beats doing allocations on the hot path.

It's wrong not becasue the allocation is costly (you do that only
once), but because the dynamic allocation means that you can't embed
stuff in your own native data structures as a user.

So now accessing those things is no longer dense in the cache.

And it's the cache that matters for a synchronous CPU algorithm. You
don't want the keys and state to be in some other location when you
already have your data structures for the stream that could just have
them right there with the other data.

> And you don't want to have it on the stack initially and then have
> to _copy_ it to some DMA-able location that you allocate on the fly
> on the hot path if you _do_ want HW acceleration.

Actually, that's *exactly* what you want. You want keys etc to be in
regular memory in a location that is convenient to the user, and then
only if the hardware has issues do you say "ok, copy the key to the
hardware". Because quite often the hardware will have very special key
caches that aren't even available to the CPU, because they are on some
hw-private buffers.

Yes, you want to have a "key identity" model so that the hardware
doesn't have to reload it all the time, but that's an invalidation
protocol, not a "put the keys or nonces in special places".

               Linus
