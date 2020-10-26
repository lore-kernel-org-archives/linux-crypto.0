Return-Path: <SRS0=A9yi=EB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA76EC2D0A3
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 07:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77B8E223AC
	for <linux-crypto@archiver.kernel.org>; Mon, 26 Oct 2020 07:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603699121;
	bh=zSAdz9M3Ny2yCTWEn+4I7wJxzYlweN57DhgwF2riu9c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=xWvTn9OjcJ5cYAVd6zlL6XTbHw++5K57aK9DyR8FW41UiDLWoHQ75MKQZ8SKO3p5u
	 /Jt3lpdVXUwEf7grtILpfFzUBnvmPyQ/AYTCE+w1Inj2aJnZIRpO/XmW0T9hvcr8qG
	 dEJWtpp9DnygCb4H9gIQ5hv8b9QA85l3QFW04POA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1771069AbgJZH6k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 26 Oct 2020 03:58:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:59144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1771066AbgJZH6k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 26 Oct 2020 03:58:40 -0400
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C400D223AC;
        Mon, 26 Oct 2020 07:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603699118;
        bh=zSAdz9M3Ny2yCTWEn+4I7wJxzYlweN57DhgwF2riu9c=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Kjbpzf3rwhvJ9N59H11nIL7wG8wN66CDMxie9ubvgSjvyXNuOu0GIxDSBDzHPAMTZ
         BupVpJBrOpp+9LzwRXSLg5PjU8nHf/A4kK8JGTU0dCpudZM0XBEgbGaLZ3CKEeIX1m
         bnrQQPjI87AclnI0Dyy5Y2CWNV9PXkDoqcHESC6E=
Received: by mail-ot1-f49.google.com with SMTP id f37so7193700otf.12;
        Mon, 26 Oct 2020 00:58:38 -0700 (PDT)
X-Gm-Message-State: AOAM5310IihoUIQdaNiFOdSL1w6cxTHgTo8BLbmfrzf4gLm367SQDTSs
        xvWkYukLRy1asyrNi+XDze9DmBBHNDAM40m/RKQ=
X-Google-Smtp-Source: ABdhPJysYbZOeMaE3htMLoBKFtWiGDUYako52XSPN1BqBfdtmBl7nkZefS2Pdzg/EQJjGD0NMMrFQrZCdSVAsZse/rQ=
X-Received: by 2002:a05:6830:4028:: with SMTP id i8mr10151804ots.90.1603699117992;
 Mon, 26 Oct 2020 00:58:37 -0700 (PDT)
MIME-Version: 1.0
References: <20201025143119.1054168-1-nivedita@alum.mit.edu> <20201025143119.1054168-3-nivedita@alum.mit.edu>
In-Reply-To: <20201025143119.1054168-3-nivedita@alum.mit.edu>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 26 Oct 2020 08:58:27 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEqJFaQkdv04wE2JHKxU7SH+W8KR9tYrBzbghRp0Zg_-g@mail.gmail.com>
Message-ID: <CAMj1kXEqJFaQkdv04wE2JHKxU7SH+W8KR9tYrBzbghRp0Zg_-g@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] crypto: Use memzero_explicit() for clearing state
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        David Laight <David.Laight@aculab.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 25 Oct 2020 at 15:31, Arvind Sankar <nivedita@alum.mit.edu> wrote:
>
> Without the barrier_data() inside memzero_explicit(), the compiler may
> optimize away the state-clearing if it can tell that the state is not
> used afterwards.
>
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

I agree with Eric that, even though there are cases where it is
unlikely that the compiler could elide an ordinary memset() or struct
assignment (even under LTO), using memzero_explicit() is better in
these cases, as it also clarifies the intent of the operation, and
doesn't result in worse code now that memzero_explicit() is a static
inline around memset() and a barrier.





> ---
>  arch/arm64/crypto/ghash-ce-glue.c | 2 +-
>  arch/arm64/crypto/poly1305-glue.c | 2 +-
>  arch/arm64/crypto/sha3-ce-glue.c  | 2 +-
>  arch/x86/crypto/poly1305_glue.c   | 2 +-
>  include/crypto/sha1_base.h        | 3 ++-
>  include/crypto/sha256_base.h      | 3 ++-
>  include/crypto/sha512_base.h      | 3 ++-
>  include/crypto/sm3_base.h         | 3 ++-
>  8 files changed, 12 insertions(+), 8 deletions(-)
>
> diff --git a/arch/arm64/crypto/ghash-ce-glue.c b/arch/arm64/crypto/ghash-ce-glue.c
> index 8536008e3e35..2427e2f3a9a1 100644
> --- a/arch/arm64/crypto/ghash-ce-glue.c
> +++ b/arch/arm64/crypto/ghash-ce-glue.c
> @@ -168,7 +168,7 @@ static int ghash_final(struct shash_desc *desc, u8 *dst)
>         put_unaligned_be64(ctx->digest[1], dst);
>         put_unaligned_be64(ctx->digest[0], dst + 8);
>
> -       *ctx = (struct ghash_desc_ctx){};
> +       memzero_explicit(ctx, sizeof(*ctx));
>         return 0;
>  }
>
> diff --git a/arch/arm64/crypto/poly1305-glue.c b/arch/arm64/crypto/poly1305-glue.c
> index f33ada70c4ed..683de671741a 100644
> --- a/arch/arm64/crypto/poly1305-glue.c
> +++ b/arch/arm64/crypto/poly1305-glue.c
> @@ -177,7 +177,7 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
>         }
>
>         poly1305_emit(&dctx->h, dst, dctx->s);
> -       *dctx = (struct poly1305_desc_ctx){};
> +       memzero_explicit(dctx, sizeof(*dctx));
>  }
>  EXPORT_SYMBOL(poly1305_final_arch);
>
> diff --git a/arch/arm64/crypto/sha3-ce-glue.c b/arch/arm64/crypto/sha3-ce-glue.c
> index 9a4bbfc45f40..e5a2936f0886 100644
> --- a/arch/arm64/crypto/sha3-ce-glue.c
> +++ b/arch/arm64/crypto/sha3-ce-glue.c
> @@ -94,7 +94,7 @@ static int sha3_final(struct shash_desc *desc, u8 *out)
>         if (digest_size & 4)
>                 put_unaligned_le32(sctx->st[i], (__le32 *)digest);
>
> -       *sctx = (struct sha3_state){};
> +       memzero_explicit(sctx, sizeof(*sctx));
>         return 0;
>  }
>
> diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
> index e508dbd91813..64d09520d279 100644
> --- a/arch/x86/crypto/poly1305_glue.c
> +++ b/arch/x86/crypto/poly1305_glue.c
> @@ -209,7 +209,7 @@ void poly1305_final_arch(struct poly1305_desc_ctx *dctx, u8 *dst)
>         }
>
>         poly1305_simd_emit(&dctx->h, dst, dctx->s);
> -       *dctx = (struct poly1305_desc_ctx){};
> +       memzero_explicit(dctx, sizeof(*dctx));
>  }
>  EXPORT_SYMBOL(poly1305_final_arch);
>
> diff --git a/include/crypto/sha1_base.h b/include/crypto/sha1_base.h
> index 20fd1f7468af..a5d6033efef7 100644
> --- a/include/crypto/sha1_base.h
> +++ b/include/crypto/sha1_base.h
> @@ -12,6 +12,7 @@
>  #include <crypto/sha.h>
>  #include <linux/crypto.h>
>  #include <linux/module.h>
> +#include <linux/string.h>
>
>  #include <asm/unaligned.h>
>
> @@ -101,7 +102,7 @@ static inline int sha1_base_finish(struct shash_desc *desc, u8 *out)
>         for (i = 0; i < SHA1_DIGEST_SIZE / sizeof(__be32); i++)
>                 put_unaligned_be32(sctx->state[i], digest++);
>
> -       *sctx = (struct sha1_state){};
> +       memzero_explicit(sctx, sizeof(*sctx));
>         return 0;
>  }
>
> diff --git a/include/crypto/sha256_base.h b/include/crypto/sha256_base.h
> index 6ded110783ae..93f9fd21cc06 100644
> --- a/include/crypto/sha256_base.h
> +++ b/include/crypto/sha256_base.h
> @@ -12,6 +12,7 @@
>  #include <crypto/sha.h>
>  #include <linux/crypto.h>
>  #include <linux/module.h>
> +#include <linux/string.h>
>
>  #include <asm/unaligned.h>
>
> @@ -105,7 +106,7 @@ static inline int sha256_base_finish(struct shash_desc *desc, u8 *out)
>         for (i = 0; digest_size > 0; i++, digest_size -= sizeof(__be32))
>                 put_unaligned_be32(sctx->state[i], digest++);
>
> -       *sctx = (struct sha256_state){};
> +       memzero_explicit(sctx, sizeof(*sctx));
>         return 0;
>  }
>
> diff --git a/include/crypto/sha512_base.h b/include/crypto/sha512_base.h
> index fb19c77494dc..93ab73baa38e 100644
> --- a/include/crypto/sha512_base.h
> +++ b/include/crypto/sha512_base.h
> @@ -12,6 +12,7 @@
>  #include <crypto/sha.h>
>  #include <linux/crypto.h>
>  #include <linux/module.h>
> +#include <linux/string.h>
>
>  #include <asm/unaligned.h>
>
> @@ -126,7 +127,7 @@ static inline int sha512_base_finish(struct shash_desc *desc, u8 *out)
>         for (i = 0; digest_size > 0; i++, digest_size -= sizeof(__be64))
>                 put_unaligned_be64(sctx->state[i], digest++);
>
> -       *sctx = (struct sha512_state){};
> +       memzero_explicit(sctx, sizeof(*sctx));
>         return 0;
>  }
>
> diff --git a/include/crypto/sm3_base.h b/include/crypto/sm3_base.h
> index 1cbf9aa1fe52..2f3a32ab97bb 100644
> --- a/include/crypto/sm3_base.h
> +++ b/include/crypto/sm3_base.h
> @@ -13,6 +13,7 @@
>  #include <crypto/sm3.h>
>  #include <linux/crypto.h>
>  #include <linux/module.h>
> +#include <linux/string.h>
>  #include <asm/unaligned.h>
>
>  typedef void (sm3_block_fn)(struct sm3_state *sst, u8 const *src, int blocks);
> @@ -104,7 +105,7 @@ static inline int sm3_base_finish(struct shash_desc *desc, u8 *out)
>         for (i = 0; i < SM3_DIGEST_SIZE / sizeof(__be32); i++)
>                 put_unaligned_be32(sctx->state[i], digest++);
>
> -       *sctx = (struct sm3_state){};
> +       memzero_explicit(sctx, sizeof(*sctx));
>         return 0;
>  }
>
> --
> 2.26.2
>
