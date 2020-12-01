Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30CDBC64E7A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 23:25:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C73252224B
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 23:25:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgLAXZl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 18:25:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:49670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbgLAXZl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 18:25:41 -0500
X-Gm-Message-State: AOAM531qVqv1QRDtf0lw1HVdT+vsLNaeu2g+maL3U8nAL/ovt5CkOFo3
        N8Kpmln/AMwd9Ty08Nu2DGoJBe0Tvirl544jamQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606865100;
        bh=+twFJzadEQPpWxtqzDlpHNCdocdPt6nS4b0nAPoH0jU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AJ18POTpMTToGB7395mWThu2vPRzn4OIOJ/Ip6UpaWDSl8+VslGbyJWE/d8gOoOH1
         sBjahF7Zomcxzc2yvcwd4G/bpQlcVB2/xd64BogV2kKJdBjNZEA87Yzyl3IFRHumvK
         Ofs6ZKfeOjTkrDBBMS3Dp0GCBsnZt/Iv8UDennaM=
X-Google-Smtp-Source: ABdhPJyXEj0Hr5UBgCQj0UPzCu4omMDwhLx7l6V0eOJhVp44wX7KCeLyKUOoBggTOzmirnelAOQvs1qCGGoxZrivL/c=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr3622252otk.108.1606865098855;
 Tue, 01 Dec 2020 15:24:58 -0800 (PST)
MIME-Version: 1.0
References: <20201201194556.5220-1-ardb@kernel.org> <20201201215722.GA31941@gondor.apana.org.au>
 <CAMj1kXHb27ugTWuQZhPD0DvjtgYC8t_pj+igqK7dNfh+WsUS4w@mail.gmail.com>
 <20201201220431.GA32072@gondor.apana.org.au> <CAMj1kXGO+kbZ+2VmUQKxLYos2nR5vqZKjengxPxPjSXudG-zLw@mail.gmail.com>
 <20201201221628.GA32130@gondor.apana.org.au> <CAMj1kXFrLiHfv1S1AM=5pc1J9gWwZVuoGvmFoTT0-+oREoojTA@mail.gmail.com>
 <20201201231158.GA32274@gondor.apana.org.au>
In-Reply-To: <20201201231158.GA32274@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 2 Dec 2020 00:24:47 +0100
X-Gmail-Original-Message-ID: <CAMj1kXE2RULwwxAGRTeACQVCpYoeuY3LmMK0hw4BOQo1gH5d8Q@mail.gmail.com>
Message-ID: <CAMj1kXE2RULwwxAGRTeACQVCpYoeuY3LmMK0hw4BOQo1gH5d8Q@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@cal-sierra.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2 Dec 2020 at 00:12, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Dec 01, 2020 at 11:27:52PM +0100, Ard Biesheuvel wrote:
> >
> > > The problem is that the degradation would come at the worst time,
> > > when the system is loaded.  IOW when you get an interrupt during
> > > your TX path and get RX traffic that's when you'll take the fallback
> > > path.
> >
> > I can see how in the general case, this is something you would prefer
> > to avoid. However, on SMP x86_64 systems that implement AES-NI (which
> > runs at ~1 cycle per byte), I don't see this as a real problem for
> > this driver.
>
> AES-NI is 1 cycle per byte but the fallback is not.
>

True. But the fallback only gets executed if the scheduler is stupid
enough to schedule the TX task onto the core that is overloaded doing
RX softirqs. So in the general case, both TX and RX will be using
AES-NI instructions (unless the CCMP is done in hardware which is the
most common case by far)

> > What we could do is expose both versions, where the async version has
> > a slightly higher priority, so that all users that do support the
> > async interface will get it, and the wifi stack can use the sync
> > interface instead.
>
> No we've already tried this with IPsec and it doesn't work.  That's
> why the async path exists in aesni.
>
> Wireless is no different to IPsec in this respect.
>

Wireless is very different. Wifi uses a medium that is fundamentally
shared, and so the load it can induce is bounded. There is no way a
wifi interface is going to saturate a 64-bit AES-NI core doing CCMP in
software.

Given the above, can't we be pragmatic here? This code addresses a
niche use case, which is not affected by the general concerns
regarding async crypto.
