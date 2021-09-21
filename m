Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 798ABC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 22:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5E52760EB4
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Sep 2021 22:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231367AbhIUWi4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Sep 2021 18:38:56 -0400
Received: from 82-65-109-163.subs.proxad.net ([82.65.109.163]:34680 "EHLO
        luna.linkmauve.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhIUWiz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Sep 2021 18:38:55 -0400
Received: by luna.linkmauve.fr (Postfix, from userid 1000)
        id 3274DF40B6D; Wed, 22 Sep 2021 00:37:25 +0200 (CEST)
Date:   Wed, 22 Sep 2021 00:37:24 +0200
From:   Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Emmanuel Gil Peyrot <linkmauve@linkmauve.fr>,
        linux-crypto@vger.kernel.org, Ash Logan <ash@heyquark.com>,
        Jonathan =?utf-8?Q?Neusch=C3=A4fer?= <j.ne@posteo.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 0/4] crypto: nintendo-aes - add a new AES driver
Message-ID: <20210921223724.ocxpdef6ptquprgz@luna>
Jabber-ID: linkmauve@linkmauve.fr
References: <20210921213930.10366-1-linkmauve@linkmauve.fr>
 <YUpVyTN7MQbMShdf@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jii3ybjni5untti4"
Content-Disposition: inline
In-Reply-To: <YUpVyTN7MQbMShdf@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org


--jii3ybjni5untti4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 21, 2021 at 02:59:37PM -0700, Eric Biggers wrote:
> On Tue, Sep 21, 2021 at 11:39:26PM +0200, Emmanuel Gil Peyrot wrote:
> > This engine implements AES in CBC mode, using 128-bit keys only.  It is
> > present on both the Wii and the Wii=C2=A0U, and is apparently identical=
 in
> > both consoles.
> >=20
> > The hardware is capable of firing an interrupt when the operation is
> > done, but this driver currently uses a busy loop, I=E2=80=99m not too s=
ure
> > whether it would be preferable to switch, nor how to achieve that.
> >=20
> > It also supports a mode where no operation is done, and thus could be
> > used as a DMA copy engine, but I don=E2=80=99t know how to expose that =
to the
> > kernel or whether it would even be useful.
> >=20
> > In my testing, on a Wii=C2=A0U, this driver reaches 80.7 MiB/s, while t=
he
> > aes-generic driver only reaches 30.9 MiB/s, so it is a quite welcome
> > speedup.
> >=20
> > This driver was written based on reversed documentation, see:
> > https://wiibrew.org/wiki/Hardware/AES
> >=20
> > Emmanuel Gil Peyrot (4):
> >   crypto: nintendo-aes - add a new AES driver
> >   dt-bindings: nintendo-aes: Document the Wii and Wii U AES support
> >   powerpc: wii.dts: Expose the AES engine on this platform
> >   powerpc: wii_defconfig: Enable AES by default
>=20
> Does this pass the self-tests, including the fuzz tests which are enabled=
 by
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=3Dy?

I wasn=E2=80=99t aware of those, and indeed it doesn=E2=80=99t pass them ye=
t:
[    0.680164] alg: skcipher: cbc-aes-nintendo encryption overran dst buffe=
r on test vector 0, cfg=3D"out-of-place"
[    0.680201] fbcon: Taking over console
[    0.680219] ------------[ cut here ]------------
[    0.680222] alg: self-tests for cbc-aes-nintendo (cbc(aes)) failed (rc=
=3D-75)

I=E2=80=99ll try to figure out how to debug this and I=E2=80=99ll send a v2=
, thanks for
the hint!

>=20
> - Eric

--=20
Emmanuel Gil Peyrot

--jii3ybjni5untti4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEjrVT1SzTln43kCLJOWgfYkb2LpAFAmFKXqIACgkQOWgfYkb2
LpCJcgf+IMfEy9fNYpEki4K7BmX/f4kKVOek3gLVkG3rrgZOTElYH5C9uOsdxHZ9
27PsYcESnj9tI3G9t9RLmyPmxuMVPCVKTc0KaFbacwx1UMmQMBFa5s0WZMVHgZC9
L7/JnU4G1rRPIxXaaYKnqBBYNzO2LuwVBd7V/0m9WBToXEWEtxabaGO6QuiKFAYX
rv6T3ajdk40w8XQo3I031M3OxSq9prJBNCtkdkPPmqB4ZtP/E8uGM6ukTMYgR/ZU
NA3w3V8BX95KNPt/uDKbZ3vdbsSH1PcFVgfPs7aqBKU+zddkdwcoEKfoyg8c4wUi
cU30fGOI9fLKgdx83YZrWeu8x9Ty7w==
=IlCT
-----END PGP SIGNATURE-----

--jii3ybjni5untti4--
