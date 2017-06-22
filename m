From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 3/4] crypto: ccp - Add support for RSA on the CCP
Date: Thu, 22 Jun 2017 07:15:03 +0200
Message-ID: <1779770.Ceb2oF5o24@tauon.chronox.de>
References: <20170621224655.15132.20473.stgit@taos.amd.com> <20170621224801.15132.99552.stgit@taos.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:60348 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751064AbdFVFPG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Jun 2017 01:15:06 -0400
In-Reply-To: <20170621224801.15132.99552.stgit@taos.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 22. Juni 2017, 00:48:01 CEST schrieb Gary R Hook:

Hi Gary,

> Wire up the v3 CCP as a cipher provider.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>  drivers/crypto/ccp/Makefile          |    1
>  drivers/crypto/ccp/ccp-crypto-main.c |   21 ++
>  drivers/crypto/ccp/ccp-crypto-rsa.c  |  286
> ++++++++++++++++++++++++++++++++++ drivers/crypto/ccp/ccp-crypto.h      |  
> 31 ++++
>  drivers/crypto/ccp/ccp-debugfs.c     |    1
>  drivers/crypto/ccp/ccp-dev.c         |    1
>  drivers/crypto/ccp/ccp-ops.c         |    2
>  include/linux/ccp.h                  |    1
>  8 files changed, 341 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-rsa.c
> 
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 59493fd3a751..439bc2fcb464 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -15,4 +15,5 @@ ccp-crypto-objs := ccp-crypto-main.o \
>  		   ccp-crypto-aes-xts.o \
>  		   ccp-crypto-aes-galois.o \
>  		   ccp-crypto-des3.o \
> +		   ccp-crypto-rsa.o \
>  		   ccp-crypto-sha.o
> diff --git a/drivers/crypto/ccp/ccp-crypto-main.c
> b/drivers/crypto/ccp/ccp-crypto-main.c index 8dccbddabef1..dd7d00c680e7
> 100644
> --- a/drivers/crypto/ccp/ccp-crypto-main.c
> +++ b/drivers/crypto/ccp/ccp-crypto-main.c
> @@ -17,6 +17,7 @@
>  #include <linux/ccp.h>
>  #include <linux/scatterlist.h>
>  #include <crypto/internal/hash.h>
> +#include <crypto/internal/akcipher.h>
> 
>  #include "ccp-crypto.h"
> 
> @@ -37,10 +38,15 @@
>  module_param(des3_disable, uint, 0444);
>  MODULE_PARM_DESC(des3_disable, "Disable use of 3DES - any non-zero value");
> 
> +static unsigned int rsa_disable;
> +module_param(rsa_disable, uint, 0444);
> +MODULE_PARM_DESC(rsa_disable, "Disable use of RSA - any non-zero value");
> +
>  /* List heads for the supported algorithms */
>  static LIST_HEAD(hash_algs);
>  static LIST_HEAD(cipher_algs);
>  static LIST_HEAD(aead_algs);
> +static LIST_HEAD(akcipher_algs);
> 
>  /* For any tfm, requests for that tfm must be returned on the order
>   * received.  With multiple queues available, the CCP can process more
> @@ -358,6 +364,14 @@ static int ccp_register_algs(void)
>  			return ret;
>  	}
> 
> +	if (!rsa_disable) {
> +		ret = ccp_register_rsa_algs(&akcipher_algs);
> +		if (ret) {
> +			rsa_disable = 1;
> +			return ret;
> +		}
> +	}
> +
>  	return 0;
>  }
> 
> @@ -366,6 +380,7 @@ static void ccp_unregister_algs(void)
>  	struct ccp_crypto_ahash_alg *ahash_alg, *ahash_tmp;
>  	struct ccp_crypto_ablkcipher_alg *ablk_alg, *ablk_tmp;
>  	struct ccp_crypto_aead *aead_alg, *aead_tmp;
> +	struct ccp_crypto_akcipher_alg *akc_alg, *akc_tmp;
> 
>  	list_for_each_entry_safe(ahash_alg, ahash_tmp, &hash_algs, entry) {
>  		crypto_unregister_ahash(&ahash_alg->alg);
> @@ -384,6 +399,12 @@ static void ccp_unregister_algs(void)
>  		list_del(&aead_alg->entry);
>  		kfree(aead_alg);
>  	}
> +
> +	list_for_each_entry_safe(akc_alg, akc_tmp, &akcipher_algs, entry) {
> +		crypto_unregister_akcipher(&akc_alg->alg);
> +		list_del(&akc_alg->entry);
> +		kfree(akc_alg);
> +	}
>  }
> 
>  static int ccp_crypto_init(void)
> diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c
> b/drivers/crypto/ccp/ccp-crypto-rsa.c new file mode 100644
> index 000000000000..4a2a71463594
> --- /dev/null
> +++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
> @@ -0,0 +1,286 @@
> +/*
> + * AMD Cryptographic Coprocessor (CCP) RSA crypto API support
> + *
> + * Copyright (C) 2016 Advanced Micro Devices, Inc.
> + *
> + * Author: Gary R Hook <gary.hook@amd.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/sched.h>
> +#include <linux/scatterlist.h>
> +#include <linux/crypto.h>
> +#include <crypto/algapi.h>
> +#include <crypto/internal/rsa.h>
> +#include <crypto/internal/akcipher.h>
> +#include <crypto/akcipher.h>
> +#include <crypto/scatterwalk.h>
> +
> +#include "ccp-crypto.h"
> +
> +static inline struct akcipher_request *akcipher_request_cast(
> +	struct crypto_async_request *req)
> +{
> +	return container_of(req, struct akcipher_request, base);
> +}
> +
> +static int ccp_rsa_complete(struct crypto_async_request *async_req, int
> ret) +{
> +	struct akcipher_request *req = akcipher_request_cast(async_req);
> +	struct ccp_rsa_req_ctx *rctx = akcipher_request_ctx(req);
> +
> +	if (!ret)
> +		req->dst_len = rctx->cmd.u.rsa.key_size >> 3;
> +
> +	ret = 0;
> +
> +	return ret;
> +}
> +
> +static unsigned int ccp_rsa_maxsize(struct crypto_akcipher *tfm)
> +{
> +	return CCP_RSA_MAXMOD;
> +}
> +
> +static int ccp_rsa_crypt(struct akcipher_request *req, bool encrypt)
> +{
> +	struct crypto_akcipher *tfm = crypto_akcipher_reqtfm(req);
> +	struct ccp_ctx *ctx = akcipher_tfm_ctx(tfm);
> +	struct ccp_rsa_req_ctx *rctx = akcipher_request_ctx(req);
> +	int ret = 0;
> +
> +	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
> +	INIT_LIST_HEAD(&rctx->cmd.entry);
> +	rctx->cmd.engine = CCP_ENGINE_RSA;
> +
> +	rctx->cmd.u.rsa.key_size = ctx->u.rsa.key_len; /* in bits */
> +	if (encrypt) {
> +		rctx->cmd.u.rsa.exp = &ctx->u.rsa.e_sg;
> +		rctx->cmd.u.rsa.exp_len = ctx->u.rsa.e_len;
> +	} else {
> +		rctx->cmd.u.rsa.exp = &ctx->u.rsa.d_sg;
> +		rctx->cmd.u.rsa.exp_len = ctx->u.rsa.d_len;
> +	}
> +	rctx->cmd.u.rsa.mod = &ctx->u.rsa.n_sg;
> +	rctx->cmd.u.rsa.mod_len = ctx->u.rsa.n_len;
> +	rctx->cmd.u.rsa.src = req->src;
> +	rctx->cmd.u.rsa.src_len = req->src_len;
> +	rctx->cmd.u.rsa.dst = req->dst;
> +
> +	ret = ccp_crypto_enqueue_request(&req->base, &rctx->cmd);
> +
> +	return ret;
> +}
> +
> +static int ccp_rsa_encrypt(struct akcipher_request *req)
> +{
> +	return ccp_rsa_crypt(req, true);
> +}
> +
> +static int ccp_rsa_decrypt(struct akcipher_request *req)
> +{
> +	return ccp_rsa_crypt(req, false);
> +}
> +
> +static int ccp_check_key_length(unsigned int len)
> +{
> +	/* In bits */
> +	if (len < 8 || len > 4096)
> +		return -EINVAL;
> +	return 0;
> +}
> +
> +static void ccp_rsa_free_key_bufs(struct ccp_ctx *ctx)
> +{
> +	/* Clean up old key data */
> +	kfree(ctx->u.rsa.e_buf);
> +	ctx->u.rsa.e_buf = NULL;
> +	ctx->u.rsa.e_len = 0;
> +	kfree(ctx->u.rsa.n_buf);
> +	ctx->u.rsa.n_buf = NULL;
> +	ctx->u.rsa.n_len = 0;
> +	kfree(ctx->u.rsa.d_buf);

kzfree, please

> +	ctx->u.rsa.d_buf = NULL;
> +	ctx->u.rsa.d_len = 0;
> +}
> +
> +static int ccp_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
> +			  unsigned int keylen, bool private)
> +{
> +	struct ccp_ctx *ctx = akcipher_tfm_ctx(tfm);
> +	struct rsa_key raw_key;
> +	int key_len, i;
> +	int ret;
> +
> +	ccp_rsa_free_key_bufs(ctx);
> +	memset(&raw_key, 0, sizeof(raw_key));
> +
> +	/* Code borrowed from crypto/rsa.c */
> +	if (private)
> +		ret = rsa_parse_priv_key(&raw_key, key, keylen);
> +	else
> +		ret = rsa_parse_pub_key(&raw_key, key, keylen);
> +	if (ret)
> +		goto e_key;
> +
> +	/* Remove leading zeroes from the modulus (n) */

Three fragments doing the same -- isn't an inline cleaner here?

> +	key_len = 0;
> +	for (i = 0; i < raw_key.n_sz; i++)
> +		if (raw_key.n[i]) {
> +			key_len = raw_key.n_sz - i;
> +			break;
> +		}
> +	ctx->u.rsa.key_len = key_len << 3; /* bits */
> +	if (ccp_check_key_length(ctx->u.rsa.key_len)) {
> +		ret = -EINVAL;
> +		goto e_key;
> +	}
> +	ctx->u.rsa.n_len = key_len;
> +	sg_init_one(&ctx->u.rsa.n_sg, raw_key.n + i, key_len);
> +
> +	/* Remove leading zeroes from the public key (e) */
> +	key_len = 0;
> +	for (i = 0; i < raw_key.e_sz; i++)
> +		if (raw_key.e[i]) {
> +			key_len = raw_key.e_sz - i;
> +			break;
> +		}
> +	ctx->u.rsa.e_len = key_len;
> +	sg_init_one(&ctx->u.rsa.e_sg, raw_key.e + i, key_len);
> +
> +	if (private) {
> +		/* Remove leading zeroes from the private key (d) */
> +		key_len = 0;
> +		for (i = 0; i < raw_key.d_sz; i++)
> +			if (raw_key.d[i]) {
> +				key_len = raw_key.d_sz - i;
> +				break;
> +			}
> +		ctx->u.rsa.d_len = key_len;
> +		sg_init_one(&ctx->u.rsa.d_sg, raw_key.d + i, key_len);

As I see no memcpy for the key components, how is it ensured that the caller's 
memory holding the key will stay alive after a setkey call? Further, wouldn'd 
the ccp_rsa_free_key_bufs function cause a double free as it would act on 
user-provided memory the user may also try to free?

Ciao
Stephan
