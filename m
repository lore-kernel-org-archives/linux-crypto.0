Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC7A273800;
	Tue, 14 Oct 2025 14:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760452494; cv=none; b=aDK8gcJ7uRxI8nCiLghhcBx9nm3m1UWdDPFRB5H/g0GWQ2Q09K8ALZ2yz54oKVsaW11QSOk3CQYcc2XU+JYlvPis4N7/YcZVdasejR9duoVBQch0DWe/LyZEPUziuwB/Hvm9J/qF/TPMfhbqwEpDliFY9TFNcU+dVET51pCb1nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760452494; c=relaxed/simple;
	bh=/lwe4bBNGbmwOLj/aSyvSOfhYpsQSpCFu1iB10dYJ5M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RTSX376iuKSCFKo3AjfTtePpN7nLuQJ2J4zR+16UM2cqKL5qq1OfseUZgpUmNKesAYokyEQFrZNJnX2Lh54rYpN1TKXOkrOo4/xEPtSGINC2W4WE2IqdUktwsKXQhXhchdSyHyr8Ro+JZY6S/FGM1EPVZcmb3gCwlB8pCGoJZsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jZbMVIs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jZbMVIs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11803C4CEE7;
	Tue, 14 Oct 2025 14:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760452493;
	bh=/lwe4bBNGbmwOLj/aSyvSOfhYpsQSpCFu1iB10dYJ5M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jZbMVIs/IksDzior41uQK2lxjETy9hEn0Gk3zH9KaijQ77s67yqdhCQbyGHbfATTj
	 vA1p4I7opvaEfjIawS+/1fqltHOAXKaTuo7rh/gWcXITQn1arxpRnoUkEtj48XOqux
	 lt4GZaB+3ocBZ1Ana9y1vrz5R1dq1O3wjT8nrpPnNJXegsIL5YLzjaFHgo7Xf49Vg1
	 Y8NH5Ad2Aj71NJswQVcdOHNjTzicapwyoNE7OFpPm+RryOzytR6DI33WyzdyWeeedu
	 lhN3agIVA8vihVjwfVy5VhWdJjAHE8bHxVrJ5D4wFPkyYCz5VwLoMx7bnhXVsUUAqD
	 I3n7Oii7NWp+Q==
Date: Tue, 14 Oct 2025 15:34:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	linux@armlinux.org.uk, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v2 02/20] arm64/simd: Add scoped guard API for kernel
 mode SIMD
Message-ID: <efbfbfcd-7d95-4e43-9865-78c8d9a8fd50@sirena.org.uk>
References: <20251001210201.838686-22-ardb+git@google.com>
 <20251001210201.838686-24-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="02Yxb3u4Ew/O+JwJ"
Content-Disposition: inline
In-Reply-To: <20251001210201.838686-24-ardb+git@google.com>
X-Cookie: Go 'way!  You're bothering me!


--02Yxb3u4Ew/O+JwJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 01, 2025 at 11:02:04PM +0200, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
>=20
> Encapsulate kernel_neon_begin() and kernel_neon_end() using a 'ksimd'
> cleanup guard. This hides the prototype of those functions, allowing
> them to be changed for arm64 but not ARM, without breaking code that is
> shared between those architectures (RAID6, AEGIS-128)

Reviewed-by: Mark Brown <broonie@kernel.org>

--02Yxb3u4Ew/O+JwJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjuX4cACgkQJNaLcl1U
h9BAAwf8CA3K6Ur/Nh5fwGjvhkHn3b4xWxNa4Hm11X9JbQjcJn18J8OEm1EM8j/T
+4t11OSLoOJ82for53Qq7/V++GamQLPEL91L2BFiVFTVPDW2YGP5vKnkVQaYoBuH
p4YtTN5YMQat0Yc3+jI2SZBOmYcNLjyw3LY9iagySCaG8iRzNppaSvxOZosBP+mv
RHovVCbiY2xy18tBr/VWPtZqVL6G+ZosUvaOXild/UEx/CpWu1v5kbfPv+hNjUI1
qXwl4+5LDNxDR4f/Zg+AUzA0BiUczGzlCCo1ZV3RaFCZIBoWa1TS5K0Yf72cONHX
9lc+3Mor7fhw7eOfDdfjvZ+z7DGVVQ==
=GLyn
-----END PGP SIGNATURE-----

--02Yxb3u4Ew/O+JwJ--
