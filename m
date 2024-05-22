Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A314F8249F;
	Wed, 22 May 2024 11:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716376667; cv=none; b=RnWCP5+sD+6g1a1bq/K8RpjaHzXwwvHYgaLIuwFy4D8J/17uB1wuYn3BYmXAJPJtiusSpuysjlEUST1a9ORHLsS86YGQyNcaLivWHbyeT+I7F3Z51OEYyT+n7a3r7U7W87eXPLR77ZckBAhIyw7lhZFjXYfE1Ydrbdvz9NzSpwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716376667; c=relaxed/simple;
	bh=qZiV++8wFsZaZn9+O5eSl13hHafRZyCKoGIEOJQTM0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AY4yGSTBcR2PusYU7v01RcVHOmAzIRxsgxcYJ/56q6BI+z5OI8H1R2dItw1LRYBJclllV6KtP8dQEvktXx8daRtA3vg/0OqEH6LqYk+OzB/gB3ox7b4PmFIQiWZ8dNIXhG1Iq+Zk+hOuNbC59Ny7lWUNigusP53Ax3hv2AoF3+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=px2RWFZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="px2RWFZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351D8C32781;
	Wed, 22 May 2024 11:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716376666;
	bh=qZiV++8wFsZaZn9+O5eSl13hHafRZyCKoGIEOJQTM0k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=px2RWFZkTWNtFHYrYkm5f1CdFTudaTF36hBSxdYsSkrRw2TETNyYgPQ/PvkEmqHpC
	 Xqyx5ZNKNBp13TlMMhdnC7PGESeqVfDSbjqp091Z5KPYZA8B6MQSL87t/KhIVDwaZ/
	 EwLKrn7WtK0w3CsSAsWpcPOrEqOCrWIOO5FZzKgQBBDGoT8vVEi2+og7kKa8GhLoOe
	 JsuiZ1TcbaQNfoUWEoD4tL1DXaJFnWswX0S4BwSrni8cdxqrHAB8X4HidZIVrGbWR7
	 LzvDx8ioaaGEgXJU8DOquQTiROZF2DmIyryLhJwMhOGzBZ/FXvoE0CyBl98CAIA32t
	 XGcwALbTJsXNg==
Date: Wed, 22 May 2024 12:17:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64/crypto: Raise priority of NEON crct10dif
 implementation
Message-ID: <e103fabb-6854-4ce1-b4f9-6f6b7f912895@sirena.org.uk>
References: <20240521-arm64-crct10dif-neon-prio-v1-1-e2975754b8f3@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZrKxlTL1TQtyMzxA"
Content-Disposition: inline
In-Reply-To: <20240521-arm64-crct10dif-neon-prio-v1-1-e2975754b8f3@kernel.org>
X-Cookie: Bridge ahead.  Pay troll.


--ZrKxlTL1TQtyMzxA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 21, 2024 at 09:22:49PM +0100, Mark Brown wrote:
> The NEON implementation of crctd10dif is registered with a priority of 100
> which is identical to that used by the generic C implementation. Raise the
> priority to 150, half way between the PMULL based implementation and the
> NEON one, so that it will be preferred over the generic implementation.

That second NEON should be PMULL, sorry.

--ZrKxlTL1TQtyMzxA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZN1FQACgkQJNaLcl1U
h9DoDwf9E9YZQMeL1x5cA1ghTaD8CabmKoN0Uenl7iBJdvZt+g9BMuQ5/KD3T7OZ
E+kyQEeEFmJB2akufGOfZYGlLoAvT1hO3ZJiF7dO3zHtpAtEvyiboHMR6QZSyoO+
WJb+XYwhBjhkRWEMQTz/oJbSKPWHVc3oxTQbOgPUjEv5UdoSnpgsaRJp3GA4F/Pe
BZRIrRZFfFnRPtNR5HCaPZdLn8LPFsAmJ8SSyc7UTDdOzAGbTen1d9Rdv2j3oAKA
PkJ/opjZr47CiOiTFJhcBK+QwGAiI7O0HnV5yVXvzrAFwGSKYdpO10k5Eag3E2km
3nB/NMv/jYBjFoAJ94pEzYwo7LfBZw==
=jRxo
-----END PGP SIGNATURE-----

--ZrKxlTL1TQtyMzxA--
