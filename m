Return-Path: <SRS0=oWw0=3Z=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1677EC35254
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 14:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCADD217F4
	for <linux-crypto@archiver.kernel.org>; Wed,  5 Feb 2020 14:48:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="unm1bnKx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgBEOsa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 Feb 2020 09:48:30 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:41483 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgBEOsa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 Feb 2020 09:48:30 -0500
Received: by mail-vs1-f65.google.com with SMTP id k188so1472012vsc.8
        for <linux-crypto@vger.kernel.org>; Wed, 05 Feb 2020 06:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hhD/UScHDJfSCz4iAnaOyAySNJ6o13kumjiZ2vFlmH8=;
        b=unm1bnKx704LjMqxyYGgSIK06NyOK8067zrR3vy19QkuBCEF6Ybhri+nC7/JRIVQ7C
         sGX7NCSlRmUQ829+MmaExvvdzKtmNW3Jsl9uE7fozpkTiH7YYqx3NOXNDHP+xWv62pqC
         CODjxDqNvue6cabQw6Gv5hK4t22DFXSkd4vIIy0VICwygvVvHeh1OagssxBkaiy2DN8b
         XDwNwNEKcvivxcvjvw5ivJG2G5xKfCYbplrdBA5ex4QPd47H+Y148d7Ab6BfQdEN3vmn
         UeWY120N7JzjYtoCFiMQOgeQedhuZ+zV5KLcbCLhoS2bsvz/6SsjhgY1z1nBVwcWlE5P
         Ysjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hhD/UScHDJfSCz4iAnaOyAySNJ6o13kumjiZ2vFlmH8=;
        b=PMkpcY1j3EiMs39RJQHLwvfNzot0KCKbptS3z9Tr2CZD7yyHREami622+5jhZ293JJ
         mWSCkJE9N49cWxU5L79FF+IejYcntz9cAkD6jnJcywobJdhx3oPWJ5KJEI1iVQSkow+5
         d0EUzQ2kFEN/PW5plbQE5s/E0ipVOwi2LYMkwVUPu8+rYCyUJnuAgsU+FYJGqYbQSdrx
         s6rW04qDRBJU+WIaN3yLZ5mI0Z4g6poV7W0Babopir1NVo7N0emA6RlrBycibdILPyKa
         qc9FEdkwJWmYc/M+HrTuh1j6e7bBCzSbTbdCNR20QwHEiCFnxFl75Hk3xfoBK0T1Gvmq
         CGJQ==
X-Gm-Message-State: APjAAAUwDcsG0HQDgjxnot1LiFpydFUkZUWeLWEBw7Ryhl/cPVov/2OD
        XnxkwQNanTcw1ov1CW3uhqGca1axMUOjucppTTs3bg==
X-Google-Smtp-Source: APXvYqyT+5yO0im9ksEZ8WHj/fonA2Om/ZyikafsGnCDechPG7m3EQaY6pWhNWDUjw5/CSdlRt9bEJ8W/WCuLJ0xkhw=
X-Received: by 2002:a67:fb14:: with SMTP id d20mr21027644vsr.136.1580914107218;
 Wed, 05 Feb 2020 06:48:27 -0800 (PST)
MIME-Version: 1.0
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <20200128023455.GC960@sol.localdomain> <20200128033824.p3z3jhc7mp7wlikp@gondor.apana.org.au>
 <CAOtvUMeJmhXL2V74e+LGxDEUJcDy5=f+x0MH86eyHq0u=HvKXw@mail.gmail.com> <20200128211229.GA224488@gmail.com>
In-Reply-To: <20200128211229.GA224488@gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 5 Feb 2020 16:48:16 +0200
Message-ID: <CAOtvUMeVXTDvH5bxVFemYmD9rpZ=xX3MkypAGyZn5VROw6sgZg@mail.gmail.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 28, 2020 at 11:12 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Jan 28, 2020 at 09:24:25AM +0200, Gilad Ben-Yossef wrote:
> > - The source is presumed to have enough room for both the associated
> > data and the plaintext.
> > - Unless it's in-place encryption, in which case, you also presume to
> > have room for the authentication tag
>
> The authentication tag is part of the ciphertext, not the plaintext.  So =
the
> rule is just that the ciphertext buffer needs to have room for it, not th=
e
> plaintext.
>
> Of course, when doing in-place encryption/decryption, the two buffers are=
 the
> same, so both will have room for it, even though the tag is only meaningf=
ul on
> the ciphertext side.  That's just the logical consequence of "in-place".
>
> > - The only way to tell if this is in-place encryption or not is to
> > compare the pointers to the source and destination - there is no flag.
>
> Requiring users to remember to provide a flag to indicate in-place
> encryption/decryption, in addition to passing the same scatterlist, would=
 make
> the API more complex.
>
> > - You can count on the scattergather list not having  a first NULL
> > buffer, *unless* the plaintext and associated data length are both
> > zero AND it's not in place encryption.
> > - You can count on not getting NULL as a scatterlist point, *unless*
> > the plaintext and associated data length are both zero AND it's not in
> > place encryption. (I'm actually unsure of this one?)
>
> If we consider that the input is not just a scatterlist, but rather a
> scatterlist and a length, then these observations are really just "you ca=
n
> access the first byte, unless the length is 0" -- which is sort of obviou=
s.  And
> requiring a dereferencable pointer for length =3D 0 is generally consider=
ed to be
> bad API design; see the memcpy() fiasco
> (https://www.imperialviolet.org/2016/06/26/nonnull.html).
>
> The API could be simplified by only supporting full scatterlists, but it =
seems
> that users are currently relying on being able to encrypt/decrypt just a =
prefix.
>
> IMO, the biggest problems with the AEAD API are actually things you didn'=
t
> mention, such as the fact that the AAD isn't given in a separate scatterl=
ist,
> and that the API only supports scatterlists and not virtual addresses (wh=
ich
> makes it difficult to use in some cases).
>
> In any case we do need much better documentation.  I'm planning to improv=
e some
> of the crypto API documentation, but I'll probably do the hash and skciph=
er
> algorithm types first before getting to AEAD.  So if you want to improve =
the
> AEAD documentation in the mean time, please go ahead.

Probably another issue with my driver, but just in case -
include/crypot/aead.h says:

 * The scatter list pointing to the input data must contain:
 *
 * * for RFC4106 ciphers, the concatenation of
 *   associated authentication data || IV || plaintext or ciphertext. Note,=
 the
 *   same IV (buffer) is also set with the aead_request_set_crypt call. Not=
e,
 *   the API call of aead_request_set_ad must provide the length of the AAD=
 and
 *   the IV. The API call of aead_request_set_crypt only points to the size=
 of
 *   the input plaintext or ciphertext.

I seem to be missing the place where this is handled in
generate_random_aead_testvec()
and generate_aead_message()

We seem to be generating a random IV for providing as the parameter to
aead_request_set_crypt()
but than have other random bytes set in aead_request_set_ad() - or am
I'm missing something again?

My apologies if this is just me suffering from lack of coffee...

Thanks!
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
