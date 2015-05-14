From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCH v2] crypto: omap-sham: Check for return value from pm_runtime_get_sync
Date: Thu, 14 May 2015 23:40:37 +0200
Message-ID: <201505142340.37649@pali>
References: <1424958600-18881-5-git-send-email-pali.rohar@gmail.com> <1425808861-17004-1-git-send-email-pali.rohar@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7025459.kGf0r5O8cn";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Cc: =?utf-8?q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <robh+dt@kernel.org>,
	Russell King <linux@arm.linux.org.uk>,
	Paul Walmsley <paul@pwsan.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Pavel Machek <pavel@ucw.cz>, Nishanth Menon <nm@ti.com>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Sebastian Reichel <sre@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425808861-17004-1-git-send-email-pali.rohar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

--nextPart7025459.kGf0r5O8cn
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 08 March 2015 11:01:01 Pali Roh=C3=A1r wrote:
> Function pm_runtime_get_sync could fail and we need to check return
> value to prevent kernel crash.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
> v2: Check return value for all pm_runtime_get_sync() calls
> ---
>  drivers/crypto/omap-sham.c |   23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
> index b20e374..c5df53d 100644
> --- a/drivers/crypto/omap-sham.c
> +++ b/drivers/crypto/omap-sham.c
> @@ -362,7 +362,13 @@ static void omap_sham_copy_ready_hash(struct
> ahash_request *req)
>=20
>  static int omap_sham_hw_init(struct omap_sham_dev *dd)
>  {
> -	pm_runtime_get_sync(dd->dev);
> +	int err;
> +
> +	err =3D pm_runtime_get_sync(dd->dev);
> +	if (err < 0) {
> +		dev_err(dd->dev, "failed to get sync: %d\n", err);
> +		return err;
> +	}
>=20
>  	if (!test_bit(FLAGS_INIT, &dd->flags)) {
>  		set_bit(FLAGS_INIT, &dd->flags);
> @@ -1949,7 +1955,13 @@ static int omap_sham_probe(struct
> platform_device *pdev) dd->flags |=3D dd->pdata->flags;
>=20
>  	pm_runtime_enable(dev);
> -	pm_runtime_get_sync(dev);
> +
> +	err =3D pm_runtime_get_sync(dev);
> +	if (err < 0) {
> +		dev_err(dev, "failed to get sync: %d\n", err);
> +		goto err_pm;
> +	}
> +
>  	rev =3D omap_sham_read(dd, SHA_REG_REV(dd));
>  	pm_runtime_put_sync(&pdev->dev);
>=20
> @@ -1979,6 +1991,7 @@ err_algs:
>  		for (j =3D dd->pdata->algs_info[i].registered - 1; j >=3D 0; j--)
>  			crypto_unregister_ahash(
>  					&dd->pdata->algs_info[i].algs_list[j]);
> +err_pm:
>  	pm_runtime_disable(dev);
>  	if (dd->dma_lch)
>  		dma_release_channel(dd->dma_lch);
> @@ -2021,7 +2034,11 @@ static int omap_sham_suspend(struct device
> *dev)
>=20
>  static int omap_sham_resume(struct device *dev)
>  {
> -	pm_runtime_get_sync(dev);
> +	int err =3D pm_runtime_get_sync(dev);
> +	if (err < 0) {
> +		dev_err(dev, "failed to get sync: %d\n", err);
> +		return err;
> +	}
>  	return 0;
>  }
>  #endif

Herbert, can you apply this patch?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart7025459.kGf0r5O8cn
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlVVFlUACgkQi/DJPQPkQ1IWHgCfQcNxQoP0s3/Xir5426BLX59P
6sUAniMOjl6klq5U2verxxGGQic5suKx
=zozE
-----END PGP SIGNATURE-----

--nextPart7025459.kGf0r5O8cn--
