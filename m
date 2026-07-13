Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 146D040BCB7;
	Mon, 13 Jul 2026 14:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783951639; cv=none; b=nGwqCKJrTLTSSoo9c9w+oQ4FHYui3KlOJ4c+crhNsYY1jXZ1mz3itxDPJ63XttHRU8pA5OSlQRyLJJ+v+2v7Mt2thlDbV6eCoqgB0nfnf9lnn0YzKRPqsYGJT5I2jt1zO0CpDwjoC8MFc/TnJvNna+m4Q1I2A9WCeAy+N1I2dMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783951639; c=relaxed/simple;
	bh=KX7jC8YYyTIzcybXpdroPkC5yw4uOgo2UsRfOauMS3I=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=eFQZQrmNWsFofx/kncMW1+OT6K6K4biZi98oMIVINzfBTEdgI1Ay76UP9wxRo7YNgYnoxozGi9QbTlwWiVuBTgbzJjdxTZptVOSiKBHOPlHWoukAq56UPKkcqHnB4l1ewi4yqUhvcWAdtFYNoALcOAOWvv+dnOrOHZvcpDWYw0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNbzsJhL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNbzsJhL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD44E1F000E9;
	Mon, 13 Jul 2026 14:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783951637;
	bh=Za+mIcU3zoOy8RAhRkEJTV0m6X6NWx6a/AgG7KlW8xw=;
	h=Date:From:To:Cc:Subject;
	b=gNbzsJhL7JKyLu3awIczG6UANa41jnZVuQptpyJxnpa3bakx1N9OywZk0fsz6BeqD
	 GXOFTx0C2xXWK46lziSNP9Fw99SBShq2YV91LEEB2OZpIEfdPzIry/NjSO/Z35WKpq
	 qMjAWwOrqMwqJ5vlFXBfnqUgW5gkB665XBb8jHTgtE2RHdQJgzkp2fqGHs3FPKOXzr
	 MVWCUQZl/2FFnaKmogT7L19l4qrJZ4a7Y9XQGTJDmGprLppsKCsm06hOHAxBKGfQlo
	 aLWoJbfLUA2wGQxYHLf6BWC8I113fT0W+GInnkA95x4VUjqktZ2BtSzWlocbuXzIKP
	 lJWsPP3cxxNdw==
Date: Mon, 13 Jul 2026 15:07:14 +0100
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto List <linux-crypto@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Fixes tags need work in the crypto-current tree
Message-ID: <alTxEhX22KMVjDDQ@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5HsMwQmJODDfMBE0"
Content-Disposition: inline


--5HsMwQmJODDfMBE0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

In commit

  196b052cbc5bb ("rhashtable: clear stale iter->p on table restart")

Fixes tag

  Fixes: 5d240a8936f6 ("rhashtable: improve rhashtable_walk stability when

has these problem(s):

  - Subject has leading but no trailing parentheses
  - Subject has leading but no trailing quotes

--5HsMwQmJODDfMBE0
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmpU8REACgkQJNaLcl1U
h9AO0wf/dDCx4Bcro1/QJuy0EouAjUadHTx9of+tJ9cl3ZL9D5WK/a4qqkl05r1e
RHeVhR51Ia1eGYS5RD7EkKe4w8hhXDZA4paIvhKwd1kkQIRjcKiv3T4rUHDFdceb
izgz34an13NFlN6zcQhg/jw6Qn+V3Hh00EdAVK593eC5ZwzQl1HMAmdKsCXNpnJg
xZQNthRJ2Kh9ZIP7FTtIaKVje/DzPau94SEd1PxLEPaGPGPKUbP0L0upD/SYd4Zq
GYsidNok6avWNhag9Y/0lHvRX4SlhMWk3Ggohc5vTCHWiRK4Rql0tAEZcyOtmUG1
TcKurKEI1/dcNA7MElBpaj5eeq6jSw==
=Y2Rg
-----END PGP SIGNATURE-----

--5HsMwQmJODDfMBE0--
