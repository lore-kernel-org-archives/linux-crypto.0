Return-Path: <SRS0=g7fO=NJ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-ua1-f65.google.com ([209.85.222.65]:46366 "EHLO
        mail-ua1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729509AbeJ2Shi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Oct 2018 14:37:38 -0400
Received: by mail-ua1-f65.google.com with SMTP id z8so2735248uap.13
        for <linux-crypto@vger.kernel.org>; Mon, 29 Oct 2018 02:49:42 -0700 (PDT)
MIME-Version: 1.0
References: <1539696935-4433-1-git-send-email-gilad@benyossef.com>
 <1539696935-4433-3-git-send-email-gilad@benyossef.com> <20181025001221.GA12740@bogus>
In-Reply-To: <20181025001221.GA12740@bogus>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Mon, 29 Oct 2018 11:49:31 +0200
Message-ID: <CAOtvUMd9W9HvFuXRH=LAyQYLnvL_hmwv703LzE-aA=2OSsVHMQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] crypto: ccree: add dt bindings for ccree 713
To: robh@kernel.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Yael Chemla <Yael.Chemla@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 25, 2018 at 3:12 AM Rob Herring <robh@kernel.org> wrote:
>
> On Tue, Oct 16, 2018 at 02:35:32PM +0100, Gilad Ben-Yossef wrote:
> > Add device tree bindings associating Arm TrustZone CryptoCell 713 with =
the
> > ccree driver.
>
> "dt-bindings: crypto: ..." for the subject.
> >
> > Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> > ---
> >  Documentation/devicetree/bindings/crypto/arm-cryptocell.txt | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/arm-cryptocell.tx=
t b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> > index 999fb2a..880de07 100644
> > --- a/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> > +++ b/Documentation/devicetree/bindings/crypto/arm-cryptocell.txt
> > @@ -1,8 +1,9 @@
> >  Arm TrustZone CryptoCell cryptographic engine
> >
> >  Required properties:
> > -- compatible: Should be one of: "arm,cryptocell-712-ree",
> > -  "arm,cryptocell-710-ree" or "arm,cryptocell-630p-ree".
> > +- compatible: Should be one of: "arm,cryptocell-713-ree",
> > +  "arm,cryptocell-712-ree", "arm,cryptocell-710-ree" or
> > +  "arm,cryptocell-630p-ree".
>
> Please format 1 per line.
>

Will do.
Thanks for the review.

I will send a corrected patch.

Gilad


--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
