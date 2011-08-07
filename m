From: Joachim Eastwood <manabian@gmail.com>
Subject: Re: [PATCH] lib/sha1: use the git implementation of SHA-1
Date: Sun, 7 Aug 2011 13:54:12 +0200
Message-ID: <CAGhQ9Vxb9F0jJ2o0ft-OOfOUMOArj_ci2gO__mxPkZJaNiA+4A@mail.gmail.com>
References: <1312595187-3265-1-git-send-email-msb@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	Ramsay Jones <ramsay@ramsay1.demon.co.uk>,
	Nicolas Pitre <nico@cam.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux@arm.linux.org.uk
To: Mandeep Singh Baines <msb@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1312595187-3265-1-git-send-email-msb@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Aug 6, 2011 at 3:46 AM, Mandeep Singh Baines <msb@chromium.org>=
 wrote:
> For ChromiumOS, we use SHA-1 to verify the integrity of the root
> filesystem. The speed of the kernel sha-1 implementation has a major
> impact on our boot performance.
>
> To improve boot performance, we investigated using the heavily
> optimized sha-1 implementation used in git. With the git
> sha-1 implementation, we see a 11.7% improvement in boot time.
>
> 10 reboots, remove slowest/fastest.
>
> Before:
>
> Mean: 6.58 seconds Stdev: 0.14
>
> After (with git sha-1, this patch):
>
> Mean: 5.89 seconds Stdev: 0.07
>
> The other cool thing about the git SHA-1 implementation is that
> it only needs 64 bytes of stack for the workspace while the original
> kernel implementation needed 320 bytes.
>
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> CC: Ramsay Jones <ramsay@ramsay1.demon.co.uk>
> CC: Nicolas Pitre <nico@cam.org>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: David S. Miller <davem@davemloft.net>
> CC: linux-crypto@vger.kernel.org
> ---
> =A0include/linux/cryptohash.h | =A0 =A02 +-
> =A0lib/sha1.c =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 | =A0212 ++++++++++++++=
++++++++++++++++++-----------
> =A02 files changed, 159 insertions(+), 55 deletions(-)
>
> diff --git a/include/linux/cryptohash.h b/include/linux/cryptohash.h
> index ec78a4b..f945218 100644
> --- a/include/linux/cryptohash.h
> +++ b/include/linux/cryptohash.h
> @@ -3,7 +3,7 @@
>
> =A0#define SHA_DIGEST_WORDS 5
> =A0#define SHA_MESSAGE_BYTES (512 /*bits*/ / 8)
> -#define SHA_WORKSPACE_WORDS 80
> +#define SHA_WORKSPACE_WORDS 16
>
> =A0void sha_init(__u32 *buf);
> =A0void sha_transform(__u32 *digest, const char *data, __u32 *W);
> diff --git a/lib/sha1.c b/lib/sha1.c
> index 4c45fd5..f33271d 100644
> --- a/lib/sha1.c
> +++ b/lib/sha1.c
> @@ -1,31 +1,72 @@
> =A0/*
> - * SHA transform algorithm, originally taken from code written by
> - * Peter Gutmann, and placed in the public domain.
> + * SHA1 routine optimized to do word accesses rather than byte acces=
ses,
> + * and to avoid unnecessary copies into the context array.
> + *
> + * This was based on the git SHA1 implementation.
> =A0*/
>
> =A0#include <linux/kernel.h>
> =A0#include <linux/module.h>
> -#include <linux/cryptohash.h>
> +#include <linux/bitops.h>
> +#include <asm/unaligned.h>
>
> -/* The SHA f()-functions. =A0*/
> +/*
> + * If you have 32 registers or more, the compiler can (and should)
> + * try to change the array[] accesses into registers. However, on
> + * machines with less than ~25 registers, that won't really work,
> + * and at least gcc will make an unholy mess of it.
> + *
> + * So to avoid that mess which just slows things down, we force
> + * the stores to memory to actually happen (we might be better off
> + * with a 'W(t)=3D(val);asm("":"+m" (W(t))' there instead, as
> + * suggested by Artur Skawina - that will also make gcc unable to
> + * try to do the silly "optimize away loads" part because it won't
> + * see what the value will be).
> + *
> + * Ben Herrenschmidt reports that on PPC, the C version comes close
> + * to the optimized asm with this (ie on PPC you don't want that
> + * 'volatile', since there are lots of registers).
> + *
> + * On ARM we get the best code generation by forcing a full memory b=
arrier
> + * between each SHA_ROUND, otherwise gcc happily get wild with spill=
ing and
> + * the stack frame size simply explode and performance goes down the=
 drain.
> + */
>
> -#define f1(x,y,z) =A0 (z ^ (x & (y ^ z))) =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0/* x ? y : z */
> -#define f2(x,y,z) =A0 (x ^ y ^ z) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0/* XOR */
> -#define f3(x,y,z) =A0 ((x & y) + (z & (x ^ y))) =A0/* majority */
> +#ifdef CONFIG_X86
> + =A0#define setW(x, val) (*(volatile __u32 *)&W(x) =3D (val))
> +#elif defined(CONFIG_ARM)
> + =A0#define setW(x, val) do { W(x) =3D (val); __asm__("":::"memory")=
; } while (0)
> +#else
> + =A0#define setW(x, val) (W(x) =3D (val))
> +#endif
>
> -/* The SHA Mysterious Constants */
> +/* This "rolls" over the 512-bit array */
> +#define W(x) (array[(x)&15])
>
> -#define K1 =A00x5A827999L =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0/* Rounds =A00-19: sqrt(2) * 2^30 */
> -#define K2 =A00x6ED9EBA1L =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0/* Rounds 20-39: sqrt(3) * 2^30 */
> -#define K3 =A00x8F1BBCDCL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0/* Rounds 40-59: sqrt(5) * 2^30 */
> -#define K4 =A00xCA62C1D6L =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0/* Rounds 60-79: sqrt(10) * 2^30 */
> +/*
> + * Where do we get the source from? The first 16 iterations get it f=
rom
> + * the input data, the next mix it from the 512-bit array.
> + */
> +#define SHA_SRC(t) get_unaligned_be32((__u32 *)data + t)
> +#define SHA_MIX(t) rol32(W(t+13) ^ W(t+8) ^ W(t+2) ^ W(t), 1)
> +
> +#define SHA_ROUND(t, input, fn, constant, A, B, C, D, E) do { \
> + =A0 =A0 =A0 __u32 TEMP =3D input(t); setW(t, TEMP); \
> + =A0 =A0 =A0 E +=3D TEMP + rol32(A,5) + (fn) + (constant); \
> + =A0 =A0 =A0 B =3D ror32(B, 2); } while (0)
> +
> +#define T_0_15(t, A, B, C, D, E) =A0SHA_ROUND(t, SHA_SRC, (((C^D)&B)=
^D) , 0x5a827999, A, B, C, D, E )
> +#define T_16_19(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (((C^D)&B)^D=
) , 0x5a827999, A, B, C, D, E )
> +#define T_20_39(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (B^C^D) , 0x=
6ed9eba1, A, B, C, D, E )
> +#define T_40_59(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, ((B&C)+(D&(B=
^C))) , 0x8f1bbcdc, A, B, C, D, E )
> +#define T_60_79(t, A, B, C, D, E) SHA_ROUND(t, SHA_MIX, (B^C^D) , =A0=
0xca62c1d6, A, B, C, D, E )
>
> =A0/**
> =A0* sha_transform - single block SHA1 transform
> =A0*
> =A0* @digest: 160 bit digest to update
> =A0* @data: =A0 512 bits of data to hash
> - * @W: =A0 =A0 =A080 words of workspace (see note)
> + * @array: =A016 words of workspace (see note)
> =A0*
> =A0* This function generates a SHA1 digest for a single 512-bit block=
=2E
> =A0* Be warned, it does not handle padding and message digest, do not
> @@ -36,47 +77,111 @@
> =A0* to clear the workspace. This is left to the caller to avoid
> =A0* unnecessary clears between chained hashing operations.
> =A0*/
> -void sha_transform(__u32 *digest, const char *in, __u32 *W)
> +void sha_transform(__u32 *digest, const char *data, __u32 *array)
> =A0{
> - =A0 =A0 =A0 __u32 a, b, c, d, e, t, i;
> -
> - =A0 =A0 =A0 for (i =3D 0; i < 16; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 W[i] =3D be32_to_cpu(((const __be32 *)i=
n)[i]);
> -
> - =A0 =A0 =A0 for (i =3D 0; i < 64; i++)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 W[i+16] =3D rol32(W[i+13] ^ W[i+8] ^ W[=
i+2] ^ W[i], 1);
> -
> - =A0 =A0 =A0 a =3D digest[0];
> - =A0 =A0 =A0 b =3D digest[1];
> - =A0 =A0 =A0 c =3D digest[2];
> - =A0 =A0 =A0 d =3D digest[3];
> - =A0 =A0 =A0 e =3D digest[4];
> -
> - =A0 =A0 =A0 for (i =3D 0; i < 20; i++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 t =3D f1(b, c, d) + K1 + rol32(a, 5) + =
e + W[i];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 e =3D d; d =3D c; c =3D rol32(b, 30); b=
 =3D a; a =3D t;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 for (; i < 40; i ++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 t =3D f2(b, c, d) + K2 + rol32(a, 5) + =
e + W[i];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 e =3D d; d =3D c; c =3D rol32(b, 30); b=
 =3D a; a =3D t;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 for (; i < 60; i ++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 t =3D f3(b, c, d) + K3 + rol32(a, 5) + =
e + W[i];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 e =3D d; d =3D c; c =3D rol32(b, 30); b=
 =3D a; a =3D t;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 for (; i < 80; i ++) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 t =3D f2(b, c, d) + K4 + rol32(a, 5) + =
e + W[i];
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 e =3D d; d =3D c; c =3D rol32(b, 30); b=
 =3D a; a =3D t;
> - =A0 =A0 =A0 }
> -
> - =A0 =A0 =A0 digest[0] +=3D a;
> - =A0 =A0 =A0 digest[1] +=3D b;
> - =A0 =A0 =A0 digest[2] +=3D c;
> - =A0 =A0 =A0 digest[3] +=3D d;
> - =A0 =A0 =A0 digest[4] +=3D e;
> + =A0 =A0 =A0 __u32 A, B, C, D, E;
> +
> + =A0 =A0 =A0 A =3D digest[0];
> + =A0 =A0 =A0 B =3D digest[1];
> + =A0 =A0 =A0 C =3D digest[2];
> + =A0 =A0 =A0 D =3D digest[3];
> + =A0 =A0 =A0 E =3D digest[4];
> +
> + =A0 =A0 =A0 /* Round 1 - iterations 0-16 take their input from 'dat=
a' */
> + =A0 =A0 =A0 T_0_15( 0, A, B, C, D, E);
> + =A0 =A0 =A0 T_0_15( 1, E, A, B, C, D);
> + =A0 =A0 =A0 T_0_15( 2, D, E, A, B, C);
> + =A0 =A0 =A0 T_0_15( 3, C, D, E, A, B);
> + =A0 =A0 =A0 T_0_15( 4, B, C, D, E, A);
> + =A0 =A0 =A0 T_0_15( 5, A, B, C, D, E);
> + =A0 =A0 =A0 T_0_15( 6, E, A, B, C, D);
> + =A0 =A0 =A0 T_0_15( 7, D, E, A, B, C);
> + =A0 =A0 =A0 T_0_15( 8, C, D, E, A, B);
> + =A0 =A0 =A0 T_0_15( 9, B, C, D, E, A);
> + =A0 =A0 =A0 T_0_15(10, A, B, C, D, E);
> + =A0 =A0 =A0 T_0_15(11, E, A, B, C, D);
> + =A0 =A0 =A0 T_0_15(12, D, E, A, B, C);
> + =A0 =A0 =A0 T_0_15(13, C, D, E, A, B);
> + =A0 =A0 =A0 T_0_15(14, B, C, D, E, A);
> + =A0 =A0 =A0 T_0_15(15, A, B, C, D, E);
> +
> + =A0 =A0 =A0 /* Round 1 - tail. Input from 512-bit mixing array */
> + =A0 =A0 =A0 T_16_19(16, E, A, B, C, D);
> + =A0 =A0 =A0 T_16_19(17, D, E, A, B, C);
> + =A0 =A0 =A0 T_16_19(18, C, D, E, A, B);
> + =A0 =A0 =A0 T_16_19(19, B, C, D, E, A);
> +
> + =A0 =A0 =A0 /* Round 2 */
> + =A0 =A0 =A0 T_20_39(20, A, B, C, D, E);
> + =A0 =A0 =A0 T_20_39(21, E, A, B, C, D);
> + =A0 =A0 =A0 T_20_39(22, D, E, A, B, C);
> + =A0 =A0 =A0 T_20_39(23, C, D, E, A, B);
> + =A0 =A0 =A0 T_20_39(24, B, C, D, E, A);
> + =A0 =A0 =A0 T_20_39(25, A, B, C, D, E);
> + =A0 =A0 =A0 T_20_39(26, E, A, B, C, D);
> + =A0 =A0 =A0 T_20_39(27, D, E, A, B, C);
> + =A0 =A0 =A0 T_20_39(28, C, D, E, A, B);
> + =A0 =A0 =A0 T_20_39(29, B, C, D, E, A);
> + =A0 =A0 =A0 T_20_39(30, A, B, C, D, E);
> + =A0 =A0 =A0 T_20_39(31, E, A, B, C, D);
> + =A0 =A0 =A0 T_20_39(32, D, E, A, B, C);
> + =A0 =A0 =A0 T_20_39(33, C, D, E, A, B);
> + =A0 =A0 =A0 T_20_39(34, B, C, D, E, A);
> + =A0 =A0 =A0 T_20_39(35, A, B, C, D, E);
> + =A0 =A0 =A0 T_20_39(36, E, A, B, C, D);
> + =A0 =A0 =A0 T_20_39(37, D, E, A, B, C);
> + =A0 =A0 =A0 T_20_39(38, C, D, E, A, B);
> + =A0 =A0 =A0 T_20_39(39, B, C, D, E, A);
> +
> + =A0 =A0 =A0 /* Round 3 */
> + =A0 =A0 =A0 T_40_59(40, A, B, C, D, E);
> + =A0 =A0 =A0 T_40_59(41, E, A, B, C, D);
> + =A0 =A0 =A0 T_40_59(42, D, E, A, B, C);
> + =A0 =A0 =A0 T_40_59(43, C, D, E, A, B);
> + =A0 =A0 =A0 T_40_59(44, B, C, D, E, A);
> + =A0 =A0 =A0 T_40_59(45, A, B, C, D, E);
> + =A0 =A0 =A0 T_40_59(46, E, A, B, C, D);
> + =A0 =A0 =A0 T_40_59(47, D, E, A, B, C);
> + =A0 =A0 =A0 T_40_59(48, C, D, E, A, B);
> + =A0 =A0 =A0 T_40_59(49, B, C, D, E, A);
> + =A0 =A0 =A0 T_40_59(50, A, B, C, D, E);
> + =A0 =A0 =A0 T_40_59(51, E, A, B, C, D);
> + =A0 =A0 =A0 T_40_59(52, D, E, A, B, C);
> + =A0 =A0 =A0 T_40_59(53, C, D, E, A, B);
> + =A0 =A0 =A0 T_40_59(54, B, C, D, E, A);
> + =A0 =A0 =A0 T_40_59(55, A, B, C, D, E);
> + =A0 =A0 =A0 T_40_59(56, E, A, B, C, D);
> + =A0 =A0 =A0 T_40_59(57, D, E, A, B, C);
> + =A0 =A0 =A0 T_40_59(58, C, D, E, A, B);
> + =A0 =A0 =A0 T_40_59(59, B, C, D, E, A);
> +
> + =A0 =A0 =A0 /* Round 4 */
> + =A0 =A0 =A0 T_60_79(60, A, B, C, D, E);
> + =A0 =A0 =A0 T_60_79(61, E, A, B, C, D);
> + =A0 =A0 =A0 T_60_79(62, D, E, A, B, C);
> + =A0 =A0 =A0 T_60_79(63, C, D, E, A, B);
> + =A0 =A0 =A0 T_60_79(64, B, C, D, E, A);
> + =A0 =A0 =A0 T_60_79(65, A, B, C, D, E);
> + =A0 =A0 =A0 T_60_79(66, E, A, B, C, D);
> + =A0 =A0 =A0 T_60_79(67, D, E, A, B, C);
> + =A0 =A0 =A0 T_60_79(68, C, D, E, A, B);
> + =A0 =A0 =A0 T_60_79(69, B, C, D, E, A);
> + =A0 =A0 =A0 T_60_79(70, A, B, C, D, E);
> + =A0 =A0 =A0 T_60_79(71, E, A, B, C, D);
> + =A0 =A0 =A0 T_60_79(72, D, E, A, B, C);
> + =A0 =A0 =A0 T_60_79(73, C, D, E, A, B);
> + =A0 =A0 =A0 T_60_79(74, B, C, D, E, A);
> + =A0 =A0 =A0 T_60_79(75, A, B, C, D, E);
> + =A0 =A0 =A0 T_60_79(76, E, A, B, C, D);
> + =A0 =A0 =A0 T_60_79(77, D, E, A, B, C);
> + =A0 =A0 =A0 T_60_79(78, C, D, E, A, B);
> + =A0 =A0 =A0 T_60_79(79, B, C, D, E, A);
> +
> + =A0 =A0 =A0 digest[0] +=3D A;
> + =A0 =A0 =A0 digest[1] +=3D B;
> + =A0 =A0 =A0 digest[2] +=3D C;
> + =A0 =A0 =A0 digest[3] +=3D D;
> + =A0 =A0 =A0 digest[4] +=3D E;
> =A0}
> =A0EXPORT_SYMBOL(sha_transform);
>
> @@ -92,4 +197,3 @@ void sha_init(__u32 *buf)
> =A0 =A0 =A0 =A0buf[3] =3D 0x10325476;
> =A0 =A0 =A0 =A0buf[4] =3D 0xc3d2e1f0;
> =A0}
> -
> --
> 1.7.3.1
>
> --

Hello Mandeep,

This patch cause a hang on my custom AT91RM9200 ARM board.
See logs below.

Linux version 3.0.0-mpa-07617-gce20efc (subcon@archspace) (gcc version
4.3.3 (GCC) ) #101 PREEMPT Sun Aug 7 15:30:13 CEST 2011
CPU: ARM920T [41129200] revision 0 (ARMv4T), cr=3Dc0007177
CPU: VIVT data cache, VIVT instruction cache
Machine: Phontech MPA 1600
Memory policy: ECC disabled, Data cache writeback
AT91: Detected soc type: at91rm9200
AT91: Detected soc subtype: Unknown
AT91: sram at 0x200000 of 0x4000 mapped at 0xfef74000
Clocks: CPU 179 MHz, master 59 MHz, main 18.432 MHz
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16=
256
Kernel command line: mem=3D64M console=3DttyAT0,115200 root=3D/dev/nfs
nfsroot=3D172.16.10.1:/array/devel/mpa_fs,v3
ip=3D172.16.10.100:::255.255.255.0::eth0:off
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 64MB =3D 64MB total
Memory: 62096k/62096k available, 3440k reserved, 0K highmem
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
    vmalloc : 0xc4800000 - 0xfee00000   ( 934 MB)
    lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .text : 0xc0008000 - 0xc027f000   (2524 kB)
      .init : 0xc027f000 - 0xc029a000   ( 108 kB)
      .data : 0xc029a000 - 0xc02b46a0   ( 106 kB)
       .bss : 0xc02b46c4 - 0xc02c4470   (  64 kB)
SLUB: Genslabs=3D13, HWalign=3D32, Order=3D0-3, MinObjects=3D0, CPUs=3D=
1, Nodes=3D1
NR_IRQS:192
AT91: 128 gpio irqs in 4 banks
console [ttyAT0] enabled
Calibrating delay loop... 78.64 BogoMIPS (lpj=3D393216)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
SCSI subsystem initialized
i2c-gpio i2c-gpio: using pins 57 (SDA) and 58 (SCL)
Switching to clocksource 32k_counter
NET: Registered protocol family 2

And here its stuck.

A good boot should looks like this;
Linux version 3.0.0-mpa-07617-gce20efc-dirty (subcon@archspace) (gcc
version 4.3.3 (GCC) ) #100 PREEMPT Sun Aug 7 15:16:59 CEST 2011
CPU: ARM920T [41129200] revision 0 (ARMv4T), cr=3Dc0007177
CPU: VIVT data cache, VIVT instruction cache
Machine: Phontech MPA 1600
Memory policy: ECC disabled, Data cache writeback
AT91: Detected soc type: at91rm9200
AT91: Detected soc subtype: Unknown
AT91: sram at 0x200000 of 0x4000 mapped at 0xfef74000
On node 0 totalpages: 16384
free_area_init_node: node 0, pgdat c02b3ee8, node_mem_map c02c5000
  Normal zone: 128 pages used for memmap
  Normal zone: 0 pages reserved
  Normal zone: 16256 pages, LIFO batch:3
Clocks: CPU 179 MHz, master 59 MHz, main 18.432 MHz
pcpu-alloc: s0 r0 d32768 u32768 alloc=3D1*32768
pcpu-alloc: [0] 0
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 16=
256
Kernel command line: mem=3D64M console=3DttyAT0,115200 root=3D/dev/nfs
nfsroot=3D172.16.10.1:/array/devel/mpa_fs,v3
ip=3D172.16.10.100:::255.255.255.0::eth0:off
PID hash table entries: 256 (order: -2, 1024 bytes)
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 64MB =3D 64MB total
Memory: 62096k/62096k available, 3440k reserved, 0K highmem
Virtual kernel memory layout:
    vector  : 0xffff0000 - 0xffff1000   (   4 kB)
    fixmap  : 0xfff00000 - 0xfffe0000   ( 896 kB)
    DMA     : 0xffc00000 - 0xffe00000   (   2 MB)
    vmalloc : 0xc4800000 - 0xfee00000   ( 934 MB)
    lowmem  : 0xc0000000 - 0xc4000000   (  64 MB)
    modules : 0xbf000000 - 0xc0000000   (  16 MB)
      .text : 0xc0008000 - 0xc027f000   (2524 kB)
      .init : 0xc027f000 - 0xc029a000   ( 108 kB)
      .data : 0xc029a000 - 0xc02b46a0   ( 106 kB)
       .bss : 0xc02b46c4 - 0xc02c4470   (  64 kB)
SLUB: Genslabs=3D13, HWalign=3D32, Order=3D0-3, MinObjects=3D0, CPUs=3D=
1, Nodes=3D1
NR_IRQS:192
AT91: 128 gpio irqs in 4 banks
console [ttyAT0] enabled
Calibrating delay loop... 78.23 BogoMIPS (lpj=3D391168)
pid_max: default: 32768 minimum: 301
Mount-cache hash table entries: 512
CPU: Testing write buffer coherency: ok
NET: Registered protocol family 16
bio: create slab <bio-0> at 0
SCSI subsystem initialized
i2c-gpio i2c-gpio: using pins 57 (SDA) and 58 (SCL)
Switching to clocksource 32k_counter
NET: Registered protocol family 2
IP route cache hash table entries: 1024 (order: 0, 4096 bytes)
TCP established hash table entries: 2048 (order: 2, 16384 bytes)
TCP bind hash table entries: 2048 (order: 1, 8192 bytes)
TCP: Hash tables configured (established 2048 bind 2048)
TCP reno registered
UDP hash table entries: 256 (order: 0, 4096 bytes)
UDP-Lite hash table entries: 256 (order: 0, 4096 bytes)
NET: Registered protocol family 1
RPC: Registered named UNIX socket transport module.
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
=2E..

Reverting this patch makes my board boot normal again.

I see some ARM asm in your patch, maybe this is the cause?
My ARM core is a ARM920T.

And btw, I am NFS booting this board.

regards
Joachim Eastwood
