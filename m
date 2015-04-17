From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 0/2] crypto: add new driver for Marvell CESA
Date: Fri, 17 Apr 2015 16:50:22 +0200
Message-ID: <20150417145022.GR15807@lukather>
References: <552B8EC4.209@free-electrons.com>
 <20150413124711.GI18660@io.lakedaemon.net>
 <87r3rom2qu.fsf@natisbad.org>
 <20150413201146.GL18660@io.lakedaemon.net>
 <20150417103356.6ce78145@bbrezillon>
 <20150417103946.2a46c243@bbrezillon>
 <5531040D.4000007@free-electrons.com>
 <20150417161922.54adec64@bbrezillon>
 <20150417143216.GQ15807@lukather>
 <55311B6B.2090108@free-electrons.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TYoqghpzCwoKvQG2"
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
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
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55311B6B.2090108@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--TYoqghpzCwoKvQG2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2015 at 04:40:43PM +0200, Gregory CLEMENT wrote:
> Hi Maxime,
>=20
> On 17/04/2015 16:32, Maxime Ripard wrote:
> > On Fri, Apr 17, 2015 at 04:19:22PM +0200, Boris Brezillon wrote:
> >> Hi Gregory,
> >>
> >> On Fri, 17 Apr 2015 15:01:01 +0200
> >> Gregory CLEMENT <gregory.clement@free-electrons.com> wrote:
> >>
> >>> Hi Boris,
> >>>
> >>> On 17/04/2015 10:39, Boris Brezillon wrote:
> >>>> On Fri, 17 Apr 2015 10:33:56 +0200
> >>>> Boris Brezillon <boris.brezillon@free-electrons.com> wrote:
> >>>>
> >>>>> Hi Jason,
> >>>>>
> >>>>> On Mon, 13 Apr 2015 20:11:46 +0000
> >>>>> Jason Cooper <jason@lakedaemon.net> wrote:
> >>>>>
> >>>>>>>
> >>>>>>>> I'd appreciate if we'd look into it.  I understand from on-list =
and
> >>>>>>>> off-list discussion that the rewrite was unavoidable.  So I'm wi=
lling to
> >>>>>>>> concede that.  Giving people time to migrate from old to new whi=
le still
> >>>>>>>> being able to update for other security fixes seems reasonable.
> >>>>>>>
> >>>>>>> Jason, what do you think of the approach above?=20
> >>>>>>
> >>>>>> I say keep it simple.  We shouldn't use the DT changes to trigger =
one
> >>>>>> vice the other.  We need to be able to build both, but only load o=
ne at
> >>>>>> a time.  If that's anything other than simple to do, then we make =
it a
> >>>>>> Kconfig binary choice and move on.
> >>>>>
> >>>>> Actually I was planning to handle it with a Kconfig dependency rule
> >>>>> (NEW_DRIVER depends on !OLD_DRIVER and OLD_DRIVER depends
> >>>>> on !NEW_DRIVER).
> >>>>> I don't know how to make it a runtime check without adding new
> >>>>> compatible strings for the kirkwood, dove and orion platforms, and =
I'm
> >>>>> sure sure this is a good idea.
> >>>>   ^ not
> >>>>
> >>>>> Do you have any ideas ?
> >>>
> >>> You use devm_ioremap_resource() in the new driver, so if the old one
> >>> is already loaded the memory region will be already hold and the new
> >>> driver will simply fail during the probe. So for this part it is OK.
> >>
> >> I like the idea :-).
> >=20
> > Not really, how do you know which device is going to be probed? For
> > that matter, it's pretty much random, and you have no control over it.
> >=20
> > Why not just have a choice option, and select which one you want to
> > enable?
>=20
> Because you can't prevent an user to build a module, then modifying the
> configuration and building the other module.

Well, actually, you don't even know if it's going to be a module. You
might very well have both drivers compiled statically in the kernel
image, and this is where the trouble begins.

> So even if there is a choice at build time, and I think that it is
> something expected for the v2, we still need preventing having the
> both drivers trying accessing the same hardware in the same time.

Of course, but this is already there, and doesn't really address the
same issue.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--TYoqghpzCwoKvQG2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVMR2uAAoJEBx+YmzsjxAgVmEP/jpNrk9S8vdZaaV8SUqCEgyN
YG0fquE3nWUqZ27xr8+01JNd9aDKQo3N5jindUkw3T16zQGj7hZpn+jKsM/yZ8z/
f7xxjOan0TeTLA+nzFdjkSpYGeGHP/IRh75xDtwLDoz5xfsi8/Qvcs0E+YSXX5pk
tjV8RQGLQWdFsLoDLMIgD8tFj9pc9E4U+rprgQWfpRaVjpK6wvOIzb83q9PGi081
z3SwPBoy9V2O6Go4je8dhQhy1iJj/5qWLjGGPNEY7LYPqrxiA9VZxAUXyhBuF4kD
6jT/UhNBnHFEALnU3srZto4UmJuLb6na+Fg/EBt7uBGrPH3cSMWYcvhMct2fmb1K
Nvb30In8+BvCH/WX5nzXY17cvHDJvrpM1rMBnC2xxoZFS9fOpozp1TbkbMG+ud3h
ENGPQAXMibVMM2dnIbwDFBYTDH4M/mcvmghdDI3u6zJ7YSLEBPE1Onx0X/XFcWiX
uUk9x37mpZSBbO6XSh/sdWC141/0B9Qb7Q0kidQSkmIkWKk3HzoPJP27AfnQegsM
5hpxdKxhuM2GePscBn+Hykktc6+9o5Pmzn4wvTn6GCAJDWYywjbBzefdMLg8uM6P
Bz0NuK/oW21CcSnP0OdVbPdykS9ASyYj27Bi6uaZ4ImAUhjsAtJ3nb32R4YkvIda
tXPfi+eP4vLK85AI5nq5
=tnHK
-----END PGP SIGNATURE-----

--TYoqghpzCwoKvQG2--
