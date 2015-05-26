From: Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 11/13] spi: omap2-mcspi: Support for deferred probing
 when requesting DMA channels
Date: Tue, 26 May 2015 16:27:30 +0100
Message-ID: <20150526152730.GT21577@sirena.org.uk>
References: <1432646768-12532-1-git-send-email-peter.ujfalusi@ti.com>
 <1432646768-12532-12-git-send-email-peter.ujfalusi@ti.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="cCVGH4QhGbYkRKO5"
Cc: vinod.koul@intel.com, tony@atomide.com, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
	dmaengine@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-spi@vger.kernel.org,
	linux-media@vger.kernel.org, alsa-devel@alsa-project.org
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57400 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbbEZP1k (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 May 2015 11:27:40 -0400
Content-Disposition: inline
In-Reply-To: <1432646768-12532-12-git-send-email-peter.ujfalusi@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--cCVGH4QhGbYkRKO5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 26, 2015 at 04:26:06PM +0300, Peter Ujfalusi wrote:

> Switch to use ma_request_slave_channel_compat_reason() to request the DMA
> channels. Only fall back to pio mode if the error code returned is not
> -EPROBE_DEFER, otherwise return from the probe with the -EPROBE_DEFER.

I've got two patches from a patch series here with no cover letter...
I'm guessing there's no interdependencies or anything?  Please always
ensure that when sending a patch series everyone getting the patches can
tell what the series as a whole looks like (if there's no dependencies
consider posting as individual patches rather than a series).

--cCVGH4QhGbYkRKO5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJVZJDhAAoJECTWi3JdVIfQii8H/1dNPl+UQ4hYgOsQbXMiYH/e
613k9/0lY7U0SMHKZ0pKlQNnbkrEDfY1qniWMTAYfBjxhcP97iACvq/Dhf8hPBoX
UsaJGnpjmbMBw9OKGo3aSFQW3OA84ifW7VZK51316IwlL9weniqOJlQ7zRAl8nJe
mBwR9lhFKAfUexsHRZkfqeoxIiZkCM4DU9pqPNeZUI4cu7uiGPGWmwonZ/+K0Zr5
Vm5pe7A4BAyKUYoJatAOfektb0ODeNvo8ogFbsYGThHghm4+24fRQdNDiw/jYGTP
TUJQRHR2/KRHvi2EjdlTMKdG7c/EhnPtH6jS8H2ryIDYtLte+1nBs8lL2EzQJRE=
=GuJ4
-----END PGP SIGNATURE-----

--cCVGH4QhGbYkRKO5--
