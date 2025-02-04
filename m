Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF44F2147E9;
	Tue,  4 Feb 2025 19:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738697212; cv=none; b=JrdBXVYcROdyzPS88Nzf0t3T2MOwEgY0wlfvIx5mCYgVXRLc+AMzLhJaNyhLPSEIkUK6bJq8n6p/UfUtldybnqlNB51Z2SrRZ18zs13EGw97ARzr4ZFyIyHXhy0Nv94naDRo+m9c4jR757vo5EfU3tNRYbAAyrEXYAoZ+ypxGx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738697212; c=relaxed/simple;
	bh=CUugQ4UB8ewPvEhGFpWRj7jO44gq3NLTzSwK4Ta4SAY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nRkjqWd3l0kW16c/LdsOAVWAA1AFOWpmg1rGZwxGlDS0yqXAsCFO3nfXY22w4WjtI6Gq0jAFTiycVMQBSURR1M48/E0FSUBCQJUXi7pUKb7lT7XR93XN/M/FEB7ijZ7ZNRmvrYoZ8TDR/dxsP2adcO2YQ6QmeU7CRM81Dp/ncNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=If/fF4qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="If/fF4qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E16DC4CEDF;
	Tue,  4 Feb 2025 19:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738697212;
	bh=CUugQ4UB8ewPvEhGFpWRj7jO44gq3NLTzSwK4Ta4SAY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=If/fF4qyzjOA0+yCmOfYWkWbEyXoVZvtmd/BWQJb/Z9Whx5AQd32XjDQEApfnoCas
	 uK3WEjCmaJeTXU24HtocZuLB4vDzq1o3Xb9xZ0cdS7rGqx4L30j4zsUloD+1vJ2I1w
	 oKYn16tFe+PvCkqe9oBJV+aGSNoaBr8735ZQVvNMOvEqSIyB1T8WMkXoLNhbqrsDA8
	 Sxv6YIJjBuOTPPhtnVQtwRak96ircyn28PQ92eB5lF9nfzNN6M2t92hcV4sBLoyP7/
	 92MFLyUW39LLt7ffwe5qaRZphEFKIRW4PeguGrxNaZFsNxGZYQh75+dWpDhhu/N7/G
	 V3vnVHAl4jlFg==
Date: Tue, 4 Feb 2025 19:26:46 +0000
From: Conor Dooley <conor@kernel.org>
To: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Daniel Golle <daniel@makrotopia.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	kernel@collabora.com, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 2/7] dt-bindings: rng: add binding for Rockchip RK3588
 RNG
Message-ID: <20250204-monologue-throng-c6772c089404@spud>
References: <20250204-rk3588-trng-submission-v2-0-608172b6fd91@collabora.com>
 <20250204-rk3588-trng-submission-v2-2-608172b6fd91@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3oc7PGcIEvdR+5za"
Content-Disposition: inline
In-Reply-To: <20250204-rk3588-trng-submission-v2-2-608172b6fd91@collabora.com>


--3oc7PGcIEvdR+5za
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 04, 2025 at 04:35:47PM +0100, Nicolas Frattaroli wrote:
> The Rockchip RK3588 SoC has two hardware RNGs accessible to the
> non-secure world: an RNG in the Crypto IP, and a standalone RNG that is
> new to this SoC.
>=20
> Add a binding for this new standalone RNG. It is distinct hardware from
> the existing rockchip,rk3568-rng, and therefore gets its own binding as
> the two hardware IPs are unrelated other than both being made by the
> same vendor.
>=20
> The RNG is capable of firing an interrupt when entropy is ready.
>=20
> The reset is optional, as the hardware does a power-on reset, and
> functions without the software manually resetting it.
>=20
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

--3oc7PGcIEvdR+5za
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ6Jp9gAKCRB4tDGHoIJi
0sZwAPwNeNLYaxfWC1AxcDB1tYjKebikVvcKzjwoZADBtieSSQEA6/BVaYCQIuCs
363NNSW6ibIXN0SYog0H3t+JFHlysQ4=
=mXHF
-----END PGP SIGNATURE-----

--3oc7PGcIEvdR+5za--
