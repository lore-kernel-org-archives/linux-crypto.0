Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B9A2367DF;
	Fri, 19 Sep 2025 16:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758297718; cv=none; b=dz60/v8Xkl0RtGV20Luv94EL3iLlQPcSZjPQTAPapvVq5QdVL7UYw8A+0SJ7sHiNC7jgojw23yUG9OPVDP2h8snbasVM/XFtb941pCcRz/izldpZOooZw52GLwdfdhnPEdG1bUnwhN48qDUyf+xVdGT+UyXjKCz1TyTaM3LCCyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758297718; c=relaxed/simple;
	bh=w73svW2MCHh+dM/RM9nKKSF7/QBMrZkqdV86ek1OZ1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OHbBk4CAwIUgCO3qpXcMgoOTiJQF/HXfnXZvKv0PVnESeQZBUFPBJ0Hk7cG0y87ZMwNB6vHMR62aVqrupl+6oJIi0z+/2Ues6Ahvkbs5jUKppJYD630GuFAUt98aUybchJ3Fr/9xtynHIXf2x3p2cV6KwlVxwjps+Vik2JIfDtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjT0HZ/S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjT0HZ/S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF34C4CEF0;
	Fri, 19 Sep 2025 16:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758297718;
	bh=w73svW2MCHh+dM/RM9nKKSF7/QBMrZkqdV86ek1OZ1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HjT0HZ/Sgh6IGLK7OHg8G7bMNIvL2ZhONBPeN5WO9nb/JMqQ3yW5YoBL8npqRSTa7
	 2zh/8Ue7K4of89smCAsFGdJd9iHMDv69B5IqSY8lXsW6BdaZiWNy3xqC4m04C0tKII
	 rEWIqn/rrlJJLzh/q5AQNZnu8tE5kTld3+AzxfzZXZ500neHksVKQwAfo4YO/onXFL
	 ntr8Fblmm5vSeruLByepg7xnqBNoVBpHyQarVL2L3MWHsmM0yFzqz4Y/JXigzK568O
	 sQuBQipyQ7wl4+/opaPs8ts1azmufDJTMJ1+Gb64IDxZp4SOFAZ1dsLRipl5BzbzNf
	 9PDp0AmnKMu4A==
Date: Fri, 19 Sep 2025 17:01:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 1/5] crypto/arm64: aes-ce-ccm - Avoid pointless yield of
 the NEON unit
Message-ID: <cbd5247e-5c57-43cf-93a3-ec3a6631a509@sirena.org.uk>
References: <20250918063539.2640512-7-ardb+git@google.com>
 <20250918063539.2640512-8-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wKXztv/NdWB6IIby"
Content-Disposition: inline
In-Reply-To: <20250918063539.2640512-8-ardb+git@google.com>
X-Cookie: Don't read everything you believe.


--wKXztv/NdWB6IIby
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2025 at 08:35:41AM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>=20
> Kernel mode NEON sections are now preemptible on arm64, and so there is
> no need to yield it explicitly in order to prevent scheduling latency
> spikes.
>=20
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>

Reviewed-by: Mark Brown <broonie@kernel.org>

--wKXztv/NdWB6IIby
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjNfm8ACgkQJNaLcl1U
h9DIOwf/RW889nrpAPtx2QplJTo+RH/40Ch5TIVuvSF+yWtsPuoEyDbHp/5LDfNF
EBtMLQ08UICuOq7NVxKqcsBt/c5j9aBPwhovm1THuPXzIPd/KwXK5dNBWCaJlixh
W9OXRW2xR8DYu4O0MEE11AOzTySYPpwaVGav/YmoVoqRQuDituYaSg593ztQUpqd
8cCmTbf5+i4J41vFJ9PGokeGSDxTILTe4lW7Ix6Z+SMOhveQZfGL/kqnlefLjiW/
1VXsMleQf5/MDZ93Ueac9ia9WiOC6h0/TLz7t3Vh9KeUNqhvLmKRVcyxizLID5b7
eDscvtf2T5KlrfYEpeY/5uzv+gWnfA==
=o8Xv
-----END PGP SIGNATURE-----

--wKXztv/NdWB6IIby--
