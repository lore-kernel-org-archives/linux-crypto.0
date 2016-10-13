From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 3/6] crypto: ccp - Add support for RSA on the CCP
Date: Thu, 13 Oct 2016 20:25:48 +0200
Message-ID: <1603902.uM94ZuZj0Q@tauon.atsec.com>
References: <20161013144542.19759.6924.stgit@taos> <20161013145309.19759.18493.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:49830 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753859AbcJMS0V (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Oct 2016 14:26:21 -0400
In-Reply-To: <20161013145309.19759.18493.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 13. Oktober 2016, 09:53:09 CEST schrieb Gary R Hook:

Hi Gary,

> Wire up the v3 CCP as a cipher provider.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>  drivers/crypto/ccp/Makefile          |    1
>  drivers/crypto/ccp/ccp-crypto-main.c |   15 ++
>  drivers/crypto/ccp/ccp-crypto-rsa.c  |  258
> ++++++++++++++++++++++++++++++++++ drivers/crypto/ccp/ccp-crypto.h      |  
> 24 +++
>  drivers/crypto/ccp/ccp-dev-v3.c      |   38 +++++
>  drivers/crypto/ccp/ccp-ops.c         |    1
>  include/linux/ccp.h                  |   34 ++++
>  7 files changed, 370 insertions(+), 1 deletion(-)
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-rsa.c
> 
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 346ceb8..23f89b7 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -12,4 +12,5 @@ ccp-crypto-objs := ccp-crypto-main.o \
>  		   ccp-crypto-aes.o \
>  		   ccp-crypto-aes-cmac.o \
>  		   ccp-crypto-aes-xts.o \
> +		   ccp-crypto-rsa.o \
>  		   ccp-crypto-sha.o
> diff --git a/drivers/crypto/ccp/ccp-crypto-main.c
> b/drivers/crypto/ccp/ccp-crypto-main.c index e0380e5..f3c4c25 100644
> --- a/drivers/crypto/ccp/ccp-crypto-main.c
> +++ b/drivers/crypto/ccp/ccp-crypto-main.c
> @@ -33,6 +33,10 @@ static unsigned int sha_disable;
>  module_param(sha_disable, uint, 0444);
>  MODULE_PARM_DESC(sha_disable, "Disable use of SHA - any non-zero value");
> 
> +static unsigned int rsa_disable;
> +module_param(rsa_disable, uint, 0444);
> +MODULE_PARM_DESC(rsa_disable, "Disable use of RSA - any non-zero value");
> +
>  /* List heads for the supported algorithms */
>  static LIST_HEAD(hash_algs);
>  static LIST_HEAD(cipher_algs);
> @@ -343,6 +347,14 @@ static int ccp_register_algs(void)
>  			return ret;
>  	}
> 
> +	if (!rsa_disable) {
> +		ret = ccp_register_rsa_algs();
> +		if (ret) {
> +			rsa_disable = 1;
> +			return ret;
> +		}
> +	}
> +
>  	return 0;
>  }
> 
> @@ -362,6 +374,9 @@ static void ccp_unregister_algs(void)
>  		list_del(&ablk_alg->entry);
>  		kfree(ablk_alg);
>  	}
> +
> +	if (!rsa_disable)
> +		ccp_unregister_rsa_algs();
>  }
> 
>  static int ccp_crypto_init(void)
> diff --git a/drivers/crypto/ccp/ccp-crypto-rsa.c
> b/drivers/crypto/ccp/ccp-crypto-rsa.c new file mode 100644
> index 0000000..7dab43b
> --- /dev/null
> +++ b/drivers/crypto/ccp/ccp-crypto-rsa.c
> @@ -0,0 +1,258 @@
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
> +#include <linux/mpi.h>
> +#include <linux/scatterlist.h>
> +#include <linux/crypto.h>
> +#include <crypto/algapi.h>
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
> +		req->dst_len = rctx->cmd.u.rsa.d_len;
> +
> +	ret = 0;
> +
> +	return ret;
> +}
> +
> +static int ccp_rsa_maxsize(struct crypto_akcipher *tfm)
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
> +	if (!ctx->u.rsa.pkey.d && !ctx->u.rsa.pkey.e)
> +		return -EINVAL;
> +
> +	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
> +	INIT_LIST_HEAD(&rctx->cmd.entry);
> +	rctx->cmd.engine = CCP_ENGINE_RSA;
> +	rctx->cmd.u.rsa.mode = encrypt ? CCP_RSA_ENCRYPT : CCP_RSA_DECRYPT;
> +
> +	rctx->cmd.u.rsa.pkey = ctx->u.rsa.pkey;
> +	rctx->cmd.u.rsa.key_size = ctx->u.rsa.key_len;
> +	rctx->cmd.u.rsa.exp = &ctx->u.rsa.e_sg;
> +	rctx->cmd.u.rsa.exp_len = ctx->u.rsa.e_len;
> +	rctx->cmd.u.rsa.mod = &ctx->u.rsa.n_sg;
> +	rctx->cmd.u.rsa.mod_len = ctx->u.rsa.n_len;
> +	if (ctx->u.rsa.pkey.d) {
> +		rctx->cmd.u.rsa.d_sg = &ctx->u.rsa.d_sg;
> +		rctx->cmd.u.rsa.d_len = ctx->u.rsa.d_len;
> +	}
> +
> +	rctx->cmd.u.rsa.src = req->src;
> +	rctx->cmd.u.rsa.src_len = req->src_len;
> +	rctx->cmd.u.rsa.dst = req->dst;
> +	rctx->cmd.u.rsa.dst_len = req->dst_len;
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
> +static void ccp_free_mpi_key(struct ccp_rsa_key *key)
> +{
> +	mpi_free(key->d);
> +	key->d = NULL;
> +	mpi_free(key->e);
> +	key->e = NULL;
> +	mpi_free(key->n);
> +	key->n = NULL;
> +}

Could you please see whether that function can be turned into a common 
function call? crypto/rsa.c implements the same code in rsa_free_mpi_key.
> +
> +static int ccp_check_key_length(unsigned int len)
> +{
> +	/* In bits */
> +	if (len < 8 || len > 16384)
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

kzfree, please.

> +	ctx->u.rsa.d_buf = NULL;
> +	ctx->u.rsa.d_len = 0;
> +}
> +
> +static int ccp_rsa_setkey(struct crypto_akcipher *tfm, const void *key,
> +			  unsigned int keylen, bool public)
> +{
> +	struct ccp_ctx *ctx = akcipher_tfm_ctx(tfm);
> +	struct rsa_key raw_key;
> +	unsigned int n_size;
> +	int ret;
> +
> +	if (!ctx)
> +		return -EINVAL;
> +
> +	ccp_rsa_free_key_bufs(ctx);
> +	memset(&raw_key, 0, sizeof(raw_key));
> +
> +	/* Code borrowed from crypto/rsa.c */
> +	if (public)
> +		ret = rsa_parse_pub_key(&raw_key, key, keylen);
> +	else
> +		ret = rsa_parse_priv_key(&raw_key, key, keylen);
> +	if (ret)
> +		goto e_ret;
> +
> +	ret = -EINVAL;
> +
> +	ctx->u.rsa.pkey.e = mpi_read_raw_data(raw_key.e, raw_key.e_sz);
> +	if (!ctx->u.rsa.pkey.e)
> +		goto e_ret;
> +	ctx->u.rsa.e_buf = mpi_get_buffer(ctx->u.rsa.pkey.e,
> +					  &ctx->u.rsa.e_len, NULL);
> +	if (!ctx->u.rsa.e_buf)
> +		goto e_key;
> +	sg_init_one(&ctx->u.rsa.e_sg, ctx->u.rsa.e_buf, ctx->u.rsa.e_len);
> +
> +
> +	ctx->u.rsa.pkey.n = mpi_read_raw_data(raw_key.n, raw_key.n_sz);
> +	n_size = mpi_get_size(ctx->u.rsa.pkey.n);
> +	if (ccp_check_key_length(n_size << 3))
> +		goto e_key;
> +	ctx->u.rsa.key_len = n_size;
> +	ctx->u.rsa.n_buf = mpi_get_buffer(ctx->u.rsa.pkey.n,
> +					  &ctx->u.rsa.n_len, NULL);
> +	if (!ctx->u.rsa.n_buf)
> +		goto e_nkey;
> +	sg_init_one(&ctx->u.rsa.n_sg, ctx->u.rsa.n_buf, ctx->u.rsa.n_len);
> +
> +	if (!public) {
> +		ctx->u.rsa.pkey.d = mpi_read_raw_data(raw_key.d, raw_key.d_sz);
> +		if (!ctx->u.rsa.pkey.d)
> +			goto e_nkey;
> +		ctx->u.rsa.d_buf = mpi_get_buffer(ctx->u.rsa.pkey.d,
> +						  &ctx->u.rsa.d_len, NULL);
> +		if (!ctx->u.rsa.d_buf)
> +			goto e_dkey;
> +		sg_init_one(&ctx->u.rsa.d_sg, ctx->u.rsa.d_buf,
> +			    ctx->u.rsa.d_len);
> +	}
> +
> +	return 0;
> +
> +e_dkey:
> +	kfree(ctx->u.rsa.n_buf);
> +e_nkey:
> +	kfree(ctx->u.rsa.e_buf);
> +e_key:
> +	ccp_free_mpi_key(&ctx->u.rsa.pkey);
> +e_ret:
> +	return ret;
> +}
> +
> +static int ccp_rsa_setprivkey(struct crypto_akcipher *tfm, const void *key,
> +			      unsigned int keylen)
> +{
> +	return ccp_rsa_setkey(tfm, key, keylen, false);
> +}
> +
> +static int ccp_rsa_setpubkey(struct crypto_akcipher *tfm, const void *key,
> +			     unsigned int keylen)
> +{
> +	return ccp_rsa_setkey(tfm, key, keylen, true);
> +}
> +
> +static int ccp_rsa_init_tfm(struct crypto_akcipher *tfm)
> +{
> +	struct ccp_ctx *ctx = akcipher_tfm_ctx(tfm);
> +
> +	ctx->complete = ccp_rsa_complete;
> +
> +	return 0;
> +}
> +
> +static void ccp_rsa_exit_tfm(struct crypto_akcipher *tfm)
> +{
> +	struct ccp_ctx *ctx = crypto_tfm_ctx(&tfm->base);
> +
> +	ccp_rsa_free_key_bufs(ctx);
> +}
> +
> +static struct akcipher_alg rsa = {
> +	.encrypt = ccp_rsa_encrypt,
> +	.decrypt = ccp_rsa_decrypt,
> +	.sign = NULL,
> +	.verify = NULL,
> +	.set_pub_key = ccp_rsa_setpubkey,
> +	.set_priv_key = ccp_rsa_setprivkey,
> +	.max_size = ccp_rsa_maxsize,
> +	.init = ccp_rsa_init_tfm,
> +	.exit = ccp_rsa_exit_tfm,
> +	.reqsize = sizeof(struct ccp_rsa_req_ctx),
> +	.base = {
> +		.cra_name = "rsa",
> +		.cra_driver_name = "rsa-ccp",
> +		.cra_priority = 100,

Are you sure you want to leave it at 100? With this value, it will content 
with the C implementation.

> +		.cra_module = THIS_MODULE,
> +		.cra_ctxsize = sizeof(struct ccp_ctx),
> +	},
> +};
> +
> +int ccp_register_rsa_algs(void)
> +{
> +	int ret;
> +
> +	/* Register the RSA algorithm in standard mode
> +	 * This works for CCP v3 and later
> +	 */
> +	ret = crypto_register_akcipher(&rsa);
> +	return ret;
> +}
> +
> +void ccp_unregister_rsa_algs(void)
> +{
> +	crypto_unregister_akcipher(&rsa);
> +}
> diff --git a/drivers/crypto/ccp/ccp-crypto.h
> b/drivers/crypto/ccp/ccp-crypto.h index ae442ac..4a1d206 100644
> --- a/drivers/crypto/ccp/ccp-crypto.h
> +++ b/drivers/crypto/ccp/ccp-crypto.h
> @@ -22,6 +22,7 @@
>  #include <crypto/ctr.h>
>  #include <crypto/hash.h>
>  #include <crypto/sha.h>
> +#include <crypto/internal/rsa.h>
> 
>  #define CCP_CRA_PRIORITY	300
> 
> @@ -155,6 +156,26 @@ struct ccp_sha_ctx {
>  	struct crypto_shash *hmac_tfm;
>  };
> 
> +/***** RSA related defines *****/
> +
> +struct ccp_rsa_ctx {
> +	unsigned int key_len; /* in bytes */
> +	struct ccp_rsa_key pkey;
> +	struct scatterlist e_sg;
> +	u8 *e_buf;
> +	unsigned int e_len;
> +	struct scatterlist n_sg;
> +	u8 *n_buf;
> +	unsigned int n_len;
> +	struct scatterlist d_sg;
> +	u8 *d_buf;
> +	unsigned int d_len;
> +};
> +
> +struct ccp_rsa_req_ctx {
> +	struct ccp_cmd cmd;
> +};
> +
>  struct ccp_sha_req_ctx {
>  	enum ccp_sha_type type;
> 
> @@ -201,6 +222,7 @@ struct ccp_ctx {
> 
>  	union {
>  		struct ccp_aes_ctx aes;
> +		struct ccp_rsa_ctx rsa;
>  		struct ccp_sha_ctx sha;
>  	} u;
>  };
> @@ -214,5 +236,7 @@ int ccp_register_aes_algs(struct list_head *head);
>  int ccp_register_aes_cmac_algs(struct list_head *head);
>  int ccp_register_aes_xts_algs(struct list_head *head);
>  int ccp_register_sha_algs(struct list_head *head);
> +int ccp_register_rsa_algs(void);
> +void ccp_unregister_rsa_algs(void);
> 
>  #endif
> diff --git a/drivers/crypto/ccp/ccp-dev-v3.c
> b/drivers/crypto/ccp/ccp-dev-v3.c index 8d2dbac..75a0978 100644
> --- a/drivers/crypto/ccp/ccp-dev-v3.c
> +++ b/drivers/crypto/ccp/ccp-dev-v3.c
> @@ -20,6 +20,43 @@
> 
>  #include "ccp-dev.h"
> 
> +/* CCP version 3: Union to define the function field (cmd_reg1/dword0) */
> +union ccp_function {
> +	struct {
> +		u16 size:7;
> +		u16 encrypt:1;
> +		u16 mode:3;
> +		u16 type:2;
> +	} aes;
> +	struct {
> +		u16 size:7;
> +		u16 encrypt:1;
> +		u16 rsvd:5;
> +	} aes_xts;
> +	struct {
> +		u16 rsvd1:11;
> +		u16 type:2;
> +	} sha;
> +	struct {
> +		u16 size:13;
> +	} rsa;
> +	struct {
> +		u16 byteswap:2;
> +		u16 bitwise:3;
> +		u16 rsvd:8;
> +	} pt;
> +	struct  {
> +		u16 rsvd:13;
> +	} zlib;
> +	struct {
> +		u16 size:8;
> +		u16 mode:3;
> +		u16 rsvd1:1;
> +		u16 rsvd2:1;
> +	} ecc;
> +	u16 raw;
> +};
> +
>  static u32 ccp_alloc_ksb(struct ccp_cmd_queue *cmd_q, unsigned int count)
>  {
>  	int start;
> @@ -88,6 +125,7 @@ static int ccp_do_cmd(struct ccp_op *op, u32 *cr,
> unsigned int cr_count) * are actually available, but reading that register
> resets it
>  	 * and you could lose some error information.
>  	 */
> +
>  	cmd_q->free_slots--;
> 
>  	cr0 = (cmd_q->id << REQ0_CMD_Q_SHIFT)
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 82cc637..826782d 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -17,6 +17,7 @@
>  #include <linux/interrupt.h>
>  #include <crypto/scatterwalk.h>
>  #include <linux/ccp.h>
> +#include <linux/delay.h>
> 
>  #include "ccp-dev.h"
> 
> diff --git a/include/linux/ccp.h b/include/linux/ccp.h
> index 1a3e0b5..d634565 100644
> --- a/include/linux/ccp.h
> +++ b/include/linux/ccp.h
> @@ -19,7 +19,8 @@
>  #include <linux/list.h>
>  #include <crypto/aes.h>
>  #include <crypto/sha.h>
> -
> +#include <linux/mpi.h>
> +#include <crypto/internal/rsa.h>
> 
>  struct ccp_device;
>  struct ccp_cmd;
> @@ -293,6 +294,27 @@ struct ccp_sha_engine {
>  				 * final sha cmd */
>  };
> 
> +/**
> + * ccp_rsa_type - mode of RSA operation
> + *
> + * @CCP_RSA_MODE_STD: standard mode
> + */
> +enum ccp_rsa_mode {
> +	CCP_RSA_ENCRYPT = 0,
> +	CCP_RSA_DECRYPT,
> +	CCP_RSA__LAST,
> +};
> +
> +struct ccp_rsa_key {
> +	MPI e;
> +	MPI n;
> +	MPI d;
> +};
> +
> +#define	CCP_RSA_MAXMOD	(4 * 1024 / 8)
> +#define	CCP5_RSA_MAXMOD	(16 * 1024 / 8)
> +#define	CCP5_RSA_MINMOD	(512 / 8)
> +
>  /***** RSA engine *****/
>  /**
>   * struct ccp_rsa_engine - CCP RSA operation
> @@ -309,16 +331,26 @@ struct ccp_sha_engine {
>   *   - key_size, exp, exp_len, mod, mod_len, src, dst, src_len
>   */
>  struct ccp_rsa_engine {
> +	enum ccp_rsa_mode mode;
>  	u32 key_size;		/* In bits */
> 
> +	struct ccp_rsa_key pkey;
> +
> +/* e */
>  	struct scatterlist *exp;
>  	u32 exp_len;		/* In bytes */
> 
> +/* n */
>  	struct scatterlist *mod;
>  	u32 mod_len;		/* In bytes */
> 
> +/* d */
> +	struct scatterlist *d_sg;
> +	unsigned int d_len;
> +
>  	struct scatterlist *src, *dst;
>  	u32 src_len;		/* In bytes */
> +	u32 dst_len;		/* In bytes */
>  };
> 
>  /***** Passthru engine *****/
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



Ciao
Stephan
