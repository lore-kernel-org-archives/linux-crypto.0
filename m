Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D5F179BC;
	Thu, 30 Jan 2025 18:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738262778; cv=none; b=Em8m8h1adNpuiL0O95Bz+HHbs8/qlxd+G0RlINa8kTkXxG812GICWaRbA3m41fu/RSazHbRlVPxvR+5mmozYpT11+R8x9eJVfDOfgm+JMdZ/Ezmgqbf6zzrVBYaQN6XeuF8zdrlP5ycJ8OJmhOcypqDmWMpLgdkwBBCghsXs4Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738262778; c=relaxed/simple;
	bh=0K6s1LorKkA3vT94npzZne1s6vrmJojmi6fmu1jX3YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qO0/DLWIPtLAseRgKCAFK8+5nJlxXAy8dZVzAeW+EJyi3/afwIRds6xbK4VpkD5euT+jTcT8yXIthHNZd4Lk2b8jIfxFdDJZYAAqGwHzuFhKf4JLQhvLZq+mdTR1/gvD+t9hAODf+z+jPdeQ21Cg8q3ZqPWkOAGy3AI+p2a15Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/25bg1c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/25bg1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC740C4CED2;
	Thu, 30 Jan 2025 18:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738262777;
	bh=0K6s1LorKkA3vT94npzZne1s6vrmJojmi6fmu1jX3YI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k/25bg1cFe91uYNFaGP8OzA2csT7VrfCxQQ85vXieeatqHEH7TENfk6bozjSKXLK+
	 wdDeOJY8kTahByo6G/XtWwAipPDysbPGOYMSWGMOdOC7npjNCO4sGEYCm6w22oUGGV
	 nTu+pOrB+bsj2VM05owXPCSZYFhfIjImRr+5pdUrryjq19U/K2m6dI0bmM5N561tCz
	 77GeQPRyxOkYK4z9r+vjIC2JGUh6PvvRZ02DlcIfSCNlRHfTqH2V8m5lOT5m5hJzP8
	 oHE6TrpQVaN3P8IlOJw3fvoVK5gHZ0dPCbvr+XLNLMKABemI0SRuakb+KgJnYlToCQ
	 FKpBhFimtXdtg==
Date: Thu, 30 Jan 2025 18:46:12 +0000
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
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	XiaoDong Huang <derrick.huang@rock-chips.com>
Subject: Re: [PATCH 1/7] dt-bindings: reset: Add SCMI reset IDs for RK3588
Message-ID: <20250130-payment-carpentry-bf3898625c96@spud>
References: <20250130-rk3588-trng-submission-v1-0-97ff76568e49@collabora.com>
 <20250130-rk3588-trng-submission-v1-1-97ff76568e49@collabora.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="CXK8FdX5cD3efR4o"
Content-Disposition: inline
In-Reply-To: <20250130-rk3588-trng-submission-v1-1-97ff76568e49@collabora.com>


--CXK8FdX5cD3efR4o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 30, 2025 at 05:31:15PM +0100, Nicolas Frattaroli wrote:
> When TF-A is used to assert/deassert the resets through SCMI, the
> IDs communicated to it are different than the ones mainline Linux uses.
>=20
> Import the list of SCMI reset IDs from mainline TF-A so that devicetrees
> can use these IDs more easily.
>=20
> Co-developed-by: XiaoDong Huang <derrick.huang@rock-chips.com>
> Signed-off-by: XiaoDong Huang <derrick.huang@rock-chips.com>
> Signed-off-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

--CXK8FdX5cD3efR4o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZ5vI9AAKCRB4tDGHoIJi
0lvpAP9ygjEXGyo4J28BWq/27ynjo3PWvGqe6RcHCk0ZCC2LNQD/dyoBch31V1v3
TlDQoD+rw5odXfpjDFjLOsA3O3ea8Qw=
=y1Z6
-----END PGP SIGNATURE-----

--CXK8FdX5cD3efR4o--
