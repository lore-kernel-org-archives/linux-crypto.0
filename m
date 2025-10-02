Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B2D1922FB;
	Thu,  2 Oct 2025 16:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759422214; cv=none; b=dXPVzCStN7d5I1Zg9jqIUOmVl6P3MfoqEd8li+Xb3r+OqtJx/g08x4PeFBgTikpFVX08AiQpwNq+MPfgVWYA0ed2EuzZY4e7PZhlCTuAxMFtc3plQPYTIgV6iN4b0zsNfsAAbBHWeVawDYLqU3mE1uMWvC3iyJGf4LBtimEXM7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759422214; c=relaxed/simple;
	bh=PmYyJOnUFog0AL2FCuG4NNJEsZpxpTJfKkWtHasPM2c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jpzg/A3zUVEEOEqC9ZEH78sISaymp3FwJtSxQyPoAWGs6k0cZISEOfqdXZrcywHfmBM73FWGYEbcqmU7hlRafyTlIswLYrdhKwiYNB9WDm97MF6zFrSaTV7ChdvjyqrA5C6oMPUUOMciqua55kJLaJJGiD7tVj1+o8oArHVYqiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hAiwO6pQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hAiwO6pQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6E49C4CEF4;
	Thu,  2 Oct 2025 16:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759422213;
	bh=PmYyJOnUFog0AL2FCuG4NNJEsZpxpTJfKkWtHasPM2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hAiwO6pQ72bAJ1RaRtddkhRyk/vpHK6scNS/SS9/YBZKmjoFI0L2R+wn8n3xQTj1w
	 6Fe6YiaqtqVAzmBgLfzcCoTSZnZ0j/SAeOqnpVUwn1ycavDACFyh3J1kOdmCYOnJi2
	 8kcw+S5ntsUVxVNypxwQ2xAEet8UWAdPE5xqcQo/JREnAQvY++nap8heu6pXJNI7fI
	 1jlQdpx4X1sqr19cHFqtSYRf67g3MGwjm3DlMaH2mR2VdbqsXhp9LDNw7jjtF0AAu9
	 IOMu/L2l7xR7fImaz6EfwTc/KeMHoPX8Z7wSbqV3AxXtTyloKwUciUrG47qqBZOeJP
	 20o9yMnAitcTg==
Date: Thu, 2 Oct 2025 17:23:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
	linux@armlinux.org.uk, Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2 01/20] arm64: Revert support for generic kernel mode
 FPU
Message-ID: <94214ee4-3eec-4151-a5a7-9d5e030fbca3@sirena.org.uk>
References: <20251001210201.838686-22-ardb+git@google.com>
 <20251001210201.838686-23-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nWWZ4oGleevaWtf9"
Content-Disposition: inline
In-Reply-To: <20251001210201.838686-23-ardb+git@google.com>
X-Cookie: idleness, n.:


--nWWZ4oGleevaWtf9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 01, 2025 at 11:02:03PM +0200, Ard Biesheuvel wrote:

> However, dropping that flag allows the compiler to use FPU and SIMD
> registers in other ways too, and for this reason, arm64 only permits
> doing so in strictly controlled contexts, i.e., isolated compilation
> units that get called from inside a kernel_neon_begin() and
> kernel_neon_end() pair.

> The users of the generic kernel mode FPU API lack such strict checks,
> and this may result in userland FP/SIMD state to get corrupted, given
> that touching FP/SIMD registers outside of a kernel_neon_begin/end pair
> does not fault, but silently operates on the userland state without
> preserving it.

Oh dear, that's nasty - I didn't see the patch when it was going in:

Reviewed-by: Mark Brown <broonie@kernel.org>

--nWWZ4oGleevaWtf9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjepv8ACgkQJNaLcl1U
h9AjmAf/SiFHTDNbN3rXmWdsvNAunPrL+9aRBs9j/mZfqVYq9uzKNhwIxj8s45I4
yWhSDWUvwP8YaauMEyjic7CObKYZqqDWU/EiN2nIXazkkxLJbHepxoOdtl570UeE
O9tTJ4GxAuFO0tAzCJZccVjlmBPw8mjZQFNnoisDLZtoPkeAHeX+luSpKrtRW485
i8koP3kVvjSSKEzKFAl5EzXO8rytkbgGoHCJEC5VCowgQjYMPfF2q/9pqkrtO6FZ
MzlGkKZpEAfFDanLklqtkCzVZVX1kWB9FLK9l7ivkr8Fm/zJcXtqJAJGcaW6ysAW
FeV20Z2gHM1Mv6ApBwu+USi75HVx+w==
=Z2EE
-----END PGP SIGNATURE-----

--nWWZ4oGleevaWtf9--
