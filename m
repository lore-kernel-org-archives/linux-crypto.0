Received: from mail.zeus03.de (zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38A02DA765
	for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 08:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783843780; cv=none; b=FcF+utGOyPPtTM14WxtfaHtLrRub7jzfA6fJ5wzpOu3qb8ppQwN9zH9Mlw/PsDctKEp8ROOhQdLOyDT4EPNA5guUHhuo/JT/ZV+1daOFSnAfwwNjuzwm5Hy3ZhXWcpBVeN+DoomWcKDQTX26OdcIV26BRs/GY9G1q7+shi05BjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783843780; c=relaxed/simple;
	bh=1/h0853WPj4v9Xa/Ikld7lLSrbwCPyDbQ05j6cpCsgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ngR7PSeLAVVy7V2zVit5UWBH8AOyhnXOEwHsTqwoQdfBbAXsLrBODsyoA6k6zvCJ67ALq3CbXs6UUYegT80s2hMAc2S7b4PLmYDbsH9IsNYJ5OFZsro3M/TMthKpaU+1AKfUqehNVhxbW9NW2Eg14fPd0WjpXkgy+DRciNH2TiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=IzlypMh7; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="IzlypMh7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=date:from:to:cc:subject:message-id
	:references:mime-version:content-type:in-reply-to; s=k1; bh=1/h0
	853WPj4v9Xa/Ikld7lLSrbwCPyDbQ05j6cpCsgw=; b=IzlypMh74eMkR4Km+/Uh
	ZQQTQQ2T3/qN9/HYVBuOvqjMCWKBeF8EjVpcm/bklPxGCHMFAgsuMGOoS316bx3b
	8YkvMtOAO1pFQLp4TAr0JTceM1LAYgwnvyhvEre0T0S6wllJ2D0dnRGMNPWDT4HZ
	L8tc1JXRy84uWooUcQ+kN1P++5COS66V7dcurNSxRWm11uwmwMHXXkpYhLr7O96y
	C641b5DYX3ozd0nfCpA72EUmOlbpxCL46oo2x/wORP2sz9P8/f8PRfaSNHBcKbvX
	mPIO56oix1xmhlMZnHBbG4jlTG0vMxa/acU07p54f1neMtgO6dnt5HR6IheYlE2e
	4A==
Received: (qmail 2158249 invoked from network); 12 Jul 2026 10:09:33 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 12 Jul 2026 10:09:33 +0200
X-UD-Smtp-Session: l3s3148p1@RTtpfmVWxuAujnun
Date: Sun, 12 Jul 2026 10:09:32 +0200
From: Wolfram Sang <wsa+renesas@sang-engineering.com>
To: "Miquel Raynal (Schneider Electric)" <miquel.raynal@bootlin.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Pascal EBERHARD <pascal.eberhard@se.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: rng: Rename the title of the EIP-76
 file
Message-ID: <alNLvB5okFx5A9RE@shikoro>
References: <20260710-schneider-v7-2-rc1-eip76-upstream-v2-0-4eab557b0e70@bootlin.com>
 <20260710-schneider-v7-2-rc1-eip76-upstream-v2-1-4eab557b0e70@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+IS7JJhj9ssZMeKS"
Content-Disposition: inline
In-Reply-To: <20260710-schneider-v7-2-rc1-eip76-upstream-v2-1-4eab557b0e70@bootlin.com>


--+IS7JJhj9ssZMeKS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2026 at 08:20:32PM +0200, Miquel Raynal (Schneider Electric=
) wrote:
> Be a little more precise in the title by giving the family name and the
> own name of the hardware block. Despite the original compatibles, this
> file describes a SafeXcel EIP-76 hardware random number generator.
>=20
> Signed-off-by: Miquel Raynal (Schneider Electric) <miquel.raynal@bootlin.=
com>
> Acked-by: Rob Herring (Arm) <robh@kernel.org>

Yes, more precise.

Acked-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--+IS7JJhj9ssZMeKS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmpTS7gACgkQFA3kzBSg
KbYt6BAAqn+qMy4odzL4PISBY3K00+ej1VaTYy69lS7Ui3DwjZIs1SFdS/FwQLP1
scGz9UDtDFTyvqEr4ljSTvnIch7UxOSXRj/Ty1OWaU7Sw/eYUlKyA3YJA9Xci7ZM
e8O08cM/lT6iHwnepl6cDSK/NaYaSe2PCLq14hqCuB31HcOaEtmP7I2knzup3nOL
tD2Ek0y1t1Tf14QVeDMSD4eFZemf5CiULoCiopBCLzhWJ/xFUQjAuVtS5fH4546w
WdnccljZis0lAxD1Rz3aGeAng/Lwe9ebNM7P8xjm3HFUBctJcdcrczuxpfKgEmkt
cf/HT/Vrr/5DdJx/UnmeUj9Jcsjxb+Uj9B3vz7B2uUv18IvySpEXmMs+ATbknqFP
ck/i4X0VeDuu9Z3jOLx96LlcFFfXA/xlResoJHDzJRxW1dkOqZ3mco+EGPwWlQdD
ZpVe2NfaV8ZSAsNZw747KkA5V2LnRrNYRMI0RC6mkypQT/OF6f4WmbhFQ4PiS+Df
sDOFX/RxGDN5lWU01qGDpqeupY2n2NGMevJsQKRI+WhPN21Jw02h+EbwSZlIkU9o
6wkM5TuWVZHOLkUVqfiCxNEi6hyqy/znXfCJQKLIROGj/aYnsstNqP8qtKP6prCX
9ETiIcqUMc3ytNwB7FAoNFY/W3IAfNyI3TDxoIkaYXrTwKmlVQI=
=sMt2
-----END PGP SIGNATURE-----

--+IS7JJhj9ssZMeKS--
