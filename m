Return-Path: <SRS0=9iLH=EL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E349BC00A89
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 07:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BE812151B
	for <linux-crypto@archiver.kernel.org>; Thu,  5 Nov 2020 07:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1604562682;
	bh=oxQwtuW0hwiokYEAdCc1FFU1wnaunMZOGRSZJvYbK84=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=EkwVhc9kE2AgCxLu/UHvzJ7rmIwurIQnoaH9mLDTAnkovWlhKUXjZrdVA4AMCx24k
	 iDBzBXx8uj1/hh8Dsw2hJKeBehVSd8YuX/7bqUUJ84RGrT0p80cx2XBmbeE5gaMog4
	 O2XjnA+MD0NO8eKnbCMkAHhj2jEJszhyNlutjdXw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbgKEHvW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Nov 2020 02:51:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:51384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgKEHvV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Nov 2020 02:51:21 -0500
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22B3821556
        for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2020 07:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604562681;
        bh=oxQwtuW0hwiokYEAdCc1FFU1wnaunMZOGRSZJvYbK84=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z715G/ZJJT7qc61nYJWySEPdvkoXhGG17BhN+03gZ77IuM8evpigz4F1mmeGUdP0f
         I32ldaaLrRPCqOCTLV6ribRsVjkc5N1ZOs2J41gE4fxVtR3cO39BAMoMx83diZ9gPI
         V71//HKSmEYWYGtZn3qet1GrcrFdVDD2Iizdys40=
Received: by mail-ot1-f41.google.com with SMTP id 32so616184otm.3
        for <linux-crypto@vger.kernel.org>; Wed, 04 Nov 2020 23:51:21 -0800 (PST)
X-Gm-Message-State: AOAM5304eHbOJ8PCvGJehecX5yFa/S8aFdgtx1RBFDd/llfnVgumHtDs
        UjwenKsAvgEbGcg+I/c8XqpGri8L8YQzJn75pnI=
X-Google-Smtp-Source: ABdhPJxgCFEIL2XHfTZqQD1BqlYhZO35F/h2gqv286fgM1lIjCyxyPxLjVFKcC2ZDEpBQ32AWbRuHJEQVAX24h0XawE=
X-Received: by 2002:a05:6830:4028:: with SMTP id i8mr829221ots.90.1604562680278;
 Wed, 04 Nov 2020 23:51:20 -0800 (PST)
MIME-Version: 1.0
References: <20201103121506.1533-1-liqiang64@huawei.com> <20201103121506.1533-2-liqiang64@huawei.com>
 <20201104175742.GA846@sol.localdomain> <2dad168c-f6cb-103c-04ce-cc3c2561e01b@huawei.com>
In-Reply-To: <2dad168c-f6cb-103c-04ce-cc3c2561e01b@huawei.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 5 Nov 2020 08:51:08 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG+YJvHLFDMk7ABAD=WthxLx5Uh0LAXCP6+2tXEySj7eg@mail.gmail.com>
Message-ID: <CAMj1kXG+YJvHLFDMk7ABAD=WthxLx5Uh0LAXCP6+2tXEySj7eg@mail.gmail.com>
Subject: Re: [PATCH 1/1] arm64: Accelerate Adler32 using arm64 SVE instructions.
To:     Li Qiang <liqiang64@huawei.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 5 Nov 2020 at 03:50, Li Qiang <liqiang64@huawei.com> wrote:
>
> Hi Eric,
>
> =E5=9C=A8 2020/11/5 1:57, Eric Biggers =E5=86=99=E9=81=93:
> > On Tue, Nov 03, 2020 at 08:15:06PM +0800, l00374334 wrote:
> >> From: liqiang <liqiang64@huawei.com>
> >>
> >>      In the libz library, the checksum algorithm adler32 usually occup=
ies
> >>      a relatively high hot spot, and the SVE instruction set can easil=
y
> >>      accelerate it, so that the performance of libz library will be
> >>      significantly improved.
> >>
> >>      We can divides buf into blocks according to the bit width of SVE,
> >>      and then uses vector registers to perform operations in units of =
blocks
> >>      to achieve the purpose of acceleration.
> >>
> >>      On machines that support ARM64 sve instructions, this algorithm i=
s
> >>      about 3~4 times faster than the algorithm implemented in C langua=
ge
> >>      in libz. The wider the SVE instruction, the better the accelerati=
on effect.
> >>
> >>      Measured on a Taishan 1951 machine that supports 256bit width SVE=
,
> >>      below are the results of my measured random data of 1M and 10M:
> >>
> >>              [root@xxx adler32]# ./benchmark 1000000
> >>              Libz alg: Time used:    608 us, 1644.7 Mb/s.
> >>              SVE  alg: Time used:    166 us, 6024.1 Mb/s.
> >>
> >>              [root@xxx adler32]# ./benchmark 10000000
> >>              Libz alg: Time used:   6484 us, 1542.3 Mb/s.
> >>              SVE  alg: Time used:   2034 us, 4916.4 Mb/s.
> >>
> >>      The blocks can be of any size, so the algorithm can automatically=
 adapt
> >>      to SVE hardware with different bit widths without modifying the c=
ode.
> >>
> >>
> >> Signed-off-by: liqiang <liqiang64@huawei.com>
> >
> > Note that this patch does nothing to actually wire up the kernel's copy=
 of libz
> > (lib/zlib_{deflate,inflate}/) to use this implementation of Adler32.  T=
o do so,
> > libz would either need to be changed to use the shash API, or you'd nee=
d to
> > implement an adler32() function in lib/crypto/ that automatically uses =
an
> > accelerated implementation if available, and make libz call it.
> >
> > Also, in either case a C implementation would be required too.  There c=
an't be
> > just an architecture-specific implementation.
>
> Okay, thank you for the problems and suggestions you gave. I will continu=
e to
> improve my code.
>
> >
> > Also as others have pointed out, there's probably not much point in hav=
ing a SVE
> > implementation of Adler32 when there isn't even a NEON implementation y=
et.  It's
> > not too hard to implement Adler32 using NEON, and there are already sev=
eral
> > permissively-licensed NEON implementations out there that could be used=
 as a
> > reference, e.g. my implementation using NEON instrinsics here:
> > https://github.com/ebiggers/libdeflate/blob/v1.6/lib/arm/adler32_impl.h
> >
> > - Eric
> > .
> >
>
> I am very happy to get this NEON implementation code. :)
>

Note that NEON intrinsics can be compiled for 32-bit ARM as well (with
a bit of care - please refer to lib/raid6/recov_neon_inner.c for an
example of how to deal with intrinsics that are only available on
arm64) and are less error prone, so intrinsics should be preferred if
feasible.

However, you have still not explained how optimizing Adler32 makes a
difference for a real-world use case. Where is libdeflate used on a
hot path?
