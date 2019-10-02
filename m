Return-Path: <SRS0=UbUg=X3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AB15C352AA
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 16:47:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3FA4221D81
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Oct 2019 16:47:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iJ5or5kJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfJBQrz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Oct 2019 12:47:55 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37475 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfJBQrz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Oct 2019 12:47:55 -0400
Received: by mail-pf1-f196.google.com with SMTP id y5so10685422pfo.4
        for <linux-crypto@vger.kernel.org>; Wed, 02 Oct 2019 09:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8e2f/B7O/eA1P+agxIjcgRsbBkwhMLqm5Md4WJWFegE=;
        b=iJ5or5kJzrB1SCq2XiBOmrzCAeu+vtDm/AYBk9hrVEcMh2k0SIwGeN/kgGtpsWF+Xw
         U/pc5NYQP+L/nMtkPUlC92GXUNaHUHf9Ynb7+3oQOKxzUtCp1A+Y6jhH5UjcrDC3K9Qw
         pSmVv/+ZDqruNjEdK3KQ4h21T+0sEQDhNSE2Uhb/NNFOc+7AxQqWrWIPLIulyXiKlbV2
         i851tFKRj74upqpHeVxebh78X5Z2ThUHivHzHhvOrBjyV533oZil3ARB6kBy3iPlUyAG
         Nwf2up+7IEjwSJMN7f7tCnubKRmFYfieEF2oYINJHaMipXFE5MS69gvN+F1fnjM+RHHK
         Md2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8e2f/B7O/eA1P+agxIjcgRsbBkwhMLqm5Md4WJWFegE=;
        b=V4dO68t8lWYzbBuPYvr5nXx90OxHEHKCIJbKhngmIjgI+EYLn3l9FYicM8owODIqSm
         7hwPlCQ06X6zAafDpI9WDuFXzzlHrxTi2vAFNCPrRuCTDwRPf1GmCfXXuDcs7QVQnep4
         /5ZODFc70IexDiGmG9jpsPDLf5rVUuIYkFGHMDHsoE15T/cXp1wsszBCxgq2vhQ8XXw4
         e2TNLpWtSP9BI1DJ3quSJgXWP0NysgHKG+SJwE+J7oNWf1PQtUOxUxEgrXiIuUcLkK6E
         kMX7S78r0bJxS7L22r2Tkw8bTfVZNeAOCrbin1xcaMMud1TKDtGK7HYT/aNW3a1KaztK
         i5uw==
X-Gm-Message-State: APjAAAUYCimuzfYdYYh6fMCNk/Pj1lnsAHlmEZUwSFAWbb5op2gQLNl9
        DcKJgmGuIPYKOrQXTNJArHLH3Y9P+9Nyc1iBQFb6ew==
X-Google-Smtp-Source: APXvYqwgl9+x+X7dH+bUehEzb6KtDKnn3rH7pQmlRq4Fq0cBwsVLeefo2nqY3HM+oVWJI1Gj7OTU2RBBSCLSyEkRrLc=
X-Received: by 2002:a63:2f45:: with SMTP id v66mr4771858pgv.263.1570034872733;
 Wed, 02 Oct 2019 09:47:52 -0700 (PDT)
MIME-Version: 1.0
References: <20191002075448.6453-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20191002075448.6453-1-ard.biesheuvel@linaro.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 2 Oct 2019 09:47:41 -0700
Message-ID: <CAKwvOdmr2VX0MObnRScW4suijOLQL24HL3+TPKk8Rkcz0_0ZbA@mail.gmail.com>
Subject: Re: [PATCH] crypto: aegis128/simd - build 32-bit ARM for v8
 architecture explicitly
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 2, 2019 at 12:55 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Now that the Clang compiler has taken it upon itself to police the
> compiler command line, and reject combinations for arguments it views
> as incompatible, the AEGIS128 no longer builds correctly, and errors
> out like this:
>
>   clang-10: warning: ignoring extension 'crypto' because the 'armv7-a'
>   architecture does not support it [-Winvalid-command-line-argument]
>
> So let's switch to armv8-a instead, which matches the crypto-neon-fp-armv8
> FPU profile we specify. Since neither were actually supported by GCC
> versions before 4.8, let's tighten the Kconfig dependencies as well so
> we won't run into errors when building with an ancient compiler.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Thank you Ard, this fixes the build error for us.  Do you know if the
"crypto extensions" are mandatory ISA extensions?  I'm running into
some inconsistencies between how clang parses target arch between
command line flag, function __attribute__, assembler directive, and
disassembler.  I see arch's like: armv8-a+crc, armv8-a+sve,
armv8-a+fp16, armv8-a+memtag, armv8-a+lse, but I'm not familiar with
the `+...` part of the target arch.

Either way, thanks for the patch:
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Reported-by: <ci_notify@linaro.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/730

> ---
>  crypto/Kconfig  | 1 +
>  crypto/Makefile | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index e928f88b6206..b138b68329dc 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -331,6 +331,7 @@ config CRYPTO_AEGIS128
>  config CRYPTO_AEGIS128_SIMD
>         bool "Support SIMD acceleration for AEGIS-128"
>         depends on CRYPTO_AEGIS128 && ((ARM || ARM64) && KERNEL_MODE_NEON)
> +       depends on !ARM || CC_IS_CLANG || GCC_VERSION >= 40800
>         default y
>
>  config CRYPTO_AEGIS128_AESNI_SSE2
> diff --git a/crypto/Makefile b/crypto/Makefile
> index fcb1ee679782..aa740c8492b9 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -93,7 +93,7 @@ obj-$(CONFIG_CRYPTO_AEGIS128) += aegis128.o
>  aegis128-y := aegis128-core.o
>
>  ifeq ($(ARCH),arm)
> -CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv7-a -mfloat-abi=softfp
> +CFLAGS_aegis128-neon-inner.o += -ffreestanding -march=armv8-a -mfloat-abi=softfp
>  CFLAGS_aegis128-neon-inner.o += -mfpu=crypto-neon-fp-armv8
>  aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-neon.o aegis128-neon-inner.o
>  endif
> --
> 2.20.1
>


--
Thanks,
~Nick Desaulniers
