Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB7076FB9;
	Thu, 22 Aug 2024 15:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724341420; cv=none; b=NpwmENTwTIOx0ksVrAvVO/RBjzli7iTL626aM9CRCIH7LBo4cVESlErDZ19iKbCdqzwRm59CVKvo1nDC4MaNgbPgeV7xLg98MbV/Rdmc5jec1P7IAXR1X0TnvoMtgoG+OV7XFvJUgnq6tjmUujc12SVDEHB/XwY2uJ84Wc3J+YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724341420; c=relaxed/simple;
	bh=QAENrNB7k/EGZOnXra0Px3DH9MHblScnhf7MbfgT3g8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZWgTTEjFEbPpsEXxcI1oOnJ17h1gI4ukrsXENNkbyvYRQ0UNJJiF02JFbpUUPMI+nfiD4yaV0MnDRZ/i9lxosp4bggD2Hnw3rhHHmJJ23BUdNQU2UbZFxhOYFaDFNUCC/4DY2ngDSImFIwyKXOf40vFIYRDDOCn9l1jZzYhk91E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cxbWdEEc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cxbWdEEc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D3D3C32782;
	Thu, 22 Aug 2024 15:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724341419;
	bh=QAENrNB7k/EGZOnXra0Px3DH9MHblScnhf7MbfgT3g8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cxbWdEEcN/mxIeJSMtf9zmuQyZkp7GKN0lpJLvn8tVLlH/lSXTy6PFUBizPvtIdZA
	 jPlbETVE9l7aJFFtHZSR+rk1usQXRvDINSCPnG7av9q31FLhATSO+/4ahSawVDLSLK
	 VPVKCRTmzJV4TPI4q5LjrHZx3V2C0KKOLpZXPzftKib3DVgsXVckyw7xsmfIdCO9QK
	 GPa6aJgJbABJXTbGoPzDso38qrKtDABWNqGsxMYA4OAQhcDZy9rR43WIWzBC0HuawP
	 6eHpBEqX86jivK8Xv6dsT8AyGWg63FbfyP1Vz8kZ2HEwSq2eiwPjWD/am+ZqxFolDz
	 F1YwQ5ds6DA9A==
Date: Thu, 22 Aug 2024 16:43:35 +0100
From: Conor Dooley <conor@kernel.org>
To: Frank Li <Frank.Li@nxp.com>
Cc: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
	Pankaj Gupta <pankaj.gupta@nxp.com>,
	Gaurav Jain <gaurav.jain@nxp.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
	"open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" <devicetree@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>, imx@lists.linux.dev
Subject: Re: [PATCH 1/1] dt-bindings: crypto: fsl,sec-v4.0: add second
 register space for rtic
Message-ID: <20240822-android-retiree-d0e0f9e55494@spud>
References: <20240821192135.578126-1-Frank.Li@nxp.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="/SBX+pNmwevHPmmq"
Content-Disposition: inline
In-Reply-To: <20240821192135.578126-1-Frank.Li@nxp.com>


--/SBX+pNmwevHPmmq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 21, 2024 at 03:20:48PM -0400, Frank Li wrote:
> Add two description for register space of rtic. There are two register
> space, one is for control and status, the other optional space is
> recoverable error indication register space.
>=20
> Fix below CHECK_DTBS error:
> arch/arm64/boot/dts/freescale/fsl-ls1012a-frdm.dtb: crypto@1700000: rtic@=
60000:reg: [[393216, 256], [396800, 24]] is too long
>         from schema $id: http://devicetree.org/schemas/crypto/fsl,sec-v4.=
0.yaml#
>=20
> Signed-off-by: Frank Li <Frank.Li@nxp.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

--/SBX+pNmwevHPmmq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZsdcpwAKCRB4tDGHoIJi
0uH0AQDLYQpXI217BsXs4RFEYT9LJSATdPlo8dmk2fDeniMmtgEAq7MXxoVcXBg9
ocWh6q4QrjHasrLNJo0zCqPvjVv1IgI=
=3EPs
-----END PGP SIGNATURE-----

--/SBX+pNmwevHPmmq--
