Return-Path: <SRS0=TZua=WD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5659AC32751
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 13:17:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1788221E6B
	for <linux-crypto@archiver.kernel.org>; Wed,  7 Aug 2019 13:17:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LMxKvnLG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388144AbfHGNR0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 7 Aug 2019 09:17:26 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45705 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387982AbfHGNR0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Aug 2019 09:17:26 -0400
Received: by mail-wr1-f65.google.com with SMTP id q12so1081123wrj.12
        for <linux-crypto@vger.kernel.org>; Wed, 07 Aug 2019 06:17:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LIwwnq+LH+wfwk2ZofLN/BZ4Mpy/yetSxoWKfADaX8s=;
        b=LMxKvnLGHshHkfpNm2LsHe1rcRXAGJhRzb9L5e76XWuqAOM3Aw/M1S43ujhCZ11xJN
         u84Xfaiz29X6LIehRQyV2BMU92pJq3UpNB/UO12xUUsd3OQfq7doj5BSRxOREFvxrZFq
         GM2ajqGDlLc5I3YuRIMz3fNrGFtT9ANyw98Wcocf3lqc6dJQ8aSSB/KdB/6V4n4xMa/8
         yVUwT3hiwCqUi0sdMN/Bs6uikCx00KXOz6jWHefBhSgqB5dyDYBFA6+6gvnmX/8I/h//
         Ig2VtOKDfDX4bqdE/3IagKN6LZsyap95yQZW/UBupqtLapuGPwEAE0BFdGEKq2GD0LO9
         JEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LIwwnq+LH+wfwk2ZofLN/BZ4Mpy/yetSxoWKfADaX8s=;
        b=ufXWmHjxl4pFeobr3AZJ523dpWYEKX+HXcGyybdgiugCSUMXEto2UL3XNj6vTU+WbQ
         JmLi/XBBIuaYq1rs+f6NYneUOJlOlBn30M8TOFMl5o/dLA+GRraNXCCZsiMwSfcnBYLV
         iQslT3WFWhq9hKY6Eg8aPpgmUg+Yy31lhcO4Q1vAqaA10e25KIOtycvHCmTc/LNbeJ+r
         qQTMIfzCbEu9H9RCg7HXiX24BUCAGpu0CbNaVw07Fj6CqHglPKdRUtHIeOOTUkKJo1xi
         AS6ApBXHdSQNx/8WU6SDRjMb1iGsr9TBEhnvpcN5xJkaXcvVfC8VC7/y5odNObR76IP9
         4l0g==
X-Gm-Message-State: APjAAAXx+pdJf30kqj4St12yz+7hfwFxWdp5nDiFN39b3geuNHLTWPRF
        30ZVewwC90FVyRAr4NmtCOhj6KMu2FfH9vNQVsrAew==
X-Google-Smtp-Source: APXvYqwe4bR/2BjNrMK0E52EYt8a2PTBVYlx9qD2wKkNKrz1qNTKPfn5aD4oqvJu19H2tmznt/KWZ9dNvlhwt5BE6YE=
X-Received: by 2002:a5d:46cf:: with SMTP id g15mr11376129wrs.93.1565183842685;
 Wed, 07 Aug 2019 06:17:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org> <MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
In-Reply-To: <MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 7 Aug 2019 16:17:14 +0300
Message-ID: <CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "gmazyland@gmail.com" <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 7 Aug 2019 at 10:28, Pascal Van Leeuwen
<pvanleeuwen@verimatrix.com> wrote:
>
> Ard,
>
> I've actually been following this discussion with some interest, as it has
> some relevance for some of the things I am doing at the moment as well.
>
> For example, for my CTS implementation I need to crypt one or two
> seperate blocks and for the inside-secure driver I sometimes need to do
> some single crypto block precomputes. (the XTS driver additionally
> also already did such a single block encrypt for the tweak, also using
> a seperate (non-sk)cipher instance - very similar to your IV case)
>
> Long story short, the current approach is to allocate a seperate
> cipher instance so you can conveniently do crypto_cipher_en/decrypt_one.
> (it would be nice to have a matching crypto_skcipher_en/decrypt_one
> function available from the crypto API for these purposes?)
> But if I understand you correctly, you may end up with an insecure
> table-based implementation if you do that. Not what I want :-(
>

Table based AES is known to be vulnerable to plaintext attacks on the
key, since each byte of the input xor'ed with the key is used as an
index for doing Sbox lookups, and so with enough samples, there is an
exploitable statistical correlation between the response time and the
key.

So in the context of EBOIV, where the user might specify a SIMD based
time invariant skcipher, it would be really bad if the known plaintext
encryptions of the byte offsets that occur with the *same* key would
happen with a different cipher that is allocated implicitly and ends
up being fulfilled by, e.g., aes-generic, since in that case, each
block en/decryption is preceded by a single, time-variant AES
invocation with an easily guessable input.

In your case, we are not dealing with known plaintext attacks, and the
higher latency of h/w accelerated crypto makes me less worried that
the final, user observable latency would strongly correlate the way
aes-generic in isolation does.

> However, in many cases there would actually be a very good reason
> NOT to want to use the main skcipher for this. As that is some
> hardware accelerator with terrible latency that you wouldn't want
> to use to process just one cipher block. For that, you want to have
> some SW implementation that is efficient on a single block instead.
>

Indeed. Note that for EBOIV, such performance concerns are deemed
irrelevant, but it is an issue in the general case.

> In my humble opinion, such insecure table based implementations just
> shouldn't exist at all - you can always do better, possibly at the
> expense of some performance degradation. Or you should at least have
> some flag  available to specify you have some security requirements
> and such an implementation is not an acceptable response.
>

We did some work to reduce the time variance of AES: there is the
aes-ti driver, and there is now also the AES library, which is known
to be slower than aes-generic, but does include some mitigations for
cache timing attacks.

Other than that, I have little to offer, given that the performance vs
security tradeoffs were decided long before security became a thing
like it is today, and so removing aes-generic is not an option,
especially since the scalar alternatives we have are not truly time
invariant either.


> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of
> > Ard Biesheuvel
> > Sent: Wednesday, August 7, 2019 7:50 AM
> > To: linux-crypto@vger.kernel.org
> > Cc: herbert@gondor.apana.org.au; ebiggers@kernel.org; agk@redhat.com; snitzer@redhat.com;
> > dm-devel@redhat.com; gmazyland@gmail.com; Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > Subject: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV generation
> >
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
> > --
> > 2.17.1
>
