Return-Path: <SRS0=Wq3S=VB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DD35C0651F
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 14:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAC73218A3
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jul 2019 14:28:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oBAeo/IH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfGDO2v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jul 2019 10:28:51 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40882 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfGDO2v (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jul 2019 10:28:51 -0400
Received: by mail-wr1-f67.google.com with SMTP id r1so525701wrl.7
        for <linux-crypto@vger.kernel.org>; Thu, 04 Jul 2019 07:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dseQ2w7kiOe0C10IMpeQTb3ExkLhhvoRu7lf+rkm25I=;
        b=oBAeo/IH4WgIqgL5ZoUQhNsyb3QmkMu4UIjK9KNsI9kUQD3U9hcE+Qln43i5aTpP5q
         LbWGSi22A6EigZYCfDXm5L982a1wwKZoG+ngsVaJwo0Wwb2O3mcpj6yGmI+vptuSXltl
         zUaSBah+zDhB42ksreT7RwK4tvkbjXLSSAMu49c+IKTkGoYu0Vvrtum2ajN3bXMDfkHd
         oYTlGDANAIRiHZ8HnEY/u7N8LNcWqbJE4ryHSSaQzMUWhE3pZ4dTVakoHQ6Xaw3BDXla
         bHyzKO/2e+KZLUeGlzkBo0awWKun78jy49244UQ8V5nQTDtV3QhNtlHWpJneUs9xLvwp
         4dJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dseQ2w7kiOe0C10IMpeQTb3ExkLhhvoRu7lf+rkm25I=;
        b=UONDULwVD1FsBEHXh/nHb0hGJtTY3QyjyrmrNal+VoOOFGrSTAcJnsuvfMNvvrAcSL
         FIxmV4/iLHI5DXE5HjU2lRzZIqdd6Npdsy5+bIW7qlKfWI7L9r77vHEnzOqWqAou6vWA
         Own8BdPadRW/D72kz0uuAtfE7HFxCAfYNu4edh9TtBnc7LfsWjUjX0bynL6aZDqtTZfb
         RKkxM0GotudHkcETobKOkXh2aEoMhqBpBvlwsoZXUY3DCXzhuZH7dADpGSoyXG++vSFj
         C/IAU7MnfmBFpKZeepCspzjZpaneB5s9K6ZhkiYoxWB4s+GvhLcyfEi4jraWzA7t+mPW
         Acmw==
X-Gm-Message-State: APjAAAX4FbB4sxmo34562RW2/3S4i7HpNa7dlOae8BgOgFS6Pzu/8dlq
        ZzrXFbj2e/ydAXZ7nuAX1IpgjkiW6UAJpAEF3/acfQ==
X-Google-Smtp-Source: APXvYqyTqz1CW6nRNRsDqlu/p5Hmr3rrUV0azy44cmg42hr0Zu/Vq60L0/P5xCnyroUs2ZVW3qZ0Yu20/WJ8ZYQUUe4=
X-Received: by 2002:a5d:5589:: with SMTP id i9mr24549078wrv.198.1562250528596;
 Thu, 04 Jul 2019 07:28:48 -0700 (PDT)
MIME-Version: 1.0
References: <20190704131033.9919-1-gmazyland@gmail.com> <20190704131033.9919-3-gmazyland@gmail.com>
 <7a8d13ee-2d3f-5357-48c6-37f56d7eff07@gmail.com>
In-Reply-To: <7a8d13ee-2d3f-5357-48c6-37f56d7eff07@gmail.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 4 Jul 2019 16:28:32 +0200
Message-ID: <CAKv+Gu_c+OpOwrr0dSM=j=HiDpfM4sarq6u=6AXrU8jwLaEr-w@mail.gmail.com>
Subject: Re: [PATCH 3/3] dm-crypt: Implement eboiv - encrypted byte-offset
 initialization vector.
To:     Milan Broz <gmazyland@gmail.com>,
        Eric Biggers <ebiggers@google.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(+ Eric)

On Thu, 4 Jul 2019 at 15:29, Milan Broz <gmazyland@gmail.com> wrote:
>
> Hi Herbert,
>
> I have a question about the crypto_cipher API in dm-crypt:
>
> We are apparently trying to deprecate cryto_cipher API (see the ESSIV patchset),
> but I am not sure what API now should be used instead.
>

Not precisely - what I would like to do is to make the cipher part of
the internal crypto API. The reason is that there are too many
occurrences where non-trivial chaining modes have been cobbled
together from the cipher API.

> See the patch below - all we need is to one block encryption for IV.
>
> This algorithm makes sense only for FDE (old compatible Bitlocker devices),
> I really do not want this to be shared in some crypto module...
>
> What API should I use here? Sync skcipher? Is the crypto_cipher API
> really a problem in this case?
>

Are arbitrary ciphers supported? Or are you only interested in AES? In
the former case, I'd suggest the sync skcipher API to instantiate
"ecb(%s)", otherwise, use the upcoming AES library interface.

> On 04/07/2019 15:10, Milan Broz wrote:
> > This IV is used in some BitLocker devices with CBC encryption mode.
> >
> > NOTE: maybe we need to use another crypto API if the bare cipher
> >       API is going to be deprecated.
> >
> > Signed-off-by: Milan Broz <gmazyland@gmail.com>
> > ---
> >  drivers/md/dm-crypt.c | 82 ++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 81 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > index 96ead4492787..a5ffa1ac6a28 100644
> > --- a/drivers/md/dm-crypt.c
> > +++ b/drivers/md/dm-crypt.c
> > @@ -120,6 +120,10 @@ struct iv_tcw_private {
> >       u8 *whitening;
> >  };
> >
> > +struct iv_eboiv_private {
> > +     struct crypto_cipher *tfm;
> > +};
> > +
> >  /*
> >   * Crypt: maps a linear range of a block device
> >   * and encrypts / decrypts at the same time.
> > @@ -159,6 +163,7 @@ struct crypt_config {
> >               struct iv_benbi_private benbi;
> >               struct iv_lmk_private lmk;
> >               struct iv_tcw_private tcw;
> > +             struct iv_eboiv_private eboiv;
> >       } iv_gen_private;
> >       u64 iv_offset;
> >       unsigned int iv_size;
> > @@ -290,6 +295,10 @@ static struct crypto_aead *any_tfm_aead(struct crypt_config *cc)
> >   *       is calculated from initial key, sector number and mixed using CRC32.
> >   *       Note that this encryption scheme is vulnerable to watermarking attacks
> >   *       and should be used for old compatible containers access only.
> > + *
> > + * eboiv: Encrypted byte-offset IV (used in Bitlocker in CBC mode)
> > + *        The IV is encrypted little-endian byte-offset (with the same key
> > + *        and cipher as the volume).
> >   */
> >
> >  static int crypt_iv_plain_gen(struct crypt_config *cc, u8 *iv,
> > @@ -838,6 +847,67 @@ static int crypt_iv_random_gen(struct crypt_config *cc, u8 *iv,
> >       return 0;
> >  }
> >
> > +static void crypt_iv_eboiv_dtr(struct crypt_config *cc)
> > +{
> > +     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > +
> > +     crypto_free_cipher(eboiv->tfm);
> > +     eboiv->tfm = NULL;
> > +}
> > +
> > +static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
> > +                         const char *opts)
> > +{
> > +     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > +     struct crypto_cipher *tfm;
> > +
> > +     tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
> > +     if (IS_ERR(tfm)) {
> > +             ti->error = "Error allocating crypto tfm for EBOIV";
> > +             return PTR_ERR(tfm);
> > +     }
> > +
> > +     if (crypto_cipher_blocksize(tfm) != cc->iv_size) {
> > +             ti->error = "Block size of EBOIV cipher does "
> > +                         "not match IV size of block cipher";
> > +             crypto_free_cipher(tfm);
> > +             return -EINVAL;
> > +     }
> > +
> > +     eboiv->tfm = tfm;
> > +     return 0;
> > +}
> > +
> > +static int crypt_iv_eboiv_init(struct crypt_config *cc)
> > +{
> > +     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > +     int err;
> > +
> > +     err = crypto_cipher_setkey(eboiv->tfm, cc->key, cc->key_size);
> > +     if (err)
> > +             return err;
> > +
> > +     return 0;
> > +}
> > +
> > +static int crypt_iv_eboiv_wipe(struct crypt_config *cc)
> > +{
> > +     /* Called after cc->key is set to random key in crypt_wipe() */
> > +     return crypt_iv_eboiv_init(cc);
> > +}
> > +
> > +static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
> > +                         struct dm_crypt_request *dmreq)
> > +{
> > +     struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
> > +
> > +     memset(iv, 0, cc->iv_size);
> > +     *(__le64 *)iv = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
> > +     crypto_cipher_encrypt_one(eboiv->tfm, iv, iv);
> > +
> > +     return 0;
> > +}
> > +
> >  static const struct crypt_iv_operations crypt_iv_plain_ops = {
> >       .generator = crypt_iv_plain_gen
> >  };
> > @@ -890,6 +960,14 @@ static struct crypt_iv_operations crypt_iv_random_ops = {
> >       .generator = crypt_iv_random_gen
> >  };
> >
> > +static struct crypt_iv_operations crypt_iv_eboiv_ops = {
> > +     .ctr       = crypt_iv_eboiv_ctr,
> > +     .dtr       = crypt_iv_eboiv_dtr,
> > +     .init      = crypt_iv_eboiv_init,
> > +     .wipe      = crypt_iv_eboiv_wipe,
> > +     .generator = crypt_iv_eboiv_gen
> > +};
> > +
> >  /*
> >   * Integrity extensions
> >   */
> > @@ -2293,6 +2371,8 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
> >               cc->iv_gen_ops = &crypt_iv_benbi_ops;
> >       else if (strcmp(ivmode, "null") == 0)
> >               cc->iv_gen_ops = &crypt_iv_null_ops;
> > +     else if (strcmp(ivmode, "eboiv") == 0)
> > +             cc->iv_gen_ops = &crypt_iv_eboiv_ops;
> >       else if (strcmp(ivmode, "lmk") == 0) {
> >               cc->iv_gen_ops = &crypt_iv_lmk_ops;
> >               /*
> > @@ -3093,7 +3173,7 @@ static void crypt_io_hints(struct dm_target *ti, struct queue_limits *limits)
> >
> >  static struct target_type crypt_target = {
> >       .name   = "crypt",
> > -     .version = {1, 18, 1},
> > +     .version = {1, 19, 0},
> >       .module = THIS_MODULE,
> >       .ctr    = crypt_ctr,
> >       .dtr    = crypt_dtr,
> >
