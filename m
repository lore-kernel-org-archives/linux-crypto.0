From: Michael Turquette <mturquette@baylibre.com>
Subject: Re: [PATCH v3 1/3] clk: meson-gxbb: expose clock CLKID_RNG0
Date: Wed, 22 Mar 2017 18:43:50 -0700
Message-ID: <149023343045.54062.16811894906233729582@resonance>
References: <4e2d12e5-f75b-3ac6-a3f7-18e8a8b7283b@gmail.com>
 <20170316100743.GA12137@gondor.apana.org.au> <m2mvcl6pwg.fsf@baylibre.com>
 <20170317083032.GA18512@gondor.apana.org.au> <m2lgrxnxlz.fsf@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Cc: "Heiner Kallweit" <hkallweit1@gmail.com>,
        "Jerome Brunet" <jbrunet@baylibre.com>,
        "Neil Armstrong" <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, linux-crypto@vger.kernel.org,
        "Stephen Boyd" <sboyd@codeaurora.org>, linux-clk@vger.kernel.org,
        devicetree@vger.kernel.org
To: Kevin Hilman <khilman@baylibre.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:35783 "EHLO
        mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752467AbdCWBny (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Mar 2017 21:43:54 -0400
Received: by mail-pf0-f179.google.com with SMTP id 20so50524018pfk.2
        for <linux-crypto@vger.kernel.org>; Wed, 22 Mar 2017 18:43:53 -0700 (PDT)
In-Reply-To: <m2lgrxnxlz.fsf@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Quoting Kevin Hilman (2017-03-22 08:24:08)
> Herbert Xu <herbert@gondor.apana.org.au> writes:
> =

> > On Thu, Mar 16, 2017 at 11:24:31AM -0700, Kevin Hilman wrote:
> >> Hi Herbert,
> >> =

> >> Herbert Xu <herbert@gondor.apana.org.au> writes:
> >> =

> >> > On Wed, Feb 22, 2017 at 07:55:24AM +0100, Heiner Kallweit wrote:
> >> >> Expose clock CLKID_RNG0 which is needed for the HW random number ge=
nerator.
> >> >> =

> >> >> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> >> >
> >> > All patches applied.  Thanks.
> >> =

> >> Actually, can you just apply [PATCH 4/4] to your tree?
> >> =

> >> The clock and DT patches need to go through their respective trees or
> >> will otherwise have conflicts with other things going in via those
> >> trees.
> >
> > It's too late now.  Please speak up sooner next time.  These
> > patches were posted a month ago.
> =

> Because this will be causing conflicts with both the platform (amlogic)
> tree and the clk tree, could provide an immutable branch where these are
> applied to help us handle these conflicts?

+1

The DT header changes will cause conflicts in the clk tree. Much better
to either arrange for the patches to be applied by the correct
maintainers or to provide a stable, immutable branch.

Best regards,
Mike

> =

> Thanks,
> =

> Kevin
