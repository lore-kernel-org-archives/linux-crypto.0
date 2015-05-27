From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 13/13] ASoC: omap-pcm: Switch to use
 dma_request_slave_channel_compat_reason()
Date: Wed, 27 May 2015 18:48:42 +0100
Message-ID: <20150527174842.GL21577@sirena.org.uk>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-14-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nt+vFqn/aPO6zu0j"
Cc: vinod.koul@intel.com, tony@atomide.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
	dmaengine@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
	Jarkko Nikula <jarkko.nikula@bitmer.com>,
	Liam Girdwood <lgirdwood@gmail.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432646768-12532-14-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--nt+vFqn/aPO6zu0j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 26, 2015 at 04:26:08PM +0300, Peter Ujfalusi wrote:
> dmaengine provides a wrapper function to handle DT and non DT boots when
> requesting DMA channel. Use that instead of checking for of_node in the
> platform driver.

Acked-by: Mark Brown <broonie@kernel.org>

--nt+vFqn/aPO6zu0j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVZgN6AAoJECTWi3JdVIfQK9QH/0/yPag64vn/82FuyAK+qqjP
yKDVu5pt9gu5mC9wK69tm9TyqijJ4MLRFLYvaiLfSFgchTZN2upb6fxCEZAlsLNX
5VSso5EVNC3XAnP4Ong5EgAJluhf3X29RIc/TNinG426/0mPD0E9udZKpYDddxI9
MSgLVt1UELbHdcXC2pESJWxu2AID0kvaGfPV99vH8U3qOAtyimM/Au/DpXaiji6m
1XFlwGwNITHD0ZsjpkH39Q6MjQU2WItVL+Kr7m+4SrAo85jMvrP3MQ5Po6jlpx3s
urUiv2OWG7FyRfnaJQcxLC+KeC5E9WgzkrqGbtjfwSDOQWNJMek0daZkIMoTo2Q=
=pr+m
-----END PGP SIGNATURE-----

--nt+vFqn/aPO6zu0j--
