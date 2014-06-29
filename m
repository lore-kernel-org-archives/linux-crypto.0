From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: Re: [PATCH 2/2] crypto: sha1: add ARM NEON implementation
Date: Sun, 29 Jun 2014 14:25:20 +0300
Message-ID: <53AFF7A0.1000306@iki.fi>
References: <20140628103959.24628.55994.stgit@localhost6.localdomain6>	<20140628104004.24628.72714.stgit@localhost6.localdomain6> <CAKv+Gu9uWr6E2DT7Nz35k8YVG_zypktMkkdPKUKncPJ=xo2Lsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"David S. Miller" <davem@davemloft.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:55013 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbaF2LZe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 29 Jun 2014 07:25:34 -0400
In-Reply-To: <CAKv+Gu9uWr6E2DT7Nz35k8YVG_zypktMkkdPKUKncPJ=xo2Lsw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 28.06.2014 23:07, Ard Biesheuvel wrote:> Hi Jussi,
>=20
> On 28 June 2014 12:40, Jussi Kivilinna <jussi.kivilinna@iki.fi> wrote=
:
>> This patch adds ARM NEON assembly implementation of SHA-1 algorithm.
>>
>> tcrypt benchmark results on Cortex-A8, sha1-arm-asm vs sha1-neon-asm=
:
>>
>> block-size      bytes/update    old-vs-new
>> 16              16              1.06x
>> 64              16              1.05x
>> 64              64              1.09x
>> 256             16              1.04x
>> 256             64              1.11x
>> 256             256             1.28x
>> 1024            16              1.04x
>> 1024            256             1.34x
>> 1024            1024            1.42x
>> 2048            16              1.04x
>> 2048            256             1.35x
>> 2048            1024            1.44x
>> 2048            2048            1.46x
>> 4096            16              1.04x
>> 4096            256             1.36x
>> 4096            1024            1.45x
>> 4096            4096            1.48x
>> 8192            16              1.04x
>> 8192            256             1.36x
>> 8192            1024            1.46x
>> 8192            4096            1.49x
>> 8192            8192            1.49x
>>
>=20
> This is a nice result: about the same speedup as OpenSSL when
> comparing the ALU asm implementation with the NEON.
>=20
>> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
>> ---
>>  arch/arm/crypto/Makefile           |    2
>>  arch/arm/crypto/sha1-armv7-neon.S  |  635 +++++++++++++++++++++++++=
+++++++++++
>>  arch/arm/crypto/sha1_glue.c        |    8
>>  arch/arm/crypto/sha1_neon_glue.c   |  197 +++++++++++
>>  arch/arm/include/asm/crypto/sha1.h |   10 +
>>  crypto/Kconfig                     |   11 +
>>  6 files changed, 860 insertions(+), 3 deletions(-)
>>  create mode 100644 arch/arm/crypto/sha1-armv7-neon.S
>>  create mode 100644 arch/arm/crypto/sha1_neon_glue.c
>>  create mode 100644 arch/arm/include/asm/crypto/sha1.h
>>
>> diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
>> index 81cda39..374956d 100644
>> --- a/arch/arm/crypto/Makefile
>> +++ b/arch/arm/crypto/Makefile
>> @@ -5,10 +5,12 @@
>>  obj-$(CONFIG_CRYPTO_AES_ARM) +=3D aes-arm.o
>>  obj-$(CONFIG_CRYPTO_AES_ARM_BS) +=3D aes-arm-bs.o
>>  obj-$(CONFIG_CRYPTO_SHA1_ARM) +=3D sha1-arm.o
>> +obj-$(CONFIG_CRYPTO_SHA1_ARM_NEON) +=3D sha1-arm-neon.o
>>
>>  aes-arm-y      :=3D aes-armv4.o aes_glue.o
>>  aes-arm-bs-y   :=3D aesbs-core.o aesbs-glue.o
>>  sha1-arm-y     :=3D sha1-armv4-large.o sha1_glue.o
>> +sha1-arm-neon-y        :=3D sha1-armv7-neon.o sha1_neon_glue.o
>>
>>  quiet_cmd_perl =3D PERL    $@
>>        cmd_perl =3D $(PERL) $(<) > $(@)
>> diff --git a/arch/arm/crypto/sha1-armv7-neon.S b/arch/arm/crypto/sha=
1-armv7-neon.S
>> new file mode 100644
>> index 0000000..beb1ed1
>> --- /dev/null
>> +++ b/arch/arm/crypto/sha1-armv7-neon.S
>> @@ -0,0 +1,635 @@
>> +/* sha1-armv7-neon.S - ARM/NEON accelerated SHA-1 transform functio=
n
>> + *
>> + * Copyright =C2=A9 2013-2014 Jussi Kivilinna <jussi.kivilinna@iki.=
fi>
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify it
>> + * under the terms of the GNU General Public License as published b=
y the Free
>> + * Software Foundation; either version 2 of the License, or (at you=
r option)
>> + * any later version.
>> + */
>> +
>> +.syntax unified
>> +#ifdef __thumb2__
>> +.thumb
>> +#else
>> +.code   32
>> +#endif
>=20
> This is all NEON code, which has no size benefit from being assembled
> as Thumb-2. (NEON instructions are 4 bytes in either case)
> If we drop the Thumb-2 versions, there's one less version to test.
>=20

Ok, I'll drop the .thumb part for both SHA1 and SHA512.

>> +.fpu neon
>> +
>> +.data
>> +
>> +#define GET_DATA_POINTER(reg, name, rtmp) ldr reg, =3Dname
>> +
> [...]
>> +.align 4
>> +.LK_VEC:
>> +.LK1:  .long K1, K1, K1, K1
>> +.LK2:  .long K2, K2, K2, K2
>> +.LK3:  .long K3, K3, K3, K3
>> +.LK4:  .long K4, K4, K4, K4
>=20
> If you are going to put these constants in a different section, they
> belong in .rodata not .data.
> But why not just keep them in .text? In that case, you can replace th=
e
> above 'ldr reg, =3Dname' with 'adr reg ,name' (or adrl if required) a=
nd
> get rid of the .ltorg and the literal pool.
>=20

Ok, I'll move these to .text.

Actually I realized that these values can be loaded to still free NEON
registers for additional speed up.

>> +/*
>> + * Transform nblks*64 bytes (nblks*16 32-bit words) at DATA.
>> + *
>> + * unsigned int
>> + * sha1_transform_neon (void *ctx, const unsigned char *data,
>> + *                      unsigned int nblks)
>> + */
>> +.align 3
>> +.globl sha1_transform_neon
>> +.type  sha1_transform_neon,%function;
>> +
>> +sha1_transform_neon:
>=20
> ENTRY(sha1_transform_neon) [and matching ENDPROC() below]

Sure.

-Jussi
