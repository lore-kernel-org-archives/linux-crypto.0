Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705257;
	b=pkUf0nUEqy0O+2vB4bW31DZckIDc6A1Yjm6CJQVLmwwoxlJxsg8YiNTyWYepy9fwhU+B
	 sQNc8LxKaLN80rs8HiINlIU4a+pmax9IhmdEmdF5PlpofHquzWs7NEv+3Swa5epV747G4
	 5pFXlmtHszuLBPbwT2yykbHJrvto8jObkV+b5/d302QfyAO7Z41EStkJno9zTPHVyfQp7
	 mvWxsfm0URV0yxEQ2pL+vyZsnRHogYoyjnTaow9OEmswHcMxYwVFcLgKIfDhkNAVXZDs9
	 9Oub6VdKAB5vFNJarAu/LiaOkfi5hiZIzXe8QyQbbqGs9dncTx2+N6nKrMQUf+m94uA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705257;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=szQYCmCboKQhYRz5PIZ4ziRWGdQ3ul94B2U28ottxVQ=;
	b=HMpgMT4+wLpU0pwwxWenuGSB+N56LgLW0s1jTCRbKXhVvoPqVxVztmHTIcxjCkSS/0lz
	 avaIaudv5PxDkEJIr6TuhvxbxA+y6N7da5uAqAhM7Nea+VEzXwTCdidQeKM4cyO4aTezo
	 /pGF8ISGCwKdBYBLuyL5HmHHZ/ay9Z7KjIOcNRakuPyRrSesaj4GCgoNKQkjthO03qqWb
	 3E/KOS2aFnY1x3v/X5AkVwSFu1sOyW7tjMeNsJOFQEYN5EtgJQJOvS3W7t2M1bF0mmTlI
	 hGUjV0lPgjKy4uh9wosezI+m5CMde6U3LIFOXsnvD6E4dPTQKKs9+w+xXy6dpdBvPMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e7vHMCXT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60225606A31E;
	Thu, 26 Nov 2026 15:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e7vHMCXT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E8291F000CF;
	Thu, 26 Nov 2026 15:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795705257;
	bh=szQYCmCboKQhYRz5PIZ4ziRWGdQ3ul94B2U28ottxVQ=;
	h=Date:From:To:Cc:Subject;
	b=e7vHMCXT1n2izuuYV7PVhPuyhrhPHivTqjA2PnuGEWAeKeKS7t8yW5PdKqt9m4O+7
	 zGDOnXYsN/x09qb6iB/a9C0wM2LN5GfI5oiElF62S+LNDeJjHHxubT2r1a83rAakmo
	 szyfJYSAkwtnyXBr/Ruy2EeSjvzp2VRbgf/Yn7NcsCW4t8Lag5A5udrv/QKZQhBAwq
	 BbDTwg8fueW7HE6fRcdC5qKYLRDQPyUkiFmGjVghyIKdZl+1hoPtvDlW6POEf7OHnW
	 IIGByVK6SV/GpwSiMqvgNVghvU4KJOhyPYyA2pJEDy6SfRPedXtEspPeYwcJLcXdvf
	 i3HUDWfWVIOLA==
Date: Thu, 26 Nov 2026 15:00:53 +0000
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto List <linux-crypto@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	soc@lists.linux.dev
Subject: linux-next: manual merge of the crypto tree with the arm-soc tree
Message-ID: <awhJpZy-x8Bcjy0W@sirena.org.uk>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="DA9yH44D276z56l2"
Content-Disposition: inline


--DA9yH44D276z56l2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the crypto tree got conflicts in:

  arch/arm/configs/am200epdkit_defconfig
  arch/arm/configs/spitz_defconfig

between commit:

  71a0ba7b39ad4 ("ARM: remove legacy pxa board files")

=66rom the arm-soc tree and commit:

  fd29be9b99251 ("crypto: arc4 - Remove obsolete crypto API support for ARC=
4")

=66rom the crypto tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

[Deleted the files]

--DA9yH44D276z56l2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmsISaQACgkQJNaLcl1U
h9C5wwf+O3eeP2CcirN4dxwXVhaEuICz2LDxY6YKO9ucNC4bpZCaWQBrBIGubcSq
R7JZYvNHajezXgGr815Gz8yryhBfDdcDsFxzyWbiSCCBeWd53o93gyH4DTkw2uHq
dQMV9AOGPn/E3sRr6JxWfLZTC3Qjm8bBLdDXSNJd2BRGd/VEF+RQ/lXkI1Hd2xPp
hcivEgtgcxcedJ8eWnSgnlEJq0P4Yafwt7zaKn8SbFK4vvTfoO3oNBKkfFiXyHWp
GPFWba25cNhfATyDaxkvsnAkGcAITXBqNuC4JYPhcCNOLcOGBMprv5Ao4/p+Z85n
bf0CqEJig8OaqYCWqw736L+RpnC3Sg==
=YFc8
-----END PGP SIGNATURE-----

--DA9yH44D276z56l2--
