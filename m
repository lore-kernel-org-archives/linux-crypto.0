Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282A0314A85;
	Fri, 19 Sep 2025 16:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758297817; cv=none; b=XhrR4qlVrn4RvkKxQT+1CTkNV0tgjc5a5KzHUiO2H6b5OtY8ts5HxAVvyNE1dltlhMiR8YTXuui1h/Vw+3W+BL/viGYO126Kl1Ma1e0r6eRt4+RvwT5Bie0QYOm0c7xOSDgnQh+9yjanj5p4QXo/v9tAfGt0g5KbsgxcZR0LEZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758297817; c=relaxed/simple;
	bh=nYGhvaswrglufTThE8Ko8tVUeDykuaH4CIml5aGwjWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I+b5brq0IC4GiSllLCodI/zkH42s6bX4uTkZ2/+IStXKQBTvyMwnu/97KZNHMqY1IdIUjsPptBICGZqJd7O2WuGqpitLJDq/w17h7gGnhbbOtkhwxxb1oKFZeK5qYJU0dliRtDMv2bCMxx4wSc999utWE2knSegpNjxNrn25b+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/Kaoaj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/Kaoaj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C56C4CEFB;
	Fri, 19 Sep 2025 16:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758297816;
	bh=nYGhvaswrglufTThE8Ko8tVUeDykuaH4CIml5aGwjWI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q/Kaoaj7/JaKRP8O4fGkgim34hTc1efzdwxNkmTCalIwsPZuERsCotfZ+M3jBvKNT
	 bbWN+hhksHJb4J/UVlIbv4m5g1hJ9He2nlbDGH95Dpe1VXUUIxCv4Oti+JaPplDxjj
	 uDfc316Y6XPmZn76OhSbG5D8kY4ZWbRARqSeuBGHQ2sUhxuHPUPA5uyO/HEccQ3wGJ
	 n/iyboyl45ZIy/5B4WgGDS1cmg/D7c1ypIu4/3kLuvPHAfTqbfzqrvmzSERu8jnF05
	 irTEb38K0lPnapiS1T0rsArdGUhpc2HdseH7SbRGPOY4aYPqUwBCLb6QFO1M4gKh07
	 fw5M8rTp9y+MQ==
Date: Fri, 19 Sep 2025 17:03:30 +0100
From: Mark Brown <broonie@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 3/5] crypto/arm64: sm4-ce-gcm - Avoid pointless yield of
 the NEON unit
Message-ID: <4eb3c865-75af-43e4-a760-46bbb7e34f9b@sirena.org.uk>
References: <20250918063539.2640512-7-ardb+git@google.com>
 <20250918063539.2640512-10-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="V1bFmzjAwqS0yQHR"
Content-Disposition: inline
In-Reply-To: <20250918063539.2640512-10-ardb+git@google.com>
X-Cookie: Don't read everything you believe.


--V1bFmzjAwqS0yQHR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2025 at 08:35:43AM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>=20
> Kernel mode NEON sections are now preemptible on arm64, and so there is
> no need to yield it when calling APIs that may sleep.
>=20
> Also, move the calls to kernel_neon_end() to the same scope as
> kernel_neon_begin(). This is needed for a subsequent change where a
> stack buffer is allocated transparently and passed to
> kernel_neon_begin().

Reviewed-by: Mark Brown <broonie@kernel.org>

--V1bFmzjAwqS0yQHR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjNftIACgkQJNaLcl1U
h9CYGgf/aqFUbV8ym698Sr7+ZwrCHLCSAI7rfHpPa0ePv1UBDBTHcd2TrMYdUHyw
nsXFJ8JNceHUvk2vT1wYR5Ao+7BxvKAXuC3qw1OR29DJUTLSkRJ9Y15I9Yk6DMH0
xHrfkGfjyZCpbt6vf7PxbactkGYlOrHlgYRM+53vT7dWecei47BcXWyGEQaDabEA
jJjJZ5qtCY/D1KWuYfbudHIwhgYfQHWR5L6AF5RSAph9SV4+UseqtW5xnZ6zJSOb
vU5VG9ojXUELVI7zXMLOTtZYhOcj8g2AHKyeDWwunjEho7MksVoCfNXMIUVUS6xk
s/1u+CKpHm5yMiN+kmk9YXq+xzw85A==
=KcOJ
-----END PGP SIGNATURE-----

--V1bFmzjAwqS0yQHR--
