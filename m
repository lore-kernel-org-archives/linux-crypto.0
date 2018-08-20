From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] arm64/crypto: remove non-standard notation
Date: Mon, 20 Aug 2018 15:43:32 -0700
Message-ID: <CAKwvOdm9ZabUHY0w0mT52nZQNZqfhk1EyQHXo27uO816TyU0eg@mail.gmail.com>
References: <20180820224032.53194-1-ndesaulniers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-crypto@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180820224032.53194-1-ndesaulniers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Aug 20, 2018 at 3:41 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> It seems that:
> ldr q8, =0x30000000200000001
>
> is a GNU as convience notation for:
> ldr q8, .Lconstant
> .Lconstant
> .word 0x00000001
> .word 0x00000002
> .word 0x00000003
> .word 0x00000000
>
> based on this comment in binutils' source [0]. I've asked for this
> non-standard convience notation to be added to other assemblers [1], but
> until then, we can remove it and get equivalent disassembly:
>
> before:
> 00000000000009d4 <neon_aes_ctr_encrypt>:
> ...
>      a48:       9c000ac8        ldr     q8, ba0 <neon_aes_ctr_encrypt+0x1cc>
> ...
>      ba0:       00000001        .word   0x00000001
>      ba4:       00000002        .word   0x00000002
>      ba8:       00000003        .word   0x00000003
>      bac:       00000000        .word   0x00000000
>
> after:
>
> 00000000000009d4 <neon_aes_ctr_encrypt>:
> ...
>      a48:       9c000aa8        ldr     q8, b9c <neon_aes_ctr_encrypt+0x1c8>
> ...
>      b9c:       00000001        .word   0x00000001
>      ba0:       00000002        .word   0x00000002
>      ba4:       00000003        .word   0x00000003
>      ba8:       00000000        .word   0x00000000
>
> [0] https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=blob;f=gas/testsuite/gas/aarch64/programmer-friendly.s;h=6254c6476efdc848648b05068be0574e7addc85d;hb=HEAD#l11
> [1] https://bugs.llvm.org/show_bug.cgi?id=38642
>
> Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> ---
>  arch/arm64/crypto/aes-modes.S | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
> index 483a7130cf0e..9288c5b0eca2 100644
> --- a/arch/arm64/crypto/aes-modes.S
> +++ b/arch/arm64/crypto/aes-modes.S
> @@ -232,7 +232,7 @@ AES_ENTRY(aes_ctr_encrypt)
>         bmi             .Lctr1x
>         cmn             w6, #4                  /* 32 bit overflow? */
>         bcs             .Lctr1x
> -       ldr             q8, =0x30000000200000001        /* addends 1,2,3[,0] */
> +       ldr             q8, .Laddends /* addends 1,2,3[,0] */
>         dup             v7.4s, w6
>         mov             v0.16b, v4.16b
>         add             v7.4s, v7.4s, v8.4s
> @@ -295,6 +295,12 @@ AES_ENTRY(aes_ctr_encrypt)
>         rev             x7, x7
>         ins             v4.d[0], x7
>         b               .Lctrcarrydone
> +
> +.Laddends:
> +       .word   0x00000001
> +       .word   0x00000002
> +       .word   0x00000003
> +       .word   0x00000000
>  AES_ENDPROC(aes_ctr_encrypt)
>         .ltorg
>
> --
> 2.18.0.865.gffc8e1a3cd6-goog
>

I can't spell. s/convience/convenience/g

-- 
Thanks,
~Nick Desaulniers
