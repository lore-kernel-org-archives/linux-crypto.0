From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] arm64/crypto: remove non-standard notation
Date: Tue, 21 Aug 2018 11:13:53 -0700
Message-ID: <CAKwvOdnpBT=73JOG-OO36NgnGCGr6HNxhEKsCBDOAX=WR5HB=Q@mail.gmail.com>
References: <20180820224032.53194-1-ndesaulniers@google.com>
 <CAKv+Gu-xAmadr96vwStOxdeqi=rCEBrn8V6GofexBhpmA=JiuA@mail.gmail.com>
 <CAKwvOdkZR-MWuMU=j=kKXQwA0LEj1n0uoZQyTpwOzZuz9gjmJQ@mail.gmail.com>
 <CAKv+Gu8ZZYvh9ZthRH7mvG7_j3bvT=3st-aj0kdwpNQaAcs=-w@mail.gmail.com> <0dda3996-a4f3-33f8-ef4f-935943f132b4@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
To: Robin Murphy <robin.murphy@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0dda3996-a4f3-33f8-ef4f-935943f132b4@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 21, 2018 at 10:25 AM Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 21/08/18 18:00, Ard Biesheuvel wrote:
> > On 21 August 2018 at 18:50, Nick Desaulniers <ndesaulniers@google.com> wrote:
> >> On Tue, Aug 21, 2018 at 5:23 AM Ard Biesheuvel
> >> <ard.biesheuvel@linaro.org> wrote:
> >>>
> >>> Hi Nick,
> >>>
> >>> On 21 August 2018 at 00:40, Nick Desaulniers <ndesaulniers@google.com> wrote:
> >>>> It seems that:
> >>>> ldr q8, =0x30000000200000001
> >>>>
> >>>> is a GNU as convience notation for:
> >>>> ldr q8, .Lconstant
> >>>> .Lconstant
> >>>> .word 0x00000001
> >>>> .word 0x00000002
> >>>> .word 0x00000003
> >>>> .word 0x00000000
> >>>>
> >>>> based on this comment in binutils' source [0]. I've asked for this
> >>>> non-standard convience notation to be added to other assemblers [1], but
> >>>> until then, we can remove it and get equivalent disassembly:
> >>>>
> >>>
> >>> What do you mean by 'non-standard convenience notation'? Which asm
> >>> 'standard' does Clang actually claim to implement?
> >>
> >> Well, for assembly 'standard' is a bit nebulous.  But it's frustrating
> >> when you can't find what the `=0x...` notation means in either the ARM
> >> or GNU as manuals.  The source of truth happened to be a comment in
> >> the source [0] that explained that this was a "programmer friendly
> >> notation."  Sure, if you can find it.
> >>
> >
> > Well, it is documented in the ARM manuals as the 'ldr pseudo
> > instruction' for 32-bit ARM, and originally, it would only emit a
> > literal if the value could not be loaded using a ordinary mov.
>
> FWIW It's certainly well-documented by common A64 assemblers too:
>
> http://infocenter.arm.com/help/topic/com.arm.doc.100069_0610_01_en/dom1395139540926.html
>
> https://sourceware.org/binutils/docs/as/AArch64-Opcodes.html#AArch64-Opcodes

Thanks for those links, I've added them to the LLVM bug to show that
this is documented behavior.
-- 
Thanks,
~Nick Desaulniers
