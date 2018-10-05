From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [RFC PATCH 1/9] kernel: add support for patchable function pointers
Date: Fri, 5 Oct 2018 08:08:08 -0700
Message-ID: <9E0E08C8-0DFC-4E50-A4FA-73208835EF9E@amacapital.net>
References: <20181005081333.15018-1-ard.biesheuvel@linaro.org> <20181005081333.15018-2-ard.biesheuvel@linaro.org> <20181005141433.GS19272@hirez.programming.kicks-ass.net>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        And
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005141433.GS19272@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> On Oct 5, 2018, at 7:14 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>=20
>> On Fri, Oct 05, 2018 at 10:13:25AM +0200, Ard Biesheuvel wrote:
>> diff --git a/include/linux/ffp.h b/include/linux/ffp.h
>> new file mode 100644
>> index 000000000000..8fc3b4c9b38f
>> --- /dev/null
>> +++ b/include/linux/ffp.h
>> @@ -0,0 +1,43 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +#ifndef __LINUX_FFP_H
>> +#define __LINUX_FFP_H
>> +
>> +#include <linux/types.h>
>> +#include <linux/compiler.h>
>> +
>> +#ifdef CONFIG_HAVE_ARCH_FFP
>> +#include <asm/ffp.h>
>> +#else
>> +
>> +struct ffp {
>> +    void    (**fn)(void);
>> +    void    (*default_fn)(void);
>> +};
>> +
>> +#define DECLARE_FFP(_fn, _def)                        \
>> +    extern typeof(_def) *_fn;                    \
>> +    extern struct ffp const __ffp_ ## _fn
>> +
>> +#define DEFINE_FFP(_fn, _def)                        \
>> +    typeof(_def) *_fn =3D &_def;                    \
>> +    struct ffp const __ffp_ ## _fn                    \
>> +        =3D { (void(**)(void))&_fn, (void(*)(void))&_def };    \
>> +    EXPORT_SYMBOL(__ffp_ ## _fn)
>> +
>> +static inline void ffp_set_target(const struct ffp *m, void *new_fn)
>> +{
>> +    WRITE_ONCE(*m->fn, new_fn);
>> +}
>> +
>> +static inline void ffp_reset_target(const struct ffp *m)
>> +{
>> +    WRITE_ONCE(*m->fn, m->default_fn);
>> +}
>> +
>> +#endif
>> +
>> +#define SET_FFP(_fn, _new)    ffp_set_target(&__ffp_ ## _fn, _new)
>> +#define RESET_FFP(_fn)        ffp_reset_target(&__ffp_ ## _fn)
>> +
>> +#endif
>=20
> I don't understand this interface. There is no wrapper for the call
> site, so how are we going to patch all call-sites when you update the
> target?

I=E2=80=99m also confused.

Anyway, we have patchable functions on x86. They=E2=80=99re called PVOPs, an=
d they=E2=80=99re way overcomplicated.

I=E2=80=99ve proposed a better way that should generate better code, be more=
 portable, and be more maintainable.  It goes like this.

To call the function, you literally just call  the default implementation.  I=
t *might* be necessary to call a nonexistent wrapper to avoid annoying optim=
izations. At build time, the kernel is built with relocations, so the object=
 files contain relocation entries for the call. We collect these entries int=
o a table. If we=E2=80=99re using the =E2=80=9Cnonexistent wrapper=E2=80=9D a=
pproach, we can link in a .S or linker script to alias them to the default i=
mplementation.

To patch them, we just patch them. It can=E2=80=99t necessarily be done conc=
urrently because nothing forces the right alignment. But we can do it at boo=
t time and module load time. (Maybe we can patch at runtime on architectures=
 with appropriate instruction alignment.  Or we ask gcc for an extension to a=
lign calls to a function.)

Most of the machinery already exists: this is roughly how the module loader r=
esolves calls outside of a module.=
