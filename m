From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH] arm: crypto: Add NEON optimized SHA-256
Date: Mon, 16 Mar 2015 17:08:03 +0100
Message-ID: <CAKv+Gu8+oQ13j61X6x70baJXOpEiM2L+vK=KgK1JG12sy5KMsg@mail.gmail.com>
References: <20150316154835.GA31336@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Sami Tolvanen <samitolvanen@google.com>,
	Andy Polyakov <appro@openssl.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37284 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965871AbbCPQII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 16 Mar 2015 12:08:08 -0400
Received: by igcqo1 with SMTP id qo1so46487392igc.0
        for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2015 09:08:03 -0700 (PDT)
In-Reply-To: <20150316154835.GA31336@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Sami,

On 16 March 2015 at 16:48, Sami Tolvanen <samitolvanen@google.com> wrot=
e:
> Add Andy Polyakov's NEON optimized SHA-256 implementation.
>
> On Nexus 6, this implementation is ~2x faster than sha256-generic.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
>

Have you tested this code with the tcrypt.ko module?

Some more comments below

> ---
>  arch/arm/crypto/Makefile            |    2
>  arch/arm/crypto/sha256-armv7-neon.S |  819 +++++++++++++++++++++++++=
+++++++++++
>  arch/arm/crypto/sha256_neon_glue.c  |  201 ++++++++
>  crypto/Kconfig                      |   12
>  4 files changed, 1034 insertions(+)
>
> diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
> index b48fa34..316dba2 100644
> --- a/arch/arm/crypto/Makefile
> +++ b/arch/arm/crypto/Makefile
> @@ -6,12 +6,14 @@ obj-$(CONFIG_CRYPTO_AES_ARM) +=3D aes-arm.o
>  obj-$(CONFIG_CRYPTO_AES_ARM_BS) +=3D aes-arm-bs.o
>  obj-$(CONFIG_CRYPTO_SHA1_ARM) +=3D sha1-arm.o
>  obj-$(CONFIG_CRYPTO_SHA1_ARM_NEON) +=3D sha1-arm-neon.o
> +obj-$(CONFIG_CRYPTO_SHA256_ARM_NEON) +=3D sha256-arm-neon.o
>  obj-$(CONFIG_CRYPTO_SHA512_ARM_NEON) +=3D sha512-arm-neon.o
>
>  aes-arm-y      :=3D aes-armv4.o aes_glue.o
>  aes-arm-bs-y   :=3D aesbs-core.o aesbs-glue.o
>  sha1-arm-y     :=3D sha1-armv4-large.o sha1_glue.o
>  sha1-arm-neon-y        :=3D sha1-armv7-neon.o sha1_neon_glue.o
> +sha256-arm-neon-y :=3D sha256-armv7-neon.o sha256_neon_glue.o
>  sha512-arm-neon-y :=3D sha512-armv7-neon.o sha512_neon_glue.o
>
>  quiet_cmd_perl =3D PERL    $@
> diff --git a/arch/arm/crypto/sha256-armv7-neon.S b/arch/arm/crypto/sh=
a256-armv7-neon.S
> new file mode 100644
> index 0000000..5ce04c2
> --- /dev/null
> +++ b/arch/arm/crypto/sha256-armv7-neon.S
> @@ -0,0 +1,819 @@
> +@ sha256-armv7-neon.S  -  ARM/NEON assembly implementation of SHA-25=
6 transform
> +@
> +@ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +@ Written by Andy Polyakov <appro@openssl.org> for the OpenSSL
> +@ project. The module is, however, dual licensed under OpenSSL and
> +@ CRYPTOGAMS licenses depending on where you obtain it. For further
> +@ details see http://www.openssl.org/~appro/cryptogams/.
> +@ =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +

Did you talk to Andy about the license? I don't think this is
permissible for the kernel as-is.


> +#include <linux/linkage.h>
> +
> +.text
> +.code   32
> +.fpu neon
> +
> +.type  K256,%object
> +.align 5
> +K256:
> +.word  0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5
> +.word  0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5
> +.word  0xd807aa98,0x12835b01,0x243185be,0x550c7dc3
> +.word  0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174
> +.word  0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc
> +.word  0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da
> +.word  0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7
> +.word  0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967
> +.word  0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13
> +.word  0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85
> +.word  0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3
> +.word  0xd192e819,0xd6990624,0xf40e3585,0x106aa070
> +.word  0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5
> +.word  0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3
> +.word  0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208
> +.word  0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
> +.size  K256,.-K256
> +.word  0                               @ terminator
> +.word  0
> +.align 5
> +
> +.align 5
> +ENTRY(sha256_transform_neon)
> +       /* Input:
> +        *      %r0: SHA256_CONTEXT
> +        *      %r1: data
> +        *      %r2: nblks
> +        */
> +       sub     r3,pc,#8                @ sha256_transform_neon

This is broken on thumb-2, use adr instead


> +       add     r2,r1,r2,lsl#6  @ len to point at the end of inp
> +
> +       stmdb   sp!,{r4-r12,lr}
> +
> +       mov     r12,sp
> +       sub     sp,sp,#16*4+16          @ alloca
> +       sub     r14,r3,#256+32  @ K256
> +       bic     sp,sp,#15               @ align for 128-bit stores
> +
> +       vld1.8          {q0},[r1]!
> +       vld1.8          {q1},[r1]!
> +       vld1.8          {q2},[r1]!
> +       vld1.8          {q3},[r1]!
> +       vld1.32         {q8},[r14,:128]!
> +       vld1.32         {q9},[r14,:128]!
> +       vld1.32         {q10},[r14,:128]!
> +       vld1.32         {q11},[r14,:128]!
> +       vrev32.8        q0,q0           @ yes, even on
> +       str             r0,[sp,#64]
> +       vrev32.8        q1,q1           @ big-endian
> +       str             r1,[sp,#68]
> +       mov             r1,sp
> +       vrev32.8        q2,q2
> +       str             r2,[sp,#72]
> +       vrev32.8        q3,q3
> +       str             r12,[sp,#76]            @ save original sp
> +       vadd.i32        q8,q8,q0
> +       vadd.i32        q9,q9,q1
> +       vst1.32         {q8},[r1,:128]!
> +       vadd.i32        q10,q10,q2
> +       vst1.32         {q9},[r1,:128]!
> +       vadd.i32        q11,q11,q3
> +       vst1.32         {q10},[r1,:128]!
> +       vst1.32         {q11},[r1,:128]!
> +
> +       ldmia           r0,{r4-r11}
> +       sub             r1,r1,#64
> +       ldr             r2,[sp,#0]
> +       eor             r12,r12,r12
> +       eor             r3,r5,r6
> +       b               .L_00_48
> +
> +.align 4
> +.L_00_48:
> +       vext.8  q8,q0,q1,#4
> +       add     r11,r11,r2
> +       eor     r2,r9,r10
> +       eor     r0,r8,r8,ror#5
> +       vext.8  q9,q2,q3,#4
> +       add     r4,r4,r12
> +       and     r2,r2,r8
> +       eor     r12,r0,r8,ror#19
> +       vshr.u32        q10,q8,#7
> +       eor     r0,r4,r4,ror#11
> +       eor     r2,r2,r10
> +       vadd.i32        q0,q0,q9
> +       add     r11,r11,r12,ror#6
> +       eor     r12,r4,r5
> +       vshr.u32        q9,q8,#3
> +       eor     r0,r0,r4,ror#20
> +       add     r11,r11,r2
> +       vsli.32 q10,q8,#25
> +       ldr     r2,[sp,#4]
> +       and     r3,r3,r12
> +       vshr.u32        q11,q8,#18
> +       add     r7,r7,r11
> +       add     r11,r11,r0,ror#2
> +       eor     r3,r3,r5
> +       veor    q9,q9,q10
> +       add     r10,r10,r2
> +       vsli.32 q11,q8,#14
> +       eor     r2,r8,r9
> +       eor     r0,r7,r7,ror#5
> +       vshr.u32        d24,d7,#17
> +       add     r11,r11,r3
> +       and     r2,r2,r7
> +       veor    q9,q9,q11
> +       eor     r3,r0,r7,ror#19
> +       eor     r0,r11,r11,ror#11
> +       vsli.32 d24,d7,#15
> +       eor     r2,r2,r9
> +       add     r10,r10,r3,ror#6
> +       vshr.u32        d25,d7,#10
> +       eor     r3,r11,r4
> +       eor     r0,r0,r11,ror#20
> +       vadd.i32        q0,q0,q9
> +       add     r10,r10,r2
> +       ldr     r2,[sp,#8]
> +       veor    d25,d25,d24
> +       and     r12,r12,r3
> +       add     r6,r6,r10
> +       vshr.u32        d24,d7,#19
> +       add     r10,r10,r0,ror#2
> +       eor     r12,r12,r4
> +       vsli.32 d24,d7,#13
> +       add     r9,r9,r2
> +       eor     r2,r7,r8
> +       veor    d25,d25,d24
> +       eor     r0,r6,r6,ror#5
> +       add     r10,r10,r12
> +       vadd.i32        d0,d0,d25
> +       and     r2,r2,r6
> +       eor     r12,r0,r6,ror#19
> +       vshr.u32        d24,d0,#17
> +       eor     r0,r10,r10,ror#11
> +       eor     r2,r2,r8
> +       vsli.32 d24,d0,#15
> +       add     r9,r9,r12,ror#6
> +       eor     r12,r10,r11
> +       vshr.u32        d25,d0,#10
> +       eor     r0,r0,r10,ror#20
> +       add     r9,r9,r2
> +       veor    d25,d25,d24
> +       ldr     r2,[sp,#12]
> +       and     r3,r3,r12
> +       vshr.u32        d24,d0,#19
> +       add     r5,r5,r9
> +       add     r9,r9,r0,ror#2
> +       eor     r3,r3,r11
> +       vld1.32 {q8},[r14,:128]!
> +       add     r8,r8,r2
> +       vsli.32 d24,d0,#13
> +       eor     r2,r6,r7
> +       eor     r0,r5,r5,ror#5
> +       veor    d25,d25,d24
> +       add     r9,r9,r3
> +       and     r2,r2,r5
> +       vadd.i32        d1,d1,d25
> +       eor     r3,r0,r5,ror#19
> +       eor     r0,r9,r9,ror#11
> +       vadd.i32        q8,q8,q0
> +       eor     r2,r2,r7
> +       add     r8,r8,r3,ror#6
> +       eor     r3,r9,r10
> +       eor     r0,r0,r9,ror#20
> +       add     r8,r8,r2
> +       ldr     r2,[sp,#16]
> +       and     r12,r12,r3
> +       add     r4,r4,r8
> +       vst1.32 {q8},[r1,:128]!
> +       add     r8,r8,r0,ror#2
> +       eor     r12,r12,r10
> +       vext.8  q8,q1,q2,#4
> +       add     r7,r7,r2
> +       eor     r2,r5,r6
> +       eor     r0,r4,r4,ror#5
> +       vext.8  q9,q3,q0,#4
> +       add     r8,r8,r12
> +       and     r2,r2,r4
> +       eor     r12,r0,r4,ror#19
> +       vshr.u32        q10,q8,#7
> +       eor     r0,r8,r8,ror#11
> +       eor     r2,r2,r6
> +       vadd.i32        q1,q1,q9
> +       add     r7,r7,r12,ror#6
> +       eor     r12,r8,r9
> +       vshr.u32        q9,q8,#3
> +       eor     r0,r0,r8,ror#20
> +       add     r7,r7,r2
> +       vsli.32 q10,q8,#25
> +       ldr     r2,[sp,#20]
> +       and     r3,r3,r12
> +       vshr.u32        q11,q8,#18
> +       add     r11,r11,r7
> +       add     r7,r7,r0,ror#2
> +       eor     r3,r3,r9
> +       veor    q9,q9,q10
> +       add     r6,r6,r2
> +       vsli.32 q11,q8,#14
> +       eor     r2,r4,r5
> +       eor     r0,r11,r11,ror#5
> +       vshr.u32        d24,d1,#17
> +       add     r7,r7,r3
> +       and     r2,r2,r11
> +       veor    q9,q9,q11
> +       eor     r3,r0,r11,ror#19
> +       eor     r0,r7,r7,ror#11
> +       vsli.32 d24,d1,#15
> +       eor     r2,r2,r5
> +       add     r6,r6,r3,ror#6
> +       vshr.u32        d25,d1,#10
> +       eor     r3,r7,r8
> +       eor     r0,r0,r7,ror#20
> +       vadd.i32        q1,q1,q9
> +       add     r6,r6,r2
> +       ldr     r2,[sp,#24]
> +       veor    d25,d25,d24
> +       and     r12,r12,r3
> +       add     r10,r10,r6
> +       vshr.u32        d24,d1,#19
> +       add     r6,r6,r0,ror#2
> +       eor     r12,r12,r8
> +       vsli.32 d24,d1,#13
> +       add     r5,r5,r2
> +       eor     r2,r11,r4
> +       veor    d25,d25,d24
> +       eor     r0,r10,r10,ror#5
> +       add     r6,r6,r12
> +       vadd.i32        d2,d2,d25
> +       and     r2,r2,r10
> +       eor     r12,r0,r10,ror#19
> +       vshr.u32        d24,d2,#17
> +       eor     r0,r6,r6,ror#11
> +       eor     r2,r2,r4
> +       vsli.32 d24,d2,#15
> +       add     r5,r5,r12,ror#6
> +       eor     r12,r6,r7
> +       vshr.u32        d25,d2,#10
> +       eor     r0,r0,r6,ror#20
> +       add     r5,r5,r2
> +       veor    d25,d25,d24
> +       ldr     r2,[sp,#28]
> +       and     r3,r3,r12
> +       vshr.u32        d24,d2,#19
> +       add     r9,r9,r5
> +       add     r5,r5,r0,ror#2
> +       eor     r3,r3,r7
> +       vld1.32 {q8},[r14,:128]!
> +       add     r4,r4,r2
> +       vsli.32 d24,d2,#13
> +       eor     r2,r10,r11
> +       eor     r0,r9,r9,ror#5
> +       veor    d25,d25,d24
> +       add     r5,r5,r3
> +       and     r2,r2,r9
> +       vadd.i32        d3,d3,d25
> +       eor     r3,r0,r9,ror#19
> +       eor     r0,r5,r5,ror#11
> +       vadd.i32        q8,q8,q1
> +       eor     r2,r2,r11
> +       add     r4,r4,r3,ror#6
> +       eor     r3,r5,r6
> +       eor     r0,r0,r5,ror#20
> +       add     r4,r4,r2
> +       ldr     r2,[sp,#32]
> +       and     r12,r12,r3
> +       add     r8,r8,r4
> +       vst1.32 {q8},[r1,:128]!
> +       add     r4,r4,r0,ror#2
> +       eor     r12,r12,r6
> +       vext.8  q8,q2,q3,#4
> +       add     r11,r11,r2
> +       eor     r2,r9,r10
> +       eor     r0,r8,r8,ror#5
> +       vext.8  q9,q0,q1,#4
> +       add     r4,r4,r12
> +       and     r2,r2,r8
> +       eor     r12,r0,r8,ror#19
> +       vshr.u32        q10,q8,#7
> +       eor     r0,r4,r4,ror#11
> +       eor     r2,r2,r10
> +       vadd.i32        q2,q2,q9
> +       add     r11,r11,r12,ror#6
> +       eor     r12,r4,r5
> +       vshr.u32        q9,q8,#3
> +       eor     r0,r0,r4,ror#20
> +       add     r11,r11,r2
> +       vsli.32 q10,q8,#25
> +       ldr     r2,[sp,#36]
> +       and     r3,r3,r12
> +       vshr.u32        q11,q8,#18
> +       add     r7,r7,r11
> +       add     r11,r11,r0,ror#2
> +       eor     r3,r3,r5
> +       veor    q9,q9,q10
> +       add     r10,r10,r2
> +       vsli.32 q11,q8,#14
> +       eor     r2,r8,r9
> +       eor     r0,r7,r7,ror#5
> +       vshr.u32        d24,d3,#17
> +       add     r11,r11,r3
> +       and     r2,r2,r7
> +       veor    q9,q9,q11
> +       eor     r3,r0,r7,ror#19
> +       eor     r0,r11,r11,ror#11
> +       vsli.32 d24,d3,#15
> +       eor     r2,r2,r9
> +       add     r10,r10,r3,ror#6
> +       vshr.u32        d25,d3,#10
> +       eor     r3,r11,r4
> +       eor     r0,r0,r11,ror#20
> +       vadd.i32        q2,q2,q9
> +       add     r10,r10,r2
> +       ldr     r2,[sp,#40]
> +       veor    d25,d25,d24
> +       and     r12,r12,r3
> +       add     r6,r6,r10
> +       vshr.u32        d24,d3,#19
> +       add     r10,r10,r0,ror#2
> +       eor     r12,r12,r4
> +       vsli.32 d24,d3,#13
> +       add     r9,r9,r2
> +       eor     r2,r7,r8
> +       veor    d25,d25,d24
> +       eor     r0,r6,r6,ror#5
> +       add     r10,r10,r12
> +       vadd.i32        d4,d4,d25
> +       and     r2,r2,r6
> +       eor     r12,r0,r6,ror#19
> +       vshr.u32        d24,d4,#17
> +       eor     r0,r10,r10,ror#11
> +       eor     r2,r2,r8
> +       vsli.32 d24,d4,#15
> +       add     r9,r9,r12,ror#6
> +       eor     r12,r10,r11
> +       vshr.u32        d25,d4,#10
> +       eor     r0,r0,r10,ror#20
> +       add     r9,r9,r2
> +       veor    d25,d25,d24
> +       ldr     r2,[sp,#44]
> +       and     r3,r3,r12
> +       vshr.u32        d24,d4,#19
> +       add     r5,r5,r9
> +       add     r9,r9,r0,ror#2
> +       eor     r3,r3,r11
> +       vld1.32 {q8},[r14,:128]!
> +       add     r8,r8,r2
> +       vsli.32 d24,d4,#13
> +       eor     r2,r6,r7
> +       eor     r0,r5,r5,ror#5
> +       veor    d25,d25,d24
> +       add     r9,r9,r3
> +       and     r2,r2,r5
> +       vadd.i32        d5,d5,d25
> +       eor     r3,r0,r5,ror#19
> +       eor     r0,r9,r9,ror#11
> +       vadd.i32        q8,q8,q2
> +       eor     r2,r2,r7
> +       add     r8,r8,r3,ror#6
> +       eor     r3,r9,r10
> +       eor     r0,r0,r9,ror#20
> +       add     r8,r8,r2
> +       ldr     r2,[sp,#48]
> +       and     r12,r12,r3
> +       add     r4,r4,r8
> +       vst1.32 {q8},[r1,:128]!
> +       add     r8,r8,r0,ror#2
> +       eor     r12,r12,r10
> +       vext.8  q8,q3,q0,#4
> +       add     r7,r7,r2
> +       eor     r2,r5,r6
> +       eor     r0,r4,r4,ror#5
> +       vext.8  q9,q1,q2,#4
> +       add     r8,r8,r12
> +       and     r2,r2,r4
> +       eor     r12,r0,r4,ror#19
> +       vshr.u32        q10,q8,#7
> +       eor     r0,r8,r8,ror#11
> +       eor     r2,r2,r6
> +       vadd.i32        q3,q3,q9
> +       add     r7,r7,r12,ror#6
> +       eor     r12,r8,r9
> +       vshr.u32        q9,q8,#3
> +       eor     r0,r0,r8,ror#20
> +       add     r7,r7,r2
> +       vsli.32 q10,q8,#25
> +       ldr     r2,[sp,#52]
> +       and     r3,r3,r12
> +       vshr.u32        q11,q8,#18
> +       add     r11,r11,r7
> +       add     r7,r7,r0,ror#2
> +       eor     r3,r3,r9
> +       veor    q9,q9,q10
> +       add     r6,r6,r2
> +       vsli.32 q11,q8,#14
> +       eor     r2,r4,r5
> +       eor     r0,r11,r11,ror#5
> +       vshr.u32        d24,d5,#17
> +       add     r7,r7,r3
> +       and     r2,r2,r11
> +       veor    q9,q9,q11
> +       eor     r3,r0,r11,ror#19
> +       eor     r0,r7,r7,ror#11
> +       vsli.32 d24,d5,#15
> +       eor     r2,r2,r5
> +       add     r6,r6,r3,ror#6
> +       vshr.u32        d25,d5,#10
> +       eor     r3,r7,r8
> +       eor     r0,r0,r7,ror#20
> +       vadd.i32        q3,q3,q9
> +       add     r6,r6,r2
> +       ldr     r2,[sp,#56]
> +       veor    d25,d25,d24
> +       and     r12,r12,r3
> +       add     r10,r10,r6
> +       vshr.u32        d24,d5,#19
> +       add     r6,r6,r0,ror#2
> +       eor     r12,r12,r8
> +       vsli.32 d24,d5,#13
> +       add     r5,r5,r2
> +       eor     r2,r11,r4
> +       veor    d25,d25,d24
> +       eor     r0,r10,r10,ror#5
> +       add     r6,r6,r12
> +       vadd.i32        d6,d6,d25
> +       and     r2,r2,r10
> +       eor     r12,r0,r10,ror#19
> +       vshr.u32        d24,d6,#17
> +       eor     r0,r6,r6,ror#11
> +       eor     r2,r2,r4
> +       vsli.32 d24,d6,#15
> +       add     r5,r5,r12,ror#6
> +       eor     r12,r6,r7
> +       vshr.u32        d25,d6,#10
> +       eor     r0,r0,r6,ror#20
> +       add     r5,r5,r2
> +       veor    d25,d25,d24
> +       ldr     r2,[sp,#60]
> +       and     r3,r3,r12
> +       vshr.u32        d24,d6,#19
> +       add     r9,r9,r5
> +       add     r5,r5,r0,ror#2
> +       eor     r3,r3,r7
> +       vld1.32 {q8},[r14,:128]!
> +       add     r4,r4,r2
> +       vsli.32 d24,d6,#13
> +       eor     r2,r10,r11
> +       eor     r0,r9,r9,ror#5
> +       veor    d25,d25,d24
> +       add     r5,r5,r3
> +       and     r2,r2,r9
> +       vadd.i32        d7,d7,d25
> +       eor     r3,r0,r9,ror#19
> +       eor     r0,r5,r5,ror#11
> +       vadd.i32        q8,q8,q3
> +       eor     r2,r2,r11
> +       add     r4,r4,r3,ror#6
> +       eor     r3,r5,r6
> +       eor     r0,r0,r5,ror#20
> +       add     r4,r4,r2
> +       ldr     r2,[r14]
> +       and     r12,r12,r3
> +       add     r8,r8,r4
> +       vst1.32 {q8},[r1,:128]!
> +       add     r4,r4,r0,ror#2
> +       eor     r12,r12,r6
> +       teq     r2,#0                           @ check for K256 term=
inator
> +       ldr     r2,[sp,#0]
> +       sub     r1,r1,#64
> +       bne     .L_00_48
> +
> +       ldr             r1,[sp,#68]
> +       ldr             r0,[sp,#72]
> +       sub             r14,r14,#256    @ rewind r14
> +       teq             r1,r0
> +       subeq           r1,r1,#64               @ avoid SEGV
> +       vld1.8          {q0},[r1]!              @ load next input blo=
ck
> +       vld1.8          {q1},[r1]!
> +       vld1.8          {q2},[r1]!
> +       vld1.8          {q3},[r1]!
> +       strne           r1,[sp,#68]
> +       mov             r1,sp
> +       add     r11,r11,r2
> +       eor     r2,r9,r10
> +       eor     r0,r8,r8,ror#5
> +       add     r4,r4,r12
> +       vld1.32 {q8},[r14,:128]!
> +       and     r2,r2,r8
> +       eor     r12,r0,r8,ror#19
> +       eor     r0,r4,r4,ror#11
> +       eor     r2,r2,r10
> +       vrev32.8        q0,q0
> +       add     r11,r11,r12,ror#6
> +       eor     r12,r4,r5
> +       eor     r0,r0,r4,ror#20
> +       add     r11,r11,r2
> +       vadd.i32        q8,q8,q0
> +       ldr     r2,[sp,#4]
> +       and     r3,r3,r12
> +       add     r7,r7,r11
> +       add     r11,r11,r0,ror#2
> +       eor     r3,r3,r5
> +       add     r10,r10,r2
> +       eor     r2,r8,r9
> +       eor     r0,r7,r7,ror#5
> +       add     r11,r11,r3
> +       and     r2,r2,r7
> +       eor     r3,r0,r7,ror#19
> +       eor     r0,r11,r11,ror#11
> +       eor     r2,r2,r9
> +       add     r10,r10,r3,ror#6
> +       eor     r3,r11,r4
> +       eor     r0,r0,r11,ror#20
> +       add     r10,r10,r2
> +       ldr     r2,[sp,#8]
> +       and     r12,r12,r3
> +       add     r6,r6,r10
> +       add     r10,r10,r0,ror#2
> +       eor     r12,r12,r4
> +       add     r9,r9,r2
> +       eor     r2,r7,r8
> +       eor     r0,r6,r6,ror#5
> +       add     r10,r10,r12
> +       and     r2,r2,r6
> +       eor     r12,r0,r6,ror#19
> +       eor     r0,r10,r10,ror#11
> +       eor     r2,r2,r8
> +       add     r9,r9,r12,ror#6
> +       eor     r12,r10,r11
> +       eor     r0,r0,r10,ror#20
> +       add     r9,r9,r2
> +       ldr     r2,[sp,#12]
> +       and     r3,r3,r12
> +       add     r5,r5,r9
> +       add     r9,r9,r0,ror#2
> +       eor     r3,r3,r11
> +       add     r8,r8,r2
> +       eor     r2,r6,r7
> +       eor     r0,r5,r5,ror#5
> +       add     r9,r9,r3
> +       and     r2,r2,r5
> +       eor     r3,r0,r5,ror#19
> +       eor     r0,r9,r9,ror#11
> +       eor     r2,r2,r7
> +       add     r8,r8,r3,ror#6
> +       eor     r3,r9,r10
> +       eor     r0,r0,r9,ror#20
> +       add     r8,r8,r2
> +       ldr     r2,[sp,#16]
> +       and     r12,r12,r3
> +       add     r4,r4,r8
> +       add     r8,r8,r0,ror#2
> +       eor     r12,r12,r10
> +       vst1.32 {q8},[r1,:128]!
> +       add     r7,r7,r2
> +       eor     r2,r5,r6
> +       eor     r0,r4,r4,ror#5
> +       add     r8,r8,r12
> +       vld1.32 {q8},[r14,:128]!
> +       and     r2,r2,r4
> +       eor     r12,r0,r4,ror#19
> +       eor     r0,r8,r8,ror#11
> +       eor     r2,r2,r6
> +       vrev32.8        q1,q1
> +       add     r7,r7,r12,ror#6
> +       eor     r12,r8,r9
> +       eor     r0,r0,r8,ror#20
> +       add     r7,r7,r2
> +       vadd.i32        q8,q8,q1
> +       ldr     r2,[sp,#20]
> +       and     r3,r3,r12
> +       add     r11,r11,r7
> +       add     r7,r7,r0,ror#2
> +       eor     r3,r3,r9
> +       add     r6,r6,r2
> +       eor     r2,r4,r5
> +       eor     r0,r11,r11,ror#5
> +       add     r7,r7,r3
> +       and     r2,r2,r11
> +       eor     r3,r0,r11,ror#19
> +       eor     r0,r7,r7,ror#11
> +       eor     r2,r2,r5
> +       add     r6,r6,r3,ror#6
> +       eor     r3,r7,r8
> +       eor     r0,r0,r7,ror#20
> +       add     r6,r6,r2
> +       ldr     r2,[sp,#24]
> +       and     r12,r12,r3
> +       add     r10,r10,r6
> +       add     r6,r6,r0,ror#2
> +       eor     r12,r12,r8
> +       add     r5,r5,r2
> +       eor     r2,r11,r4
> +       eor     r0,r10,r10,ror#5
> +       add     r6,r6,r12
> +       and     r2,r2,r10
> +       eor     r12,r0,r10,ror#19
> +       eor     r0,r6,r6,ror#11
> +       eor     r2,r2,r4
> +       add     r5,r5,r12,ror#6
> +       eor     r12,r6,r7
> +       eor     r0,r0,r6,ror#20
> +       add     r5,r5,r2
> +       ldr     r2,[sp,#28]
> +       and     r3,r3,r12
> +       add     r9,r9,r5
> +       add     r5,r5,r0,ror#2
> +       eor     r3,r3,r7
> +       add     r4,r4,r2
> +       eor     r2,r10,r11
> +       eor     r0,r9,r9,ror#5
> +       add     r5,r5,r3
> +       and     r2,r2,r9
> +       eor     r3,r0,r9,ror#19
> +       eor     r0,r5,r5,ror#11
> +       eor     r2,r2,r11
> +       add     r4,r4,r3,ror#6
> +       eor     r3,r5,r6
> +       eor     r0,r0,r5,ror#20
> +       add     r4,r4,r2
> +       ldr     r2,[sp,#32]
> +       and     r12,r12,r3
> +       add     r8,r8,r4
> +       add     r4,r4,r0,ror#2
> +       eor     r12,r12,r6
> +       vst1.32 {q8},[r1,:128]!
> +       add     r11,r11,r2
> +       eor     r2,r9,r10
> +       eor     r0,r8,r8,ror#5
> +       add     r4,r4,r12
> +       vld1.32 {q8},[r14,:128]!
> +       and     r2,r2,r8
> +       eor     r12,r0,r8,ror#19
> +       eor     r0,r4,r4,ror#11
> +       eor     r2,r2,r10
> +       vrev32.8        q2,q2
> +       add     r11,r11,r12,ror#6
> +       eor     r12,r4,r5
> +       eor     r0,r0,r4,ror#20
> +       add     r11,r11,r2
> +       vadd.i32        q8,q8,q2
> +       ldr     r2,[sp,#36]
> +       and     r3,r3,r12
> +       add     r7,r7,r11
> +       add     r11,r11,r0,ror#2
> +       eor     r3,r3,r5
> +       add     r10,r10,r2
> +       eor     r2,r8,r9
> +       eor     r0,r7,r7,ror#5
> +       add     r11,r11,r3
> +       and     r2,r2,r7
> +       eor     r3,r0,r7,ror#19
> +       eor     r0,r11,r11,ror#11
> +       eor     r2,r2,r9
> +       add     r10,r10,r3,ror#6
> +       eor     r3,r11,r4
> +       eor     r0,r0,r11,ror#20
> +       add     r10,r10,r2
> +       ldr     r2,[sp,#40]
> +       and     r12,r12,r3
> +       add     r6,r6,r10
> +       add     r10,r10,r0,ror#2
> +       eor     r12,r12,r4
> +       add     r9,r9,r2
> +       eor     r2,r7,r8
> +       eor     r0,r6,r6,ror#5
> +       add     r10,r10,r12
> +       and     r2,r2,r6
> +       eor     r12,r0,r6,ror#19
> +       eor     r0,r10,r10,ror#11
> +       eor     r2,r2,r8
> +       add     r9,r9,r12,ror#6
> +       eor     r12,r10,r11
> +       eor     r0,r0,r10,ror#20
> +       add     r9,r9,r2
> +       ldr     r2,[sp,#44]
> +       and     r3,r3,r12
> +       add     r5,r5,r9
> +       add     r9,r9,r0,ror#2
> +       eor     r3,r3,r11
> +       add     r8,r8,r2
> +       eor     r2,r6,r7
> +       eor     r0,r5,r5,ror#5
> +       add     r9,r9,r3
> +       and     r2,r2,r5
> +       eor     r3,r0,r5,ror#19
> +       eor     r0,r9,r9,ror#11
> +       eor     r2,r2,r7
> +       add     r8,r8,r3,ror#6
> +       eor     r3,r9,r10
> +       eor     r0,r0,r9,ror#20
> +       add     r8,r8,r2
> +       ldr     r2,[sp,#48]
> +       and     r12,r12,r3
> +       add     r4,r4,r8
> +       add     r8,r8,r0,ror#2
> +       eor     r12,r12,r10
> +       vst1.32 {q8},[r1,:128]!
> +       add     r7,r7,r2
> +       eor     r2,r5,r6
> +       eor     r0,r4,r4,ror#5
> +       add     r8,r8,r12
> +       vld1.32 {q8},[r14,:128]!
> +       and     r2,r2,r4
> +       eor     r12,r0,r4,ror#19
> +       eor     r0,r8,r8,ror#11
> +       eor     r2,r2,r6
> +       vrev32.8        q3,q3
> +       add     r7,r7,r12,ror#6
> +       eor     r12,r8,r9
> +       eor     r0,r0,r8,ror#20
> +       add     r7,r7,r2
> +       vadd.i32        q8,q8,q3
> +       ldr     r2,[sp,#52]
> +       and     r3,r3,r12
> +       add     r11,r11,r7
> +       add     r7,r7,r0,ror#2
> +       eor     r3,r3,r9
> +       add     r6,r6,r2
> +       eor     r2,r4,r5
> +       eor     r0,r11,r11,ror#5
> +       add     r7,r7,r3
> +       and     r2,r2,r11
> +       eor     r3,r0,r11,ror#19
> +       eor     r0,r7,r7,ror#11
> +       eor     r2,r2,r5
> +       add     r6,r6,r3,ror#6
> +       eor     r3,r7,r8
> +       eor     r0,r0,r7,ror#20
> +       add     r6,r6,r2
> +       ldr     r2,[sp,#56]
> +       and     r12,r12,r3
> +       add     r10,r10,r6
> +       add     r6,r6,r0,ror#2
> +       eor     r12,r12,r8
> +       add     r5,r5,r2
> +       eor     r2,r11,r4
> +       eor     r0,r10,r10,ror#5
> +       add     r6,r6,r12
> +       and     r2,r2,r10
> +       eor     r12,r0,r10,ror#19
> +       eor     r0,r6,r6,ror#11
> +       eor     r2,r2,r4
> +       add     r5,r5,r12,ror#6
> +       eor     r12,r6,r7
> +       eor     r0,r0,r6,ror#20
> +       add     r5,r5,r2
> +       ldr     r2,[sp,#60]
> +       and     r3,r3,r12
> +       add     r9,r9,r5
> +       add     r5,r5,r0,ror#2
> +       eor     r3,r3,r7
> +       add     r4,r4,r2
> +       eor     r2,r10,r11
> +       eor     r0,r9,r9,ror#5
> +       add     r5,r5,r3
> +       and     r2,r2,r9
> +       eor     r3,r0,r9,ror#19
> +       eor     r0,r5,r5,ror#11
> +       eor     r2,r2,r11
> +       add     r4,r4,r3,ror#6
> +       eor     r3,r5,r6
> +       eor     r0,r0,r5,ror#20
> +       add     r4,r4,r2
> +       ldr     r2,[sp,#64]
> +       and     r12,r12,r3
> +       add     r8,r8,r4
> +       add     r4,r4,r0,ror#2
> +       eor     r12,r12,r6
> +       vst1.32 {q8},[r1,:128]!
> +       ldr     r0,[r2,#0]
> +       add     r4,r4,r12                       @ h+=3DMaj(a,b,c) fro=
m the past
> +       ldr     r12,[r2,#4]
> +       ldr     r3,[r2,#8]
> +       ldr     r1,[r2,#12]
> +       add     r4,r4,r0                        @ accumulate
> +       ldr     r0,[r2,#16]
> +       add     r5,r5,r12
> +       ldr     r12,[r2,#20]
> +       add     r6,r6,r3
> +       ldr     r3,[r2,#24]
> +       add     r7,r7,r1
> +       ldr     r1,[r2,#28]
> +       add     r8,r8,r0
> +       str     r4,[r2],#4
> +       add     r9,r9,r12
> +       str     r5,[r2],#4
> +       add     r10,r10,r3
> +       str     r6,[r2],#4
> +       add     r11,r11,r1
> +       str     r7,[r2],#4
> +       stmia   r2,{r8-r11}
> +
> +       movne   r1,sp
> +       ldrne   r2,[sp,#0]
> +       eorne   r12,r12,r12
> +       ldreq   sp,[sp,#76]                     @ restore original sp
> +       eorne   r3,r5,r6
> +       bne     .L_00_48
> +
> +       ldmia   sp!,{r4-r12,pc}
> +ENDPROC(sha256_transform_neon)
> diff --git a/arch/arm/crypto/sha256_neon_glue.c b/arch/arm/crypto/sha=
256_neon_glue.c
> new file mode 100644
> index 0000000..698a498
> --- /dev/null
> +++ b/arch/arm/crypto/sha256_neon_glue.c
> @@ -0,0 +1,201 @@
> +/*
> + * Glue code for the SHA256 Secure Hash Algorithm assembly implement=
ation
> + * using NEON instructions.
> + *
> + * Copyright =C2=A9 2015 Google Inc.
> + *
> + * This file is based on sha512_neon_glue.c:
> + *   Copyright =C2=A9 2014 Jussi Kivilinna <jussi.kivilinna@iki.fi>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify it
> + * under the terms of the GNU General Public License as published by=
 the Free
> + * Software Foundation; either version 2 of the License, or (at your=
 option)
> + * any later version.
> + *
> + */
> +
> +#include <crypto/internal/hash.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/mm.h>
> +#include <linux/cryptohash.h>
> +#include <linux/types.h>
> +#include <linux/string.h>
> +#include <crypto/sha.h>
> +#include <asm/byteorder.h>
> +#include <asm/simd.h>
> +#include <asm/neon.h>
> +
> +asmlinkage void sha256_transform_neon(u32 *digest, const void *data,
> +                                     unsigned int num_blks);
> +
> +
> +static int sha256_neon_init(struct shash_desc *desc)
> +{
> +       struct sha256_state *sctx =3D shash_desc_ctx(desc);
> +
> +       sctx->state[0] =3D SHA256_H0;
> +       sctx->state[1] =3D SHA256_H1;
> +       sctx->state[2] =3D SHA256_H2;
> +       sctx->state[3] =3D SHA256_H3;
> +       sctx->state[4] =3D SHA256_H4;
> +       sctx->state[5] =3D SHA256_H5;
> +       sctx->state[6] =3D SHA256_H6;
> +       sctx->state[7] =3D SHA256_H7;
> +       sctx->count =3D 0;
> +
> +       return 0;
> +}
> +
> +static int __sha256_neon_update(struct shash_desc *desc, const u8 *d=
ata,
> +                               unsigned int len, unsigned int partia=
l)
> +{
> +       struct sha256_state *sctx =3D shash_desc_ctx(desc);
> +       unsigned int done =3D 0;
> +
> +       sctx->count +=3D len;
> +
> +       if (partial) {
> +               done =3D SHA256_BLOCK_SIZE - partial;
> +               memcpy(sctx->buf + partial, data, done);
> +               sha256_transform_neon(sctx->state, sctx->buf, 1);
> +       }
> +
> +       if (len - done >=3D SHA256_BLOCK_SIZE) {
> +               const unsigned int rounds =3D (len - done) / SHA256_B=
LOCK_SIZE;
> +
> +               sha256_transform_neon(sctx->state, data + done, round=
s);
> +               done +=3D rounds * SHA256_BLOCK_SIZE;
> +       }
> +
> +       memcpy(sctx->buf, data + done, len - done);
> +
> +       return 0;
> +}
> +
> +static int sha256_neon_update(struct shash_desc *desc, const u8 *dat=
a,
> +                            unsigned int len)
> +{
> +       struct sha256_state *sctx =3D shash_desc_ctx(desc);
> +       unsigned int partial =3D sctx->count % SHA256_BLOCK_SIZE;
> +       int res;
> +
> +       /* Handle the fast case right here */
> +       if (partial + len < SHA256_BLOCK_SIZE) {
> +               sctx->count +=3D len;
> +               memcpy(sctx->buf + partial, data, len);
> +
> +               return 0;
> +       }
> +
> +       if (!may_use_simd()) {
> +               res =3D crypto_sha256_update(desc, data, len);
> +       } else {
> +               kernel_neon_begin();
> +               res =3D __sha256_neon_update(desc, data, len, partial=
);
> +               kernel_neon_end();
> +       }
> +
> +       return res;
> +}
> +
> +/* Add padding and return the message digest. */
> +static int sha256_neon_final(struct shash_desc *desc, u8 *out)
> +{
> +       struct sha256_state *sctx =3D shash_desc_ctx(desc);
> +       unsigned int i, index, padlen;
> +       __be32 *dst =3D (__be32 *)out;
> +       __be64 bits;
> +       static const u8 padding[SHA256_BLOCK_SIZE] =3D { 0x80, };
> +
> +       /* save number of bits */
> +       bits =3D cpu_to_be64(sctx->count << 3);
> +
> +       /* Pad out to 56 mod 64 and append length */
> +       index =3D sctx->count % SHA256_BLOCK_SIZE;
> +       padlen =3D (index < 56) ? (56 - index) : ((SHA256_BLOCK_SIZE+=
56)-index);
> +
> +       if (!may_use_simd()) {
> +               crypto_sha256_update(desc, padding, padlen);
> +               crypto_sha256_update(desc, (const u8 *)&bits, sizeof(=
bits));
> +       } else {
> +               kernel_neon_begin();
> +               /* We need to fill a whole block for __sha256_neon_up=
date() */
> +               if (padlen <=3D 56) {
> +                       sctx->count +=3D padlen;
> +                       memcpy(sctx->buf + index, padding, padlen);
> +               } else {
> +                       __sha256_neon_update(desc, padding, padlen, i=
ndex);
> +               }
> +               __sha256_neon_update(desc, (const u8 *)&bits,
> +                                       sizeof(bits), 56);
> +               kernel_neon_end();
> +       }
> +
> +       /* Store state in digest */
> +       for (i =3D 0; i < 8; i++)
> +               dst[i] =3D cpu_to_be32(sctx->state[i]);
> +
> +       /* Wipe context */
> +       memset(sctx, 0, sizeof(*sctx));
> +
> +       return 0;
> +}
> +
> +static int sha256_neon_export(struct shash_desc *desc, void *out)
> +{
> +       struct sha256_state *sctx =3D shash_desc_ctx(desc);
> +
> +       memcpy(out, sctx, sizeof(*sctx));
> +
> +       return 0;
> +}
> +
> +static int sha256_neon_import(struct shash_desc *desc, const void *i=
n)
> +{
> +       struct sha256_state *sctx =3D shash_desc_ctx(desc);
> +
> +       memcpy(sctx, in, sizeof(*sctx));
> +
> +       return 0;
> +}
> +
> +static struct shash_alg alg =3D {
> +       .digestsize     =3D       SHA256_DIGEST_SIZE,
> +       .init           =3D       sha256_neon_init,
> +       .update         =3D       sha256_neon_update,
> +       .final          =3D       sha256_neon_final,
> +       .export         =3D       sha256_neon_export,
> +       .import         =3D       sha256_neon_import,
> +       .descsize       =3D       sizeof(struct sha256_state),
> +       .statesize      =3D       sizeof(struct sha256_state),
> +       .base           =3D       {
> +               .cra_name       =3D       "sha256",
> +               .cra_driver_name =3D      "sha256-neon",
> +               .cra_priority   =3D       350,
> +               .cra_flags      =3D       CRYPTO_ALG_TYPE_SHASH,
> +               .cra_blocksize  =3D       SHA256_BLOCK_SIZE,
> +               .cra_module     =3D       THIS_MODULE,
> +       }
> +};
> +

You can also implement SHA-224 using the same core transform, it's
just some trivial glue code.

> +static int __init sha256_neon_mod_init(void)
> +{
> +       if (!cpu_has_neon())
> +               return -ENODEV;
> +
> +       return crypto_register_shash(&alg);
> +}
> +
> +static void __exit sha256_neon_mod_fini(void)
> +{
> +       crypto_unregister_shash(&alg);
> +}
> +
> +module_init(sha256_neon_mod_init);
> +module_exit(sha256_neon_mod_fini);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("SHA256 Secure Hash Algorithm, NEON accelerated")=
;
> +
> +MODULE_ALIAS("sha256");
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 50f4da4..0505523 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -610,6 +610,18 @@ config CRYPTO_SHA256
>           This code also includes SHA-224, a 224 bit hash with 112 bi=
ts
>           of security against collision attacks.
>
> +config CRYPTO_SHA256_ARM_NEON
> +       tristate "SHA256 digest algorithm (ARM NEON)"
> +       depends on ARM && KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
> +       select CRYPTO_SHA256
> +       select CRYPTO_HASH
> +       help
> +         SHA-256 secure hash standard (DFIPS 180-2) implemented
> +         using ARM NEON instructions, when available.
> +
> +         This version of SHA implements a 256 bit hash with 128 bits=
 of
> +         security against collision attacks.
> +

Could you please rebase this onto Herbert's cryptodev tree and move
this to arch/arm/crypto/Kconfig?


>  config CRYPTO_SHA256_SPARC64
>         tristate "SHA224 and SHA256 digest algorithm (SPARC64)"
>         depends on SPARC64

Regards,
Ard.
