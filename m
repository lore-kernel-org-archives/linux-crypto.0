From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH net-next v5 02/20] zinc: introduce minimal cryptography library
Date: Thu, 20 Sep 2018 09:01:36 -0700
Message-ID: <043F588D-4F40-49AB-9F19-1C6180F0393E@amacapital.net>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-3-Jason@zx2c4.com> <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-0oTBrg3T8TsNYPOdrmJSSC313-CYASO34kb_nviva6A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> On Sep 20, 2018, at 8:41 AM, Ard Biesheuvel <ard.biesheuvel@linaro.org> wr=
ote:
>=20
> (+ Arnd, Eric)
>=20
> On 18 September 2018 at 09:16, Jason A. Donenfeld <Jason@zx2c4.com> wrote:=

> ...
>=20
>> diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
>> new file mode 100644
>> index 000000000000..83dfd63988c0
>> --- /dev/null
>> +++ b/lib/zinc/Makefile
>> @@ -0,0 +1,4 @@
>=20
> Apologies for not spotting these before:
>=20
>> +ccflags-y :=3D -O3
>=20
> -O3 optimization has been problematic in the past, at least on x86 but
> I think on other architectures as well. Please stick with -O2.
>=20
>> +ccflags-y +=3D -Wframe-larger-than=3D$(if (CONFIG_KASAN),16384,8192)
>=20
> There is no way we can support code in the kernel with that kind of
> stack space requirements. I will let Arnd comment on what we typically
> allow, since he deals with such issues on a regular basis.

To make matters worse, KASAN is incompatible with VMAP_STACK right now, and K=
ASAN is not so good at detecting stack overflow.

>=20
>> +ccflags-y +=3D -D'pr_fmt(fmt)=3D"zinc: " fmt'
>> +ccflags-$(CONFIG_ZINC_DEBUG) +=3D -DDEBUG
>> --
>> 2.19.0
>>=20
