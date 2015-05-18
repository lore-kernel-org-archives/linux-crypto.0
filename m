From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 0/8] ARM: mvebu: Add support for RAID6 PQ offloading
Date: Mon, 18 May 2015 11:14:54 +0200
Message-ID: <20150518091454.GP4004@lukather>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
 <CAPcyv4gshyaji2HarAeOg3XOiNnmGwnSOMuFGWpuDu8ZTGg=jw@mail.gmail.com>
 <20150513091733.GW10961@lukather>
 <CAPcyv4jv=xWHbrO=rKhnWt9zFn8vkhS2J5mJiCBKKwESdUk5tg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tbUdrdPJASQ8VKrP"
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
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:46345 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752275AbbERJPE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 May 2015 05:15:04 -0400
Content-Disposition: inline
In-Reply-To: <CAPcyv4jv=xWHbrO=rKhnWt9zFn8vkhS2J5mJiCBKKwESdUk5tg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--tbUdrdPJASQ8VKrP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Wed, May 13, 2015 at 09:00:46AM -0700, Dan Williams wrote:
> On Wed, May 13, 2015 at 2:17 AM, Maxime Ripard
> <maxime.ripard@free-electrons.com> wrote:
> > Hi Dan,
> >
> > On Tue, May 12, 2015 at 09:05:41AM -0700, Dan Williams wrote:
> >> On Tue, May 12, 2015 at 8:37 AM, Maxime Ripard
> >> <maxime.ripard@free-electrons.com> wrote:
> >> > Hi,
> >> >
> >> > This serie refactors the mv_xor in order to support the latest Armada
> >> > 38x features, including the PQ support in order to offload the RAID6
> >> > PQ operations.
> >> >
> >> > Not all the PQ operations are supported by the XOR engine, so we had
> >> > to introduce new async_tx flags in the process to identify
> >> > un-supported operations.
> >> >
> >> > Please note that this is currently not usable because of a possible
> >> > regression in the RAID stack in 4.1 that is being discussed at the
> >> > moment here: https://lkml.org/lkml/2015/5/7/527
> >>
> >> This is problematic as async_tx is a wart on the dmaengine subsystem
> >> and needs to be deprecated, I just have yet to find the time to do
> >> that work.  It turns out it was a mistake to hide the device details
> >> from md, it should be explicitly managing the dma channels, not
> >> relying on a abstraction api.  The async_tx api usage of the
> >> dma-mapping api is broken in that it relies on overlapping mappings of
> >> the same address.  This happens to work on x86, but on arm it needs
> >> explicit non-overlapping mappings.  I started the work to reference
> >> count dma-mappings in 3.13, and we need to teach md to use
> >> dmaengine_unmap_data explicitly.  Yielding dma channel management to
> >> md also results in a more efficient implementation as we can dma_map()
> >> the stripe cache once rather than per-io.  The  "async_tx_ack()"
> >> disaster can also go away when md is explicitly handling channel
> >> switching.
> >
> > Even though I'd be very much in favor of deprecating / removing
> > async_tx, is it something likely to happen soon?
>=20
> Not unless someone else takes it on, I'm actively asking for help.
>=20
> > I remember discussing this with Vinod at Plumbers back in October, but
> > haven't seen anything since then.
>=20
> Right, "help!" :)
>=20
> > If not, I think that we shouldn't really hold back patches to
> > async_tx, even though we know than in a year from now, it's going to
> > be gone.
>=20
> We definitely should block new usages, because they make a bad
> situation worse.  Russell already warned that the dma_mapping api
> abuse could lead to data corruption on ARM (speculative pre-fetching).
> We need to mark ASYNC_TX_DMA as "depends on !ARM" or even "depends on
> BROKEN" until we can get this resolved.

I'm not sure what the issues exactly are with async_tx and ARM, but
these patches have been tested on ARM and are working quite well.

What I'm doing here is merely using the existing API, I'm not making
it worse, just using the API that is used by numerous drivers
already. So I'm not sure this is really reasonable to ask for such a
huge rework (with a huge potential of regressions) before merging my
patches.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--tbUdrdPJASQ8VKrP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVWa2OAAoJEBx+YmzsjxAgaZkP/jRIySV7WSAt2sIkFkm2Rkgt
Yp6CZV9CnKPwOWcUnvfBhsnRPvJvyny4mPC4pEWnIcAPTotr8ibnjT+9ay/woEye
PRA+m+eyy9Stl2uXUOSWupn5KYC64LXylpKoNrmMQn7BjUgXDal2d4d2SapeEu5D
Pub7JNRbEhsQz2nBA8lh/IHV2G9zBssrYqxPBP8jmmxZkUqYVYQu/MLTup0w5ypv
roY155FLxUObf4drO6ukXnbIN9ioYVv2AqnWhquKr98aGWhbcg9ybaXkvnIrno2c
FhvH0kdAyvsnGeFQ7Y1Afhq/xMaowRVeMselEGFjYXdSol0w3HuDdr12s2HxA+RT
xrfEcJx8VKK3GHgSECAKOlE8TjDz1pNBZsp1Kqvofm3tYDMPMbcb43HSACOBHbBZ
yafa6SHp8CGzsskxk6ao7EVtTs5rWOkKAkSHfYNSBoA4L0DlAOzNDmXa4yIOJPrz
zRJYLdEdr+TEjQzN2Ao5k9tVzrxomRYtT5hhqP4tO/2dsMiS53S1Acs1VzYTJ0bF
xPE2GogBldYwwyOWKEs7Pb+MkIo9cJDecpoHgJ2rW2SIZP2oxzK6WvLh2DnEh9Fs
Py1ajr4wyEOaXR0IaIshlzoWzmk3e0U5pWeuZwJHzisjdNWcZUkoLe8mYNX8laVy
8eveiN9/RMusLVSJDKBO
=4oRU
-----END PGP SIGNATURE-----

--tbUdrdPJASQ8VKrP--
