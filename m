Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467D620C488;
	Sun, 30 Nov 2025 02:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764470752; cv=none; b=UPeWiSJc5QDWiDzdwY5nmZe28eGWr0zV9UN38W3/YEnPho+Yiip1PimmMLhpchbkvQ3dDLyHHfeTtCZARDHOC7FevC/YLtIopoqZU7uaHDYgLxhB/UiZl5+6BFfa1SnjsVZCc+XthNJht0jB6OxBidsndwD+6TJPfqlY98sooEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764470752; c=relaxed/simple;
	bh=xOPrgR/E7zkysphxrXM23vcb2cJsIWMng0nnNmYt5fg=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=gFJWt4UtNCmTgds3TjtO5UCn/t6MqT+J8oHqhgLaZaOZ7ru7f/REnnx6sHXckBkXv3lRvp5tQ6Hc21i4kZqeOMUmh0vSpJ0768OR0JdFRDZwVQeDXs9AXa6+Uf9vifICK53P/7F2f6hnLpcFmWPiV42/vzsY48GT+X89Zx8twpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qh0ImzzO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qh0ImzzO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC004C4CEF7;
	Sun, 30 Nov 2025 02:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764470752;
	bh=xOPrgR/E7zkysphxrXM23vcb2cJsIWMng0nnNmYt5fg=;
	h=Date:From:To:Cc:Subject:From;
	b=qh0ImzzOHqrh4HBCp2caT85dcCzIBWUXZbEmFY0LHCS3Fz3gyDKIlbJ5BLEPxk06q
	 C7rR+H4yybsMsMVytBFOML5dSGf7HzGmwdINcdSt4XUiUeDtjwCDvnlF/TzV9OJF9o
	 3RF6gQqQYakjM6iwIZK2g/xcpNa3b78Bj5TRtziThmhfs+2kyt3GEIg63BVYa93fWA
	 KRUWywLoT5T4bSmdDvRt1gUMwSXJ+jR3EfLnW4oRWNe98SPkP4uINcD9ImTkpdQUrd
	 hpO9rkP7Mx+55uliXJ7J45KdaRaKsVhHL0HtWtvqozY1/xjmpPCNjlTYnbxfozqpPz
	 0idse887qalxQ==
Date: Sat, 29 Nov 2025 18:44:01 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>
Subject: [GIT PULL] Crypto library tests for 6.19
Message-ID: <20251130024401.GC12664@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is based on the "Crypto library updates for 6.19" pull request.

The following changes since commit 2dbb6f4a25d38fcf7d6c1c682e45a13e6bbe9562:

  fscrypt: Drop obsolete recommendation to enable optimized POLYVAL (2025-11-11 11:03:39 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-tests-for-linus

for you to fetch changes up to 578fe3ff3d5bc9d851d597bb12dd74c22ad55ff8:

  crypto: testmgr - Remove polyval tests (2025-11-11 11:07:52 -0800)

----------------------------------------------------------------

- Add KUnit test suites for SHA-3, BLAKE2b, and POLYVAL. These are the
  algorithms that have new crypto library interfaces this cycle.

- Remove the crypto_shash POLYVAL tests. They're no longer needed
  because POLYVAL support was removed from crypto_shash. Better
  POLYVAL test coverage is now provided via the KUnit test suite.

----------------------------------------------------------------
David Howells (1):
      lib/crypto: tests: Add SHA3 kunit tests

Eric Biggers (4):
      lib/crypto: tests: Add KUnit tests for BLAKE2b
      lib/crypto: tests: Add additional SHAKE tests
      lib/crypto: tests: Add KUnit tests for POLYVAL
      crypto: testmgr - Remove polyval tests

 Documentation/crypto/sha3.rst       |  11 +
 crypto/tcrypt.c                     |   4 -
 crypto/testmgr.c                    |   6 -
 crypto/testmgr.h                    | 171 ---------------
 lib/crypto/tests/Kconfig            |  29 +++
 lib/crypto/tests/Makefile           |   3 +
 lib/crypto/tests/blake2b-testvecs.h | 342 +++++++++++++++++++++++++++++
 lib/crypto/tests/blake2b_kunit.c    | 133 ++++++++++++
 lib/crypto/tests/polyval-testvecs.h | 186 ++++++++++++++++
 lib/crypto/tests/polyval_kunit.c    | 223 +++++++++++++++++++
 lib/crypto/tests/sha3-testvecs.h    | 249 +++++++++++++++++++++
 lib/crypto/tests/sha3_kunit.c       | 422 ++++++++++++++++++++++++++++++++++++
 scripts/crypto/gen-hash-testvecs.py | 101 +++++++--
 13 files changed, 1682 insertions(+), 198 deletions(-)
 create mode 100644 lib/crypto/tests/blake2b-testvecs.h
 create mode 100644 lib/crypto/tests/blake2b_kunit.c
 create mode 100644 lib/crypto/tests/polyval-testvecs.h
 create mode 100644 lib/crypto/tests/polyval_kunit.c
 create mode 100644 lib/crypto/tests/sha3-testvecs.h
 create mode 100644 lib/crypto/tests/sha3_kunit.c
