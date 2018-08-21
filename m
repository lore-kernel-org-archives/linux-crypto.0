From: Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH] crypto: arm64/aes-modes - get rid of literal load of
 addend vector
Date: Tue, 21 Aug 2018 11:34:42 -0700
Message-ID: <CAKwvOdkktJOSOmbJmq8npbXjfj_u1YOvJjTzMmQRVVZ4tnjY4w@mail.gmail.com>
References: <20180821164614.31513-1-ard.biesheuvel@linaro.org>
 <CAKwvOd=Mh5s+TcSFzwruKq-yZjuMYgXZoG+jqKz5cOhE11cfeA@mail.gmail.com>
 <CAKv+Gu9DV52L1if+Arnrndn6J4SB_W_0MjSq292Z-qMzhgzLAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Robin Murphy <robin.murphy@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-crypto@vger.kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAKv+Gu9DV52L1if+Arnrndn6J4SB_W_0MjSq292Z-qMzhgzLAg@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 21, 2018 at 11:19 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On 21 August 2018 at 20:04, Nick Desaulniers <ndesaulniers@google.com> wrote:
> > On Tue, Aug 21, 2018 at 9:46 AM Ard Biesheuvel
> > <ard.biesheuvel@linaro.org> wrote:
> >>
> >> Replace the literal load of the addend vector with a sequence that
> >> composes it using immediates. While at it, tweak the code that refers
> >> to it so it does not clobber the register, so we can take the load
> >> out of the loop as well.
> >>
> >> This results in generally better code, but also works around a Clang
> >> issue, whose integrated assembler does not implement the GNU ARM asm
> >> syntax completely, and does not support the =literal notation for
> >> FP registers.
> >
> > Would you mind linking to the issue tracker for:
> > https://bugs.llvm.org/show_bug.cgi?id=38642
> >
> > And maybe the comment from the binutils source? (or arm32 reference
> > manual you mentioned in https://lkml.org/lkml/2018/8/21/589)
> > https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=blob;f=gas/testsuite/gas/aarch64/programmer-friendly.s;h=6254c6476efdc848648b05068be0574e7addc85d;hb=HEAD#l11
> >
> > They can help provide more context to future travelers.
> >
>
> Sure, if it helps.

Robin linked to the arm documentation and the gas documentation, maybe
those would be better than the source level comment? Or simply the
llvm bug since I've posted those links there, too?

> To clarify, these are the consecutive values of each of the registers,
> using 16-bit elements:
>
> v7 := { 1, 1, 1, 1, 0, 0, 0, 0 }
> v8 := { 2, 2, 2, 2, 0, 0, 0, 0 }
> v6 := { 3, 0, 3, 0, 3, 0, 3, 0 }
> v8 := { 1, 2, 1, 2, 1, 2, 1, 2 }
> v8 := { 1, 2, 3, 0, 1, 2, 3, 0 }
> v8 := { 1, 0, 2, 0, 3, 0, 0, 0 }

Beautiful, thank you for this.  Can this go in the patch as a comment/ascii art?

With that...

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
-- 
Thanks,
~Nick Desaulniers
