Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4766BC32792
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 11:49:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B082216F4
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 11:49:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zYgPw0ZI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbfI3Ltm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 07:49:42 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34986 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbfI3Ltm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 07:49:42 -0400
Received: by mail-wm1-f68.google.com with SMTP id y21so12388098wmi.0
        for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2019 04:49:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A+7eTaynhvCbkjtKRzkBY0V/xhABFiAjacJiNwLb2X4=;
        b=zYgPw0ZIEQD+22W0wKzRM4F4v1JVLdqINHOR0XUILzGxKAdtc12r0TCDW0B8XDxph9
         81oJ2EqUkuJusLm2GrpLjGTlQCrKpzROiV/p1amFfOohA7nZxGC0Y2p6tkkVREa0b9pS
         tS2GSdQugj0QgdiLPu0s+PBnHV6CAg0kX8GfjW63nik3sW0isBaWNpGtAVu6LX/vQxW8
         X+dYcZCqq/25ZKrW9afeU6kRKZWnspUJgUEQvsqWI+1ISPFbYK+MURKXs6eIMb+YnlY2
         j65uHgK+M2FxrHYbYj58iwSZ+JLNpIFkDpX31jtcFRWP/L4EAqZaReFytMb8R6R3KXPb
         31FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A+7eTaynhvCbkjtKRzkBY0V/xhABFiAjacJiNwLb2X4=;
        b=cLNS1JznrpuoovfuDtbQz3/zG87gHPmZml3iSXUEaPjy5b1WFARzL3CRh2xTpiwDAP
         JbOsKfTrTs65FMcJ4S0mr7KKImLcd/V3OVygOFxKZRIOEMw5wrVV3rJ5Jbi/kafZeuEB
         Q3rBrlGuXrK7MPLLgU0HN+jt0ePtGIPdhBmDVGv6UmA8H09f25wCH9uz4q1/zPFJs4e2
         omf1WLGmZN1TPR8auyiJ7xMF3UMaN4cLVH2/o0+baGGMFjX/MwCuSbUENLSHxtnzf0Yh
         RHiYNjgTswKqw7Bra7kDmLdVhDKdGzPg8jo5CLO84vwaqPPZlu3DjJel/mD4g+iVs4s8
         HWnQ==
X-Gm-Message-State: APjAAAUAoixgoGSVeZqegtavykucu4drZdxzub32ZmLtDHBMEjT+44km
        QLLyZh7aM5idRlJZeGU4mk++9iyfdzvQ6iFX0GMVUw==
X-Google-Smtp-Source: APXvYqxtLMoOOipak3VdQ3oHGiqJLNT3ITe4aYlbV/3Nc5/ZXFDEHLR997hTeB8gu9mOaSS3O7lxuAkEed4NiGPjVhw=
X-Received: by 2002:a7b:cb55:: with SMTP id v21mr17046132wmj.53.1569844179797;
 Mon, 30 Sep 2019 04:49:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190929173850.26055-1-ard.biesheuvel@linaro.org>
 <20190929173850.26055-10-ard.biesheuvel@linaro.org> <CAK7LNARxeskbf2g9YWxD9MvMdfmFjEu2uQXQiC0AansUOmij0A@mail.gmail.com>
In-Reply-To: <CAK7LNARxeskbf2g9YWxD9MvMdfmFjEu2uQXQiC0AansUOmij0A@mail.gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 30 Sep 2019 13:49:28 +0200
Message-ID: <CAKv+Gu-DDMyXnE8xe465tYSxyWdiS4MKzhF0izSczvKKz+989g@mail.gmail.com>
Subject: Re: [RFC PATCH 09/20] int128: move __uint128_t compiler test to Kconfig
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Martin Willi <martin@strongswan.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Eric Biggers <ebiggers@google.com>,
        Samuel Neves <sneves@dei.uc.pt>, Will Deacon <will@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lutomirski <luto@kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 30 Sep 2019 at 13:01, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Mon, Sep 30, 2019 at 2:41 AM Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
> >
> > In order to use 128-bit integer arithmetic in C code, the architecture
> > needs to have declared support for it by setting ARCH_SUPPORTS_INT128,
> > and it requires a version of the toolchain that supports this at build
> > time. This is why all existing tests for ARCH_SUPPORTS_INT128 also test
> > whether __SIZEOF_INT128__ is defined, since this is only the case for
> > compilers that can support 128-bit integers.
> >
> > Let's fold this additional test into the Kconfig declaration of
> > ARCH_SUPPORTS_INT128 so that we can also use the symbol in Makefiles,
> > e.g., to decide whether a certain object needs to be included in the
> > first place.
> >
> > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
>
> Do you still need CONFIG_ARCH_SUPPORTS_INT128 ?
>

arm64 needs GCC 5 or later for int128_t support, since older versions
emit support library function calls that we don't implement.

I guess we could fold that into the CC_HAS_INT128 test as well though

> I do not know which part in lib/ubsan.c or crypto/ecc.c
> is arch-dependent...
>
>
>
>
>
> > ---
> >  arch/arm64/Kconfig | 2 +-
> >  arch/riscv/Kconfig | 2 +-
> >  arch/x86/Kconfig   | 2 +-
> >  crypto/ecc.c       | 2 +-
> >  init/Kconfig       | 4 ++++
> >  lib/ubsan.c        | 2 +-
> >  lib/ubsan.h        | 2 +-
> >  7 files changed, 10 insertions(+), 6 deletions(-)
> >
> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 3adcec05b1f6..a0f764e2f299 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -69,7 +69,7 @@ config ARM64
> >         select ARCH_USE_QUEUED_SPINLOCKS
> >         select ARCH_SUPPORTS_MEMORY_FAILURE
> >         select ARCH_SUPPORTS_ATOMIC_RMW
> > -       select ARCH_SUPPORTS_INT128 if GCC_VERSION >= 50000 || CC_IS_CLANG
> > +       select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
> >         select ARCH_SUPPORTS_NUMA_BALANCING
> >         select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
> >         select ARCH_WANT_FRAME_POINTERS
> > diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> > index 59a4727ecd6c..99be78ac7b33 100644
> > --- a/arch/riscv/Kconfig
> > +++ b/arch/riscv/Kconfig
> > @@ -127,7 +127,7 @@ config ARCH_RV32I
> >  config ARCH_RV64I
> >         bool "RV64I"
> >         select 64BIT
> > -       select ARCH_SUPPORTS_INT128 if GCC_VERSION >= 50000
> > +       select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && GCC_VERSION >= 50000
> >         select HAVE_FUNCTION_TRACER
> >         select HAVE_FUNCTION_GRAPH_TRACER
> >         select HAVE_FTRACE_MCOUNT_RECORD
> > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > index 222855cc0158..97f74a2e1cf3 100644
> > --- a/arch/x86/Kconfig
> > +++ b/arch/x86/Kconfig
> > @@ -24,7 +24,7 @@ config X86_64
> >         depends on 64BIT
> >         # Options that are inherently 64-bit kernel only:
> >         select ARCH_HAS_GIGANTIC_PAGE
> > -       select ARCH_SUPPORTS_INT128
> > +       select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
> >         select ARCH_USE_CMPXCHG_LOCKREF
> >         select HAVE_ARCH_SOFT_DIRTY
> >         select MODULES_USE_ELF_RELA
> > diff --git a/crypto/ecc.c b/crypto/ecc.c
> > index dfe114bc0c4a..6e6aab6c987c 100644
> > --- a/crypto/ecc.c
> > +++ b/crypto/ecc.c
> > @@ -336,7 +336,7 @@ static u64 vli_usub(u64 *result, const u64 *left, u64 right,
> >  static uint128_t mul_64_64(u64 left, u64 right)
> >  {
> >         uint128_t result;
> > -#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
> > +#if defined(CONFIG_ARCH_SUPPORTS_INT128)
> >         unsigned __int128 m = (unsigned __int128)left * right;
> >
> >         result.m_low  = m;
> > diff --git a/init/Kconfig b/init/Kconfig
> > index bd7d650d4a99..f5566a985b9e 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -780,6 +780,10 @@ config ARCH_SUPPORTS_NUMA_BALANCING
> >  config ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
> >         bool
> >
> > +config CC_HAS_INT128
> > +       def_bool y
> > +       depends on !$(cc-option,-D__SIZEOF_INT128__=0)
> > +
> >  #
> >  # For architectures that know their GCC __int128 support is sound
> >  #
> > diff --git a/lib/ubsan.c b/lib/ubsan.c
> > index e7d31735950d..b652cc14dd60 100644
> > --- a/lib/ubsan.c
> > +++ b/lib/ubsan.c
> > @@ -119,7 +119,7 @@ static void val_to_string(char *str, size_t size, struct type_descriptor *type,
> >  {
> >         if (type_is_int(type)) {
> >                 if (type_bit_width(type) == 128) {
> > -#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
> > +#if defined(CONFIG_ARCH_SUPPORTS_INT128)
> >                         u_max val = get_unsigned_val(type, value);
> >
> >                         scnprintf(str, size, "0x%08x%08x%08x%08x",
> > diff --git a/lib/ubsan.h b/lib/ubsan.h
> > index b8fa83864467..7b56c09473a9 100644
> > --- a/lib/ubsan.h
> > +++ b/lib/ubsan.h
> > @@ -78,7 +78,7 @@ struct invalid_value_data {
> >         struct type_descriptor *type;
> >  };
> >
> > -#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
> > +#if defined(CONFIG_ARCH_SUPPORTS_INT128)
> >  typedef __int128 s_max;
> >  typedef unsigned __int128 u_max;
> >  #else
> > --
> > 2.17.1
> >
> >
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
>
>
> --
> Best Regards
> Masahiro Yamada
