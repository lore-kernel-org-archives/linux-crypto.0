From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] arm64/crypto: remove non-standard notation
Date: Tue, 21 Aug 2018 09:50:44 -0700
Message-ID: <CAKwvOdkZR-MWuMU=j=kKXQwA0LEj1n0uoZQyTpwOzZuz9gjmJQ@mail.gmail.com>
References: <20180820224032.53194-1-ndesaulniers@google.com> <CAKv+Gu-xAmadr96vwStOxdeqi=rCEBrn8V6GofexBhpmA=JiuA@mail.gmail.com>
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
In-Reply-To: <CAKv+Gu-xAmadr96vwStOxdeqi=rCEBrn8V6GofexBhpmA=JiuA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 21, 2018 at 5:23 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> Hi Nick,
>
> On 21 August 2018 at 00:40, Nick Desaulniers <ndesaulniers@google.com> wrote:
> > It seems that:
> > ldr q8, =0x30000000200000001
> >
> > is a GNU as convience notation for:
> > ldr q8, .Lconstant
> > .Lconstant
> > .word 0x00000001
> > .word 0x00000002
> > .word 0x00000003
> > .word 0x00000000
> >
> > based on this comment in binutils' source [0]. I've asked for this
> > non-standard convience notation to be added to other assemblers [1], but
> > until then, we can remove it and get equivalent disassembly:
> >
>
> What do you mean by 'non-standard convenience notation'? Which asm
> 'standard' does Clang actually claim to implement?

Well, for assembly 'standard' is a bit nebulous.  But it's frustrating
when you can't find what the `=0x...` notation means in either the ARM
or GNU as manuals.  The source of truth happened to be a comment in
the source [0] that explained that this was a "programmer friendly
notation."  Sure, if you can find it.

>
> This 'GCC/binutils is broken and we are reluctant to subvert Clang'
> attitude is getting a bit old tbh. In the future, could you please
> mention clang explicitly in the patch subject so it is obvious what
> the purpose of the patch is? I think we should accommodate Clang in
> Linux, but the attitude has got to go.

'Reluctant?' Please assume good faith; I filed the bug/noticed
yesterday [1]. And I'm in favor of supporting the shorthand.  That's
not my argument at all; Strawman.

>
>
> > before:
> > 00000000000009d4 <neon_aes_ctr_encrypt>:
> > ...
> >      a48:       9c000ac8        ldr     q8, ba0 <neon_aes_ctr_encrypt+0x1cc>
> > ...
> >      ba0:       00000001        .word   0x00000001
> >      ba4:       00000002        .word   0x00000002
> >      ba8:       00000003        .word   0x00000003
> >      bac:       00000000        .word   0x00000000
> >
> > after:
> >
> > 00000000000009d4 <neon_aes_ctr_encrypt>:
> > ...
> >      a48:       9c000aa8        ldr     q8, b9c <neon_aes_ctr_encrypt+0x1c8>
> > ...
> >      b9c:       00000001        .word   0x00000001
> >      ba0:       00000002        .word   0x00000002
> >      ba4:       00000003        .word   0x00000003
> >      ba8:       00000000        .word   0x00000000
> >
> > [0] https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=blob;f=gas/testsuite/gas/aarch64/programmer-friendly.s;h=6254c6476efdc848648b05068be0574e7addc85d;hb=HEAD#l11
> > [1] https://bugs.llvm.org/show_bug.cgi?id=38642
> >
> > Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
> > ---
> >  arch/arm64/crypto/aes-modes.S | 8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/crypto/aes-modes.S b/arch/arm64/crypto/aes-modes.S
> > index 483a7130cf0e..9288c5b0eca2 100644
> > --- a/arch/arm64/crypto/aes-modes.S
> > +++ b/arch/arm64/crypto/aes-modes.S
> > @@ -232,7 +232,7 @@ AES_ENTRY(aes_ctr_encrypt)
> >         bmi             .Lctr1x
> >         cmn             w6, #4                  /* 32 bit overflow? */
> >         bcs             .Lctr1x
> > -       ldr             q8, =0x30000000200000001        /* addends 1,2,3[,0] */
> > +       ldr             q8, .Laddends /* addends 1,2,3[,0] */
> >         dup             v7.4s, w6
> >         mov             v0.16b, v4.16b
> >         add             v7.4s, v7.4s, v8.4s
> > @@ -295,6 +295,12 @@ AES_ENTRY(aes_ctr_encrypt)
> >         rev             x7, x7
> >         ins             v4.d[0], x7
> >         b               .Lctrcarrydone
> > +
> > +.Laddends:
> > +       .word   0x00000001
> > +       .word   0x00000002
> > +       .word   0x00000003
> > +       .word   0x00000000
>


> As Will points out, this breaks BE builds.

Looks like -EB and -EL are the flags for me to test with in GNU as
(looks like a few different flags for this).  Is there a target triple
ABI for BE?  I'll ask around here too, and post my findings.

>
> >  AES_ENDPROC(aes_ctr_encrypt)
> >         .ltorg
>
> You can drop this .ltorg if you get rid of all =xxx instances.
>
> Actually, though, I would prefer it if we could use some clever short
> sequence of movi+add instructions, and get rid of the literal
> altogether. Or otherwise, please use something like
>
> ldr_l q8, .Laddends, <temp register>
>
> instead, and move the literal into the .rodata section (and use .octa
> so you don't break BE)

Ah, .octa, neat.  Ok, I'll take a look for v2.

-- 
Thanks,
~Nick Desaulniers
