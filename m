From: James Hogan <james.hogan@imgtec.com>
Subject: Re: [PATCH 2/2] MIPS: crypto: Add crc32 and crc32c hw accelerated
 module
Date: Fri, 29 Sep 2017 22:34:51 +0100
Message-ID: <20170929213451.GB24591@jhogan-linux.le.imgtec.org>
References: <1506514716-29470-1-git-send-email-marcin.nowakowski@imgtec.com>
 <1506514716-29470-3-git-send-email-marcin.nowakowski@imgtec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="TYecfFk8j8mZq+dy"
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:52168 "EHLO
        mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752255AbdI2Vez (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Sep 2017 17:34:55 -0400
Content-Disposition: inline
In-Reply-To: <1506514716-29470-3-git-send-email-marcin.nowakowski@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

--TYecfFk8j8mZq+dy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marcin,

On Wed, Sep 27, 2017 at 02:18:36PM +0200, Marcin Nowakowski wrote:
> This module registers crc32 and crc32c algorithms that use the
> optional CRC32[bhwd] and CRC32C[bhwd] instructions in MIPSr6 cores.
>=20
> Signed-off-by: Marcin Nowakowski <marcin.nowakowski@imgtec.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
>=20
> ---
>  arch/mips/Kconfig             |   4 +
>  arch/mips/Makefile            |   3 +
>  arch/mips/crypto/Makefile     |   5 +
>  arch/mips/crypto/crc32-mips.c | 361 ++++++++++++++++++++++++++++++++++++=
++++++
>  crypto/Kconfig                |   9 ++
>  5 files changed, 382 insertions(+)
>  create mode 100644 arch/mips/crypto/Makefile
>  create mode 100644 arch/mips/crypto/crc32-mips.c
>=20
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index cb7fcc4..0f96812 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -2036,6 +2036,7 @@ config CPU_MIPSR6
>  	select CPU_HAS_RIXI
>  	select HAVE_ARCH_BITREVERSE
>  	select MIPS_ASID_BITS_VARIABLE
> +	select MIPS_CRC_SUPPORT
>  	select MIPS_SPRAM
> =20
>  config EVA
> @@ -2503,6 +2504,9 @@ config MIPS_ASID_BITS
>  config MIPS_ASID_BITS_VARIABLE
>  	bool
> =20
> +config MIPS_CRC_SUPPORT
> +	bool
> +
>  #
>  # - Highmem only makes sense for the 32-bit kernel.
>  # - The current highmem code will only work properly on physically index=
ed
> diff --git a/arch/mips/Makefile b/arch/mips/Makefile
> index a96d97a..aa77536 100644
> --- a/arch/mips/Makefile
> +++ b/arch/mips/Makefile
> @@ -216,6 +216,8 @@ cflags-$(toolchain-msa)			+=3D -DTOOLCHAIN_SUPPORTS_M=
SA
>  endif
>  toolchain-virt				:=3D $(call cc-option-yn,$(mips-cflags) -mvirt)
>  cflags-$(toolchain-virt)		+=3D -DTOOLCHAIN_SUPPORTS_VIRT
> +toolchain-crc				:=3D $(call cc-option-yn,$(mips-cflags) -Wa$(comma)-mcr=
c)
> +cflags-$(toolchain-crc)			+=3D -DTOOLCHAIN_SUPPORTS_CRC
> =20
>  #
>  # Firmware support
> @@ -324,6 +326,7 @@ libs-y			+=3D arch/mips/math-emu/
>  # See arch/mips/Kbuild for content of core part of the kernel
>  core-y +=3D arch/mips/
> =20
> +drivers-$(CONFIG_MIPS_CRC_SUPPORT) +=3D arch/mips/crypto/
>  drivers-$(CONFIG_OPROFILE)	+=3D arch/mips/oprofile/
> =20
>  # suspend and hibernation support
> diff --git a/arch/mips/crypto/Makefile b/arch/mips/crypto/Makefile
> new file mode 100644
> index 0000000..665c725
> --- /dev/null
> +++ b/arch/mips/crypto/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for MIPS crypto files..
> +#
> +
> +obj-$(CONFIG_CRYPTO_CRC32_MIPS) +=3D crc32-mips.o
> diff --git a/arch/mips/crypto/crc32-mips.c b/arch/mips/crypto/crc32-mips.c
> new file mode 100644
> index 0000000..dfa8bb1
> --- /dev/null
> +++ b/arch/mips/crypto/crc32-mips.c
> @@ -0,0 +1,361 @@
> +/*
> + * crc32-mips.c - CRC32 and CRC32C using optional MIPSr6 instructions
> + *
> + * Module based on arm64/crypto/crc32-arm.c
> + *
> + * Copyright (C) 2014 Linaro Ltd <yazen.ghannam@linaro.org>
> + * Copyright (C) 2017 Imagination Technologies, Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/unaligned/access_ok.h>
> +#include <linux/cpufeature.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/string.h>
> +
> +#include <crypto/internal/hash.h>
> +
> +enum crc_op_size {
> +	b, h, w, d,
> +};
> +
> +enum crc_type {
> +	crc32,
> +	crc32c,
> +};
> +
> +#ifdef TOOLCHAIN_SUPPORTS_CRC
> +
> +#define _CRC32(crc, value, size, type)		\
> +do {						\
> +	__asm__ __volatile__(			\
> +	".set	push\n\t"			\
> +	".set	crc\n\t"			\
> +	#type #size "	%0, %1, %0\n\t"		\
> +	".set	pop\n\t"			\

Technically the \n\t on the last line is redundant.

> +	: "+r" (crc)				\
> +	: "r" (value)				\
> +);						\
> +} while(0)
> +
> +#define CRC_REGISTER
> +
> +#else	/* TOOLCHAIN_SUPPORTS_CRC */
> +/*
> + * Crc argument is currently ignored and the assembly below assumes
> + * the crc is stored in $2. As the register number is encoded in the
> + * instruction we can't let the compiler chose the register it wants.
> + * An alternative is to change the code to do
> + * move $2, %0
> + * crc32
> + * move %0, $2
> + * but that adds unnecessary operations that the crc32 operation is
> + * designed to avoid. This issue can go away once the assembler
> + * is extended to support this operation and the compiler can make
> + * the right register choice automatically
> + */
> +
> +#define _CRC32(crc, value, size, type)						\
> +do {										\
> +	__asm__ __volatile__(							\
> +	".set	push\n\t"							\
> +	".set	noat\n\t"							\
> +	"move	$at, %1\n\t"							\
> +	"# " #type #size "	%0, $at, %0\n\t"				\
> +	_ASM_INSN_IF_MIPS(0x7c00000f | (2 << 16) | (1 << 21) | (%2 << 6) | (%3 =
<< 8))	\
> +	_ASM_INSN32_IF_MM(0x00000030 | (1 << 16) | (2 << 21) | (%2 << 14) | (%3=
 << 3))	\

You should explicitly include <asm/mipsregs.h> for these macros.

> +	".set	pop\n\t"							\
> +	: "+r" (crc)								\
> +	: "r" (value), "i" (size), "i" (type)					\
> +);										\
> +} while(0)
> +
> +#define CRC_REGISTER __asm__("$2")
> +#endif	/* !TOOLCHAIN_SUPPORTS_CRC */
> +
> +#define CRC32(crc, value, size) \
> +	_CRC32(crc, value, size, crc32)
> +
> +#define CRC32C(crc, value, size) \
> +	_CRC32(crc, value, size, crc32c)
> +
> +static u32 crc32_mips_le_hw(u32 crc_, const u8 *p, unsigned int len)
> +{
> +	s64 length =3D len;

The need for 64-bit signed length is unfortunate. Do you get decent
assembly and comparable/better performance on 32-bit if you just use len
and only decrement it in the loops? i.e.

-	while ((length -=3D sizeof(uXX)) >=3D 0) {
+	while (len >=3D sizeof(uXX)) {
		register uXX value =3D get_unaligned_leXX(p);

		CRC32(crc, value, XX);
		p +=3D sizeof(uXX);
+		len -=3D sizeof(uXX);
	}

That would be more readable too IMHO.

Just a thought.

Cheers
James


> +	register u32 crc CRC_REGISTER =3D crc_;
> +
> +#ifdef CONFIG_64BIT
> +	while ((length -=3D sizeof(u64)) >=3D 0) {
> +		register u64 value =3D get_unaligned_le64(p);
> +
> +		CRC32(crc, value, d);
> +		p +=3D sizeof(u64);
> +	}
> +
> +	if (length & sizeof(u32)) {
> +#else /* !CONFIG_64BIT */
> +	while ((length -=3D sizeof(u32)) >=3D 0) {
> +#endif
> +		register u32 value =3D get_unaligned_le32(p);
> +
> +		CRC32(crc, value, w);
> +		p +=3D sizeof(u32);
> +	}
> +
> +	if (length & sizeof(u16)) {
> +		register u16 value =3D get_unaligned_le16(p);
> +
> +		CRC32(crc, value, h);
> +		p +=3D sizeof(u16);
> +	}
> +
> +	if (length & sizeof(u8)) {
> +		register u8 value =3D *p++;
> +
> +		CRC32(crc, value, b);
> +	}
> +
> +	return crc;
> +}
> +
> +static u32 crc32c_mips_le_hw(u32 crc_, const u8 *p, unsigned int len)
> +{
> +	s64 length =3D len;
> +	register u32 crc __asm__("$2") =3D crc_;
> +
> +#ifdef CONFIG_64BIT
> +	while ((length -=3D sizeof(u64)) >=3D 0) {
> +		register u64 value =3D get_unaligned_le64(p);
> +
> +		CRC32C(crc, value, d);
> +		p +=3D sizeof(u64);
> +	}
> +
> +	if (length & sizeof(u32)) {
> +#else /* !CONFIG_64BIT */
> +	while ((length -=3D sizeof(u32)) >=3D 0) {
> +#endif
> +		register u32 value =3D get_unaligned_le32(p);
> +
> +		CRC32C(crc, value, w);
> +		p +=3D sizeof(u32);
> +	}
> +
> +	if (length & sizeof(u16)) {
> +		register u16 value =3D get_unaligned_le16(p);
> +
> +		CRC32C(crc, value, h);
> +		p +=3D sizeof(u16);
> +	}
> +
> +	if (length & sizeof(u8)) {
> +		register u8 value =3D *p++;
> +
> +		CRC32C(crc, value, b);
> +	}
> +	return crc;
> +}
> +
> +#define CHKSUM_BLOCK_SIZE	1
> +#define CHKSUM_DIGEST_SIZE	4
> +
> +struct chksum_ctx {
> +	u32 key;
> +};
> +
> +struct chksum_desc_ctx {
> +	u32 crc;
> +};
> +
> +static int chksum_init(struct shash_desc *desc)
> +{
> +	struct chksum_ctx *mctx =3D crypto_shash_ctx(desc->tfm);
> +	struct chksum_desc_ctx *ctx =3D shash_desc_ctx(desc);
> +
> +	ctx->crc =3D mctx->key;
> +
> +	return 0;
> +}
> +
> +/*
> + * Setting the seed allows arbitrary accumulators and flexible XOR policy
> + * If your algorithm starts with ~0, then XOR with ~0 before you set
> + * the seed.
> + */
> +static int chksum_setkey(struct crypto_shash *tfm, const u8 *key,
> +			 unsigned int keylen)
> +{
> +	struct chksum_ctx *mctx =3D crypto_shash_ctx(tfm);
> +
> +	if (keylen !=3D sizeof(mctx->key)) {
> +		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		return -EINVAL;
> +	}
> +	mctx->key =3D get_unaligned_le32(key);
> +	return 0;
> +}
> +
> +static int chksum_update(struct shash_desc *desc, const u8 *data,
> +			 unsigned int length)
> +{
> +	struct chksum_desc_ctx *ctx =3D shash_desc_ctx(desc);
> +
> +	ctx->crc =3D crc32_mips_le_hw(ctx->crc, data, length);
> +	return 0;
> +}
> +
> +static int chksumc_update(struct shash_desc *desc, const u8 *data,
> +			 unsigned int length)
> +{
> +	struct chksum_desc_ctx *ctx =3D shash_desc_ctx(desc);
> +
> +	ctx->crc =3D crc32c_mips_le_hw(ctx->crc, data, length);
> +	return 0;
> +}
> +
> +static int chksum_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct chksum_desc_ctx *ctx =3D shash_desc_ctx(desc);
> +
> +	put_unaligned_le32(ctx->crc, out);
> +	return 0;
> +}
> +
> +static int chksumc_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct chksum_desc_ctx *ctx =3D shash_desc_ctx(desc);
> +
> +	put_unaligned_le32(~ctx->crc, out);
> +	return 0;
> +}
> +
> +static int __chksum_finup(u32 crc, const u8 *data, unsigned int len, u8 =
*out)
> +{
> +	put_unaligned_le32(crc32_mips_le_hw(crc, data, len), out);
> +	return 0;
> +}
> +
> +static int __chksumc_finup(u32 crc, const u8 *data, unsigned int len, u8=
 *out)
> +{
> +	put_unaligned_le32(~crc32c_mips_le_hw(crc, data, len), out);
> +	return 0;
> +}
> +
> +static int chksum_finup(struct shash_desc *desc, const u8 *data,
> +			unsigned int len, u8 *out)
> +{
> +	struct chksum_desc_ctx *ctx =3D shash_desc_ctx(desc);
> +
> +	return __chksum_finup(ctx->crc, data, len, out);
> +}
> +
> +static int chksumc_finup(struct shash_desc *desc, const u8 *data,
> +			unsigned int len, u8 *out)
> +{
> +	struct chksum_desc_ctx *ctx =3D shash_desc_ctx(desc);
> +
> +	return __chksumc_finup(ctx->crc, data, len, out);
> +}
> +
> +static int chksum_digest(struct shash_desc *desc, const u8 *data,
> +			 unsigned int length, u8 *out)
> +{
> +	struct chksum_ctx *mctx =3D crypto_shash_ctx(desc->tfm);
> +
> +	return __chksum_finup(mctx->key, data, length, out);
> +}
> +
> +static int chksumc_digest(struct shash_desc *desc, const u8 *data,
> +			 unsigned int length, u8 *out)
> +{
> +	struct chksum_ctx *mctx =3D crypto_shash_ctx(desc->tfm);
> +
> +	return __chksumc_finup(mctx->key, data, length, out);
> +}
> +
> +static int chksum_cra_init(struct crypto_tfm *tfm)
> +{
> +	struct chksum_ctx *mctx =3D crypto_tfm_ctx(tfm);
> +
> +	mctx->key =3D ~0;
> +	return 0;
> +}
> +
> +static struct shash_alg crc32_alg =3D {
> +	.digestsize		=3D	CHKSUM_DIGEST_SIZE,
> +	.setkey			=3D	chksum_setkey,
> +	.init			=3D	chksum_init,
> +	.update			=3D	chksum_update,
> +	.final			=3D	chksum_final,
> +	.finup			=3D	chksum_finup,
> +	.digest			=3D	chksum_digest,
> +	.descsize		=3D	sizeof(struct chksum_desc_ctx),
> +	.base			=3D	{
> +		.cra_name		=3D	"crc32",
> +		.cra_driver_name	=3D	"crc32-mips-hw",
> +		.cra_priority		=3D	300,
> +		.cra_blocksize		=3D	CHKSUM_BLOCK_SIZE,
> +		.cra_alignmask		=3D	0,
> +		.cra_ctxsize		=3D	sizeof(struct chksum_ctx),
> +		.cra_module		=3D	THIS_MODULE,
> +		.cra_init		=3D	chksum_cra_init,
> +	}
> +};
> +
> +static struct shash_alg crc32c_alg =3D {
> +	.digestsize		=3D	CHKSUM_DIGEST_SIZE,
> +	.setkey			=3D	chksum_setkey,
> +	.init			=3D	chksum_init,
> +	.update			=3D	chksumc_update,
> +	.final			=3D	chksumc_final,
> +	.finup			=3D	chksumc_finup,
> +	.digest			=3D	chksumc_digest,
> +	.descsize		=3D	sizeof(struct chksum_desc_ctx),
> +	.base			=3D	{
> +		.cra_name		=3D	"crc32c",
> +		.cra_driver_name	=3D	"crc32c-mips-hw",
> +		.cra_priority		=3D	300,
> +		.cra_blocksize		=3D	CHKSUM_BLOCK_SIZE,
> +		.cra_alignmask		=3D	0,
> +		.cra_ctxsize		=3D	sizeof(struct chksum_ctx),
> +		.cra_module		=3D	THIS_MODULE,
> +		.cra_init		=3D	chksum_cra_init,
> +	}
> +};
> +
> +static int __init crc32_mod_init(void)
> +{
> +	int err;
> +
> +	err =3D crypto_register_shash(&crc32_alg);
> +
> +	if (err)
> +		return err;
> +
> +	err =3D crypto_register_shash(&crc32c_alg);
> +
> +	if (err) {
> +		crypto_unregister_shash(&crc32_alg);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
> +static void __exit crc32_mod_exit(void)
> +{
> +	crypto_unregister_shash(&crc32_alg);
> +	crypto_unregister_shash(&crc32c_alg);
> +}
> +
> +MODULE_AUTHOR("Marcin Nowakowski <marcin.nowakowski@imgtec.com");
> +MODULE_DESCRIPTION("CRC32 and CRC32C using optional MIPS instructions");
> +MODULE_LICENSE("GPL v2");
> +
> +module_cpu_feature_match(MIPS_CRC32, crc32_mod_init);
> +module_exit(crc32_mod_exit);
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 28b1a0d..661971a 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -494,6 +494,15 @@ config CRYPTO_CRC32_PCLMUL
>  	  which will enable any routine to use the CRC-32-IEEE 802.3 checksum
>  	  and gain better performance as compared with the table implementation.
> =20
> +config CRYPTO_CRC32_MIPS
> +	tristate "CRC32c and CRC32 CRC algorithm (MIPS)"
> +	depends on MIPS_CRC_SUPPORT
> +	select CRYPTO_HASH
> +	help
> +	  CRC32c and CRC32 CRC algorithms implemented using mips crypto
> +	  instructions, when available.
> +
> +
>  config CRYPTO_CRCT10DIF
>  	tristate "CRCT10DIF algorithm"
>  	select CRYPTO_HASH
> --=20
> 2.7.4
>=20
>=20

--TYecfFk8j8mZq+dy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEd80NauSabkiESfLYbAtpk944dnoFAlnOvHsACgkQbAtpk944
dnoPUw//UoHRvAXQml7glfFCsf0r6uIGMVmOD7DVgZjd2BMsjel4asy4rcY+IXpP
EFk2ZVXcwyLUcif/kuFFxhrjuh8ANXiaS+hTlGI9uFsCxgoJ9SSIYZxmoXQcmB1d
vHFII8AAzySXdEePkjxm01fDn9PbSHa8m8aSwA5otP5c8aWbBQkSAw6hlnm7JDgL
iDKCZQOwnNaLKjGaBW1JT2Xhj1QvPzkwBMxiP3ikH5zG/Jq8990t+1pATtwM+r7g
nHnJZtpHJ8oqcjQedu4KyCQFGRRbUwl2zAM0SGTQjNgtFW/J8TZsvlMOhL8RdWeb
jkC+xH3JCoxcAQ03LjM7eYQonQLN5cJFthQ7jZokIRS+V4Piyi26OG4sAEwZ9AVv
X+RORoie5dRNsEIj7qMnrodj0Z9s0dIbsTv2/XV3FbksXlg8dqx59qzKraB3aeE9
n5VNRROitHDZn9eAur72plO8PelqZCouARy4ULQ7eahMdk2tf84JKnjSPj4gGaMS
bhZkiHL+pJ/f+z5iC+5s9sC7Tnpl0MKnob7J61rzyghGhGX2wpawNUvfO7fyjrhH
ObptgGfkJ4AuhFBw7m/pVEMBTceKP+5I1f7IfnD++4sjsQW6p+L9jckF+6dCc9da
2kFrWZ59RdxfYwcXbgGTApKpFbopdmAWRpZDU4uUkC2zoIyj+4w=
=Y7pr
-----END PGP SIGNATURE-----

--TYecfFk8j8mZq+dy--
