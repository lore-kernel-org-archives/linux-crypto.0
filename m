From: Jan Glauber <jang@linux.vnet.ibm.com>
Subject: Re: [RFC] [crypto] S390-AES add fallback driver.
Date: Mon, 12 Nov 2007 18:04:29 +0000
Message-ID: <1194890669.5656.46.camel@localhost.localdomain>
References: <20071111211027.GA9003@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:4905 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530AbXKLREq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Nov 2007 12:04:46 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.8/8.13.8) with ESMTP id lACH4jGg143104
	for <linux-crypto@vger.kernel.org>; Mon, 12 Nov 2007 17:04:45 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.6) with ESMTP id lACH4iGV1921028
	for <linux-crypto@vger.kernel.org>; Mon, 12 Nov 2007 18:04:44 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lACH4iRd022770
	for <linux-crypto@vger.kernel.org>; Mon, 12 Nov 2007 18:04:44 +0100
In-Reply-To: <20071111211027.GA9003@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, 2007-11-11 at 22:10 +0100, Sebastian Siewior wrote:
> Some CPUs support only 128 bit keys in HW. This patch adds SW fallbac=
k
> support for the other keys which may be required. The generic algorit=
hm
> (and the block mode) must be availble in case of a fallback.
>=20
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> ---
>=20
> Jan, please I didn't have the time to compile test. My compiler nagge=
d
> only about the header file so it could work :)

Sebastian, thanks for working on this! Do you know if I need other
posted patches that are not yet in cryptodev-2.6 for this to work?

I'm asking becuase I'm getting the following crash using tcrypt (aes
192-bit key, ecb-mode) :(

Call Trace:
(=DD<0000000002ee5680>=A8 0x2ee5680)
 =DD<00000001008292ae>=A8 crypto_ecb_setkey+0x52/0x74 =DDecb=A8
 =DD<000000010082316e>=A8 setkey_fallback_blk+0x5e/0x98 =DDaes_s390=A8
 =DD<0000000100886d76>=A8 test_cipher+0x2da/0x8f0 =DDtcrypt=A8
 =DD<000000010080570e>=A8 init+0x70e/0x1808 =DDtcrypt=A8
 =DD<00000000000674f4>=A8 sys_init_module+0x148/0x1e64
 =DD<00000000000222f8>=A8 sysc_noemu+0x10/0x16
 =DD<000002000011ff6e>=A8 0x2000011ff6e

>From my limited understanding of the internals of crypto API I think
this is because crypto_ecb_setkey() calls crypto_cipher_setkey() instea=
d
of crypto_blkcipher_setkey() and the layout of struct blkcipher_tfm
has the *iv where cipher_tfm has the setkey(). And oops, since the *iv
is zero we have a null pointer call. But maybe I'm just missing another=
 patch...

thanks, Jan


> diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.=
c
> index 812511b..393a450 100644
> --- a/arch/s390/crypto/aes_s390.c
> +++ b/arch/s390/crypto/aes_s390.c
> @@ -6,6 +6,7 @@
>   * s390 Version:
>   *   Copyright IBM Corp. 2005,2007
>   *   Author(s): Jan Glauber (jang@de.ibm.com)
> + *		Sebastian Siewior (sebastian@breakpoint.cc> SW-Fallback
>   *
>   * Derived from "crypto/aes_generic.c"
>   *
> @@ -18,6 +19,7 @@
>=20
>  #include <crypto/aes.h>
>  #include <crypto/algapi.h>
> +#include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include "crypt_s390.h"
> @@ -34,45 +36,89 @@ struct s390_aes_ctx {
>  	long enc;
>  	long dec;
>  	int key_len;
> +	union {
> +		struct crypto_blkcipher *blk;
> +		struct crypto_cipher *cip;
> +	} fallback;
>  };
>=20
> -static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
> -		       unsigned int key_len)
> +/*
> + * Check if the key_len is supported by the HW.
> + * Returns 0 if it is, a positive number if it is not and software f=
allback is
> + * required or a negative number in case the key size is not valid
> + */
> +static int need_fallback(unsigned int key_len)
>  {
> -	struct s390_aes_ctx *sctx =3D crypto_tfm_ctx(tfm);
> -	u32 *flags =3D &tfm->crt_flags;
> -
>  	switch (key_len) {
>  	case 16:
>  		if (!(keylen_flag & AES_KEYLEN_128))
> -			goto fail;
> +			return 1;
>  		break;
>  	case 24:
>  		if (!(keylen_flag & AES_KEYLEN_192))
> -			goto fail;
> -
> +			return 1;
>  		break;
>  	case 32:
>  		if (!(keylen_flag & AES_KEYLEN_256))
> -			goto fail;
> +			return 1;
>  		break;
>  	default:
> -		goto fail;
> +		return -1;
>  		break;
>  	}
> +	return 0;
> +}
> +
> +static int setkey_fallback_cip(struct crypto_tfm *tfm, const u8 *in_=
key,
> +		unsigned int key_len)
> +{
> +	struct s390_aes_ctx *sctx =3D crypto_tfm_ctx(tfm);
> +	int ret;
> +
> +	sctx->fallback.blk->base.crt_flags &=3D ~CRYPTO_TFM_REQ_MASK;
> +	sctx->fallback.blk->base.crt_flags |=3D (tfm->crt_flags &
> +			CRYPTO_TFM_REQ_MASK);
> +
> +	ret =3D crypto_cipher_setkey(sctx->fallback.cip, in_key, key_len);
> +	if (ret) {
> +		tfm->crt_flags &=3D ~CRYPTO_TFM_RES_MASK;
> +		tfm->crt_flags |=3D (sctx->fallback.blk->base.crt_flags &
> +				CRYPTO_TFM_RES_MASK);
> +	}
> +	return ret;
> +}
> +
> +static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
> +		       unsigned int key_len)
> +{
> +	struct s390_aes_ctx *sctx =3D crypto_tfm_ctx(tfm);
> +	u32 *flags =3D &tfm->crt_flags;
> +	int ret;
> +
> +	ret =3D need_fallback(key_len);
> +	if (ret < 0) {
> +		*flags |=3D CRYPTO_TFM_RES_BAD_KEY_LEN;
> +		return -EINVAL;
> +	}
>=20
>  	sctx->key_len =3D key_len;
> -	memcpy(sctx->key, in_key, key_len);
> -	return 0;
> -fail:
> -	*flags |=3D CRYPTO_TFM_RES_BAD_KEY_LEN;
> -	return -EINVAL;
> +	if (!ret) {
> +		memcpy(sctx->key, in_key, key_len);
> +		return 0;
> +	}
> +
> +	return setkey_fallback_cip(tfm, in_key, key_len);
>  }
>=20
>  static void aes_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *i=
n)
>  {
>  	const struct s390_aes_ctx *sctx =3D crypto_tfm_ctx(tfm);
>=20
> +	if (unlikely(need_fallback(sctx->key_len))) {
> +		crypto_cipher_encrypt_one(sctx->fallback.cip, out, in);
> +		return;
> +	}
> +
>  	switch (sctx->key_len) {
>  	case 16:
>  		crypt_s390_km(KM_AES_128_ENCRYPT, &sctx->key, out, in,
> @@ -93,6 +139,11 @@ static void aes_decrypt(struct crypto_tfm *tfm, u=
8 *out, const u8 *in)
>  {
>  	const struct s390_aes_ctx *sctx =3D crypto_tfm_ctx(tfm);
>=20
> +	if (unlikely(need_fallback(sctx->key_len))) {
> +		crypto_cipher_decrypt_one(sctx->fallback.cip, out, in);
> +		return;
> +	}
> +
>  	switch (sctx->key_len) {
>  	case 16:
>  		crypt_s390_km(KM_AES_128_DECRYPT, &sctx->key, out, in,
> @@ -109,7 +160,6 @@ static void aes_decrypt(struct crypto_tfm *tfm, u=
8 *out, const u8 *in)
>  	}
>  }
>=20
> -
>  static struct crypto_alg aes_alg =3D {
>  	.cra_name		=3D	"aes",
>  	.cra_driver_name	=3D	"aes-s390",
> @@ -131,10 +181,71 @@ static struct crypto_alg aes_alg =3D {
>  	}
>  };
>=20
> +static int setkey_fallback_blk(struct crypto_tfm *tfm, const u8 *key=
,
> +		unsigned int len)
> +{
> +	struct s390_aes_ctx *sctx =3D crypto_tfm_ctx(tfm);
> +	unsigned int ret;
> +
> +	/*
> +	 * The requested key size is not supported by HW, do a fallback
> +	 */
> +	sctx->fallback.blk->base.crt_flags &=3D ~CRYPTO_TFM_REQ_MASK;
> +	sctx->fallback.blk->base.crt_flags |=3D (tfm->crt_flags &
> +			CRYPTO_TFM_REQ_MASK);
> +
> +	ret =3D crypto_blkcipher_setkey(sctx->fallback.blk, key, len);
> +	if (ret) {
> +		tfm->crt_flags &=3D ~CRYPTO_TFM_RES_MASK;
> +		tfm->crt_flags |=3D (sctx->fallback.blk->base.crt_flags &
> +				CRYPTO_TFM_RES_MASK);
> +	}
> +	return ret;
> +}
> +
> +static int fallback_blk_dec(struct blkcipher_desc *desc,
> +		struct scatterlist *dst, struct scatterlist *src,
> +		unsigned int nbytes)
> +{
> +	unsigned int ret;
> +	struct crypto_blkcipher *tfm;
> +	struct s390_aes_ctx *sctx =3D crypto_blkcipher_ctx(desc->tfm);
> +
> +	tfm =3D desc->tfm;
> +	desc->tfm =3D sctx->fallback.blk;
> +
> +	ret =3D crypto_blkcipher_decrypt(desc, dst, src, nbytes);
> +
> +	desc->tfm =3D tfm;
> +	return ret;
> +}
> +
> +static int fallback_blk_enc(struct blkcipher_desc *desc,
> +		struct scatterlist *dst, struct scatterlist *src,
> +		unsigned int nbytes)
> +{
> +	unsigned int ret;
> +	struct crypto_blkcipher *tfm;
> +	struct s390_aes_ctx *sctx =3D crypto_blkcipher_ctx(desc->tfm);
> +
> +	tfm =3D desc->tfm;
> +	desc->tfm =3D sctx->fallback.blk;
> +
> +	ret =3D crypto_blkcipher_encrypt(desc, dst, src, nbytes);
> +
> +	desc->tfm =3D tfm;
> +	return ret;
> +}
> +
>  static int ecb_aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>  			   unsigned int key_len)
>  {
>  	struct s390_aes_ctx *sctx =3D crypto_tfm_ctx(tfm);
> +	int ret;
> +
> +	ret =3D need_fallback(key_len);
> +	if (ret > 0)
> +		return setkey_fallback_blk(tfm, in_key, key_len);
>=20
>  	switch (key_len) {
>  	case 16:
> @@ -183,6 +294,9 @@ static int ecb_aes_encrypt(struct blkcipher_desc =
*desc,
>  	struct s390_aes_ctx *sctx =3D crypto_blkcipher_ctx(desc->tfm);
>  	struct blkcipher_walk walk;
>=20
> +	if (unlikely(need_fallback(sctx->key_len)))
> +		return fallback_blk_enc(desc, dst, src, nbytes);
> +
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	return ecb_aes_crypt(desc, sctx->enc, sctx->key, &walk);
>  }
> @@ -194,10 +308,37 @@ static int ecb_aes_decrypt(struct blkcipher_des=
c *desc,
>  	struct s390_aes_ctx *sctx =3D crypto_blkcipher_ctx(desc->tfm);
>  	struct blkcipher_walk walk;
>=20
> +	if (unlikely(need_fallback(sctx->key_len)))
> +		return fallback_blk_dec(desc, dst, src, nbytes);
> +
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	return ecb_aes_crypt(desc, sctx->dec, sctx->key, &walk);
>  }
>=20
> +static int fallback_init_blk(struct crypto_tfm *tfm)
> +{
> +	const char *name =3D tfm->__crt_alg->cra_name;
> +	struct s390_aes_ctx *sctx =3D crypto_tfm_ctx(tfm);
> +
> +	sctx->fallback.blk =3D crypto_alloc_blkcipher(name, 0,
> +			CRYPTO_ALG_ASYNC | CRYPTO_ALG_NEED_FALLBACK);
> +
> +	if (IS_ERR(sctx->fallback.blk)) {
> +		printk(KERN_ERR "Error allocating fallback algo %s\n", name);
> +		return PTR_ERR(sctx->fallback.blk);
> +	}
> +
> +	return 0;
> +}
> +
> +static void fallback_exit_blk(struct crypto_tfm *tfm)
> +{
> +	struct s390_aes_ctx *sctx =3D crypto_tfm_ctx(tfm);
> +
> +	crypto_free_blkcipher(sctx->fallback.blk);
> +	sctx->fallback.blk =3D NULL;
> +}
> +
>  static struct crypto_alg ecb_aes_alg =3D {
>  	.cra_name		=3D	"ecb(aes)",
>  	.cra_driver_name	=3D	"ecb-aes-s390",
> @@ -209,6 +350,8 @@ static struct crypto_alg ecb_aes_alg =3D {
>  	.cra_type		=3D	&crypto_blkcipher_type,
>  	.cra_module		=3D	THIS_MODULE,
>  	.cra_list		=3D	LIST_HEAD_INIT(ecb_aes_alg.cra_list),
> +	.cra_init		=3D	fallback_init_blk,
> +	.cra_exit		=3D	fallback_exit_blk,
>  	.cra_u			=3D	{
>  		.blkcipher =3D {
>  			.min_keysize		=3D	AES_MIN_KEY_SIZE,
> @@ -224,6 +367,11 @@ static int cbc_aes_set_key(struct crypto_tfm *tf=
m, const u8 *in_key,
>  			   unsigned int key_len)
>  {
>  	struct s390_aes_ctx *sctx =3D crypto_tfm_ctx(tfm);
> +	int ret;
> +
> +	ret =3D need_fallback(key_len);
> +	if (ret > 0)
> +		return setkey_fallback_blk(tfm, in_key, key_len);
>=20
>  	switch (key_len) {
>  	case 16:
> @@ -278,6 +426,9 @@ static int cbc_aes_encrypt(struct blkcipher_desc =
*desc,
>  	struct s390_aes_ctx *sctx =3D crypto_blkcipher_ctx(desc->tfm);
>  	struct blkcipher_walk walk;
>=20
> +	if (unlikely(need_fallback(sctx->key_len)))
> +		return fallback_blk_enc(desc, dst, src, nbytes);
> +
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	return cbc_aes_crypt(desc, sctx->enc, sctx->iv, &walk);
>  }
> @@ -289,6 +440,9 @@ static int cbc_aes_decrypt(struct blkcipher_desc =
*desc,
>  	struct s390_aes_ctx *sctx =3D crypto_blkcipher_ctx(desc->tfm);
>  	struct blkcipher_walk walk;
>=20
> +	if (unlikely(need_fallback(sctx->key_len)))
> +		return fallback_blk_dec(desc, dst, src, nbytes);
> +
>  	blkcipher_walk_init(&walk, dst, src, nbytes);
>  	return cbc_aes_crypt(desc, sctx->dec, sctx->iv, &walk);
>  }
> @@ -304,6 +458,8 @@ static struct crypto_alg cbc_aes_alg =3D {
>  	.cra_type		=3D	&crypto_blkcipher_type,
>  	.cra_module		=3D	THIS_MODULE,
>  	.cra_list		=3D	LIST_HEAD_INIT(cbc_aes_alg.cra_list),
> +	.cra_init		=3D	fallback_init_blk,
> +	.cra_exit		=3D	fallback_exit_blk,
>  	.cra_u			=3D	{
>  		.blkcipher =3D {
>  			.min_keysize		=3D	AES_MIN_KEY_SIZE,
> @@ -331,14 +487,10 @@ static int __init aes_init(void)
>  		return -EOPNOTSUPP;
>=20
>  	/* z9 109 and z9 BC/EC only support 128 bit key length */
> -	if (keylen_flag =3D=3D AES_KEYLEN_128) {
> -		aes_alg.cra_u.cipher.cia_max_keysize =3D AES_MIN_KEY_SIZE;
> -		ecb_aes_alg.cra_u.blkcipher.max_keysize =3D AES_MIN_KEY_SIZE;
> -		cbc_aes_alg.cra_u.blkcipher.max_keysize =3D AES_MIN_KEY_SIZE;
> +	if (keylen_flag =3D=3D AES_KEYLEN_128)
>  		printk(KERN_INFO
>  		       "aes_s390: hardware acceleration only available for"
>  		       "128 bit keys\n");
> -	}
>=20
>  	ret =3D crypto_register_alg(&aes_alg);
>  	if (ret)
> @@ -377,4 +529,3 @@ MODULE_ALIAS("aes");
>=20
>  MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
>  MODULE_LICENSE("GPL");
> -
