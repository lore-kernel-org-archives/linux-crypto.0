Return-Path: <SRS0=zaW3=BX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.6 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46D5C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 16:04:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A02A420829
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Aug 2020 16:04:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ufEjr7Ub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgHMQE4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Aug 2020 12:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMQEx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Aug 2020 12:04:53 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615B9C061383
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2020 09:04:53 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z6so7842950iow.6
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2020 09:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Opxc5fUaKy9V8/hlSmFSRdMNdNQxw+Pe4f7MqaOFPs=;
        b=ufEjr7UbBsbV8ViyFX1hwnQFFeB5r4z60h7wLfv9I9s3tufgjekwG5Y32w7MGibR0Q
         6DGvVuoIqji0kcxlwrKJOPRAgxtN1/5V9H6rn4YWLO1+HaQamZR3KMfT6sDF1pMRee3Q
         MhiNHgG7HwDgsY2ZBTNSmv1HIKRPgSGf7Jv4z2jrQfjVUv1edTjYSPEADzfbrQZ5J70G
         QfDOCtq+70dm/bddqRPXdlc9hrwolvHNFctvChJyvxrFaFxNHTNq1gTi7FnASn00txDm
         7CrxBPd8o+43GGD7u8y1hPAVtAEZoFO6JZ173vJhClXmN3YwHERybPqMY2pVtB1dDTkG
         PsmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5Opxc5fUaKy9V8/hlSmFSRdMNdNQxw+Pe4f7MqaOFPs=;
        b=XtHhUKRw3OOEfbpp/4PoMnwAgf7A+x+3zssli5iWIcb+Gs5yVXb47bYq+X8DQh8Z/v
         5QpyYOCmG9prwmTBSnnpOj/8KXnqa4Tw0b34QpUiEyzS/qP8HqxjZYPjNHnWIJaC5AqD
         8zjtrVfqp1Irh3CCi4hV94MYpzAp85hLJIMDK2VHdKgf6AMtSMAT9eMQTCP7IcOY+R39
         l+KEvjzMRXPWBo+HqYtlYtrmjChpms7olLva+vRz4LT+b+sTWqeGvjpWNfpHpkuWf1mN
         gKrLxFb4+huzPOgFU9Rv7fwzH/Zi/2e06dym+CLPvlqIlwGOwjUIkpatxVDn1/P2hVn6
         EH2Q==
X-Gm-Message-State: AOAM531WKoB83cH4h5R2ERomaazyXHDrkAK8vdBhtuNLCdX8XGakPnq/
        hE2Mzvj0xp+jQa/Id3GpIfMrdAC0BBhUSqa2NyMZEGzM
X-Google-Smtp-Source: ABdhPJxPBNQk3NyVuBmqwPPtMybR7EpiX/FOE0sqWMfT3bVIpZujeSTrawTZyRkMDpc15EAC9wWDpJfWuPE+hWlJDTQ=
X-Received: by 2002:a5e:a607:: with SMTP id q7mr5514718ioi.16.1597334692075;
 Thu, 13 Aug 2020 09:04:52 -0700 (PDT)
MIME-Version: 1.0
References: <CABvBcwbQY9nnDu5LSRUDHqPcmnedwa-juQaFdirDY3zTuZB0yA@mail.gmail.com>
 <20200813160149.3566448-1-lenaptr@google.com>
In-Reply-To: <20200813160149.3566448-1-lenaptr@google.com>
From:   Elena Petrova <lenaptr@google.com>
Date:   Thu, 13 Aug 2020 17:04:40 +0100
Message-ID: <CABvBcwYPXvK1_b2hR5THaqfq8nKVwppdBd2aJF6cmS_aCxHxUg@mail.gmail.com>
Subject: Re: [PATCH v4] crypto: af_alg - add extra parameters for DRBG interface
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Jeffrey Vander Stoep <jeffv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Err, I sent the old patch file, sorry. Real v5 coming shortly...

On Thu, 13 Aug 2020 at 17:02, Elena Petrova <lenaptr@google.com> wrote:
>
> Extend the user-space RNG interface:
>   1. Add entropy input via ALG_SET_DRBG_ENTROPY setsockopt option;
>   2. Add additional data input via sendmsg syscall.
>
> This allows DRBG to be tested with test vectors, for example for the
> purpose of CAVP testing, which otherwise isn't possible.
>
> To prevent erroneous use of entropy input, it is hidden under
> CRYPTO_USER_API_CAVP_DRBG config option and requires CAP_SYS_ADMIN to
> succeed.
>
> Signed-off-by: Elena Petrova <lenaptr@google.com>
> ---
>
> Updates in v4:
>   1) setentropy returns 0 or error code (used to return length);
>   2) bigfixes suggested by Eric.
>
> Updates in v3:
>   1) More details in commit message;
>   2) config option name is now CRYPTO_USER_API_CAVP_DRBG;
>   3) fixed a bug of not releasing socket locks.
>
> Updates in v2:
>   1) Adding CONFIG_CRYPTO_CAVS_DRBG around setentropy.
>   2) Requiring CAP_SYS_ADMIN for entropy reset.
>   3) Locking for send and recv.
>   4) Length checks added for send and setentropy; send and setentropy now return
>      number of bytes accepted.
>   5) Minor code style corrections.
>
> libkcapi patch for testing:
>   https://github.com/Len0k/libkcapi/commit/6f095d270b982008f419078614c15caa592cb531
>
>  Documentation/crypto/userspace-if.rst |  17 +++-
>  crypto/Kconfig                        |   8 ++
>  crypto/af_alg.c                       |   8 ++
>  crypto/algif_rng.c                    | 130 ++++++++++++++++++++++++--
>  include/crypto/if_alg.h               |   1 +
>  include/uapi/linux/if_alg.h           |   1 +
>  6 files changed, 152 insertions(+), 13 deletions(-)
>
> diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
> index ff86befa61e0..ef7132802c2d 100644
> --- a/Documentation/crypto/userspace-if.rst
> +++ b/Documentation/crypto/userspace-if.rst
> @@ -296,15 +296,23 @@ follows:
>
>      struct sockaddr_alg sa = {
>          .salg_family = AF_ALG,
> -        .salg_type = "rng", /* this selects the symmetric cipher */
> -        .salg_name = "drbg_nopr_sha256" /* this is the cipher name */
> +        .salg_type = "rng", /* this selects the random number generator */
> +        .salg_name = "drbg_nopr_sha256" /* this is the RNG name */
>      };
>
>
>  Depending on the RNG type, the RNG must be seeded. The seed is provided
>  using the setsockopt interface to set the key. For example, the
>  ansi_cprng requires a seed. The DRBGs do not require a seed, but may be
> -seeded.
> +seeded. The seed is also known as a *Personalization String* in DRBG800-90A
> +standard.
> +
> +For the purpose of CAVP testing, the concatenation of *Entropy* and *Nonce*
> +can be provided to the RNG via ALG_SET_DRBG_ENTROPY setsockopt interface. This
> +requires a kernel built with CONFIG_CRYPTO_USER_API_CAVP_DRBG, and
> +CAP_SYS_ADMIN permission.
> +
> +*Additional Data* can be provided using the send()/sendmsg() system calls.
>
>  Using the read()/recvmsg() system calls, random numbers can be obtained.
>  The kernel generates at most 128 bytes in one call. If user space
> @@ -377,6 +385,9 @@ mentioned optname:
>     provided ciphertext is assumed to contain an authentication tag of
>     the given size (see section about AEAD memory layout below).
>
> +-  ALG_SET_DRBG_ENTROPY -- Setting the entropy of the random number generator.
> +   This option is applicable to RNG cipher type only.
> +
>  User space API example
>  ----------------------
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 091c0a0bbf26..aa2b3085a431 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -1896,6 +1896,14 @@ config CRYPTO_STATS
>  config CRYPTO_HASH_INFO
>         bool
>
> +config CRYPTO_USER_API_CAVP_DRBG
> +       tristate "Enable CAVP testing of DRBG"
> +       depends on CRYPTO_USER_API_RNG && CRYPTO_DRBG
> +       help
> +         This option enables the resetting of DRBG entropy via the user-space
> +         interface. This should only be enabled for CAVP testing. You should say
> +         no unless you know what this is.
> +
>  source "lib/crypto/Kconfig"
>  source "drivers/crypto/Kconfig"
>  source "crypto/asymmetric_keys/Kconfig"
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index b1cd3535c525..27d6248ca447 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -260,6 +260,14 @@ static int alg_setsockopt(struct socket *sock, int level, int optname,
>                 if (!type->setauthsize)
>                         goto unlock;
>                 err = type->setauthsize(ask->private, optlen);
> +               break;
> +       case ALG_SET_DRBG_ENTROPY:
> +               if (sock->state == SS_CONNECTED)
> +                       goto unlock;
> +               if (!type->setentropy)
> +                       goto unlock;
> +
> +               err = type->setentropy(ask->private, optval, optlen);
>         }
>
>  unlock:
> diff --git a/crypto/algif_rng.c b/crypto/algif_rng.c
> index 087c0ad09d38..21e8201844bf 100644
> --- a/crypto/algif_rng.c
> +++ b/crypto/algif_rng.c
> @@ -38,6 +38,7 @@
>   * DAMAGE.
>   */
>
> +#include <linux/capability.h>
>  #include <linux/module.h>
>  #include <crypto/rng.h>
>  #include <linux/random.h>
> @@ -53,20 +54,35 @@ struct rng_ctx {
>  #define MAXSIZE 128
>         unsigned int len;
>         struct crypto_rng *drng;
> +       u8 *addtl;
> +       size_t addtl_len;
>  };
>
> +struct rng_parent_ctx {
> +       struct crypto_rng *drng;
> +       u8 *entropy;
> +};
> +
> +static void rng_reset_addtl(struct rng_ctx *ctx)
> +{
> +       kzfree(ctx->addtl);
> +       ctx->addtl = NULL;
> +       ctx->addtl_len = 0;
> +}
> +
>  static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>                        int flags)
>  {
>         struct sock *sk = sock->sk;
>         struct alg_sock *ask = alg_sk(sk);
>         struct rng_ctx *ctx = ask->private;
> -       int err;
> +       int err = 0;
>         int genlen = 0;
>         u8 result[MAXSIZE];
>
> +       lock_sock(sock->sk);
>         if (len == 0)
> -               return 0;
> +               goto unlock;
>         if (len > MAXSIZE)
>                 len = MAXSIZE;
>
> @@ -82,13 +98,48 @@ static int rng_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>          * seeding as they automatically seed. The X9.31 DRNG will return
>          * an error if it was not seeded properly.
>          */
> -       genlen = crypto_rng_get_bytes(ctx->drng, result, len);
> -       if (genlen < 0)
> -               return genlen;
> +       genlen = crypto_rng_generate(ctx->drng, ctx->addtl, ctx->addtl_len,
> +                                    result, len);
> +       if (genlen < 0) {
> +               err = genlen;
> +               goto unlock;
> +       }
>
>         err = memcpy_to_msg(msg, result, len);
>         memzero_explicit(result, len);
> +       rng_reset_addtl(ctx);
>
> +unlock:
> +       release_sock(sock->sk);
> +       return err ? err : len;
> +}
> +
> +static int rng_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
> +{
> +       int err;
> +       struct alg_sock *ask = alg_sk(sock->sk);
> +       struct rng_ctx *ctx = ask->private;
> +
> +       lock_sock(sock->sk);
> +       if (len > MAXSIZE)
> +               len = MAXSIZE;
> +
> +       rng_reset_addtl(ctx);
> +       ctx->addtl = kmalloc(len, GFP_KERNEL);
> +       if (!ctx->addtl) {
> +               err = -ENOMEM;
> +               goto unlock;
> +       }
> +
> +       err = memcpy_from_msg(ctx->addtl, msg, len);
> +       if (err) {
> +               rng_reset_addtl(ctx);
> +               goto unlock;
> +       }
> +       ctx->addtl_len = len;
> +
> +unlock:
> +       release_sock(sock->sk);
>         return err ? err : len;
>  }
>
> @@ -106,21 +157,41 @@ static struct proto_ops algif_rng_ops = {
>         .bind           =       sock_no_bind,
>         .accept         =       sock_no_accept,
>         .setsockopt     =       sock_no_setsockopt,
> -       .sendmsg        =       sock_no_sendmsg,
>         .sendpage       =       sock_no_sendpage,
>
>         .release        =       af_alg_release,
>         .recvmsg        =       rng_recvmsg,
> +       .sendmsg        =       rng_sendmsg,
>  };
>
>  static void *rng_bind(const char *name, u32 type, u32 mask)
>  {
> -       return crypto_alloc_rng(name, type, mask);
> +       struct rng_parent_ctx *pctx;
> +       struct crypto_rng *rng;
> +
> +       pctx = kzalloc(sizeof(*pctx), GFP_KERNEL);
> +       if (!pctx)
> +               return ERR_PTR(-ENOMEM);
> +
> +       rng = crypto_alloc_rng(name, type, mask);
> +       if (IS_ERR(rng)) {
> +               kfree(pctx);
> +               return ERR_CAST(rng);
> +       }
> +
> +       pctx->drng = rng;
> +       return pctx;
>  }
>
>  static void rng_release(void *private)
>  {
> -       crypto_free_rng(private);
> +       struct rng_parent_ctx *pctx = private;
> +
> +       if (unlikely(!pctx))
> +               return;
> +       crypto_free_rng(pctx->drng);
> +       kzfree(pctx->entropy);
> +       kzfree(pctx);
>  }
>
>  static void rng_sock_destruct(struct sock *sk)
> @@ -128,6 +199,7 @@ static void rng_sock_destruct(struct sock *sk)
>         struct alg_sock *ask = alg_sk(sk);
>         struct rng_ctx *ctx = ask->private;
>
> +       rng_reset_addtl(ctx);
>         sock_kfree_s(sk, ctx, ctx->len);
>         af_alg_release_parent(sk);
>  }
> @@ -135,6 +207,7 @@ static void rng_sock_destruct(struct sock *sk)
>  static int rng_accept_parent(void *private, struct sock *sk)
>  {
>         struct rng_ctx *ctx;
> +       struct rng_parent_ctx *pctx = private;
>         struct alg_sock *ask = alg_sk(sk);
>         unsigned int len = sizeof(*ctx);
>
> @@ -150,7 +223,9 @@ static int rng_accept_parent(void *private, struct sock *sk)
>          * state of the RNG.
>          */
>
> -       ctx->drng = private;
> +       ctx->drng = pctx->drng;
> +       ctx->addtl = NULL;
> +       ctx->addtl_len = 0;
>         ask->private = ctx;
>         sk->sk_destruct = rng_sock_destruct;
>
> @@ -159,18 +234,53 @@ static int rng_accept_parent(void *private, struct sock *sk)
>
>  static int rng_setkey(void *private, const u8 *seed, unsigned int seedlen)
>  {
> +       struct rng_parent_ctx *pctx = private;
>         /*
>          * Check whether seedlen is of sufficient size is done in RNG
>          * implementations.
>          */
> -       return crypto_rng_reset(private, seed, seedlen);
> +       return crypto_rng_reset(pctx->drng, seed, seedlen);
> +}
> +
> +#ifdef CONFIG_CRYPTO_USER_API_CAVP_DRBG
> +static int rng_setentropy(void *private, const u8 *entropy, unsigned int len)
> +{
> +       struct rng_parent_ctx *pctx = private;
> +       u8 *kentropy = NULL;
> +
> +       if (!capable(CAP_SYS_ADMIN))
> +               return -EACCES;
> +
> +       if (pctx->entropy)
> +               return -EINVAL;
> +
> +       if (len > MAXSIZE)
> +               return -EMSGSIZE;
> +
> +       if (len) {
> +               kentropy = memdup_user(entropy, len);
> +               if (IS_ERR(kentropy))
> +                       return PTR_ERR(kentropy);
> +       }
> +
> +       crypto_rng_alg(pctx->drng)->set_ent(pctx->drng, kentropy, len);
> +       /*
> +        * Since rng doesn't perform any memory management for the entropy
> +        * buffer, save kentropy pointer to pctx now to free it after use.
> +        */
> +       pctx->entropy = kentropy;
> +       return 0;
>  }
> +#endif
>
>  static const struct af_alg_type algif_type_rng = {
>         .bind           =       rng_bind,
>         .release        =       rng_release,
>         .accept         =       rng_accept_parent,
>         .setkey         =       rng_setkey,
> +#ifdef CONFIG_CRYPTO_USER_API_CAVP_DRBG
> +       .setentropy     =       rng_setentropy,
> +#endif
>         .ops            =       &algif_rng_ops,
>         .name           =       "rng",
>         .owner          =       THIS_MODULE
> diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
> index 56527c85d122..9e5c8ac53c59 100644
> --- a/include/crypto/if_alg.h
> +++ b/include/crypto/if_alg.h
> @@ -46,6 +46,7 @@ struct af_alg_type {
>         void *(*bind)(const char *name, u32 type, u32 mask);
>         void (*release)(void *private);
>         int (*setkey)(void *private, const u8 *key, unsigned int keylen);
> +       int (*setentropy)(void *private, const u8 *entropy, unsigned int len);
>         int (*accept)(void *private, struct sock *sk);
>         int (*accept_nokey)(void *private, struct sock *sk);
>         int (*setauthsize)(void *private, unsigned int authsize);
> diff --git a/include/uapi/linux/if_alg.h b/include/uapi/linux/if_alg.h
> index bc2bcdec377b..60b7c2efd921 100644
> --- a/include/uapi/linux/if_alg.h
> +++ b/include/uapi/linux/if_alg.h
> @@ -35,6 +35,7 @@ struct af_alg_iv {
>  #define ALG_SET_OP                     3
>  #define ALG_SET_AEAD_ASSOCLEN          4
>  #define ALG_SET_AEAD_AUTHSIZE          5
> +#define ALG_SET_DRBG_ENTROPY           6
>
>  /* Operations */
>  #define ALG_OP_DECRYPT                 0
> --
> 2.28.0.rc0.142.g3c755180ce-goog
>
