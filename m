Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DE6244669;
	Fri, 19 Sep 2025 16:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758297787; cv=none; b=DwexOHZ4ZNpPPEEaf0gQRlOrm3+HNDm8HOBJr0v1TCE//Aae/2rzu9QrqrvqQ8x41AYPo+/G2o8gly96xi0mZrZvlwM2UDnLqQUwKYE6H02fkDqxJaMHyrfKn/p3Ep8FrOiwTPro3ZPMwHOnXvmsaNd9i1o6M1dL0eqQa/KcgJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758297787; c=relaxed/simple;
	bh=/JrXP+Er95XRyZ504JanEx3HoJ/rZisZt2Q5h92w2jU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sFQEEY+GZa6GHbVQqzOmGz5YVgf6JWhGu3/rtISsw1WmKxkoG2o0VpIp8Tp000qCGSrTOUzsJILo+92jEHnu3CPIHG98AZe7/6lznGE4KoNuusbm0tza+8jGAEWxWDO9fXvGTshYMd9gB5VfWYbyeJEGJFnmieECwvDeNowjlN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jjkTQ8Jt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jjkTQ8Jt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EA38C4CEF1;
	Fri, 19 Sep 2025 16:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758297787;
	bh=/JrXP+Er95XRyZ504JanEx3HoJ/rZisZt2Q5h92w2jU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jjkTQ8JtJs0Xyy+aQM3zsH1Awb/CfBlumwAxr7MEWVPJ4QY2thL1HmfKTtXMedq3W
	 cgisJV4p6tw7EE4XA7kooz5pcWhNawHYrfMfyGnlr52yPLeieHEMHpVCTqsbFdFzn8
	 kvMkdkeL6Hd28sXV6ptjv8ZS2oJXPfLlEvldKmmtCvUiD9cU7WyHzMLfEsKCOkHY+h
	 Jp3jqPhcyct4WE0nldynGAXaRFSMjaoDvSM0Hqx2d/JrToEcoiRoOORNFCUkfEYGSs
	 VstG1EbpRqJ7KmLOqpWo0DOdEuTXsLQTjU6mDnsYwT349Ic6rA3hUPqNKiFKCPQqKN
	 UjVrkXdwt4RHw==
Date: Fri, 19 Sep 2025 17:03:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	ebiggers@kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 2/5] crypto/arm64: sm4-ce-ccm - Avoid pointless yield of
 the NEON unit
Message-ID: <eaf4c342-5ba0-4f05-b641-937d24d2a352@sirena.org.uk>
References: <20250918063539.2640512-7-ardb+git@google.com>
 <20250918063539.2640512-9-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tbed4sQ6qHeiGdFl"
Content-Disposition: inline
In-Reply-To: <20250918063539.2640512-9-ardb+git@google.com>
X-Cookie: Don't read everything you believe.


--tbed4sQ6qHeiGdFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 18, 2025 at 08:35:42AM +0200, Ard Biesheuvel wrote:
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

--tbed4sQ6qHeiGdFl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjNfrMACgkQJNaLcl1U
h9Ceowf/Z3UzSwYIObGf9baV5ZQ75yhm3OUJTsQyFR2rSe2VG+cSKPV0rER22deq
v09d6cECoYrSVHh1sAGAtEBPbMUkyviQmHupfGBysyGunMcxJKiwh6Vf1HRXSesz
MXgnRuskEfvgWlBKcfJ3CL8PGe7oWxc/5OlC3E18Ld1RYB+i8p5yHc9z01FrF3om
d1R/e3Nwg9Y1hApSzMW+WGmoh7OrIbO+UcrnO6QsFDu9W4Xo4sCCs4ASGMcpen8W
c9CqyzYZqLpsLYVH0AjFs8f0Zi0GxAXSUsm9sZZRsY3F4aAMcLYm+GwcPa10EyPL
Dujr4lWrw8NpWMqmt0yoRMZZCOOmcA==
=qk93
-----END PGP SIGNATURE-----

--tbed4sQ6qHeiGdFl--
