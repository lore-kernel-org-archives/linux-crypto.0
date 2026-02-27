Received: from sphereful.davidgow.net (sphereful.davidgow.net [203.29.242.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAD538A721;
	Fri, 27 Feb 2026 09:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.29.242.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772184002; cv=none; b=i5wcTP2YQGufsw+8LduCiYwC7/rlOzlImMHQNm6u/2NdZYyQaqvsw5KtrIxYVEfBrCm92tHk8taNDQH3jsEUH3v3aGPo71ZjQnerefF95z4dRHJ/OygMXdF6kJCADHsZwXDczdhsKmlHw3DoS6pt2AtmnDk2uu+bvybSI04Hfls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772184002; c=relaxed/simple;
	bh=52FSEcDd5oAKtEs/Gkr465MLhbFHmP5Omk7jgrGcxAg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tf/vhhvu2PpC5n/qBIR4foUQiP7yD0CNuKnJvO1CLPhuNuXp7qBM9Ang5C3k2PC1PWKrgVN8nVVXr9qwBnlNVHwO6liNzrCbOJon6ydPv52B6aeRSNb8fon/CG/zQhK4rVp5yaV7IOAbw+xyg8XC3LZR4dmj0ht4OYX3t1qBD+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net; spf=pass smtp.mailfrom=davidgow.net; dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.b=a19n42Vv; dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.b=E4B7JXH6; arc=none smtp.client-ip=203.29.242.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=davidgow.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=davidgow.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.b="a19n42Vv";
	dkim=pass (4096-bit key) header.d=davidgow.net header.i=@davidgow.net header.b="E4B7JXH6"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1772183998;
	bh=52FSEcDd5oAKtEs/Gkr465MLhbFHmP5Omk7jgrGcxAg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a19n42VveTPnmO1MOwHm+PlM5HNs7HhoKaM5Pf4SJGoNYN7YlnXsAuTgX8LyMLoYM
	 Yq0pQ1ycZHdB5vJIfEC4C7dk1F8w4h79n/2jgNgd0SXib5CVyh4dHP8RNI+U895WKA
	 VU7+s0chN6hY7rg1MkK78cG2aRTe1jyVZPOBgJwhzKAPEHAxJdxm0icaxnEYwXezxY
	 Kyya9q/fxAHae93MTCkdL3z6vBAtzzQ8G8YZXOTDehkqMw9pQ3fG5fV23ia8FVp3Bh
	 HXmtfxwnEOYpAqByEgGqa57TdgNvEBjcYFmCf/ez6UylvJLbEhT7TOR4jen1o4hCsc
	 Xod6K+owczj1g0MJ12YDeOdaW8fW3nWPx09yAyAdngFaBjUaVkM4htHH+sqxXKeO1y
	 prkblPOuREiMM9xIqQfdAETxpLiJP0wFeAODAUWjXeVTmf7jffuvHUlpI2tdIe4RYG
	 aTEkBL4r8Ntc9wsvzCpugQhcbfPsDjZ1QZTyS1HujwA3zm68vqi5SE/KNraTSbmsdT
	 7NQKXz6ZnDndRSCeqHyIaB5MZFb7W2n8JSmNKn/FQTTKttPHvgGbQXJIb/LBBU8nL8
	 pWEmHIiQQTPfnC/VRPGcU8R9IOS9bSOFZRMCsDqAxSSJTfitX7fFQNa0zCKzP4UB5s
	 NFBeL1q2mwFFHXHYEc3ohM1s=
Received: by sphereful.davidgow.net (Postfix, from userid 119)
	id BE4551E7A31; Fri, 27 Feb 2026 17:19:58 +0800 (AWST)
X-Spam-Level: 
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=davidgow.net;
	s=201606; t=1772183996;
	bh=52FSEcDd5oAKtEs/Gkr465MLhbFHmP5Omk7jgrGcxAg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E4B7JXH6gAxvwzrFixGhE33glyDyT/NJH3pWbK85bP3X4edIjLby+jI3IUKtvhzrC
	 iabKpbXT5qnVoEm1nKru7gJRZDizg6vzKkSRUpkZ+yMVHqUh5Grrv+pz2xUKS3EIbB
	 AH1rJCRBZe8235kzrun3ay9ow2zOdUqRV5OXDIa8KQ9hWtsRA8fQGGBA5pRfhcsrPE
	 YlMqsjd4nSATK3EAo42Ek5uNhToYO3D8V2gs4vCAKgKTeqomacXHsKJ4cKcKbTYVoV
	 xpwQMd6BsrDUTRhh8upr5/n7MDJKphm6gLFCeZzQvFE2tISOBZ+Gwh9+H8oT1AmMPh
	 Qw3hbvOdL1GBVsS0XcHQrIl1pTmqZ104n6OV0UC5zJuQcDHd5nr6zsSm7g+LRmQxQi
	 STuMP11yWEYHrQ8hVAP8H2BA7JtRqjrxpD5+eev1mQvbB56IsfXt71CTjgKEtvcPNN
	 ympswz9BaTSiuRNwXZ72z9baCFOdQr6m63OjEItBP36NJaL1nmE3al7g+u10BCDQzl
	 XUlwoWyt9qJ51ZIUfAizggc2APOeaA1B6vSzEij53bLdAk0lQFCXsEwiBgwrA6M6Vr
	 L7Bd89jzsH/gKYaxajwrslpwk6NfMCBzq6QaTUePhRBAurlATgrw/L+BgvJkaHjJcz
	 niPZIkoD2T6JSUzCJnSOlj54=
Received: from [IPV6:2001:8003:8824:9e00:6d16:7ef9:c827:387c] (unknown [IPv6:2001:8003:8824:9e00:6d16:7ef9:c827:387c])
	by sphereful.davidgow.net (Postfix) with ESMTPSA id D66781E7A28;
	Fri, 27 Feb 2026 17:19:56 +0800 (AWST)
Message-ID: <e7885b51-3481-4499-a3d2-88087d8b5200@davidgow.net>
Date: Fri, 27 Feb 2026 17:19:54 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] lib/crypto: tests: Depend on library options rather than
 selecting them
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
 "Jason A . Donenfeld" <Jason@zx2c4.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, kunit-dev@googlegroups.com,
 linux-kselftest@vger.kernel.org, Brendan Higgins
 <brendan.higgins@linux.dev>, Rae Moar <raemoar63@gmail.com>,
 Geert Uytterhoeven <geert@linux-m68k.org>, stable@vger.kernel.org
References: <20260226191749.39397-1-ebiggers@kernel.org>
Content-Language: fr
From: David Gow <david@davidgow.net>
In-Reply-To: <20260226191749.39397-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 27/02/2026 à 3:17 AM, 'Eric Biggers' via KUnit Development a écrit :
> The convention for KUnit tests is to have the test kconfig options
> visible only when the code they depend on is already enabled.  This way
> only the tests that are relevant to the particular kernel build can be
> enabled, either manually or via KUNIT_ALL_TESTS.
> 
> Update lib/crypto/tests/Kconfig to follow that convention, i.e. depend
> on the corresponding library options rather than selecting them.  This
> fixes an issue where enabling KUNIT_ALL_TESTS enabled non-test code.
> 
> This does mean that it becomes more difficult to enable *all* the crypto
> library tests (which is what I do as a maintainer of the code), since
> doing so will now require enabling other options that select the
> libraries.  Regardless, we should follow the standard KUnit convention.
> 
> Note: currently most of the crypto library options are selected by
> visible options in crypto/Kconfig, which can be used to enable them
> without too much trouble.  If in the future we end up with more cases
> like CRYPTO_LIB_CURVE25519 which is selected only by WIREGUARD (thus
> making CRYPTO_LIB_CURVE25519_KUNIT_TEST effectively depend on WIREGUARD
> after this commit), we could consider adding a new kconfig option that
> enables all the library code specifically for testing.
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Closes: https://lore.kernel.org/r/CAMuHMdVFRQZXCKJBOBDJtpENvpVO39AxGMUFWVQdM6xKTpnYYw@mail.gmail.com
> Fixes: 4dcf6caddaa0 ("lib/crypto: tests: Add KUnit tests for SHA-224 and SHA-256")
> Fixes: 571eaeddb67d ("lib/crypto: tests: Add KUnit tests for SHA-384 and SHA-512")
> Fixes: 6dd4d9f7919e ("lib/crypto: tests: Add KUnit tests for Poly1305")
> Fixes: 66b130607908 ("lib/crypto: tests: Add KUnit tests for SHA-1 and HMAC-SHA1")
> Fixes: d6b6aac0cdb4 ("lib/crypto: tests: Add KUnit tests for MD5 and HMAC-MD5")
> Fixes: afc4e4a5f122 ("lib/crypto: tests: Migrate Curve25519 self-test to KUnit")
> Fixes: 6401fd334ddf ("lib/crypto: tests: Add KUnit tests for BLAKE2b")
> Fixes: 15c64c47e484 ("lib/crypto: tests: Add SHA3 kunit tests")
> Fixes: b3aed551b3fc ("lib/crypto: tests: Add KUnit tests for POLYVAL")
> Fixes: ed894faccb8d ("lib/crypto: tests: Add KUnit tests for ML-DSA verification")
> Fixes: 7246fe6cd644 ("lib/crypto: tests: Add KUnit tests for NH")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---

Thanks -- I do think this is better, as we do run KUnit tests on pretty 
minimal configurations.

One suggestion would be to have a crypto/.kunitconfig file which enables 
all of these: you could then run the crypto tests with:
./tools/testing/kunit/kunit.py run --kunitconfig crypto/

Reviewed-by: David Gow <david@davidgow.net>

Cheers,
-- David

