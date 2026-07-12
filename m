Received: from mail.zeus03.de (zeus03.de [194.117.254.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5EC1372EC6
	for <linux-crypto@vger.kernel.org>; Sun, 12 Jul 2026 08:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.117.254.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783844015; cv=none; b=qhPI/qkkpYIYtW3cm5/mAMf/W/9FSaa9eOBJ5YP4nLvgBu/z81akV8cuTwVJ+3TKtAfNdBBwVz3h/DTlTyLuCDDp2k5SSI7IlwGgWt62zPm9c8bDVJboqxW7KnPJMphuHVtHFIpFqCZF5Zmxj1GU9HR0d0wQCwnCEgpsdCe0O60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783844015; c=relaxed/simple;
	bh=HJd/iyE1L08rvgqBeJSEVBvoYo+Y5iwJ7CrdeDu+mQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MDpHn9GSdtfV9gExhCIKeaBYOQb6/NvZl6ZWt9JiUQ0hcdxf7NJ/m1KFWe04OYkOTlmQQ2jHx9BO5xDdLy70B4EUyeT0d6qflqZWf2nx4bVcQrmcwxNd7/ak2xEmRN16gCWIBcy9kwyQ42Q+bzmv+XUVv8ZIC3IwkojApwWjp+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com; spf=pass smtp.mailfrom=sang-engineering.com; dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b=mearCb4N; arc=none smtp.client-ip=194.117.254.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sang-engineering.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sang-engineering.com header.i=@sang-engineering.com header.b="mearCb4N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	sang-engineering.com; h=date:from:to:cc:subject:message-id
	:references:mime-version:content-type:in-reply-to; s=k1; bh=HJd/
	iyE1L08rvgqBeJSEVBvoYo+Y5iwJ7CrdeDu+mQo=; b=mearCb4NG7+DUb1Zp5EZ
	BcesaZp9IZ/wDmjuxZ3Ev9hA//yR3u10f4qYzQmU3ld2nq04ir41T70vHjyOAtGz
	1sQhB/3XDWji9QSg5SebEt1ESkcSfcOckQ2sqGwZujSN3Mfwe8C8j0HzgqQLJokY
	kPk0awVwGeu1iH3kxE18+nuNG6uIoXPa+X7HGPdkjKY+fhM+zp2gp9x43yEI6aTQ
	k1COp5N71ws16cQ4URCiOgecUIZmGEHf8IUhujtAN4CESReXkYpb5Zir8l+H/SZi
	IUtFAtCxeRhq+FVT9UBVJGMJYDNJnW6jN5dOb4pM3tl3RR5ZUpDu4JDFz7g79PKB
	uQ==
Received: (qmail 2159428 invoked from network); 12 Jul 2026 10:13:30 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 12 Jul 2026 10:13:30 +0200
X-UD-Smtp-Session: l3s3148p1@x+eQjGVW6Lsujnun
Date: Sun, 12 Jul 2026 10:13:30 +0200
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
Subject: Re: [PATCH v2 2/2] hwrng: omap: Enable on Renesas RZ/N1D
Message-ID: <alNMqvOy5DEz_4nf@shikoro>
References: <20260710-schneider-v7-2-rc1-eip76-upstream-v2-0-4eab557b0e70@bootlin.com>
 <20260710-schneider-v7-2-rc1-eip76-upstream-v2-2-4eab557b0e70@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HvtI8ZeixoIEYXu9"
Content-Disposition: inline
In-Reply-To: <20260710-schneider-v7-2-rc1-eip76-upstream-v2-2-4eab557b0e70@bootlin.com>


--HvtI8ZeixoIEYXu9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2026 at 08:20:33PM +0200, Miquel Raynal (Schneider Electric=
) wrote:
> The Kconfig symbol and associated seem to be badly named as they have
> nothing OMAP specific but instead refer to Inside Secure Safexcel
> devices which have been used in many SoCs from different
> manufacturers (like OMAP, Marvell but also eg. Renesas).
>=20
> The Renesas RZ/N1D features this IP, so add this architecture to the
> dependency allow list. In practice this dependency list does not seem
> very relevant and could be entirely dropped, given the fact that this IP
> has been implemented by many different vendors and seems to be
> architecture agnostic.

I thought the same. But I am also fine with adding one more:

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--HvtI8ZeixoIEYXu9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmpTTKoACgkQFA3kzBSg
KbaTMw//cwOJonuD2ZlfeuRusk00ZjdhM/N/aDKZxt/JTatIS4kWvQDwZwQSzdMD
h+HJstrlCW8MseQ4k12KJOpqs2H7Qd7wVvaNUTDJnSIeb6JqiRobqq59HItwTfp7
6EP7JuDtX8VCXaUf+WdNg90zpGn4BQ6IshiuWJJuuVceHNlnTbVywMl90CjX2VVl
IQiyuSEOuV5K37bvSmldtnfdqikin6k5tl+adi6dtWXsw/MkIwE5DwSBs6b6vahW
2ydth49rXR1qPY+TuMFfSs10aHl5Jm8AfADZNv6RMrTyJ/wi5K5EBRrYYP5imfV1
oMnFGmWwxIqjRZpKvvdhX7OvFLmZc+zvw3fdSKF2sq06Iv2Udaa+VuFw/CsqJu4/
YZ4l8t7vgrUBTBk6Tc6wESKIzygKSCdCrorA41KwFYI05Borcm0IOhSHaF+/fehB
RSD/tzH9X3h/4O/GnjVFK91gt/7AjOMzJV3nbi8UmqjBDIt3G7UVTqF+rL5MGbfB
jUkfr/6pUiayDJ3YBxaylc1ac2kgMJs8xuGnhsqduOi/T5PBble9uQa81W8jFynK
agWs3QC80bvpJVzmsJf7wUUrqKD28DTSNvitwA44g5G0ICdE7iVdiSMXze/OskwD
tyn8VNwLNoa82ooQPfegiCUHo+cSA1MA6aOL//Tk1uJh1iaYN54=
=0RyS
-----END PGP SIGNATURE-----

--HvtI8ZeixoIEYXu9--
