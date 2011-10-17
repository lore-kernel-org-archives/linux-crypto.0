From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Subject: Re: [PATCH v2.1 1/7] crypto: GnuPG based MPI lib - source files (part 1)
Date: Mon, 17 Oct 2011 14:07:11 +0300
Message-ID: <CALLzPKaOYKdPvGvbzQ4DVF9uGt=bY1-j4uSb0PXD1BvBPuu-ww@mail.gmail.com>
References: <cover.1318598705.git.dmitry.kasatkin@intel.com>
	<92d93a9fe52e048a21d19732c31d80c9ec44de77.1318598705.git.dmitry.kasatkin@intel.com>
	<alpine.LRH.2.00.1110151125280.24994@tundra.namei.org>
	<CALLzPKZ63vp9W_p1t1JOCui+aLRyN6W0t9O-tJ40xKxBef0QPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	zohar@linux.vnet.ibm.com, dhowells@redhat.com,
	herbert@gondor.hengli.com.au
To: James Morris <jmorris@namei.org>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <CALLzPKZ63vp9W_p1t1JOCui+aLRyN6W0t9O-tJ40xKxBef0QPA@mail.gmail.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 17, 2011 at 12:11 PM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> From Kernel Docbook
>
> =C2=A0 =C2=A0Similar to <function>EXPORT_SYMBOL()</function> except t=
hat the
> =C2=A0 =C2=A0symbols exported by <function>EXPORT_SYMBOL_GPL()</funct=
ion> can
> =C2=A0 =C2=A0only be seen by modules with a
> =C2=A0 =C2=A0<function>MODULE_LICENSE()</function> that specifies a G=
PL
> =C2=A0 =C2=A0compatible license. =C2=A0It implies that the function i=
s considered
> =C2=A0 =C2=A0an internal implementation issue, and not really an inte=
rface.
>
> "not really an interface"....
>
> Should it really be EXPORT_SYMBOL_GPL?
>
> - Dmitry
>
> On Sat, Oct 15, 2011 at 3:28 AM, James Morris <jmorris@namei.org> wro=
te:
>> On Fri, 14 Oct 2011, Dmitry Kasatkin wrote:
>>
>>> +MPI mpi_alloc(unsigned nlimbs)
>>> +{
>>> + =C2=A0 =C2=A0 MPI a;
>>> +
>>> + =C2=A0 =C2=A0 a =3D (MPI) kmalloc(sizeof *a, GFP_KERNEL);
>>
>> Generally, typedef structs are frowned upon in the kernel. =C2=A0I'd=
 prefer to
>> see this (and any others) changed to a normal type.
>>
>> Also, kmalloc return values do not need to be cast, they're void *.
>>
>>> +EXPORT_SYMBOL(mpi_alloc);
>>
>> New interfaces should be EXPORT_SYMBOL_GPL.
>>
>>
>> --
>> James Morris
>> <jmorris@namei.org>
>>
>

Hello James,

Also please let me know about other things so that I could fix them as =
well...

Thanks!

- Dmitry
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
