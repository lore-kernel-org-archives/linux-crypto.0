Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B46BC433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 18:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD5D32166E
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 18:52:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VOI5nGc2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfHISwt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 14:52:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35566 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbfHISws (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 14:52:48 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so6478864wmg.0
        for <linux-crypto@vger.kernel.org>; Fri, 09 Aug 2019 11:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Jva4IllYopbsrm/y3/X7WqbwqZFCf5iLfNxoz0XqtZI=;
        b=VOI5nGc2ZQmXD7kwFPQoSYXcu1xM/xQmi6PwhYUnPckejvpuM6qyjzJooEmosNiNO+
         WNm2dv8MKdEtUhdnbiKOrCG1S7kCfwX89cBY8FVD3JQJcFIoqv8CKXKlrbsytbTI2vXO
         Z98S2AuxtNpnfqJoE+1URjhdayr/fhRLdy6jfGf0nYOATPEI9h00ezqWZTFOL3d6pIjb
         Ejr15f+uxwD/XVvyZowTXzQ6mfql02AFaT++SLjbQk4rldN2+roclIkriN5Os14pR2tL
         4w3AjRuQR/OS27UrKJczIYQ7Bn8N6OfGbtyQ2wxz9ivmi7xX8qArpTmLzfAPJxWsKEK9
         Ytyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Jva4IllYopbsrm/y3/X7WqbwqZFCf5iLfNxoz0XqtZI=;
        b=ndHVG7pyDj5IbEtiKcr/K1SUtL23x22q+er5QcmfYyKDjWVEzy30X4pbh/byAz1Qgx
         gCrMK1wqzJqnZUTqRd/osB7X2WxnIr41ObOCzjY4b+qq5V3c3Blye3N3LiYFRZe6qTvU
         SHJeBzq8dmUOsWK3RGlSOOe2mhU4YerpXhNiXkpRoJVgNYCynW+XDIq2G6iM39WGiYbC
         SEjVxEOjn0xw6L/bw8Dge359n3xB9HEtOorrJITjZi7N8Nq/7F8TbKfxYbUfd6/3fLv3
         LRbzVLzNbdZ2CqpUmyrhYUkx9U598u2Q9Rt6elcY8wS2x7ppcol/lxtXTP05j64539Yk
         vQ9A==
X-Gm-Message-State: APjAAAWWpb/osTAtGvX/Y4IRTUz7pdrpqXZn9OFm+zt6Bl+gUtSPnQCR
        nxDZSj5nDzFf+3U5IdU65c8aXpS3Yg6138Qe+YyfbQ==
X-Google-Smtp-Source: APXvYqw4Ilzxya6hIiDOjE3ote/Aq97/U2eUbYXu5BS0rpMErX03XS26xpvIctl8LCuLv7fb5eKXBQulHLXp8GOn7Cg=
X-Received: by 2002:a05:600c:20c1:: with SMTP id y1mr12784864wmm.10.1565376765631;
 Fri, 09 Aug 2019 11:52:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org> <e13525a4-4885-e0f3-6711-efd83dd4a9fb@gmail.com>
In-Reply-To: <e13525a4-4885-e0f3-6711-efd83dd4a9fb@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 9 Aug 2019 21:52:07 +0300
Message-ID: <CAKv+Gu-X5D8U-getjTmpn1x50E41GvSRTPPvOL=NbB9Q33=PFQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
To:     Milan Broz <gmazyland@gmail.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        "Alasdair G. Kergon" <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 8 Aug 2019 at 14:53, Milan Broz <gmazyland@gmail.com> wrote:
>
> Hi,
>
> On 07/08/2019 07:50, Ard Biesheuvel wrote:
> > Instead of instantiating a separate cipher to perform the encryption
> > needed to produce the IV, reuse the skcipher used for the block data
> > and invoke it one additional time for each block to encrypt a zero
> > vector and use the output as the IV.
> >
> > For CBC mode, this is equivalent to using the bare block cipher, but
> > without the risk of ending up with a non-time invariant implementation
> > of AES when the skcipher itself is time variant (e.g., arm64 without
> > Crypto Extensions has a NEON based time invariant implementation of
> > cbc(aes) but no time invariant implementation of the core cipher other
> > than aes-ti, which is not enabled by default)
> >
> > This approach is a compromise between dm-crypt API flexibility and
> > reducing dependence on parts of the crypto API that should not usually
> > be exposed to other subsystems, such as the bare cipher API.
> >
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> For now I have just pair of images here to test, but seems checksums are ok.
>
> Tested-by: Milan Broz <gmazyland@gmail.com>
>
> I talked with Mike already, so it should go through DM tree now.
>

Thanks!


>
> > ---
> >  drivers/md/dm-crypt.c | 70 ++++++++++++++-----------------------------
> >  1 file changed, 22 insertions(+), 48 deletions(-)
> >
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index d5216bcc4649..48cd76c88d77 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -120,10 +120,6 @@ struct iv_tcw_private {
> >       u8 *whitening;
> >  };
> >
> > -struct iv_eboiv_private {
> > -     struct crypto_cipher *tfm;
> > -};
> > -
> >  /*
> >   * Crypt: maps a linear range of a block device
> >   * and encrypts / decrypts at the same time.
> > @@ -163,7 +159,6 @@ struct crypt_config {
> >               struct iv_benbi_private benbi;
> >               struct iv_lmk_private lmk;
> >               struct iv_tcw_private tcw;
> > -             struct iv_eboiv_private eboiv;
> >       } iv_gen_private;
> >       u64 iv_offset;
> >       unsigned int iv_size;
> > @@ -847,65 +842,47 @@ static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
> >       return 0;
> >  }
> >
> > -static void crypt_iv_eboiv_dtr(struct crypt_config *cc)
> > -{
> > -     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > -
> > -     crypto_free_cipher(eboiv->tfm);
> > -     eboiv->tfm = NULL;
> > -}
> > -
> >  static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
> >                           const char *opts)
> >  {
> > -     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > -     struct crypto_cipher *tfm;
> > -
> > -     tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
> > -     if (IS_ERR(tfm)) {
> > -             ti->error = "Error allocating crypto tfm for EBOIV";
> > -             return PTR_ERR(tfm);
> > +     if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags)) {
> > +             ti->error = "AEAD transforms not supported for EBOIV";
> > +             return -EINVAL;
> >       }
> >
> > -     if (crypto_cipher_blocksize(tfm) != cc->iv_size) {
> > +     if (crypto_skcipher_blocksize(any_tfm(cc)) != cc->iv_size) {
> >               ti->error = "Block size of EBOIV cipher does "
> >                           "not match IV size of block cipher";
> > -             crypto_free_cipher(tfm);
> >               return -EINVAL;
> >       }
> >
> > -     eboiv->tfm = tfm;
> >       return 0;
> >  }
> >
> > -static int crypt_iv_eboiv_init(struct crypt_config *cc)
> > +static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
> > +                         struct dm_crypt_request *dmreq)
> >  {
> > -     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > +     u8 buf[MAX_CIPHER_BLOCKSIZE] __aligned(__alignof__(__le64));
> > +     struct skcipher_request *req;
> > +     struct scatterlist src, dst;
> > +     struct crypto_wait wait;
> >       int err;
> >
> > -     err = crypto_cipher_setkey(eboiv->tfm, cc->key, cc->key_size);
> > -     if (err)
> > -             return err;
> > -
> > -     return 0;
> > -}
> > -
> > -static int crypt_iv_eboiv_wipe(struct crypt_config *cc)
> > -{
> > -     /* Called after cc->key is set to random key in crypt_wipe() */
> > -     return crypt_iv_eboiv_init(cc);
> > -}
> > +     req = skcipher_request_alloc(any_tfm(cc), GFP_KERNEL | GFP_NOFS);
> > +     if (!req)
> > +             return -ENOMEM;
> >
> > -static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
> > -                         struct dm_crypt_request *dmreq)
> > -{
> > -     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > +     memset(buf, 0, cc->iv_size);
> > +     *(__le64 *)buf = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
> >
> > -     memset(iv, 0, cc->iv_size);
> > -     *(__le64 *)iv = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
> > -     crypto_cipher_encrypt_one(eboiv->tfm, iv, iv);
> > +     sg_init_one(&src, page_address(ZERO_PAGE(0)), cc->iv_size);
> > +     sg_init_one(&dst, iv, cc->iv_size);
> > +     skcipher_request_set_crypt(req, &src, &dst, cc->iv_size, buf);
> > +     skcipher_request_set_callback(req, 0, crypto_req_done, &wait);
> > +     err = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
> > +     skcipher_request_free(req);
> >
> > -     return 0;
> > +     return err;
> >  }
> >
> >  static const struct crypt_iv_operations crypt_iv_plain_ops = {
> > @@ -962,9 +939,6 @@ static struct crypt_iv_operations crypt_iv_random_ops = {
> >
> >  static struct crypt_iv_operations crypt_iv_eboiv_ops = {
> >       .ctr       = crypt_iv_eboiv_ctr,
> > -     .dtr       = crypt_iv_eboiv_dtr,
> > -     .init      = crypt_iv_eboiv_init,
> > -     .wipe      = crypt_iv_eboiv_wipe,
> >       .generator = crypt_iv_eboiv_gen
> >  };
> >
> >
