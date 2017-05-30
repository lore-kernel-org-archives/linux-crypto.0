From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [PATCH v2 12/12] ARM: sun5i: add a cryptographic engine node
Date: Tue, 30 May 2017 08:48:11 +0200
Message-ID: <20170530064811.idsv66mvfyh2tyiw@flea.lan>
References: <20170529202738.2167-1-antoine.tenart@free-electrons.com>
 <20170529202738.2167-13-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="vqogfsnyvuomvqoo"
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, wens@csie.org,
        clabbe.montjoie@gmail.com, linux-crypto@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:41709 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdE3GsW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 May 2017 02:48:22 -0400
Content-Disposition: inline
In-Reply-To: <20170529202738.2167-13-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--vqogfsnyvuomvqoo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 29, 2017 at 10:27:38PM +0200, Antoine Tenart wrote:
> Add a node for the cryptographic engine that can be found on sun5i SoCs.
> This cryptographic engine is compatible with the Allwinner cryptographic
> accelerator driver.
>=20
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  arch/arm/boot/dts/sun5i.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun5i.dtsi b/arch/arm/boot/dts/sun5i.dtsi
> index 5175f9cc9bed..9bfefa2c7224 100644
> --- a/arch/arm/boot/dts/sun5i.dtsi
> +++ b/arch/arm/boot/dts/sun5i.dtsi
> @@ -355,6 +355,14 @@
>  			status =3D "disabled";
>  		};
> =20
> +		crypto: crypto-engine@01c15000 {
> +			compatible =3D "allwinner,sun4i-a10-crypto";

you should add a SoC-specific compatible here, just so that if we ever
need to fix something in there we don't have to update our DT.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--vqogfsnyvuomvqoo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJZLRWrAAoJEBx+YmzsjxAg6r8P/i9zeyupVXm1i7VTiCcpOZOr
g7ZO76p1PCYSZAUYqnOgyITa75gciA8JXbwp9G7pkyjnyrGcGQvEplhjeJxFhIDs
x7nGZtL7WqaNfPlgHRA8FTBote1riOEyT42rie6ghU1yI/ZSiusDOI7YsXTlQUhc
Rq7zgMjL7FabiqWNHc8MJYgbEevXto24uEUKVJzQE+J3WWyRDDGHz6NAdKMRPN8e
5RrlH1V4VTbquiodxslC7eiz/Xzf2RtooORSkhuk3zPdTP++IQQWZ4Kyy5vmUmLI
d8dNtc+pRsPNVM1II1uvuv5MZ78gBI3Jg/dtKAyaOkqEO6HO3DbtuhIpflJRswwJ
Xj8S2B7ceYeVx1Xz6QrScLBxz7jh0XfNdcjWoUxBOPqiHF6N55ERsJAqCTQilR8H
CEuWHxYi7rS042x2w+Zjrz+PbxCfPmPMbbAHlcWaHoeBIH1zLl+1V52o7MUBUQJW
Yx1Tn+pumAneNp433XBLpoPyhuCVGtif2/AS5cq9iL7kvbjYFeEz6kKWf87kffUk
QaXsdIxrQf/F0HpnqCrRwLKhJ/zeVRH0pq396UiqwsJSYV6+VNZsxbkaJ+/nMAtG
7dELw5mpYMr7C8nQmq8k2g4V1cBm7GG1koi+htFDL5fq9cyfPPmec1O5t3OgLfy5
bDma/GxSs9DfsOmRUvdl
=08b5
-----END PGP SIGNATURE-----

--vqogfsnyvuomvqoo--
