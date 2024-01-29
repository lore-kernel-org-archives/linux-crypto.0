Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7856154BF0;
	Mon, 29 Jan 2024 15:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706543371; cv=none; b=nD9XekQJKzXee6h2GKC+s73F+lamqBRaGl07ClQNdGgNVFZn6OW6FBKwF8f2okrPKiQCpqiokLlz/gNFpX+uzy59K/U4io5+ghjpJztw6PXDXqVbsQG8NNzBoPUxALs1hPfPNyK3yQiM1ch2qK5lMnc4BAZ87TDD+KKZxCuW4Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706543371; c=relaxed/simple;
	bh=e0ESeQsRk5SoTUCa6RZLB/A935snlZkD/TqcBFtYBfs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V8Me1dzPMBpTon86D59mb8XwSTTfhllcIpkhDPZu+X9hq30N17I7RhJsaCvIA79LWhiiWeYFQCsvIMkzAK7f7joXMNl2CmjVB3KWPAgQc6bWesARplhM5U6p1684oMRC9608WNgHa/zuy6xrIeil4SsuoVwDGBD+oi0M6NZWG+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=klRqlMJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="klRqlMJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4B4C433F1;
	Mon, 29 Jan 2024 15:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706543371;
	bh=e0ESeQsRk5SoTUCa6RZLB/A935snlZkD/TqcBFtYBfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=klRqlMJkd+WDOpLV4juXYlgk8v3HtObx4BTF0uw+i6uMJ2Ukbl/AnHkgvlzC3Fbeh
	 6/k0AZzH8diBnwhlxKgNtvAV1pnyzv4YX5C8n2D8jRsHUGxqz7zRFU0SuVB3wnLab9
	 IFHbOYbi4/huqwPcpPd4nWnzstOvOF0xQQnUjlNgiLC8Q+qxfpU59I8TnfR3mIHCz/
	 pNpoXRsCLig/7qtUkzPbEMZkSD6AWncpltomFPmywI3UZeEQzN6/7AK8D8wYxWoOiP
	 XEmSj7BUmVDzGjaXikIqMFY1lMv/0F6lECM2o63uF4fnm05hwo4nrnQJUzJVN91/hn
	 c3++kX5OZ/raQ==
Date: Mon, 29 Jan 2024 15:49:27 +0000
From: Conor Dooley <conor@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-riscv@lists.infradead.org, linux-crypto@vger.kernel.org,
	llvm@lists.linux.dev, Brandon Wu <brandon.wu@sifive.com>,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH] RISC-V: fix check for zvkb with tip-of-tree clang
Message-ID: <20240129-always-nurture-f5fe831b8bb2@spud>
References: <20240127090055.124336-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EL2F3hYGXg3SLtEB"
Content-Disposition: inline
In-Reply-To: <20240127090055.124336-1-ebiggers@kernel.org>


--EL2F3hYGXg3SLtEB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 27, 2024 at 01:00:54AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>=20
> LLVM commit 8e01042da9d3 ("[RISCV] Add missing dependency check for Zvkb
> (#79467)") broke the check used by the TOOLCHAIN_HAS_VECTOR_CRYPTO
> kconfig symbol because it made zvkb start depending on v or zve*.  Fix
> this by specifying both v and zvkb when checking for support for zvkb.

Seems like a reasonable change on the part of LLVM.
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Cheers,
Conor.

>=20
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  arch/riscv/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
> index b49016bb5077b..912fff31492b9 100644
> --- a/arch/riscv/Kconfig
> +++ b/arch/riscv/Kconfig
> @@ -581,21 +581,21 @@ config TOOLCHAIN_HAS_ZBB
>  	default y
>  	depends on !64BIT || $(cc-option,-mabi=3Dlp64 -march=3Drv64ima_zbb)
>  	depends on !32BIT || $(cc-option,-mabi=3Dilp32 -march=3Drv32ima_zbb)
>  	depends on LLD_VERSION >=3D 150000 || LD_VERSION >=3D 23900
>  	depends on AS_HAS_OPTION_ARCH
> =20
>  # This symbol indicates that the toolchain supports all v1.0 vector cryp=
to
>  # extensions, including Zvk*, Zvbb, and Zvbc.  LLVM added all of these a=
t once.
>  # binutils added all except Zvkb, then added Zvkb.  So we just check for=
 Zvkb.
>  config TOOLCHAIN_HAS_VECTOR_CRYPTO
> -	def_bool $(as-instr, .option arch$(comma) +zvkb)
> +	def_bool $(as-instr, .option arch$(comma) +v$(comma) +zvkb)
>  	depends on AS_HAS_OPTION_ARCH
> =20
>  config RISCV_ISA_ZBB
>  	bool "Zbb extension support for bit manipulation instructions"
>  	depends on TOOLCHAIN_HAS_ZBB
>  	depends on MMU
>  	depends on RISCV_ALTERNATIVE
>  	default y
>  	help
>  	   Adds support to dynamically detect the presence of the ZBB
>=20
> base-commit: cb4ede926134a65bc3bf90ed58dace8451d7e759
> --=20
> 2.43.0
>=20
>=20
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv

--EL2F3hYGXg3SLtEB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZbfJBwAKCRB4tDGHoIJi
0gPKAP4wBaV9cReJkJDl06WUVEYJxyYVr3Il1OGMyQgDVaCHKAD+L7LWWskK+HJW
fTp58Q6g61eD/wtV2oyASlZrEQ8f2g4=
=khU5
-----END PGP SIGNATURE-----

--EL2F3hYGXg3SLtEB--
