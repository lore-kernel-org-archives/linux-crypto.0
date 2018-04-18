From: Wolfram Sang <wsa-z923LK4zBo2bacvFa/9K2g@public.gmane.org>
Subject: Re: [PATCH v3 07/20] i2c: Remove depends on HAS_DMA in case of
	platform dependency
Date: Wed, 18 Apr 2018 09:01:54 +0200
Message-ID: <20180418070154.mgvdb2ne7tdqyyra@ninjato>
References: <1523987360-18760-1-git-send-email-geert@linux-m68k.org>
	<1523987360-18760-8-git-send-email-geert@linux-m68k.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0613545038917178784=="
Cc: Ulf Hansson <ulf.hansson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fpga-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-remoteproc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	alsa-devel-K7yf7f+aM1XWsZ/bQMPhNw@public.gmane.org, Bjorn Andersson <bjorn.andersson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
	Eric Anholt <eric-WhKQ6XTQaPysTnJN9+BGXg@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-i2c-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux1394-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>,
	Stefan Wahren <stefan.wahren-eS4NqCHxEME@public.gmane.org>,
	Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Jassi Brar <jassisinghbrar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Marek Vasut <marek.vasut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matias Bjorling <mb-VR7NuqX4VJ8tq7phqP6ubQ@public.gmane.org>,
	linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ohad Ben-Cohen <ohad-Ix1uc/W3ht7QT0dZR+AlfA@public.gmane.org>,
	devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, Alan Tull <atull-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>,
	linux-k
To: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1523987360-18760-8-git-send-email-geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org


--===============0613545038917178784==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="65i3mhai7gxgnaf3"
Content-Disposition: inline


--65i3mhai7gxgnaf3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2018 at 07:49:07PM +0200, Geert Uytterhoeven wrote:
> Remove dependencies on HAS_DMA where a Kconfig symbol depends on another
> symbol that implies HAS_DMA, and, optionally, on "|| COMPILE_TEST".
> In most cases this other symbol is an architecture or platform specific
> symbol, or PCI.
>=20
> Generic symbols and drivers without platform dependencies keep their
> dependencies on HAS_DMA, to prevent compiling subsystems or drivers that
> cannot work anyway.
>=20
> This simplifies the dependencies, and allows to improve compile-testing.
>=20
> Signed-off-by: Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>
> Reviewed-by: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Acked-by: Robin Murphy <robin.murphy-5wv7dgnIgG8@public.gmane.org>

Applied to for-current, thanks!


--65i3mhai7gxgnaf3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAlrW7V4ACgkQFA3kzBSg
KbbXkQ/6A+My2+u0mIuo0vlx8PQNM4nXpuGAjtIwhvCDZDUsVnYi3wAnpwGSSbUe
dFFkEoD6fo2xikBdF1xjwU36oCMO3VV4zdSPXKmBLQgLd+EDY1WS1sX54kYzNb2T
aqxIL8J8Uf7SNNVxg1iaPLQbakS96xLocim26fWdV+H+ggLJxthEQlZrR2LKV/m2
UHE+8NLy13Zq0+WAd9l/aX+7Lo5WZUBFAZIorLEI8v2nfWtUf3oBVBU97FxbjDwc
gEmi2qqcggS3CtaGQmHUJc6FiirvHbNGfLAI/3SzAZ2qkrcn+kJbls3LJ6wEpfvp
OHkQyujvT2QokgW/xddLqyMTl16EDiPKT2YWjP/fsgpfAZEubDCVyDt4VJ8sNMLH
Zvm5A1jU/9k3LE0dxG8fEiwW3RkD7qtsUDayY1T4BZvafjXVww+VRJZyxRVCGOqd
ohBossb6pK0difN2MbnaSeE1ykkn9sGbEot/AyQ5xfw9Mjjkm8VfBuIT/GqgIr3r
vegJZcPwC8rdJTz5qg/6lj3JuIL51OxBfuFaIpYQR6klrer9y9VSbKKuFJyAW0Y1
E4+f1d2cxaJPcuUbvfINWpyBLBHTFARdWYcE9tFxxOHBXLxgRnRKKljZZYq5yc6b
LR03w8WxaMKC4cT6mPgBHSck/LY70C5pA4k/VlOj2+MNa4cPA30=
=opRi
-----END PGP SIGNATURE-----

--65i3mhai7gxgnaf3--

--===============0613545038917178784==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--===============0613545038917178784==--
