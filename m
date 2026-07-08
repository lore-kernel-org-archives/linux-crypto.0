Received: from sender4-op-o11.zoho.com (sender4-op-o11.zoho.com [136.143.188.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF25D39021C;
	Wed,  8 Jul 2026 23:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783554989; cv=pass; b=MBHSwYiuAibP1iILvt/+TcxO2p+ACi5uddGPe43f5MU+Fb+sTunHgY49R2CfNPoszfeuKyIt+5445p+fGxk+vuewyrGNYspmzWSmMtnVd/jDArNeYGw0x7GqH3JYjtunBWRHWjlHOJZkGfctf/1L74DNgnc6yATirIGzD0hxRLg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783554989; c=relaxed/simple;
	bh=1S0123Ko3TwwqEYz9+NFJGMEEcDCr/jiCUfmFtGOsJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gtLmL1R68i6kx5IWJkA2TcO58oEtVb5yPzsH3DfsObSD7p5/8swTmqlpyMVI6NTD1m7F7JU8VF+pn+4u79FWHltwcux2SCyjQ+FY8KqwMjPIkGyFWxYuKsj4sZGWhEYdolvzzrXI3rAmQK6byhMqmYpHGk1p9s/eYOkWj14nbMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (1024-bit key) header.d=collabora.com header.i=sebastian.reichel@collabora.com header.b=F2b67eCg; arc=pass smtp.client-ip=136.143.188.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=collabora.com header.i=sebastian.reichel@collabora.com header.b="F2b67eCg"
ARC-Seal: i=1; a=rsa-sha256; t=1783554977; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=XFb4GppKjEilY55ygRsHWBLOhnNKpUcm1DkzM5BcMD3KdJ0BG9a2LVDTRquH33zAmRW6wy3en2cJy+R7a4uBEyQaTtKaKnf8L0ym4D0vZnjfts9y7VmDBErGqJYq7mPC5+rVNi+/iR1Qs6HZqPSmYNxmlHAjZ7T1uAa7wua0oqE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1783554977; h=Content-Type:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=CbB3C9UwRHwJz8l8h3m0DtvM1ARd9imbzXPsvbNCwWY=; 
	b=PS4tCHROjJk2PrBhFzM1Ve3trFDTdtcsasKSNYaZNYXE7Cj+gUoC7ldhlQgFvmAv/2TKwI5G94JhBA2I8Oq58SPfvwm4R4EG6WAuyijiSwFFbpPI09n2iMj8Qfng4sdN2DfbeJu9q2gJqQc7x5AnVZnCXGIxE0eY0y+KP7yzr3I=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=sebastian.reichel@collabora.com;
	dmarc=pass header.from=<sebastian.reichel@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1783554977;
	s=zohomail; d=collabora.com; i=sebastian.reichel@collabora.com;
	h=Date:Date:From:From:To:To:Cc:Cc:Subject:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To:Message-Id:Reply-To;
	bh=CbB3C9UwRHwJz8l8h3m0DtvM1ARd9imbzXPsvbNCwWY=;
	b=F2b67eCg2Gk8F9eawFiscCcCs/KpYLYJLV0/6xrQwCWeA9UZc5/1swtcHIKL+fAh
	UxiuKT/3C6m5eTplA6T64ww6m7o3KhjXpsR8sjxNzAyBqGqZXTd/Lmcr4HDFaiOFrsN
	SZ+5e6MJyDfbs4gNMS1UmJ4j8KMHYi6S5F6w4D78=
Received: by mx.zohomail.com with SMTPS id 1783554974300771.8410971279968;
	Wed, 8 Jul 2026 16:56:14 -0700 (PDT)
Received: by venus (Postfix, from userid 1000)
	id 2C4631806CA; Thu, 09 Jul 2026 01:56:10 +0200 (CEST)
Date: Thu, 9 Jul 2026 01:56:10 +0200
From: Sebastian Reichel <sebastian.reichel@collabora.com>
To: Dawid Olesinski <dawidro@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Heiko Stuebner <heiko@sntech.de>, Corentin Labbe <clabbe@baylibre.com>, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] arm64: dts: rockchip: Add crypto node to
 rk356x-base
Message-ID: <ak7jEYTAGgeDdi1W@venus>
References: <20260708175837.1718437-1-dawidro@gmail.com>
 <20260708175837.1718437-4-dawidro@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nchjsrkyo2s4nb4j"
Content-Disposition: inline
In-Reply-To: <20260708175837.1718437-4-dawidro@gmail.com>
X-Zoho-Virus-Status: 1
X-Zoho-AV-Stamp: zmail-av-0.2.10.1.5.2/283.531.57
X-ZohoMailClient: External


--nchjsrkyo2s4nb4j
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 3/4] arm64: dts: rockchip: Add crypto node to
 rk356x-base
MIME-Version: 1.0

Hi,

On Wed, Jul 08, 2026 at 06:58:24PM +0100, Dawid Olesinski wrote:
> Add the device tree node for the V2 cryptographic hardware accelerator
> on RK356x SoCs (RK3566, RK3568).
>=20
> The IP block sits in the non-secure peripheral domain. Its three clocks
> (core, aclk, hclk) and reset line are accessible directly through the
> main non-secure CRU, so no firmware intermediary is required.
>=20
> The node is disabled by default; board files that wish to use hardware
> crypto offload must enable it.

Why is it disabled by default? It doesn't seem to be board specific
at all to me (the same question applies to the RK3588 DT).

Greetings,

-- Sebastian

>=20
> Signed-off-by: Dawid Olesinski <dawidro@gmail.com>
> ---
>  arch/arm64/boot/dts/rockchip/rk356x-base.dtsi | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi b/arch/arm64/b=
oot/dts/rockchip/rk356x-base.dtsi
> index a5832895bd39..9de7e7487ca1 100644
> --- a/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
> +++ b/arch/arm64/boot/dts/rockchip/rk356x-base.dtsi
> @@ -1112,6 +1112,18 @@ sdhci: mmc@fe310000 {
>  		status =3D "disabled";
>  	};
> =20
> +	crypto: crypto@fe380000 {
> +		compatible =3D "rockchip,rk3568-crypto";
> +		reg =3D <0x0 0xfe380000 0x0 0x2000>;
> +		interrupts =3D <GIC_SPI 4 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks =3D <&cru CLK_CRYPTO_NS_CORE>, <&cru ACLK_CRYPTO_NS>,
> +			 <&cru HCLK_CRYPTO_NS>;
> +		clock-names =3D "core", "aclk", "hclk";
> +		resets =3D <&cru SRST_CRYPTO_NS_CORE>;
> +		reset-names =3D "core";
> +		status =3D "disabled";
> +	};
> +
>  	/*
>  	 * Testing showed that the HWRNG found in RK3566 produces unacceptably
>  	 * low quality of random data, so the HWRNG isn't enabled for all RK356x
> --=20
> 2.47.3
>=20
>=20

--nchjsrkyo2s4nb4j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmpO45kACgkQ2O7X88g7
+pqdGhAAnuYg7zLjumByWrVauxAbYdeNH1NJ0MFQCIsxYyhDCl9PVKc27oFP6/Ev
Xtwp8RQDB0Aq1AHuGPnmhy9UOTBwOi0I6uaOtdRjPKT/pEOATJY5UvpdGsHe9c+/
/HFlMJdEykULZjzULWjyFNAxON/gc5qGAfPKaaMKryJgRKVBu2girSp1ky+YSoAx
GeWAf2WvTf0jrSbrrxcCbRrUVVs5Ni9TMTgijp2rNNKEW98MiJSj8FnWYmmhfbIO
WRJz/r5/NgGZwXiL/FE50wV8p+p5s2OvFER4NBcuKao6rVDyrBtuxX0Nfgq68qqU
DqJXzfHTBSn9zq/Wxp1VTGDm0IYShRFQ6qDHPWzEl817WBs8JDy+9i5qCSDtVXli
lLwZOKqEiuYJj1IKSLJcePomtilj8v+VJr2CJM5TezKaTAZN82rruqr7PX16ubdC
oV96WMMqeEYOObrN2tfzCGjq+cF7MciSGnvMNVSmCxF5laD7AQXihQo/fxhw1P/c
MZnz8K1lFD1qUU9Yx7T0zjmvFVvmfY8/mrp/gcGtYQ53f+U9Lfe3B4sK50kEyBdS
bcgaWJL1R+X/DDdH0AUqAs+jLPwXYDk93DqV4F/PPwUUlvFJVnFs5wsk6wtawIXn
P2wdhmkYnCwD5DBgk1MVyWFGCMfS8ur91pGWCctlXLRWkwIAJiw=
=xw6V
-----END PGP SIGNATURE-----

--nchjsrkyo2s4nb4j--
