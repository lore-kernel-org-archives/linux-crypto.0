Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50A15C433E9
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:20:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B89220791
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:20:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725964AbhAPRUS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:20:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:33406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbhAPRUG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jan 2021 12:20:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD2A523359;
        Sat, 16 Jan 2021 16:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610815937;
        bh=ZDSLu0JCfcOYuE9aL0IgQNet6XaP5vThHRTmm/vzuMc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rf6HIma/8HBkx/yapd0BlF0jmFJUj48+iYJlgrVuPgqOKC2ngssWuHUaoXHa3DJRI
         EaIcxw6SV7vbbNuRD88NmNLOXvmCTOVN8lsCgGXktVwj0Z2DXzcHIG28MjOFGs5ZwJ
         VL7BtgWdvqd0cCWYfMK1YO8R3nSixd9d6enVBsmlrABaLrMS1+SVAwipVRRdBeyZr1
         6RSnQkt0l8MMedGRu1VhZfrPqwq/itJ2fAHGggBuFshu3VUvGIhP4YYj3HJZeQdHSP
         63d2D4liVug3cRy3fUgResEba3FRhn4rNByj19lYY8JQ02kkp+rQjY5Zbp3FZqbeH2
         QUnE8FxSvlwzQ==
Received: by mail-ot1-f46.google.com with SMTP id o11so11876075ote.4;
        Sat, 16 Jan 2021 08:52:16 -0800 (PST)
X-Gm-Message-State: AOAM532nM9RrDPryCaRZjEJcl496BmGVwF488cpbYyD1RznF4TZfawBm
        56hhYxCYmEpgSMuALSCyJzR052giw4c4H2duPj8=
X-Google-Smtp-Source: ABdhPJzuUkG0CBnkY2jqz0+uDfkZr5i+JwP1UcUhW8LmXNEg8/XWke3dPKKlQWWfUJbeqTL26EvqjA2PzdQRpIKKMg0=
X-Received: by 2002:a05:6830:10d2:: with SMTP id z18mr12528352oto.90.1610815936257;
 Sat, 16 Jan 2021 08:52:16 -0800 (PST)
MIME-Version: 1.0
References: <1608325864-4033-1-git-send-email-megha.dey@intel.com>
 <X+Et0ubPcBVZOURL@sol.localdomain> <caa90522-14ac-c674-b6f5-22a7d8359a3c@intel.com>
In-Reply-To: <caa90522-14ac-c674-b6f5-22a7d8359a3c@intel.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 16 Jan 2021 17:52:05 +0100
X-Gmail-Original-Message-ID: <CAMj1kXGFsQMpWCYCB8Vqeq2Kj+WBiXkVv=dom13PJhbR3EZKFQ@mail.gmail.com>
Message-ID: <CAMj1kXGFsQMpWCYCB8Vqeq2Kj+WBiXkVv=dom13PJhbR3EZKFQ@mail.gmail.com>
Subject: Re: [RFC V1 0/7] Introduce AVX512 optimized crypto algorithms
To:     "Dey, Megha" <megha.dey@intel.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ravi.v.shankar@intel.com, tim.c.chen@intel.com,
        andi.kleen@intel.com, Dave Hansen <dave.hansen@intel.com>,
        wajdi.k.feghali@intel.com, greg.b.tucker@intel.com,
        robert.a.kasten@intel.com, rajendrakumar.chinnaiyan@intel.com,
        tomasz.kantecki@intel.com, ryan.d.saffores@intel.com,
        ilya.albrekht@intel.com, kyung.min.park@intel.com,
        Tony Luck <tony.luck@intel.com>, ira.weiny@intel.com,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 28 Dec 2020 at 20:11, Dey, Megha <megha.dey@intel.com> wrote:
>
> Hi Eric,
>
> On 12/21/2020 3:20 PM, Eric Biggers wrote:
> > On Fri, Dec 18, 2020 at 01:10:57PM -0800, Megha Dey wrote:
> >> Optimize crypto algorithms using VPCLMULQDQ and VAES AVX512 instructions
> >> (first implemented on Intel's Icelake client and Xeon CPUs).
> >>
> >> These algorithms take advantage of the AVX512 registers to keep the CPU
> >> busy and increase memory bandwidth utilization. They provide substantial
> >> (2-10x) improvements over existing crypto algorithms when update data size
> >> is greater than 128 bytes and do not have any significant impact when used
> >> on small amounts of data.
> >>
> >> However, these algorithms may also incur a frequency penalty and cause
> >> collateral damage to other workloads running on the same core(co-scheduled
> >> threads). These frequency drops are also known as bin drops where 1 bin
> >> drop is around 100MHz. With the SpecCPU and ffmpeg benchmark, a 0-1 bin
> >> drop(0-100MHz) is observed on Icelake desktop and 0-2 bin drops (0-200Mhz)
> >> are observed on the Icelake server.
> >>
> > Do these new algorithms all pass the self-tests, including the fuzz tests that
> > are enabled when CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?
>
> I had tested these algorithms with CRYPTO_MANAGER_DISABLE_TESTS=n and
> tcrypt, not with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y (I wasn't aware this existed, my bad).
> I see a couple of errors after enabling it and am working on fixing those.
>

Hello Megha,

I think the GHASH changes can be dropped (as discussed in the other
thread), given the lack of a use case. The existing GHASH driver could
also be removed in the future, but I don't think it needs to be part
of this series.

Could you please rebase this onto the latest AES-NI changes that are
in Herbert's tree? (as well as the ones I sent out today) They address
some issues with indirect calls and excessive disabling of preemption,
and your GCM and CTR changes are definitely going to be affected by
this as well.
