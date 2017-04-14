From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [RFC PATCH v1 1/1] crypto: algif_compression - User-space
 interface for compression
Date: Fri, 14 Apr 2017 09:49:34 +0530
Message-ID: <CANc+2y6=iiCZBvxjSxRkApA+F9+0_FVTkh5S-nh3ddAJji1T=g@mail.gmail.com>
References: <1492108494-10694-1-git-send-email-akamaluddin@cavium.com> <1492108494-10694-2-git-send-email-akamaluddin@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, akamaluddin@cavium.com,
        pathreya@cavium.com, machalla@cavium.com
To: Abed Kamaluddin <abedamu@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:35357 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750734AbdDNETg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Apr 2017 00:19:36 -0400
Received: by mail-ua0-f195.google.com with SMTP id g30so5439504uab.2
        for <linux-crypto@vger.kernel.org>; Thu, 13 Apr 2017 21:19:35 -0700 (PDT)
In-Reply-To: <1492108494-10694-2-git-send-email-akamaluddin@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 14 April 2017 at 00:04, Abed Kamaluddin <abedamu@gmail.com> wrote:
> crypto: algif_compression - User-space interface for compression
>
> This patch adds af_alg plugin for compression algorithms of type scomp/acomp
> registered to the kernel crypto layer.
>
> The user needs to set operation (compression/decompression) as a control
> message to sendmsg, identical to selecting the cipher operation type in case of
> ciphers. Once a sendmsg call occurs, no further writes can be made to the
> socket until all previous data has been processed and read. Therefore the
> interface only supports one request at a time.
>
> The interface is completely synchronous; all operations are carried out in
> recvmsg and will complete prior to the system call returning.
>
> The sendmsg and recvmsg interface supports directly reading/writing to
> user-space without additional copying, i.e., the kernel crypto interface will
> receive the user-space address as its input/output SG list. The scomp interface
> or crypto drivers may copy the data as required.
>
> Signed-off-by: Abed Kamaluddin <akam...@cavium.com>
> Signed-off-by: Mahipal Challa <mahipal.cha...@cavium.com>
>
> ---
>  crypto/Kconfig              |  11 ++
>  crypto/Makefile             |   1 +
>  crypto/algif_compression.c  | 272 ++++++++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/if_alg.h |   2 +
>  4 files changed, 286 insertions(+)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index f37e9cc..13b03ba 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1741,6 +1741,17 @@ config CRYPTO_USER_API_AEAD
>           This option enables the user-spaces interface for AEAD
>           cipher algorithms.
>
> +config CRYPTO_USER_API_COMPRESSION
> +       tristate "User-space interface for compression algorithms"
> +       depends on NET
> +       select CRYPTO_ACOMP
> +       select CRYPTO_USER_API
> +       help
> +         This option enables the user-space interface for compression
> +         algorithms. Enable this option for access to compression algorithms
> +         of type scomp/acomp exported by the kernel crypto layer through
> +         AF_ALG interface.
> +
>  config CRYPTO_HASH_INFO
>         bool
>
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 8a44057..1469e06 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -134,6 +134,7 @@ obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
>  obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
>  obj-$(CONFIG_CRYPTO_USER_API) += af_alg.o
>  obj-$(CONFIG_CRYPTO_USER_API_HASH) += algif_hash.o
> +obj-$(CONFIG_CRYPTO_USER_API_COMPRESSION) += algif_compression.o
>  obj-$(CONFIG_CRYPTO_USER_API_SKCIPHER) += algif_skcipher.o
>  obj-$(CONFIG_CRYPTO_USER_API_RNG) += algif_rng.o
>  obj-$(CONFIG_CRYPTO_USER_API_AEAD) += algif_aead.o
> diff --git a/crypto/algif_compression.c b/crypto/algif_compression.c
> new file mode 100644
> index 0000000..0ba6d1e
> --- /dev/null
> +++ b/crypto/algif_compression.c
> @@ -0,0 +1,272 @@
> +/*
> + * algif_compression: User-space interface for COMPRESSION algorithms
> + *
> + * This file provides user-space API support for compression algorithms
> + * registered through the kernel crypto layer.
> + *
> + * Copyright (C) 2017 Cavium, Inc.
> + *
> + * Original Authors: Abed Kamaluddin <akamaluddin@cavium.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License as published by the Free
> + * Software Foundation; either version 2 of the License, or (at your option)
> + * any later version.
> + */
> +
> +#include <crypto/acompress.h>
> +#include <crypto/if_alg.h>
> +#include <linux/crypto.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/mm.h>
> +#include <linux/module.h>
> +#include <linux/net.h>
> +#include <net/sock.h>
> +#include <linux/scatterlist.h>
> +
> +/* scomp scratch is currently 128KB */
> +#define COMP_BUFFER_SIZE       65535
> +
> +struct comp_ctx {
> +       struct af_alg_sgl tsgl;
> +       struct af_alg_sgl rsgl;
> +       struct af_alg_completion completion;
> +       unsigned int clen;
> +       unsigned int slen;
> +       unsigned int dlen;
> +       bool comp;
> +       bool used;
> +       struct acomp_req *acomp_req;
> +};

Is it necessary to have 3 len fields viz clen, slen, dlen? Please add
a comment indicating their purpose.

> +struct comp_tfm {
> +       struct crypto_acomp *acomp;
> +};
> +
> +static int comp_sendmsg(struct socket *sock, struct msghdr *msg,
> +                       size_t ignored)
> +{
> +       struct sock *sk = sock->sk;
> +       struct alg_sock *ask = alg_sk(sk);
> +       struct comp_ctx *ctx = ask->private;
> +       struct af_alg_control con = {};
> +       int limit = COMP_BUFFER_SIZE;
> +       int len;
> +       int err = -EINVAL;
> +
> +       if (msg->msg_controllen) {
> +               err = af_alg_cmsg_send(msg, &con);
> +               if (err)
> +                       return err;
> +
> +               switch (con.op) {
> +               case ALG_OP_COMPRESS:
> +                       ctx->comp = 1;
> +                       break;
> +
> +               case ALG_OP_DECOMPRESS:
> +                       ctx->comp = 0;
> +                       break;
> +
> +               default:
> +                       return -EINVAL;
> +               }
> +       }
> +
> +       lock_sock(sk);
> +
> +       /* One request at a time supported, data submitted for comp/decomp will
> +        * be processed at subsequent recvmsg
> +        */
> +       if (ctx->used) {
> +               err = -EAGAIN;
> +               goto unlock;
> +       }
> +
> +       len = msg_data_left(msg);
> +
> +       if (len > limit)
> +               len = limit;
> +
> +       len = af_alg_make_sg(&ctx->tsgl, &msg->msg_iter, len);
> +
> +       if (len < 0) {
> +               err = len;
> +               goto unlock;
> +       }
> +
> +       ctx->slen = len;
> +       ctx->used = 1;
> +
> +unlock:
> +       release_sock(sk);
> +
> +       return err ?: len;
> +}
> +
> +static int comp_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
> +                       int flags)
> +{
> +       struct sock *sk = sock->sk;
> +       struct alg_sock *ask = alg_sk(sk);
> +       struct comp_ctx *ctx = ask->private;
> +       int rlen = ctx->dlen;
> +       int err;
> +
> +       if (len > rlen)
> +               len = rlen;
> +
> +       lock_sock(sk);
> +
> +       if (!ctx->used) {
> +               err = -EAGAIN;
> +               goto unlock;
> +       }
> +
> +       len = af_alg_make_sg(&ctx->rsgl, &msg->msg_iter, len);
> +       if (len < 0) {
> +               err = len;
> +               goto unlock;
> +       }
> +
> +       acomp_request_set_params(ctx->acomp_req, ctx->tsgl.sg, ctx->rsgl.sg,
> +                                ctx->slen, len);
> +
> +       /* Synchronous completion of comp/decomp requests */
> +       err = af_alg_wait_for_completion(
> +                       ctx->comp ?
> +                               crypto_acomp_compress(ctx->acomp_req) :
> +                               crypto_acomp_decompress(ctx->acomp_req),
> +                               &ctx->completion);
> +
> +       /* Add acomp req wrapper for dlen */
> +       len = (ctx->acomp_req)->dlen;
> +
> +       af_alg_free_sg(&ctx->tsgl);
> +       af_alg_free_sg(&ctx->rsgl);
> +
> +unlock:
> +       ctx->used = 0;
> +       release_sock(sk);
> +
> +       return err ?: len;
> +}
> +
> +static struct proto_ops algif_comp_ops = {
> +       .family         =       PF_ALG,
> +
> +       .connect        =       sock_no_connect,
> +       .socketpair     =       sock_no_socketpair,
> +       .getname        =       sock_no_getname,
> +       .ioctl          =       sock_no_ioctl,
> +       .listen         =       sock_no_listen,
> +       .shutdown       =       sock_no_shutdown,
> +       .getsockopt     =       sock_no_getsockopt,
> +       .mmap           =       sock_no_mmap,
> +       .bind           =       sock_no_bind,
> +       .setsockopt     =       sock_no_setsockopt,
> +       .poll           =       sock_no_poll,
> +
> +       .release        =       af_alg_release,
> +       .sendmsg        =       comp_sendmsg,
> +       .recvmsg        =       comp_recvmsg,
> +       .sendpage       =       sock_no_sendpage,
> +       .accept         =       sock_no_accept,
> +};
> +
> +static void *comp_bind(const char *name, u32 type, u32 mask)
> +{
> +       struct comp_tfm *tfm;
> +       struct crypto_acomp *acomp;
> +
> +       tfm = kzalloc(sizeof(*tfm), GFP_KERNEL);
> +       if (!tfm)
> +               return ERR_PTR(-ENOMEM);
> +
> +       acomp = crypto_alloc_acomp(name, type, mask);
> +       if (IS_ERR_OR_NULL(acomp)) {
> +               kfree(tfm);
> +               return ERR_PTR(-ENOMEM);
> +       }
> +       tfm->acomp = acomp;
> +
> +       return tfm;
> +}
> +
> +static void comp_release(void *private)
> +{
> +       struct comp_tfm *tfm = private;
> +
> +       crypto_free_acomp(tfm->acomp);
> +       kfree(tfm);
> +}
> +
> +static void comp_sock_destruct(struct sock *sk)
> +{
> +       struct alg_sock *ask = alg_sk(sk);
> +       struct comp_ctx *ctx = ask->private;
> +
> +       acomp_request_free(ctx->acomp_req);
> +       sock_kfree_s(sk, ctx, ctx->clen);
> +       af_alg_release_parent(sk);
> +}
> +
> +static int comp_accept_parent(void *private, struct sock *sk)
> +{
> +       struct comp_ctx *ctx;
> +       struct alg_sock *ask = alg_sk(sk);
> +       struct comp_tfm *tfm = private;
> +       struct crypto_acomp *acomp = tfm->acomp;
> +       unsigned int len = sizeof(*ctx);
> +
> +       ctx = sock_kmalloc(sk, len, GFP_KERNEL);
> +       if (!ctx)
> +               return -ENOMEM;
> +
> +       ctx->used = 0;
> +       ctx->clen = len;
> +       ctx->dlen = COMP_BUFFER_SIZE;
> +       ctx->slen = COMP_BUFFER_SIZE;
> +
> +       af_alg_init_completion(&ctx->completion);
> +
> +       ctx->acomp_req = acomp_request_alloc(acomp);
> +       if (!ctx->acomp_req) {
> +               sock_kfree_s(sk, ctx, ctx->clen);
> +               return -ENOMEM;
> +       }
> +
> +       acomp_request_set_callback(ctx->acomp_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +                                  af_alg_complete, &ctx->completion);
> +
> +       ask->private = ctx;
> +       sk->sk_destruct = comp_sock_destruct;
> +
> +       return 0;
> +}
> +
> +static const struct af_alg_type algif_type_comp = {
> +       .bind           =       comp_bind,
> +       .release        =       comp_release,
> +       .accept         =       comp_accept_parent,
> +       .ops            =       &algif_comp_ops,
> +       .name           =       "compression",
> +       .owner          =       THIS_MODULE
> +};
> +
> +static int __init algif_comp_init(void)
> +{
> +       return af_alg_register_type(&algif_type_comp);
> +}
> +
> +static void __exit algif_comp_exit(void)
> +{
> +       int err = af_alg_unregister_type(&algif_type_comp);
> +
> +       BUG_ON(err);
> +}
> +
> +module_init(algif_comp_init);
> +module_exit(algif_comp_exit);
> +MODULE_LICENSE("GPL");
> diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
> index f2acd2f..5cca9eb 100644
> --- a/include/uapi/linux/if_alg.h
> +++ b/include/uapi/linux/if_alg.h
> @@ -38,5 +38,7 @@ struct af_alg_iv {
>  /* Operations */
>  #define ALG_OP_DECRYPT                 0
>  #define ALG_OP_ENCRYPT                 1
> +#define ALG_OP_DECOMPRESS              0
> +#define ALG_OP_COMPRESS                1
>
>  #endif /* _LINUX_IF_ALG_H */
> --
> 2.7.4
>

Regards,
PrasannaKumar
