Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F38B190671
	for <linux-crypto@vger.kernel.org>; Tue, 20 Aug 2024 16:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724171096; cv=none; b=YU8qndL4zGs9jVFHi6mAD2Gkui5LH3pvUEuBcT+XX/A9UwuAJDvwryPeV8aGIeIaO3XCTQVBwoXjw84Ttm0mAni0fFaetG/FNkKvxY67c1IAdwCaSvA4/P26PjpCQSz3YpJoNtBDKK6XKBEn6GfsEuwCLtHy3RRdlnee6okb/Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724171096; c=relaxed/simple;
	bh=PzZ3B4Oof6/mmhHRrPZJgRfSqra5K+EuTRadfhD9cwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KAHSw0gknbbLHASLY5cTMhwt+v+KMV4GX3fvwLEHalXegqlFFk+NHAFa6Az/HRljpwtqdaqhSz/vV6X49+gSjBdmnsGlrzLlgqt6Md0n5u6rvIaichD02IYrukUZwlK1p7aTc8SDHoM4vi2pmL+jcRmJS02XFezmXSvJCmXUF5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dNOmyANg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dNOmyANg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C21F4C4AF0F;
	Tue, 20 Aug 2024 16:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724171096;
	bh=PzZ3B4Oof6/mmhHRrPZJgRfSqra5K+EuTRadfhD9cwo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dNOmyANg5zCZTj7qILMv4s9/eGY9EuS+lTOiru7UfGNXzDRKu8KgOJB4hdA8ZlcbS
	 ZhAbTKRFhMY6AbFqEbtuJMRESiUO1GIsd2uEfIOyVIroWzGeHCfKhM7/RO2rLNRWlw
	 6sX1Qoq7u0c8iFPux7MSXnbadkDWwsLrMeSXrRWvA1IsRSDyu79XGhI8TyLHc1TVqc
	 I/SKrOau/Uam0L/e7B+fV7Z72dVB9gFD0AxL0qaql/ximkEB4lXoKhDAME1N3B38Eq
	 qLmID2Wx1TG65EzllC5gNrqg+ctfIHWnUcqknVx2z6SEi83KLki9S87BnmG4NN2Spi
	 j2fpIl/clR7fA==
Date: Tue, 20 Aug 2024 17:24:52 +0100
From: Conor Dooley <conor@kernel.org>
To: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v5 6/7] Add SPAcc dts overlay
Message-ID: <20240820-bunion-cloud-89ab9ac2d82c@spud>
References: <20240621082053.638952-1-pavitrakumarm@vayavyalabs.com>
 <20240621082053.638952-7-pavitrakumarm@vayavyalabs.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="g+8cyK+KYF+BRz61"
Content-Disposition: inline
In-Reply-To: <20240621082053.638952-7-pavitrakumarm@vayavyalabs.com>


--g+8cyK+KYF+BRz61
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 01:50:52PM +0530, Pavitrakumar M wrote:
> Signed-off-by: Manjunath Hadli <manjunath.hadli@vayavyalabs.com>
> Signed-off-by: Pavitrakumar M <pavitrakumarm@vayavyalabs.com>
> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>

In case it is not clear from Geert's mail earlier today, NAK to merging
any of this without bindings.

Thanks,
Conor.

> ---
>  arch/arm64/boot/dts/xilinx/Makefile           |  3 ++
>  .../arm64/boot/dts/xilinx/snps-dwc-spacc.dtso | 35 +++++++++++++++++++
>  2 files changed, 38 insertions(+)
>  create mode 100644 arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso
>=20
> diff --git a/arch/arm64/boot/dts/xilinx/Makefile b/arch/arm64/boot/dts/xi=
linx/Makefile
> index 1068b0fa8e98..1e98ca994283 100644
> --- a/arch/arm64/boot/dts/xilinx/Makefile
> +++ b/arch/arm64/boot/dts/xilinx/Makefile
> @@ -20,6 +20,7 @@ dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-zcu1275-revA.dtb
> =20
>  dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-sm-k26-revA.dtb
>  dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-smk-k26-revA.dtb
> +dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-smk-k26-revA.dtb
> =20
>  zynqmp-sm-k26-revA-sck-kv-g-revA-dtbs :=3D zynqmp-sm-k26-revA.dtb zynqmp=
-sck-kv-g-revA.dtbo
>  dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-sm-k26-revA-sck-kv-g-revA.dtb
> @@ -29,3 +30,5 @@ zynqmp-smk-k26-revA-sck-kv-g-revA-dtbs :=3D zynqmp-smk-=
k26-revA.dtb zynqmp-sck-kv-
>  dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-smk-k26-revA-sck-kv-g-revA.dtb
>  zynqmp-smk-k26-revA-sck-kv-g-revB-dtbs :=3D zynqmp-smk-k26-revA.dtb zynq=
mp-sck-kv-g-revB.dtbo
>  dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-smk-k26-revA-sck-kv-g-revB.dtb
> +zynqmp-zcu104-revC-snps-dwc-spacc-dtbs :=3D zynqmp-zcu104-revC.dtb snps-=
dwc-spacc.dtbo
> +dtb-$(CONFIG_ARCH_ZYNQMP) +=3D zynqmp-zcu104-revC-snps-dwc-spacc.dtb
> diff --git a/arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso b/arch/arm64/=
boot/dts/xilinx/snps-dwc-spacc.dtso
> new file mode 100644
> index 000000000000..603ad92f4c49
> --- /dev/null
> +++ b/arch/arm64/boot/dts/xilinx/snps-dwc-spacc.dtso
> @@ -0,0 +1,35 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * dts file for Synopsys DWC SPAcc
> + *
> + * (C) Copyright 2024 Synopsys
> + *
> + * Ruud Derwig <Ruud.Derwig@synopsys.com>
> + */
> +
> +/dts-v1/;
> +/plugin/;
> +
> +/ {
> +	#address-cells =3D <2>;
> +	#size-cells =3D <2>;
> +
> +	fragment@0 {
> +		target =3D <&amba>;
> +
> +		overlay1: __overlay__ {
> +			#address-cells =3D <2>;
> +			#size-cells =3D <2>;
> +
> +			dwc_spacc: spacc@400000000 {
> +				compatible =3D "snps-dwc-spacc";
> +				reg =3D /bits/ 64 <0x400000000 0x3FFFF>;
> +				interrupts =3D <0 89 4>;
> +				interrupt-parent =3D <&gic>;
> +				clock-names =3D "ref_clk";
> +				spacc_priority =3D <0>;
> +				spacc_index =3D <0>;
> +			};
> +		};
> +	};
> +};
> --=20
> 2.25.1
>=20

--g+8cyK+KYF+BRz61
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZsTDVAAKCRB4tDGHoIJi
0iQXAP9d0ipBsTHcQE5RmxSJUdqp6Yj2mCZC1edGN17qy4h6UQEA3tKsBeu1AneA
yy04G68mMWykHi3OV72s+R7+z7o4EA0=
=LJob
-----END PGP SIGNATURE-----

--g+8cyK+KYF+BRz61--
