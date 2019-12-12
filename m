Return-Path: <SRS0=MXL1=2C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D13A6C43603
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 14:30:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9211E22527
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Dec 2019 14:30:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="rUIj2xwk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729752AbfLLOaz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Dec 2019 09:30:55 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:52105 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729612AbfLLOay (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Dec 2019 09:30:54 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 0002d49a
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=iehgp+nXsGk8SuvtzvDstSbnKtM=; b=rUIj2x
        wknQfs5R5cqVVmb2UhBpfGLJRSZ+hxkHE/g1dIP8pji1XnNGPPmc9d7QdrQufNL5
        m4hvy36eDN43zYvujBWE8zpgSFiZ7axVOKSGnX2X3HU7edpipeijYRX7T+oKkWq4
        z3sEMiu8E04aqCPA0MKzFFrKwQtWBUjBSB+EerVlc2veS1PqXkE4jYDANEjYHCaH
        1IAPWkE4OKVLpia6lLHf+NuqfTX1MtaYh/mTalHiPuIL0hMCqahZtpo61Nwt0A4+
        6h6kYjgXEkegTrunIEIiNPqh7XipXM2au7iVHO07ZKxmzkWFeLBv9cYrmzw42cyN
        5vsywf/1Y7NaePPg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 41d5348e (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 12 Dec 2019 13:35:04 +0000 (UTC)
Received: by mail-oi1-f170.google.com with SMTP id a124so540707oii.13
        for <linux-crypto@vger.kernel.org>; Thu, 12 Dec 2019 06:30:52 -0800 (PST)
X-Gm-Message-State: APjAAAXsuBVpp6Zbqqdlk9A51QL7b2xgiwGYF6P3FMfpXZKuNtzDCPDM
        41XALau9H4XEpv+8ktVdaPh05IGBlD3GdYK39LQ=
X-Google-Smtp-Source: APXvYqzXh34RlNRnz1wuJGB6xzQtAht+OGSgv0wuSv1vrBjsgyY9uo3dhE6YnDNS0jJ/Rth3FkvCY3ijBjUAzS75EcA=
X-Received: by 2002:aca:5143:: with SMTP id f64mr4942382oib.66.1576161051500;
 Thu, 12 Dec 2019 06:30:51 -0800 (PST)
MIME-Version: 1.0
References: <20191211170936.385572-1-Jason@zx2c4.com> <20191212093008.217086-1-Jason@zx2c4.com>
 <d55e0390c7187b09f820e123b05df1e5e680df0b.camel@strongswan.org>
 <CAHmME9ovvwX3Or1ctRH8U5PjpNNMe9ixOZLi3F0vbO9SqA04Ow@mail.gmail.com>
 <CAHmME9reEXXSmQr+6vPM1cwr+pjvwPwJ5n3UZ0BUSjO2kQQcNg@mail.gmail.com> <CAKv+Gu80EVN-_aHPSYUu=0TvFJERBMKFvQS-gce3z_jx=X7www@mail.gmail.com>
In-Reply-To: <CAKv+Gu80EVN-_aHPSYUu=0TvFJERBMKFvQS-gce3z_jx=X7www@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Thu, 12 Dec 2019 15:30:39 +0100
X-Gmail-Original-Message-ID: <CAHmME9oQ-Yj2WWuvNj1KNm=d4+PgnVFOusnh8HG0=yYWdi2UXQ@mail.gmail.com>
Message-ID: <CAHmME9oQ-Yj2WWuvNj1KNm=d4+PgnVFOusnh8HG0=yYWdi2UXQ@mail.gmail.com>
Subject: Re: [PATCH crypto-next v2 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Martin Willi <martin@strongswan.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Dec 12, 2019 at 3:26 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On Thu, 12 Dec 2019 at 14:47, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > On Thu, Dec 12, 2019 at 2:08 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > >
> > > Hi Martin,
> > >
> > > On Thu, Dec 12, 2019 at 1:03 PM Martin Willi <martin@strongswan.org> wrote:
> > > > Can you provide some numbers to testify that? In my tests, the 32-bit
> > > > version gives me exact the same results.
> > >
> > > On 32-bit, if you only call update() once, then the results are the
> > > same. However, as soon as you call it more than once, this new version
> > > has increasing gains. Other than that, they should behave pretty much
> > > identically.
> >
> > Oh, you asked for numbers. I just fired up an Armada 370/XP and am
> > seeing a 8% increase in performance on calls to the update function.
>
> It would help if we could get some actual numbers. I usually try to
> capture the performance delta for a small set of block sizes that are
> significant for the use case at hand, e.g., like so [0], and also
> include blocksizes that are not 2^n. If the change improves the
> general case without causing any significant regressions elsewhere, I
> don't think we need to continue this debate.

I'm not sure I understand why the 32x32 performance discussion is even
happening in the first place. The new 32x32 code most certainly
doesn't make anything worse. It most likely makes some things better
in some places -- 8% on that machine I fired up, maybe more and maybe
less other places. But who even cares? The principle advantage of this
patchset is the 64x64 code, and I think we gain something else,
immeasurable, by having parallel and comparable implementations.
Please, let's not turn this into another pointless debate.
