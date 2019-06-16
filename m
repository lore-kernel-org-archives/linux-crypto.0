Return-Path: <SRS0=USLa=UP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD790C31E54
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 19:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA9FA20862
	for <linux-crypto@archiver.kernel.org>; Sun, 16 Jun 2019 19:07:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pJcilbq8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfFPTHn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 16 Jun 2019 15:07:43 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41945 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfFPTHm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 16 Jun 2019 15:07:42 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so16558893ioc.8
        for <linux-crypto@vger.kernel.org>; Sun, 16 Jun 2019 12:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jJg0OolIz2BW/cueVRr/fBaMqlwp5/uUHEbd8Srkloo=;
        b=pJcilbq8utuP5QGfGuQGWYZqF4hInsP9ad3/ybQzf/m+8lrNRfm9+tC/P3BAZKgTvL
         w71fljWdNXHolwsTKd71e+/dmXSE7O1Fyzrhqh+FfUSPRrMLNcjeZExK+2aXiTiModdN
         yg/qWgO+YVbePCnIvpLk8zURFe2Qi+euT6RLcM0MbJYQzudlzsV7qoIzuQ6UBT26veKW
         mX7zYJnCOWmGDfghiIyKoUUX802hEb4zndOzmCzpaSidKJs5FvSpNsfpBhr8tJeFFQXu
         AdpWIT8oKwB1Lx8HhL5sexB6IuZrAR38WkB3YQMHFkM5fvVsLU/kdkckmh0XO1Y1eBrl
         WfWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jJg0OolIz2BW/cueVRr/fBaMqlwp5/uUHEbd8Srkloo=;
        b=S9Su3rYnZ0mgSwaTDCCjpZWKAFaN7H4qjU+0coimdOfnWtZfMFIKvDl9WTX/i5PpjX
         bTf35EDHVxUQY4C0r8TQuDRoW6M1QiSEakPcOew8jVFSPirp5bLy81g/qKlnm5Lm2pK2
         30mBfEOe1phXI/4nNXaU3HG7vk2A4DGsituRkhlWKc82m1lxYogw9ZfC5baL/uiTky2m
         YKJ0ADg1LlI77By8ye0rE4TugGcS5ZdlIxJnEdyx0p1XBJKnXauMyh232hP8olraQ46J
         +/LayXjT+dNTbGSqXFc5VQ0cmQsq/oQnuF0EE5LYgdOxyaVEcFVkcrrL7RXUQk0dNXte
         9HvQ==
X-Gm-Message-State: APjAAAVZXAywyZyxHTR7ApsN/e99Yol4ilZVHe6uOUadhXmprZ28aQI+
        1ESEDqHfkqFoMFajemRxPw6LJ0J+AEP2znrrLYqEUIC+jdc=
X-Google-Smtp-Source: APXvYqzlQukL+swB/vkHq2brpL0CKFJoUu9kyknAqHdbNYipq5mwbidbuQclkF+hFT2duvaTyJ7RlWZtof8ZT0YsEOA=
X-Received: by 2002:a02:a815:: with SMTP id f21mr37965014jaj.130.1560712061024;
 Sun, 16 Jun 2019 12:07:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190614092922.22517-1-ard.biesheuvel@linaro.org> <20190616190136.GA923@sol.localdomain>
In-Reply-To: <20190616190136.GA923@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 16 Jun 2019 21:07:28 +0200
Message-ID: <CAKv+Gu_WiUcdKmDhtNf69P=uVxSLqV+RvscN9BhFg62mQTB=vA@mail.gmail.com>
Subject: Re: [PATCH] lib80211: use crypto API ccm(aes) transform for CCMP processing
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "<linux-wireless@vger.kernel.org>" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, 16 Jun 2019 at 21:01, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Hi Ard,
>
> On Fri, Jun 14, 2019 at 11:29:22AM +0200, Ard Biesheuvel wrote:
> > -static void ccmp_init_blocks(struct crypto_cipher *tfm,
> > -                          struct ieee80211_hdr *hdr,
> > -                          u8 * pn, size_t dlen, u8 * b0, u8 * auth, u8 * s0)
> > +static void ccmp_init_blocks(struct ieee80211_hdr *hdr,
> > +                          u8 * pn, size_t dlen, u8 * b0, u8 * aad)
> >  {
> >       u8 *pos, qc = 0;
> >       size_t aad_len;
> >       int a4_included, qc_included;
> > -     u8 aad[2 * AES_BLOCK_LEN];
> >
> >       a4_included = ieee80211_has_a4(hdr->frame_control);
> >       qc_included = ieee80211_is_data_qos(hdr->frame_control);
> > @@ -131,17 +123,19 @@ static void ccmp_init_blocks(struct crypto_cipher *tfm,
> >               aad_len += 2;
> >       }
> >
> > -     /* CCM Initial Block:
> > -      * Flag (Include authentication header, M=3 (8-octet MIC),
> > -      *       L=1 (2-octet Dlen))
> > -      * Nonce: 0x00 | A2 | PN
> > -      * Dlen */
> > -     b0[0] = 0x59;
> > +     /* In CCM, the initial vectors (IV) used for CTR mode encryption and CBC
> > +      * mode authentication are not allowed to collide, yet both are derived
> > +      * from this vector b0. We only set L := 1 here to indicate that the
> > +      * data size can be represented in (L+1) bytes. The CCM layer will take
> > +      * care of storing the data length in the top (L+1) bytes and setting
> > +      * and clearing the other bits as is required to derive the two IVs.
> > +      */
> > +     b0[0] = 0x1;
> > +
> > +     /* Nonce: QC | A2 | PN */
> >       b0[1] = qc;
> >       memcpy(b0 + 2, hdr->addr2, ETH_ALEN);
> >       memcpy(b0 + 8, pn, CCMP_PN_LEN);
> > -     b0[14] = (dlen >> 8) & 0xff;
> > -     b0[15] = dlen & 0xff;
> >
> >       /* AAD:
> >        * FC with bits 4..6 and 11..13 masked to zero; 14 is always one
> > @@ -166,16 +160,6 @@ static void ccmp_init_blocks(struct crypto_cipher *tfm,
> >               aad[a4_included ? 30 : 24] = qc;
> >               /* rest of QC masked */
> >       }
> > -
> > -     /* Start with the first block and AAD */
> > -     lib80211_ccmp_aes_encrypt(tfm, b0, auth);
> > -     xor_block(auth, aad, AES_BLOCK_LEN);
> > -     lib80211_ccmp_aes_encrypt(tfm, auth, auth);
> > -     xor_block(auth, &aad[AES_BLOCK_LEN], AES_BLOCK_LEN);
> > -     lib80211_ccmp_aes_encrypt(tfm, auth, auth);
> > -     b0[0] &= 0x07;
> > -     b0[14] = b0[15] = 0;
> > -     lib80211_ccmp_aes_encrypt(tfm, b0, s0);
> >  }
>
> How about shifting the contents of aad over by 2 bytes and returning the AAD
> length from this function instead?  It's confusing to still manually format the
> AAD length for CCM mode, when actually it's ignored now.
>
> Also I suggest fixing up the naming:
>
>         ccmp_init_blocks() => ccmp_init_iv_and_aad()
>         b0 => iv
>
> >
> >  static int lib80211_ccmp_hdr(struct sk_buff *skb, int hdr_len,
> > @@ -218,13 +202,13 @@ static int lib80211_ccmp_hdr(struct sk_buff *skb, int hdr_len,
> >  static int lib80211_ccmp_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
> >  {
> >       struct lib80211_ccmp_data *key = priv;
> > -     int data_len, i, blocks, last, len;
> > -     u8 *pos, *mic;
> >       struct ieee80211_hdr *hdr;
> > -     u8 *b0 = key->tx_b0;
> > -     u8 *b = key->tx_b;
> > -     u8 *e = key->tx_e;
> > -     u8 *s0 = key->tx_s0;
> > +     struct aead_request *req;
> > +     struct scatterlist sg[2];
> > +     u8 *aad = key->tx_aad;
> > +     u8 b0[AES_BLOCK_LEN];
> > +     int len, data_len;
> > +     int ret;
> >
> >       if (skb_tailroom(skb) < CCMP_MIC_LEN || skb->len < hdr_len)
> >               return -1;
> > @@ -234,31 +218,29 @@ static int lib80211_ccmp_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
> >       if (len < 0)
> >               return -1;
> >
> > -     pos = skb->data + hdr_len + CCMP_HDR_LEN;
> > +     req = kzalloc(sizeof(*req) + crypto_aead_reqsize(key->tfm), GFP_ATOMIC);
> > +     if (!req)
> > +             return -ENOMEM;
> > +
>
> Why not kzalloc() and kzfree() instead of aead_request_alloc() and
> aead_request_free()?  Same in lib80211_ccmp_decrypt().
>

Why kzalloc, right? (i.e., without the 'not'). Good question, I'll change that.

> Otherwise this patch looks good, though I'd like for someone to test it.
>
> Thanks for doing this!
>

As you know, I want to get rid of all the crypto cobbled together
using the cipher interface. I guess it's my turn to clean up some of
this mess :-)
