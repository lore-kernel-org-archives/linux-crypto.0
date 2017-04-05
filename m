From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH v2] crypto: arm64/sha: Add constant operand modifier to ASM_EXPORT
Date: Wed, 5 Apr 2017 20:21:59 +0100
Message-ID: <CAKv+Gu8aXQb2LueqQg7L2794bujH-OyEJ+EsQitr3oybTJMUmA@mail.gmail.com>
References: <20170405183458.193068-1-mka@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Greg Hackmann <ghackmann@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Grant Grundler <grundler@chromium.org>,
        Michael Davidson <md@google.com>
To: Matthias Kaehlcke <mka@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:35231 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755396AbdDETWA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Apr 2017 15:22:00 -0400
Received: by mail-io0-f169.google.com with SMTP id z13so16479631iof.2
        for <linux-crypto@vger.kernel.org>; Wed, 05 Apr 2017 12:22:00 -0700 (PDT)
In-Reply-To: <20170405183458.193068-1-mka@chromium.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 5 April 2017 at 19:34, Matthias Kaehlcke <mka@chromium.org> wrote:
> The operand is an integer constant, make the constness explicit by
> adding the modifier. This is needed for clang to generate valid code
> and also works with gcc.
>
> Also change the constraint of the operand from 'I' ("Integer constant
> that is valid as an immediate operand in an ADD instruction", AArch64)
> to 'i' ("An immediate integer operand").
>
> Based-on-patch-from: Greg Hackmann <ghackmann@google.com>
> Signed-off-by: Greg Hackmann <ghackmann@google.com>
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Herbert, could you please pick this up?

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
