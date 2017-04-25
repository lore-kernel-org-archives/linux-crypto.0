From: Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [PATCH v2] crypto: arm64/sha: Add constant operand modifier to
 ASM_EXPORT
Date: Tue, 25 Apr 2017 10:39:37 -0700
Message-ID: <20170425173937.GN128305@google.com>
References: <20170405183458.193068-1-mka@chromium.org>
 <CAP=VYLpejcYwXUMtCCkXmjXw=T1tBJLn21aVi-9v_VGmEinjRg@mail.gmail.com>
 <CAKv+Gu_DHBT=2YA9h+ao3pZXgEV5KsO9ia+J90wtLuDX=a4+eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Hackmann <ghackmann@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f51.google.com ([74.125.83.51]:35039 "EHLO
        mail-pg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1431890AbdDYRjj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Apr 2017 13:39:39 -0400
Received: by mail-pg0-f51.google.com with SMTP id 72so31607000pge.2
        for <linux-crypto@vger.kernel.org>; Tue, 25 Apr 2017 10:39:39 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_DHBT=2YA9h+ao3pZXgEV5KsO9ia+J90wtLuDX=a4+eg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

El Tue, Apr 18, 2017 at 04:35:02PM +0100 Ard Biesheuvel ha dit:

> On 18 April 2017 at 15:47, Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> > On Wed, Apr 5, 2017 at 2:34 PM, Matthias Kaehlcke <mka@chromium.org> wrote:
> >> The operand is an integer constant, make the constness explicit by
> >> adding the modifier. This is needed for clang to generate valid code
> >> and also works with gcc.
> >
> > Actually it doesn't work with all gcc.  I've got an older arm64 toolchain that I
> > only use for syntax checking (and hence I don't care if it is the latest and
> > greatest) and this commit breaks it:
> >
> > arch/arm64/crypto/sha1-ce-glue.c:21:2: error: invalid 'asm': invalid
> > operand prefix '%c'
> >   asm(".globl " #sym "; .set " #sym ", %c0" :: "i"(val));
> >
> > I'm currently reverting this change locally so I can continue to use the old
> > toolchain:
> >
> > $ aarch64-linux-gnu-gcc --version
> > aarch64-linux-gnu-gcc (crosstool-NG linaro-1.13.1-4.8-2013.12 - Linaro
> > GCC 2013.11) 4.8.3 20131202 (prerelease)
> > Copyright (C) 2013 Free Software Foundation, Inc.
> >
> > $ aarch64-linux-gnu-as --version
> > GNU assembler (crosstool-NG linaro-1.13.1-4.8-2013.12 - Linaro GCC
> > 2013.11) 2.24.0.20131220
> > Copyright 2013 Free Software Foundation, Inc.
> >
> > Maybe it is finally too old and nobody cares, but I thought it worth a mention.
> >
> 
> Thanks for the report. I think we care more about GCC 4.8 than about
> Clang, which argues for reverting this patch.
> 
> I understand these issues must be frustrating if you are working on
> this stuff, but to me, it is not entirely obvious why we want to
> support Clang in the first place (i.e., what does it buy you if your
> distro/environment is not already using Clang for userland), and why
> the burden is on Linux to make modifications to support Clang,
> especially when it comes to GCC extensions such as inline assembly
> syntax.
> 
> It is ultimately up to the maintainers to decide what to do with this
> patch, but my vote would be to revert it, especially given that the %c
> placeholder prefix is not documented anywhere, and appears to simply
> trigger some GCC internals that happen to do the right thing in this
> case.
> 
> However, the I -> i change is arguably an improvement, and considering
> that the following
> 
> asm("foo: .long %0" :: "i"(some value))
> 
> doesn't compile with clang either, I suggest you (Matthias) file a bug
> against Clang to get this fixed, and we can propose another patch just
> for the I->i change.

I consulted with folks with more expertise in this area than myself.
This is their analysis of the situation:

"The ARM ARM specifies that the correct AArch64 instruction assembly
syntax is to have a hash sign (#) before an immediate.

Therefore, every time an inline assembly constraint is used that
specifies to print an immediate (like 'i' or 'I'), the immediate
(e.g. 42) should be printed with the hash (e.g. #42).

Therefore, if you're using an immediate constraint where the hash sign
must not be printed, you have to use the "c" operand modifier. The "c"
operand modifier apparently got introduced to gcc after the 4.8
release.

The binutils assembler and the clang integrated assembler accept
immediates without the hash sign as a non-official extension. Some of
the immediate constraints on gcc seem to not print out the hash sign
either; which is why the variant in the linux kernel works with gcc.

In summary, it seems to me that the inline assembly with the %c0
operand is the correct one and gcc 4.8 is simply too old to support
this."

If the above is correct it seems that the solution is not to "fix"
clang, but to use different instructions for gcc<=4.8 and newer
compilers. I am aware that this is not a popular option.

What do you think?

Thanks

Matthias
