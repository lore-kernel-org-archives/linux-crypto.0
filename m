Return-Path: <SRS0=wYoS=XZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C9FC32792
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 11:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A46D21855
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Sep 2019 11:01:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="qmcRPsFx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730742AbfI3LBk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Sep 2019 07:01:40 -0400
Received: from conssluserg-02.nifty.com ([210.131.2.81]:16960 "EHLO
        conssluserg-02.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729870AbfI3LBk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Sep 2019 07:01:40 -0400
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43]) (authenticated)
        by conssluserg-02.nifty.com with ESMTP id x8UB1U60004180
        for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2019 20:01:31 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com x8UB1U60004180
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1569841293;
        bh=ZUfDYKkNxwOj4CYeJtC9+yuKCYe/CpuyUB+xIK/lF+c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qmcRPsFx7rBAo5jj9ZrppVZ+uoS9IpKJFRTd288o7p5TQNIvM2xQpMCjo7Zii9M5u
         HuEpRmLpO5t1Qaym8R8e50tlBwED/SEDw2BoCxjhAPBjCT8Adi+Q4ZE9miNSL/1DpH
         XjBJfXKxmqHyV9v2SHboT5NBPhpmw6xjlN0mOLwNY2gUW4bye1CPhFyXoVheem9ZKF
         5DWfjrAovYnzNVuM/A+Gow8ZgHFgEayq2Y7D3JMKOrgQyPmUcxgdW3x4UZIfRS2XG+
         XbYp2vaga2ladNqN84reXVYPM5EoBchSQ61qkVXu0HsbWlHXOjAgNJMQs1pbMHZQZW
         plKQHFhHQ4/LA==
X-Nifty-SrcIP: [209.85.217.43]
Received: by mail-vs1-f43.google.com with SMTP id v10so6433557vsc.7
        for <linux-crypto@vger.kernel.org>; Mon, 30 Sep 2019 04:01:31 -0700 (PDT)
X-Gm-Message-State: APjAAAUWjEJeHjPfN0GMQgw9rKgLC2wR59Lw+G9OL9g2exNi6KP5rZq5
        AWSnYIWOUHFIm0ue2HvRITL43/zPbofmqe1qHx4=
X-Google-Smtp-Source: APXvYqwNyrp0FzS70arGcUZoP2iezgES7aiPAzMOGpzj8AToTlvnNN3C8Dekf8sS1zwlCu3RtobjmF+I+r1VHM431a0=
X-Received: by 2002:a67:2d13:: with SMTP id t19mr8130052vst.99.1569841289932;
 Mon, 30 Sep 2019 04:01:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190929173850.26055-1-ard.biesheuvel@linaro.org> <20190929173850.26055-10-ard.biesheuvel@linaro.org>
In-Reply-To: <20190929173850.26055-10-ard.biesheuvel@linaro.org>
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Mon, 30 Sep 2019 20:00:53 +0900
X-Gmail-Original-Message-ID: <CAK7LNARxeskbf2g9YWxD9MvMdfmFjEu2uQXQiC0AansUOmij0A@mail.gmail.com>
Message-ID: <CAK7LNARxeskbf2g9YWxD9MvMdfmFjEu2uQXQiC0AansUOmij0A@mail.gmail.com>
Subject: Re: [RFC PATCH 09/20] int128: move __uint128_t compiler test to Kconfig
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
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

On Mon, Sep 30, 2019 at 2:41 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> In order to use 128-bit integer arithmetic in C code, the architecture
> needs to have declared support for it by setting ARCH_SUPPORTS_INT128,
> and it requires a version of the toolchain that supports this at build
> time. This is why all existing tests for ARCH_SUPPORTS_INT128 also test
> whether __SIZEOF_INT128__ is defined, since this is only the case for
> compilers that can support 128-bit integers.
>
> Let's fold this additional test into the Kconfig declaration of
> ARCH_SUPPORTS_INT128 so that we can also use the symbol in Makefiles,
> e.g., to decide whether a certain object needs to be included in the
> first place.
>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>


Do you still need CONFIG_ARCH_SUPPORTS_INT128 ?

I do not know which part in lib/ubsan.c or crypto/ecc.c
is arch-dependent...





> ---
>  arch/arm64/Kconfig | 2 +-
>  arch/riscv/Kconfig | 2 +-
>  arch/x86/Kconfig   | 2 +-
>  crypto/ecc.c       | 2 +-
>  init/Kconfig       | 4 ++++
>  lib/ubsan.c        | 2 +-
>  lib/ubsan.h        | 2 +-
>  7 files changed, 10 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 3adcec05b1f6..a0f764e2f299 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -69,7 +69,7 @@ config ARM64
>         select ARCH_USE_QUEUED_SPINLOCKS
>         select ARCH_SUPPORTS_MEMORY_FAILURE
>         select ARCH_SUPPORTS_ATOMIC_RMW
> -       select ARCH_SUPPORTS_INT128 if GCC_VERSION >= 50000 || CC_IS_CLANG
> +       select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
>         select ARCH_SUPPORTS_NUMA_BALANCING
>         select ARCH_WANT_COMPAT_IPC_PARSE_VERSION if COMPAT
>         select ARCH_WANT_FRAME_POINTERS
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index 59a4727ecd6c..99be78ac7b33 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -127,7 +127,7 @@ config ARCH_RV32I
>  config ARCH_RV64I
>         bool "RV64I"
>         select 64BIT
> -       select ARCH_SUPPORTS_INT128 if GCC_VERSION >= 50000
> +       select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && GCC_VERSION >= 50000
>         select HAVE_FUNCTION_TRACER
>         select HAVE_FUNCTION_GRAPH_TRACER
>         select HAVE_FTRACE_MCOUNT_RECORD
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 222855cc0158..97f74a2e1cf3 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -24,7 +24,7 @@ config X86_64
>         depends on 64BIT
>         # Options that are inherently 64-bit kernel only:
>         select ARCH_HAS_GIGANTIC_PAGE
> -       select ARCH_SUPPORTS_INT128
> +       select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
>         select ARCH_USE_CMPXCHG_LOCKREF
>         select HAVE_ARCH_SOFT_DIRTY
>         select MODULES_USE_ELF_RELA
> diff --git a/crypto/ecc.c b/crypto/ecc.c
> index dfe114bc0c4a..6e6aab6c987c 100644
> --- a/crypto/ecc.c
> +++ b/crypto/ecc.c
> @@ -336,7 +336,7 @@ static u64 vli_usub(u64 *result, const u64 *left, u64 right,
>  static uint128_t mul_64_64(u64 left, u64 right)
>  {
>         uint128_t result;
> -#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
> +#if defined(CONFIG_ARCH_SUPPORTS_INT128)
>         unsigned __int128 m = (unsigned __int128)left * right;
>
>         result.m_low  = m;
> diff --git a/init/Kconfig b/init/Kconfig
> index bd7d650d4a99..f5566a985b9e 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -780,6 +780,10 @@ config ARCH_SUPPORTS_NUMA_BALANCING
>  config ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
>         bool
>
> +config CC_HAS_INT128
> +       def_bool y
> +       depends on !$(cc-option,-D__SIZEOF_INT128__=0)
> +
>  #
>  # For architectures that know their GCC __int128 support is sound
>  #
> diff --git a/lib/ubsan.c b/lib/ubsan.c
> index e7d31735950d..b652cc14dd60 100644
> --- a/lib/ubsan.c
> +++ b/lib/ubsan.c
> @@ -119,7 +119,7 @@ static void val_to_string(char *str, size_t size, struct type_descriptor *type,
>  {
>         if (type_is_int(type)) {
>                 if (type_bit_width(type) == 128) {
> -#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
> +#if defined(CONFIG_ARCH_SUPPORTS_INT128)
>                         u_max val = get_unsigned_val(type, value);
>
>                         scnprintf(str, size, "0x%08x%08x%08x%08x",
> diff --git a/lib/ubsan.h b/lib/ubsan.h
> index b8fa83864467..7b56c09473a9 100644
> --- a/lib/ubsan.h
> +++ b/lib/ubsan.h
> @@ -78,7 +78,7 @@ struct invalid_value_data {
>         struct type_descriptor *type;
>  };
>
> -#if defined(CONFIG_ARCH_SUPPORTS_INT128) && defined(__SIZEOF_INT128__)
> +#if defined(CONFIG_ARCH_SUPPORTS_INT128)
>  typedef __int128 s_max;
>  typedef unsigned __int128 u_max;
>  #else
> --
> 2.17.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel



-- 
Best Regards
Masahiro Yamada
