From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH 0/8] ARM: mvebu: Add support for RAID6 PQ offloading
Date: Tue, 2 Jun 2015 16:41:26 +0200
Message-ID: <20150602144126.GZ23777@lukather>
References: <1431445063-20226-1-git-send-email-maxime.ripard@free-electrons.com>
 <CAPcyv4gshyaji2HarAeOg3XOiNnmGwnSOMuFGWpuDu8ZTGg=jw@mail.gmail.com>
 <20150513091733.GW10961@lukather>
 <CAPcyv4jv=xWHbrO=rKhnWt9zFn8vkhS2J5mJiCBKKwESdUk5tg@mail.gmail.com>
 <20150518091454.GP4004@lukather>
 <CAPcyv4jbW=B_mYfx5HfKckLYeWctfC-9jYeDf0Z1APvQZfHj6Q@mail.gmail.com>
 <20150526094511.GP8557@lukather>
 <CAPcyv4i06Mwis_CSrKV1Yo6crD1vrjb9it6RtYdtwbgOOY9a4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sPkBZsy7C+1fV4MN"
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
	"David S. Miller" <davem@davemloft.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Boaz Harrosh <boaz@plexistor.com>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:60071 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932369AbbFBOpF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Jun 2015 10:45:05 -0400
Content-Disposition: inline
In-Reply-To: <CAPcyv4i06Mwis_CSrKV1Yo6crD1vrjb9it6RtYdtwbgOOY9a4g@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--sPkBZsy7C+1fV4MN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2015 at 09:31:03AM -0700, Dan Williams wrote:
> > If you mean, "give me a hand, you can start there", then yeah, I can
> > do that.
> >
> >> I'm not happy about not having had the time to do this rework myself.
> >> Linux is better off with this api deprecated.
> >
> > You're not talking about deprecating it, you're talking about removing
> > it entirely.
>=20
> True, and adding more users makes that removal more difficult.  I'm
> willing to help out on the design and review for this work, I just
> can't commit to doing the implementation and testing.
>=20
> I think it looks something like this:
>=20
> At init time the raid456 driver probes for offload resources It can
> discover several scenarios:
>=20
> 1/ "the ioatdma case": raid channels that have all the necessary
> operations (copy, xor/pq, xor/pq check).  In this case we'll never
> need to perform a channel switch.  Potentially the cpu never touches
> the stripe cache in this case and we can maintain a static dma mapping
> for the entire lifespan of a struct stripe_head.
>=20
> 2/ "the channel switch case":  All the necessary offload resources are
> available but span multiple devices.  In this case we need to wait for
> channel1 to complete an operation before channel2 can start.  This
> case is complicated by the fact that different channels may need their
> own dma mappings.  In the simplest case channels can share the same
> mapping and raid456 needs to wait for channel completions.  I think we
> can do a better job than the async_tx api here as raid456 should
> probably poll for completions after each stripe processing batch.
> Taking an interrupt per channel-switch event seems like excessive
> overhead.
>=20
> 3/ "the co-op case": We have a xor/pq offload resource, but copy and
> check operations require the cpu to touch the stripe cache.  In this
> case we need to use the dma_sync_*_for_cpu()/dma_sync_*_for_device()
> to pass buffers back and forth between device and cpu ownership.  This
> shares some of the complexity of waiting for completions with scenario
> 2.
>=20
> Which scenario does your implementation fall into?  Maybe we can focus
> on that one and leave the other scenarios for other dmaengine
> maintainers to jump in an implement?

=46rom my limited understanding of RAID and PQ computations, it would be
3 with a twist.

Our hardware controller supports xor and PQ, but the checks and
recovering data is not supported (we're not able to offload async_mult
and async_sum_product).

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--sPkBZsy7C+1fV4MN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJVbcCWAAoJEBx+YmzsjxAgtmkP/23sMNPCBdBvNYS0KqqzlCls
kXgIF2Yp5NemAwx1XArRYq8EQtXKh6YMivL1DRutuLT5ETAY5TtP2hQ/VSRZbzUk
4M3Pi7DSEhW6HeCTqUH91swFkgNzXUsEGBL8WP1a/XeZKi2GYvYaiDndXRxR8EBW
7V72ThipDwJzFdqBAhudmnHS4xDmuKAY5I3k7Vma6ZYHDIhRKZHmqJ+PGeaAOtQ1
Yed3DP6jzJz1a0khQKb/9+I4gnMnw45XusEUXSWTMEkPocAjUctQZBzvQgmlPtrx
NadM7UuawZqT5pch7+wR+SiiIFyrdDJoHt6sTfBmjX/ZKK+BrRklAFiuAgWAzAYZ
964l8ZcbmJNynCDoeeRQZmKkqLr2Qly8igS53SZBDGF7/yrCs/4KphwLgXMxJv0j
XrYCHO5nvVKbld58nulT5pqAClga7i5LJlCl0FeIYz+W5OcgKZxA1MQGSi7gfkB4
11Rs90azNoBb6Jvh4K4Xk1V2rQHM9b2AVeuRzhBgnt4+GnoaT0uFsuCRRl+EOp7z
9pJRMUc0qABne/sh5k1pk6X84aA2rvsXQl3miqfNEHP5LGnRgm0TnsJZP31E6BQi
YkbfaJen27O2fv3O8FSvrA0nSLMFjPWTG0fwvjfzsvzh8dpB4Y+B3LlEWALiGvFd
VIrtn5afALP1/8l8HrUW
=7D0i
-----END PGP SIGNATURE-----

--sPkBZsy7C+1fV4MN--
