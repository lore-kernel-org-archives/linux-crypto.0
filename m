From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/2] Crypto: Add SHA-3 hash algorithm
Date: Wed, 15 Jun 2016 13:42:50 +0200
Message-ID: <8163378.RZGaC46RvE@tauon.atsec.com>
References: <1465983719-8313-1-git-send-email-raveendra.padasalagi@broadcom.com> <1465983719-8313-2-git-send-email-raveendra.padasalagi@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jon Mason <jonmason@broadcom.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Anup Patel <anup.patel@broadcom.com>,
	Ray Jui <rjui@broadcom.com>,
	Scott Branden <sbranden@broadcom.com>,
	Pramod Kumar <pramod.kumar@broadcom.com>,
	bcm-kernel-feedback-list@broadcom.com,
	Jeff Garzik <jeff@garzik.org>, Jeff Garzik <jgarzik@redhat.com>
To: Raveendra Padasalagi <raveendra.padasalagi@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465983719-8313-2-git-send-email-raveendra.padasalagi@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 15. Juni 2016, 15:11:58 schrieb Raveendra Padasalagi:

Hi Raveendra,

> From: Jeff Garzik <jeff@garzik.org>
>=20
> This patch adds the implementation of SHA3 algorithm
> in software and it's based on original implementation
> pushed in patch https://lwn.net/Articles/518415/ with
> additional changes to match the padding rules specified
> in SHA-3 specification.
>=20
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> Signed-off-by: Raveendra Padasalagi <raveendra.padasalagi@broadcom.co=
m>
> ---
>  crypto/Kconfig        |  10 ++
>  crypto/Makefile       |   1 +
>  crypto/sha3_generic.c | 296
> ++++++++++++++++++++++++++++++++++++++++++++++++++ include/crypto/sha=
3.h |=20
> 29 +++++
>  4 files changed, 336 insertions(+)
>  create mode 100644 crypto/sha3_generic.c
>  create mode 100644 include/crypto/sha3.h
>=20
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 1d33beb..83ee8cb 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -750,6 +750,16 @@ config CRYPTO_SHA512_SPARC64
>  	  SHA-512 secure hash standard (DFIPS 180-2) implemented
>  	  using sparc64 crypto instructions, when available.
>=20
> +config CRYPTO_SHA3
> +	tristate "SHA3 digest algorithm"
> +	select CRYPTO_HASH
> +	help
> +	  SHA-3 secure hash standard (DFIPS 202). It's based on

Typo DFIPS?

> +	  cryptographic sponge function family called Keccak.
> +
> +	  References:
> +	  http://keccak.noekeon.org/
> +
>  config CRYPTO_TGR192
>  	tristate "Tiger digest algorithms"
>  	select CRYPTO_HASH
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 4f4ef7e..0b82c47 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -61,6 +61,7 @@ obj-$(CONFIG_CRYPTO_RMD320) +=3D rmd320.o
>  obj-$(CONFIG_CRYPTO_SHA1) +=3D sha1_generic.o
>  obj-$(CONFIG_CRYPTO_SHA256) +=3D sha256_generic.o
>  obj-$(CONFIG_CRYPTO_SHA512) +=3D sha512_generic.o
> +obj-$(CONFIG_CRYPTO_SHA3) +=3D sha3_generic.o
>  obj-$(CONFIG_CRYPTO_WP512) +=3D wp512.o
>  obj-$(CONFIG_CRYPTO_TGR192) +=3D tgr192.o
>  obj-$(CONFIG_CRYPTO_GF128MUL) +=3D gf128mul.o
> diff --git a/crypto/sha3_generic.c b/crypto/sha3_generic.c
> new file mode 100644
> index 0000000..162dfc3
> --- /dev/null
> +++ b/crypto/sha3_generic.c
> @@ -0,0 +1,296 @@
> +/*
> + * Cryptographic API.
> + *
> + * SHA-3, as specified in
> + * http://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf
> + *
> + * SHA-3 code by Jeff Garzik <jeff@garzik.org>
> + *
> + * This program is free software; you can redistribute it and/or mod=
ify it
> + * under the terms of the GNU General Public License as published by=
 the
> Free + * Software Foundation; either version 2 of the License, or (at=
 your
> option)=E2=80=A2 + * any later version.
> + *
> + */
> +#include <crypto/internal/hash.h>
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <crypto/sha3.h>
> +#include <asm/byteorder.h>
> +
> +#define KECCAK_ROUNDS 24
> +
> +#define ROTL64(x, y) (((x) << (y)) | ((x) >> (64 - (y))))
> +
> +static const u64 keccakf_rndc[24] =3D {
> +	0x0000000000000001, 0x0000000000008082, 0x800000000000808a,
> +	0x8000000080008000, 0x000000000000808b, 0x0000000080000001,
> +	0x8000000080008081, 0x8000000000008009, 0x000000000000008a,
> +	0x0000000000000088, 0x0000000080008009, 0x000000008000000a,
> +	0x000000008000808b, 0x800000000000008b, 0x8000000000008089,
> +	0x8000000000008003, 0x8000000000008002, 0x8000000000000080,
> +	0x000000000000800a, 0x800000008000000a, 0x8000000080008081,
> +	0x8000000000008080, 0x0000000080000001, 0x8000000080008008
> +};
> +
> +static const int keccakf_rotc[24] =3D {
> +	1,  3,  6,  10, 15, 21, 28, 36, 45, 55, 2,  14,
> +	27, 41, 56, 8,  25, 43, 62, 18, 39, 61, 20, 44
> +};
> +
> +static const int keccakf_piln[24] =3D {
> +	10, 7,  11, 17, 18, 3, 5,  16, 8,  21, 24, 4,
> +	15, 23, 19, 13, 12, 2, 20, 14, 22, 9,  6,  1
> +};
> +
> +/* update the state with given number of rounds */
> +
> +static void keccakf(u64 st[25])
> +{
> +	int i, j, round;
> +	u64 t, bc[5];
> +
> +	for (round =3D 0; round < KECCAK_ROUNDS; round++) {
> +
> +		/* Theta */
> +		for (i =3D 0; i < 5; i++)
> +			bc[i] =3D st[i] ^ st[i + 5] ^ st[i + 10] ^ st[i + 15]
> +				^ st[i + 20];
> +
> +		for (i =3D 0; i < 5; i++) {
> +			t =3D bc[(i + 4) % 5] ^ ROTL64(bc[(i + 1) % 5], 1);
> +			for (j =3D 0; j < 25; j +=3D 5)
> +				st[j + i] ^=3D t;
> +		}
> +
> +		/* Rho Pi */
> +		t =3D st[1];
> +		for (i =3D 0; i < 24; i++) {
> +			j =3D keccakf_piln[i];
> +			bc[0] =3D st[j];
> +			st[j] =3D ROTL64(t, keccakf_rotc[i]);
> +			t =3D bc[0];
> +		}
> +
> +		/* Chi */
> +		for (j =3D 0; j < 25; j +=3D 5) {
> +			for (i =3D 0; i < 5; i++)
> +				bc[i] =3D st[j + i];
> +			for (i =3D 0; i < 5; i++)
> +				st[j + i] ^=3D (~bc[(i + 1) % 5]) &
> +					     bc[(i + 2) % 5];
> +		}
> +
> +		/* Iota */
> +		st[0] ^=3D keccakf_rndc[round];
> +	}
> +}
> +
> +static void sha3_init(struct sha3_state *sctx, unsigned int digest_s=
z)
> +{
> +	memset(sctx, 0, sizeof(*sctx));
> +	sctx->md_len =3D digest_sz;
> +	sctx->rsiz =3D 200 - 2 * digest_sz;
> +	sctx->rsizw =3D sctx->rsiz / 8;
> +}
> +
> +static int sha3_224_init(struct shash_desc *desc)
> +{
> +	struct sha3_state *sctx =3D shash_desc_ctx(desc);
> +
> +	sha3_init(sctx, SHA3_224_DIGEST_SIZE);
> +	return 0;
> +}
> +
> +static int sha3_256_init(struct shash_desc *desc)
> +{
> +	struct sha3_state *sctx =3D shash_desc_ctx(desc);
> +
> +	sha3_init(sctx, SHA3_256_DIGEST_SIZE);
> +	return 0;
> +}
> +
> +static int sha3_384_init(struct shash_desc *desc)
> +{
> +	struct sha3_state *sctx =3D shash_desc_ctx(desc);
> +
> +	sha3_init(sctx, SHA3_384_DIGEST_SIZE);
> +	return 0;
> +}
> +
> +static int sha3_512_init(struct shash_desc *desc)
> +{
> +	struct sha3_state *sctx =3D shash_desc_ctx(desc);
> +
> +	sha3_init(sctx, SHA3_512_DIGEST_SIZE);
> +	return 0;
> +}
> +
> +static int sha3_update(struct shash_desc *desc, const u8 *data,
> +		       unsigned int len)
> +{
> +	struct sha3_state *sctx =3D shash_desc_ctx(desc);
> +	unsigned int done;
> +	const u8 *src;
> +
> +	done =3D 0;
> +	src =3D data;
> +
> +	if ((sctx->partial + len) > (sctx->rsiz - 1)) {
> +		if (sctx->partial) {
> +			done =3D -sctx->partial;
> +			memcpy(sctx->buf + sctx->partial, data,
> +			       done + sctx->rsiz);
> +			src =3D sctx->buf;
> +		}
> +
> +		do {
> +			unsigned int i;
> +
> +			for (i =3D 0; i < sctx->rsizw; i++)
> +				sctx->st[i] ^=3D ((u64 *) src)[i];
> +			keccakf(sctx->st);
> +
> +			done +=3D sctx->rsiz;
> +			src =3D data + done;
> +		} while (done + (sctx->rsiz - 1) < len);
> +
> +		sctx->partial =3D 0;
> +	}
> +	memcpy(sctx->buf + sctx->partial, src, len - done);
> +	sctx->partial +=3D (len - done);
> +
> +	return 0;
> +}
> +
> +static int sha3_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct sha3_state *sctx =3D shash_desc_ctx(desc);
> +	unsigned int i, inlen =3D sctx->partial;
> +
> +	sctx->buf[inlen++] =3D 0x06;
> +	memset(sctx->buf + inlen, 0, sctx->rsiz - inlen);
> +	sctx->buf[sctx->rsiz - 1] |=3D 0x80;
> +
> +	for (i =3D 0; i < sctx->rsizw; i++)
> +		sctx->st[i] ^=3D ((u64 *) sctx->buf)[i];
> +
> +	keccakf(sctx->st);
> +
> +	for (i =3D 0; i < sctx->rsizw; i++)
> +		sctx->st[i] =3D cpu_to_le64(sctx->st[i]);
> +
> +	memcpy(out, sctx->st, sctx->md_len);
> +
> +	memset(sctx, 0, sizeof(*sctx));
> +	return 0;
> +}
> +
> +static struct shash_alg sha3_224 =3D {
> +	.digestsize	=3D	SHA3_224_DIGEST_SIZE,
> +	.init		=3D	sha3_224_init,
> +	.update		=3D	sha3_update,
> +	.final		=3D	sha3_final,
> +	.descsize	=3D	sizeof(struct sha3_state),
> +	.base		=3D	{
> +		.cra_name	=3D	"sha3-224",
> +		.cra_driver_name =3D	"sha3-224-generic",
> +		.cra_flags	=3D	CRYPTO_ALG_TYPE_SHASH,
> +		.cra_blocksize	=3D	SHA3_224_BLOCK_SIZE,
> +		.cra_module	=3D	THIS_MODULE,
> +	}
> +};
> +
> +static struct shash_alg sha3_256 =3D {
> +	.digestsize	=3D	SHA3_256_DIGEST_SIZE,
> +	.init		=3D	sha3_256_init,
> +	.update		=3D	sha3_update,
> +	.final		=3D	sha3_final,
> +	.descsize	=3D	sizeof(struct sha3_state),
> +	.base		=3D	{
> +		.cra_name	=3D	"sha3-256",
> +		.cra_driver_name =3D	"sha3-256-generic",
> +		.cra_flags	=3D	CRYPTO_ALG_TYPE_SHASH,
> +		.cra_blocksize	=3D	SHA3_256_BLOCK_SIZE,
> +		.cra_module	=3D	THIS_MODULE,
> +	}
> +};
> +
> +static struct shash_alg sha3_384 =3D {
> +	.digestsize	=3D	SHA3_384_DIGEST_SIZE,
> +	.init		=3D	sha3_384_init,
> +	.update		=3D	sha3_update,
> +	.final		=3D	sha3_final,
> +	.descsize	=3D	sizeof(struct sha3_state),
> +	.base		=3D	{
> +		.cra_name	=3D	"sha3-384",
> +		.cra_driver_name =3D	"sha3-384-generic",
> +		.cra_flags	=3D	CRYPTO_ALG_TYPE_SHASH,
> +		.cra_blocksize	=3D	SHA3_384_BLOCK_SIZE,
> +		.cra_module	=3D	THIS_MODULE,
> +	}
> +};
> +
> +static struct shash_alg sha3_512 =3D {
> +	.digestsize	=3D	SHA3_512_DIGEST_SIZE,
> +	.init		=3D	sha3_512_init,
> +	.update		=3D	sha3_update,
> +	.final		=3D	sha3_final,
> +	.descsize	=3D	sizeof(struct sha3_state),
> +	.base		=3D	{
> +		.cra_name	=3D	"sha3-512",
> +		.cra_driver_name =3D	"sha3-512-generic",
> +		.cra_flags	=3D	CRYPTO_ALG_TYPE_SHASH,
> +		.cra_blocksize	=3D	SHA3_512_BLOCK_SIZE,
> +		.cra_module	=3D	THIS_MODULE,
> +	}
> +};

Shouldn't there be a priority here?
> +
> +static int __init sha3_generic_mod_init(void)
> +{
> +	int ret;
> +
> +	ret =3D crypto_register_shash(&sha3_224);
> +	if (ret < 0)
> +		goto err_out;
> +	ret =3D crypto_register_shash(&sha3_256);
> +	if (ret < 0)
> +		goto err_out_224;
> +	ret =3D crypto_register_shash(&sha3_384);
> +	if (ret < 0)
> +		goto err_out_256;
> +	ret =3D crypto_register_shash(&sha3_512);
> +	if (ret < 0)
> +		goto err_out_384;
> +
> +	return 0;
> +
> +err_out_384:
> +	crypto_unregister_shash(&sha3_384);
> +err_out_256:
> +	crypto_unregister_shash(&sha3_256);
> +err_out_224:
> +	crypto_unregister_shash(&sha3_224);
> +err_out:
> +	return ret;
> +}
> +
> +static void __exit sha3_generic_mod_fini(void)
> +{
> +	crypto_unregister_shash(&sha3_224);
> +	crypto_unregister_shash(&sha3_256);
> +	crypto_unregister_shash(&sha3_384);
> +	crypto_unregister_shash(&sha3_512);
> +}
> +
> +module_init(sha3_generic_mod_init);
> +module_exit(sha3_generic_mod_fini);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("SHA-3 Secure Hash Algorithm");
> +
> +MODULE_ALIAS("sha3-224");
> +MODULE_ALIAS("sha3-256");
> +MODULE_ALIAS("sha3-384");
> +MODULE_ALIAS("sha3-512");

MODULE_ALIAS_CRYPTO?

What about the aliases for cra_driver_name?

> diff --git a/include/crypto/sha3.h b/include/crypto/sha3.h
> new file mode 100644
> index 0000000..f4c9f68
> --- /dev/null
> +++ b/include/crypto/sha3.h
> @@ -0,0 +1,29 @@
> +/*
> + * Common values for SHA-3 algorithms
> + */
> +#ifndef __CRYPTO_SHA3_H__
> +#define __CRYPTO_SHA3_H__
> +
> +#define SHA3_224_DIGEST_SIZE	(224 / 8)
> +#define SHA3_224_BLOCK_SIZE	(200 - 2 * SHA3_224_DIGEST_SIZE)
> +
> +#define SHA3_256_DIGEST_SIZE	(256 / 8)
> +#define SHA3_256_BLOCK_SIZE	(200 - 2 * SHA3_256_DIGEST_SIZE)
> +
> +#define SHA3_384_DIGEST_SIZE	(384 / 8)
> +#define SHA3_384_BLOCK_SIZE	(200 - 2 * SHA3_384_DIGEST_SIZE)
> +
> +#define SHA3_512_DIGEST_SIZE	(512 / 8)
> +#define SHA3_512_BLOCK_SIZE	(200 - 2 * SHA3_512_DIGEST_SIZE)
> +
> +struct sha3_state {
> +	u64		st[25];
> +	unsigned int	md_len;
> +	unsigned int	rsiz;
> +	unsigned int	rsizw;
> +
> +	unsigned int	partial;
> +	u8		buf[SHA3_224_BLOCK_SIZE];
> +};
> +
> +#endif


Ciao
Stephan
