Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B7D156F46
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 10:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717152648; cv=none; b=N8xqKjIiQ1K4A3rcgOROQrW6gariDxMdnvKWb0Ri0+Wjk1fD6ImL9cDO6iGzZuGKqL+YBdcO/IxceXfOJq1ZS8xF3mzl1fDHt+xaXO2JDuJQcsp/mcLgwj711ANjP+6PpXCcc8rfNwvj0/LVhgjqgF2YUbIZiCdvQ9Mowlfz26s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717152648; c=relaxed/simple;
	bh=IgNuUc7H+4H+wS/T7K15pYQS/lOBI7Syd2UuQzgQbNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SmBGjgs54yed2Jd4pTgA1glXKxs8gvepnUHeoKwjH8DsMVYOWnrWWex4OY+k2i69xbi4PDOnHJ8Q7K/iDt0/9bGIpwcKfdhOf2cpjTWPEe1x6J+mZTUOKommlHADR3AT4wjmpejMT8n395gpw+mYTfAQoc2S2T7ldNPhqnCheXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IaLcqEvx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IaLcqEvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EB1C116B1;
	Fri, 31 May 2024 10:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717152648;
	bh=IgNuUc7H+4H+wS/T7K15pYQS/lOBI7Syd2UuQzgQbNg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IaLcqEvxf3WPsbG2GeI4rF01P9sJapsh+waMRV+Bn5GVwzGlT4iKmwQqs6EEovMXO
	 bq5MHfHY6YFi1fR4X70+hsY69LAzUVWpDrh57DRzkJYj4jjsvmAOyPuwwp3KKMkAjn
	 UNJ1Sxz2GocpMQCwrvXq5T6CImk7oLDAiMvZnkyrdTjfuo93qfcnD1WxaylZTpZw6B
	 WNpypSu8SidR+hFaMIGQYj/Ax384ABc4lusdGy+QKdKxtiXO7/oEWY3nklJt1AUC5u
	 Ko6rwqc3pTr8n9ZBCL52sbLWtxUPyureJ7C/BmxytphV3nt4YdZisxhRC8WhplyUzE
	 DA5PC6T4geM0A==
Date: Fri, 31 May 2024 12:50:44 +0200
From: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <ukleinek@kernel.org>
To: Marek Vasut <marex@denx.de>
Cc: linux-crypto@vger.kernel.org, 
	Alexandre Torgue <alexandre.torgue@foss.st.com>, Gatien Chevallier <gatien.chevallier@foss.st.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
	Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>, 
	Yang Yingliang <yangyingliang@huawei.com>, kernel@dh-electronics.com, linux-arm-kernel@lists.infradead.org, 
	linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH] hwrng: stm32 - use sizeof(*priv) instead of
 sizeof(struct stm32_rng_private)
Message-ID: <n5fitoidzxrqqsjddfaza5z52hmjgjksytpqua726s7h56z63e@m4cygxcnafo3>
References: <20240531085749.42863-1-marex@denx.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xek54sdap76jwck5"
Content-Disposition: inline
In-Reply-To: <20240531085749.42863-1-marex@denx.de>


--xek54sdap76jwck5
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2024 at 10:57:34AM +0200, Marek Vasut wrote:
> Use sizeof(*priv) instead of sizeof(struct stm32_rng_private), the
> former makes renaming of struct stm32_rng_private easier if necessary,
> as it removes one site where such rename has to happen. No functional
> change.

IMHO the main upside is that it's easier to spot that the allocation
size is correct.

Acked-by: Uwe Kleine-K=F6nig <ukleinek@kernel.org>

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |

--xek54sdap76jwck5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEP4GsaTp6HlmJrf7Tj4D7WH0S/k4FAmZZq34ACgkQj4D7WH0S
/k7cTAgAlRRgppFhUD+9O+z0yqXTYZdPWzdDaF2Y/wCjo4vW+41rmwpPXPYjUj6V
RUSJ0g1eMaVwKaX53dbWlNYD3RTj8bv7uScBomwhTGUY8CUlIpEHkbY0xIrjCq2p
d36Rm/i3BzP0AvYV8EGgKLCys7f+u1br8Kl/ubGUx+E7P40C0V8D1biYD5kxvzYX
7U55QcKsKuAinDRk126iXM6d2f/aZGwO4Syh7NvNC6Q9czeSK2MAqU+dpQLScogl
UlNK+9iYjkadIlusVt19D2BDhpY8iG4hidRNL/sncLLA+M9i0oqZfCMvi01A4fEd
eRlktUFUxNYh6x/yhWMoVApAbqccRA==
=sZmB
-----END PGP SIGNATURE-----

--xek54sdap76jwck5--
