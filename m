Return-Path: <SRS0=waMk=NM=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-oi1-f195.google.com ([209.85.167.195]:33179 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727753AbeKAReu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Nov 2018 13:34:50 -0400
MIME-Version: 1.0
References: <20181019230153.28201-1-dbaryshkov@gmail.com> <CAKv+Gu8eiFXoC2MWjGUG_AgDNq5rduWQN0CC4Q4BM0pjWW3B-w@mail.gmail.com>
 <1540109262.3023.6.camel@HansenPartnership.com>
In-Reply-To: <1540109262.3023.6.camel@HansenPartnership.com>
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Date: Thu, 1 Nov 2018 11:32:37 +0300
Message-ID: <CALT56yNN6N8J040Ce7B-FgGSyO0WngUoePp+3TsVn3PpvEQORw@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: fix cfb mode decryption
To: James.Bottomley@hansenpartnership.com
Cc: ard.biesheuvel@linaro.org, linux-crypto@vger.kernel.org,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

=D0=B2=D1=81, 21 =D0=BE=D0=BA=D1=82. 2018 =D0=B3. =D0=B2 11:07, James Botto=
mley
<James.Bottomley@hansenpartnership.com>:
>
> On Sun, 2018-10-21 at 09:05 +0200, Ard Biesheuvel wrote:
> > (+ James)
>
> Thanks!
>
> > On 20 October 2018 at 01:01, Dmitry Eremin-Solenikov
> > <dbaryshkov@gmail.com> wrote:
> > > crypto_cfb_decrypt_segment() incorrectly XOR'ed generated keystream
> > > with
> > > IV, rather than with data stream, resulting in incorrect
> > > decryption.
> > > Test vectors will be added in the next patch.
> > >
> > > Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  crypto/cfb.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/crypto/cfb.c b/crypto/cfb.c
> > > index a0d68c09e1b9..fd4e8500e121 100644
> > > --- a/crypto/cfb.c
> > > +++ b/crypto/cfb.c
> > > @@ -144,7 +144,7 @@ static int crypto_cfb_decrypt_segment(struct
> > > skcipher_walk *walk,
> > >
> > >         do {
> > >                 crypto_cfb_encrypt_one(tfm, iv, dst);
> > > -               crypto_xor(dst, iv, bsize);
> > > +               crypto_xor(dst, src, bsize);
>
> This does look right.  I think the reason the TPM code works is that it
> always does encrypt/decrypt in-place, which is a separate piece of the
> code which appears to be correct.

Since 4.20 pull went into Linus'es tree, any change of getting these two pa=
tches
in crypto tree?

--=20
With best wishes
Dmitry
