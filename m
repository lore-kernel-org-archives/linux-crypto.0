From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/3] crypto: exynos - Support Exynos5250+ SoCs
Date: Wed, 06 Dec 2017 09:56:11 -0800
Message-ID: <1512582971.960.6.camel@perches.com>
References: <CGME20171206134305eucas1p218c38b977c14cae58763586458c3e78d@eucas1p2.samsung.com>
         <CAJKOXPf9JpBkR_z4frT-knxSUv53K=94wHoJkqD2fzVz2K6mGA@mail.gmail.com>
         <87bmjc9dlr.fsf%l.stelmach@samsung.com>
         <CAJKOXPfep5BeJMz=qHqF4m05c2=5DgnFjPeA21n2EMJnyXvoQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: robh+dt@kernel.org, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kukjin Kim <kgene@kernel.org>, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        =?UTF-8?Q?Bart=C5=82omiej_?= =?UTF-8?Q?=C5=BBo=C5=82nierkiewicz?=
        <b.zolnierkie@samsung.com>
To: Krzysztof Kozlowski <krzk@kernel.org>,
        =?UTF-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0200.hostedemail.com ([216.40.44.200]:34735 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752079AbdLFR4P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Dec 2017 12:56:15 -0500
In-Reply-To: <CAJKOXPfep5BeJMz=qHqF4m05c2=5DgnFjPeA21n2EMJnyXvoQA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2017-12-06 at 15:05 +0100, Krzysztof Kozlowski wrote:
> On Wed, Dec 6, 2017 at 2:42 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> > It was <2017-12-05 wto 14:34>, when Krzysztof Kozlowski wrote:
> > > On Tue, Dec 5, 2017 at 1:35 PM, Łukasz Stelmach <l.stelmach@samsung.com> wrote:
> > > > Add support for PRNG in Exynos5250+ SoCs.
[]
> > > > diff --git a/drivers/crypto/exynos-rng.c b/drivers/crypto/exynos-rng.c
[]
> > > > @@ -300,7 +323,10 @@ static int exynos_rng_probe(struct platform_device *pdev)
> > > >                 dev_err(&pdev->dev,
> > > >                         "Couldn't register rng crypto alg: %d\n", ret);
> > > >                 exynos_rng_dev = NULL;
> > > > -       }
> > > > +       } else
> > > 
> > > Missing {} around else clause. Probably checkpatch should point it.
> > 
> > It doesn't. Fixed.

checkpatch does report this if using --strict

$ ./scripts/checkpatch.pl --strict -
CHECK: Unbalanced braces around else statement
#119: FILE: drivers/crypto/exynos-rng.c:326:
+	} else

Arguably, this should always be reported.
