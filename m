Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247C347A73;
	Mon, 21 Oct 2024 16:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729529432; cv=none; b=LoucU66qZeyO3Ogjl70Q0us7P1vFg3HxKpiJJnU95fR23dJcgOvHfrgIUqX9f+dCcraZk5WGTlgBfN5lD/tkJRtIK5R/Q8w2fdQZX3o/6qR/NG0K0VGCjse73LfVSlTNO6PveLfh8w4QMJTMvpPNumWcc9m47cJ+mcgdd95w6ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729529432; c=relaxed/simple;
	bh=bkVG9qLYw3ABhfdAM9/KxI+HYYRzwNI98LvRSY++XDE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B7u/c6TmKYyJQ8JYKsNXSTKLQpwyRwoN7lZ5+KKUvtR616a94j6NT/rCX71SXtafY2H9ESQg4Jx8unGiDwHayok9FZ94jinAUr4Po/8xciVs+WYRNUjVafWZQ/+IdwWHx+a0bafWo+Y5Vn4cfIaXAQsJBl26XSEjqMLgj6S/ofA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+0aSFQd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+0aSFQd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CCAC4CECD;
	Mon, 21 Oct 2024 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729529432;
	bh=bkVG9qLYw3ABhfdAM9/KxI+HYYRzwNI98LvRSY++XDE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C+0aSFQdIXH0WMVIeTlFBk9DgdNd1w/BUXl1Nk8Ghl6/zvsBbTDMCuPXlE7U5UC8V
	 D+f5omY3VEe3Ftsw1UoQ+a2Wl9tbvBb9m2frsxk5X/sVyn+45gQLMYgHVHlBd46dtP
	 HJRBpiPKxHn9bYmC4cb0H8pFF5VBFtQJiWym06ROO5VX+ufHr2No/47zz1k3Fma+SQ
	 17CzvIPUVY5zcOx8DoubLsjyKXEaUaC18UaWDJyOC0ApzDCjW5XQoHnt5S9qkK+1AE
	 xtqLzNufvwkEt3iNfO6TPT4PtMCFy31ULFEFZ4Pol+FDsbimbwpZF09MjMbtA/U0iG
	 kohBCYG/Bjinw==
Date: Mon, 21 Oct 2024 17:50:25 +0100
From: Conor Dooley <conor@kernel.org>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Richard van Schagen <vschagen@icloud.com>,
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [RFC PATCH v3 2/3] dt-bindings: crypto: Add Inside Secure
 SafeXcel EIP-93 crypto engine
Message-ID: <20241021-extenuate-glue-fa98a4c7f695@spud>
References: <20241021145642.16368-1-ansuelsmth@gmail.com>
 <20241021145642.16368-2-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="XnYX0dOYK3nMEEbA"
Content-Disposition: inline
In-Reply-To: <20241021145642.16368-2-ansuelsmth@gmail.com>


--XnYX0dOYK3nMEEbA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 21, 2024 at 04:56:38PM +0200, Christian Marangi wrote:
> Add bindings for the Inside Secure SafeXcel EIP-93 crypto engine.
>=20
> The IP is present on Airoha SoC and on various Mediatek devices and
> other SoC under different names like mtk-eip93 or PKTE.
>=20
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> Changes v3:
> - Add SoC compatible with generic one
> Changes v2:
> - Change to better compatible
> - Add description for EIP93 models

RFC v3, but I don't see any comments explaining what you're seeking
comments on.

--XnYX0dOYK3nMEEbA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZxaGUQAKCRB4tDGHoIJi
0hncAQDhWH3eBSBaL0KJABO5zc3ZCf9xeXA9yXleXdSOPqMFYQEAugCZgQ99Anky
RCGazzpmE1QglGc+IiLDgYdvaQcoowo=
=Ee6T
-----END PGP SIGNATURE-----

--XnYX0dOYK3nMEEbA--
