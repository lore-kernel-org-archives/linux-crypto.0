Return-Path: <SRS0=eQ+U=3S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B676BC33CB2
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 11:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BE572071E
	for <linux-crypto@archiver.kernel.org>; Wed, 29 Jan 2020 11:28:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="oPp1U9L5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726068AbgA2L2Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 29 Jan 2020 06:28:25 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:33500 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgA2L2Z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 29 Jan 2020 06:28:25 -0500
Received: by mail-vk1-f193.google.com with SMTP id i78so4672145vke.0
        for <linux-crypto@vger.kernel.org>; Wed, 29 Jan 2020 03:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KAVxi2jUpaSOMH9MjkyK4jIEapVEWsyDIKYn69cYqhQ=;
        b=oPp1U9L59tbKdM2PNq6+grDDTFTKQW5KUdHMnIy3AgG+UgkLFp8sGR5t9qtzVw+j6b
         qYoErT/VbYQLAcfN3skVI/T1CpHFZH78YCy+1SBqdxrHnYjU2wsvtVrbiO0G4We4IEWe
         jBxY46H3KS+nUCfToHcqEswgRLg5vRe8H1KMFfvOy1j7jEx+sEUqa4wa7/gkOmQdltX3
         s+FbdN/X4VCuYsHtEty9Q5LmR7PwIc/gRESWtuB5+pqPESH7TbT1X4HVxM6mbSFuWL9r
         1viIjV+9kjyoZGBy1p7JJ+08ngO03Q/QVZmOn9fQRPHgabcjnhbm8McXIrJrcAwh49Vm
         bYgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KAVxi2jUpaSOMH9MjkyK4jIEapVEWsyDIKYn69cYqhQ=;
        b=KJJCCsfnmXXWHF9JqzQR0hINO7LnJG1SLrREVM+P6yO9z8Y/gXa+1Wg03V+IHoiBU0
         MKAVJkk6j6CCAcqd1bYnOryRHtb3ENUAVzso1RcYYuugrc9TMmrTU/+30phnTzzpeMh1
         +Geuidm8J0XPOs45ihTl/fZ/mxbaELNUnCh6mz6/a32ETj6+iGt3hLLHMD3a2Ca0eH5k
         FIVBlJvTHvRXyzqQ8pWAjKoAyEm3MI9jXWsW4eMz6m7yohX8yikAEPohD5gdWeEcbn7J
         5bGL2tV3HKsGUnu98vwofLGP9iUYuiqkcoylXRfIlQhQUFSQ5Udj70oim65aZvs3gUvw
         +ZEw==
X-Gm-Message-State: APjAAAUvKGqoJE9LEanuCUBafaScG9rEaRS0lOCILhN3gHiyWq3VKoHS
        peoCyJu4nKa53Nf7j7TM4haqV7kdr/GecVVLNL9oWw==
X-Google-Smtp-Source: APXvYqyMmVakcKWGNAwBc2CXiO5Y1MXEtLhuoiYyYofGXSc8sKL5YRBiWUtyh9WdW/lMheWCQ2kobuQdxkbLrgmRtUU=
X-Received: by 2002:a1f:7cc2:: with SMTP id x185mr15939952vkc.1.1580297303740;
 Wed, 29 Jan 2020 03:28:23 -0800 (PST)
MIME-Version: 1.0
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <20200128023455.GC960@sol.localdomain> <20200128033824.p3z3jhc7mp7wlikp@gondor.apana.org.au>
 <CAOtvUMeJmhXL2V74e+LGxDEUJcDy5=f+x0MH86eyHq0u=HvKXw@mail.gmail.com> <20200128211229.GA224488@gmail.com>
In-Reply-To: <20200128211229.GA224488@gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Wed, 29 Jan 2020 13:28:12 +0200
Message-ID: <CAOtvUMc3tx5g=QCdzGAbGcKPXf6yQXB0DgrbJVf9J0LubGZyeA@mail.gmail.com>
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

Yes, of course. I understand the purpose all of this serves.

>
> > - The only way to tell if this is in-place encryption or not is to
> > compare the pointers to the source and destination - there is no flag.
>
> Requiring users to remember to provide a flag to indicate in-place
> encryption/decryption, in addition to passing the same scatterlist, would=
 make
> the API more complex.
>

Asking the user to provide the flag is throwing the problem at the user -
so indeed, not a good idea. But that still doesn't mean we need to have
"rea->src =3D=3D req->dst" in every driver. We can have the API framework
do this.

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

Yes, if it is indeed a scatterlist and length. In fact it isn't - it's
a scatterlist
and four different lengths: plaintext, associated data, IV and auth tag.
Some of them are used in various scenarios and some aren't.
Which is exactly my point.

> requiring a dereferencable pointer for length =3D 0 is generally consider=
ed to be
> bad API design; see the memcpy() fiasco
> (https://www.imperialviolet.org/2016/06/26/nonnull.html).

Yes, that's not a good option - but neither is having a comment that
can be read to imply
that the API requires it if it doesn't :-)

Thinking about it, I'm wondering if having something like this will
save boilerplate code in many drivers:

static inline bool crypto_aead_inplace(struct aead_request req)
{
        return (req->src =3D=3D req->dst);
}

unsigned int crypto_aead_sg_len(struct aead_request req, bool enc, bool src=
,
                                 int authsize, bool need_iv)
{
        struct crypto_aead *tfm =3D crypto_aead_reqtfm(req);
        unsigned int len =3D req->assoclen + req->cryptlen;

        if (need_iv)
                len +=3D crypto_aead_ivsize(tfm);

        if (src && !enc) || (!src && enc) || crypto_aead_inplace(req))
                len +=3D authsize;

        return len;
}

It would be better even if we can put the authsize and need_iv into the tfv
at registration time and not have to pass them as parameters at all.

<snip>

Anyways, thanks for entertaining my ramblings... :-)

Thanks,
Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
