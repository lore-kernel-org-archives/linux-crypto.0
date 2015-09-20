From: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH v2 0/7] hwrng: Add support for STMicroelectronics' RNG IP
Date: Sun, 20 Sep 2015 05:39:02 +0100
Message-ID: <20150920043902.GA3039@x1>
References: <1442497557-9271-1-git-send-email-lee.jones@linaro.org>
 <20150918140756.GK9249@gondor.apana.org.au>
 <CAF2Aj3h7Jy=tpYdZTdbxAJwa=147_hAu3reOFrbEh=JdrMFWLQ@mail.gmail.com>
 <20150918151137.GA10763@gondor.apana.org.au>
 <20150918155112.GE3218@x1>
 <20150918231213.GA14278@gondor.apana.org.au>
 <20150919092145.GG3218@x1>
 <20150920012347.GA21913@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	Peter Korsgaard <peter@korsgaard.com>,
	Fabio Estevam <festevam@gmail.com>,
	Kieran Bingham <kieranbingham@gmail.com>,
	"kernel@stlinux.com" <kernel@stlinux.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33828 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbbITEjL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Sep 2015 00:39:11 -0400
Received: by padhy16 with SMTP id hy16so85811400pad.1
        for <linux-crypto@vger.kernel.org>; Sat, 19 Sep 2015 21:39:10 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150920012347.GA21913@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 20 Sep 2015, Herbert Xu wrote:

> On Sat, Sep 19, 2015 at 10:21:45AM +0100, Lee Jones wrote:
> >
> > That's not how it works.  It's helpful, more often than not, to sub=
mit
> > the entire set to each maintainer concerned so they can keep up wit=
h
> > the general conversation.  By only sending specific patches to
> > maintainers you essentially blinker them to the bigger picture.
> >=20
> > As a maintainer you should _know_ that you can't apply patches from
> > other subsystems without appropriate Acks.  I'm sure you'd take
> > exception to another maintainer who started accepting patches for
> > subsystems you are responsible for.  This works both ways.
>=20
> No you are mistaken.  You should only put patches which have
> dependencies on each other in a series.  If the patches can be
> applied independently of each other there is no need to have
> them in a single series.

That's just not true.  I've explained why it's important for everyone
involved to see the bigger picture.  Let me use this set in an
example.  The patches can (and should) be applied separately, but they
are heavily entwined.  Let's say I only sent the ARM patch to Maxime
(the STi Maintainer) and only sent you the driver and the binding
document.  There's a chance Maxime could apply the DTS changes prior
to a proper review of the bindings.  Granted, one way round this would
be to place the DTS changes into a holding-pen until the binding has
been accepted, but this method is highly impractical and puts
unnecessary burden on the contributor.

There are 1000's of examples where all parties need to see reviews on
other, related but not dependant, parts of a set.  For many of the
sets I review it's critical for me what else is going on in related
diffs.  I guess for the subsystems you maintain it's less of an issue,
but still, it _is_ how people tend to submit code and there is no good
reason for you to dictate otherwise.

> Obviously if they can go into different trees then they cannot
> have dependencies.
>=20
> Cheers,

--=20
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
=46ollow Linaro: Facebook | Twitter | Blog
