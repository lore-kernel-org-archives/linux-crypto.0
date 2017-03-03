From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH V2 2/3] crypto: ccp - Enable support for AES GCM on v5 CCPs
Date: Fri, 03 Mar 2017 08:15:15 +0100
Message-ID: <2878078.SoWQfIOqxb@tauon.atsec.com>
References: <20170302212331.30959.44149.stgit@taos> <20170302212654.30959.31.stgit@taos>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
To: Gary R Hook <gary.hook@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35560 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbdCCHyQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Mar 2017 02:54:16 -0500
In-Reply-To: <20170302212654.30959.31.stgit@taos>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 2. März 2017, 22:26:54 CET schrieb Gary R Hook:

Hi Gary,

> A version 5 device provides the primitive commands
> required for AES GCM. This patch adds support for
> en/decryption.
> 
> Signed-off-by: Gary R Hook <gary.hook@amd.com>
> ---
>  drivers/crypto/ccp/Makefile                |    1
>  drivers/crypto/ccp/ccp-crypto-aes-galois.c |  257
> ++++++++++++++++++++++++++++ drivers/crypto/ccp/ccp-crypto-main.c       |  
> 12 +
>  drivers/crypto/ccp/ccp-crypto.h            |   14 ++
>  drivers/crypto/ccp/ccp-dev-v5.c            |    2
>  drivers/crypto/ccp/ccp-dev.h               |    1
>  drivers/crypto/ccp/ccp-ops.c               |  252
> +++++++++++++++++++++++++++ include/linux/ccp.h                        |   
> 9 +
>  8 files changed, 548 insertions(+)
>  create mode 100644 drivers/crypto/ccp/ccp-crypto-aes-galois.c
> 
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index 346ceb8..9ca1722 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -12,4 +12,5 @@ ccp-crypto-objs := ccp-crypto-main.o \
>  		   ccp-crypto-aes.o \
>  		   ccp-crypto-aes-cmac.o \
>  		   ccp-crypto-aes-xts.o \
> +		   ccp-crypto-aes-galois.o \
>  		   ccp-crypto-sha.o
> diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
> b/drivers/crypto/ccp/ccp-crypto-aes-galois.c new file mode 100644
> index 0000000..8bc18c9
> --- /dev/null
> +++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
> @@ -0,0 +1,257 @@
> +/*
> + * AMD Cryptographic Coprocessor (CCP) AES GCM crypto API support
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
> +#include <linux/delay.h>
> +#include <linux/scatterlist.h>
> +#include <linux/crypto.h>
> +#include <crypto/internal/aead.h>
> +#include <crypto/algapi.h>
> +#include <crypto/aes.h>
> +#include <crypto/ctr.h>
> +#include <crypto/scatterwalk.h>
> +#include <linux/delay.h>
> +
> +#include "ccp-crypto.h"
> +
> +#define	AES_GCM_IVSIZE	12
> +
> +static int ccp_aes_gcm_complete(struct crypto_async_request *async_req, int
> ret) +{
> +	return ret;
> +}
> +
> +static int ccp_aes_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
> +			      unsigned int key_len)
> +{
> +	struct ccp_ctx *ctx = crypto_aead_ctx(tfm);
> +
> +	switch (key_len) {
> +	case AES_KEYSIZE_128:
> +		ctx->u.aes.type = CCP_AES_TYPE_128;
> +		break;
> +	case AES_KEYSIZE_192:
> +		ctx->u.aes.type = CCP_AES_TYPE_192;
> +		break;
> +	case AES_KEYSIZE_256:
> +		ctx->u.aes.type = CCP_AES_TYPE_256;
> +		break;
> +	default:
> +		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> +		return -EINVAL;
> +	}
> +
> +	ctx->u.aes.mode = CCP_AES_MODE_GCM;
> +	ctx->u.aes.key_len = key_len;
> +
> +	memcpy(ctx->u.aes.key, key, key_len);
> +	sg_init_one(&ctx->u.aes.key_sg, ctx->u.aes.key, key_len);
> +
> +	return 0;
> +}
> +
> +static int ccp_aes_gcm_setauthsize(struct crypto_aead *tfm,
> +				   unsigned int authsize)
> +{
> +	return 0;
> +}
> +
> +static int ccp_aes_gcm_crypt(struct aead_request *req, bool encrypt)
> +{
> +	struct crypto_aead *tfm = crypto_aead_reqtfm(req);
> +	struct ccp_ctx *ctx = crypto_aead_ctx(tfm);
> +	struct ccp_aes_req_ctx *rctx = aead_request_ctx(req);
> +	struct scatterlist *iv_sg = NULL;
> +	unsigned int iv_len = 0;
> +	int i;
> +	int ret = 0;
> +
> +	if (!ctx->u.aes.key_len)
> +		return -EINVAL;
> +
> +	if (ctx->u.aes.mode != CCP_AES_MODE_GCM)
> +		return -EINVAL;
> +
> +	if (!req->iv)
> +		return -EINVAL;
> +
> +	/*
> +	 * 5 parts:
> +	 *   plaintext/ciphertext input
> +	 *   AAD
> +	 *   key
> +	 *   IV
> +	 *   Destination+tag buffer
> +	 */
> +
> +	/* According to the way AES GCM has been implemented here,
> +	 * per RFC 4106 it seems, the provided IV is fixed at 12 bytes,

When you have that restriction, should the cipher be called rfc4106(gcm(aes))?

But then, the key is 4 bytes longer than a normal AES key as it contains the 
leading 32 bits of the IV.

> +	 * occupies the beginning of the IV array. Write a 32-bit
> +	 * integer after that (bytes 13-16) with a value of "1".
> +	 */
> +	memcpy(rctx->iv, req->iv, AES_GCM_IVSIZE);
> +	for (i = 0; i < 3; i++)
> +		rctx->iv[i + AES_GCM_IVSIZE] = 0;
> +	rctx->iv[AES_BLOCK_SIZE - 1] = 1;
> +
> +	/* Set up a scatterlist for the IV */
> +	iv_sg = &rctx->iv_sg;
> +	iv_len = AES_BLOCK_SIZE;
> +	sg_init_one(iv_sg, rctx->iv, iv_len);
> +
> +	/* The AAD + plaintext are concatenated in the src buffer */
> +	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
> +	INIT_LIST_HEAD(&rctx->cmd.entry);
> +	rctx->cmd.engine = CCP_ENGINE_AES;
> +	rctx->cmd.u.aes.type = ctx->u.aes.type;
> +	rctx->cmd.u.aes.mode = ctx->u.aes.mode;
> +	rctx->cmd.u.aes.action =
> +		(encrypt) ? CCP_AES_ACTION_ENCRYPT : CCP_AES_ACTION_DECRYPT;

Instead of this condition, why not changing the encrypt/decrypt function to 
directly provide the enc/dec variables?

> +	rctx->cmd.u.aes.key = &ctx->u.aes.key_sg;
> +	rctx->cmd.u.aes.key_len = ctx->u.aes.key_len;
> +	rctx->cmd.u.aes.iv = iv_sg;
> +	rctx->cmd.u.aes.iv_len = iv_len;
> +	rctx->cmd.u.aes.src = req->src;
> +	rctx->cmd.u.aes.src_len = req->cryptlen;
> +	rctx->cmd.u.aes.aad_len = req->assoclen;

Just to be on the safe side: is the implementation good when cryptlen or 
assoclen is 0?

Ciao
Stephan
