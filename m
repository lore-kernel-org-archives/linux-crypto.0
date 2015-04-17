From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 0/2] crypto: add new driver for Marvell CESA
Date: Fri, 17 Apr 2015 16:32:16 +0200
Message-ID: <20150417143216.GQ15807@lukather>
References: <20150410171148.07bc9429@bbrezillon>
 <20150410223008.GA18660@io.lakedaemon.net>
 <552B8EC4.209@free-electrons.com>
 <20150413124711.GI18660@io.lakedaemon.net>
 <87r3rom2qu.fsf@natisbad.org>
 <20150413201146.GL18660@io.lakedaemon.net>
 <20150417103356.6ce78145@bbrezillon>
 <20150417103946.2a46c243@bbrezillon>
 <5531040D.4000007@free-electrons.com>
 <20150417161922.54adec64@bbrezillon>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rE45P3aZNSuYx5ND"
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Arnaud Ebalard <arno@natisbad.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Petazzoni <info@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Pawel Moll <pawel.moll@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Eran Ben-Avi <benavi@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>, devicetree@vger.kernel.org,
	Rob Herring <robh+dt@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	linux-crypto@vger.kernel.org, Kumar Gala <galak@codeaurora.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Lior Amsalem <alior@marvell.com>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150417161922.54adec64@bbrezillon>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--rE45P3aZNSuYx5ND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2015 at 04:19:22PM +0200, Boris Brezillon wrote:
> Hi Gregory,
>=20
> On Fri, 17 Apr 2015 15:01:01 +0200
> Gregory CLEMENT <gregory.clement@free-electrons.com> wrote:
>=20
> > Hi Boris,
> >=20
> > On 17/04/2015 10:39, Boris Brezillon wrote:
> > > On Fri, 17 Apr 2015 10:33:56 +0200
> > > Boris Brezillon <boris.brezillon@free-electrons.com> wrote:
> > >=20
> > >> Hi Jason,
> > >>
> > >> On Mon, 13 Apr 2015 20:11:46 +0000
> > >> Jason Cooper <jason@lakedaemon.net> wrote:
> > >>
> > >>>>
> > >>>>> I'd appreciate if we'd look into it.  I understand from on-list a=
nd
> > >>>>> off-list discussion that the rewrite was unavoidable.  So I'm wil=
ling to
> > >>>>> concede that.  Giving people time to migrate from old to new whil=
e still
> > >>>>> being able to update for other security fixes seems reasonable.
> > >>>>
> > >>>> Jason, what do you think of the approach above?=20
> > >>>
> > >>> I say keep it simple.  We shouldn't use the DT changes to trigger o=
ne
> > >>> vice the other.  We need to be able to build both, but only load on=
e at
> > >>> a time.  If that's anything other than simple to do, then we make i=
t a
> > >>> Kconfig binary choice and move on.
> > >>
> > >> Actually I was planning to handle it with a Kconfig dependency rule
> > >> (NEW_DRIVER depends on !OLD_DRIVER and OLD_DRIVER depends
> > >> on !NEW_DRIVER).
> > >> I don't know how to make it a runtime check without adding new
> > >> compatible strings for the kirkwood, dove and orion platforms, and I=
'm
> > >> sure sure this is a good idea.
> > >   ^ not
> > >=20
> > >> Do you have any ideas ?
> >=20
> > You use devm_ioremap_resource() in the new driver, so if the old one
> > is already loaded the memory region will be already hold and the new
> > driver will simply fail during the probe. So for this part it is OK.
>=20
> I like the idea :-).

Not really, how do you know which device is going to be probed? For
that matter, it's pretty much random, and you have no control over it.

Why not just have a choice option, and select which one you want to
enable?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--rE45P3aZNSuYx5ND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVMRlwAAoJEBx+YmzsjxAg7EQP/1FqMkeMowR6Qa1lgbx6KinK
o5ZyhARK3e12RVdboVYUWfwjr3C0EFz96/PyBIecBNwZn9AwXaFfbl+9pUKKk+Ef
5AvbQP1VFtnE4gndyXISp0qmJYWyJPCkA23vDJoGUDj2sRa5404t01ZqFIH0YenA
sbwIY2YtejQjtWtDZYTiq4g+lAdvZVDv/JiaS5uOWpEMXSUEQR53luJSSDHqRqHX
drCFnZ3yfvtdptjd+OZgo52x9SBkvu0qWzna79P5O/7ury3NmwMPY/yFX7h8LS6A
UZZ25nIl3Cg2NXb42kBsfVXvfM12VrvmfOArTlNvzno+XR2irDSO7mhd/99JKjcl
OiC2H6QuZb33H2l8MQlLNaTGAdoCYTrPhNhxBAzKfBZ9xnjH0nnDnlPHMnZV8wj1
rFO0j0DZd9jugiiFOdKbvP48mHxdD8eMMTIIwGhMaQ0wa5tUKR+jUwdxoAGSp62O
Y6ua4hHxgiB1yOSfuBlJ7TVrEhq4CNvOogFRN3SLYgIxClcY2BgK3+fgLMiZndA1
8n94A2R5VnQAjmeIFRMYOPHhQ6TCGqJ/CPaR5eJy3X9tURCLpvR52/Lbuk7AA13E
LxVr+wtfUlhJMeO8K6HXsWLq3MhhRFPDK+yr9B4Zrd6B/8gIPoHOwhpQc7jj0yBP
Nf9eqAdhnb3wcpahIlMr
=bLvx
-----END PGP SIGNATURE-----

--rE45P3aZNSuYx5ND--
