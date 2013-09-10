From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] crypto_memcmp: add constant-time memcmp
Date: Tue, 10 Sep 2013 20:57:55 +0200
Message-ID: <522F6BB3.2050308@redhat.com>
References: <1378838291-7036-1-git-send-email-james@openvpn.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.hengli.com.au,
	Florian Weimer <fw@deneb.enyo.de>
To: James Yonan <james@openvpn.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901Ab3IJS6K (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Sep 2013 14:58:10 -0400
In-Reply-To: <1378838291-7036-1-git-send-email-james@openvpn.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/10/2013 08:38 PM, James Yonan wrote:
> When comparing MAC hashes, AEAD authentication tags, or other hash
> values in the context of authentication or integrity checking, it
> is important not to leak timing information to a potential attacker.
>
> Bytewise memory comparisons (such as memcmp) are usually optimized so
> that they return a nonzero value as soon as a mismatch is found.
> This early-return behavior can leak timing information, allowing an
> attacker to iteratively guess the correct result.
>
> This patch adds a new method crypto_memcmp that has the same prototype
> as standard memcmp, but that compares strings of the same length in
> roughly constant time (cache misses could change the timing, but
> since they don't reveal information about the content of the strings
> being compared, they are effectively benign).  Note that crypto_memcmp
> (unlike memcmp) can only be used to test for equality or inequality,
> NOT greater-than or less-than.  This is not an issue for its use-cases
> within the Crypto API.
>
> I tried to locate all of the places in the Crypto API where memcmp was
> being used for authentication or integrity checking, and convert them
> over to crypto_memcmp.
>
> crypto_memcmp is declared noinline and placed in its own source file
> because a very smart compiler (or LTO) might notice that the return
> value is always compared against zero/nonzero, and might then
> reintroduce the same early-return optimization that we are trying to
> avoid.

There was a similar patch posted some time ago [1] on lkml, where
Florian (CC) made a good point in [2] that future compiler optimizations
could short circuit on this. This issue should probably be addressed in
such a patch here as well.

  [1] https://lkml.org/lkml/2013/2/10/131
  [2] https://lkml.org/lkml/2013/2/11/381

> Signed-off-by: James Yonan <james@openvpn.net>
> ---
>   crypto/Makefile                         |  2 +-
>   crypto/asymmetric_keys/rsa.c            |  5 +++--
>   crypto/authenc.c                        |  7 ++++---
>   crypto/authencesn.c                     |  9 +++++----
>   crypto/ccm.c                            |  5 +++--
>   crypto/crypto_memcmp.c                  | 31 +++++++++++++++++++++++++++++++
>   crypto/gcm.c                            |  3 ++-
>   include/crypto/internal/crypto_memcmp.h | 20 ++++++++++++++++++++
>   8 files changed, 69 insertions(+), 13 deletions(-)
>   create mode 100644 crypto/crypto_memcmp.c
>   create mode 100644 include/crypto/internal/crypto_memcmp.h
>
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 2ba0df2..39a574d 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -3,7 +3,7 @@
>   #
>
>   obj-$(CONFIG_CRYPTO) += crypto.o
> -crypto-y := api.o cipher.o compress.o
> +crypto-y := api.o cipher.o compress.o crypto_memcmp.o
>
>   obj-$(CONFIG_CRYPTO_WORKQUEUE) += crypto_wq.o
>
> diff --git a/crypto/asymmetric_keys/rsa.c b/crypto/asymmetric_keys/rsa.c
> index 4a6a069..4f9a250 100644
> --- a/crypto/asymmetric_keys/rsa.c
> +++ b/crypto/asymmetric_keys/rsa.c
> @@ -13,6 +13,7 @@
>   #include <linux/module.h>
>   #include <linux/kernel.h>
>   #include <linux/slab.h>
> +#include <crypto/internal/crypto_memcmp.h>
>   #include "public_key.h"
>
>   MODULE_LICENSE("GPL");
> @@ -189,12 +190,12 @@ static int RSA_verify(const u8 *H, const u8 *EM, size_t k, size_t hash_size,
>   		}
>   	}
>
> -	if (memcmp(asn1_template, EM + T_offset, asn1_size) != 0) {
> +	if (crypto_memcmp(asn1_template, EM + T_offset, asn1_size) != 0) {
>   		kleave(" = -EBADMSG [EM[T] ASN.1 mismatch]");
>   		return -EBADMSG;
>   	}
>
> -	if (memcmp(H, EM + T_offset + asn1_size, hash_size) != 0) {
> +	if (crypto_memcmp(H, EM + T_offset + asn1_size, hash_size) != 0) {
>   		kleave(" = -EKEYREJECTED [EM[T] hash mismatch]");
>   		return -EKEYREJECTED;
>   	}
> diff --git a/crypto/authenc.c b/crypto/authenc.c
> index ffce19d..82ca98f 100644
> --- a/crypto/authenc.c
> +++ b/crypto/authenc.c
> @@ -13,6 +13,7 @@
>   #include <crypto/aead.h>
>   #include <crypto/internal/hash.h>
>   #include <crypto/internal/skcipher.h>
> +#include <crypto/internal/crypto_memcmp.h>
>   #include <crypto/authenc.h>
>   #include <crypto/scatterwalk.h>
>   #include <linux/err.h>
> @@ -188,7 +189,7 @@ static void authenc_verify_ahash_update_done(struct crypto_async_request *areq,
>   	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
>   				 authsize, 0);
>
> -	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
> +	err = crypto_memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
>   	if (err)
>   		goto out;
>
> @@ -227,7 +228,7 @@ static void authenc_verify_ahash_done(struct crypto_async_request *areq,
>   	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
>   				 authsize, 0);
>
> -	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
> +	err = crypto_memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
>   	if (err)
>   		goto out;
>
> @@ -462,7 +463,7 @@ static int crypto_authenc_verify(struct aead_request *req,
>   	ihash = ohash + authsize;
>   	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
>   				 authsize, 0);
> -	return memcmp(ihash, ohash, authsize) ? -EBADMSG : 0;
> +	return crypto_memcmp(ihash, ohash, authsize) ? -EBADMSG : 0;
>   }
>
>   static int crypto_authenc_iverify(struct aead_request *req, u8 *iv,
> diff --git a/crypto/authencesn.c b/crypto/authencesn.c
> index ab53762..ec3bef9 100644
> --- a/crypto/authencesn.c
> +++ b/crypto/authencesn.c
> @@ -15,6 +15,7 @@
>   #include <crypto/aead.h>
>   #include <crypto/internal/hash.h>
>   #include <crypto/internal/skcipher.h>
> +#include <crypto/internal/crypto_memcmp.h>
>   #include <crypto/authenc.h>
>   #include <crypto/scatterwalk.h>
>   #include <linux/err.h>
> @@ -247,7 +248,7 @@ static void authenc_esn_verify_ahash_update_done(struct crypto_async_request *ar
>   	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
>   				 authsize, 0);
>
> -	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
> +	err = crypto_memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
>   	if (err)
>   		goto out;
>
> @@ -296,7 +297,7 @@ static void authenc_esn_verify_ahash_update_done2(struct crypto_async_request *a
>   	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
>   				 authsize, 0);
>
> -	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
> +	err = crypto_memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
>   	if (err)
>   		goto out;
>
> @@ -336,7 +337,7 @@ static void authenc_esn_verify_ahash_done(struct crypto_async_request *areq,
>   	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
>   				 authsize, 0);
>
> -	err = memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
> +	err = crypto_memcmp(ihash, ahreq->result, authsize) ? -EBADMSG : 0;
>   	if (err)
>   		goto out;
>
> @@ -568,7 +569,7 @@ static int crypto_authenc_esn_verify(struct aead_request *req)
>   	ihash = ohash + authsize;
>   	scatterwalk_map_and_copy(ihash, areq_ctx->sg, areq_ctx->cryptlen,
>   				 authsize, 0);
> -	return memcmp(ihash, ohash, authsize) ? -EBADMSG : 0;
> +	return crypto_memcmp(ihash, ohash, authsize) ? -EBADMSG : 0;
>   }
>
>   static int crypto_authenc_esn_iverify(struct aead_request *req, u8 *iv,
> diff --git a/crypto/ccm.c b/crypto/ccm.c
> index 499c917..57349d3 100644
> --- a/crypto/ccm.c
> +++ b/crypto/ccm.c
> @@ -12,6 +12,7 @@
>
>   #include <crypto/internal/aead.h>
>   #include <crypto/internal/skcipher.h>
> +#include <crypto/internal/crypto_memcmp.h>
>   #include <crypto/scatterwalk.h>
>   #include <linux/err.h>
>   #include <linux/init.h>
> @@ -363,7 +364,7 @@ static void crypto_ccm_decrypt_done(struct crypto_async_request *areq,
>
>   	if (!err) {
>   		err = crypto_ccm_auth(req, req->dst, cryptlen);
> -		if (!err && memcmp(pctx->auth_tag, pctx->odata, authsize))
> +		if (!err && crypto_memcmp(pctx->auth_tag, pctx->odata, authsize))
>   			err = -EBADMSG;
>   	}
>   	aead_request_complete(req, err);
> @@ -422,7 +423,7 @@ static int crypto_ccm_decrypt(struct aead_request *req)
>   		return err;
>
>   	/* verify */
> -	if (memcmp(authtag, odata, authsize))
> +	if (crypto_memcmp(authtag, odata, authsize))
>   		return -EBADMSG;
>
>   	return err;
> diff --git a/crypto/crypto_memcmp.c b/crypto/crypto_memcmp.c
> new file mode 100644
> index 0000000..ef4101c
> --- /dev/null
> +++ b/crypto/crypto_memcmp.c
> @@ -0,0 +1,31 @@
> +/*
> + * Constant-time memcmp.
> + *
> + * Copyright (C) 2013 OpenVPN Technologies Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + */
> +
> +#include <linux/export.h>
> +#include <crypto/internal/crypto_memcmp.h>
> +
> +/**
> + * Like memcmp(), but constant-time to prevent leakage of timing info.
> + * Returns 0 when data is equal, non-zero otherwise.
> + */
> +noinline int crypto_memcmp(const void *a, const void *b, size_t size)
> +{
> +	const u8 *a1 = a;
> +	const u8 *b1 = b;
> +	int ret = 0;
> +	size_t i;
> +
> +	for (i = 0; i < size; i++) {
> +		ret |= *a1++ ^ *b1++;
> +	}
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(crypto_memcmp);
> diff --git a/crypto/gcm.c b/crypto/gcm.c
> index 43e1fb0..6be5bca 100644
> --- a/crypto/gcm.c
> +++ b/crypto/gcm.c
> @@ -12,6 +12,7 @@
>   #include <crypto/internal/aead.h>
>   #include <crypto/internal/skcipher.h>
>   #include <crypto/internal/hash.h>
> +#include <crypto/internal/crypto_memcmp.h>
>   #include <crypto/scatterwalk.h>
>   #include <crypto/hash.h>
>   #include "internal.h"
> @@ -582,7 +583,7 @@ static int crypto_gcm_verify(struct aead_request *req,
>
>   	crypto_xor(auth_tag, iauth_tag, 16);
>   	scatterwalk_map_and_copy(iauth_tag, req->src, cryptlen, authsize, 0);
> -	return memcmp(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
> +	return crypto_memcmp(iauth_tag, auth_tag, authsize) ? -EBADMSG : 0;
>   }
>
>   static void gcm_decrypt_done(struct crypto_async_request *areq, int err)
> diff --git a/include/crypto/internal/crypto_memcmp.h b/include/crypto/internal/crypto_memcmp.h
> new file mode 100644
> index 0000000..db23cc0
> --- /dev/null
> +++ b/include/crypto/internal/crypto_memcmp.h
> @@ -0,0 +1,20 @@
> +/*
> + * Constant-time memcmp.
> + *
> + * Copyright (C) 2013 OpenVPN Technologies Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + */
> +
> +#ifndef _CRYPTO_INTERNAL_CRYPTO_MEMCMP_H
> +#define _CRYPTO_INTERNAL_CRYPTO_MEMCMP_H
> +
> +#include <linux/types.h>
> +#include <linux/compiler.h>
> +
> +noinline int crypto_memcmp(const void *a, const void *b, size_t size);
> +
> +#endif
>
