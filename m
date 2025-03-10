Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1DB023371B;
	Mon, 10 Mar 2025 17:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627656; cv=none; b=QC4nCfuI1xCqNf4lzJS+vB0CceIflcwDAgblPl5+sxvM+EjpgyrABVpoAmm7EBV18W6KRc8e+omEsC5eTtd1hRmWzJnR3w9bX5XT1hc6Wj4D5ANxr235/9sjN9YiWQInAn9CVyO4oMwkuQYWKjhF5A9KUVZql7z0AyI3qjwpgzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627656; c=relaxed/simple;
	bh=mfL+ECuyinM+wmc2OBrFOzo/GFhGAFreWMKKzFatSXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gxiZlJM2NMcE0x7E17aMYARP1nJfVsaB2Z7PEeg1sGpyaULMujvZr6Bxp0O0QVqVpHKpHPLHO2vngEbCSmfK7LNEaBOcSB9tKZEAQc/FD4SySkg2Dk/xc1+Vf0eR87k4X+TrJF2n/8OFfv4XcyBwz8BCFrmPqaFtPnRB2+VcTww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vIuhOP3N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vIuhOP3N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4238C4CEE5;
	Mon, 10 Mar 2025 17:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741627656;
	bh=mfL+ECuyinM+wmc2OBrFOzo/GFhGAFreWMKKzFatSXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vIuhOP3NLjhj33EUr+hMQkvcx4HTSXtAPmXIc9GPTE+oTJvOzN2e4hOE035+tL9rt
	 8S880nEDnSHwqG6cQB5xDl4FcBUPSzOWVJUyWHS1uMWtrPZdEsHW2iajZ2SYn4qvzb
	 dRlRPXOwnOyxtYliMy+d9C2IRFPt0yvmhD+atblB3e3PHksUF+OPfNtf96HqT/hKPe
	 dg+P/e7fd+u9TZPN75szBzEjxtnJME+aNhUwQPEwOdd/hB80OOAINRD4cxa+aTSNKc
	 S32zghOWFDWJLfAO50Li75q+VXBEUCfU1G3rKLzoLQQCD2Vd9wr2g/EiGTlA664c5w
	 imlZeBIBwffxw==
Date: Mon, 10 Mar 2025 10:27:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Justin M. Forbes" <jforbes@fedoraproject.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Arnd Bergmann <arnd@arndb.de>, Ard Biesheuvel <ardb@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	James Bottomley <James.Bottomley@hansenpartnership.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] crypto: lib/Kconfig: hide library options
Message-ID: <20250310172734.GE1701@sol.localdomain>
References: <20250310132647.3256818-1-arnd@kernel.org>
 <20250310132647.3256818-2-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250310132647.3256818-2-arnd@kernel.org>

On Mon, Mar 10, 2025 at 02:26:40PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Any driver that needs these library functions should already be selecting
> the corresponding Kconfig symbols, so there is no real point in making
> these visible.
> 
> The original patch that made these user selectable described problems
> with drivers failing to select the code they use, but as far as I can
> tell, those were all bugs that got solved in the meantime and did not
> get solved by that patch.
> 
> Fixes: e56e18985596 ("lib/crypto: add prompts back to crypto libraries")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ----
> This does not actually fix a build failure, but I noticed that the
> user visible options don't really make sense. Feel free to ignore
> this one.

Acked-by: Eric Biggers <ebiggers@kernel.org>

But I think the following needs to be fixed first:

    config BIG_KEYS
            bool "Large payload keys"
            depends on KEYS
            depends on TMPFS
            depends on CRYPTO_LIB_CHACHA20POLY1305 = y

- Eric
