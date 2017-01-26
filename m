From: Krzysztof Kwiatkowski <kris@amongbytes.com>
Subject: Re: [RFC PATCH 4/4] crypto: aes - add generic time invariant AES for
 CTR/CCM/GCM
Date: Thu, 26 Jan 2017 18:35:01 +0000
Message-ID: <cd08e440-ce91-5ba4-d79c-d1995a3fa170@amongbytes.com>
References: <1485451063-11822-1-git-send-email-ard.biesheuvel@linaro.org>
 <1485451063-11822-5-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-crypto@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1485451063-11822-5-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Ard,

This is really interesting implementation. Is there a way to test if
execution of this code is really constant time. Have you done any tests
like that? Adam Langley has proposed using modified version of valgrind
(ctgrind) for that, but I wonder if you maybe thought about any
alternative method?


Kind regards,
Kris


On 26/01/17 17:17, Ard Biesheuvel wrote:
> Lookup table based AES is sensitive to timing attacks, which is
> due to the fact that such table lookups are data dependent, and
> the fact that 8 KB worth of tables covers a significant number of
> cachelines on any architecture.
> 
> For network facing algorithms such as CTR, CCM or GCM, this presents
> a security risk, which is why arch specific AES ports are typically
> time invariant, either through the use of special instructions, or
> by using SIMD algorithms that don't rely on table lookups.
> 
> For generic code, this is difficult to achieve without losing too
> much performance, but we can improve the situation significantly by
> switching to an implementation that only needs 256 bytes of table
> data (the actual S-box itself), which can be prefetched at the start
> of each block to eliminate data dependent latencies.
> 
> Note that this only implements AES encryption, which is all we need
> for CTR and CBC-MAC. AES decryption can easily be implemented in a
> similar way, but is significantly more costly.
> 
> This code runs at ~25 cycles per byte on ARM Cortex-A57 (while the
> ordinary generic AES driver manages 18 cycles per byte on this
> hardware).
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  crypto/Kconfig  |  14 +
>  crypto/Makefile |   1 +
>  crypto/aes_ti.c | 314 ++++++++++++++++++++
>  3 files changed, 329 insertions(+)
> 
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index e8269d1b0282..ce1f6be9e48f 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -896,6 +896,20 @@ config CRYPTO_AES
>  
>  	  See <http://csrc.nist.gov/CryptoToolkit/aes/> for more information.
>  
> +config CRYPTO_AES_TI
> +	tristate "Generic time invariant AES in CTR and CBC-MAC modes"
> +	select CRYPTO_BLKCIPHER
> +	select CRYPTO_HASH
> +	select CRYPTO_AES
> +	help
> +	  This is a time invariant generic implementation of AES in CTR and
> +	  CBC-MAC modes, intended for use by the generic CCM and GCM drivers,
> +	  and other CTR based modes. Instead of using 8 lookup tables of 1 KB
> +	  each, both for encryption and decryption, this implementation only
> +	  uses a single S-box of 256 bytes, and attempts to eliminate data
> +	  dependent latencies by prefetching the entire table into the cache
> +	  at the start of each block.
> +
>  config CRYPTO_AES_586
>  	tristate "AES cipher algorithms (i586)"
>  	depends on (X86 || UML_X86) && !64BIT
> diff --git a/crypto/Makefile b/crypto/Makefile
> index b8f0e3eb0791..bcd834536163 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -99,6 +99,7 @@ obj-$(CONFIG_CRYPTO_TWOFISH) += twofish_generic.o
>  obj-$(CONFIG_CRYPTO_TWOFISH_COMMON) += twofish_common.o
>  obj-$(CONFIG_CRYPTO_SERPENT) += serpent_generic.o
>  obj-$(CONFIG_CRYPTO_AES) += aes_generic.o
> +obj-$(CONFIG_CRYPTO_AES_TI) += aes_ti.o
>  obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia_generic.o
>  obj-$(CONFIG_CRYPTO_CAST_COMMON) += cast_common.o
>  obj-$(CONFIG_CRYPTO_CAST5) += cast5_generic.o
> diff --git a/crypto/aes_ti.c b/crypto/aes_ti.c
> new file mode 100644
> index 000000000000..5ad80e063681
> --- /dev/null
> +++ b/crypto/aes_ti.c
> @@ -0,0 +1,314 @@
> +/*
> + * Scalar (mostly) time invariant AES core transform for CTR/CCM/GCM
> + *
> + * Copyright (C) 2017 Linaro Ltd <ard.biesheuvel@linaro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <crypto/aes.h>
> +#include <crypto/internal/hash.h>
> +#include <crypto/internal/skcipher.h>
> +#include <linux/crypto.h>
> +#include <linux/module.h>
> +#include <asm/unaligned.h>
> +
> +struct aes_ti_ctx {
> +	u32	rk[AES_MAX_KEYLENGTH_U32];
> +	int	rounds;
> +};
> +
> +struct cbcmac_desc_ctx {
> +	unsigned int len;
> +	u8 dg[];
> +};
> +
> +__weak const u8 __cacheline_aligned __aesti_sbox[] = {
> +	0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
> +	0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
> +	0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
> +	0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0,
> +	0xb7, 0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc,
> +	0x34, 0xa5, 0xe5, 0xf1, 0x71, 0xd8, 0x31, 0x15,
> +	0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05, 0x9a,
> +	0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75,
> +	0x09, 0x83, 0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0,
> +	0x52, 0x3b, 0xd6, 0xb3, 0x29, 0xe3, 0x2f, 0x84,
> +	0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b,
> +	0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf,
> +	0xd0, 0xef, 0xaa, 0xfb, 0x43, 0x4d, 0x33, 0x85,
> +	0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c, 0x9f, 0xa8,
> +	0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5,
> +	0xbc, 0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2,
> +	0xcd, 0x0c, 0x13, 0xec, 0x5f, 0x97, 0x44, 0x17,
> +	0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19, 0x73,
> +	0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88,
> +	0x46, 0xee, 0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb,
> +	0xe0, 0x32, 0x3a, 0x0a, 0x49, 0x06, 0x24, 0x5c,
> +	0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
> +	0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9,
> +	0x6c, 0x56, 0xf4, 0xea, 0x65, 0x7a, 0xae, 0x08,
> +	0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6, 0xb4, 0xc6,
> +	0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a,
> +	0x70, 0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e,
> +	0x61, 0x35, 0x57, 0xb9, 0x86, 0xc1, 0x1d, 0x9e,
> +	0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e, 0x94,
> +	0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf,
> +	0x8c, 0xa1, 0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68,
> +	0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16,
> +};
> +
> +static int aesti_set_key(struct aes_ti_ctx *ctx, const u8 *in_key,
> +			 unsigned int key_len)
> +{
> +	struct crypto_aes_ctx rk;
> +	int err;
> +
> +	err = crypto_aes_expand_key(&rk, in_key, key_len);
> +	if (err)
> +		return err;
> +
> +	memcpy(ctx->rk, rk.key_enc, sizeof(ctx->rk));
> +	ctx->rounds = 6 + key_len / 4;
> +
> +	/*
> +	 * In order to force the compiler to emit data independent Sbox lookups
> +	 * at the start of each block, xor the first round key with values at
> +	 * fixed indexes in the Sbox.
> +	 */
> +	ctx->rk[0] ^= __aesti_sbox[ 0] ^ __aesti_sbox[128];
> +	ctx->rk[1] ^= __aesti_sbox[32] ^ __aesti_sbox[160];
> +	ctx->rk[2] ^= __aesti_sbox[64] ^ __aesti_sbox[192];
> +	ctx->rk[3] ^= __aesti_sbox[96] ^ __aesti_sbox[224];
> +
> +	return 0;
> +}
> +
> +static u32 mul_by_x(u32 w)
> +{
> +	/* multiply by polynomial 'x' (0b10) in GF(2^8) */
> +	return ((w & 0x80808080) >> 7) * 0x1b ^ ((w & 0x7f7f7f7f) << 1);
> +}
> +
> +static u32 mix_columns(u32 x)
> +{
> +	u32 y = mul_by_x(x) ^ ror32(x, 16);
> +
> +	return y ^ ror32(x ^ y, 8);
> +}
> +
> +static __always_inline u32 subshift(u32 in[], int pos)
> +{
> +	return (__aesti_sbox[in[pos] & 0xff]) ^
> +	       (__aesti_sbox[(in[(pos + 1) % 4] >>  8) & 0xff] <<  8) ^
> +	       (__aesti_sbox[(in[(pos + 2) % 4] >> 16) & 0xff] << 16) ^
> +	       (__aesti_sbox[(in[(pos + 3) % 4] >> 24) & 0xff] << 24);
> +}
> +
> +static void aesti_encrypt(struct aes_ti_ctx *ctx, u8 *out, const u8 *in)
> +{
> +	u32 st0[4], st1[4];
> +	u32 *rkp = ctx->rk + 4;
> +	int round;
> +
> +	st0[0] = get_unaligned_le32(in);
> +	st0[1] = get_unaligned_le32(in + 4);
> +	st0[2] = get_unaligned_le32(in + 8);
> +	st0[3] = get_unaligned_le32(in + 12);
> +
> +	st0[0] ^= __aesti_sbox[ 0] ^ __aesti_sbox[128] ^ ctx->rk[0];
> +	st0[1] ^= __aesti_sbox[32] ^ __aesti_sbox[160] ^ ctx->rk[1];
> +	st0[2] ^= __aesti_sbox[64] ^ __aesti_sbox[192] ^ ctx->rk[2];
> +	st0[3] ^= __aesti_sbox[96] ^ __aesti_sbox[224] ^ ctx->rk[3];
> +
> +	for (round = 0;; round += 2) {
> +		st1[0] = mix_columns(subshift(st0, 0)) ^ *rkp++;
> +		st1[1] = mix_columns(subshift(st0, 1)) ^ *rkp++;
> +		st1[2] = mix_columns(subshift(st0, 2)) ^ *rkp++;
> +		st1[3] = mix_columns(subshift(st0, 3)) ^ *rkp++;
> +
> +		if (round == ctx->rounds - 2)
> +			break;
> +
> +		st0[0] = mix_columns(subshift(st1, 0)) ^ *rkp++;
> +		st0[1] = mix_columns(subshift(st1, 1)) ^ *rkp++;
> +		st0[2] = mix_columns(subshift(st1, 2)) ^ *rkp++;
> +		st0[3] = mix_columns(subshift(st1, 3)) ^ *rkp++;
> +	}
> +
> +	put_unaligned_le32(subshift(st1, 0) ^ rkp[0], out);
> +	put_unaligned_le32(subshift(st1, 1) ^ rkp[1], out + 4);
> +	put_unaligned_le32(subshift(st1, 2) ^ rkp[2], out + 8);
> +	put_unaligned_le32(subshift(st1, 3) ^ rkp[3], out + 12);
> +}
> +
> +static int aesti_ctr_set_key(struct crypto_skcipher *tfm, const u8 *in_key,
> +			     unsigned int key_len)
> +{
> +	struct aes_ti_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	int err;
> +
> +	err = aesti_set_key(ctx, in_key, key_len);
> +	if (err)
> +		crypto_skcipher_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +	return err;
> +}
> +
> +static int aesti_ctr_encrypt(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
> +	struct aes_ti_ctx *ctx = crypto_skcipher_ctx(tfm);
> +	struct skcipher_walk walk;
> +	u8 buf[AES_BLOCK_SIZE];
> +	int err;
> +
> +	err = skcipher_walk_virt(&walk, req, true);
> +
> +	while (walk.nbytes > 0) {
> +		u8 *dst = walk.dst.virt.addr;
> +		u8 *src = walk.src.virt.addr;
> +		int nbytes = walk.nbytes;
> +		int tail = 0;
> +
> +		if (nbytes < walk.total) {
> +			nbytes = round_down(nbytes, AES_BLOCK_SIZE);
> +			tail = walk.nbytes % AES_BLOCK_SIZE;
> +		}
> +
> +		do {
> +			int bsize = min(nbytes, AES_BLOCK_SIZE);
> +
> +			aesti_encrypt(ctx, buf, walk.iv);
> +			if (dst != src)
> +			       memcpy(dst, src, bsize);
> +			crypto_xor(dst, buf, bsize);
> +			crypto_inc(walk.iv, AES_BLOCK_SIZE);
> +
> +			dst += AES_BLOCK_SIZE;
> +			src += AES_BLOCK_SIZE;
> +			nbytes -= AES_BLOCK_SIZE;
> +		} while (nbytes > 0);
> +
> +		err = skcipher_walk_done(&walk, tail);
> +	}
> +	return err;
> +}
> +
> +static struct skcipher_alg ctr_alg = {
> +	.base.cra_name		= "ctr(aes)",
> +	.base.cra_driver_name	= "ctr-aes-ti",
> +	.base.cra_priority	= 100 + 1,
> +	.base.cra_blocksize	= 1,
> +	.base.cra_ctxsize	= sizeof(struct aes_ti_ctx),
> +	.base.cra_module	= THIS_MODULE,
> +
> +	.min_keysize		= AES_MIN_KEY_SIZE,
> +	.max_keysize		= AES_MAX_KEY_SIZE,
> +	.chunksize		= AES_BLOCK_SIZE,
> +	.ivsize			= AES_BLOCK_SIZE,
> +	.setkey			= aesti_ctr_set_key,
> +	.encrypt		= aesti_ctr_encrypt,
> +	.decrypt		= aesti_ctr_encrypt,
> +};
> +
> +static int aesti_cbcmac_setkey(struct crypto_shash *tfm,
> +			       const u8 *in_key, unsigned int key_len)
> +{
> +	struct aes_ti_ctx *ctx = crypto_shash_ctx(tfm);
> +	int err;
> +
> +	err = aesti_set_key(ctx, in_key, key_len);
> +	if (err)
> +		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +
> +	return err;
> +}
> +
> +static int aesti_cbcmac_init(struct shash_desc *desc)
> +{
> +	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(desc);
> +
> +	memset(ctx->dg, 0, AES_BLOCK_SIZE);
> +	ctx->len = 0;
> +
> +	return 0;
> +}
> +
> +static int aesti_cbcmac_update(struct shash_desc *desc, const u8 *p,
> +			       unsigned int len)
> +{
> +	struct aes_ti_ctx *tctx = crypto_shash_ctx(desc->tfm);
> +	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(desc);
> +
> +	while (len--) {
> +		ctx->dg[ctx->len++] ^= *p++;
> +
> +		if (ctx->len == AES_BLOCK_SIZE) {
> +			aesti_encrypt(tctx, ctx->dg, ctx->dg);
> +			ctx->len = 0;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +static int aesti_cbcmac_final(struct shash_desc *desc, u8 *out)
> +{
> +	struct aes_ti_ctx *tctx = crypto_shash_ctx(desc->tfm);
> +	struct cbcmac_desc_ctx *ctx = shash_desc_ctx(desc);
> +
> +	if (ctx->len)
> +		aesti_encrypt(tctx, out, ctx->dg);
> +	else
> +		memcpy(out, ctx->dg, AES_BLOCK_SIZE);
> +
> +	return 0;
> +}
> +
> +static struct shash_alg cbcmac_alg = {
> +	.base.cra_name		= "cbcmac(aes)",
> +	.base.cra_driver_name	= "cbcmac-aes-ti",
> +	.base.cra_priority	= 100 + 1,
> +	.base.cra_flags		= CRYPTO_ALG_TYPE_SHASH,
> +	.base.cra_blocksize	= 1,
> +	.base.cra_ctxsize	= sizeof(struct aes_ti_ctx),
> +	.base.cra_module	= THIS_MODULE,
> +
> +	.digestsize		= AES_BLOCK_SIZE,
> +	.init			= aesti_cbcmac_init,
> +	.update			= aesti_cbcmac_update,
> +	.final			= aesti_cbcmac_final,
> +	.setkey			= aesti_cbcmac_setkey,
> +	.descsize		= sizeof(struct cbcmac_desc_ctx),
> +};
> +
> +static int __init aes_init(void)
> +{
> +	int err;
> +
> +	err = crypto_register_skcipher(&ctr_alg);
> +	if (err)
> +		return err;
> +
> +	err = crypto_register_shash(&cbcmac_alg);
> +	if (err)
> +		crypto_unregister_skcipher(&ctr_alg);
> +	return err;
> +}
> +
> +static void __exit aes_fini(void)
> +{
> +	crypto_unregister_shash(&cbcmac_alg);
> +	crypto_unregister_skcipher(&ctr_alg);
> +}
> +
> +module_init(aes_init);
> +module_exit(aes_fini);
> +
> +MODULE_DESCRIPTION("Generic time invariant AES transform in CTR and CBC-MAC modes");
> +MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS_CRYPTO("cbcmac(aes)");
> +MODULE_ALIAS_CRYPTO("ctr(aes)");
> 
