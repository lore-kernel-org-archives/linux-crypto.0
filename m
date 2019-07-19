Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EE19C76188
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 05:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDD332173B
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 05:34:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x7yc+G26"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbfGSFer (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 01:34:47 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41813 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbfGSFeq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 01:34:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so27724710wrm.8
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2019 22:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Iow/hRxvVSUjo+9McFqy4a9hVvzKVnwTDlHSRUZV1h8=;
        b=x7yc+G267SAGG4+G1mYrx99EtRd9meF6RmN/qzLyX6h7BW1cMrMG2uA5mCfLoPhRvK
         tyjNZBh3NRZ30JNiQVjC1dfbmHZs50BYyNcpaBR5Jl/egodlcFOx4lckK0TQKqrewwcI
         gj5SIZEybkRYNEC1kyAbgq9kQlZ3/ve4ZHq4STBdJuExOlqEXRj7M3XbDv3hUkhrAVKd
         9bbZNGP56jOz56RXjlYUPWQId5uYymwK6anBlKHMPZACUu1+fDL/R7S3LboWCql1x8Pg
         U1XPNQzm2/Kj/nekZmrLPdJ95DSoZGhEAO4/My9cNMdn8BQ+qZEmtHCPI+Bjswi2FQ6a
         3G8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Iow/hRxvVSUjo+9McFqy4a9hVvzKVnwTDlHSRUZV1h8=;
        b=nUsZ+vwVlzvInuWJwev04XS1i42CY8OtejZr9d0Yk1tar7Wu46Kch15yjV1BO/ZMI2
         mhN8M0D2QW/rLD6mJu91fEZ/EWp4QfRZIQ7r1b7TxRqYTuLJdsyDUDvC+FTqUpraZH+A
         WjNXtfu6IYIOzTvj23333mKo06OtPPj6tAiHnlrOEQ3eUg5LQwSjbMLK+ARW3VyDTiaK
         Rdlz9AiZqWvgjhsncQ+tLKAtqJX4WWsp85ItkyptAH7jaI2It0AqS3FOgPZ11Cwspc6n
         PwbHuflO7Mnp0QlLsISaHnbJ7WmOgOC22hdPaHhBmIONwdgGPlzsbUS7qznmr2sQhWVj
         mg9g==
X-Gm-Message-State: APjAAAXibiBl06a4Xx0mOEMEPjnKTmpQBKuqTNNshG40GHomZFNNhyQz
        u9mdJFENs49GrRXX+tagoT9uKhT6gC4N98wchx+ByQ==
X-Google-Smtp-Source: APXvYqz2wcEG7VJP1w6LyA/iBG8byNOjpWunC0K9KTLEbNjWP26NaeKKgMXdm5+Hi/0vRhX7nsRFDpDdWga8mlCP7sc=
X-Received: by 2002:a5d:428b:: with SMTP id k11mr23152900wrq.174.1563514484209;
 Thu, 18 Jul 2019 22:34:44 -0700 (PDT)
MIME-Version: 1.0
References: <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com> <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au> <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au> <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190718152908.xiuze3kb3fdc7ov6@gondor.apana.org.au> <MN2PR20MB2973E1A367986303566E80FCCAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190718155140.b6ig3zq22askmfpy@gondor.apana.org.au> <CAKv+Gu9qm8mDZASJasq18bW=4_oE-cKPGKvdF9+8=7VNo==_fA@mail.gmail.com>
 <MN2PR20MB2973DE308D0050DBF3F26870CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB2973DE308D0050DBF3F26870CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 19 Jul 2019 07:34:33 +0200
Message-ID: <CAKv+Gu8dE6EO1NOwni91cvEWJvPzieC3wKph73j2jWxzx_xKAw@mail.gmail.com>
Subject: Re: xts fuzz testing and lack of ciphertext stealing support
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Milan Broz <gmazyland@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 18 Jul 2019 at 19:03, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> > > > For XTS, you have this additional curve ball being thrown in called the "tweak".
> > > > For encryption, the underlying "xts" would need to be able to chain the tweak,
> > > > from what I've seen of the source the implementation cannot do that.
> > >
> > > You simply use the underlying xts for the first n - 2 blocks and
> > > do the last two by hand.
> > >
> >
> > OK, so it appears the XTS ciphertext stealing algorithm does not
> > include the peculiar reordering of the 2 final blocks, which means
> > that the kernel's implementation of XTS already conforms to the spec
> > for inputs that are a multiple of the block size.
> >
> Yes, for XTS you effectively don't do CTS if it's a 16 byte multiple ...
>
> > The reason I am not a fan of making any changes here is that there are
> > no in-kernel users that require ciphertext stealing for XTS, nor is
> > anyone aware of any reason why we should be adding it to the userland
> > interface. So we are basically adding dead code so that we are
> > theoretically compliant in a way that we will never exercise in
> > practice.
> >
> You know, having worked on all kinds of workarounds for silly irrelevant
> (IMHO) corner cases in  the inside-secure hardware driver over the past
> months just to keep testmgr happy, this is kind of ironic ...
>
> Cipher text stealing happens to be a *major* part of the XTS specification
> (it's not actually XTS without the CTS part!), yet you are suggesting not
> to implement it because *you* don't have or know a use case for it.
> That seems like a pretty bad argument to me. It's not some minor corner
> case that's not supported.The implementation is just *incomplete*
> without it.
>

I would argue that these cases are diametrically opposite: you
proposed to remove support for zero length input vectors from the
entire crypto API to prevent your driver from having to deal with
inputs that the hardware cannot handle.

I am proposing not to add support for cases that we have no need for.
XTS without CTS is indistinguishable from XTS with CTS if the inputs
are always a multiple of the block size, and in 12 years, nobody has
ever raised the issue that our support is limited to that. So what
problem are we fixing by changing this? dm-crypt does not care,
fscrypt does not care, userland does not care (given that it does not
work today and we are only finding out now due to some fuzz test
failing on CAAM)


> > Note that for software algorithms such as the bit sliced NEON
> > implementation of AES, which can only operate on 8 AES blocks at a
> > time, doing the final 2 blocks sequentially is going to seriously
> > impact performance. This means whatever wrapper we invent around xex()
> > (or whatever we call it) should go out of its way to ensure that the
> > common, non-CTS case does not regress in performance, and the special
> > handling is only invoked when necessary (which will be never).
> >
> I pretty much made the same argument about all these driver workarounds
> slowing down my driver fast path but that was considered a non-issue.
>
> In this particular case, it should not need to be more than:
>
> if (unlikely(size & 15)) {
>   xts_with_partial_last_block();
> } else {
>   xts_with_only_full_blocks();
> }
>

Of course. But why add this at all if it is known to be dead code?
