From: James Hogan <jhogan@kernel.org>
Subject: Re: [PATCH v3 2/3] MIPS: crypto: Add crc32 and crc32c hw accelerated
 module
Date: Wed, 14 Feb 2018 14:22:46 +0000
Message-ID: <20180214142245.GA3986@saruman>
References: <cover.a1aaa0593f5afd4b00e8131611adda3a02c060d1.1518214143.git-series.jhogan@kernel.org>
 <77eab2cb46e52be3639610a7ad574bac7bf78d73.1518214143.git-series.jhogan@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Cc: Marcin Nowakowski <marcin.nowakowski@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030363AbeBNOWv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Feb 2018 09:22:51 -0500
Content-Disposition: inline
In-Reply-To: <77eab2cb46e52be3639610a7ad574bac7bf78d73.1518214143.git-series.jhogan@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi crypto folk,

On Fri, Feb 09, 2018 at 10:11:06PM +0000, James Hogan wrote:
> From: Marcin Nowakowski <marcin.nowakowski@mips.com>
>=20
> This module registers crc32 and crc32c algorithms that use the
> optional CRC32[bhwd] and CRC32C[bhwd] instructions in MIPSr6 cores.
>=20
> Signed-off-by: Marcin Nowakowski <marcin.nowakowski@mips.com>
> Signed-off-by: James Hogan <jhogan@kernel.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-mips@linux-mips.org
> Cc: linux-crypto@vger.kernel.org

I don't think any version of this patch has had any feedback from the
crypto side. Can some review or an ack be expected?

Thanks
James

> ---
> Changes in v3:
>  - Convert to using assembler macros to support CRC instructions on
>    older toolchains, using the helpers merged for 4.16. This removes the
>    need to hardcode either rt or rs (i.e. as $v0 (CRC_REGISTER) and
>    $at), and drops the C "register" keywords sprinkled everywhere.
>  - Minor whitespace rearrangement of _CRC32 macro.
>  - Add SPDX-License-Identifier to crc32-mips.c and the crypo Makefile.
>  - Update copyright from ImgTec to MIPS Tech, LLC.
>  - Update imgtec.com email addresses to mips.com.
>=20
> Changes in v2:
>  - minor code refactoring as suggested by JamesH which produces
>    a better assembly output for 32-bit builds
> ---
>  arch/mips/Kconfig             |   4 +-
>  arch/mips/Makefile            |   3 +-
>  arch/mips/crypto/Makefile     |   6 +-
>  arch/mips/crypto/crc32-mips.c | 346 +++++++++++++++++++++++++++++++++++-
>  crypto/Kconfig                |   9 +-
>  5 files changed, 368 insertions(+)
>  create mode 100644 arch/mips/crypto/Makefile
>  create mode 100644 arch/mips/crypto/crc32-mips.c
>=20
> diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
> index ac0f5bb10f0b..cccd17c07bfc 100644
> --- a/arch/mips/Kconfig
> +++ b/arch/mips/Kconfig
> @@ -2023,6 +2023,7 @@ config CPU_MIPSR6
>  	select CPU_HAS_RIXI
>  	select HAVE_ARCH_BITREVERSE
>  	select MIPS_ASID_BITS_VARIABLE
> +	select MIPS_CRC_SUPPORT
>  	select MIPS_SPRAM
> =20
>  config EVA
> @@ -2490,6 +2491,9 @@ config MIPS_ASID_BITS
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
> index d1ca839c3981..44a6ed53d018 100644
> --- a/arch/mips/Makefile
> +++ b/arch/mips/Makefile
> @@ -222,6 +222,8 @@ xpa-cflags-y				:=3D $(mips-cflags)
>  xpa-cflags-$(micromips-ase)		+=3D -mmicromips -Wa$(comma)-fatal-warnings
>  toolchain-xpa				:=3D $(call cc-option-yn,$(xpa-cflags-y) -mxpa)
>  cflags-$(toolchain-xpa)			+=3D -DTOOLCHAIN_SUPPORTS_XPA
> +toolchain-crc				:=3D $(call cc-option-yn,$(mips-cflags) -Wa$(comma)-mcr=
c)
> +cflags-$(toolchain-crc)			+=3D -DTOOLCHAIN_SUPPORTS_CRC
> =20
>  #
>  # Firmware support
> @@ -330,6 +332,7 @@ libs-y			+=3D arch/mips/math-emu/
>  # See arch/mips/Kbuild for content of core part of the kernel
>  core-y +=3D arch/mips/
> =20
> +drivers-$(CONFIG_MIPS_CRC_SUPPORT) +=3D arch/mips/crypto/
>  drivers-$(CONFIG_OPROFILE)	+=3D arch/mips/oprofile/
> =20
>  # suspend and hibernation support
> diff --git a/arch/mips/crypto/Makefile b/arch/mips/crypto/Makefile
> new file mode 100644
> index 000000000000..e07aca572c2e
> --- /dev/null
> +++ b/arch/mips/crypto/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Makefile for MIPS crypto files..
> +#
> +
> +obj-$(CONFIG_CRYPTO_CRC32_MIPS) +=3D crc32-mips.o
> diff --git a/arch/mips/crypto/crc32-mips.c b/arch/mips/crypto/crc32-mips.c
> new file mode 100644
> index 000000000000..8d4122f37fa5
> --- /dev/null
> +++ b/arch/mips/crypto/crc32-mips.c
> @@ -0,0 +1,346 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * crc32-mips.c - CRC32 and CRC32C using optional MIPSr6 instructions
> + *
> + * Module based on arm64/crypto/crc32-arm.c
> + *
> + * Copyright (C) 2014 Linaro Ltd <yazen.ghannam@linaro.org>
> + * Copyright (C) 2018 MIPS Tech, LLC
> + */
> +
> +#include <linux/unaligned/access_ok.h>
> +#include <linux/cpufeature.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/string.h>
> +#include <asm/mipsregs.h>
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
> +#ifndef TOOLCHAIN_SUPPORTS_CRC
> +#define _ASM_MACRO_CRC32(OP, SZ, TYPE)					  \
> +_ASM_MACRO_3R(OP, rt, rs, rt2,						  \
> +	".ifnc	\\rt, \\rt2\n\t"					  \
> +	".error	\"invalid operands \\\"" #OP " \\rt,\\rs,\\rt2\\\"\"\n\t" \
> +	".endif\n\t"							  \
> +	_ASM_INSN_IF_MIPS(0x7c00000f | (__rt << 16) | (__rs << 21) |	  \
> +			  ((SZ) <<  6) | ((TYPE) << 8))			  \
> +	_ASM_INSN32_IF_MM(0x00000030 | (__rs << 16) | (__rt << 21) |	  \
> +			  ((SZ) << 14) | ((TYPE) << 3)))
> +_ASM_MACRO_CRC32(crc32b,  0, 0);
> +_ASM_MACRO_CRC32(crc32h,  1, 0);
> +_ASM_MACRO_CRC32(crc32w,  2, 0);
> +_ASM_MACRO_CRC32(crc32d,  3, 0);
> +_ASM_MACRO_CRC32(crc32cb, 0, 1);
> +_ASM_MACRO_CRC32(crc32ch, 1, 1);
> +_ASM_MACRO_CRC32(crc32cw, 2, 1);
> +_ASM_MACRO_CRC32(crc32cd, 3, 1);
> +#define _ASM_SET_CRC ""
> +#else /* !TOOLCHAIN_SUPPORTS_CRC */
> +#define _ASM_SET_CRC ".set\tcrc\n\t"
> +#endif
> +
> +#define _CRC32(crc, value, size, type)		\
> +do {						\
> +	__asm__ __volatile__(			\
> +		".set	push\n\t"		\
> +		_ASM_SET_CRC			\
> +		#type #size "	%0, %1, %0\n\t"	\
> +		".set	pop"			\
> +		: "+r" (crc)			\
> +		: "r" (value));			\
> +} while (0)
> +
> +#define CRC32(crc, value, size) \
> +	_CRC32(crc, value, size, crc32)
> +
> +#define CRC32C(crc, value, size) \
> +	_CRC32(crc, value, size, crc32c)
> +
> +static u32 crc32_mips_le_hw(u32 crc_, const u8 *p, unsigned int len)
> +{
> +	u32 crc =3D crc_;
> +
> +#ifdef CONFIG_64BIT
> +	while (len >=3D sizeof(u64)) {
> +		u64 value =3D get_unaligned_le64(p);
> +
> +		CRC32(crc, value, d);
> +		p +=3D sizeof(u64);
> +		len -=3D sizeof(u64);
> +	}
> +
> +	if (len & sizeof(u32)) {
> +#else /* !CONFIG_64BIT */
> +	while (len >=3D sizeof(u32)) {
> +#endif
> +		u32 value =3D get_unaligned_le32(p);
> +
> +		CRC32(crc, value, w);
> +		p +=3D sizeof(u32);
> +		len -=3D sizeof(u32);
> +	}
> +
> +	if (len & sizeof(u16)) {
> +		u16 value =3D get_unaligned_le16(p);
> +
> +		CRC32(crc, value, h);
> +		p +=3D sizeof(u16);
> +	}
> +
> +	if (len & sizeof(u8)) {
> +		u8 value =3D *p++;
> +
> +		CRC32(crc, value, b);
> +	}
> +
> +	return crc;
> +}
> +
> +static u32 crc32c_mips_le_hw(u32 crc_, const u8 *p, unsigned int len)
> +{
> +	u32 crc =3D crc_;
> +
> +#ifdef CONFIG_64BIT
> +	while (len >=3D sizeof(u64)) {
> +		u64 value =3D get_unaligned_le64(p);
> +
> +		CRC32C(crc, value, d);
> +		p +=3D sizeof(u64);
> +		len -=3D sizeof(u64);
> +	}
> +
> +	if (len & sizeof(u32)) {
> +#else /* !CONFIG_64BIT */
> +	while (len >=3D sizeof(u32)) {
> +#endif
> +		u32 value =3D get_unaligned_le32(p);
> +
> +		CRC32C(crc, value, w);
> +		p +=3D sizeof(u32);
> +		len -=3D sizeof(u32);
> +	}
> +
> +	if (len & sizeof(u16)) {
> +		u16 value =3D get_unaligned_le16(p);
> +
> +		CRC32C(crc, value, h);
> +		p +=3D sizeof(u16);
> +	}
> +
> +	if (len & sizeof(u8)) {
> +		u8 value =3D *p++;
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
> +MODULE_AUTHOR("Marcin Nowakowski <marcin.nowakowski@mips.com");
> +MODULE_DESCRIPTION("CRC32 and CRC32C using optional MIPS instructions");
> +MODULE_LICENSE("GPL v2");
> +
> +module_cpu_feature_match(MIPS_CRC32, crc32_mod_init);
> +module_exit(crc32_mod_exit);
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index f7911963bb79..52717a03068e 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -495,6 +495,15 @@ config CRYPTO_CRC32_PCLMUL
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
> git-series 0.9.1

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEd80NauSabkiESfLYbAtpk944dnoFAlqERi4ACgkQbAtpk944
dnorcw//X9OfkVl5ajuETde9gFd/gIFONq0Y1Ateh8H43+1EImAknVCDtTPAU2wE
WYjM+3DpeXWI/iWXfsrLs6uxU7VvWsaaPAYdx6SpZySU8ZTy90V41RmiDidC4iLG
INt3gWw6pJG2ovoD1qY+nhdGk9lysTjYPpfgHciQk4jfAJsJTZok+NfdJoKmg/5u
GFrkRGPAm7lksug5mOae5u92RHSEOf7erbNgpPY+lUA/PlZoR8UpeOBx2k6H2x8h
lAX/kT3txCfubMUmZO3hjxXVX1amwWcO8ICUOsrHisEtEe1ux8vwByxjAcrHUmf7
sBvxPDIhQHybQdyHKED4Czq7GKXLrmkVRr+TZEPRUvsP2HH594QiPsU3VvB9H/ES
7Dpe7T1VqEMlbW43WZK4tWwK/SaZtQdWr45hjBvCPGXSIUsiAOFy/DYUBFbgP1Vy
by/M7pWpvkwDwT3tGxxpqe1SQSRYQ7gmxM2jNtaoM5ssKuYKZfq6qXHHW2E3v2jp
ZUrvbJPOz4i2UJReuliKewAM6jkPDn4lx56SpVtA86bSHfvOSmQq6+sMBX7c4sA9
ZcIT17j35dW1ySoWU0eM/g8JjXIQ/2IFQNi4vN2c2BALNRzaAQSeSSk/QvIovuE7
RpSjIlH7VDYK7A1s5JGWYLG9u9mh43dHHZMo7dmDVl6nc0Y9d18=
=xnv5
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
