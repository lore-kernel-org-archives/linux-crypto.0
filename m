From: =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?=
        <omosnacek+linux-crypto@gmail.com>
Subject: Re: [PATCH] x86/crypto: Add missing RETs
Date: Sat, 23 Jun 2018 19:30:30 +0200
Message-ID: <CAAUqJDvKG6T3y=Cf8B7cThmkgvjZxWYbDqVV=EA4GS5TfjBCeQ@mail.gmail.com>
References: <20180507213755.GA32406@avx2> <tip-51bad67ffbce0aaa44579f84ef5d05597054ec6a@git.kernel.org>
 <1529235613.4572.7.camel@gmx.de> <20180617120012.GB16877@zn.tnic>
 <1529242717.4472.3.camel@gmx.de> <1529244178.4674.1.camel@gmx.de>
 <20180617194747.GA21160@zn.tnic> <1529289279.31745.3.camel@gmx.de> <20180623103622.GA2760@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-crypto@vger.kernel.org, efault@gmx.de, adobriyan@gmail.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        mingo@kernel.org, jpoimboe@redhat.com, luto@kernel.org,
        peterz@infradead.org, brgerst@gmail.com, hpa@zytor.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dvlasenk@redhat.com, h.peter.anvin@intel.com,
        linux-tip-commits@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: bp@alien8.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180623103622.GA2760@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

so 23. 6. 2018 o 12:36 Borislav Petkov <bp@alien8.de> nap=C3=ADsal(a):
>
> Lemme send a proper patch now...
>
> ---
> From: Borislav Petkov <bp@suse.de>
> Date: Sun, 17 Jun 2018 13:57:42 +0200
> Subject: [PATCH] x86/crypto: Add missing RETs
>
> Add explicit RETs to the tail calls of AEGIS and MORUS crypto algorithms
> otherwise they run into INT3 padding due to
>
>   51bad67ffbce ("x86/asm: Pad assembly functions with INT3 instructions")
>
> leading to spurious debug exceptions.
>
> Mike Galbraith <efault@gmx.de> took care of all the remaining callsites.
>
> Signed-off-by: Borislav Petkov <bp@suse.de>

Oh, thanks for fixing that!

Acked-by: Ondrej Mosnacek <omosnacek@gmail.com>

Cheers,
Ondrej

> ---
>  arch/x86/crypto/aegis128-aesni-asm.S  | 1 +
>  arch/x86/crypto/aegis128l-aesni-asm.S | 1 +
>  arch/x86/crypto/aegis256-aesni-asm.S  | 1 +
>  arch/x86/crypto/morus1280-avx2-asm.S  | 1 +
>  arch/x86/crypto/morus1280-sse2-asm.S  | 1 +
>  arch/x86/crypto/morus640-sse2-asm.S   | 1 +
>  6 files changed, 6 insertions(+)
>
> diff --git a/arch/x86/crypto/aegis128-aesni-asm.S b/arch/x86/crypto/aegis=
128-aesni-asm.S
> index 9254e0b6cc06..717bf0776421 100644
> --- a/arch/x86/crypto/aegis128-aesni-asm.S
> +++ b/arch/x86/crypto/aegis128-aesni-asm.S
> @@ -535,6 +535,7 @@ ENTRY(crypto_aegis128_aesni_enc_tail)
>         movdqu STATE3, 0x40(STATEP)
>
>         FRAME_END
> +       ret
>  ENDPROC(crypto_aegis128_aesni_enc_tail)
>
>  .macro decrypt_block a s0 s1 s2 s3 s4 i
> diff --git a/arch/x86/crypto/aegis128l-aesni-asm.S b/arch/x86/crypto/aegi=
s128l-aesni-asm.S
> index 9263c344f2c7..4eda2b8db9e1 100644
> --- a/arch/x86/crypto/aegis128l-aesni-asm.S
> +++ b/arch/x86/crypto/aegis128l-aesni-asm.S
> @@ -645,6 +645,7 @@ ENTRY(crypto_aegis128l_aesni_enc_tail)
>         state_store0
>
>         FRAME_END
> +       ret
>  ENDPROC(crypto_aegis128l_aesni_enc_tail)
>
>  /*
> diff --git a/arch/x86/crypto/aegis256-aesni-asm.S b/arch/x86/crypto/aegis=
256-aesni-asm.S
> index 1d977d515bf9..32aae8397268 100644
> --- a/arch/x86/crypto/aegis256-aesni-asm.S
> +++ b/arch/x86/crypto/aegis256-aesni-asm.S
> @@ -543,6 +543,7 @@ ENTRY(crypto_aegis256_aesni_enc_tail)
>         state_store0
>
>         FRAME_END
> +       ret
>  ENDPROC(crypto_aegis256_aesni_enc_tail)
>
>  /*
> diff --git a/arch/x86/crypto/morus1280-avx2-asm.S b/arch/x86/crypto/morus=
1280-avx2-asm.S
> index 37d422e77931..07653d4582a6 100644
> --- a/arch/x86/crypto/morus1280-avx2-asm.S
> +++ b/arch/x86/crypto/morus1280-avx2-asm.S
> @@ -453,6 +453,7 @@ ENTRY(crypto_morus1280_avx2_enc_tail)
>         vmovdqu STATE4, (4 * 32)(%rdi)
>
>         FRAME_END
> +       ret
>  ENDPROC(crypto_morus1280_avx2_enc_tail)
>
>  /*
> diff --git a/arch/x86/crypto/morus1280-sse2-asm.S b/arch/x86/crypto/morus=
1280-sse2-asm.S
> index 1fe637c7be9d..bd1aa1b60869 100644
> --- a/arch/x86/crypto/morus1280-sse2-asm.S
> +++ b/arch/x86/crypto/morus1280-sse2-asm.S
> @@ -652,6 +652,7 @@ ENTRY(crypto_morus1280_sse2_enc_tail)
>         movdqu STATE4_HI, (9 * 16)(%rdi)
>
>         FRAME_END
> +       ret
>  ENDPROC(crypto_morus1280_sse2_enc_tail)
>
>  /*
> diff --git a/arch/x86/crypto/morus640-sse2-asm.S b/arch/x86/crypto/morus6=
40-sse2-asm.S
> index 71c72a0a0862..efa02816d921 100644
> --- a/arch/x86/crypto/morus640-sse2-asm.S
> +++ b/arch/x86/crypto/morus640-sse2-asm.S
> @@ -437,6 +437,7 @@ ENTRY(crypto_morus640_sse2_enc_tail)
>         movdqu STATE4, (4 * 16)(%rdi)
>
>         FRAME_END
> +       ret
>  ENDPROC(crypto_morus640_sse2_enc_tail)
>
>  /*
> --
> 2.17.0.582.gccdcbd54c
>
> --
> Regards/Gruss,
>     Boris.
>
> Good mailing practices for 400: avoid top-posting and trim the reply.
