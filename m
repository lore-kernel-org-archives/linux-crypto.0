Return-Path: <SRS0=b68P=YU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B15F6CA9EAF
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Oct 2019 11:05:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5804E20717
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Oct 2019 11:05:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YrFOdMSa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfJ0LFo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Oct 2019 07:05:44 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40311 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbfJ0LFo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Oct 2019 07:05:44 -0400
Received: by mail-wr1-f67.google.com with SMTP id o28so6919321wro.7
        for <linux-crypto@vger.kernel.org>; Sun, 27 Oct 2019 04:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=oeDu7jZ5w56RsTo19ZxY6vy/seA36DhrbCt6FhNNmyY=;
        b=YrFOdMSarO5PWpE9rmT8yZK85prv3py4SFTIytIwHk6rKdYa5IC9nij1SefoGsZWPT
         1g2UDFC854uud7aivCW758c2XHTiz02rep7d3iIkusgX41IK6UVOYwQ8nwU85GjyOgdy
         rpDQK9uJHna80uxwQI9Sk+LUkdxFEsTd5GM75HWYl2+DjGC3LDFah7nUnMrWsdNSx/4o
         shdgfisswziYzxza3hIAC+gr9ZfnSI2pRY+wT6YtojHhtKy3zCiPZTh0tbWPAR9qX1HC
         ZKIUBnQgrIoWQzSuJ3SGs8G7sSI8wBf/8bNmK1Y1bYtySKlzxP3vsKZkrH3knl5mtzy0
         rYMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=oeDu7jZ5w56RsTo19ZxY6vy/seA36DhrbCt6FhNNmyY=;
        b=PfIIbX4kq1qzaDmxsdUHh6sWArnSS8K92+9yoa29Yz5C7eA78PQ/xg5kzrODIoQkNJ
         Zs/16egyxW4ctHbs6rOtlgmNVrsA/xS7C7TiYBNVFpGoncQRgRivyAZYn0a+JDodXZCY
         aZeB1gjfSZ/OB8PjRrqTziHCPPaEjcJYIgkvSHPzO+AdyU/FNKhOr8M+No/K1KN4V9lN
         kteOxYYc7VUiZWpgb2R9DzaQdCKGNTNoNFZ7Hlfj6K9La8BM+zZpMkGNa6uo7IfIUikD
         UeirswS60L0TSXdJK04bYDLvP6G0+cf7X8Kx80fcUSNN1IT+9f97sI3p6Xk/HNP6YW/m
         fipQ==
X-Gm-Message-State: APjAAAVjaMq6J/3HnYl5vvtI/ctmtkYI8b20DVvUdKDY/Fv3NYwRDpDq
        T0aK0U8e+nyTZ7cvZ6cmMeQyFYENXGQJk6uwpvuSOg==
X-Google-Smtp-Source: APXvYqyHdw2slUb5T+lR114VXlOYAv0j7cvJJIaw3Z1plEPnFZnjUD/y/n9DCfVQLzY5Drh8aYBbuNEYmCHVLoP2XvM=
X-Received: by 2002:adf:fd88:: with SMTP id d8mr4673151wrr.200.1572174338665;
 Sun, 27 Oct 2019 04:05:38 -0700 (PDT)
MIME-Version: 1.0
References: <20191024132345.5236-1-ard.biesheuvel@linaro.org>
 <20191024132345.5236-25-ard.biesheuvel@linaro.org> <74d5c30d-d842-5bdb-ebb8-2aa47ffb5e8d@c-s.fr>
In-Reply-To: <74d5c30d-d842-5bdb-ebb8-2aa47ffb5e8d@c-s.fr>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 27 Oct 2019 12:05:36 +0100
Message-ID: <CAKv+Gu8V57Z2WixfYZSdT+rqsobqDYZ-Hyer6Aq9khUNeUsxmQ@mail.gmail.com>
Subject: Re: [PATCH v2 24/27] crypto: talitos - switch to skcipher API
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 27 Oct 2019 at 11:45, Christophe Leroy <christophe.leroy@c-s.fr> wr=
ote:
>
>
>
> Le 24/10/2019 =C3=A0 15:23, Ard Biesheuvel a =C3=A9crit :
> > Commit 7a7ffe65c8c5 ("crypto: skcipher - Add top-level skcipher interfa=
ce")
> > dated 20 august 2015 introduced the new skcipher API which is supposed =
to
> > replace both blkcipher and ablkcipher. While all consumers of the API h=
ave
> > been converted long ago, some producers of the ablkcipher remain, forci=
ng
> > us to keep the ablkcipher support routines alive, along with the matchi=
ng
> > code to expose [a]blkciphers via the skcipher API.
> >
> > So switch this driver to the skcipher API, allowing us to finally drop =
the
> > blkcipher code in the near future.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> With this series, I get the following Oops at boot:
>

Thanks for the report.

Given that the series only modifies ablkcipher implementations, it is
rather curious that the crash occurs in ahash_init(). Can you confirm
that the crash does not occur with this patch reverted?

> [    3.715154] BUG: Kernel NULL pointer dereference at 0x00000084
> [    3.720721] Faulting instruction address: 0xc0348c9c
> [    3.725641] Oops: Kernel access of bad area, sig: 11 [#1]
> [    3.730981] BE PAGE_SIZE=3D16K PREEMPT CMPC885
> [    3.735223] CPU: 0 PID: 69 Comm: cryptomgr_test Tainted: G        W
>        5.4.0-rc4-s3k-dev-00852-ga6dfc2456b41 #2442
> [    3.745858] NIP:  c0348c9c LR: c021dd88 CTR: c0348c30
> [    3.750864] REGS: c6303be0 TRAP: 0300   Tainted: G        W
> (5.4.0-rc4-s3k-dev-00852-ga6dfc2456b41)
> [    3.760559] MSR:  00009032 <EE,ME,IR,DR,RI>  CR: 24002202  XER: 000000=
00
> [    3.767192] DAR: 00000084 DSISR: c0000000
> [    3.767192] GPR00: c021dd88 c6303c98 c61c1e00 c6348800 c7fc1a40
> 00000830 00000028 c7fc1a82
> [    3.767192] GPR08: 00000001 00000000 c7f90000 00000004 84002202
> 00000000 c003b9b8 c62452e0
> [    3.767192] GPR16: c6339a00 c6348830 c06a7ee8 000000dc c6303d30
> c6339930 c6348a00 c6303db0
> [    3.767192] GPR24: 00000010 00000400 c6348c00 c05b13c8 c05d6924
> c6303cc0 00000000 c6348800
> [    3.804591] NIP [c0348c9c] ahash_init+0x6c/0x128
> [    3.809161] LR [c021dd88] do_ahash_op.isra.33+0x24/0x70
> [    3.814256] Call Trace:
> [    3.816717] [c6303ca8] [c021dd88] do_ahash_op.isra.33+0x24/0x70
> [    3.822573] [c6303cb8] [c021ebc8] test_ahash_vec_cfg+0x238/0x5a8
> [    3.828514] [c6303da8] [c02215c8] __alg_test_hash.isra.38+0x16c/0x334
> [    3.834879] [c6303e08] [c022180c] alg_test_hash+0x7c/0x164
> [    3.840299] [c6303e28] [c0222168] alg_test+0xc0/0x384
> [    3.845288] [c6303ef8] [c021ce40] cryptomgr_test+0x48/0x50
> [    3.850705] [c6303f08] [c003ba98] kthread+0xe0/0x10c
> [    3.855619] [c6303f38] [c000e1cc] ret_from_kernel_thread+0x14/0x1c
> [    3.861675] Instruction dump:
> [    3.864613] 5484ba74 814afff0 7c7f1b78 314affdf 7cc63110 54c60034
> 38c60048 3d40c080
> [    3.872271] 814a8208 90c30078 7c8a2214 54a504be <815e0084> 0f090000
> 2f8a0000 409e0058
>
> Christophe
>
>
> > ---
> >   drivers/crypto/talitos.c | 306 +++++++++-----------
> >   1 file changed, 142 insertions(+), 164 deletions(-)
> >
> > diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
> > index bcd533671ccc..c29f8c02ea05 100644
> > --- a/drivers/crypto/talitos.c
> > +++ b/drivers/crypto/talitos.c
> > @@ -35,7 +35,7 @@
> >   #include <crypto/md5.h>
> >   #include <crypto/internal/aead.h>
> >   #include <crypto/authenc.h>
> > -#include <crypto/skcipher.h>
> > +#include <crypto/internal/skcipher.h>
> >   #include <crypto/hash.h>
> >   #include <crypto/internal/hash.h>
> >   #include <crypto/scatterwalk.h>
> > @@ -1490,10 +1490,10 @@ static int aead_decrypt(struct aead_request *re=
q)
> >       return ipsec_esp(edesc, req, false, ipsec_esp_decrypt_swauth_done=
);
> >   }
> >
> > -static int ablkcipher_setkey(struct crypto_ablkcipher *cipher,
> > +static int skcipher_setkey(struct crypto_skcipher *cipher,
> >                            const u8 *key, unsigned int keylen)
> >   {
> > -     struct talitos_ctx *ctx =3D crypto_ablkcipher_ctx(cipher);
> > +     struct talitos_ctx *ctx =3D crypto_skcipher_ctx(cipher);
> >       struct device *dev =3D ctx->dev;
> >
> >       if (ctx->keylen)
> > @@ -1507,39 +1507,39 @@ static int ablkcipher_setkey(struct crypto_ablk=
cipher *cipher,
> >       return 0;
> >   }
> >
> > -static int ablkcipher_des_setkey(struct crypto_ablkcipher *cipher,
> > +static int skcipher_des_setkey(struct crypto_skcipher *cipher,
> >                                const u8 *key, unsigned int keylen)
> >   {
> > -     return verify_ablkcipher_des_key(cipher, key) ?:
> > -            ablkcipher_setkey(cipher, key, keylen);
> > +     return verify_skcipher_des_key(cipher, key) ?:
> > +            skcipher_setkey(cipher, key, keylen);
> >   }
> >
> > -static int ablkcipher_des3_setkey(struct crypto_ablkcipher *cipher,
> > +static int skcipher_des3_setkey(struct crypto_skcipher *cipher,
> >                                 const u8 *key, unsigned int keylen)
> >   {
> > -     return verify_ablkcipher_des3_key(cipher, key) ?:
> > -            ablkcipher_setkey(cipher, key, keylen);
> > +     return verify_skcipher_des3_key(cipher, key) ?:
> > +            skcipher_setkey(cipher, key, keylen);
> >   }
> >
> > -static int ablkcipher_aes_setkey(struct crypto_ablkcipher *cipher,
> > +static int skcipher_aes_setkey(struct crypto_skcipher *cipher,
> >                                 const u8 *key, unsigned int keylen)
> >   {
> >       if (keylen =3D=3D AES_KEYSIZE_128 || keylen =3D=3D AES_KEYSIZE_19=
2 ||
> >           keylen =3D=3D AES_KEYSIZE_256)
> > -             return ablkcipher_setkey(cipher, key, keylen);
> > +             return skcipher_setkey(cipher, key, keylen);
> >
> > -     crypto_ablkcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
> > +     crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
> >
> >       return -EINVAL;
> >   }
> >
> >   static void common_nonsnoop_unmap(struct device *dev,
> >                                 struct talitos_edesc *edesc,
> > -                               struct ablkcipher_request *areq)
> > +                               struct skcipher_request *areq)
> >   {
> >       unmap_single_talitos_ptr(dev, &edesc->desc.ptr[5], DMA_FROM_DEVIC=
E);
> >
> > -     talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->nbytes, =
0);
> > +     talitos_sg_unmap(dev, edesc, areq->src, areq->dst, areq->cryptlen=
, 0);
> >       unmap_single_talitos_ptr(dev, &edesc->desc.ptr[1], DMA_TO_DEVICE)=
;
> >
> >       if (edesc->dma_len)
> > @@ -1547,20 +1547,20 @@ static void common_nonsnoop_unmap(struct device=
 *dev,
> >                                DMA_BIDIRECTIONAL);
> >   }
> >
> > -static void ablkcipher_done(struct device *dev,
> > +static void skcipher_done(struct device *dev,
> >                           struct talitos_desc *desc, void *context,
> >                           int err)
> >   {
> > -     struct ablkcipher_request *areq =3D context;
> > -     struct crypto_ablkcipher *cipher =3D crypto_ablkcipher_reqtfm(are=
q);
> > -     struct talitos_ctx *ctx =3D crypto_ablkcipher_ctx(cipher);
> > -     unsigned int ivsize =3D crypto_ablkcipher_ivsize(cipher);
> > +     struct skcipher_request *areq =3D context;
> > +     struct crypto_skcipher *cipher =3D crypto_skcipher_reqtfm(areq);
> > +     struct talitos_ctx *ctx =3D crypto_skcipher_ctx(cipher);
> > +     unsigned int ivsize =3D crypto_skcipher_ivsize(cipher);
> >       struct talitos_edesc *edesc;
> >
> >       edesc =3D container_of(desc, struct talitos_edesc, desc);
> >
> >       common_nonsnoop_unmap(dev, edesc, areq);
> > -     memcpy(areq->info, ctx->iv, ivsize);
> > +     memcpy(areq->iv, ctx->iv, ivsize);
> >
> >       kfree(edesc);
> >
> > @@ -1568,17 +1568,17 @@ static void ablkcipher_done(struct device *dev,
> >   }
> >
> >   static int common_nonsnoop(struct talitos_edesc *edesc,
> > -                        struct ablkcipher_request *areq,
> > +                        struct skcipher_request *areq,
> >                          void (*callback) (struct device *dev,
> >                                            struct talitos_desc *desc,
> >                                            void *context, int error))
> >   {
> > -     struct crypto_ablkcipher *cipher =3D crypto_ablkcipher_reqtfm(are=
q);
> > -     struct talitos_ctx *ctx =3D crypto_ablkcipher_ctx(cipher);
> > +     struct crypto_skcipher *cipher =3D crypto_skcipher_reqtfm(areq);
> > +     struct talitos_ctx *ctx =3D crypto_skcipher_ctx(cipher);
> >       struct device *dev =3D ctx->dev;
> >       struct talitos_desc *desc =3D &edesc->desc;
> > -     unsigned int cryptlen =3D areq->nbytes;
> > -     unsigned int ivsize =3D crypto_ablkcipher_ivsize(cipher);
> > +     unsigned int cryptlen =3D areq->cryptlen;
> > +     unsigned int ivsize =3D crypto_skcipher_ivsize(cipher);
> >       int sg_count, ret;
> >       bool sync_needed =3D false;
> >       struct talitos_private *priv =3D dev_get_drvdata(dev);
> > @@ -1638,65 +1638,65 @@ static int common_nonsnoop(struct talitos_edesc=
 *edesc,
> >       return ret;
> >   }
> >
> > -static struct talitos_edesc *ablkcipher_edesc_alloc(struct ablkcipher_=
request *
> > +static struct talitos_edesc *skcipher_edesc_alloc(struct skcipher_requ=
est *
> >                                                   areq, bool encrypt)
> >   {
> > -     struct crypto_ablkcipher *cipher =3D crypto_ablkcipher_reqtfm(are=
q);
> > -     struct talitos_ctx *ctx =3D crypto_ablkcipher_ctx(cipher);
> > -     unsigned int ivsize =3D crypto_ablkcipher_ivsize(cipher);
> > +     struct crypto_skcipher *cipher =3D crypto_skcipher_reqtfm(areq);
> > +     struct talitos_ctx *ctx =3D crypto_skcipher_ctx(cipher);
> > +     unsigned int ivsize =3D crypto_skcipher_ivsize(cipher);
> >
> >       return talitos_edesc_alloc(ctx->dev, areq->src, areq->dst,
> > -                                areq->info, 0, areq->nbytes, 0, ivsize=
, 0,
> > +                                areq->iv, 0, areq->cryptlen, 0, ivsize=
, 0,
> >                                  areq->base.flags, encrypt);
> >   }
> >
> > -static int ablkcipher_encrypt(struct ablkcipher_request *areq)
> > +static int skcipher_encrypt(struct skcipher_request *areq)
> >   {
> > -     struct crypto_ablkcipher *cipher =3D crypto_ablkcipher_reqtfm(are=
q);
> > -     struct talitos_ctx *ctx =3D crypto_ablkcipher_ctx(cipher);
> > +     struct crypto_skcipher *cipher =3D crypto_skcipher_reqtfm(areq);
> > +     struct talitos_ctx *ctx =3D crypto_skcipher_ctx(cipher);
> >       struct talitos_edesc *edesc;
> >       unsigned int blocksize =3D
> > -                     crypto_tfm_alg_blocksize(crypto_ablkcipher_tfm(ci=
pher));
> > +                     crypto_tfm_alg_blocksize(crypto_skcipher_tfm(ciph=
er));
> >
> > -     if (!areq->nbytes)
> > +     if (!areq->cryptlen)
> >               return 0;
> >
> > -     if (areq->nbytes % blocksize)
> > +     if (areq->cryptlen % blocksize)
> >               return -EINVAL;
> >
> >       /* allocate extended descriptor */
> > -     edesc =3D ablkcipher_edesc_alloc(areq, true);
> > +     edesc =3D skcipher_edesc_alloc(areq, true);
> >       if (IS_ERR(edesc))
> >               return PTR_ERR(edesc);
> >
> >       /* set encrypt */
> >       edesc->desc.hdr =3D ctx->desc_hdr_template | DESC_HDR_MODE0_ENCRY=
PT;
> >
> > -     return common_nonsnoop(edesc, areq, ablkcipher_done);
> > +     return common_nonsnoop(edesc, areq, skcipher_done);
> >   }
> >
> > -static int ablkcipher_decrypt(struct ablkcipher_request *areq)
> > +static int skcipher_decrypt(struct skcipher_request *areq)
> >   {
> > -     struct crypto_ablkcipher *cipher =3D crypto_ablkcipher_reqtfm(are=
q);
> > -     struct talitos_ctx *ctx =3D crypto_ablkcipher_ctx(cipher);
> > +     struct crypto_skcipher *cipher =3D crypto_skcipher_reqtfm(areq);
> > +     struct talitos_ctx *ctx =3D crypto_skcipher_ctx(cipher);
> >       struct talitos_edesc *edesc;
> >       unsigned int blocksize =3D
> > -                     crypto_tfm_alg_blocksize(crypto_ablkcipher_tfm(ci=
pher));
> > +                     crypto_tfm_alg_blocksize(crypto_skcipher_tfm(ciph=
er));
> >
> > -     if (!areq->nbytes)
> > +     if (!areq->cryptlen)
> >               return 0;
> >
> > -     if (areq->nbytes % blocksize)
> > +     if (areq->cryptlen % blocksize)
> >               return -EINVAL;
> >
> >       /* allocate extended descriptor */
> > -     edesc =3D ablkcipher_edesc_alloc(areq, false);
> > +     edesc =3D skcipher_edesc_alloc(areq, false);
> >       if (IS_ERR(edesc))
> >               return PTR_ERR(edesc);
> >
> >       edesc->desc.hdr =3D ctx->desc_hdr_template | DESC_HDR_DIR_INBOUND=
;
> >
> > -     return common_nonsnoop(edesc, areq, ablkcipher_done);
> > +     return common_nonsnoop(edesc, areq, skcipher_done);
> >   }
> >
> >   static void common_nonsnoop_hash_unmap(struct device *dev,
> > @@ -2257,7 +2257,7 @@ struct talitos_alg_template {
> >       u32 type;
> >       u32 priority;
> >       union {
> > -             struct crypto_alg crypto;
> > +             struct skcipher_alg skcipher;
> >               struct ahash_alg hash;
> >               struct aead_alg aead;
> >       } alg;
> > @@ -2702,123 +2702,102 @@ static struct talitos_alg_template driver_alg=
s[] =3D {
> >                                    DESC_HDR_MODE1_MDEU_PAD |
> >                                    DESC_HDR_MODE1_MDEU_MD5_HMAC,
> >       },
> > -     /* ABLKCIPHER algorithms. */
> > -     {       .type =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
> > -             .alg.crypto =3D {
> > -                     .cra_name =3D "ecb(aes)",
> > -                     .cra_driver_name =3D "ecb-aes-talitos",
> > -                     .cra_blocksize =3D AES_BLOCK_SIZE,
> > -                     .cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> > -                                  CRYPTO_ALG_ASYNC,
> > -                     .cra_ablkcipher =3D {
> > -                             .min_keysize =3D AES_MIN_KEY_SIZE,
> > -                             .max_keysize =3D AES_MAX_KEY_SIZE,
> > -                             .setkey =3D ablkcipher_aes_setkey,
> > -                     }
> > +     /* SKCIPHER algorithms. */
> > +     {       .type =3D CRYPTO_ALG_TYPE_SKCIPHER,
> > +             .alg.skcipher =3D {
> > +                     .base.cra_name =3D "ecb(aes)",
> > +                     .base.cra_driver_name =3D "ecb-aes-talitos",
> > +                     .base.cra_blocksize =3D AES_BLOCK_SIZE,
> > +                     .base.cra_flags =3D CRYPTO_ALG_ASYNC,
> > +                     .min_keysize =3D AES_MIN_KEY_SIZE,
> > +                     .max_keysize =3D AES_MAX_KEY_SIZE,
> > +                     .setkey =3D skcipher_aes_setkey,
> >               },
> >               .desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_A=
FEU |
> >                                    DESC_HDR_SEL0_AESU,
> >       },
> > -     {       .type =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
> > -             .alg.crypto =3D {
> > -                     .cra_name =3D "cbc(aes)",
> > -                     .cra_driver_name =3D "cbc-aes-talitos",
> > -                     .cra_blocksize =3D AES_BLOCK_SIZE,
> > -                     .cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> > -                                     CRYPTO_ALG_ASYNC,
> > -                     .cra_ablkcipher =3D {
> > -                             .min_keysize =3D AES_MIN_KEY_SIZE,
> > -                             .max_keysize =3D AES_MAX_KEY_SIZE,
> > -                             .ivsize =3D AES_BLOCK_SIZE,
> > -                             .setkey =3D ablkcipher_aes_setkey,
> > -                     }
> > +     {       .type =3D CRYPTO_ALG_TYPE_SKCIPHER,
> > +             .alg.skcipher =3D {
> > +                     .base.cra_name =3D "cbc(aes)",
> > +                     .base.cra_driver_name =3D "cbc-aes-talitos",
> > +                     .base.cra_blocksize =3D AES_BLOCK_SIZE,
> > +                     .base.cra_flags =3D CRYPTO_ALG_ASYNC,
> > +                     .min_keysize =3D AES_MIN_KEY_SIZE,
> > +                     .max_keysize =3D AES_MAX_KEY_SIZE,
> > +                     .ivsize =3D AES_BLOCK_SIZE,
> > +                     .setkey =3D skcipher_aes_setkey,
> >               },
> >               .desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_A=
FEU |
> >                                    DESC_HDR_SEL0_AESU |
> >                                    DESC_HDR_MODE0_AESU_CBC,
> >       },
> > -     {       .type =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
> > -             .alg.crypto =3D {
> > -                     .cra_name =3D "ctr(aes)",
> > -                     .cra_driver_name =3D "ctr-aes-talitos",
> > -                     .cra_blocksize =3D 1,
> > -                     .cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> > -                                  CRYPTO_ALG_ASYNC,
> > -                     .cra_ablkcipher =3D {
> > -                             .min_keysize =3D AES_MIN_KEY_SIZE,
> > -                             .max_keysize =3D AES_MAX_KEY_SIZE,
> > -                             .ivsize =3D AES_BLOCK_SIZE,
> > -                             .setkey =3D ablkcipher_aes_setkey,
> > -                     }
> > +     {       .type =3D CRYPTO_ALG_TYPE_SKCIPHER,
> > +             .alg.skcipher =3D {
> > +                     .base.cra_name =3D "ctr(aes)",
> > +                     .base.cra_driver_name =3D "ctr-aes-talitos",
> > +                     .base.cra_blocksize =3D 1,
> > +                     .base.cra_flags =3D CRYPTO_ALG_ASYNC,
> > +                     .min_keysize =3D AES_MIN_KEY_SIZE,
> > +                     .max_keysize =3D AES_MAX_KEY_SIZE,
> > +                     .ivsize =3D AES_BLOCK_SIZE,
> > +                     .setkey =3D skcipher_aes_setkey,
> >               },
> >               .desc_hdr_template =3D DESC_HDR_TYPE_AESU_CTR_NONSNOOP |
> >                                    DESC_HDR_SEL0_AESU |
> >                                    DESC_HDR_MODE0_AESU_CTR,
> >       },
> > -     {       .type =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
> > -             .alg.crypto =3D {
> > -                     .cra_name =3D "ecb(des)",
> > -                     .cra_driver_name =3D "ecb-des-talitos",
> > -                     .cra_blocksize =3D DES_BLOCK_SIZE,
> > -                     .cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> > -                                  CRYPTO_ALG_ASYNC,
> > -                     .cra_ablkcipher =3D {
> > -                             .min_keysize =3D DES_KEY_SIZE,
> > -                             .max_keysize =3D DES_KEY_SIZE,
> > -                             .setkey =3D ablkcipher_des_setkey,
> > -                     }
> > +     {       .type =3D CRYPTO_ALG_TYPE_SKCIPHER,
> > +             .alg.skcipher =3D {
> > +                     .base.cra_name =3D "ecb(des)",
> > +                     .base.cra_driver_name =3D "ecb-des-talitos",
> > +                     .base.cra_blocksize =3D DES_BLOCK_SIZE,
> > +                     .base.cra_flags =3D CRYPTO_ALG_ASYNC,
> > +                     .min_keysize =3D DES_KEY_SIZE,
> > +                     .max_keysize =3D DES_KEY_SIZE,
> > +                     .setkey =3D skcipher_des_setkey,
> >               },
> >               .desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_A=
FEU |
> >                                    DESC_HDR_SEL0_DEU,
> >       },
> > -     {       .type =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
> > -             .alg.crypto =3D {
> > -                     .cra_name =3D "cbc(des)",
> > -                     .cra_driver_name =3D "cbc-des-talitos",
> > -                     .cra_blocksize =3D DES_BLOCK_SIZE,
> > -                     .cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> > -                                  CRYPTO_ALG_ASYNC,
> > -                     .cra_ablkcipher =3D {
> > -                             .min_keysize =3D DES_KEY_SIZE,
> > -                             .max_keysize =3D DES_KEY_SIZE,
> > -                             .ivsize =3D DES_BLOCK_SIZE,
> > -                             .setkey =3D ablkcipher_des_setkey,
> > -                     }
> > +     {       .type =3D CRYPTO_ALG_TYPE_SKCIPHER,
> > +             .alg.skcipher =3D {
> > +                     .base.cra_name =3D "cbc(des)",
> > +                     .base.cra_driver_name =3D "cbc-des-talitos",
> > +                     .base.cra_blocksize =3D DES_BLOCK_SIZE,
> > +                     .base.cra_flags =3D CRYPTO_ALG_ASYNC,
> > +                     .min_keysize =3D DES_KEY_SIZE,
> > +                     .max_keysize =3D DES_KEY_SIZE,
> > +                     .ivsize =3D DES_BLOCK_SIZE,
> > +                     .setkey =3D skcipher_des_setkey,
> >               },
> >               .desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_A=
FEU |
> >                                    DESC_HDR_SEL0_DEU |
> >                                    DESC_HDR_MODE0_DEU_CBC,
> >       },
> > -     {       .type =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
> > -             .alg.crypto =3D {
> > -                     .cra_name =3D "ecb(des3_ede)",
> > -                     .cra_driver_name =3D "ecb-3des-talitos",
> > -                     .cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
> > -                     .cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> > -                                  CRYPTO_ALG_ASYNC,
> > -                     .cra_ablkcipher =3D {
> > -                             .min_keysize =3D DES3_EDE_KEY_SIZE,
> > -                             .max_keysize =3D DES3_EDE_KEY_SIZE,
> > -                             .setkey =3D ablkcipher_des3_setkey,
> > -                     }
> > +     {       .type =3D CRYPTO_ALG_TYPE_SKCIPHER,
> > +             .alg.skcipher =3D {
> > +                     .base.cra_name =3D "ecb(des3_ede)",
> > +                     .base.cra_driver_name =3D "ecb-3des-talitos",
> > +                     .base.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
> > +                     .base.cra_flags =3D CRYPTO_ALG_ASYNC,
> > +                     .min_keysize =3D DES3_EDE_KEY_SIZE,
> > +                     .max_keysize =3D DES3_EDE_KEY_SIZE,
> > +                     .setkey =3D skcipher_des3_setkey,
> >               },
> >               .desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_A=
FEU |
> >                                    DESC_HDR_SEL0_DEU |
> >                                    DESC_HDR_MODE0_DEU_3DES,
> >       },
> > -     {       .type =3D CRYPTO_ALG_TYPE_ABLKCIPHER,
> > -             .alg.crypto =3D {
> > -                     .cra_name =3D "cbc(des3_ede)",
> > -                     .cra_driver_name =3D "cbc-3des-talitos",
> > -                     .cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
> > -                     .cra_flags =3D CRYPTO_ALG_TYPE_ABLKCIPHER |
> > -                                     CRYPTO_ALG_ASYNC,
> > -                     .cra_ablkcipher =3D {
> > -                             .min_keysize =3D DES3_EDE_KEY_SIZE,
> > -                             .max_keysize =3D DES3_EDE_KEY_SIZE,
> > -                             .ivsize =3D DES3_EDE_BLOCK_SIZE,
> > -                             .setkey =3D ablkcipher_des3_setkey,
> > -                     }
> > +     {       .type =3D CRYPTO_ALG_TYPE_SKCIPHER,
> > +             .alg.skcipher =3D {
> > +                     .base.cra_name =3D "cbc(des3_ede)",
> > +                     .base.cra_driver_name =3D "cbc-3des-talitos",
> > +                     .base.cra_blocksize =3D DES3_EDE_BLOCK_SIZE,
> > +                     .base.cra_flags =3D CRYPTO_ALG_ASYNC,
> > +                     .min_keysize =3D DES3_EDE_KEY_SIZE,
> > +                     .max_keysize =3D DES3_EDE_KEY_SIZE,
> > +                     .ivsize =3D DES3_EDE_BLOCK_SIZE,
> > +                     .setkey =3D skcipher_des3_setkey,
> >               },
> >               .desc_hdr_template =3D DESC_HDR_TYPE_COMMON_NONSNOOP_NO_A=
FEU |
> >                                    DESC_HDR_SEL0_DEU |
> > @@ -3036,40 +3015,39 @@ static int talitos_init_common(struct talitos_c=
tx *ctx,
> >       return 0;
> >   }
> >
> > -static int talitos_cra_init(struct crypto_tfm *tfm)
> > +static int talitos_cra_init_aead(struct crypto_aead *tfm)
> >   {
> > -     struct crypto_alg *alg =3D tfm->__crt_alg;
> > +     struct aead_alg *alg =3D crypto_aead_alg(tfm);
> >       struct talitos_crypto_alg *talitos_alg;
> > -     struct talitos_ctx *ctx =3D crypto_tfm_ctx(tfm);
> > +     struct talitos_ctx *ctx =3D crypto_aead_ctx(tfm);
> >
> > -     if ((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) =3D=3D CRYPTO_ALG_TYP=
E_AHASH)
> > -             talitos_alg =3D container_of(__crypto_ahash_alg(alg),
> > -                                        struct talitos_crypto_alg,
> > -                                        algt.alg.hash);
> > -     else
> > -             talitos_alg =3D container_of(alg, struct talitos_crypto_a=
lg,
> > -                                        algt.alg.crypto);
> > +     talitos_alg =3D container_of(alg, struct talitos_crypto_alg,
> > +                                algt.alg.aead);
> >
> >       return talitos_init_common(ctx, talitos_alg);
> >   }
> >
> > -static int talitos_cra_init_aead(struct crypto_aead *tfm)
> > +static int talitos_cra_init_skcipher(struct crypto_skcipher *tfm)
> >   {
> > -     struct aead_alg *alg =3D crypto_aead_alg(tfm);
> > +     struct skcipher_alg *alg =3D crypto_skcipher_alg(tfm);
> >       struct talitos_crypto_alg *talitos_alg;
> > -     struct talitos_ctx *ctx =3D crypto_aead_ctx(tfm);
> > +     struct talitos_ctx *ctx =3D crypto_skcipher_ctx(tfm);
> >
> >       talitos_alg =3D container_of(alg, struct talitos_crypto_alg,
> > -                                algt.alg.aead);
> > +                                algt.alg.skcipher);
> >
> >       return talitos_init_common(ctx, talitos_alg);
> >   }
> >
> >   static int talitos_cra_init_ahash(struct crypto_tfm *tfm)
> >   {
> > +     struct crypto_alg *alg =3D tfm->__crt_alg;
> > +     struct talitos_crypto_alg *talitos_alg;
> >       struct talitos_ctx *ctx =3D crypto_tfm_ctx(tfm);
> >
> > -     talitos_cra_init(tfm);
> > +     talitos_alg =3D container_of(__crypto_ahash_alg(alg),
> > +                                struct talitos_crypto_alg,
> > +                                algt.alg.hash);
> >
> >       ctx->keylen =3D 0;
> >       crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
> > @@ -3116,7 +3094,8 @@ static int talitos_remove(struct platform_device =
*ofdev)
> >
> >       list_for_each_entry_safe(t_alg, n, &priv->alg_list, entry) {
> >               switch (t_alg->algt.type) {
> > -             case CRYPTO_ALG_TYPE_ABLKCIPHER:
> > +             case CRYPTO_ALG_TYPE_SKCIPHER:
> > +                     crypto_unregister_skcipher(&t_alg->algt.alg.skcip=
her);
> >                       break;
> >               case CRYPTO_ALG_TYPE_AEAD:
> >                       crypto_unregister_aead(&t_alg->algt.alg.aead);
> > @@ -3160,15 +3139,14 @@ static struct talitos_crypto_alg *talitos_alg_a=
lloc(struct device *dev,
> >       t_alg->algt =3D *template;
> >
> >       switch (t_alg->algt.type) {
> > -     case CRYPTO_ALG_TYPE_ABLKCIPHER:
> > -             alg =3D &t_alg->algt.alg.crypto;
> > -             alg->cra_init =3D talitos_cra_init;
> > +     case CRYPTO_ALG_TYPE_SKCIPHER:
> > +             alg =3D &t_alg->algt.alg.skcipher.base;
> >               alg->cra_exit =3D talitos_cra_exit;
> > -             alg->cra_type =3D &crypto_ablkcipher_type;
> > -             alg->cra_ablkcipher.setkey =3D alg->cra_ablkcipher.setkey=
 ?:
> > -                                          ablkcipher_setkey;
> > -             alg->cra_ablkcipher.encrypt =3D ablkcipher_encrypt;
> > -             alg->cra_ablkcipher.decrypt =3D ablkcipher_decrypt;
> > +             t_alg->algt.alg.skcipher.init =3D talitos_cra_init_skciph=
er;
> > +             t_alg->algt.alg.skcipher.setkey =3D
> > +                     t_alg->algt.alg.skcipher.setkey ?: skcipher_setke=
y;
> > +             t_alg->algt.alg.skcipher.encrypt =3D skcipher_encrypt;
> > +             t_alg->algt.alg.skcipher.decrypt =3D skcipher_decrypt;
> >               break;
> >       case CRYPTO_ALG_TYPE_AEAD:
> >               alg =3D &t_alg->algt.alg.aead.base;
> > @@ -3465,10 +3443,10 @@ static int talitos_probe(struct platform_device=
 *ofdev)
> >                       }
> >
> >                       switch (t_alg->algt.type) {
> > -                     case CRYPTO_ALG_TYPE_ABLKCIPHER:
> > -                             err =3D crypto_register_alg(
> > -                                             &t_alg->algt.alg.crypto);
> > -                             alg =3D &t_alg->algt.alg.crypto;
> > +                     case CRYPTO_ALG_TYPE_SKCIPHER:
> > +                             err =3D crypto_register_skcipher(
> > +                                             &t_alg->algt.alg.skcipher=
);
> > +                             alg =3D &t_alg->algt.alg.skcipher.base;
> >                               break;
> >
> >                       case CRYPTO_ALG_TYPE_AEAD:
> >
