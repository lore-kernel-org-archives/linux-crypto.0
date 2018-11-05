Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-ua1-f66.google.com ([209.85.222.66]:46234 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbeKESg4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 13:36:56 -0500
Received: by mail-ua1-f66.google.com with SMTP id v24so2894044uap.13
        for <linux-crypto@vger.kernel.org>; Mon, 05 Nov 2018 01:18:12 -0800 (PST)
MIME-Version: 1.0
References: <1541325924-14777-1-git-send-email-gilad@benyossef.com> <2578248.XAorIH2ink@tauon.chronox.de>
In-Reply-To: <2578248.XAorIH2ink@tauon.chronox.de>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Mon, 5 Nov 2018 11:18:00 +0200
Message-ID: <CAOtvUMeRth4zrTZbEy6Co=+CR4==5oSDbaf760Yh4fj8UAf8bQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: mark cts(cbc(aes)) as FIPS allowed
To: =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Yael Chemla <Yael.Chemla@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Stephan,

On Mon, Nov 5, 2018 at 10:50 AM Stephan Mueller <smueller@chronox.de> wrote=
:
>
> Am Sonntag, 4. November 2018, 11:05:24 CET schrieb Gilad Ben-Yossef:
>
> Hi Gilad,
>
> > As per Sp800-38A addendum from Oct 2010[1], cts(cbc(aes)) is
> > allowed as a FIPS mode algorithm. Mark it as such.
> >
> > [1] https://csrc.nist.gov/publications/detail/sp/800-38a/addendum/final
>
> There are several types of CTS approaches. Only three of those are listed=
 in
> the SP800-38A addendum. The source code only refers to some RFCs.
>
> Did you check whether the CTS implementation matches one or more of the t=
ypes
> listed in the addendum? If yes, may I suggest to add a small statement in=
 the
> code noting this fact?

Yes, AFAIK the software implements CBC-CS3 as described in the document.
You have a very good point about this not document anywhere. I will
send a patch.

While we're at it, does someone find it useful if I implemented the
other two modes?
They are part of the standard as well, although I am not sure that in
itself is sufficient cause.


Gilad

--
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
