Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 691B7C432C3
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 19:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 441AF2071F
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 19:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbfKTTuT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 14:50:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:33916 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727374AbfKTTuT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 14:50:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 29ACDB14A;
        Wed, 20 Nov 2019 19:50:16 +0000 (UTC)
Message-ID: <6aaa37d2cbe91c177b7be2d7f8aa3846efe3dc34.camel@suse.de>
Subject: Re: [PATCH v3 0/4] Raspberry Pi 4 HWRNG Support
From:   Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
To:     Stefan Wahren <wahrenst@gmx.net>,
        Stephen Brennan <stephen@brennan.io>
Cc:     Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Branden <sbranden@broadcom.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        Eric Anholt <eric@anholt.net>,
        Rob Herring <robh+dt@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-rpi-kernel@lists.infradead.org, Ray Jui <rjui@broadcom.com>,
        linux-arm-kernel@lists.infradead.org
Date:   Wed, 20 Nov 2019 20:50:14 +0100
In-Reply-To: <99554159-6abb-6ea5-aebb-57a148a59b78@gmx.net>
References: <20191120031622.88949-1-stephen@brennan.io>
         <99554159-6abb-6ea5-aebb-57a148a59b78@gmx.net>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-iQqSDeLkAUWuKqj/9yXJ"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--=-iQqSDeLkAUWuKqj/9yXJ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2019-11-20 at 17:16 +0100, Stefan Wahren wrote:
> Hi Stephen,
>=20
> Am 20.11.19 um 04:16 schrieb Stephen Brennan:
> > This patch series enables support for the HWRNG included on the Raspber=
ry
> > Pi 4.  It is simply a rebase of Stefan's branch [1]. I went ahead and
> > tested this out on a Pi 4.  Prior to this patch series, attempting to u=
se
> > the hwrng gives:
> >=20
> >     $ head -c 2 /dev/hwrng
> >     head: /dev/hwrng: Input/output error
> >=20
> > After this series, the same command gives two random bytes.
>=20
> just a note: a more expressive test would be running rngtest (package
> rng-tools) on this device.

Just had a go at it,

root@rpi4:~# rngtest -c 1000 < /dev/hwrng
rngtest 2-unofficial-mt.14
Copyright (c) 2004 by Henrique de Moraes Holschuh
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 998
rngtest: FIPS 140-2 failures: 2
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 1
rngtest: FIPS 140-2(2001-10-10) Runs: 0
rngtest: FIPS 140-2(2001-10-10) Long run: 1
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=3D1.284; avg=3D113.786; max=3D126.213)Ki=
bits/s
rngtest: FIPS tests speed: (min=3D17.122; avg=3D28.268; max=3D28.812)Mibits=
/s
rngtest: Program run time: 172323761 microseconds

AFAIR (Arch wiki) some small failures are acceptable.

Regards,
Nicolas


--=-iQqSDeLkAUWuKqj/9yXJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEErOkkGDHCg2EbPcGjlfZmHno8x/4FAl3VmPYACgkQlfZmHno8
x/747ggAscLDM0fF7tOoTWdcO+lp+zKBM4o38uVkOwes/laW6msQMiAvB0qW7j4V
8FRmDLDFt34e1Ta9NKZW3GloAUkVkrS/iPX9msSCy7qlodRjRYdkgF5rbSH4YSIK
K/9p8MXknOsXsJ9kQCiexooNiiKspt2XLl1lwtLuhHVdtNEVVw1phdlPhfU37BAW
tV1n45JjdagGkNS8JrjvXNPbCRkSk8SStb/IjldltTO1Rvp//I5Whj0CWXnNzM0t
HDhXrZiO7+5NB30WU9gP+o3NU8b0KiyAdoe5RgRzTCqlnZsK2rdhJ4eDQKzVpvWR
/Ra8OIJmgCp4aezFVms92D0KO2dB6w==
=VuSq
-----END PGP SIGNATURE-----

--=-iQqSDeLkAUWuKqj/9yXJ--

