Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BAC19993E;
	Thu, 14 Nov 2024 20:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731614492; cv=none; b=EHbZGr9PEly6K7+jLbOdDEsVPwmveRJyGJsigY0eK440tDUJ9BJsqWWB6/6uoYmK2DpgBw/3w7AzEfWxIbR+5QETnjZC56CAa8dLAlRFq7ppJASjjvBMPmFpVTMw10MR2KBj8GeED9wwyD/kBJSwf5umlPzF1AA69LG8RcloBto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731614492; c=relaxed/simple;
	bh=VWz5sCQ5z+GdY4O5saurQxhltkqAWeh87WpSHdVQSB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FcDCRQu2hZwWp85k8iQFsnRWfFrnXtZu71fKy1KJt5Pg7Nhwq4iDR40zN4C2E3JuZEmo+U50/P1Q7OmsekulsvmeWJ/qgQL8iO/kgrxgUKyE9bCHnmWrW6XXTr+UrBsXOBlY5QpgVOzF/NqxLkCo90f/jyTj5szr608VwieoyTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I635dSjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I635dSjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E10DC4CECD;
	Thu, 14 Nov 2024 20:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731614492;
	bh=VWz5sCQ5z+GdY4O5saurQxhltkqAWeh87WpSHdVQSB0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I635dSjAnKKMVpTevwE3oP4UacKi1Yjjb2bBYkCes6s6ebjTGyqdcBF2BMyKn4BDh
	 RujBYwS6TiHSe2L+C+eqL1BFovRlIFtD5Qxai1Kt2P8RXHl8TLyuGB70dBHEiW4Iem
	 gGPDpWEg1F0rmNxojPbYL50vzvvDjmhNWWF5xSAEE530VKRLHVSIxSqhWMY4C8Ww71
	 ta9cKABHiUYmvMypAYfJbEm94wbUnd9p8fgvdhedLAVoIQ2f6Vo7uPb17YnrBjhxbo
	 oplQZQcY2KCbrxBwQevspMt84ivecQzWmJZD84hbtJK04HknEn+vWve1T+hM1RAgaX
	 5XXxd5davnOeQ==
Date: Thu, 14 Nov 2024 20:01:27 +0000
From: Conor Dooley <conor@kernel.org>
To: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Frank Li <Frank.Li@nxp.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dt-bindings: Unify "fsl,liodn" type definitions
Message-ID: <20241114-obligate-thinness-204e7edbac77@spud>
References: <20241113225614.1782862-1-robh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="LBgC8kDFmZGaqIfM"
Content-Disposition: inline
In-Reply-To: <20241113225614.1782862-1-robh@kernel.org>


--LBgC8kDFmZGaqIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2024 at 04:56:13PM -0600, Rob Herring (Arm) wrote:
> The type definition of "fsl,liodn" is defined as uint32 in
> crypto/fsl,sec-v4.0.yaml and uint32-array in soc/fsl/fsl,bman.yaml,
> soc/fsl/fsl,qman-portal.yaml, and soc/fsl/fsl,qman.yaml. Unify the type to
> be uint32-array and constraint the single entry cases.
>=20
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

--LBgC8kDFmZGaqIfM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZzZXFwAKCRB4tDGHoIJi
0kYGAP9Wme55iNVWUdF0JCfZsdd/dSXawb3Xp/9hcFkAFPL+1wD+JyfKr1/0r859
g2MAxCrI6eo9mzcsXHJ6NGT7mvH0DQs=
=7ofP
-----END PGP SIGNATURE-----

--LBgC8kDFmZGaqIfM--
