From: Antoine Tenart <antoine.tenart@free-electrons.com>
Subject: Re: [PATCH v6 1/5] Documentation/bindings: Document the SafeXel
 cryptographic engine driver
Date: Sun, 11 Jun 2017 10:53:53 +0200
Message-ID: <20170611085353.GG31464@kwain>
References: <20170524141035.21031-1-antoine.tenart@free-electrons.com>
 <20170524141035.21031-2-antoine.tenart@free-electrons.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="eMnpOGXCMazMAbfp"
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        thomas.petazzoni@free-electrons.com, oferh@marvell.com,
        igall@marvell.com, nadavh@marvell.com, robin.murphy@arm.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
        jason@lakedaemon.net, andrew@lunn.ch,
        gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:50657 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbdFKIx4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Jun 2017 04:53:56 -0400
Content-Disposition: inline
In-Reply-To: <20170524141035.21031-2-antoine.tenart@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--eMnpOGXCMazMAbfp
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

On Wed, May 24, 2017 at 04:10:31PM +0200, Antoine Tenart wrote:
> The Inside Secure Safexcel cryptographic engine is found on some Marvell
> SoCs (7k/8k). Document the bindings used by its driver.
>=20
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>

Since you applied the Safexcel crypto driver patch, I think you should
also apply this patch adding the corresponding bindings documentation.

Thanks!
Antoine

> ---
>  .../bindings/crypto/inside-secure-safexcel.txt     | 29 ++++++++++++++++=
++++++
>  1 file changed, 29 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/crypto/inside-secur=
e-safexcel.txt
>=20
> diff --git a/Documentation/devicetree/bindings/crypto/inside-secure-safex=
cel.txt b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.t=
xt
> new file mode 100644
> index 000000000000..f69773f4252b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/crypto/inside-secure-safexcel.txt
> @@ -0,0 +1,29 @@
> +Inside Secure SafeXcel cryptographic engine
> +
> +Required properties:
> +- compatible: Should be "inside-secure,safexcel-eip197".
> +- reg: Base physical address of the engine and length of memory mapped r=
egion.
> +- interrupts: Interrupt numbers for the rings and engine.
> +- interrupt-names: Should be "ring0", "ring1", "ring2", "ring3", "eip", =
"mem".
> +
> +Optional properties:
> +- clocks: Reference to the crypto engine clock.
> +- dma-mask: The address mask limitation. Defaults to 64.
> +
> +Example:
> +
> +	crypto: crypto@800000 {
> +		compatible =3D "inside-secure,safexcel-eip197";
> +		reg =3D <0x800000 0x200000>;
> +		interrupts =3D <GIC_SPI 34 IRQ_TYPE_LEVEL_HIGH>,
> +			     <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>,
> +			     <GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>,
> +			     <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
> +			     <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>,
> +			     <GIC_SPI 58 IRQ_TYPE_LEVEL_HIGH>;
> +		interrupt-names =3D "mem", "ring0", "ring1", "ring2", "ring3",
> +				  "eip";
> +		clocks =3D <&cpm_syscon0 1 26>;
> +		dma-mask =3D <0xff 0xffffffff>;
> +		status =3D "disabled";
> +	};
> --=20
> 2.9.4
>=20

--=20
Antoine T=E9nart, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com

--eMnpOGXCMazMAbfp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJZPQUeAAoJEFxNi8it27zYhC4P/0HcvMaEwZClxLDfIQn/nDAU
+gYukWI45iEhlMQLmTT8V2PLmXUXL2rrVwEzAkUQ7jSQ15zkCNvyQ7irhu6ptlQC
ekEfY3GlyGn4Qwdlz/Jn11BYQ6NQhPqjB8C6mfbjWb/NkRdAzHCZVvfroKqvS8eQ
AQwHGZJVfVV/9DHOPfq5QHT2kdmddw86lSrxYPk4I78c+ftpEGLxxvQbaDU+NRbO
hgylh+gyBUw/w11bEta2JkXnxbMtw82MeExV+05E3Ne1ISx0S4IbW1Ixz4kRRKkm
tlEtW2Q1IQx+BpmjPGOJBqnFjf5xgcIVKCcZdz1nAUgKXyvXIc7AOl7hGzylleGM
F3wHtDy7oOdBnBQfwL1MjMgtXsK7VHzbj9CNTvpfUpWo5HJRdbYL3NfC8wp7nI0d
og3AUbiyp4g0OcUCm8dGFzzlM7tmAXJMkPELghLJgW12xuzDQnDtGHFo5+ne9sYt
+ykxeS4YoaxFVc+GP4NSR7wCN2oghcRMOW39A7TgNxa8getToqtjZlZqwHhGrZiM
RRej9wsoVQzwh5zU5tTX7F0HjXtqYhHmaRY2XMWmaCz6Mtq7BSuTRH1c+WS7hPkW
45pnPYbucED5bV7200je16qiDJduYNO1eh4VF9kRDFyNOpDBik5aKfxmi0SuyaEB
97v1L5MRpRz5r9SxPScI
=Ocxt
-----END PGP SIGNATURE-----

--eMnpOGXCMazMAbfp--
