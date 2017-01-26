From: Nitin Kumbhar <nkumbhar@nvidia.com>
Subject: Re: [PATCH 4/6] crypto: ecdsa: add ECDSA SW implementation
Date: Thu, 26 Jan 2017 11:22:34 +0530
Message-ID: <749f2447-0761-7955-0832-fbd0f629c92b@nvidia.com>
References: <1484912161-5932-1-git-send-email-nkumbhar@nvidia.com>
 <1484912161-5932-5-git-send-email-nkumbhar@nvidia.com>
 <1915611.yMS8t8GbjV@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 8BIT
Cc: <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
To: =?UTF-8?Q?Stephan_M=c3=bcller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7293 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751598AbdAZFxA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2017 00:53:00 -0500
In-Reply-To: <1915611.yMS8t8GbjV@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Stephan,

On 1/20/2017 6:36 PM, Stephan Müller wrote:
> Am Freitag, 20. Januar 2017, 17:05:59 CET schrieb Nitin Kumbhar:
>
> Hi Nitin,
>
>> This adds support for ECDSA algorithm. This implementation supports
>> sign and verify functions for ECDSA algorithm using akcipher. As ECDSA
>> is a signing algorithm dummy functions are added for encrypt() and
>> decrypt().
>>
>> Helper routines for parsing public and private ECC keys for ECDSA are
>> added as well.
>>
>> Signed-off-by: Nitin Kumbhar <nkumbhar@nvidia.com>
>> ---
>>  crypto/Kconfig            |    7 +
>>  crypto/Makefile           |    3 +
>>  crypto/ecdsa.c            |  331
>> +++++++++++++++++++++++++++++++++++++++++++++ crypto/ecdsa_helper.c     |
>> 116 ++++++++++++++++
>>  include/crypto/akcipher.h |    5 +-
>>  include/crypto/ecdsa.h    |   29 ++++
>>  6 files changed, 490 insertions(+), 1 deletions(-)
>>  create mode 100644 crypto/ecdsa.c
>>  create mode 100644 crypto/ecdsa_helper.c
>>  create mode 100644 include/crypto/ecdsa.h
>>
>> diff --git a/crypto/Kconfig b/crypto/Kconfig
>> index e240075d6f46..1c5c236b3bbc 100644
>> --- a/crypto/Kconfig
>> +++ b/crypto/Kconfig
>> @@ -140,6 +140,13 @@ config CRYPTO_ECDH
>>  	help
>>  	  Generic implementation of the ECDH algorithm
>>
>> +config CRYPTO_ECDSA
>> +	tristate "ECDSA algorithm"
>> +	select CRYPTO_AKCIPHER
>> +	select CRYPTO_ECC
>> +	help
>> +	  Generic implementation of the ECDSA algorithm
>> +
>>  config CRYPTO_MANAGER
>>  	tristate "Cryptographic algorithm manager"
>>  	select CRYPTO_MANAGER2
>> diff --git a/crypto/Makefile b/crypto/Makefile
>> index 827740a47a37..9c13eb2ade6a 100644
>> --- a/crypto/Makefile
>> +++ b/crypto/Makefile
>> @@ -38,6 +38,9 @@ obj-$(CONFIG_CRYPTO_ECC) += ecc.o
>>  ecdh_generic-y := ecdh.o
>>  ecdh_generic-y += ecdh_helper.o
>>  obj-$(CONFIG_CRYPTO_ECDH) += ecdh_generic.o
>> +ecdsa_generic-y := ecdsa.o
>> +ecdsa_generic-y += ecdsa_helper.o
>> +obj-$(CONFIG_CRYPTO_ECDSA) += ecdsa_generic.o
>>
>>  $(obj)/rsapubkey-asn1.o: $(obj)/rsapubkey-asn1.c $(obj)/rsapubkey-asn1.h
>>  $(obj)/rsaprivkey-asn1.o: $(obj)/rsaprivkey-asn1.c $(obj)/rsaprivkey-asn1.h
>> diff --git a/crypto/ecdsa.c b/crypto/ecdsa.c
>> new file mode 100644
>> index 000000000000..d415900af3bd
>> --- /dev/null
>> +++ b/crypto/ecdsa.c
>> @@ -0,0 +1,331 @@
>> +/*
>> + * ECDSA generic algorithm
>> + *
>> + * Copyright (c) 2017, NVIDIA Corporation. All Rights Reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License as published by the
>> Free + * Software Foundation; either version 2 of the License, or (at your
>> option) + * any later version.
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/scatterlist.h>
>> +#include <linux/random.h>
>> +#include <crypto/internal/akcipher.h>
>> +#include <crypto/akcipher.h>
>> +#include <crypto/ecdsa.h>
>> +
>> +#include "ecc.h"
>> +
>> +struct ecdsa_ctx {
>> +	unsigned int curve_id;
>> +	unsigned int ndigits;
>> +	u64 private_key[ECC_MAX_DIGITS];
>> +	u64 public_key[2 * ECC_MAX_DIGITS];
>> +};
>> +
>> +static inline struct ecdsa_ctx *ecdsa_get_ctx(struct crypto_akcipher *tfm)
>> +{
>> +	return akcipher_tfm_ctx(tfm);
>> +}
>> +
>> +static void ecdsa_parse_msg_hash(struct akcipher_request *req, u64 *msg,
>> +				 unsigned int ndigits)
>> +{
>> +	unsigned int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>> +	unsigned int hash_len, hash_off;
>> +	unsigned char *hash, *msg_ptr;
>> +	int i;
>> +
>> +	/*
>> +	 * If hash_len == nbytes:
>> +	 *	copy nbytes from req
>> +	 * If hash_len > nbytes:
>> +	 *	copy left most nbytes from hash ignoring LSBs
>> +	 * If hash_len < nbytes:
>> +	 *	copy hash_len from req and zero remaining bytes
>> +	 *	(nbytes - hash_len)
>> +	 */
>> +	hash_len = req->src[0].length;
>> +	hash_off = hash_len <= nbytes ? 0 : hash_len - nbytes;
>> +
>> +	msg_ptr = (unsigned char *)msg;
>> +	hash = sg_virt(&req->src[0]);
>> +
>> +	for (i = hash_off; i < hash_len; i++)
>> +		*msg_ptr++ = hash[i];
>> +	for (; i < nbytes; i++)
>> +		*msg_ptr++ = 0;
>> +}
>> +
>> +int ecdsa_sign(struct akcipher_request *req)
>> +{
>> +	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
>> +	struct ecdsa_ctx *ctx = ecdsa_get_ctx(tfm);
>> +	unsigned int ndigits = ctx->ndigits;
>> +	unsigned int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>> +	unsigned int curve_id = ctx->curve_id;
>> +	const struct ecc_curve *curve = ecc_get_curve(curve_id);
>> +	struct ecc_point *x1y1 = NULL;
>> +	u64 z[ndigits], d[ndigits];
>> +	u64 k[ndigits], k_inv[ndigits];
>> +	u64 r[ndigits], s[ndigits];
>> +	u64 dr[ndigits], zdr[ndigits];
>> +	u8 *r_ptr, *s_ptr;
>> +
>> +	if (req->dst_len < 2 * nbytes) {
>> +		req->dst_len = 2 * nbytes;
>> +		return -EINVAL;
>> +	}
>> +
>> +	ecdsa_parse_msg_hash(req, z, ndigits);
>> +
>> +	/* d */
>> +	vli_set(d, (const u64 *)ctx->private_key, ndigits);
>> +
>> +	/* k */
>> +#if defined(CONFIG_CRYPTO_MANAGER2)
>> +	if (req->info) {
>> +		vli_copy_from_buf(k, ndigits, req->info, nbytes);
>> +	} else
>> +#endif
>> +		get_random_bytes(k, nbytes);
>
> Please use crypto_get_default_rng /crypto_rng_get_bytes /
> crypto_put_default_rng here.

Sure. I will update that in next version of the patch.

>> +
>> +	x1y1 = ecc_alloc_point(ndigits);
>> +	if (!x1y1)
>> +		return -ENOMEM;
>> +
>> +	/* (x1, y1) = k x G */
>> +	ecc_point_mult(x1y1, &curve->g, k, NULL, curve->p, ndigits);
>> +
>> +	/* r = x1 mod n */
>> +	vli_mod(r, x1y1->x, curve->n, ndigits);
>> +
>> +	/* k^-1 */
>> +	vli_mod_inv(k_inv, k, curve->n, ndigits);
>> +
>> +	/* d . r mod n */
>> +	vli_mod_mult(dr, d, r, curve->n, ndigits);
>> +
>> +	/* z + dr mod n */
>> +	vli_mod_add(zdr, z, dr, curve->n, ndigits);
>> +
>> +	/* k^-1 . ( z + dr) mod n */
>> +	vli_mod_mult(s, k_inv, zdr, curve->n, ndigits);
>> +
>> +	/* write signature (r,s) in dst */
>> +	r_ptr = sg_virt(req->dst);
>> +	s_ptr = (u8 *)sg_virt(req->dst) + nbytes;
>> +
>> +	vli_copy_to_buf(r_ptr, nbytes, r, ndigits);
>> +	vli_copy_to_buf(s_ptr, nbytes, s, ndigits);
>> +
>> +	req->dst_len = 2 * nbytes;
>> +
>> +	ecc_free_point(x1y1);
>> +	return 0;
>> +}
>> +
>> +int ecdsa_verify(struct akcipher_request *req)
>> +{
>> +	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
>> +	struct ecdsa_ctx *ctx = ecdsa_get_ctx(tfm);
>> +	unsigned int ndigits = ctx->ndigits;
>> +	unsigned int nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>> +	unsigned int curve_id = ctx->curve_id;
>> +	const struct ecc_curve *curve = ecc_get_curve(curve_id);
>> +	struct ecc_point *x1y1 = NULL, *x2y2 = NULL, *Q = NULL;
>> +	u64 r[ndigits], s[ndigits], v[ndigits];
>> +	u64 z[ndigits], w[ndigits];
>> +	u64 u1[ndigits], u2[ndigits];
>> +	u64 x1[ndigits], x2[ndigits];
>> +	u64 y1[ndigits], y2[ndigits];
>> +	u64 *ctx_qx, *ctx_qy;
>> +	int ret;
>> +
>> +	x1y1 = ecc_alloc_point(ndigits);
>> +	x2y2 = ecc_alloc_point(ndigits);
>> +	Q = ecc_alloc_point(ndigits);
>> +	if (!x1y1 || !x2y2 || !Q) {
>> +		ret = -ENOMEM;
>> +		goto exit;
>> +	}
>> +
>> +	ecdsa_parse_msg_hash(req, z, ndigits);
>> +
>> +	/* Signature r,s */
>> +	vli_copy_from_buf(r, ndigits, sg_virt(&req->src[1]), nbytes);
>> +	vli_copy_from_buf(s, ndigits, sg_virt(&req->src[2]), nbytes);
>> +
>> +	/* w = s^-1 mod n */
>> +	vli_mod_inv(w, s, curve->n, ndigits);
>> +
>> +	/* u1 = zw mod n */
>> +	vli_mod_mult(u1, z, w, curve->n, ndigits);
>> +
>> +	/* u2 = rw mod n */
>> +	vli_mod_mult(u2, r, w, curve->n, ndigits);
>> +
>> +	/* u1 . G */
>> +	ecc_point_mult(x1y1, &curve->g, u1, NULL, curve->p, ndigits);
>> +
>> +	/* Q=(Qx,Qy) */
>> +	ctx_qx = ctx->public_key;
>> +	ctx_qy = ctx_qx + ECC_MAX_DIGITS;
>> +	vli_set(Q->x, ctx_qx, ndigits);
>> +	vli_set(Q->y, ctx_qy, ndigits);
>> +
>> +	/* u2 x Q */
>> +	ecc_point_mult(x2y2, Q, u2, NULL, curve->p, ndigits);
>> +
>> +	vli_set(x1, x1y1->x, ndigits);
>> +	vli_set(y1, x1y1->y, ndigits);
>> +	vli_set(x2, x2y2->x, ndigits);
>> +	vli_set(y2, x2y2->y, ndigits);
>> +
>> +	/* x1y1 + x2y2 => P + Q; P + Q in x2 y2 */
>> +	ecc_point_add(x1, y1, x2, y2, curve->p, ndigits);
>> +
>> +	/* v = x mod n */
>> +	vli_mod(v, x2, curve->n, ndigits);
>> +
>> +	/* validate signature */
>> +	ret = vli_cmp(v, r, ndigits) == 0 ? 0 : -EBADMSG;
>> + exit:
>> +	ecc_free_point(x1y1);
>> +	ecc_free_point(x2y2);
>> +	ecc_free_point(Q);
>> +	return ret;
>> +}
>> +
>> +int ecdsa_dummy_enc(struct akcipher_request *req)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +int ecdsa_dummy_dec(struct akcipher_request *req)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +int ecdsa_set_pub_key(struct crypto_akcipher *tfm, const void *key,
>> +		      unsigned int keylen)
>> +{
>> +	struct ecdsa_ctx *ctx = ecdsa_get_ctx(tfm);
>> +	struct ecdsa params;
>> +	unsigned int ndigits;
>> +	unsigned int nbytes;
>> +	u8 *params_qx, *params_qy;
>> +	u64 *ctx_qx, *ctx_qy;
>> +	int ret = 0;
>> +
>> +	if (crypto_ecdsa_parse_pub_key(key, keylen, &params))
>> +		return -EINVAL;
>> +
>> +	ndigits = ecdsa_supported_curve(params.curve_id);
>> +
>> +	ctx->curve_id = params.curve_id;
>> +	ctx->ndigits = ndigits;
>> +	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>> +
>> +	params_qx = params.key;
>> +	params_qy = params_qx + ECC_MAX_DIGIT_BYTES;
>> +
>> +	ctx_qx = ctx->public_key;
>> +	ctx_qy = ctx_qx + ECC_MAX_DIGITS;
>> +
>> +	vli_copy_from_buf(ctx_qx, ndigits, params_qx, nbytes);
>> +	vli_copy_from_buf(ctx_qy, ndigits, params_qy, nbytes);
>> +
>> +	memset(&params, 0, sizeof(params));
>> +	return ret;
>
> Shouldn't there be a check that the point is on the curve? As I think the same
> issue is applicable to ECDH, I guess a common service function should be used
> that we can also invoke from ECDH.

Yes. I'll add checks for public key.

>> +}
>> +
>> +int ecdsa_set_priv_key(struct crypto_akcipher *tfm, const void *key,
>> +		       unsigned int keylen)
>> +{
>> +	struct ecdsa_ctx *ctx = ecdsa_get_ctx(tfm);
>> +	struct ecdsa params;
>> +	unsigned int ndigits;
>> +	unsigned int nbytes;
>> +
>> +	if (crypto_ecdsa_parse_priv_key(key, keylen, &params))
>> +		return -EINVAL;
>> +
>> +	ndigits = ecdsa_supported_curve(params.curve_id);
>> +
>> +	ctx->curve_id = params.curve_id;
>> +	ctx->ndigits = ndigits;
>> +	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>> +
>> +	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
>> +			     (const u8 *)params.key, params.key_size) < 0)
>> +		return -EINVAL;
>> +
>> +	vli_copy_from_buf(ctx->private_key, ndigits, params.key, nbytes);
>> +
>> +	memset(&params, 0, sizeof(params));
>> +	return 0;
>> +}
>> +
>> +int ecdsa_max_size(struct crypto_akcipher *tfm)
>> +{
>> +	struct ecdsa_ctx *ctx = ecdsa_get_ctx(tfm);
>> +	int nbytes = ctx->ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>> +
>> +	/* For r,s */
>> +	return 2 * nbytes;
>> +}
>> +
>> +int ecdsa_init_tfm(struct crypto_akcipher *tfm)
>> +{
>> +	return 0;
>> +}
>> +
>> +void ecdsa_exit_tfm(struct crypto_akcipher *tfm)
>> +{
>> +}
>> +
>> +static struct akcipher_alg ecdsa_alg = {
>> +	.sign		= ecdsa_sign,
>> +	.verify		= ecdsa_verify,
>> +	.encrypt	= ecdsa_dummy_enc,
>> +	.decrypt	= ecdsa_dummy_dec,
>> +	.set_priv_key	= ecdsa_set_priv_key,
>> +	.set_pub_key	= ecdsa_set_pub_key,
>> +	.max_size	= ecdsa_max_size,
>> +	.init		= ecdsa_init_tfm,
>> +	.exit		= ecdsa_exit_tfm,
>> +	.base = {
>> +		.cra_name	= "ecdsa",
>> +		.cra_driver_name = "ecdsa-generic",
>> +		.cra_priority	= 100,
>> +		.cra_module	= THIS_MODULE,
>> +		.cra_ctxsize	= sizeof(struct ecdsa_ctx),
>> +	},
>> +};
>> +
>> +static int ecdsa_init(void)
>> +{
>> +	int ret;
>> +
>> +	ret = crypto_register_akcipher(&ecdsa_alg);
>> +	if (ret)
>> +		pr_err("ecdsa alg register failed. err:%d\n", ret);
>> +	return ret;
>> +}
>> +
>> +static void ecdsa_exit(void)
>> +{
>> +	crypto_unregister_akcipher(&ecdsa_alg);
>> +}
>> +
>> +module_init(ecdsa_init);
>> +module_exit(ecdsa_exit);
>> +
>> +MODULE_ALIAS_CRYPTO("ecdsa");
>> +MODULE_LICENSE("GPL");
>> +MODULE_DESCRIPTION("ECDSA Generic Algorithm");
>> +MODULE_AUTHOR("NVIDIA Corporation");
>> diff --git a/crypto/ecdsa_helper.c b/crypto/ecdsa_helper.c
>> new file mode 100644
>> index 000000000000..d31eb54431a9
>> --- /dev/null
>> +++ b/crypto/ecdsa_helper.c
>> @@ -0,0 +1,116 @@
>> +/*
>> + * ECDSA helper routines
>> + *
>> + * Copyright (c) 2017, NVIDIA Corporation. All Rights Reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License as published by the
>> Free + * Software Foundation; either version 2 of the License, or (at your
>> option) + * any later version.
>> + *
>> + */
>> +
>> +#include <linux/kernel.h>
>> +#include <linux/export.h>
>> +#include <linux/err.h>
>> +#include <linux/string.h>
>> +#include <crypto/ecdsa.h>
>> +
>> +#include "ecc.h"
>> +
>> +#define ECDSA_KEY_MIN_SIZE	(1 + 1 + 24) /* ver + cid + n (P-192) */
>> +
>> +unsigned int ecdsa_supported_curve(unsigned int curve_id)
>> +{
>> +	switch (curve_id) {
>> +	case ECC_CURVE_NIST_P192: return 3;
>> +	case ECC_CURVE_NIST_P256: return 4;
>> +	default: return 0;
>> +	}
>> +}
>
> Wouldn't it be better to have a common function with ECDH as this has almost
> the same code in ecdh_supported_curve?

A separate function is added as ECDH and ECDSA may not support all 
elliptic curves. This allows to handle the differences.

>> +
>> +static inline u8 *ecdsa_pack_data(void *dst, const void *src, size_t sz)
>> +{
>> +	memcpy(dst, src, sz);
>> +	return dst + sz;
>> +}
>> +
>> +static inline const u8 *ecdsa_unpack_data(void *dst, const void *src,
>> size_t sz) +{
>> +	memcpy(dst, src, sz);
>> +	return src + sz;
>> +}
>> +
>> +int crypto_ecdsa_parse_pub_key(const char *buf, unsigned int len,
>> +			       struct ecdsa *params)
>> +{
>> +	unsigned char version;
>> +	unsigned int ndigits;
>> +	unsigned int nbytes;
>> +	const u8 *ptr = buf;
>> +	u8 *qx, *qy;
>> +
>> +	if (unlikely(!buf) || len < ECDSA_KEY_MIN_SIZE)
>> +		return -EINVAL;
>> +
>> +	ptr = ecdsa_unpack_data(&version, ptr, sizeof(version));
>> +	if (version != 1)
>> +		return -EINVAL;
>> +
>> +	ptr = ecdsa_unpack_data(&params->curve_id, ptr,
>> +				sizeof(params->curve_id));
>> +
>> +	ndigits = ecdsa_supported_curve(params->curve_id);
>> +	if (!ndigits)
>> +		return -EINVAL;
>> +
>> +	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>> +
>> +	/* skip private key */
>> +	ptr = ecdsa_unpack_data(&params->key, ptr, nbytes);
>> +
>> +	/* copy public key */
>> +	qx = params->key;
>> +	qy = qx + ECC_MAX_DIGIT_BYTES;
>> +
>> +	ptr = ecdsa_unpack_data(qx, ptr, nbytes);
>> +	ptr = ecdsa_unpack_data(qy, ptr, nbytes);
>> +
>> +	params->key_size = 2 * nbytes;
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(crypto_ecdsa_parse_pub_key);
>> +
>> +int crypto_ecdsa_parse_priv_key(const char *buf, unsigned int len,
>> +				struct ecdsa *params)
>> +{
>> +	unsigned char version;
>> +	unsigned int ndigits;
>> +	unsigned int nbytes;
>> +	const u8 *ptr = buf;
>> +
>> +	if (unlikely(!buf) || len < ECDSA_KEY_MIN_SIZE)
>> +		return -EINVAL;
>> +
>> +	ptr = ecdsa_unpack_data(&version, ptr, sizeof(version));
>> +	if (version != 1)
>> +		return -EINVAL;
>> +
>> +	ptr = ecdsa_unpack_data(&params->curve_id, ptr,
>> +				sizeof(params->curve_id));
>> +
>> +	ndigits = ecdsa_supported_curve(params->curve_id);
>> +	if (!ndigits)
>> +		return -EINVAL;
>> +
>> +	nbytes = ndigits << ECC_DIGITS_TO_BYTES_SHIFT;
>> +
>> +	params->key_size = nbytes;
>> +
>> +	/* copy private key */
>> +	ptr = ecdsa_unpack_data(&params->key, ptr, nbytes);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(crypto_ecdsa_parse_priv_key);
>> diff --git a/include/crypto/akcipher.h b/include/crypto/akcipher.h
>> index c37cc59e9bf2..6b34e9043a6f 100644
>> --- a/include/crypto/akcipher.h
>> +++ b/include/crypto/akcipher.h
>> @@ -3,6 +3,7 @@
>>   *
>>   * Copyright (c) 2015, Intel Corporation
>>   * Authors: Tadeusz Struk <tadeusz.struk@intel.com>
>> + * Copyright (c) 2017, NVIDIA Corporation. All Rights Reserved.
>>   *
>>   * This program is free software; you can redistribute it and/or modify it
>>   * under the terms of the GNU General Public License as published by the
>> Free @@ -27,6 +28,7 @@
>>   *		result.
>>   *		In case of error where the dst sgl size was insufficient,
>>   *		it will be updated to the size required for the operation.
>> + * @info:	Any request specific data needed to process the request.
>>   * @__ctx:	Start of private context data
>>   */
>>  struct akcipher_request {
>> @@ -35,6 +37,7 @@ struct akcipher_request {
>>  	struct scatterlist *dst;
>>  	unsigned int src_len;
>>  	unsigned int dst_len;
>> +	void *info;
>>  	void *__ctx[] CRYPTO_MINALIGN_ATTR;
>>  };
>>
>> @@ -193,7 +196,7 @@ static inline void crypto_free_akcipher(struct
>> crypto_akcipher *tfm) {
>>  	struct akcipher_request *req;
>>
>> -	req = kmalloc(sizeof(*req) + crypto_akcipher_reqsize(tfm), gfp);
>> +	req = kzalloc(sizeof(*req) + crypto_akcipher_reqsize(tfm), gfp);
>>  	if (likely(req))
>>  		akcipher_request_set_tfm(req, tfm);
>>
>> diff --git a/include/crypto/ecdsa.h b/include/crypto/ecdsa.h
>> new file mode 100644
>> index 000000000000..c71d21e654b9
>> --- /dev/null
>> +++ b/include/crypto/ecdsa.h
>> @@ -0,0 +1,29 @@
>> +/*
>> + * ECC parameters for ECDSA
>> + *
>> + * Copyright (c) 2017, NVIDIA Corporation. All Rights Reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License as published by the
>> Free + * Software Foundation; either version 2 of the License, or (at your
>> option) + * any later version.
>> + *
>> + */
>> +
>> +#ifndef _CRYPTO_ECDSA_
>> +#define _CRYPTO_ECDSA_
>> +
>> +#include <crypto/ecc.h>
>> +
>> +struct ecdsa {
>> +	unsigned char curve_id;
>> +	unsigned char key[2 * ECC_MAX_DIGIT_BYTES];
>> +	unsigned short key_size;
>> +};
>> +
>> +unsigned int ecdsa_supported_curve(unsigned int curve_id);
>> +int crypto_ecdsa_parse_pub_key(const char *buf, unsigned int len,
>> +			       struct ecdsa *params);
>> +int crypto_ecdsa_parse_priv_key(const char *buf, unsigned int len,
>> +				struct ecdsa *params);
>> +#endif /* _CRYPTO_ECDSA_ */
>
> I would like to see soem documentation here similar to the ecdh.h. Especially,
> can you please add documentation which type of point representation you expect
> as input (e.g. affine representation)?

I'll include documentation on the lines of ecdh.h for these functions in 
next patch series.

> Ciao
> Stephan
>

Regards,
- Nitin
-----------------------------------------------------------------------------------
This email message is for the sole use of the intended recipient(s) and may contain
confidential information.  Any unauthorized review, use, disclosure or distribution
is prohibited.  If you are not the intended recipient, please contact the sender by
reply email and destroy all copies of the original message.
-----------------------------------------------------------------------------------
