Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893A92FD7BE;
	Sun,  1 Mar 2026 03:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772335223; cv=none; b=SsUiM0LzIx3KD6x/QA9E5SZNU0Er2dF9cGnO1Dgr+arhJTwR2+RV0ZRACWtjBzWLUWUTx7E9DSwsETC1fu4S6D7YknWwe3AJzCRWs6T9ECrcDC7IRv3rJtNSsqumkwAYfiM/GTQhMh50w8ZgB+cM9v9tNzvSByARclvNmkQjZ74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772335223; c=relaxed/simple;
	bh=5QDKUwYfwEYBq4ItvlMoP8J0YVGi3x2/N98yqJxxFjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YN1eMzRG8TPUnM3x+IhvxThKeQ2x8y3WhD5UL538fJuAjnlEpZpidtYaqa29QiaKlk1wQriNDfk6eKsgllRBnGqF/LSmM8jmH9A3HVGFFTk9Rdc8DBt8Xjn30oyqGo6DVRtYNhQdJa1i+v3EHKH6ab2fKllCqjVyRIxRDrkv2uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ldWhmyRT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ldWhmyRT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07FAC19425;
	Sun,  1 Mar 2026 03:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772335223;
	bh=5QDKUwYfwEYBq4ItvlMoP8J0YVGi3x2/N98yqJxxFjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ldWhmyRTnFme6trmd7R0a4n1flQUSaHcjzpj1H3vNeL3DfgCTV51Jx5DkTfSLycos
	 2BIdCzV/6KsTtjCGx6eO18zBflcY51lB39g43GA4WDE2u7b7BFSvvt4egsYRUTGAX6
	 6VqL0NXtnIFEuaOE+gHBNZ2yjFQ9s8fQX3MUcfBYGMn10A+nkDWynUDQUxlzuL8wlG
	 ad5XsVzHk/J04gsRCQVUQv6tUSD/OA7rnlr9aN2jn9pd4JHOqhiCnTJxV/kP2hsJDH
	 w27CELVmymhN+EUqIXHndh4uq+HLbJaGS9kTSVXQ9b75afU0rZq/jlNeVvmwa/owgF
	 KKsjrYI1+xdLw==
Date: Sat, 28 Feb 2026 19:19:29 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>, Rae Moar <raemoar63@gmail.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>, stable@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: tests: Depend on library options rather than
 selecting them
Message-ID: <20260301031929.GB2271@sol>
References: <20260226191749.39397-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226191749.39397-1-ebiggers@kernel.org>

On Thu, Feb 26, 2026 at 11:17:49AM -0800, Eric Biggers wrote:
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

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
