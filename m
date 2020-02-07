Return-Path: <SRS0=xktg=33=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B8AC352A2
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 11:51:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A485B20838
	for <linux-crypto@archiver.kernel.org>; Fri,  7 Feb 2020 11:51:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="i/J1a+c3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgBGLvH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 7 Feb 2020 06:51:07 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:38857 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgBGLvH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 7 Feb 2020 06:51:07 -0500
Received: by mail-vs1-f65.google.com with SMTP id r18so1019187vso.5
        for <linux-crypto@vger.kernel.org>; Fri, 07 Feb 2020 03:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nCx6jLVRpNQVgGkkHrxN06X1SBx4IO3a9+xDsN5YYmc=;
        b=i/J1a+c3vFAPSjOLWlfsf+OTGEHGFDocQ8r06FQJEDM6qvjQqsb+nMflG4o00oIOVI
         0nDQ5epRLIgPRoP7gDI2bYTTcHw3QHAUajWTDTHBQOIgWPQBFe8rYU4u/UW2fI18xIy3
         tfdhJVLZB9+Qo53Phj6Utk8XbreEKGqdSux+c0Nk/LdDmJULRy4jAV1Cp397aUxjmHO2
         a20lxnTEU3hAux8dBuhAZ9QM1Wj9oOZInda95+hPgrzC58Tyhk8lO+mWO79Af96L9ord
         iKC5xFiCrmxcvvJolbtDhxs8jEHl0iwbDK20PI2oSrHUa0NDFwmb/EzFpnQh0fWYvn//
         m6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nCx6jLVRpNQVgGkkHrxN06X1SBx4IO3a9+xDsN5YYmc=;
        b=I3wWMYF+9MRlN2tI1cT2tNqrKhgdMPvIyvBmLYOvUqJrOOHpkCqCciN/mwrfHbYquR
         Z7iEYNb235MrD6EbpqFkPlku4SrecVPPkJv3MyXkTpJJJwOhe53RYSoyegNX94P2It08
         KiZcQfhAszd0COK3hYPH0fCRqO0cykAlxydRTEzSfWMHoTOyUFERpVOLn8ntDWaNhgGJ
         O5f+CnhuLQ/nnoHTLkVXOPPxvzcmuyufFyo9LqjrizJSsBZKYwax+wYXy/uvTllrycgg
         VDSYRa28n76NqmNLIulU+ubwW/9dT0bKaRUDHX3Sn730R4bBSqmkaMHExIciVmKLF2Fs
         bxjA==
X-Gm-Message-State: APjAAAXrSHpLSG4fwIET+/Bc7ZmtDN+gQqhyzOn0SsQedGZTWPFL1n85
        D780YytoIIswJyPpDsweuH/5aym2pkFSO3yRtSz/oA==
X-Google-Smtp-Source: APXvYqz3UQndenixuBtRoK87HqhQS5YFlaZ0y4G5Mgz7ThlUvgt+SHj7xoj2TBtOxOUWJg727ldZYCbQEhCezOGZcmE=
X-Received: by 2002:a67:c90d:: with SMTP id w13mr4602849vsk.164.1581076265458;
 Fri, 07 Feb 2020 03:51:05 -0800 (PST)
MIME-Version: 1.0
References: <CAOtvUMcwLtwgigFE2mx7LVjhhEgcZsSS4WyR_SQ2gixTZxyBfg@mail.gmail.com>
 <CAOtvUMeVXTDvH5bxVFemYmD9rpZ=xX3MkypAGyZn5VROw6sgZg@mail.gmail.com>
 <20200207072709.GB8284@sol.localdomain> <28236835.Fk5ARk2Leh@tauon.chronox.de>
In-Reply-To: <28236835.Fk5ARk2Leh@tauon.chronox.de>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Fri, 7 Feb 2020 13:50:51 +0200
Message-ID: <CAOtvUMchWrNsvmLJ2D-qiGOAAgbr_yxtt3h81yOHesa7C6ifZQ@mail.gmail.com>
Subject: Re: Possible issue with new inauthentic AEAD in extended crypto tests
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
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

On Fri, Feb 7, 2020 at 9:56 AM Stephan Mueller <smueller@chronox.de> wrote:
>
> Am Freitag, 7. Februar 2020, 08:27:09 CET schrieb Eric Biggers:
>
> Hi Eric,
>
> > On Wed, Feb 05, 2020 at 04:48:16PM +0200, Gilad Ben-Yossef wrote:
> > > Probably another issue with my driver, but just in case -
> > >
> > > include/crypot/aead.h says:
> > >  * The scatter list pointing to the input data must contain:
> > >  *
> > >  * * for RFC4106 ciphers, the concatenation of
> > >  *   associated authentication data || IV || plaintext or ciphertext.
> > >  Note, the *   same IV (buffer) is also set with the
> > >  aead_request_set_crypt call. Note, *   the API call of
> > >  aead_request_set_ad must provide the length of the AAD and *   the I=
V.
> > >  The API call of aead_request_set_crypt only points to the size of *
> > >  the input plaintext or ciphertext.
> > >
> > > I seem to be missing the place where this is handled in
> > > generate_random_aead_testvec()
> > > and generate_aead_message()
> > >
> > > We seem to be generating a random IV for providing as the parameter t=
o
> > > aead_request_set_crypt()
> > > but than have other random bytes set in aead_request_set_ad() - or am
> > > I'm missing something again?
> >
> > Yes, for rfc4106 the tests don't pass the same IV in both places.  This=
 is
> > because I wrote the tests from the perspective of a generic AEAD that
> > doesn't have this weird IV quirk, and then I added the minimum quirks t=
o
> > get the weird algorithms like rfc4106 passing.
> >
> > Since the actual behavior of the generic implementation of rfc4106 is t=
hat
> > the last 8 bytes of the AAD are ignored, that means that currently the
> > tests just avoid mutating these bytes when generating inauthentic input
> > tests.  They don't know that they're (apparently) meant to be another c=
opy
> > of the IV.
> >
> > So it seems we need to clearly define the behavior when the two IV copi=
es
> > don't match.  Should one or the other be used, should an error be retur=
ned,
> > or should the behavior be unspecified (in which case the tests would ne=
ed
> > to be updated)?
> >
> > Unspecified behavior is bad, but it would be easiest for software to us=
e
> > req->iv, while hardware might want to use the IV in the scatterlist...
> >
> > Herbert and Stephan, any idea what was intended here?
> >
> > - Eric
>
> The full structure of RFC4106 is the following:
>
> - the key to be set is always 4 bytes larger than required for the respec=
tive
> AES operation (i.e. the key is 20, 28 or 36 bytes respectively). The key =
value
> contains the following information: key || first 4 bytes of the IV (note,=
 the
> first 4 bytes of the IV are the bytes derived from the KDF invoked by IKE=
 -
> i.e. they come from user space and are fixed)
>
> - data block contains AAD || trailing 8 bytes of IV || plaintext or ciphe=
rtext
> - the trailing 8 bytes of the IV are the SPI which is updated for each ne=
w
> IPSec package
>
> aead_request_set_ad points to the AAD plus the 8 bytes of IV in the use c=
ase
> of rfc4106(gcm(aes)) as part of IPSec.
>
> Considering your question about the aead_request_set_ad vs
> aead_request_set_crypt I think the RFC4106 gives the answer: the IV is us=
ed in
> two locations considering that the IV is also the SPI in our case. If you=
 see
> RFC 4106 chapter 3 you see the trailing 8 bytes of the IV as, well, the G=
CM IV
> (which is extended by the 4 byte salt as defined in chapter 4 that we pro=
vide
> with the trailing 4 bytes of the key). The kernel uses the SPI for this. =
In
> chapter 5 RFC4106 you see that the SP is however used as part of the AAD =
as
> well.
>
> Bottom line: if you do not set the same IV value for both, the AAD and th=
e GCM
> IV, you deviate from the use case of rfc4106(gcm(aes)) in IPSec. Yet, fro=
m a
> pure mathematical point of view and also from a cipher implementation poi=
nt of
> view, it does not matter whether the AAD and the IV point to the same val=
ue -
> the implementation must always process that data. The result however will=
 not
> be identical to the IPSec use case.
>

It is correct, but is it smart?

Either we require the same IV to be passed twice as we do today, in which c=
ase
passing different IV should fail in a predictable manner OR we should defin=
e
the operation is taking two IV like structures - one as the IV and one as
bytes in the associated data and have the IPsec code use it in a specific w=
ay of
happen to pass the same IV in both places.

I don't care either way - but right now the tests basically relies on
undefined behaviour
which is always a bad thing, I think.

Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
