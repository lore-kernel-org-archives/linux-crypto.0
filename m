Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793294088;
	b=MW8lRXU9xD5CLq0kEdDLuuqzMsR7uznyrup5p3Z2dSUJRE0eEF/Si6wYdrlMjlxHl+oS
	 qL3CpL3JzaA+WWwNF2ZI6pq9tP27//bbWtwMUAp+IwANnMWPTfTM/mR+I9YH6AIoJVA/Z
	 vhdo3f9ha/PACroCrsmldI3UqHOTBxOyrN/licnl1uBVd1vehYEqJCNuiSWQC/2YzXm1/
	 bgxjS2DbssAvPieiTCrrX4D1hLkSS4cG2YaA2oy+EC3K7WLdItXwm5KkDp+68RrV5DhTk
	 DuL1OX+qbg0VzvhOvlTEfLthGKCyVIx44npg3+LDEmFZ+0/zqnY0dG4QzN6OSXUf/qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793294088;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=bGajM36dGxksJPdvKCxb49tIEyGw6EPecPLG7cvRSrs=;
	b=PfOIU4Mm8tFjJu0h5P2981Bbu5CqWJwoHHFKHFwVY7kpiJgYUFBe0DmgIhhin8dsg8z1
	 bs7f8I/KPvEII+jHB0k2XUmK+Fv/fQxJfoVL7QAiIJ0wcqjFneFft41V/QSHqieUzleFw
	 uSnHzc/lUJcO0F1wvuiYo4x+tZtPHvxJCOOjSyCpLiMGKkAKcnY0MrfbiYD++6Lfzk4q4
	 Q7pPvD2vI9qtOA4Gz5Pk7cMu6JkocrzwxkM33/Gga+iAUaQam9jaNM9hu67xEoZ/oWlbo
	 G5IJGRna3DL+SCv0bsxI48Ry4lZDllqWozNi1WJepu2DFqqWiE1szl/VvoauuQ6i5SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ddc6gAs4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F485606A31C
	for <linux-crypto@vger.kernel.org>; Thu, 29 Oct 2026 17:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ddc6gAs4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDDA51F01816;
	Thu, 29 Oct 2026 17:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793294088;
	bh=bGajM36dGxksJPdvKCxb49tIEyGw6EPecPLG7cvRSrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ddc6gAs41EjcM2E7jMZLTT8toW9AAz0jIDQ0QGLjIe2eph5zKIfhwbiUBDqQuzBGy
	 nS9k2rL9fiW68v1e382sFmfNq35IFKRFrYIkvnJuyDasJvpyFDjYbPTde3BxPsImx0
	 HSJRKIGSlfD+vhAQdYDuB9/MKEZz+CCTtXH7gww2FZw0SDVMNO6Xy3wfW5S5vhaxCN
	 IPyVncR7YU2u8jpCELxBZV/deUA3BSEGu1Ev6EsU8vyXsNX2YlD+dSOFrc8a2MC88G
	 pcbpAA+FkAzpgzocyEajPYhTbt7S8n4RcVvoGaRnp5zNXAX3E+MxIjm3aadgPjxAGr
	 ZQOL1SSL9kx7Q==
Date: Thu, 29 Oct 2026 10:14:46 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/3] lib/crypto: mldsa: Address some minor nits
Message-ID: <20261029171446.GD1862@quark>
References: <20261029054534.68481-1-ebiggers@kernel.org>
 <5b340d9f-04c9-4ace-9983-be30c11ea75e@app.fastmail.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b340d9f-04c9-4ace-9983-be30c11ea75e@app.fastmail.com>

On Thu, Oct 29, 2026 at 10:44:16AM +0100, Ard Biesheuvel wrote:
> 
> 
> On Thu, 29 Oct 2026, at 06:45, Eric Biggers wrote:
> > A few pedantic fixes for issues found by LLMs.
> >
> > Eric Biggers (3):
> >   lib/crypto: mldsa: Check pk_len before doing pointer arithmetic
> >   lib/crypto: mldsa: Explicitly check that 'alg' is a valid value
> >   lib/crypto: mldsa: Add __must_check to mldsa_verify()
> >
> >  include/crypto/mldsa.h         |  6 ++++--
> >  lib/crypto/mldsa.c             | 15 +++++++++++----
> >  lib/crypto/tests/mldsa_kunit.c |  9 +++++++++
> >  3 files changed, 24 insertions(+), 6 deletions(-)
> >
> >
> 
> Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
