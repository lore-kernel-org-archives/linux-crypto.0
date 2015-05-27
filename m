From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 11/13] spi: omap2-mcspi: Support for deferred probing
 when requesting DMA channels
Date: Wed, 27 May 2015 18:48:30 +0100
Message-ID: <20150527174830.GK21577@sirena.org.uk>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-12-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="g/JY+XiM8mEZh6Fo"
Cc: vinod.koul@intel.com, tony@atomide.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
	dmaengine@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Return-path: <linux-omap-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1432646768-12532-12-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-omap-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


--g/JY+XiM8mEZh6Fo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 26, 2015 at 04:26:06PM +0300, Peter Ujfalusi wrote:
> Switch to use ma_request_slave_channel_compat_reason() to request the DMA
> channels. Only fall back to pio mode if the error code returned is not
> -EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFER.

Acked-by: Mark Brown <broonie@kernel.org>

--g/JY+XiM8mEZh6Fo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVZgNtAAoJECTWi3JdVIfQtmgH/30kWkauDW84EsImYVzJjQkj
OWSjAg1TOjdXDeJUU7FLRPEkGD+w0mPmnExxwKvssSSlOoXM+nxfUd0s4HNbpLxl
EXF8PNafOHLOhQOQKcz8DOBWoE3xLWclaJRt7gdICnqGoLC1KOqkCgFV2ZkCY12w
cZynI3E2mx7PkuKdy9MctUrlJRejxg7GrthmT9uU6IStt9lCKKSM1RhnB9ce5NIH
LjFR06hOaHNp5q160vEnF+GJKAFPAjAwiE7n0CRzWPjSKWAOMU4oxn1EstK9jbfU
UuslLJjBNmt4So8Er/3j/V9BzjlPEaAmm4XJhL/dBWFFYALM05st6q7VJ5FkSRE=
=+jAM
-----END PGP SIGNATURE-----

--g/JY+XiM8mEZh6Fo--
