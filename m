Return-Path: <SRS0=bmV3=5J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3AEC43331
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 16:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B9A62076E
	for <linux-crypto@archiver.kernel.org>; Tue, 24 Mar 2020 16:41:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="j98GJB7I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbgCXQlh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Mar 2020 12:41:37 -0400
Received: from mail-pj1-f65.google.com ([209.85.216.65]:50912 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727341AbgCXQlh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Mar 2020 12:41:37 -0400
Received: by mail-pj1-f65.google.com with SMTP id v13so1810110pjb.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Mar 2020 09:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=979Mtap+CCQ7tKvldIjbiCeKqDiW28MMMAoe002pSds=;
        b=j98GJB7If0ApdU2aWtGequ2FE/n663QGTdo6OwpAj5gOsC68crPpU1zhyLu1cxDx+3
         Sc6xBVPOE9RSYBXgYJsG+eEEaFK2WV+Nx3CFxx0/x8kiT01nL6yKQoFGPZkoY44YTGfL
         VO21t32jmQN5fZMccfNwR8LQq63XaXlJCWoOF6/T635Yx3ORCPPLWErQ8Y9w2UY6fPfX
         6E84Ukc5ZNtjooyNnH/bboHJKr6wJU9J8D2rLmfQ7wFUQ2aOTMjY5psjHQ/lalul6np6
         ZsUd/FjPbkTuYiur6nMqcACieOJyxtWiH3PjWWDtLBZ9zFw4TN8xvo7mr57297aFteJr
         Dn5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=979Mtap+CCQ7tKvldIjbiCeKqDiW28MMMAoe002pSds=;
        b=eSy5ujWluld1flPMbgGll+T04bKLJIAyUqiCiXKSXXXvfyjaCcPh6vEak6R9PEzeD8
         oDO+jt0wEW9RhGGyKcjE2+E/b7nLMQXIjfry9AigstKyCEacWzEYmSx8GUb/jB2jumHQ
         0OTBM/v/W4bi2AMqRuCYy7mG83mBN2O9coRfsNOfWntHBzP6qlEIqtaKNnfmEFosc8Sh
         G422kVfI08/jTeznQs+N6yk2Tmol5MDL9vjzlBaI2oKdHADsazz4PKLJVipPLZ7leBBV
         gioLVxKtfVgnDuJL+S/XhSJzdzshkSfRqlZUNUqeUh2BqCZZrJ7l498TmzwSQTz/9plf
         XXPQ==
X-Gm-Message-State: ANhLgQ2I/tc31Yjpd4lJeOcJsrrCw5sul2uyvEOIGEpD8pTock/UIgZG
        FtoehMBSLvQC6pPyFtdV6RRFPXRMeKnv5Zw+G6apqQ==
X-Google-Smtp-Source: ADFU+vtqzM/h7+lFa90Wwln9N4BChx0mxDxEdoP4W7HcWwFcKGNGzxlnxh4n480Q5YY7oLXaZIzH0bnX0EyLxWF8PZg=
X-Received: by 2002:a17:90b:230d:: with SMTP id mt13mr6422700pjb.164.1585068096041;
 Tue, 24 Mar 2020 09:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200324084821.29944-1-masahiroy@kernel.org> <20200324084821.29944-5-masahiroy@kernel.org>
In-Reply-To: <20200324084821.29944-5-masahiroy@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 24 Mar 2020 09:41:24 -0700
Message-ID: <CAKwvOd=3tm+OQhuyM9SzC1Mo6QWphLWipd-=VBRYzEmMC6Bg=A@mail.gmail.com>
Subject: Re: [PATCH 04/16] x86: remove unneeded (CONFIG_AS_)CFI_SIGNAL_FRAME
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 24, 2020 at 1:49 AM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Commit 131484c8da97 ("x86/debug: Remove perpetually broken,
> unmaintainable dwarf annotations") removes all the users of
> CFI_SIGNAL_FRAME.
>
> Remove the CFI_SIGNAL_FRAME and CONFIG_AS_CFI_SIGNAL_FRAME.
>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

Please remember to clean up the reference to
CONFIG_AS_CFI_SIGNAL_FRAME in arch/arc/kernel/unwind.c.  It was not
defined by any Makefile scoped to arch/arc, so the the ifndef guards
can go, but the code they guard should stay.
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>
>  arch/x86/Makefile             | 6 ++----
>  arch/x86/include/asm/dwarf2.h | 6 ------
>  2 files changed, 2 insertions(+), 10 deletions(-)
>
> diff --git a/arch/x86/Makefile b/arch/x86/Makefile
> index 72f8f744ebd7..dd275008fc59 100644
> --- a/arch/x86/Makefile
> +++ b/arch/x86/Makefile
> @@ -177,8 +177,6 @@ ifeq ($(ACCUMULATE_OUTGOING_ARGS), 1)
>         KBUILD_CFLAGS += $(call cc-option,-maccumulate-outgoing-args,)
>  endif
>
> -# is .cfi_signal_frame supported too?
> -cfi-sigframe := $(call as-instr,.cfi_startproc\n.cfi_signal_frame\n.cfi_endproc,-DCONFIG_AS_CFI_SIGNAL_FRAME=1)
>  cfi-sections := $(call as-instr,.cfi_sections .debug_frame,-DCONFIG_AS_CFI_SECTIONS=1)
>
>  # does binutils support specific instructions?
> @@ -190,8 +188,8 @@ sha1_ni_instr :=$(call as-instr,sha1msg1 %xmm0$(comma)%xmm1,-DCONFIG_AS_SHA1_NI=
>  sha256_ni_instr :=$(call as-instr,sha256msg1 %xmm0$(comma)%xmm1,-DCONFIG_AS_SHA256_NI=1)
>  adx_instr := $(call as-instr,adox %r10$(comma)%r10,-DCONFIG_AS_ADX=1)
>
> -KBUILD_AFLAGS += $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
> -KBUILD_CFLAGS += $(cfi-sigframe) $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
> +KBUILD_AFLAGS += $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
> +KBUILD_CFLAGS += $(cfi-sections) $(asinstr) $(avx_instr) $(avx2_instr) $(avx512_instr) $(sha1_ni_instr) $(sha256_ni_instr) $(adx_instr)
>
>  KBUILD_LDFLAGS := -m elf_$(UTS_MACHINE)
>
> diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
> index 90807583cad7..f440790f09f9 100644
> --- a/arch/x86/include/asm/dwarf2.h
> +++ b/arch/x86/include/asm/dwarf2.h
> @@ -21,12 +21,6 @@
>  #define CFI_UNDEFINED          .cfi_undefined
>  #define CFI_ESCAPE             .cfi_escape
>
> -#ifdef CONFIG_AS_CFI_SIGNAL_FRAME
> -#define CFI_SIGNAL_FRAME       .cfi_signal_frame
> -#else
> -#define CFI_SIGNAL_FRAME
> -#endif
> -
>  #if defined(CONFIG_AS_CFI_SECTIONS)
>  #ifndef BUILD_VDSO
>         /*
> --
> 2.17.1
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200324084821.29944-5-masahiroy%40kernel.org.



-- 
Thanks,
~Nick Desaulniers
