Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506D94CCDE0;
	Mon, 31 Aug 2026 16:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788193191; cv=none; b=YdgBUDonUJEQS51cdWhcAO9A57VBGqMaA7XNpnQjBfxi/F5RLHxUjkUuq0wOsuFhv2mzdzfFTYSiBTYdoPJH9BXiwPTXYFTm7b1uUrn4n3ilGHZDq9OR0ipA8Boz7RBYv5ld+4YuOTgIYNKzzrVG45WZZpPHpen8gjgIrBuzLf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788193191; c=relaxed/simple;
	bh=vZKWq0mMMGFiL2ra1uyi9+EXSoTSOjxTyuVR5F9+hBQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iTAQvIGHTlxW9bt/1y+saQk+XZjpx1xxWulPiUWt8WgXKeYSpept9RmyIdQ+75Oaz3XDzi4LY4fJ6r/t2t+Q2SpUNvPCQz/MILHoiS2/xCCtcecwcIfY3eCLF175cMBmvUh6dfAoPizm46/VnrH6N4g3PGh6IaNXCXbaSarAiSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iZ60x8SC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iZ60x8SC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4F961F00A3D;
	Mon, 31 Aug 2026 16:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788193190;
	bh=vZKWq0mMMGFiL2ra1uyi9+EXSoTSOjxTyuVR5F9+hBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iZ60x8SCFc4ZXT6oYBS8PqfQ9ivIgeqYgqtDOKvsjCfc+r9Lhc9Rqrlkj0WAxOf3t
	 SkQzZmxmOukL2Kog/YOdtSL+rOVS8gLs7cPtBhLpVZURcqhopjf0l/4SetcvfKzBHs
	 5/jY2Hoeme9M4CBbXve+m+pfNwVAuSPPJGLwKxnxiUhH9w9ffevzfTRp05aJM+E4S7
	 RKxfBSYWdyGLqeH9UG5JlnYR0bwZO8dxuUSuJ89fyQO8vy3JvkDsO6VOnZa/n/6PwY
	 EE3q42Ff25AjUfb9ZOWcN3RIXTGUbqdTbbORwl6efU7Jk740X+BgeVyVkt/6PV2No4
	 oid6FK4dqZjgw==
Date: Mon, 31 Aug 2026 17:19:43 +0100
From: Conor Dooley <conor@kernel.org>
To: Thorsten Blum <blum@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Wensheng Wang <wenswang@yeah.net>, Frank Li <Frank.Li@nxp.com>,
	Cosmo Chou <chou.cosmo@gmail.com>, Colin Huang <u8813345@gmail.com>,
	Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
	Antoni Pokusinski <apokusinski01@gmail.com>,
	Eddie James <eajames@linux.ibm.com>,
	Dixit Parmar <dixitparmar19@gmail.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Conor Dooley <conor.dooley@microchip.com>
Subject: Re: [PATCH 1/2] dt-bindings: trivial-devices: add atmel,atecc608a
Message-ID: <20260831-irritably-bacteria-e3ddad58fd80@spud>
References: <20260830220151.21469-3-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="q3W50SDhGFq7JrQI"
Content-Disposition: inline
In-Reply-To: <20260830220151.21469-3-blum@kernel.org>

--q3W50SDhGFq7JrQI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Acked-by: Conor Dooley <conor.dooley@microchip.com>
pw-bot: not-applicable

--q3W50SDhGFq7JrQI
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCapWpnwAKCRB4tDGHoIJi
0rEXAP9DZvI/dLIfzFA2O0skyTySC0B+tR9xSHtmn7eTU6WSLwD9G4Gk0SC09K3X
p09sVB7IFk91pO5QeKi3CUK3hik74wU=
=DzDP
-----END PGP SIGNATURE-----

--q3W50SDhGFq7JrQI--
