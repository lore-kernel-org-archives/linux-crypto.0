From: Andy Lutomirski <luto@kernel.org>
Subject: Re: [RFC PATCH 1/9] kernel: add support for patchable function pointers
Date: Fri, 5 Oct 2018 10:20:15 -0700
Message-ID: <CALCETrU=fm+ZG4WZJfG-5GwL7kv5_GS1aZYu=L42d5BuSbhJDQ@mail.gmail.com>
References: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
 <20181005081333.15018-2-ard.biesheuvel@linaro.org> <20181005141433.GS19272@hirez.programming.kicks-ass.net>
 <9E0E08C8-0DFC-4E50-A4FA-73208835EF9E@amacapital.net> <CAKv+Gu9z503ZJXcsG+9Ys240BZiB-+GB=kNY4VGWpjvdzN4JtA@mail.gmail.com>
 <CALCETrWaewXsdJsf3SocgZ0ggnvZk86L+5-LWPRbjdnG2mB7jw@mail.gmail.com> <CAKv+Gu-oHBtgGbWXJu6+z4+BNhBZyY5VvF_v6cJJUGk_5YX1eQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: Andrew Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-oHBtgGbWXJu6+z4+BNhBZyY5VvF_v6cJJUGk_5YX1eQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 5, 2018 at 10:11 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> On 5 October 2018 at 18:58, Andy Lutomirski <luto@kernel.org> wrote:
> > On Fri, Oct 5, 2018 at 8:24 AM Ard Biesheuvel <ard.biesheuvel@linaro.or=
g> wrote:
> >>
> >> On 5 October 2018 at 17:08, Andy Lutomirski <luto@amacapital.net> wrot=
e:
> >> >
> >> >
> >> >> On Oct 5, 2018, at 7:14 AM, Peter Zijlstra <peterz@infradead.org> w=
rote:
> >> >>
> >> >>> On Fri, Oct 05, 2018 at 10:13:25AM +0200, Ard Biesheuvel wrote:
> >> >>> diff --git a/include/linux/ffp.h b/include/linux/ffp.h
> >> >>> new file mode 100644
> >> >>> index 000000000000..8fc3b4c9b38f
> >> >>> --- /dev/null
> >> >>> +++ b/include/linux/ffp.h
> >> >>> @@ -0,0 +1,43 @@
> >> >>> +/* SPDX-License-Identifier: GPL-2.0 */
> >> >>> +
> >> >>> +#ifndef __LINUX_FFP_H
> >> >>> +#define __LINUX_FFP_H
> >> >>> +
> >> >>> +#include <linux/types.h>
> >> >>> +#include <linux/compiler.h>
> >> >>> +
> >> >>> +#ifdef CONFIG_HAVE_ARCH_FFP
> >> >>> +#include <asm/ffp.h>
> >> >>> +#else
> >> >>> +
> >> >>> +struct ffp {
> >> >>> +    void    (**fn)(void);
> >> >>> +    void    (*default_fn)(void);
> >> >>> +};
> >> >>> +
> >> >>> +#define DECLARE_FFP(_fn, _def)                        \
> >> >>> +    extern typeof(_def) *_fn;                    \
> >> >>> +    extern struct ffp const __ffp_ ## _fn
> >> >>> +
> >> >>> +#define DEFINE_FFP(_fn, _def)                        \
> >> >>> +    typeof(_def) *_fn =3D &_def;                    \
> >> >>> +    struct ffp const __ffp_ ## _fn                    \
> >> >>> +        =3D { (void(**)(void))&_fn, (void(*)(void))&_def };    \
> >> >>> +    EXPORT_SYMBOL(__ffp_ ## _fn)
> >> >>> +
> >> >>> +static inline void ffp_set_target(const struct ffp *m, void *new_=
fn)
> >> >>> +{
> >> >>> +    WRITE_ONCE(*m->fn, new_fn);
> >> >>> +}
> >> >>> +
> >> >>> +static inline void ffp_reset_target(const struct ffp *m)
> >> >>> +{
> >> >>> +    WRITE_ONCE(*m->fn, m->default_fn);
> >> >>> +}
> >> >>> +
> >> >>> +#endif
> >> >>> +
> >> >>> +#define SET_FFP(_fn, _new)    ffp_set_target(&__ffp_ ## _fn, _new=
)
> >> >>> +#define RESET_FFP(_fn)        ffp_reset_target(&__ffp_ ## _fn)
> >> >>> +
> >> >>> +#endif
> >> >>
> >> >> I don't understand this interface. There is no wrapper for the call
> >> >> site, so how are we going to patch all call-sites when you update t=
he
> >> >> target?
> >> >
> >> > I=E2=80=99m also confused.
> >> >
> >> > Anyway, we have patchable functions on x86. They=E2=80=99re called P=
VOPs, and they=E2=80=99re way overcomplicated.
> >> >
> >> > I=E2=80=99ve proposed a better way that should generate better code,=
 be more portable, and be more maintainable.  It goes like this.
> >> >
> >> > To call the function, you literally just call  the default implement=
ation.  It *might* be necessary to call a nonexistent wrapper to avoid anno=
ying optimizations. At build time, the kernel is built with relocations, so=
 the object files contain relocation entries for the call. We collect these=
 entries into a table. If we=E2=80=99re using the =E2=80=9Cnonexistent wrap=
per=E2=80=9D approach, we can link in a .S or linker script to alias them t=
o the default implementation.
> >> >
> >> > To patch them, we just patch them. It can=E2=80=99t necessarily be d=
one concurrently because nothing forces the right alignment. But we can do =
it at boot time and module load time. (Maybe we can patch at runtime on arc=
hitectures with appropriate instruction alignment.  Or we ask gcc for an ex=
tension to align calls to a function.)
> >> >
> >> > Most of the machinery already exists: this is roughly how the module=
 loader resolves calls outside of a module.
> >>
> >> Yeah nothing is ever simple on x86 :-(
> >>
> >> So are you saying the approach i use in patch #2 (which would
> >> translate to emitting a jmpq instruction pointing to the default
> >> implementation, and patching it at runtime to point elsewhere) would
> >> not fly on x86?
> >
> > After getting some more sleep, I'm obviously wrong.  The
> > text_poke_bp() mechanism will work.  It's just really slow.
> >
>
> OK
>
> > Let me try to summarize some of the issues.  First, when emitting
> > jumps and calls from inline asm on x86, there are a few considerations
> > that are annoying:
> >
> > 1. Following the x86_64 ABI calling conventions is basically
> > impossible.  x86_64 requires a 128-byte redzone and 16-byte stack
> > alignment.  After much discussion a while back, we decided that it was
> > flat-out impossible on current gcc to get the stack pointer aligned in
> > a known manner in an inline asm statement.  Instead, if we actually
> > need alignment, we need to align manually.  Fortunately, the kernel is
> > built with an override that forces only 8-byte alignment (on *most*
> > GCC versions).  But for crypto in particular, it sucks extra, since
> > the crypto code is basically the only thing in the kernel that
> > actually wants 16-byte alignment.  I don't think this is a huge
> > problem in practice, but it's annoying.  And the kernel is built
> > without a redzone.
> >
> > 2. On x86_64, depending on config, we either need frame pointers or
> > ORC.  ORC is no big deal -- it Just Works (tm).  Frame pointers need
> > extra asm hackery.  It's doable, but it's still annoying.
> >
> > 3. Actually getting the asm constraints right to do what a C
> > programmer expects is distinctly nontrivial.  I just fixed an
> > extremely longstanding bug in the vDSO code in which the asm
> > constraints for the syscall fallback were wrong in such a way that GCC
> > didn't notice that the fallback wrote to its output parameter.
> > Whoops.
> >
>
> OK, so the thing I am missing is why this all matters.
>
> Note that the compiler should take care of all of this. It emits a
> call a function with external linkage having prototype X, and all the
> inline asm does is emit a jmp to some function having that same
> prototype, either the default one or the one we patched in.
>
> Apologies if I am missing something obvious here: as you know, x86 is
> not my focus in general.

The big issue that bothers me isn't the x86-ism so much as the nasty
interactions with the optimizer.  On x86, we have all of this working.
It's in arch/x86/include/asm/paravirt_types.h, and it looks roughly
like:

                        asm volatile(pre                                \
                                     paravirt_alt(PARAVIRT_CALL)        \
                                     post                               \
                                     : call_clbr, ASM_CALL_CONSTRAINT   \
                                     : paravirt_type(op),               \
                                       paravirt_clobber(clbr),          \
                                       ##__VA_ARGS__                    \
                                     : "memory", "cc" extra_clbr);      \

With some extra magic for the constraints.  And I don't even think
this is strictly correct -- from very recent experience, telling the
compiler that "memory" is clobbered and that a bunch of arguments are
used as numeric inputs may not actually imply that the asm modifies
the target of pointer arguments.  Checks this lovely bug out:

https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=3D=
x86/vdso-tglx&id=3D715bd9d12f84d8f5cc8ad21d888f9bc304a8eb0b

As far as I can tell, the whole PVOP infrastructure has the same bug.
And I don't see how to avoid it generically on x86 or any other
architecture.  (PeterZ, am I wrong?  Are we really just getting lucky
that x86 pvop calls actually work?  Or do we not have enough of them
that take pointers as arguments for this to matter?)

Plus, asm volatile ( ..., "memory" ) is a barrier and makes code
generation suck.

Whereas, if we use my suggestion the semantics are precisely those of
any other C function call because, as far as GCC is concerned, it *is*
a C function call.  So the generated code *is* a function call.

--Andy
