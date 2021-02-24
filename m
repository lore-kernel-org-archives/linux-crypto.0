Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFF1C433DB
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 17:43:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5BBE64E90
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 17:43:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbhBXRnR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 12:43:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:53704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229594AbhBXRnQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 12:43:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 697EE64EC4
        for <linux-crypto@vger.kernel.org>; Wed, 24 Feb 2021 17:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614188555;
        bh=X1ac+OpvnCT+uyEuBgb8T0Qwu4OjvGB9QsfK/vP2hP0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=nrKeEP749PtolT0EsjpmIeAWrR70W+dN+2JYGV4X0Nx5fvzfhX0P63CYSdxYoNCXt
         nwkhAZ34yy0sZ0ZW4wePrQEIR9Fl4iLWn1esdomOMiG473EidJCPkeJ2RpBrmRZCWV
         ARvUVhSAKt0oEBsFbopYSqkTLq10U4FwTcg7aMtQcjjqX9p+KWKfXldE1iKPLUgg4T
         5wZmKQZEskOr0TCHbwG4+oM2po1KloLlVkW6jxRrl9aHlHJJJzw5HQEu73MGrmUhdy
         vIHtAc6r+jJJ9eBzKvm2cISS5SS7/2scOOfNm9BxW5vICJgRHYsDMg+6cNMWDezWrT
         HGS9ET1m2QAZQ==
Received: by mail-ed1-f45.google.com with SMTP id h10so3599306edl.6
        for <linux-crypto@vger.kernel.org>; Wed, 24 Feb 2021 09:42:35 -0800 (PST)
X-Gm-Message-State: AOAM533rp3QU5aRkClh+3syc99TSGLdY8Mzw/XJ6Xz4RrHAkr9HJAp5i
        4hS/po6/N0b5UqjJn0OWMqYkfBYe5vdo/bX1tBIDGQ==
X-Google-Smtp-Source: ABdhPJx38CugYF/AbeapHGaaQYAavclW1nNIgt2STBDnyFQG7di+0KHd8Lzs/ON4SWvvkaZW3l0vFRLS8s51m4uvnXE=
X-Received: by 2002:a05:6402:27cd:: with SMTP id c13mr34122575ede.263.1614188553686;
 Wed, 24 Feb 2021 09:42:33 -0800 (PST)
MIME-Version: 1.0
References: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
 <CALCETrU06cuvUF5NDSm8--dy3dOkxYQ88cGWaakOQUE4Vkz88w@mail.gmail.com> <3878af8d-ac1e-522a-7c9f-fda4a1f5b967@intel.com>
In-Reply-To: <3878af8d-ac1e-522a-7c9f-fda4a1f5b967@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 24 Feb 2021 09:42:21 -0800
X-Gmail-Original-Message-ID: <CALCETrUWgLwp6yfu9ODY1UYufHeAgsnOOCOAwXZQK6FJk_YdUA@mail.gmail.com>
Message-ID: <CALCETrUWgLwp6yfu9ODY1UYufHeAgsnOOCOAwXZQK6FJk_YdUA@mail.gmail.com>
Subject: Re: [RFC V2 0/5] Introduce AVX512 optimized crypto algorithms
To:     "Dey, Megha" <megha.dey@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Ravi V. Shankar" <ravi.v.shankar@intel.com>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, greg.b.tucker@intel.com,
        "Kasten, Robert A" <robert.a.kasten@intel.com>,
        rajendrakumar.chinnaiyan@intel.com, tomasz.kantecki@intel.com,
        ryan.d.saffores@intel.com, ilya.albrekht@intel.com,
        Kyung Min Park <kyung.min.park@intel.com>,
        Weiny Ira <ira.weiny@intel.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 23, 2021 at 4:54 PM Dey, Megha <megha.dey@intel.com> wrote:
>
> Hi Andy,
>
> On 1/24/2021 8:23 AM, Andy Lutomirski wrote:
> > On Fri, Jan 22, 2021 at 11:29 PM Megha Dey <megha.dey@intel.com> wrote:
> >> Optimize crypto algorithms using AVX512 instructions - VAES and VPCLMU=
LQDQ
> >> (first implemented on Intel's Icelake client and Xeon CPUs).
> >>
> >> These algorithms take advantage of the AVX512 registers to keep the CP=
U
> >> busy and increase memory bandwidth utilization. They provide substanti=
al
> >> (2-10x) improvements over existing crypto algorithms when update data =
size
> >> is greater than 128 bytes and do not have any significant impact when =
used
> >> on small amounts of data.
> >>
> >> However, these algorithms may also incur a frequency penalty and cause
> >> collateral damage to other workloads running on the same core(co-sched=
uled
> >> threads). These frequency drops are also known as bin drops where 1 bi=
n
> >> drop is around 100MHz. With the SpecCPU and ffmpeg benchmark, a 0-1 bi=
n
> >> drop(0-100MHz) is observed on Icelake desktop and 0-2 bin drops (0-200=
Mhz)
> >> are observed on the Icelake server.
> >>
> >> The AVX512 optimization are disabled by default to avoid impact on oth=
er
> >> workloads. In order to use these optimized algorithms:
> >> 1. At compile time:
> >>     a. User must enable CONFIG_CRYPTO_AVX512 option
> >>     b. Toolchain(assembler) must support VPCLMULQDQ and VAES instructi=
ons
> >> 2. At run time:
> >>     a. User must set module parameter use_avx512 at boot time
> >>     b. Platform must support VPCLMULQDQ and VAES features
> >>
> >> N.B. It is unclear whether these coarse grain controls(global module
> >> parameter) would meet all user needs. Perhaps some per-thread control =
might
> >> be useful? Looking for guidance here.
> >
> > I've just been looking at some performance issues with in-kernel AVX,
> > and I have a whole pile of questions that I think should be answered
> > first:
> >
> > What is the impact of using an AVX-512 instruction on the logical
> > thread, its siblings, and other cores on the package?
> >
> > Does the impact depend on whether it=E2=80=99s a 512-bit insn or a shor=
ter EVEX insn?
> >
> > What is the impact on subsequent shorter EVEX, VEX, and legacy
> > SSE(2,3, etc) insns?
> >
> > How does VZEROUPPER figure in?  I can find an enormous amount of
> > misinformation online, but nothing authoritative.
> >
> > What is the effect of the AVX-512 states (5-7) being =E2=80=9Cin use=E2=
=80=9D?  As far
> > as I can tell, the only operations that clear XINUSE[5-7] are XRSTOR
> > and its variants.  Is this correct?
> >
> > On AVX-512 capable CPUs, do we ever get a penalty for executing a
> > non-VEX insn followed by a large-width EVEX insn without an
> > intervening VZEROUPPER?  The docs suggest no, since Broadwell and
> > before don=E2=80=99t support EVEX, but I=E2=80=99d like to know for sur=
e.
> >
> >
> > My current opinion is that we should not enable AVX-512 in-kernel
> > except on CPUs that we determine have good AVX-512 support.  Based on
> > some reading, that seems to mean Ice Lake Client and not anything
> > before it.  I also think a bunch of the above questions should be
> > answered before we do any of this.  Right now we have a regression of
> > unknown impact in regular AVX support in-kernel, we will have
> > performance issues in-kernel depending on what user code has done
> > recently, and I'm still trying to figure out what to do about it.
> > Throwing AVX-512 into the mix without real information is not going to
> > improve the situation.
>
> We are currently working on providing you with answers on the questions
> you have raised regarding AVX.

Thanks!
