From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 0/8] ARM: mvebu: Add support for RAID6 PQ offloading
Date: Wed, 13 May 2015 11:17:33 +0200
Message-ID: <20150513091733.GW10961@lukather>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
 <CAPcyv4gshyaji2HarAeOg3XOiNnmGwnSOMuFGWpuDu8ZTGg=jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yPlaimQd/TpiYx8R"
Cc: Vinod Koul <vinod.koul@intel.com>,
	Gregory Clement <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	"dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, Lior Amsalem <alior@marvell.com>,
	Thomas Petazzoni <thomas@free-electrons.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAPcyv4gshyaji2HarAeOg3XOiNnmGwnSOMuFGWpuDu8ZTGg=jw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--yPlaimQd/TpiYx8R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Tue, May 12, 2015 at 09:05:41AM -0700, Dan Williams wrote:
> On Tue, May 12, 2015 at 8:37 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > Hi,
> >
> > This serie refactors the mv_xor in order to support the latest Armada
> > 38x features, including the PQ support in order to offload the RAID6
> > PQ operations.
> >
> > Not all the PQ operations are supported by the XOR engine, so we had
> > to introduce new async_tx flags in the process to identify
> > un-supported operations.
> >
> > Please note that this is currently not usable because of a possible
> > regression in the RAID stack in 4.1 that is being discussed at the
> > moment here: https://lkml.org/lkml/2015/5/7/527
>=20
> This is problematic as async_tx is a wart on the dmaengine subsystem
> and needs to be deprecated, I just have yet to find the time to do
> that work.  It turns out it was a mistake to hide the device details
> from md, it should be explicitly managing the dma channels, not
> relying on a abstraction api.  The async_tx api usage of the
> dma-mapping api is broken in that it relies on overlapping mappings of
> the same address.  This happens to work on x86, but on arm it needs
> explicit non-overlapping mappings.  I started the work to reference
> count dma-mappings in 3.13, and we need to teach md to use
> dmaengine_unmap_data explicitly.  Yielding dma channel management to
> md also results in a more efficient implementation as we can dma_map()
> the stripe cache once rather than per-io.  The  "async_tx_ack()"
> disaster can also go away when md is explicitly handling channel
> switching.

Even though I'd be very much in favor of deprecating / removing
async_tx, is it something likely to happen soon?

I remember discussing this with Vinod at Plumbers back in October, but
haven't seen anything since then.

If not, I think that we shouldn't really hold back patches to
async_tx, even though we know than in a year from now, it's going to
be gone.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--yPlaimQd/TpiYx8R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVUxatAAoJEBx+YmzsjxAg9ukQALGls0TRdlNouugFNfVAjJkb
z69xNfbq+nJyg9Z6rq6nTrPQ9tCMR3FC0D0Uo1FkOS+8EnQA1fPqccjqWZ0BO2j+
DltDCC45Q+tafNbstc1s0GXjzzLbZAKs+4C0hdFKjAg7iiGtLobBhZUm+FqZrfnE
lqBglBaGVKyPC7HrdC6nZ4I8fw+cBJ6tGCHsldd9wv74SMsqujrX+TRQ6TA7Y+XX
1FBMft0essPHj4Im1J8ktHOaqTMR8ILBWY/AAmkvJyd/oZMHpvylbv2ai6sC82sY
zVx9evDokfm//EG5E6GXXS8cZRivouvaIxA0BR50l8DqYibosPKaFX91ybFCvjH5
7YU5uQOiI5Ir/XvB/0vpKWOdszp2SoFNRmzN2i61RJG89OWRcI8HrDasq99rCysc
ziu15taxQhh/uSLMdQG/1QT14ZFYH4Mb+qxE1Sf60QBmPNvs7ljlaOrREkS0zo8H
fJujx7FlWMMdQiFtm8cL0QAdEG/YX57HF9rvHFkbRoQ3vRTdu6wxsVNf9aF8s1He
2G5xICgyj2U6kmoGBTjowYY1WJI2t8Xfl3e5A6bd6ViYh94Z7tUIvZ2/dYiSBhp8
itSRZgKi2nD+gVqX742kg0uU2FsBkUAOxDVA1TKbxOMwxY06wFp46pD2g0ArxWBZ
8k1ZnuG4Hf3CP/ml0NiL
=8uoD
-----END PGP SIGNATURE-----

--yPlaimQd/TpiYx8R--
