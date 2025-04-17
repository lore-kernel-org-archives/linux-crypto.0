Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546402571A0
	for <linux-crypto@vger.kernel.org>; Thu, 17 Apr 2025 18:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915169; cv=none; b=bGnZxTto/iZY99tnKva5otbph5r/Oprt24LIBe60WHGzOaU99lcDc90baEeiCU30BezZCQBpWmeYxf6dsbR1j7mcs0WIZf2xU1E/fze8+BiX56X+AnwMPhi2JEbAz+u+IUEilHfDQhUfrZZyph2SSdaheh30oRUXyRo3qHrm8Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915169; c=relaxed/simple;
	bh=uKjQJ2/PCf/TV+Akbgt/EKN9Ks4Ib0sphpwWY7TVpkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cDxtuNsjOmiaYdL/ihfZXdo+qV6YecDpDqAFD8M+D8hcS5KnEVyzdWs1GAtp5pX1h0dPvsS/slbCnG99+XRJchVe6NctWLtt9lqtklyowzKhmFSwLXWCkF9U2ZKAKIG88bT5tIloegacl66Ryljz7fMzkSCZdLBDY1nPvCkjPYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UclTiuxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UclTiuxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD31C4CEE4;
	Thu, 17 Apr 2025 18:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744915169;
	bh=uKjQJ2/PCf/TV+Akbgt/EKN9Ks4Ib0sphpwWY7TVpkE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UclTiuxb8N44iR+CLKSYpvROCCeBOwJE4YMRQwk9w6o4yBSNgiNnw1vfGOsTUfGY5
	 EVi41QGzRyLOi29qLx9qwzjR0fwiR46sRgxMWTTqDaWOakatwpj3ndSkXAk0ajvThZ
	 TvmfDpHbQIC/rI69ToXspUBVsY4dgAGP4atOno4fSYijgKxWW0ISjDuDm2BgTm6PJz
	 Zab4JBMUTDESYClCBkwseEADtZsISl5ZW1IRqJW7MKR00XD5pbw9yIx91XMEpsfaC1
	 +iITe7Iy4vrxalEv9+Gb0DUFDoeer7YQEUSwgcqkHZZDpF8DsJv1l95CahxLVfUvDQ
	 6BQjttPQGu0+A==
Date: Thu, 17 Apr 2025 11:39:27 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 00/67] crypto: shash - Handle partial blocks in API
Message-ID: <20250417183927.GD800@quark.localdomain>
References: <cover.1744784515.git.herbert@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1744784515.git.herbert@gondor.apana.org.au>

On Wed, Apr 16, 2025 at 02:42:42PM +0800, Herbert Xu wrote:
> This series is based on
> 
> 	https://lore.kernel.org/linux-crypto/Z_8-y1NkOSm7HY8C@gondor.apana.org.au

Which links to a random message in a thread.

Going to cover letter says:

    This series is based on

            https://lore.kernel.org/linux-crypto/cover.1744454589.git.herbert@gondor.apana.org.au

But that one lists no base-commit.

And this series does not apply to current cryptodev/master.

So there's no way to apply this series to review it.

I think the high-level idea is still suspect, as I said before.  Especially for
sha256 and sha512 which I will be fixing to have proper library APIs.  I don't
think it's particularly helpful to be futzing around with how those are
integrated into shash when I'll be fixing it properly soon.

But whatever, as usual for your submissions this will get pushed out anyway,
likely without running the tests (FYI the compression tests are already failing
on cryptodev/master due to your recent changes).

- Eric
