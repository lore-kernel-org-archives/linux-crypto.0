Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2785B5DE
	for <linux-crypto@vger.kernel.org>; Tue, 28 Nov 2023 17:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hsiw/925"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D643EC433C9;
	Tue, 28 Nov 2023 17:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701194094;
	bh=N3vZMmlwPmMLxmgsU8NU5aW8UlcCxY+iRKRi4fSgJas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Hsiw/925cVatmSVS2Mjf+lwGsahVcUe9gEJwVlcmNPn+zWbmwNZ2MPg9C24I1RYFq
	 skwNvzE0segMkYvoLC58hDXsNzhnsX3tfykvPEfkeBlgAQXPLVjPalu2EOmmIgvATQ
	 aoxfGaC2vUW1mpXBAFr/E2qRXkpGsa6WRLj3i45jI8GsHf/aJokHiMdpDsswRmp4Ah
	 DfMLen3NJkBkTvG87EMmW3JR0n8L0v4+iXgXwtJcN0VoeGH7M1OgsO9pWPe5lQyExH
	 iZTLYaSNqnPLlBpXSFPrzBksF+fRvVV8C9J7TpdYC6shFoTQk/+7WWgpHw8LPVNmEh
	 zdq2ORS22eNSg==
Date: Tue, 28 Nov 2023 17:54:49 +0000
From: Conor Dooley <conor@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: paul.walmsley@sifive.com, palmer@dabbelt.com, aou@eecs.berkeley.edu,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	conor.dooley@microchip.com, ebiggers@kernel.org, ardb@kernel.org,
	heiko@sntech.de, phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 04/13] RISC-V: crypto: add Zvkned accelerated AES
 implementation
Message-ID: <20231128-await-tipper-2094715466f2@spud>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-5-jerry.shih@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="c+Bx+5YDpVONEprp"
Content-Disposition: inline
In-Reply-To: <20231127070703.1697-5-jerry.shih@sifive.com>


--c+Bx+5YDpVONEprp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

> +static inline bool check_aes_ext(void)
> +{
> +	return riscv_isa_extension_available(NULL, ZVKNED) &&
> +	       riscv_vector_vlen() >= 128;
> +}

I'm not keen on this construct, where you are checking vlen greater than
128 and the presence of Zvkned without checking for the presence of V
itself. Can you use "has_vector()" in any places where you depend on the
presence of vector please?

Also, there are potentially a lot of places in this drivers where you
can replace "riscv_isa_extension_available()" with
"riscv_has_extension_likely()". The latter is optimised with
alternatives, so in places that are going to be evaluated frequently it
may be beneficial for you.

Cheers,
Conor.

--c+Bx+5YDpVONEprp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZWYpaQAKCRB4tDGHoIJi
0gizAQClyXLat6AoDqeEMU7fszIl0aqY562jWFVvkg9MjgR24gEAzNdLynP6jTGp
PoJqYxyEhhUhpsxklOCYQbwZPyDf8ws=
=ixTm
-----END PGP SIGNATURE-----

--c+Bx+5YDpVONEprp--
