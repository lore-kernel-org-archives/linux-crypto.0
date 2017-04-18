From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH v2] crypto: arm64/sha: Add constant operand modifier to ASM_EXPORT
Date: Tue, 18 Apr 2017 10:47:36 -0400
Message-ID: <CAP=VYLpejcYwXUMtCCkXmjXw=T1tBJLn21aVi-9v_VGmEinjRg@mail.gmail.com>
References: <20170405183458.193068-1-mka@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Greg Hackmann <ghackmann@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>
To: Matthias Kaehlcke <mka@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:36038 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752204AbdDROsH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Apr 2017 10:48:07 -0400
In-Reply-To: <20170405183458.193068-1-mka@chromium.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 5, 2017 at 2:34 PM, Matthias Kaehlcke <mka@chromium.org> wrote:
> The operand is an integer constant, make the constness explicit by
> adding the modifier. This is needed for clang to generate valid code
> and also works with gcc.

Actually it doesn't work with all gcc.  I've got an older arm64 toolchain that I
only use for syntax checking (and hence I don't care if it is the latest and
greatest) and this commit breaks it:

arch/arm64/crypto/sha1-ce-glue.c:21:2: error: invalid 'asm': invalid
operand prefix '%c'
  asm(".globl " #sym "; .set " #sym ", %c0" :: "i"(val));

I'm currently reverting this change locally so I can continue to use the old
toolchain:

$ aarch64-linux-gnu-gcc --version
aarch64-linux-gnu-gcc (crosstool-NG linaro-1.13.1-4.8-2013.12 - Linaro
GCC 2013.11) 4.8.3 20131202 (prerelease)
Copyright (C) 2013 Free Software Foundation, Inc.

$ aarch64-linux-gnu-as --version
GNU assembler (crosstool-NG linaro-1.13.1-4.8-2013.12 - Linaro GCC
2013.11) 2.24.0.20131220
Copyright 2013 Free Software Foundation, Inc.

Maybe it is finally too old and nobody cares, but I thought it worth a mention.

Paul.
--

>
> Also change the constraint of the operand from 'I' ("Integer constant
> that is valid as an immediate operand in an ADD instruction", AArch64)
> to 'i' ("An immediate integer operand").
>
> Based-on-patch-from: Greg Hackmann <ghackmann@google.com>
> Signed-off-by: Greg Hackmann <ghackmann@google.com>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> Changes in v2:
> - Changed operand constraint from I to i
> - Updated commit message
> - Changed 'From' tag to 'Based-on-patch-from'
>
>  arch/arm64/crypto/sha1-ce-glue.c | 2 +-
>  arch/arm64/crypto/sha2-ce-glue.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
> index aefda9868627..6b520e3f3ab1 100644
> --- a/arch/arm64/crypto/sha1-ce-glue.c
> +++ b/arch/arm64/crypto/sha1-ce-glue.c
> @@ -18,7 +18,7 @@
>  #include <linux/module.h>
>
>  #define ASM_EXPORT(sym, val) \
> -       asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
> +       asm(".globl " #sym "; .set " #sym ", %c0" :: "i"(val));
>
>  MODULE_DESCRIPTION("SHA1 secure hash using ARMv8 Crypto Extensions");
>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
> diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
> index 7cd587564a41..e3abe11de48c 100644
> --- a/arch/arm64/crypto/sha2-ce-glue.c
> +++ b/arch/arm64/crypto/sha2-ce-glue.c
> @@ -18,7 +18,7 @@
>  #include <linux/module.h>
>
>  #define ASM_EXPORT(sym, val) \
> -       asm(".globl " #sym "; .set " #sym ", %0" :: "I"(val));
> +       asm(".globl " #sym "; .set " #sym ", %c0" :: "i"(val));
>
>  MODULE_DESCRIPTION("SHA-224/SHA-256 secure hash using ARMv8 Crypto Extensions");
>  MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
> --
> 2.12.2.715.g7642488e1d-goog
>
