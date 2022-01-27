Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0429C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 09:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238558AbiA0J3u (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 04:29:50 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33542 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238542AbiA0J3t (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 04:29:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A37DB821BF
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 09:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C86C340E6
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 09:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643275785;
        bh=7feCmwJqck6uLnrAgpCxXAd4cMngaeqhUE+/An7UoiM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LsQPXmGTgUeonwqBYE8hfrHMdVZh4qMUiUlSYQuPvH0Xf7/NgDQ+iPJrnnMM+oZLs
         SaquPvyVrHxN6l2r+8eq6aWOb8u2HXB6pRvYcWR4K32KaPAUKZv6UBaF4SETki88KQ
         xxmDhOQKW1etEoGlI6E/TByOdsVOw6ebXZNKTBut6J/JW8vmZP3OS0UQz76eCEu/Nv
         0+7MvDi4AOkfskynLZ1Q/yXPdn+LtQdYauV0klS78DI2mONR0U+FSft6w8UImO+OfT
         rwFFRVy+HHPWgOaMOokym8Zt3SDpyeccAN7meYFQJ2A4vnd7HT/uu73+DT7eWeDdj2
         XWdFWQiIGmqfQ==
Received: by mail-wm1-f51.google.com with SMTP id l35-20020a05600c1d2300b0034d477271c1so1433198wms.3
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 01:29:45 -0800 (PST)
X-Gm-Message-State: AOAM531991+znLSM4MZU1TkJAqRMNCkgjjISMELKAgTh7k9Oqx09RWY6
        7SH4utUh1wNg+4BuozOy0uGcDdgcxpsrMju2mJM=
X-Google-Smtp-Source: ABdhPJy2zNL7eEwu8G3AWxEqycEzx0C8fyiLweF5Ix3PNQzgQBZirS58efQldJYdZVi27twM10aR/YI2cTGVJHxxotE=
X-Received: by 2002:a05:600c:a47:: with SMTP id c7mr2413725wmq.25.1643275783105;
 Thu, 27 Jan 2022 01:29:43 -0800 (PST)
MIME-Version: 1.0
References: <20220125014422.80552-1-nhuck@google.com> <20220125014422.80552-4-nhuck@google.com>
In-Reply-To: <20220125014422.80552-4-nhuck@google.com>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 27 Jan 2022 10:29:31 +0100
X-Gmail-Original-Message-ID: <CAMj1kXG5vQ6SmRPPYjd4gg4O7gtjQg_NCOtEjY_EZoCPohcf2w@mail.gmail.com>
Message-ID: <CAMj1kXG5vQ6SmRPPYjd4gg4O7gtjQg_NCOtEjY_EZoCPohcf2w@mail.gmail.com>
Subject: Re: [RFC PATCH 3/7] crypto: hctr2 - Add HCTR2 support
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Paul Crowley <paulcrowley@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 25 Jan 2022 at 02:47, Nathan Huckleberry <nhuck@google.com> wrote:
>
> Add support for HCTR2 as a template.  HCTR2 is a length-preserving
> encryption mode that is efficient on processors with instructions to
> accelerate AES and carryless multiplication, e.g. x86 processors with
> AES-NI and CLMUL, and ARM processors with the ARMv8 Crypto Extensions.
>
> As a length-preserving encryption mode, HCTR2 is suitable for
> applications such as storage encryption where ciphertext expansion is
> not possible, and thus authenticated encryption cannot be used.
> Currently, such applications usually use XTS, or in some cases Adiantum.
> XTS has the disadvantage that it is a narrow-block mode: a bitflip will
> only change 16 bytes in the resulting ciphertext or plaintext.  This
> reveals more information to an attacker than necessary.
>
> HCTR2 is a wide-block mode, so it provides a stronger security property:
> a bitflip will change the entire message.  HCTR2 is somewhat similar to
> Adiantum, which is also a wide-block mode.  However, HCTR2 is designed
> to take advantage of existing crypto instructions, while Adiantum
> targets devices without such hardware support.  Adiantum is also
> designed with longer messages in mind, while HCTR2 is designed to be
> efficient even on short messages.
>
> HCTR2 requires POLYVAL and XCTR as components.  More information on
> HCTR2 can be found here: Length-preserving encryption with HCTR2:
> https://eprint.iacr.org/2021/1441.pdf
>
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> ---
>  crypto/Kconfig   |  11 +
>  crypto/Makefile  |   1 +
>  crypto/hctr2.c   | 475 ++++++++++++++++++++++++++++
>  crypto/tcrypt.c  |   5 +
>  crypto/testmgr.c |   6 +
>  crypto/testmgr.h | 787 +++++++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 1285 insertions(+)
>  create mode 100644 crypto/hctr2.c
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 051060cd5e21..3cdb6c351062 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -524,6 +524,17 @@ config CRYPTO_ADIANTUM
>
>           If unsure, say N.
>
> +config CRYPTO_HCTR2
> +       tristate "HCTR2 support"
> +       select CRYPTO_XCTR
> +       select CRYPTO_POLYVAL
> +       select CRYPTO_MANAGER
> +       help
> +         HCTR2 is a length-preserving encryption mode that is efficient =
on
> +         processors with instructions to accelerate AES and carryless
> +         multiplication, e.g. x86 processors with AES-NI and CLMUL, and =
ARM
> +         processors with the ARMv8 crypto extensions.
> +
>  config CRYPTO_ESSIV
>         tristate "ESSIV support for block encryption"
>         select CRYPTO_AUTHENC
> diff --git a/crypto/Makefile b/crypto/Makefile
> index 561f901a91d4..2dca9dbdede6 100644
> --- a/crypto/Makefile
> +++ b/crypto/Makefile
> @@ -94,6 +94,7 @@ obj-$(CONFIG_CRYPTO_LRW) +=3D lrw.o
>  obj-$(CONFIG_CRYPTO_XTS) +=3D xts.o
>  obj-$(CONFIG_CRYPTO_CTR) +=3D ctr.o
>  obj-$(CONFIG_CRYPTO_XCTR) +=3D xctr.o
> +obj-$(CONFIG_CRYPTO_HCTR2) +=3D hctr2.o
>  obj-$(CONFIG_CRYPTO_KEYWRAP) +=3D keywrap.o
>  obj-$(CONFIG_CRYPTO_ADIANTUM) +=3D adiantum.o
>  obj-$(CONFIG_CRYPTO_NHPOLY1305) +=3D nhpoly1305.o
> diff --git a/crypto/hctr2.c b/crypto/hctr2.c
> new file mode 100644
> index 000000000000..af43f81b68f3
> --- /dev/null
> +++ b/crypto/hctr2.c
> @@ -0,0 +1,475 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * HCTR2 length-preserving encryption mode
> + *
> + * Copyright 2021 Google LLC

Off by one?

> + */
> +
> +
> +/*
> + * HCTR2 is a length-preserving encryption mode that is efficient on
> + * processors with instructions to accelerate aes and carryless
> + * multiplication, e.g. x86 processors with AES-NI and CLMUL, and ARM
> + * processors with the ARMv8 crypto extensions.
> + *
> + * Length-preserving encryption with HCTR2
> + *     (https://eprint.iacr.org/2021/1441.pdf)
> + *
> + *     HCTR2 has a strict set of requirements for the hash function. For=
 this
> + *     purpose we only allow POLYVAL. To avoid misuse, XCTR is required =
as
> + *     specified in the HCTR2 paper, though theoretically there is a lar=
ger class
> + *     of algorithms that could be used.
> + */
> +
> +#include <crypto/internal/cipher.h>
> +#include <crypto/internal/hash.h>
> +#include <crypto/internal/skcipher.h>
> +#include <crypto/polyval.h>
> +#include <crypto/scatterwalk.h>
> +#include <linux/module.h>
> +
> +#define BLOCKCIPHER_BLOCK_SIZE         16
> +
> +/*
> + * The specification allows variable-length tweaks, but Linux's crypto A=
PI
> + * currently only allows algorithms to support a single length.  The "na=
tural"
> + * tweak length for HCTR2 is 16, since that fits into one POLYVAL block =
for
> + * the best performance.  But longer tweaks are useful for fscrypt, to a=
void
> + * needing to derive per-file keys.  So instead we use two blocks, or 32=
 bytes.
> + */
> +#define TWEAK_SIZE             32
> +
> +struct hctr2_instance_ctx {
> +       struct crypto_cipher_spawn blockcipher_spawn;
> +       struct crypto_skcipher_spawn streamcipher_spawn;
> +       struct crypto_shash_spawn hash_spawn;
> +};
> +
> +struct hctr2_tfm_ctx {
> +       struct crypto_cipher *blockcipher;
> +       struct crypto_skcipher *streamcipher;
> +       struct crypto_shash *hash;
> +       u8 L[BLOCKCIPHER_BLOCK_SIZE];
> +};
> +
> +struct hctr2_request_ctx {
> +       u8 first_block[BLOCKCIPHER_BLOCK_SIZE];
> +       struct scatterlist *bulk_part_dst;
> +       struct scatterlist *bulk_part_src;
> +       struct scatterlist sg_src[2];
> +       struct scatterlist sg_dst[2];
> +       /* Sub-requests, must be last */
> +       union {
> +               struct shash_desc hash_desc;
> +               struct skcipher_request streamcipher_req;
> +       } u;
> +};
> +
> +static int hctr2_setkey(struct crypto_skcipher *tfm, const u8 *key,
> +                       unsigned int keylen)
> +{
> +       struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
> +       u8 hbar[BLOCKCIPHER_BLOCK_SIZE];
> +       int err;
> +
> +       crypto_cipher_clear_flags(tctx->blockcipher, CRYPTO_TFM_REQ_MASK)=
;
> +       crypto_cipher_set_flags(tctx->blockcipher,
> +                               crypto_skcipher_get_flags(tfm) &
> +                               CRYPTO_TFM_REQ_MASK);
> +       err =3D crypto_cipher_setkey(tctx->blockcipher, key, keylen);
> +       if (err)
> +               return err;
> +
> +       crypto_skcipher_clear_flags(tctx->streamcipher, CRYPTO_TFM_REQ_MA=
SK);
> +       crypto_skcipher_set_flags(tctx->streamcipher,
> +                                 crypto_skcipher_get_flags(tfm) &
> +                                 CRYPTO_TFM_REQ_MASK);
> +       err =3D crypto_skcipher_setkey(tctx->streamcipher, key, keylen);
> +       if (err)
> +               return err;
> +
> +       memset(tctx->L, 0, sizeof(tctx->L));
> +       memset(hbar, 0, sizeof(hbar));
> +       tctx->L[0] =3D 0x01;
> +       crypto_cipher_encrypt_one(tctx->blockcipher, tctx->L, tctx->L);
> +       crypto_cipher_encrypt_one(tctx->blockcipher, hbar, hbar);
> +
> +       crypto_shash_clear_flags(tctx->hash, CRYPTO_TFM_REQ_MASK);
> +       crypto_shash_set_flags(tctx->hash, crypto_skcipher_get_flags(tfm)=
 &
> +                              CRYPTO_TFM_REQ_MASK);
> +       err =3D crypto_shash_setkey(tctx->hash, hbar, BLOCKCIPHER_BLOCK_S=
IZE);
> +       return err;
> +}
> +
> +static int hctr2_hash_tweak(struct skcipher_request *req, u8 *iv)
> +{
> +       u64 tweak_length_part[2];
> +       struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
> +       const struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
> +       struct hctr2_request_ctx *rctx =3D skcipher_request_ctx(req);
> +       struct shash_desc *hash_desc =3D &rctx->u.hash_desc;
> +       int err;
> +
> +       memset(tweak_length_part, 0, sizeof(tweak_length_part));
> +       if (req->cryptlen % POLYVAL_BLOCK_SIZE =3D=3D 0)
> +               tweak_length_part[0] =3D cpu_to_le64(TWEAK_SIZE * 8 * 2 +=
 2);
> +       else
> +               tweak_length_part[0] =3D cpu_to_le64(TWEAK_SIZE * 8 * 2 +=
 3);
> +
> +       hash_desc->tfm =3D tctx->hash;
> +       err =3D crypto_shash_init(hash_desc);
> +       if (err)
> +               return err;
> +
> +       err =3D crypto_shash_update(hash_desc, (u8 *)tweak_length_part, s=
izeof(tweak_length_part));
> +       if (err)
> +               return err;
> +       err =3D crypto_shash_update(hash_desc, iv, TWEAK_SIZE);
> +       return err;
> +}
> +
> +static int hctr2_hash_message(struct skcipher_request *req,
> +                             struct scatterlist *sgl,
> +                             u8 digest[POLYVAL_DIGEST_SIZE])
> +{
> +       u8 padding[BLOCKCIPHER_BLOCK_SIZE];
> +       struct hctr2_request_ctx *rctx =3D skcipher_request_ctx(req);
> +       struct shash_desc *hash_desc =3D &rctx->u.hash_desc;
> +       const unsigned int bulk_len =3D req->cryptlen - BLOCKCIPHER_BLOCK=
_SIZE;
> +       struct sg_mapping_iter miter;
> +       unsigned int remainder =3D bulk_len % BLOCKCIPHER_BLOCK_SIZE;
> +       int err;
> +
> +       sg_miter_start(&miter, sgl, sg_nents(sgl),
> +                      SG_MITER_FROM_SG | SG_MITER_ATOMIC);

Note to maintainers: this adds another use of kmap_atomic(), meaning
that this executes with preemption disabled even on !HIGHMEM
architectures.

Is there a plan to address that? Should we add another SG_MITER flag
that uses kmap_local() instead?

> +       while (sg_miter_next(&miter)) {
> +               err =3D crypto_shash_update(hash_desc, miter.addr, miter.=
length);
> +               if (err)
> +                       break;
> +       }
> +       sg_miter_stop(&miter);
> +       if (err)
> +               return err;
> +
> +       if (remainder) {
> +               memset(padding, 0, BLOCKCIPHER_BLOCK_SIZE);
> +               padding[0] =3D 0x01;
> +               err =3D crypto_shash_update(hash_desc, padding, BLOCKCIPH=
ER_BLOCK_SIZE - remainder);
> +               if (err)
> +                       return err;
> +       }
> +       return crypto_shash_final(hash_desc, digest);
> +}
> +
> +static int hctr2_finish(struct skcipher_request *req)
> +{
> +       struct hctr2_request_ctx *rctx =3D skcipher_request_ctx(req);
> +       u8 digest[POLYVAL_DIGEST_SIZE];
> +       int err;
> +
> +       err =3D hctr2_hash_tweak(req, req->iv);
> +       if (err)
> +               return err;
> +       err =3D hctr2_hash_message(req, rctx->bulk_part_dst, digest);
> +       if (err)
> +               return err;
> +       crypto_xor(rctx->first_block, digest, BLOCKCIPHER_BLOCK_SIZE);
> +
> +       scatterwalk_map_and_copy(rctx->first_block, req->dst,
> +                                0, BLOCKCIPHER_BLOCK_SIZE, 1);
> +       return 0;
> +}
> +
> +static void hctr2_streamcipher_done(struct crypto_async_request *areq,
> +                                   int err)
> +{
> +       struct skcipher_request *req =3D areq->data;
> +
> +       if (!err)
> +               err =3D hctr2_finish(req);
> +
> +       skcipher_request_complete(req, err);
> +}
> +
> +static int hctr2_crypt(struct skcipher_request *req, bool enc)
> +{
> +       struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
> +       const struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
> +       struct hctr2_request_ctx *rctx =3D skcipher_request_ctx(req);
> +       u8 digest[POLYVAL_DIGEST_SIZE];
> +       int bulk_len =3D req->cryptlen - BLOCKCIPHER_BLOCK_SIZE;
> +       int err;
> +
> +       // Requests must be at least one block
> +       if (req->cryptlen < BLOCKCIPHER_BLOCK_SIZE)
> +               return -EINVAL;
> +
> +       scatterwalk_map_and_copy(rctx->first_block, req->src,
> +                                0, BLOCKCIPHER_BLOCK_SIZE, 0);
> +       rctx->bulk_part_src =3D scatterwalk_ffwd(rctx->sg_src, req->src, =
BLOCKCIPHER_BLOCK_SIZE);
> +       rctx->bulk_part_dst =3D scatterwalk_ffwd(rctx->sg_dst, req->dst, =
BLOCKCIPHER_BLOCK_SIZE);
> +
> +       err =3D hctr2_hash_tweak(req, req->iv);
> +       if (err)
> +               return err;
> +       err =3D hctr2_hash_message(req, rctx->bulk_part_src, digest);
> +       if (err)
> +               return err;
> +       crypto_xor(digest, rctx->first_block, BLOCKCIPHER_BLOCK_SIZE);
> +
> +       if (enc)
> +               crypto_cipher_encrypt_one(tctx->blockcipher, rctx->first_=
block, digest);
> +       else
> +               crypto_cipher_decrypt_one(tctx->blockcipher, rctx->first_=
block, digest);
> +
> +       crypto_xor(digest, rctx->first_block, BLOCKCIPHER_BLOCK_SIZE);
> +       crypto_xor(digest, tctx->L, BLOCKCIPHER_BLOCK_SIZE);
> +
> +       skcipher_request_set_tfm(&rctx->u.streamcipher_req, tctx->streamc=
ipher);
> +       skcipher_request_set_crypt(&rctx->u.streamcipher_req, rctx->bulk_=
part_src,
> +                                  rctx->bulk_part_dst, bulk_len, digest)=
;
> +       skcipher_request_set_callback(&rctx->u.streamcipher_req,
> +                                     req->base.flags,
> +                                     hctr2_streamcipher_done, req);
> +       return crypto_skcipher_encrypt(&rctx->u.streamcipher_req) ?:
> +               hctr2_finish(req);
> +}
> +
> +static int hctr2_encrypt(struct skcipher_request *req)
> +{
> +       return hctr2_crypt(req, true);
> +}
> +
> +static int hctr2_decrypt(struct skcipher_request *req)
> +{
> +       return hctr2_crypt(req, false);
> +}
> +
> +static int hctr2_init_tfm(struct crypto_skcipher *tfm)
> +{
> +       struct skcipher_instance *inst =3D skcipher_alg_instance(tfm);
> +       struct hctr2_instance_ctx *ictx =3D skcipher_instance_ctx(inst);
> +       struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
> +       struct crypto_skcipher *streamcipher;
> +       struct crypto_cipher *blockcipher;
> +       struct crypto_shash *hash;
> +       unsigned int subreq_size;
> +       int err;
> +
> +       streamcipher =3D crypto_spawn_skcipher(&ictx->streamcipher_spawn)=
;
> +       if (IS_ERR(streamcipher))
> +               return PTR_ERR(streamcipher);
> +
> +       blockcipher =3D crypto_spawn_cipher(&ictx->blockcipher_spawn);
> +       if (IS_ERR(blockcipher)) {
> +               err =3D PTR_ERR(blockcipher);
> +               goto err_free_streamcipher;
> +       }
> +
> +       hash =3D crypto_spawn_shash(&ictx->hash_spawn);
> +       if (IS_ERR(hash)) {
> +               err =3D PTR_ERR(hash);
> +               goto err_free_blockcipher;
> +       }
> +
> +       tctx->streamcipher =3D streamcipher;
> +       tctx->blockcipher =3D blockcipher;
> +       tctx->hash =3D hash;
> +
> +       BUILD_BUG_ON(offsetofend(struct hctr2_request_ctx, u) !=3D
> +                                sizeof(struct hctr2_request_ctx));
> +       subreq_size =3D max(sizeof_field(struct hctr2_request_ctx, u.hash=
_desc) +
> +                         crypto_shash_descsize(hash), sizeof_field(struc=
t
> +                         hctr2_request_ctx, u.streamcipher_req) +
> +                         crypto_skcipher_reqsize(streamcipher));
> +
> +       crypto_skcipher_set_reqsize(tfm, offsetof(struct hctr2_request_ct=
x, u) +
> +                                   subreq_size);
> +       return 0;
> +
> +err_free_blockcipher:
> +       crypto_free_cipher(blockcipher);
> +err_free_streamcipher:
> +       crypto_free_skcipher(streamcipher);
> +       return err;
> +}
> +
> +static void hctr2_exit_tfm(struct crypto_skcipher *tfm)
> +{
> +       struct hctr2_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
> +
> +       crypto_free_cipher(tctx->blockcipher);
> +       crypto_free_skcipher(tctx->streamcipher);
> +       crypto_free_shash(tctx->hash);
> +}
> +
> +static void hctr2_free_instance(struct skcipher_instance *inst)
> +{
> +       struct hctr2_instance_ctx *ictx =3D skcipher_instance_ctx(inst);
> +
> +       crypto_drop_cipher(&ictx->blockcipher_spawn);
> +       crypto_drop_skcipher(&ictx->streamcipher_spawn);
> +       crypto_drop_shash(&ictx->hash_spawn);
> +       kfree(inst);
> +}
> +
> +/*
> + * Check for a supported set of inner algorithms.
> + * See the comment at the beginning of this file.
> + */
> +static bool hctr2_supported_algorithms(struct skcipher_alg *streamcipher=
_alg,
> +                                      struct crypto_alg *blockcipher_alg=
,
> +                                      struct shash_alg *hash_alg)
> +{
> +       if (strncmp(streamcipher_alg->base.cra_name, "xctr(", 4) !=3D 0)
> +               return false;
> +
> +       if (blockcipher_alg->cra_blocksize !=3D BLOCKCIPHER_BLOCK_SIZE)
> +               return false;
> +
> +       if (strcmp(hash_alg->base.cra_name, "polyval") !=3D 0)
> +               return false;
> +
> +       return true;
> +}
> +
> +static int hctr2_create_common(struct crypto_template *tmpl,
> +                              struct rtattr **tb,
> +                              const char *blockcipher_name,
> +                              const char *streamcipher_name,
> +                              const char *polyval_name)
> +{
> +       u32 mask;
> +       struct skcipher_instance *inst;
> +       struct hctr2_instance_ctx *ictx;
> +       struct skcipher_alg *streamcipher_alg;
> +       struct crypto_alg *blockcipher_alg;
> +       struct shash_alg *hash_alg;
> +       int err;
> +
> +       err =3D crypto_check_attr_type(tb, CRYPTO_ALG_TYPE_SKCIPHER, &mas=
k);
> +       if (err)
> +               return err;
> +
> +       inst =3D kzalloc(sizeof(*inst) + sizeof(*ictx), GFP_KERNEL);
> +       if (!inst)
> +               return -ENOMEM;
> +       ictx =3D skcipher_instance_ctx(inst);
> +
> +       /* Stream cipher, xctr(block_cipher) */
> +       err =3D crypto_grab_skcipher(&ictx->streamcipher_spawn,
> +                                  skcipher_crypto_instance(inst),
> +                                  streamcipher_name, 0, mask);
> +       if (err)
> +               goto err_free_inst;
> +       streamcipher_alg =3D crypto_spawn_skcipher_alg(&ictx->streamciphe=
r_spawn);
> +
> +       /* Block cipher, e.g. "aes" */
> +       err =3D crypto_grab_cipher(&ictx->blockcipher_spawn,
> +                                skcipher_crypto_instance(inst),
> +                                blockcipher_name, 0, mask);
> +       if (err)
> +               goto err_free_inst;
> +       blockcipher_alg =3D crypto_spawn_cipher_alg(&ictx->blockcipher_sp=
awn);
> +
> +       /* Polyval =CE=B5-=E2=88=86U hash function */
> +       err =3D crypto_grab_shash(&ictx->hash_spawn,
> +                               skcipher_crypto_instance(inst),
> +                               polyval_name, 0, mask);
> +       if (err)
> +               goto err_free_inst;
> +       hash_alg =3D crypto_spawn_shash_alg(&ictx->hash_spawn);
> +
> +       /* Check the set of algorithms */
> +       if (!hctr2_supported_algorithms(streamcipher_alg, blockcipher_alg=
,
> +                                       hash_alg)) {
> +               pr_warn("Unsupported HCTR2 instantiation: (%s,%s,%s)\n",
> +                       streamcipher_alg->base.cra_name,
> +                       blockcipher_alg->cra_name, hash_alg->base.cra_nam=
e);
> +               err =3D -EINVAL;
> +               goto err_free_inst;
> +       }
> +
> +       /* Instance fields */
> +
> +       err =3D -ENAMETOOLONG;
> +       if (snprintf(inst->alg.base.cra_name, CRYPTO_MAX_ALG_NAME,
> +                                "hctr2(%s)", blockcipher_alg->cra_name) =
>=3D CRYPTO_MAX_ALG_NAME)
> +               goto err_free_inst;
> +       if (snprintf(inst->alg.base.cra_driver_name, CRYPTO_MAX_ALG_NAME,
> +                    "hctr2(%s,%s,%s)",
> +                    blockcipher_alg->cra_driver_name,
> +                    streamcipher_alg->base.cra_driver_name,
> +                    hash_alg->base.cra_driver_name) >=3D CRYPTO_MAX_ALG_=
NAME)
> +               goto err_free_inst;
> +
> +       inst->alg.base.cra_blocksize =3D BLOCKCIPHER_BLOCK_SIZE;
> +       inst->alg.base.cra_ctxsize =3D sizeof(struct hctr2_tfm_ctx);
> +       inst->alg.base.cra_alignmask =3D streamcipher_alg->base.cra_align=
mask |
> +                                      hash_alg->base.cra_alignmask;
> +       /*
> +        * The hash function is called twice, so it is weighted higher th=
an the
> +        * streamcipher and blockcipher.
> +        */
> +       inst->alg.base.cra_priority =3D (2 * streamcipher_alg->base.cra_p=
riority +
> +                                      4 * hash_alg->base.cra_priority +
> +                                      blockcipher_alg->cra_priority) / 7=
;
> +
> +       inst->alg.setkey =3D hctr2_setkey;
> +       inst->alg.encrypt =3D hctr2_encrypt;
> +       inst->alg.decrypt =3D hctr2_decrypt;
> +       inst->alg.init =3D hctr2_init_tfm;
> +       inst->alg.exit =3D hctr2_exit_tfm;
> +       inst->alg.min_keysize =3D crypto_skcipher_alg_min_keysize(streamc=
ipher_alg);
> +       inst->alg.max_keysize =3D crypto_skcipher_alg_max_keysize(streamc=
ipher_alg);
> +       inst->alg.ivsize =3D TWEAK_SIZE;
> +
> +       inst->free =3D hctr2_free_instance;
> +
> +       err =3D skcipher_register_instance(tmpl, inst);
> +       if (err) {
> +err_free_inst:
> +               hctr2_free_instance(inst);
> +       }
> +       return err;
> +}
> +
> +static int hctr2_create(struct crypto_template *tmpl, struct rtattr **tb=
)
> +{
> +       const char *blockcipher_name;
> +       char streamcipher_name[CRYPTO_MAX_ALG_NAME];
> +
> +       blockcipher_name =3D crypto_attr_alg_name(tb[1]);
> +       if (IS_ERR(blockcipher_name))
> +               return PTR_ERR(blockcipher_name);
> +
> +       if (snprintf(streamcipher_name, CRYPTO_MAX_ALG_NAME, "xctr(%s)",
> +                   blockcipher_name) >=3D CRYPTO_MAX_ALG_NAME)
> +               return -ENAMETOOLONG;
> +       return hctr2_create_common(tmpl, tb, blockcipher_name, streamciph=
er_name, "polyval");
> +}
> +
> +/* hctr2(blockcipher_name [, xctr(blockcipher_name)] [, polyval_name]) *=
/
> +static struct crypto_template hctr2_tmpl =3D {
> +       .name =3D "hctr2",
> +       .create =3D hctr2_create,
> +       .module =3D THIS_MODULE,
> +};
> +
> +static int __init hctr2_module_init(void)
> +{
> +       return crypto_register_template(&hctr2_tmpl);
> +}
> +
> +static void __exit hctr2_module_exit(void)
> +{
> +       crypto_unregister_template(&hctr2_tmpl);
> +}
> +
> +subsys_initcall(hctr2_module_init);
> +module_exit(hctr2_module_exit);
> +
> +MODULE_DESCRIPTION("HCTR2 length-preserving encryption mode");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS_CRYPTO("hctr2");
> +MODULE_IMPORT_NS(CRYPTO_INTERNAL);
> diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> index b358a5141218..5af2e859830a 100644
> --- a/crypto/tcrypt.c
> +++ b/crypto/tcrypt.c
> @@ -2385,6 +2385,11 @@ static int do_test(const char *alg, u32 type, u32 =
mask, int m, u32 num_mb)
>                                    16, 16, aead_speed_template_19, num_mb=
);
>                 break;
>
> +       case 226:
> +               test_cipher_speed("hctr2(aes)", ENCRYPT, sec, NULL,
> +                                 0, speed_template_32);
> +               break;
> +
>         case 300:
>                 if (alg) {
>                         test_hash_speed(alg, sec, generic_hash_speed_temp=
late);
> diff --git a/crypto/testmgr.c b/crypto/testmgr.c
> index a3a24aa07492..fa8f33210358 100644
> --- a/crypto/testmgr.c
> +++ b/crypto/testmgr.c
> @@ -4994,6 +4994,12 @@ static const struct alg_test_desc alg_test_descs[]=
 =3D {
>                 .suite =3D {
>                         .hash =3D __VECS(ghash_tv_template)
>                 }
> +       }, {
> +               .alg =3D "hctr2(aes)",
> +               .test =3D alg_test_skcipher,
> +               .suite =3D {
> +                       .cipher =3D __VECS(aes_hctr2_tv_template)
> +               }
>         }, {
>                 .alg =3D "hmac(md5)",
>                 .test =3D alg_test_hash,
> diff --git a/crypto/testmgr.h b/crypto/testmgr.h
> index da3736e51982..87e4df6f8ea9 100644
> --- a/crypto/testmgr.h
> +++ b/crypto/testmgr.h
> @@ -33630,4 +33630,791 @@ static const struct hash_testvec polyval_tv_tem=
plate[] =3D {
>         },
>  };
>
> +/*
> + * Test vectors generated using https://github.com/google/hctr2
> + */
> +static const struct cipher_testvec aes_hctr2_tv_template[] =3D {
> +       {
> +               .key    =3D "\xe1\x15\x66\x3c\x8d\xc6\x3a\xff"
> +                         "\xef\x41\xd7\x47\xa2\xcc\x8a\xba",
> +               .iv     =3D "\xc3\xbe\x2a\xcb\xb5\x39\x86\xf1"
> +                         "\x91\xad\x6c\xf4\xde\x74\x45\x63"
> +                         "\x5c\x7a\xd5\xcc\x8b\x76\xef\x0e"
> +                         "\xcf\x2c\x60\x69\x37\xfd\x07\x96",
> +               .ptext  =3D "\x65\x75\xae\xd3\xe2\xbc\x43\x5c"
> +                         "\xb3\x1a\xd8\x05\xc3\xd0\x56\x29",
> +               .ctext  =3D "\x11\x91\xea\x74\x58\xcc\xd5\xa2"
> +                         "\xd0\x55\x9e\x3d\xfe\x7f\xc8\xfe",
> +               .klen   =3D 16,
> +               .len    =3D 16,
> +       },
> +       {
> +               .key    =3D "\x50\xcc\x28\x5c\xaf\x62\xa2\x4e"
> +                         "\x02\xf0\xc0\x5e\xc1\x29\x80\xca",
> +               .iv     =3D "\x64\xa5\xd5\xf9\xf4\x68\x26\xea"
> +                         "\xce\xbb\x6c\xdd\xa5\xef\x39\xb5"
> +                         "\x5c\x93\xdf\x1b\x93\x21\xbe\x49"
> +                         "\xff\x9e\x86\x4f\x7c\x4d\x51\x15",
> +               .ptext  =3D "\x34\xc1\x08\x3e\x9c\x28\x0a\xcf"
> +                         "\x33\xdb\x3f\x0d\x05\x27\xa4\xed",
> +               .ctext  =3D "\x7c\xae\xbb\x37\x4a\x55\x94\x5b"
> +                         "\xc6\x6f\x8f\x9f\x68\x5f\xc7\x62",
> +               .klen   =3D 16,
> +               .len    =3D 16,
> +       },
> +       {
> +               .key    =3D "\xda\xce\x30\x85\xe7\x06\xe6\x02"
> +                         "\x8f\x02\xbf\x9a\x82\x6e\x54\xde",
> +               .iv     =3D "\xf6\x7a\x28\xce\xfb\x6c\xb3\xc5"
> +                         "\x47\x81\x58\x69\x07\xe5\x22\xdb"
> +                         "\x66\x93\xd7\xe9\xbd\x5c\x7f\xf0"
> +                         "\x8a\x0b\x07\x09\xbb\xf1\x48\xc4",
> +               .ptext  =3D "\x01\xcd\xa4\x47\x8e\x4e\xbc\x7d"
> +                         "\xfd\xd8\xe9\xaa\xc7\x37\x25\x3d"
> +                         "\x56",
> +               .ctext  =3D "\xf3\xb2\x9e\xde\x96\x5d\xf0\xf6"
> +                         "\xb6\x43\x57\xc5\x53\xe8\xf9\x05"
> +                         "\x87",
> +               .klen   =3D 16,
> +               .len    =3D 17,
> +       },
> +       {
> +               .key    =3D "\xe1\x22\xee\x5b\x3c\x92\x0e\x52"
> +                         "\xd7\x95\x88\xa3\x79\x6c\xf8\xd9",
> +               .iv     =3D "\xb8\xd1\xe7\x32\x36\x96\xd6\x44"
> +                         "\x9c\x36\xad\x31\x5c\xaa\xf0\x17"
> +                         "\x33\x2f\x29\x04\x31\xf5\x46\xc1"
> +                         "\x2f\x1b\xfa\xa1\xbd\x86\xc4\xd3",
> +               .ptext  =3D "\x87\xd7\xb8\x2d\x12\x62\xed\x41"
> +                         "\x30\x7e\xd4\x0c\xfd\xb9\x6d\x8e"
> +                         "\x30",
> +               .ctext  =3D "\xb6\x6a\x0c\x71\x96\x22\xb9\x40"
> +                         "\xa2\x04\x56\x14\x22\xae\xaa\x94"
> +                         "\x26",
> +               .klen   =3D 16,
> +               .len    =3D 17,
> +       },
> +       {
> +               .key    =3D "\xf6\x2b\xab\xec\x04\x4a\x47\xa6"
> +                         "\x37\xf0\x50\x3d\x56\xe5\x61\xac",
> +               .iv     =3D "\xb7\x6d\x55\x7d\xe2\xf0\x10\x93"
> +                         "\x07\x1e\x5a\x9d\xc3\x59\x6f\x98"
> +                         "\x11\xde\xdb\x3a\x03\xf4\x0e\xcc"
> +                         "\x15\xa4\x1c\xdf\x3c\x55\x89\x27",
> +               .ptext  =3D "\xbe\xc6\x74\x4b\xb9\xa1\x43\x86"
> +                         "\xc2\x4a\x65\x00\xbf\x43\xe4\x84"
> +                         "\x6d\xae\x0a\x3c\xec\x6b\x3d\x43"
> +                         "\xcf\x49\x36\x88\x14\x3d\x3c\xfc"
> +                         "\xfb\xc1\x58\x1f\x39\x81\x88\xeb"
> +                         "\x4e\xa1\xe2\x59\xad\x47\xa3\x61",
> +               .ctext  =3D "\x80\x25\x8e\x11\xed\x58\x21\x6f"
> +                         "\x34\xe3\xa1\xb8\xc0\x99\x6a\x50"
> +                         "\xe0\x18\x23\x4f\x1b\x00\x68\x39"
> +                         "\x75\x34\x95\xfb\x9e\xb4\x18\x89"
> +                         "\x53\x12\x2c\xe2\xee\x59\x32\xa6"
> +                         "\xc5\x3f\xd1\x37\xbc\x12\x40\xbd",
> +               .klen   =3D 16,
> +               .len    =3D 48,
> +       },
> +       {
> +               .key    =3D "\x39\x4e\x4d\x5c\xd6\x63\xaf\x4b"
> +                         "\xcf\xc3\x2c\x53\x8e\x3d\x7b\x3d",
> +               .iv     =3D "\x1d\x4a\x01\xa0\x88\xac\xdf\x2c"
> +                         "\x34\x88\x13\xef\xa4\xe7\xe5\x2e"
> +                         "\x44\xf8\xdc\xff\x74\xd4\x8a\x81"
> +                         "\x26\xfe\x50\x57\xca\x0b\x93\x54",
> +               .ptext  =3D "\x55\x76\x17\x29\xc6\xd2\xbd\x9c"
> +                         "\xf4\xde\x9b\x8e\x71\xf7\xe4\xfd"
> +                         "\x60\xc0\xca\xbc\x8a\x70\x31\x9b"
> +                         "\x2d\xfd\x92\x51\x31\x4d\x3e\x1b"
> +                         "\xdf\x66\x46\xba\x28\x1f\x08\xc1"
> +                         "\x1b\xd0\x8a\x5c\x8e\xe1\xcf\x79",
> +               .ctext  =3D "\x34\x1f\x14\x61\x16\xd8\xf0\x73"
> +                         "\x38\xe7\x5f\xc8\x64\x70\x28\x93"
> +                         "\x9b\xb3\x1c\xfe\x62\xbf\x8e\x3c"
> +                         "\xf5\x17\x2d\xfc\x0d\x3b\x61\xf7"
> +                         "\x30\x25\x4d\x5b\x0c\x84\x5f\x86"
> +                         "\x94\xa1\xbe\xa5\x6d\xa9\x10\x78",
> +               .klen   =3D 16,
> +               .len    =3D 48,
> +       },
> +       {
> +               .key    =3D "\x3e\x08\x5d\x64\x6c\x98\xec\xec"
> +                         "\x70\x0e\x0d\xa1\x41\x20\x99\x82",
> +               .iv     =3D "\x11\xb7\x77\x91\x0d\x99\xd9\x8d"
> +                         "\x35\x3a\xf7\x14\x6b\x09\x37\xe5"
> +                         "\xad\x51\xf6\xc3\x96\x4b\x64\x56"
> +                         "\xa8\xbd\x81\xcc\xbe\x94\xaf\xe4",
> +               .ptext  =3D "\xff\x8d\xb9\xc0\xe3\x69\xb3\xb2"
> +                         "\x8b\x11\x26\xb3\x11\xec\xfb\xb9"
> +                         "\x9c\xc1\x71\xd6\xe3\x26\x0e\xe0"
> +                         "\x68\x40\x60\xb9\x3a\x63\x56\x8a"
> +                         "\x9e\xc1\xf0\x10\xb1\x64\x32\x70"
> +                         "\xf8\xcd\xc6\xc4\x49\x4c\xe1\xce"
> +                         "\xf3\xe1\x03\xf8\x35\xae\xe0\x5e"
> +                         "\xef\x5f\xbc\x41\x75\x26\x13\xcc"
> +                         "\x37\x85\xdf\xc0\x5d\xa6\x47\x98"
> +                         "\xf1\x97\x52\x58\x04\xe6\xb5\x01"
> +                         "\xc0\xb8\x17\x6d\x74\xbd\x9a\xdf"
> +                         "\xa4\x37\x94\x86\xb0\x13\x83\x28"
> +                         "\xc9\xa2\x07\x3f\xb5\xb2\x72\x40"
> +                         "\x0e\x60\xdf\x57\x07\xb7\x2c\x66"
> +                         "\x10\x3f\x8d\xdd\x30\x0a\x47\xd5"
> +                         "\xe8\x9d\xfb\xa1\xaf\x53\xd7\x05"
> +                         "\xc7\xd2\xba\xe7\x2c\xa0\xbf\xb8"
> +                         "\xd1\x93\xe7\x41\x82\xa3\x41\x3a"
> +                         "\xaf\x12\xd6\xf8\x34\xda\x92\x46"
> +                         "\xad\xa2\x2f\xf6\x7e\x46\x96\xd8"
> +                         "\x03\xf3\x49\x64\xde\xd8\x06\x8b"
> +                         "\xa0\xbc\x63\x35\x38\xb6\x6b\xda"
> +                         "\x5b\x50\x3f\x13\xa5\x84\x1b\x1b"
> +                         "\x66\x89\x95\xb7\xc2\x16\x3c\xe9"
> +                         "\x24\xb0\x8c\x6f\x49\xef\xf7\x28"
> +                         "\x6a\x24\xfd\xbe\x25\xe2\xb4\x90"
> +                         "\x77\x44\x08\xb8\xda\xd2\xde\x2c"
> +                         "\xa0\x57\x45\x57\x29\x47\x6b\x89"
> +                         "\x4a\xf6\xa7\x2a\xc3\x9e\x7b\xc8"
> +                         "\xfd\x9f\x89\xab\xee\x6d\xa3\xb4"
> +                         "\x23\x90\x7a\xe9\x89\xa0\xc7\xb3"
> +                         "\x17\x41\x87\x91\xfc\x97\x42",
> +               .ctext  =3D "\xfc\x9b\x96\x66\xc4\x82\x2a\x4a"
> +                         "\xb1\x24\xba\xc7\x78\x5f\x79\xc1"
> +                         "\x57\x2e\x47\x29\x4d\x7b\xd2\x9a"
> +                         "\xbd\xc6\xc1\x26\x7b\x8e\x3f\x5d"
> +                         "\xd4\xb4\x9f\x6a\x02\x24\x4a\xad"
> +                         "\x0c\x00\x1b\xdf\x92\xc5\x8a\xe1"
> +                         "\x77\x79\xcc\xd5\x20\xbf\x83\xf4"
> +                         "\x4b\xad\x11\xbf\xdb\x47\x65\x70"
> +                         "\x43\xf3\x65\xdf\xb7\xdc\xb2\xb9"
> +                         "\xaa\x3f\xb3\xdf\x79\x69\x0d\xa0"
> +                         "\x86\x1c\xba\x48\x0b\x01\xc1\x88"
> +                         "\xdf\x03\xb1\x06\x3c\x1d\x56\xa1"
> +                         "\x8e\x98\xc1\xa6\x95\xa2\x5b\x72"
> +                         "\x76\x59\xd2\x26\x25\xcd\xef\x7c"
> +                         "\xc9\x60\xea\x43\xd1\x12\x8a\x8a"
> +                         "\x63\x12\x78\xcb\x2f\x88\x1e\x88"
> +                         "\x78\x59\xde\xba\x4d\x2c\x78\x61"
> +                         "\x75\x37\x54\xfd\x80\xc7\x5e\x98"
> +                         "\xcf\x14\x62\x8e\xfb\x72\xee\x4d"
> +                         "\x9f\xaf\x8b\x09\xe5\x21\x0a\x91"
> +                         "\x8f\x88\x87\xd5\xb1\x84\xab\x18"
> +                         "\x08\x57\xed\x72\x35\xa6\x0e\xc6"
> +                         "\xff\xcb\xfe\x2c\x48\x39\x14\x44"
> +                         "\xba\x59\x32\x3a\x2d\xc4\x5f\xcb"
> +                         "\xbe\x68\x8e\x7b\xee\x21\xa4\x32"
> +                         "\x11\xa0\x99\xfd\x90\xde\x59\x43"
> +                         "\xeb\xed\xd5\x87\x68\x46\xc6\xde"
> +                         "\x0b\x07\x17\x59\x6a\xab\xca\x15"
> +                         "\x65\x02\x01\xb6\x71\x8c\x3b\xaa"
> +                         "\x18\x3b\x30\xae\x38\x5b\x2c\x74"
> +                         "\xd4\xee\x4a\xfc\xf7\x1b\x09\xd4"
> +                         "\xda\x8b\x1d\x5d\x6f\x21\x6c",
> +               .klen   =3D 16,
> +               .len    =3D 255,
> +       },
> +       {
> +               .key    =3D "\x9f\xd3\xd5\x1a\x0e\xba\x32\x0a"
> +                         "\x1d\xa5\xd1\x14\x16\x58\xcd\xdd",
> +               .iv     =3D "\x10\x52\x8d\x53\x3f\x54\x11\x01"
> +                         "\x19\x3b\xd8\xa5\xe8\x38\x77\x3e"
> +                         "\xd4\x58\xff\x0a\x13\xd2\x09\xe4"
> +                         "\x77\x38\x28\x46\xf9\x16\xd3\xfc",
> +               .ptext  =3D "\x5d\x3f\x4a\xa1\x16\x9a\x3c\xdf"
> +                         "\xd8\x21\x51\xdc\xb7\x3c\x12\xda"
> +                         "\xd1\xe1\xba\x38\xf1\xc1\x9c\x84"
> +                         "\xc7\x48\xe1\xd5\xed\x84\x3b\xcd"
> +                         "\xc7\x1b\xe1\x5d\x1b\xa5\x79\x3c"
> +                         "\xe3\x7e\xab\xf7\xac\x71\x49\x1d"
> +                         "\x25\x2b\x8f\x40\xe8\x89\x45\x67"
> +                         "\x39\x33\xd3\x27\xd5\xff\x16\xb5"
> +                         "\x46\x0f\x37\x05\x14\x87\xa7\xc2"
> +                         "\x35\x7f\x66\x98\x48\x5c\x1a\x05"
> +                         "\x6c\x0a\xd8\xe4\x28\x1e\x99\x6e"
> +                         "\x84\x6c\x13\x07\xc8\x23\xcd\x22"
> +                         "\x80\xb8\xc7\x9e\xbe\xcb\xed\x0b"
> +                         "\xfa\x9d\xf5\x4b\x4f\x0c\x6e\x4e"
> +                         "\x1b\xec\x8c\xb1\x9b\x64\xaa\x65"
> +                         "\x5e\x91\x45\xda\x87\x14\x89\x43"
> +                         "\x61\xb8\xc7\x68\xc6\xe0\x53\x0a"
> +                         "\x71\xef\xac\xc2\xb2\x41\xd9\x4e"
> +                         "\x41\xf8\xb3\xee\x2f\x59\xff\x05"
> +                         "\x91\x77\x34\xe1\xb2\x1c\x46\x95"
> +                         "\xf2\xea\x2a\x15\x70\x97\xa3\x7f"
> +                         "\xc3\x68\x23\x73\xd4\x86\xf7\xe0"
> +                         "\xc6\x6a\xbd\x70\x63\x0a\x5e\xe2"
> +                         "\xba\xe6\x7c\x18\x71\xc4\x1d\x07"
> +                         "\x40\xb0\x18\xd7\x52\xc1\x9e\x4e"
> +                         "\x8a\x3a\x75\xc3\xf5\xf1\xf9\x8e"
> +                         "\x00\x0e\x4f\x7f\x17\x16\x38\x73"
> +                         "\xf6\x91\x29\x2a\xcb\xf8\xee\x1a"
> +                         "\xf8\x09\x75\x0a\xaf\xb1\x47\x7c"
> +                         "\xcf\xca\xd3\xbd\x28\x8b\xa6\xe5"
> +                         "\x33\xd1\x63\xea\x89\x1d\xa3\x63"
> +                         "\x9d\x1f\xb2\xc6\x02\x50\x1b",
> +               .ctext  =3D "\xd3\x8c\xee\xa6\x45\x11\xaf\x8a"
> +                         "\x21\x75\x1f\x84\x1d\x6f\x3f\xbe"
> +                         "\xc6\x07\xdd\x64\x6c\x99\x9b\x8b"
> +                         "\xfa\xef\x41\xf2\xe1\x04\xe2\x0a"
> +                         "\x12\x88\x96\x98\x74\xd4\x6c\x5d"
> +                         "\x6b\xf4\x8b\xfc\x87\x5f\x4b\x70"
> +                         "\x29\x07\x13\x49\xad\x52\x3e\xa7"
> +                         "\x88\x20\x8a\xdd\x5d\xe9\x2d\x86"
> +                         "\x5c\x1e\x33\x82\x07\xe9\x04\xa4"
> +                         "\x72\xbd\xa8\xb3\x67\x2e\xc0\x80"
> +                         "\xea\x9d\x44\x55\x36\xca\xb6\xb4"
> +                         "\x0d\x5e\xaf\x87\x63\x45\x65\xd8"
> +                         "\x90\x58\xc3\xec\x27\x5a\x7f\x25"
> +                         "\x1b\x14\x08\x2b\xed\x14\xe2\x80"
> +                         "\x53\xc2\xed\xbf\x88\xf3\x74\x8d"
> +                         "\x79\x99\x9e\x7f\x18\x2b\x1f\x70"
> +                         "\x09\x46\x88\x41\x1b\xce\xc5\x69"
> +                         "\xd8\xc8\x83\xfa\x32\xd8\xb7\xab"
> +                         "\x87\xae\xda\x36\xc1\x75\xba\xf5"
> +                         "\xd3\x22\xcc\x0a\x20\x62\x37\xfd"
> +                         "\xc1\xe1\x6c\xc6\xac\x4b\x1e\x34"
> +                         "\x4f\xbe\x09\xea\xb1\xd3\x30\xa6"
> +                         "\xf1\xd8\x51\x0f\x83\xf7\x36\x83"
> +                         "\x17\x23\x25\x6c\xb4\x5f\x4f\x76"
> +                         "\xde\x0a\x09\x54\xf3\xd2\xca\x52"
> +                         "\xc2\xec\x6a\x9c\x0a\xa0\x59\x8e"
> +                         "\xbe\x09\x02\x83\xcf\x4e\xe3\x59"
> +                         "\x6d\xff\x45\x49\x1f\xa7\x32\x67"
> +                         "\x1d\xb4\xdf\x60\xb9\x30\xd4\x64"
> +                         "\xfc\x47\xf7\xe7\xfa\x94\x23\x60"
> +                         "\xd5\x47\xe4\x4e\x61\x45\x7e\x48"
> +                         "\xd3\xad\xad\x97\x61\x1c\x32",
> +               .klen   =3D 16,
> +               .len    =3D 255,
> +       },
> +       {
> +               .key    =3D "\xea\x2f\x51\x6f\x31\xe9\x2f\x7b"
> +                         "\x68\xc8\x1a\xd5\xfa\x9c\xe1\x40"
> +                         "\x95\xe9\x47\xcb\xa1\x9a\xf7\xee",
> +               .iv     =3D "\xe6\x77\x52\x55\x9c\xa7\xc1\x91"
> +                         "\x02\xa7\x32\x87\x76\x91\x72\x2e"
> +                         "\xf3\xa4\x84\x33\xe8\xa5\xa3\x57"
> +                         "\x42\x5d\xd5\x6c\xaa\xf1\xfd\x53",
> +               .ptext  =3D "\x22\xd0\xff\xba\xad\x43\xaf\x63"
> +                         "\x0e\xb1\x0c\x60\x0f\x64\x92\x5a",
> +               .ctext  =3D "\x21\x85\xb9\xb8\xdf\x5e\x8b\x70"
> +                         "\xfe\x79\xc0\x5d\x9d\x89\x30\xdc",
> +               .klen   =3D 24,
> +               .len    =3D 16,
> +       },
> +       {
> +               .key    =3D "\x44\x18\xc4\xb2\x25\xe5\xa6\x90"
> +                         "\x7a\x12\x8c\x35\x6a\x98\x44\x3c"
> +                         "\x4b\x67\x18\x24\x34\xce\x30\x7e",
> +               .iv     =3D "\x8e\xf9\x6d\xf5\x52\x06\xb5\x07"
> +                         "\xd1\x13\xfe\x36\x87\xee\x6e\x13"
> +                         "\xea\xde\x54\xaf\x49\xc6\x4f\xce"
> +                         "\xe1\x86\x8e\xcd\x22\x12\xde\x39",
> +               .ptext  =3D "\x34\x14\x8d\x92\xa6\x83\xd5\x87"
> +                         "\x89\xfd\xf7\xb1\x8f\x93\x0b\x1c",
> +               .ctext  =3D "\x4f\xdd\xc7\x22\x85\x33\x9d\x34"
> +                         "\xc8\x9b\x88\xfd\x8f\x40\xab\x42",
> +               .klen   =3D 24,
> +               .len    =3D 16,
> +       },
> +       {
> +               .key    =3D "\x24\xf6\xe1\x62\xe5\xaf\x99\xda"
> +                         "\x84\xec\x41\xb0\xa3\x0b\xd5\xa8"
> +                         "\xa0\x3e\x7b\xa6\xdd\x6c\x8f\xa8",
> +               .iv     =3D "\x7f\x80\x24\x62\x32\xdd\xab\x66"
> +                         "\xf2\x87\x29\x24\xec\xd2\x4b\x9f"
> +                         "\x0c\x33\x52\xd9\xe0\xcc\x6e\xe4"
> +                         "\x90\x85\x43\x97\xc4\x62\x14\x33",
> +               .ptext  =3D "\xef\x58\xe7\x7f\xa9\xd9\xb8\xd7"
> +                         "\xa2\x91\x97\x07\x27\x9e\xba\xe8"
> +                         "\xaa",
> +               .ctext  =3D "\xd7\xc3\x81\x91\xf2\x40\x17\x73"
> +                         "\x3e\x3b\x1c\x2a\x8e\x11\x9c\x17"
> +                         "\xf1",
> +               .klen   =3D 24,
> +               .len    =3D 17,
> +       },
> +       {
> +               .key    =3D "\xa6\xc2\x58\x49\x28\x50\x8c\x88"
> +                         "\x84\x9c\xb1\x70\x18\x99\x9c\x0d"
> +                         "\x08\x60\x4f\xb1\xcf\x90\x66\x72",
> +               .iv     =3D "\x80\x14\x7f\x97\x64\x17\x55\xef"
> +                         "\x4b\x1b\xce\x2b\x09\x20\x5a\xed"
> +                         "\x96\xdc\xa6\x6e\xb0\x59\x54\x00"
> +                         "\x1d\x26\x3d\x96\xc2\x3e\x73\x05",
> +               .ptext  =3D "\x49\x8b\x90\x34\x41\x63\xc6\x9a"
> +                         "\x07\xe0\x9d\x86\x77\x54\x63\x6d"
> +                         "\x6a",
> +               .ctext  =3D "\xcb\x94\xfa\xc3\xeb\xf8\x37\xfe"
> +                         "\x15\x76\x03\xd9\x67\xe4\x90\x28"
> +                         "\x0c",
> +               .klen   =3D 24,
> +               .len    =3D 17,
> +       },
> +       {
> +               .key    =3D "\xbf\xaf\xd7\x67\x8c\x47\xcf\x21"
> +                         "\x8a\xa5\xdd\x32\x25\x47\xbe\x4f"
> +                         "\xf1\x3a\x0b\xa6\xaa\x2d\xcf\x09",
> +               .iv     =3D "\xd9\xe8\xf0\x92\x4e\xfc\x1d\xf2"
> +                         "\x81\x37\x7c\x8f\xf1\x59\x09\x20"
> +                         "\xf4\x46\x51\x86\x4f\x54\x8b\x32"
> +                         "\x58\xd1\x99\x8b\x8c\x03\xeb\x5d",
> +               .ptext  =3D "\xcd\x64\x90\xf9\x7c\xe5\x0e\x5a"
> +                         "\x75\xe7\x8e\x39\x86\xec\x20\x43"
> +                         "\x8a\x49\x09\x15\x47\xf4\x3c\x89"
> +                         "\x21\xeb\xcf\x4e\xcf\x91\xb5\x40"
> +                         "\xcd\xe5\x4d\x5c\x6f\xf2\xd2\x80"
> +                         "\xfa\xab\xb3\x76\x9f\x7f\x84\x0a",
> +               .ctext  =3D "\x44\x98\x64\x15\xb7\x0b\x80\xa3"
> +                         "\xb9\xca\x23\xff\x3b\x0b\x68\x74"
> +                         "\xbb\x3e\x20\x19\x9f\x28\x71\x2a"
> +                         "\x48\x3c\x7c\xe2\xef\xb5\x10\xac"
> +                         "\x82\x9f\xcd\x08\x8f\x6b\x16\x6f"
> +                         "\xc3\xbb\x07\xfb\x3c\xb0\x1b\x27",
> +               .klen   =3D 24,
> +               .len    =3D 48,
> +       },
> +       {
> +               .key    =3D "\xbe\xbb\x77\x46\x06\x9c\xf4\x4d"
> +                         "\x37\x9a\xe6\x3f\x27\xa7\x3b\x6e"
> +                         "\x7a\x36\xb8\xb3\xff\xba\x51\xcc",
> +               .iv     =3D "\x06\xbc\x8f\x66\x6a\xbe\xed\x5e"
> +                         "\x51\xf2\x72\x11\x3a\x56\x85\x21"
> +                         "\x44\xfe\xec\x47\x2b\x09\xb8\x6f"
> +                         "\x08\x85\x2a\x93\xa3\xc3\xab\x5e",
> +               .ptext  =3D "\xc7\x74\x42\xf1\xea\xc5\x37\x2d"
> +                         "\xc2\xa0\xf6\xd5\x5a\x9a\xbb\xa0"
> +                         "\xb2\xfd\x54\x8e\x98\xa0\xea\xc7"
> +                         "\x79\x09\x65\x63\xa0\x2e\x82\x4e"
> +                         "\x49\x9c\x39\x67\xd0\x0d\x80\x3e"
> +                         "\x1a\x86\x84\x2b\x20\x23\xdf\xa7",
> +               .ctext  =3D "\x5f\xa3\x11\xca\x93\xfa\x24\x3a"
> +                         "\x24\xb6\xcf\x1e\x76\xbc\xab\xc4"
> +                         "\xf3\x24\xa0\x27\xac\x90\xec\xe9"
> +                         "\x73\x28\x7d\x35\x67\xfe\x2e\xa8"
> +                         "\x89\x77\xac\xeb\xc3\x68\x36\xf4"
> +                         "\x8f\x80\x2c\xf1\x80\xef\x49\x49",
> +               .klen   =3D 24,
> +               .len    =3D 48,
> +       },
> +       {
> +               .key    =3D "\x76\xe4\x8f\xf0\x60\x7b\xe4\x0d"
> +                         "\xb9\x06\xfa\x90\x38\x55\x0a\x98"
> +                         "\xaa\x7d\x97\xfe\x8d\x77\x39\x9f",
> +               .iv     =3D "\xf7\x2c\x39\x70\xa4\x28\x66\x45"
> +                         "\xea\x62\x1b\xdd\xb0\xfa\x6c\x50"
> +                         "\xcf\xf7\x4a\x57\xdf\x1e\xa4\xf0"
> +                         "\x0f\xf6\x8a\x71\x15\xcf\xa0\x29",
> +               .ptext  =3D "\x9c\x15\x7c\xc0\x70\x49\x65\xac"
> +                         "\x95\x67\x37\x40\x8b\x0e\x9d\xa9"
> +                         "\x66\x0a\x5e\x32\x58\xa1\x40\x8d"
> +                         "\x46\xa2\xbd\x4f\x5a\xb1\x5f\xd5"
> +                         "\x9d\x8e\x55\x18\x7e\x43\x43\xa9"
> +                         "\x55\x1a\x3f\x50\x51\x7a\xc9\x1b"
> +                         "\x2f\xd8\x36\x35\x41\xf3\x3d\x42"
> +                         "\x7e\x3e\xd5\x94\x6b\xa7\xa0\xc6"
> +                         "\x02\x35\xba\x59\x7a\xc3\xda\xca"
> +                         "\xa3\x73\x18\x6a\x57\x2f\xbd\xe8"
> +                         "\xc8\x3a\x6c\x07\x0e\xea\x6c\x17"
> +                         "\x4f\x3a\xcc\xc3\x70\x89\x99\x23"
> +                         "\x78\x38\xd7\x60\x51\x5a\xe5\xec"
> +                         "\x19\x98\x5b\x78\x9f\xb8\xb9\x00"
> +                         "\x7c\xf8\xab\x23\x59\xf0\x71\xcf"
> +                         "\x7f\x06\x11\x55\x85\x94\xe5\x50"
> +                         "\x0d\x01\x93\xcb\xde\x58\x90\x00"
> +                         "\xc5\x34\x7e\xda\x26\xbf\x58\x15"
> +                         "\x80\x33\x34\x56\x86\xaa\xc8\x6e"
> +                         "\x2b\x47\x98\xb6\xc9\x1c\xa4\xb6"
> +                         "\xac\xf1\x76\xfe\x33\x57\x2d\xad"
> +                         "\x42\x15\x34\xba\x71\x96\xfe\x0e"
> +                         "\xba\xee\x68\x36\x3a\xe0\xe7\xc7"
> +                         "\x3e\x6d\x54\xda\x77\x04\x26\x2c"
> +                         "\xc1\x45\x16\xd9\xdd\x89\xd3\xf1"
> +                         "\xcc\xfc\x19\x44\x6c\x99\xb2\x44"
> +                         "\x1f\x89\x34\x21\xb1\x8d\x02\x5c"
> +                         "\x76\x1e\x27\x84\xf9\xd4\xa3\x03"
> +                         "\x1d\x26\xc1\x39\xb6\x67\x6c\xad"
> +                         "\xb5\x69\x6b\x54\x65\xf6\x9c\xcf"
> +                         "\xaf\x00\x12\x87\x21\x2f\x68\xcb"
> +                         "\xd2\x76\xc1\x43\xce\x24\xc2",
> +               .ctext  =3D "\x40\xff\x83\x8e\xef\x98\xa1\xcb"
> +                         "\x57\x3f\xb6\xf3\x26\x99\x96\xe2"
> +                         "\xd0\x68\x80\x32\x2c\x58\x9a\xd6"
> +                         "\x24\xd0\x21\x17\xc0\x6e\x44\xb6"
> +                         "\xa7\xa0\xdd\xde\xce\x18\x5a\x17"
> +                         "\xf2\xc1\x98\xab\x61\xcd\x70\x0a"
> +                         "\x4d\xef\x9f\xa6\x9d\x8b\x45\x81"
> +                         "\x23\x90\x65\xe0\x45\x2c\x74\xc5"
> +                         "\x7d\xe8\x43\xec\x5a\xfa\x54\x64"
> +                         "\x6f\xfc\x4b\x6c\x83\xec\x1d\xbc"
> +                         "\x39\x19\x2f\xa7\xe6\x46\x5a\x4e"
> +                         "\x17\x6d\x0b\xf2\x7a\x14\x0c\x50"
> +                         "\x8e\x83\x00\xb7\xbb\x65\x77\xfd"
> +                         "\x72\xb3\xea\xe4\xde\x54\xd6\xc0"
> +                         "\x8c\x02\xb2\xdb\xc3\xe6\x46\xd5"
> +                         "\xfb\xb4\x03\x29\xdc\xa4\x64\xe3"
> +                         "\xe8\x20\xb5\x4d\x81\x44\x20\xc8"
> +                         "\x29\x41\xce\x05\x3a\xd6\xe3\x0e"
> +                         "\x0b\xea\xdf\x50\xea\x91\xaa\x9b"
> +                         "\xc4\x9c\x09\x4a\x42\xfa\xef\x38"
> +                         "\x3b\xdf\xfb\x5b\x95\xa2\x9a\xbd"
> +                         "\x10\x55\x61\x4a\xee\x8b\xda\x1f"
> +                         "\x23\x69\xce\x6e\x92\x64\x3e\x32"
> +                         "\x4d\x80\x23\xf1\x43\xd7\x01\x54"
> +                         "\x6f\x18\x4c\x53\x91\xd5\xaa\xeb"
> +                         "\x17\x73\x92\x7f\x10\x7b\x57\x02"
> +                         "\x8e\x6f\xce\x63\x83\x6b\x12\xba"
> +                         "\xbc\x23\xcb\x95\x3a\x1f\x16\xe5"
> +                         "\x21\xf7\x52\x17\x43\x28\x52\xaf"
> +                         "\x2e\x6f\x7f\x36\xe6\x0c\x31\x90"
> +                         "\x57\xf7\x5f\x7c\x06\x3e\x47\x5f"
> +                         "\xb8\xc4\x2a\xeb\xd7\x91\xf1",
> +               .klen   =3D 24,
> +               .len    =3D 255,
> +       },
> +       {
> +               .key    =3D "\x87\x2b\xdd\x36\x2a\x76\x60\xce"
> +                         "\xfb\x54\xa7\x5a\x3f\x40\xcd\x10"
> +                         "\xc8\x88\x0e\xd8\x83\x31\xd5\x5e",
> +               .iv     =3D "\x3b\x6c\x32\xde\x9c\x02\xb6\xa1"
> +                         "\x13\xfe\x8d\x4a\x8d\xf8\x15\x8d"
> +                         "\x0b\x2c\x14\x1c\x44\xd4\x1f\x7e"
> +                         "\xcc\x33\xf0\x03\xa3\x41\x3e\x6d",
> +               .ptext  =3D "\x6a\x0c\x6b\x8b\x44\x75\x77\x0b"
> +                         "\x7d\x9f\xca\x35\x27\x36\xbf\xe3"
> +                         "\xc2\x09\x3e\x6e\x42\xd4\x81\xc2"
> +                         "\x4a\xd5\xa3\x00\x5d\x2b\x97\x0a"
> +                         "\xe0\xd9\x8b\x10\x79\x74\xf4\x5f"
> +                         "\xef\xf0\xc7\x3b\xbc\xbe\x69\xe4"
> +                         "\x0f\xb8\xa2\x39\x15\x70\x3a\xa6"
> +                         "\x20\x86\x8b\x3c\x6e\xca\xfc\x36"
> +                         "\xea\x32\x5f\xa6\x17\x2b\xd3\x24"
> +                         "\x65\x69\x9c\x13\x5c\x56\xb6\x14"
> +                         "\x3a\x8f\x21\x40\xde\x23\x6f\x8b"
> +                         "\x2f\xa8\xa4\x81\x91\xb6\xbe\x7c"
> +                         "\x12\x25\x7c\x87\xb8\x74\x6a\xa7"
> +                         "\x8d\xa5\xb9\x8c\xb4\xa9\xd2\x6a"
> +                         "\xb2\xb3\x6e\x8b\x40\x9f\xf2\x38"
> +                         "\xd8\x26\xf1\xfa\x6f\xb9\x29\xfe"
> +                         "\x0f\xc1\x4d\x90\xf8\x49\xe1\x72"
> +                         "\x70\x63\x35\xdc\xfe\xb4\x72\x06"
> +                         "\xae\x7e\xbe\x36\x23\xa2\x4a\x03"
> +                         "\x6c\xa8\xa0\x7a\x5c\x44\x60\xc4"
> +                         "\x2b\x50\xa1\x19\xa4\x35\xfc\x00"
> +                         "\xd1\x0a\x8f\x9c\x54\x5b\xdc\x53"
> +                         "\x68\x7b\x7b\x1e\xd0\x8e\xd0\x93"
> +                         "\x8f\xaf\xf5\xa2\x40\xe1\x15\x33"
> +                         "\x49\x41\xaa\x57\xf3\x13\x1b\xa5"
> +                         "\x8a\xab\x01\x2b\x28\xec\x63\x81"
> +                         "\x34\x77\xf1\x3f\xc2\x47\x09\x31"
> +                         "\xc2\x80\x1c\xa9\x16\x6b\xa5\x0a"
> +                         "\x1c\xbe\x23\x0c\x41\x63\xd6\x92"
> +                         "\x7f\x3a\x74\x71\x86\x5e\x30\xc1"
> +                         "\xc5\xee\x5b\x41\x9a\xed\x43\xab"
> +                         "\x10\x40\xc4\xe6\xf3\xaa\xc2",
> +               .ctext  =3D "\x45\x61\x53\x5c\x56\x08\xc2\x78"
> +                         "\x01\x23\x8d\x9d\x8e\xeb\xca\xcd"
> +                         "\xf5\x1f\x01\x3f\xba\x9d\xea\x87"
> +                         "\xca\x23\xc5\xa8\xb2\x92\x87\x0d"
> +                         "\x62\x8c\x72\x9c\xe8\xa5\x3f\x75"
> +                         "\xda\xa4\xd5\x92\x6f\xae\x4e\xeb"
> +                         "\xfd\x21\xe6\xa9\x7e\xbf\xed\x85"
> +                         "\xbd\x8c\x88\x18\xa8\x79\xd0\x09"
> +                         "\x5b\x6b\x96\x32\x63\x1a\x6e\x27"
> +                         "\x72\xa3\x7a\xc4\x48\xf3\xed\x04"
> +                         "\x5d\xc7\x01\x23\x7c\x36\x57\x57"
> +                         "\xf4\x45\xf6\xf6\xc7\x9a\xb2\x2f"
> +                         "\x88\x79\xac\xaf\xfd\x52\xa7\x96"
> +                         "\x83\x65\x5d\x6b\xa2\x3b\x2b\x17"
> +                         "\x6c\xa7\xe3\x03\x2e\x6b\xa5\x80"
> +                         "\x32\x0b\x7c\x86\x38\x64\x24\x64"
> +                         "\x51\x61\xca\xa8\xdc\x67\x6a\x17"
> +                         "\x96\xc8\xbd\xd0\x0f\x99\x78\x75"
> +                         "\xbb\x81\xc8\x35\xc1\x5c\x48\x66"
> +                         "\x75\x8a\xed\x44\x57\x10\xc9\xd8"
> +                         "\x85\x91\xaf\x2b\xdd\xc0\xfc\x7f"
> +                         "\x19\x9d\x22\x8f\x94\xe7\xb0\x86"
> +                         "\x34\x17\xd3\xe1\x10\x2a\x30\x3a"
> +                         "\x4d\x5b\xab\x99\xf5\xf8\x21\x78"
> +                         "\x9d\x1b\xba\x1f\xb9\x18\x20\xfa"
> +                         "\x12\x09\x65\xb0\x2c\xf0\x0c\x11"
> +                         "\x4d\x91\xb0\xa0\x24\xb0\xf8\x61"
> +                         "\xe0\x65\xc1\x21\x72\x98\xbc\x29"
> +                         "\x92\x85\x2c\xfc\xa1\x0c\xa0\x04"
> +                         "\x6d\x21\x3d\x40\x62\xda\x55\x71"
> +                         "\xee\xa1\x1e\x5e\xc3\x42\x0b\xa0"
> +                         "\x4b\xe5\xbd\x95\xa9\xdf\x70",
> +               .klen   =3D 24,
> +               .len    =3D 255,
> +       },
> +       {
> +               .key    =3D "\x9e\xeb\xb2\x49\x3c\x1c\xf5\xf4"
> +                         "\x6a\x99\xc2\xc4\xdf\xb1\xf4\xdd"
> +                         "\x75\x20\x57\xea\x2c\x4f\xcd\xb2"
> +                         "\xa5\x3d\x7b\x49\x1e\xab\xfd\x0f",
> +               .iv     =3D "\xdf\x63\xd4\xab\xd2\x49\xf3\xd8"
> +                         "\x33\x81\x37\x60\x7d\xfa\x73\x08"
> +                         "\xd8\x49\x6d\x80\xe8\x2f\x62\x54"
> +                         "\xeb\x0e\xa9\x39\x5b\x45\x7f\x8a",
> +               .ptext  =3D "\x67\xc9\xf2\x30\x84\x41\x8e\x43"
> +                         "\xfb\xf3\xb3\x3e\x79\x36\x7f\xe8",
> +               .ctext  =3D "\x27\x38\x78\x47\x16\xd9\x71\x35"
> +                         "\x2e\x7e\xdd\x7e\x43\x3c\xb8\x40",
> +               .klen   =3D 32,
> +               .len    =3D 16,
> +       },
> +       {
> +               .key    =3D "\x50\x4a\xc8\x94\x01\x13\xd3\x0c"
> +                         "\xd9\xaa\xf3\x4c\xf8\x3f\x2c\x39"
> +                         "\x9e\xec\xc6\xa8\x97\xf2\x8e\x73"
> +                         "\x94\xb8\x4c\x40\x03\x28\xaf\xc2",
> +               .iv     =3D "\x9e\xaa\x0b\x7f\x12\x2a\xe3\xdf"
> +                         "\x05\x03\x93\x1b\xda\xc8\xd7\x98"
> +                         "\x8a\xf9\xdf\x63\xb1\xcd\x15\xaa"
> +                         "\x02\x8e\x41\xa0\x75\x1d\x17\x0e",
> +               .ptext  =3D "\xe2\x8a\x35\xa7\x10\x0d\x65\x6e"
> +                         "\xad\x77\xce\x07\xbb\x67\x83\x03",
> +               .ctext  =3D "\x81\xc1\x1c\x06\x73\xcb\xc1\xe6"
> +                         "\xed\x1f\x5b\xf0\x7d\x8b\x12\xf8",
> +               .klen   =3D 32,
> +               .len    =3D 16,
> +       },
> +       {
> +               .key    =3D "\x93\xfa\x7e\xe2\x0e\x67\xc4\x39"
> +                         "\xe7\xca\x47\x95\x68\x9d\x5e\x5a"
> +                         "\x7c\x26\x19\xab\xc6\xca\x6a\x4c"
> +                         "\x45\xa6\x96\x42\xae\x6c\xff\xe7",
> +               .iv     =3D "\xea\x82\x47\x95\x3b\x22\xa1\x3a"
> +                         "\x6a\xca\x24\x4c\x50\x7e\x23\xcd"
> +                         "\x0e\x50\xe5\x41\xb6\x65\x29\xd8"
> +                         "\x30\x23\x00\xd2\x54\xa7\xd6\x56",
> +               .ptext  =3D "\xdb\x1f\x1f\xec\xad\x83\x6e\x5d"
> +                         "\x19\xa5\xf6\x3b\xb4\x93\x5a\x57"
> +                         "\x6f",
> +               .ctext  =3D "\xf1\x46\x6e\x9d\xb3\x01\xf0\x6b"
> +                         "\xc2\xac\x57\x88\x48\x6d\x40\x72"
> +                         "\x68",
> +               .klen   =3D 32,
> +               .len    =3D 17,
> +       },
> +       {
> +               .key    =3D "\xbe\xa5\x63\xe5\x3d\xa6\xdd\x83"
> +                         "\x12\x4e\x52\x3e\xb7\x47\x13\xc0"
> +                         "\x98\x57\x14\x8c\xe9\xbe\x0d\xb4"
> +                         "\xa7\x82\x0e\x99\x82\x94\x0f\x60",
> +               .iv     =3D "\x36\xdf\x56\x4d\xcf\x6a\xd2\xf4"
> +                         "\x35\x92\x3d\xd2\x31\x24\xf8\xa6"
> +                         "\x27\x27\xe4\x55\xe2\xe0\xc3\xb5"
> +                         "\xe7\x40\x31\xae\x98\xab\xab\x93",
> +               .ptext  =3D "\xf4\x54\x01\xb5\x11\xe3\xed\x8d"
> +                         "\xa4\xf0\xf7\x3f\xc8\x4b\xac\x7a"
> +                         "\xb9",
> +               .ctext  =3D "\xa7\xb5\xa4\xaa\x6b\x56\xdb\x79"
> +                         "\x30\xa1\x6e\xfe\xa2\x60\xcb\xb3"
> +                         "\x10",
> +               .klen   =3D 32,
> +               .len    =3D 17,
> +       },
> +       {
> +               .key    =3D "\x03\x65\x03\x6e\x4d\xe6\xe8\x4e"
> +                         "\x8b\xbe\x22\x19\x48\x31\xee\xd9"
> +                         "\xa0\x91\x21\xbe\x62\x89\xde\x78"
> +                         "\xd9\xb0\x36\xa3\x3c\xce\x43\xd5",
> +               .iv     =3D "\xa9\xc3\x4b\xe7\x0f\xfc\x6d\xbf"
> +                         "\x56\x27\x21\x1c\xfc\xd6\x04\x10"
> +                         "\x5f\x43\xe2\x30\x35\x29\x6c\x10"
> +                         "\x90\xf1\xbf\x61\xed\x0f\x8a\x91",
> +               .ptext  =3D "\x07\xaa\x02\x26\xb4\x98\x11\x5e"
> +                         "\x33\x41\x21\x51\x51\x63\x2c\x72"
> +                         "\x00\xab\x32\xa7\x1c\xc8\x3c\x9c"
> +                         "\x25\x0e\x8b\x9a\xdf\x85\xed\x2d"
> +                         "\xf4\xf2\xbc\x55\xca\x92\x6d\x22"
> +                         "\xfd\x22\x3b\x42\x4c\x0b\x74\xec",
> +               .ctext  =3D "\x7b\xb1\x43\x6d\xd8\x72\x6c\xf6"
> +                         "\x67\x6a\x00\xc4\xf1\xf0\xf5\xa4"
> +                         "\xfc\x60\x91\xab\x46\x0b\x15\xfc"
> +                         "\xd7\xc1\x28\x15\xa1\xfc\xf7\x68"
> +                         "\x8e\xcc\x27\x62\x00\x64\x56\x72"
> +                         "\xa6\x17\xd7\x3f\x67\x80\x10\x58",
> +               .klen   =3D 32,
> +               .len    =3D 48,
> +       },
> +       {
> +               .key    =3D "\x93\x14\x30\x98\x95\xda\xad\xeb"
> +                         "\xb8\x22\xb5\x98\x57\x7c\xfa\x14"
> +                         "\x88\x8a\x70\x76\x09\x7d\x03\xb7"
> +                         "\xf9\x1d\x5d\x30\x1f\x24\xb2\xce",
> +               .iv     =3D "\x47\xb7\x08\xb9\xc1\xf5\x12\x57"
> +                         "\x68\x4d\x74\x71\xc3\x0b\x05\xc5"
> +                         "\x8d\x00\x48\x9d\x3a\xfc\x85\x05"
> +                         "\x49\x82\x96\x95\x09\x1a\x17\x27",
> +               .ptext  =3D "\x3f\xf5\x2c\x26\x53\x6c\xdc\x88"
> +                         "\x5e\xf3\x2e\x0d\x22\xe4\xef\x4e"
> +                         "\xad\xaf\xe5\xf7\x5c\xd3\x84\x0e"
> +                         "\xe1\xbb\x19\x0a\xcf\x1e\xb6\xf3"
> +                         "\x53\xf3\x25\xa2\x66\x7a\xd2\x97"
> +                         "\x58\x39\x7a\xd6\x4b\x7f\x31\x76",
> +               .ctext  =3D "\x75\x16\xb1\x9a\xa9\x9d\x12\x78"
> +                         "\x5a\xd1\x36\xc5\x11\x4c\x1a\xc5"
> +                         "\x9b\x21\x12\x0b\xef\x13\xbc\xd0"
> +                         "\x31\x03\xcc\xd9\xf5\x59\x23\xb6"
> +                         "\x70\xaf\xc2\x84\x57\x5c\xad\xc7"
> +                         "\x89\x6a\xf4\x39\x14\x7e\x0d\x0d",
> +               .klen   =3D 32,
> +               .len    =3D 48,
> +       },
> +       {
> +               .key    =3D "\x36\x45\x11\xa2\x98\x5f\x96\x7c"
> +                         "\xc6\xb4\x94\x31\x0a\x67\x09\x32"
> +                         "\x6c\x6f\x6f\x00\xf0\x17\xcb\xac"
> +                         "\xa5\xa9\x47\x9e\x2e\x85\x2f\xfa",
> +               .iv     =3D "\x28\x88\xaa\x9b\x59\x3b\x1e\x97"
> +                         "\x82\xe5\x5c\x9e\x6d\x14\x11\x19"
> +                         "\x6e\x38\x8f\xd5\x40\x2b\xca\xf9"
> +                         "\x7b\x4c\xe4\xa3\xd0\xd2\x8a\x13",
> +               .ptext  =3D "\x95\xd2\xf7\x71\x1b\xca\xa5\x86"
> +                         "\xd9\x48\x01\x93\x2f\x79\x55\x29"
> +                         "\x71\x13\x15\x0e\xe6\x12\xbc\x4d"
> +                         "\x8a\x31\xe3\x40\x2a\xc6\x5e\x0d"
> +                         "\x68\xbb\x4a\x62\x8d\xc7\x45\x77"
> +                         "\xd2\xb8\xc7\x1d\xf1\xd2\x5d\x97"
> +                         "\xcf\xac\x52\xe5\x32\x77\xb6\xda"
> +                         "\x30\x85\xcf\x2b\x98\xe9\xaa\x34"
> +                         "\x62\xb5\x23\x9e\xb7\xa6\xd4\xe0"
> +                         "\xb4\x58\x18\x8c\x4d\xde\x4d\x01"
> +                         "\x83\x89\x24\xca\xfb\x11\xd4\x82"
> +                         "\x30\x7a\x81\x35\xa0\xb4\xd4\xb6"
> +                         "\x84\xea\x47\x91\x8c\x19\x86\x25"
> +                         "\xa6\x06\x8d\x78\xe6\xed\x87\xeb"
> +                         "\xda\xea\x73\x7c\xbf\x66\xb8\x72"
> +                         "\xe3\x0a\xb8\x0c\xcb\x1a\x73\xf1"
> +                         "\xa7\xca\x0a\xde\x57\x2b\xbd\x2b"
> +                         "\xeb\x8b\x24\x38\x22\xd3\x0e\x1f"
> +                         "\x17\xa0\x84\x98\x31\x77\xfd\x34"
> +                         "\x6a\x4e\x3d\x84\x4c\x0e\xfb\xed"
> +                         "\xc8\x2a\x51\xfa\xd8\x73\x21\x8a"
> +                         "\xdb\xb5\xfe\x1f\xee\xc4\xe8\x65"
> +                         "\x54\x84\xdd\x96\x6d\xfd\xd3\x31"
> +                         "\x77\x36\x52\x6b\x80\x4f\x9e\xb4"
> +                         "\xa2\x55\xbf\x66\x41\x49\x4e\x87"
> +                         "\xa7\x0c\xca\xe7\xa5\xc5\xf6\x6f"
> +                         "\x27\x56\xe2\x48\x22\xdd\x5f\x59"
> +                         "\x3c\xf1\x9f\x83\xe5\x2d\xfb\x71"
> +                         "\xad\xd1\xae\x1b\x20\x5c\x47\xb7"
> +                         "\x3b\xd3\x14\xce\x81\x42\xb1\x0a"
> +                         "\xf0\x49\xfa\xc2\xe7\x86\xbf\xcd"
> +                         "\xb0\x95\x9f\x8f\x79\x41\x54",
> +               .ctext  =3D "\xf6\x57\x51\xc4\x25\x61\x2d\xfa"
> +                         "\xd6\xd9\x3f\x9a\x81\x51\xdd\x8e"
> +                         "\x3d\xe7\xaa\x2d\xb1\xda\xc8\xa6"
> +                         "\x9d\xaa\x3c\xab\x62\xf2\x80\xc3"
> +                         "\x2c\xe7\x58\x72\x1d\x44\xc5\x28"
> +                         "\x7f\xb4\xf9\xbc\x9c\xb2\xab\x8e"
> +                         "\xfa\xd1\x4d\x72\xd9\x79\xf5\xa0"
> +                         "\x24\x3e\x90\x25\x31\x14\x38\x45"
> +                         "\x59\xc8\xf6\xe2\xc6\xf6\xc1\xa7"
> +                         "\xb2\xf8\xa7\xa9\x2b\x6f\x12\x3a"
> +                         "\xb0\x81\xa4\x08\x57\x59\xb1\x56"
> +                         "\x4c\x8f\x18\x55\x33\x5f\xd6\x6a"
> +                         "\xc6\xa0\x4b\xd6\x6b\x64\x3e\x9e"
> +                         "\xfd\x66\x16\xe2\xdb\xeb\x5f\xb3"
> +                         "\x50\x50\x3e\xde\x8d\x72\x76\x01"
> +                         "\xbe\xcc\xc9\x52\x09\x2d\x8d\xe7"
> +                         "\xd6\xc3\x66\xdb\x36\x08\xd1\x77"
> +                         "\xc8\x73\x46\x26\x24\x29\xbf\x68"
> +                         "\x2d\x2a\x99\x43\x56\x55\xe4\x93"
> +                         "\xaf\xae\x4d\xe7\x55\x4a\xc0\x45"
> +                         "\x26\xeb\x3b\x12\x90\x7c\xdc\xd1"
> +                         "\xd5\x6f\x0a\xd0\xa9\xd7\x4b\x89"
> +                         "\x0b\x07\xd8\x86\xad\xa1\xc4\x69"
> +                         "\x1f\x5e\x8b\xc4\x9e\x91\x41\x25"
> +                         "\x56\x98\x69\x78\x3a\x9e\xae\x91"
> +                         "\xd8\xd9\xfa\xfb\xff\x81\x25\x09"
> +                         "\xfc\xed\x2d\x87\xbc\x04\x62\x97"
> +                         "\x35\xe1\x26\xc2\x46\x1c\xcf\xd7"
> +                         "\x14\xed\x02\x09\xa5\xb2\xb6\xaa"
> +                         "\x27\x4e\x61\xb3\x71\x6b\x47\x16"
> +                         "\xb7\xe8\xd4\xaf\x52\xeb\x6a\x6b"
> +                         "\xdb\x4c\x65\x21\x9e\x1c\x36",
> +               .klen   =3D 32,
> +               .len    =3D 255,
> +       },
> +       {
> +               .key    =3D "\x56\x33\x37\x21\xc4\xea\x8b\x88"
> +                         "\x67\x5e\xee\xb8\x0b\x6c\x04\x43"
> +                         "\x17\xc5\x2b\x8a\x37\x17\x8b\x37"
> +                         "\x60\x57\x3f\xa7\x82\xcd\xb9\x09",
> +               .iv     =3D "\x88\xee\x9b\x35\x21\x2d\x41\xa1"
> +                         "\x16\x0d\x7f\xdf\x57\xc9\xb9\xc3"
> +                         "\xf6\x30\x53\xbf\x89\x46\xe6\x87"
> +                         "\x60\xc8\x5e\x59\xdd\x8a\x7b\xfe",
> +               .ptext  =3D "\x49\xe2\x0a\x4f\x7a\x60\x75\x9b"
> +                         "\x95\x98\x2c\xe7\x4f\xb4\x58\xb9"
> +                         "\x24\x54\x46\x34\xdf\x58\x31\xe7"
> +                         "\x23\xc6\xa2\x60\x4a\xd2\x59\xb6"
> +                         "\xeb\x3e\xc2\xf8\xe5\x14\x3c\x6d"
> +                         "\x4b\x72\xcb\x5f\xcb\xa7\x47\xb9"
> +                         "\x7a\x49\xfc\xf1\xad\x92\x76\x55"
> +                         "\xac\x59\xdc\x3a\xc6\x8b\x7c\xdb"
> +                         "\x06\xcd\xea\x6a\x34\x51\xb7\xb2"
> +                         "\xe5\x39\x3c\x87\x00\x90\xc2\xbb"
> +                         "\xb2\xa5\x2c\x58\xc2\x9b\xe3\x77"
> +                         "\x95\x82\x50\xcb\x23\xdc\x18\xd8"
> +                         "\x4e\xbb\x13\x5d\x35\x3d\x9a\xda"
> +                         "\xe4\x75\xa1\x75\x17\x59\x8c\x6a"
> +                         "\xb2\x76\x7e\xd4\x45\x31\x0a\x45"
> +                         "\x2e\x60\x83\x3d\xdc\x8d\x43\x20"
> +                         "\x58\x24\xb2\x9d\xd5\x59\x64\x32"
> +                         "\x4e\x6f\xb9\x9c\xde\x77\x4d\x65"
> +                         "\xdf\xc0\x7a\xeb\x40\x80\xe8\xe5"
> +                         "\xc7\xc1\x77\x3b\xae\x2b\x85\xce"
> +                         "\x56\xfa\x43\x41\x96\x23\x8e\xab"
> +                         "\xd3\xc8\x65\xef\x0b\xfe\x42\x4c"
> +                         "\x3a\x8a\x54\x55\xab\xa3\xf9\x62"
> +                         "\x9f\x8e\xbe\x33\x9a\xfe\x6b\x52"
> +                         "\xd4\x4c\x93\x84\x7c\x7e\xb1\x5e"
> +                         "\x32\xaf\x6e\x21\x44\xd2\x6b\x56"
> +                         "\xcd\x2c\x9d\x03\x3b\x50\x1f\x0a"
> +                         "\xc3\x98\xff\x3a\x1d\x36\x7e\x6d"
> +                         "\xcf\xbc\xe7\xe8\xfc\x24\x55\xfd"
> +                         "\x72\x3d\xa7\x3f\x09\xa7\x38\xe6"
> +                         "\x57\x8d\xc4\x74\x7f\xd3\x26\x75"
> +                         "\xda\xfa\x29\x35\xc1\x31\x82",
> +               .ctext  =3D "\x02\x23\x74\x02\x56\xf4\x7b\xc8"
> +                         "\x55\x61\xa0\x6b\x68\xff\xde\x87"
> +                         "\x9d\x66\x77\x86\x98\x63\xab\xd5"
> +                         "\xd6\xf4\x7e\x3b\xf4\xae\x97\x13"
> +                         "\x79\xc0\x96\x75\x87\x33\x2a\x0e"
> +                         "\xc2\x1a\x13\x90\x5f\x6e\x93\xed"
> +                         "\x54\xfe\xee\x05\x48\xae\x20\x2d"
> +                         "\xa9\x2b\x98\xa3\xc8\xaf\x17\x6b"
> +                         "\x82\x4a\x9a\x7f\xf0\xce\xd9\x26"
> +                         "\x16\x28\xeb\xf4\x4b\xab\x7d\x6e"
> +                         "\x96\x27\xd2\x90\xbb\x8d\x98\xdc"
> +                         "\xb8\x6f\x7a\x98\x67\xef\x1c\xfb"
> +                         "\xd0\x23\x1a\x2f\xc9\x58\x4e\xc6"
> +                         "\x38\x03\x53\x61\x8e\xff\x55\x46"
> +                         "\x47\xe8\x1f\x9d\x66\x95\x9b\x7f"
> +                         "\x26\xac\xf2\x61\xa4\x05\x15\xcb"
> +                         "\x62\xb6\x6b\x7c\x57\x95\x9d\x25"
> +                         "\x9e\x83\xb1\x88\x50\x39\xb5\x34"
> +                         "\x8a\x04\x2b\x76\x1b\xb8\x8c\x57"
> +                         "\x26\x21\x99\x2e\x93\xc8\x9b\xb2"
> +                         "\x31\xe1\xe3\x27\xde\xc8\xf2\xc5"
> +                         "\x01\x7a\x45\x38\x6f\xe7\xa0\x9d"
> +                         "\x8c\x41\x99\xec\x3d\xb6\xaf\x66"
> +                         "\x76\xac\xc8\x78\xb0\xdf\xcf\xce"
> +                         "\xa1\x29\x46\x6f\xe3\x35\x4a\x67"
> +                         "\x59\x27\x14\xcc\x04\xdb\xb3\x03"
> +                         "\xb7\x2d\x8d\xf9\x75\x9e\x59\x42"
> +                         "\xe3\xa4\xf8\xf4\x82\x27\xa3\xa9"
> +                         "\x79\xac\x6b\x8a\xd8\xdb\x29\x73"
> +                         "\x02\xbb\x6f\x85\x00\x92\xea\x59"
> +                         "\x30\x1b\x19\xf3\xab\x6e\x99\x9a"
> +                         "\xf2\x23\x27\xc6\x59\x5a\x9c",
> +               .klen   =3D 32,
> +               .len    =3D 255,
> +       },
> +
> +};
> +
>  #endif /* _CRYPTO_TESTMGR_H */
> --
> 2.35.0.rc0.227.g00780c9af4-goog
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
