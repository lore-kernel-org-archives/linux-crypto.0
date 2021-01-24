Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61968C433DB
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jan 2021 16:25:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30F2422AAA
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Jan 2021 16:25:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbhAXQYy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Jan 2021 11:24:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbhAXQYx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Jan 2021 11:24:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C4AB22B48
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jan 2021 16:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611505450;
        bh=1TatI210WJgZj/jDJkhx6YRQcHibA+56Kuz+2iQjaQo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=JUzin1qaagQSdOCe0saIEC6Lcg6I6TB8FRLkwymOZAzITTK4/ND7zDqlIXbysyr3r
         njjVd/Am+NYDRQ3cwU8C1UOTFiziSahKWBu30zeVgTLnzo5ke/0um7dGingZKbcFzn
         qbD+s+kmdOA2gBgwsxFsZrWjufxKdMjRsPCvy2K2e0oD5F2x1D6nhHacYxKL0v2Lmy
         mvFm0wf5XRh7EK4WfzNWKqb0D45VQ122kJHoBFiNb+qIcMhMkJFyXPeTOXdKronCVB
         PngYcc1oIINwKSIa1SdRXmI/kXr6/Ddi25X4MCwzpObYA92oItcXwjstgnvE20H3l4
         hCG4MdCVdU08A==
Received: by mail-ed1-f51.google.com with SMTP id n6so12310552edt.10
        for <linux-crypto@vger.kernel.org>; Sun, 24 Jan 2021 08:24:10 -0800 (PST)
X-Gm-Message-State: AOAM533i0MxUmnSulhbnHbNU4qEy9n8ZGN92mFltDxX4wwTfZ2AosnQD
        pGRQrnNfHSgDRmIZ1/zLTm7I6BX4mE2JmV2wtnlbpw==
X-Google-Smtp-Source: ABdhPJzVcByeXM+JP9LIbSXDwhHu5/ZWNWLY6OgFIX7jGPsEyc8yHifDsfz1ffoN6RaVnzCwHs2MgaM+E/49hgsn8s0=
X-Received: by 2002:aa7:d4d2:: with SMTP id t18mr395846edr.238.1611505448819;
 Sun, 24 Jan 2021 08:24:08 -0800 (PST)
MIME-Version: 1.0
References: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
In-Reply-To: <1611386920-28579-1-git-send-email-megha.dey@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 24 Jan 2021 08:23:57 -0800
X-Gmail-Original-Message-ID: <CALCETrU06cuvUF5NDSm8--dy3dOkxYQ88cGWaakOQUE4Vkz88w@mail.gmail.com>
Message-ID: <CALCETrU06cuvUF5NDSm8--dy3dOkxYQ88cGWaakOQUE4Vkz88w@mail.gmail.com>
Subject: Re: [RFC V2 0/5] Introduce AVX512 optimized crypto algorithms
To:     Megha Dey <megha.dey@intel.com>, Tony Luck <tony.luck@intel.com>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
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

On Fri, Jan 22, 2021 at 11:29 PM Megha Dey <megha.dey@intel.com> wrote:
>
> Optimize crypto algorithms using AVX512 instructions - VAES and VPCLMULQD=
Q
> (first implemented on Intel's Icelake client and Xeon CPUs).
>
> These algorithms take advantage of the AVX512 registers to keep the CPU
> busy and increase memory bandwidth utilization. They provide substantial
> (2-10x) improvements over existing crypto algorithms when update data siz=
e
> is greater than 128 bytes and do not have any significant impact when use=
d
> on small amounts of data.
>
> However, these algorithms may also incur a frequency penalty and cause
> collateral damage to other workloads running on the same core(co-schedule=
d
> threads). These frequency drops are also known as bin drops where 1 bin
> drop is around 100MHz. With the SpecCPU and ffmpeg benchmark, a 0-1 bin
> drop(0-100MHz) is observed on Icelake desktop and 0-2 bin drops (0-200Mhz=
)
> are observed on the Icelake server.
>
> The AVX512 optimization are disabled by default to avoid impact on other
> workloads. In order to use these optimized algorithms:
> 1. At compile time:
>    a. User must enable CONFIG_CRYPTO_AVX512 option
>    b. Toolchain(assembler) must support VPCLMULQDQ and VAES instructions
> 2. At run time:
>    a. User must set module parameter use_avx512 at boot time
>    b. Platform must support VPCLMULQDQ and VAES features
>
> N.B. It is unclear whether these coarse grain controls(global module
> parameter) would meet all user needs. Perhaps some per-thread control mig=
ht
> be useful? Looking for guidance here.


I've just been looking at some performance issues with in-kernel AVX,
and I have a whole pile of questions that I think should be answered
first:

What is the impact of using an AVX-512 instruction on the logical
thread, its siblings, and other cores on the package?

Does the impact depend on whether it=E2=80=99s a 512-bit insn or a shorter =
EVEX insn?

What is the impact on subsequent shorter EVEX, VEX, and legacy
SSE(2,3, etc) insns?

How does VZEROUPPER figure in?  I can find an enormous amount of
misinformation online, but nothing authoritative.

What is the effect of the AVX-512 states (5-7) being =E2=80=9Cin use=E2=80=
=9D?  As far
as I can tell, the only operations that clear XINUSE[5-7] are XRSTOR
and its variants.  Is this correct?

On AVX-512 capable CPUs, do we ever get a penalty for executing a
non-VEX insn followed by a large-width EVEX insn without an
intervening VZEROUPPER?  The docs suggest no, since Broadwell and
before don=E2=80=99t support EVEX, but I=E2=80=99d like to know for sure.


My current opinion is that we should not enable AVX-512 in-kernel
except on CPUs that we determine have good AVX-512 support.  Based on
some reading, that seems to mean Ice Lake Client and not anything
before it.  I also think a bunch of the above questions should be
answered before we do any of this.  Right now we have a regression of
unknown impact in regular AVX support in-kernel, we will have
performance issues in-kernel depending on what user code has done
recently, and I'm still trying to figure out what to do about it.
Throwing AVX-512 into the mix without real information is not going to
improve the situation.
