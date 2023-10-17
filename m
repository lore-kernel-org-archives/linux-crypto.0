Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B2C3CDB474
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Oct 2023 06:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbjJQGnp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Oct 2023 02:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjJQGnp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2023 02:43:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E9595
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2023 23:43:43 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76B35C433CA
        for <linux-crypto@vger.kernel.org>; Tue, 17 Oct 2023 06:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697525023;
        bh=F8JeGIf5fTjeDtn0mUwOr+jYS5d6XeOTNY/HUJJf2yw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=CtZxMROGhxdmOhrZYL29MudLcCSM3Mgd1CAsvuBE9gENODEAhCORdXTrs+O6mBUl5
         IpESHo3FPx+Iwyl5VoqcklH6Cx7OQChvwXhvWStsnDFngMyWF1Z6aXjuL88UQQMpJq
         QbI2XKWuVIM84/z1XIjD3wvN0lRi4l3dd+LbjsSP64dXtbrqY0HyzAVwAj4Xn8/wnY
         pxaoLJ7nav6UtBPrQm7dpsvnYifSHelrtvSxerCED5aorHQ6pqhAa3zOh5rUBvsey8
         /2wmIx2ZD7w5hgq3/9Vf1JAl4Hh4Rc5I+BEzp002nNvWpMUx2fYdWFf7fLyK2v6cOL
         uvcKXrY0pYFaw==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2c51682fddeso29248591fa.1
        for <linux-crypto@vger.kernel.org>; Mon, 16 Oct 2023 23:43:43 -0700 (PDT)
X-Gm-Message-State: AOJu0YzjPo8nMVyRZCzenlDsX2sF7iJ53a0lcFOZ4JNkudBqkk4OHnxG
        Tud5E1dyfigHaYc3TMORxxQTMqW9aCbAZwQEPvQ=
X-Google-Smtp-Source: AGHT+IGp+B9GxjFmRnRMebJKwwMveFs/A1UjFAxuLyyyKs9MjeF1EO9nZ0m29C6P0KyTfZx/i5KuVSsBi0mx9B55dc0=
X-Received: by 2002:a2e:9594:0:b0:2c5:d0c:237e with SMTP id
 w20-20020a2e9594000000b002c50d0c237emr427190ljh.17.1697525021653; Mon, 16 Oct
 2023 23:43:41 -0700 (PDT)
MIME-Version: 1.0
References: <20201210121627.GB28441@gondor.apana.org.au> <CAMj1kXE-+35tfO87024xB274ZVOu7HTHqDa8o-hjoxDasd8p7g@mail.gmail.com>
 <CAMj1kXH5LPib2vPgLkdzHX4gSawDSE=ij451s106_xTuT19YmA@mail.gmail.com>
 <20201215091902.GA21455@gondor.apana.org.au> <062a2258-fad4-2c6f-0054-b0f41786ff85@candelatech.com>
 <Y2sj84u/w/nOgKwx@gondor.apana.org.au> <CAMj1kXG3id6ABX=5D4H0XLmVnijHCY6whp09U5pLQr0Ftf5Gzw@mail.gmail.com>
 <6e20b593-393c-9fa1-76aa-b78951b1f2f3@candelatech.com> <CAMj1kXEqcPvb-uLvGLhue=6eME-6WhuPgoG+HgLH0EoZLE9aZA@mail.gmail.com>
 <32a44a29-c5f4-f5fa-496f-a9dc98d8209d@candelatech.com> <20231017031603.GB1907@sol.localdomain>
In-Reply-To: <20231017031603.GB1907@sol.localdomain>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 17 Oct 2023 08:43:29 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFRpbGJ_nkomb88o3F5Eg9ghh+xTZgGgeD7wfC3uwSk0g@mail.gmail.com>
Message-ID: <CAMj1kXFRpbGJ_nkomb88o3F5Eg9ghh+xTZgGgeD7wfC3uwSk0g@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: aesni - add ccm(aes) algorithm implementation
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ben Greear <greearb@candelatech.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 17 Oct 2023 at 05:16, Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Oct 16, 2023 at 01:50:05PM -0700, Ben Greear wrote:
> > On 11/12/22 06:59, Ard Biesheuvel wrote:
> > > On Fri, 11 Nov 2022 at 23:29, Ben Greear <greearb@candelatech.com> wrote:
> > > >
> > > > On 11/9/22 2:05 AM, Ard Biesheuvel wrote:
> > > > > On Wed, 9 Nov 2022 at 04:52, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > > > >
> > > > > > On Tue, Nov 08, 2022 at 10:50:48AM -0800, Ben Greear wrote:
> > > > > > >
> > > > > > > While rebasing my patches onto 6.1-rc4, I noticed my aesni for ccm(aes) patch didn't apply cleanly,
> > > > > > > and I found this patch described below is applied now.  Does this upstream patch mean that aesni is already
> > > > > > > supported upstream now?  Or is it specific to whatever xctr is?  If so,
> > > > > > > any chance the patch is wanted upstream now?
> > > > > >
> > > > > > AFAICS the xctr patch has nothing to do with what you were trying
> > > > > > to achieve with wireless.  My objection still stands with regards
> > > > > > to wireless, we should patch wireless to use the async crypto
> > > > > > interface and not hack around it in the Crypto API.
> > > > > >
> > > > >
> > > > > Indeed. Those are just add/add conflicts because both patches
> > > > > introduce new code into the same set of files. The resolution is
> > > > > generally to keep both sides.
> > > > >
> > > > > As for Herbert's objection: I will note here that in the meantime,
> > > > > arm64 now has gotten rid of the scalar fallbacks entirely in AEAD and
> > > > > skipcher implementations, because those are only callable in task or
> > > > > softirq context, and the arm64 SIMD wrappers now disable softirq
> > > > > processing. This means that the condition that results in the fallback
> > > > > being needed can no longer occur, making the SIMD helper dead code on
> > > > > arm64.
> > > > >
> > > > > I suppose we might do the same thing on x86, but since the kernel mode
> > > > > SIMD handling is highly arch specific, you'd really need to raise this
> > > > > with the x86 maintainers.
> > > > >
> > > >
> > > > Hello Ard,
> > > >
> > > > Could you please review the attached patch to make sure I merged it properly?  My concern
> > > > is the cleanup section and/or some problems I might have introduced related to the similarly
> > > > named code that was added upstream.
> > > >
> > >
> > > I don't think the logic is quite right, although it rarely matter.
> > >
> > > I've pushed my version here - it invokes the static call for CTR so it
> > > will use the faster AVX version if the CPU supports it.
> > >
> > > https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/log/?h=aesni-ccm-v6.1
> >
> > Hello Ard,
> >
> > It looks like something changed again in the intel-aesni logic for 6.6 kernel.  I was able to do a small
> > change to the patch to get it to compile, but the kernel crashes when I bring up a wlan port in
> > 6.6.  When I remove the aesni patch, the station comes up without crashing.  The aesni patch worked
> > fine in 6.5 as far as I can tell.
> >
> > I'm attaching my slightly modified version of the patch you sent previous.  If you have time to
> > investigate this it would be much appreciated.
> >
> > Thanks,
> > Ben
>
> If this patch is useful, shouldn't it be upstreamed?
>

It was rejected by Herbert on the basis that the wireless stack should
be converted to use the async API instead.
