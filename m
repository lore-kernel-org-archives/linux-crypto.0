Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77491C3B189
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2835246B1
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="LiCA0Ujv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfLMP0h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:26:37 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:33341 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfLMP0h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Dec 2019 10:26:37 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id eab08f8d
        for <linux-crypto@vger.kernel.org>;
        Fri, 13 Dec 2019 14:30:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type:content-transfer-encoding; s=mail; bh=jvQm8bwLK124
        gLEtiGuBImsGtCM=; b=LiCA0Ujv4CER8TgITL5r38ZgnqOOUMHBEWJfw3UHb0Ni
        iwtqt+vkeZDs8OyMHmJEaVptPy82mzT8Z2woVaWh20+Hg7LfHo7SzRu6ZvCX1Wvs
        DDlNCWrCJBmnYJemlew6sJ442HeTW+enZnWBOwl4zj28KOpStvvpnhB6bLcv1jIN
        TesIfq7j3Vp5+5o4YjBrBYUW6VfOIcSKIfqSowLKNeQPIEsxpoohsoVjLRp+kj1S
        2sroYIqd4sdlD1lR+FSmy7zqHQYezMV88oAejwJOboYssWhhi88saSjUaNAXPqEi
        o2ruQf8kjiHBJ0fsdH3bto5qte+wIiB1J/cvxaXbrQ==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e9dce3bd (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 13 Dec 2019 14:30:39 +0000 (UTC)
Received: by mail-oi1-f170.google.com with SMTP id c16so454029oic.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Dec 2019 07:26:35 -0800 (PST)
X-Gm-Message-State: APjAAAXgKgAGX4VpoPEz3kuujAugNQfQIpUhygwDsvCpLCHgF8Pekk5y
        NW5+4YIiEPGW3zB7DyllE6FjmJkYiOzfvAKNu4E=
X-Google-Smtp-Source: APXvYqw/ISiDD6D5kuhcnQ/0Plebg6INZyySa7f4YuZn/RjHLcjZiVMXwtcl1S/gTAMKlfBMJm1F7ALWVTsZGV4f2NQ=
X-Received: by 2002:aca:2109:: with SMTP id 9mr6686414oiz.119.1576250794841;
 Fri, 13 Dec 2019 07:26:34 -0800 (PST)
MIME-Version: 1.0
References: <20191212173258.13358-1-Jason@zx2c4.com> <20191212173258.13358-2-Jason@zx2c4.com>
 <20191213030333.GA1109@sol.localdomain>
In-Reply-To: <20191213030333.GA1109@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Fri, 13 Dec 2019 16:26:23 +0100
X-Gmail-Original-Message-ID: <CAHmME9py920OxZ6LfZ6YdRswDbvhngYbwhwf2TPYFPhA7gw1PA@mail.gmail.com>
Message-ID: <CAHmME9py920OxZ6LfZ6YdRswDbvhngYbwhwf2TPYFPhA7gw1PA@mail.gmail.com>
Subject: Re: [PATCH crypto-next v3 1/3] crypto: poly1305 - add new 32 and
 64-bit generic versions
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Dec 13, 2019 at 4:03 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Thu, Dec 12, 2019 at 06:32:56PM +0100, Jason A. Donenfeld wrote:
> > diff --git a/include/crypto/internal/poly1305.h b/include/crypto/intern=
al/poly1305.h
> > index 479b0cab2a1a..ad97819711eb 100644
> > --- a/include/crypto/internal/poly1305.h
> > +++ b/include/crypto/internal/poly1305.h
> > @@ -11,11 +11,12 @@
> >  #include <crypto/poly1305.h>
> >
> >  /*
> > - * Poly1305 core functions.  These implement the =CE=B5-almost-=E2=88=
=86-universal hash
> > + * Poly1305 core functions.  These can implement the =CE=B5-almost-=E2=
=88=86-universal hash
> >   * function underlying the Poly1305 MAC, i.e. they don't add an encryp=
ted nonce
> > - * ("s key") at the end.  They also only support block-aligned inputs.
> > + * ("s key") at the end, by passing NULL to nonce.  They also only sup=
port
> > + * block-aligned inputs.
> >   */
>
> This comment is now ambiguous because the "i.e." clause wasn't updated to=
 match
> the change "implement" =3D> "can implement".
>
> This comment also wasn't updated when the 'hibit' argument was added earl=
ier
> anyway.  So how about just rewriting it like:
>
> /*
>  * Poly1305 core functions.  These only accept whole blocks; the caller m=
ust
>  * handle any needed block buffering and padding.  'hibit' must be 1 for =
any
>  * full blocks, or 0 for the final block if it had to be padded.  If 'non=
ce' is
>  * non-NULL, then it's added at the end to compute the Poly1305 MAC.  Oth=
erwise,
>  * only the =CE=B5-almost-=E2=88=86-universal hash function (not the full=
 MAC) is computed.
>  */
>

Sounds good.

> > diff --git a/include/crypto/nhpoly1305.h b/include/crypto/nhpoly1305.h
> > index 53c04423c582..a2f4e37b5107 100644
> > --- a/include/crypto/nhpoly1305.h
> > +++ b/include/crypto/nhpoly1305.h
> > @@ -33,7 +33,7 @@
> >  #define NHPOLY1305_KEY_SIZE  (POLY1305_BLOCK_SIZE + NH_KEY_BYTES)
> >
> >  struct nhpoly1305_key {
> > -     struct poly1305_key poly_key;
> > +     struct poly1305_key poly_key[2];
> >       u32 nh_key[NH_KEY_WORDS];
> >  };
>
> I still feel that this makes the code worse.  Before, poly1305_key was an=
 opaque
> type that represented a Poly1305 key.  After, users would need to know th=
at an
> array of 2 "keys" is needed, despite there actually being only one key.
>
> Given that this even caused an actual bug in v1 of this series, how about=
 going
> with a less error-prone approach?
>
> > +void poly1305_core_blocks(struct poly1305_state *state,
> > +                       const struct poly1305_key *key, const void *src=
,
> > +                       unsigned int nblocks, u32 hibit)
> > +{
> > +     const u8 *input =3D src;
> > +     u32 r0, r1, r2, r3, r4;
> > +     u32 s1, s2, s3, s4;
> > +     u32 h0, h1, h2, h3, h4;
> > +     u64 d0, d1, d2, d3, d4;
> > +     u32 c;
> > +
> > +     if (!nblocks)
> > +             return;
> > +
> > +     hibit <<=3D 24;
> > +
> > +     r0 =3D key[0].r[0];
> > +     r1 =3D key[0].r[1];
> > +     r2 =3D key[0].r[2];
> > +     r3 =3D key[0].r[3];
> > +     r4 =3D key[0].r[4];
> > +
> > +     s1 =3D key[1].r[0];
> > +     s2 =3D key[1].r[1];
> > +     s3 =3D key[1].r[2];
> > +     s4 =3D key[1].r[3];
>
> And some of the function prototypes, like this one, still give no indicat=
ion
> that 2 "keys" are needed...

I'll try to fix it up a bit using the type system.
