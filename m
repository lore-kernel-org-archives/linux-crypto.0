From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: [PATCH 5/8] crypto:chcr: Change cra_flags for cipher algos
Date: Wed, 8 Mar 2017 15:28:26 +0530
Message-ID: <CAFXBA=mkKinfgLT0vRSXjyW7Lt0V-6o0ud3bdzLZjxqF1je+sg@mail.gmail.com>
References: <cover.1485501428.git.harsh@chelsio.com> <19591395286ea8addca8affa595eabd951fda7ff.1485501429.git.harsh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:34113 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdCHKVl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Mar 2017 05:21:41 -0500
Received: by mail-qk0-f193.google.com with SMTP id v125so9409673qkh.1
        for <linux-crypto@vger.kernel.org>; Wed, 08 Mar 2017 02:21:22 -0800 (PST)
In-Reply-To: <19591395286ea8addca8affa595eabd951fda7ff.1485501429.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert

On Fri, Jan 27, 2017 at 4:09 PM, Harsh Jain <harsh@chelsio.com> wrote:
> Change cipher algos flags to CRYPTO_ALG_TYPE_ABLKCIPHER.
>
> Signed-off-by: Harsh Jain <harsh@chelsio.com>
> ---
>  drivers/crypto/chelsio/chcr_algo.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/crypto/chelsio/chcr_algo.c b/drivers/crypto/chelsio/chcr_algo.c
> index d335943..21fc04c 100644
> --- a/drivers/crypto/chelsio/chcr_algo.c
> +++ b/drivers/crypto/chelsio/chcr_algo.c
> @@ -171,7 +171,7 @@ int chcr_handle_resp(struct crypto_async_request *req, unsigned char *input,
>                 }
>                 break;
>
> -       case CRYPTO_ALG_TYPE_BLKCIPHER:
> +       case CRYPTO_ALG_TYPE_ABLKCIPHER:
>                 ctx_req.req.ablk_req = (struct ablkcipher_request *)req;
>                 ctx_req.ctx.ablk_ctx =
>                         ablkcipher_request_ctx(ctx_req.req.ablk_req);
> @@ -2492,7 +2492,7 @@ static int chcr_aead_op(struct aead_request *req,
>                         .cra_name               = "cbc(aes)",
>                         .cra_driver_name        = "cbc-aes-chcr",
>                         .cra_priority           = CHCR_CRA_PRIORITY,
> -                       .cra_flags              = CRYPTO_ALG_TYPE_BLKCIPHER |
> +                       .cra_flags              = CRYPTO_ALG_TYPE_ABLKCIPHER |
>                                 CRYPTO_ALG_ASYNC,
>                         .cra_blocksize          = AES_BLOCK_SIZE,
>                         .cra_ctxsize            = sizeof(struct chcr_context)
> @@ -2519,7 +2519,7 @@ static int chcr_aead_op(struct aead_request *req,
>                         .cra_name               = "xts(aes)",
>                         .cra_driver_name        = "xts-aes-chcr",
>                         .cra_priority           = CHCR_CRA_PRIORITY,
> -                       .cra_flags              = CRYPTO_ALG_TYPE_BLKCIPHER |
> +                       .cra_flags              = CRYPTO_ALG_TYPE_ABLKCIPHER |
>                                 CRYPTO_ALG_ASYNC,
>                         .cra_blocksize          = AES_BLOCK_SIZE,
>                         .cra_ctxsize            = sizeof(struct chcr_context) +

If I try above patch on 4.9.13 stable kernel. Kernel  stops executing
tests for cbc(aes), Same is working fine on cryptodev-2.6 latest tree.
It seems below patch set has changed the behavior.


crypto: testmgr - Do not test internal algorithms


diff --git a/crypto/algboss.c b/crypto/algboss.c
index 6e39d9c..ccb85e1 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -247,12 +247,8 @@ static int cryptomgr_schedule_test(struct crypto_alg *alg)
memcpy(param->alg, alg->cra_name, sizeof(param->alg));
type = alg->cra_flags;
- /* This piece of crap needs to disappear into per-type test hooks. */
- if (!((type ^ CRYPTO_ALG_TYPE_BLKCIPHER) &
- CRYPTO_ALG_TYPE_BLKCIPHER_MASK) && !(type & CRYPTO_ALG_GENIV) &&
- ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) ==
- CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
- alg->cra_ablkcipher.ivsize))
+ /* Do not test internal algorithms. */
+ if (type & CRYPTO_ALG_INTERNAL)
type |= CRYPTO_ALG_TESTED;

Its bit confusing for me. Are we supposed to declared it as
"CRYPTO_ALG_TYPE_BLKCIPHER" for older kernels.

Regards
Harsh Jain
