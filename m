From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH v2.2 2/7] crypto: GnuPG based MPI lib - header files (part 2)
Date: Thu, 22 Mar 2012 10:21:44 +0200
Message-ID: <CALLzPKYazTXLq3XSALUJgtaRdkYFg-_ZbLT8cx7LPeN-Eg_ZHQ@mail.gmail.com>
References: <cover.1319025009.git.dmitry.kasatkin@intel.com>
	<af9b876508ebc83431312aef67b3ae920780bd5c.1319025009.git.dmitry.kasatkin@intel.com>
	<alpine.DEB.2.00.1203111046110.4778@ayla.of.borg>
	<CAMuHMdWLixmQ-iSiShRjFHgxPp9MZxUQDA=oYasdZd3WwmqGYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	zohar@linux.vnet.ibm.com, dhowells@redhat.com,
	herbert@gondor.apana.org.au,
	"Linux/m68k" <linux-m68k@lists.linux-m68k.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdWLixmQ-iSiShRjFHgxPp9MZxUQDA=oYasdZd3WwmqGYg@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Mar 21, 2012 at 10:39 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Ping?
>
> On Sun, Mar 11, 2012 at 10:55, Geert Uytterhoeven <geert@linux-m68k.o=
rg> wrote:
>> On Wed, 19 Oct 2011, Dmitry Kasatkin wrote:
>>> Adds the multi-precision-integer maths library which was originally=
 taken
>>> from GnuPG and ported to the kernel by (among others) David Howells=
=2E
>>> This version is taken from Fedora kernel 2.6.32-71.14.1.el6.
>>> The difference is that checkpatch reported errors and warnings have=
 been fixed.
>>>
>>> This library is used to implemenet RSA digital signature verificati=
on
>>> used in IMA/EVM integrity protection subsystem.
>>
>>> --- /dev/null
>>> +++ b/lib/mpi/longlong.h
>>
>>> + =C2=A0 =C2=A0 /* If udiv_qrnnd was not defined for this processor=
, use __udiv_qrnnd_c. =C2=A0*/
>>> +#if !defined(udiv_qrnnd)
>>> +#define UDIV_NEEDS_NORMALIZATION 1
>>> +#define udiv_qrnnd __udiv_qrnnd_c
>>> +#endif
>>> +
>>> +#undef count_leading_zeros
>>
>> Why is this #undef here? It's not present in mpi/longlong.h from Ubu=
ntu's
>> gnupg-1.4.10, and causing ...
>>
>>> +#if !defined(count_leading_zeros)
>>> + =C2=A0 =C2=A0 extern
>>> +#ifdef __STDC__
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 const
>>> +#endif
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 unsigned char __clz_tab[];
>>> +#define count_leading_zeros(count, x) \
>>> +do { \
>>> + =C2=A0 =C2=A0 UWtype __xr =3D (x); \
>>> + =C2=A0 =C2=A0 UWtype __a; \
>>> + =C2=A0 =C2=A0 \
>>> + =C2=A0 =C2=A0 if (W_TYPE_SIZE <=3D 32) { \
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __a =3D __xr < ((UWtype=
) 1 << 2*__BITS4) \
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ? (__xr < ((UWtype) 1 <=
< __BITS4) ? 0 : __BITS4) \
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : (__xr < ((UWtype) 1 <=
< 3*__BITS4) ? =C2=A02*__BITS4 : 3*__BITS4); \
>>> + =C2=A0 =C2=A0 } \
>>> + =C2=A0 =C2=A0 else { \
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 for (__a =3D W_TYPE_SIZ=
E - 8; __a > 0; __a -=3D 8) \
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (((__xr >> __a) & 0xff) !=3D 0) \
>>> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 break; \
>>> + =C2=A0 =C2=A0 } \
>>> + =C2=A0 =C2=A0 \
>>> + =C2=A0 =C2=A0 (count) =3D W_TYPE_SIZE - (__clz_tab[__xr >> __a] +=
 __a); \
>>> +} while (0)
>>> + =C2=A0 =C2=A0 /* This version gives a well-defined value for zero=
=2E */
>>> +#define COUNT_LEADING_ZEROS_0 W_TYPE_SIZE
>>
>> lib/mpi/longlong.h:1483:1: warning: "COUNT_LEADING_ZEROS_0" redefine=
d
>> lib/mpi/longlong.h:610:1: warning: this is the location of the previ=
ous definition
>>
>> on m68k/allmodconfig.
>>
>> I'm also wondering why this warning is not seen on other arches, e.g=
=2E PPC
>> #defines COUNT_LEADING_ZEROS_0 to 32, just like m68k.
>>
>>> +#endif
>>
>> I suppose the plan is to clean up this header file, as lots of its
>> functionality is already present in the kernel sources in some other=
 way
>> (e.g. arch/m68k/lib/muldi3.c)?
>
> Gr{oetje,eeting}s,
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linu=
x-m68k.org
>
> In personal conversations with technical people, I call myself a hack=
er. But
> when I'm talking to journalists I just say "programmer" or something =
like that.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0=C2=A0 =C2=A0=C2=A0 -- Linus Torvalds
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> Please read the FAQ at =C2=A0http://www.tux.org/lkml/

Hello,

There are things to cleanup...
It takes a bit of time.

- Dmitry
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
