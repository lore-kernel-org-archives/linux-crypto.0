Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE4A76025;
	Sun, 27 Jul 2025 23:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753660098; cv=none; b=OHKA36tyHZQaL66fPX1wlqAL3OIXp5cJj7Q9S/0jnipPkb17z9vWtBuN0tdeavr1mMd7LdGGHgBGVPwBKJ6mIVb2417SrTuMwAx2jtunhQGq3y587aspQ68g9D6rvRPZSp+8y8S9V03ogBjAnZigXwi1OBp38kf59sAAWm8C0AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753660098; c=relaxed/simple;
	bh=sRwE7YTGYu95qmZvfFcR8jto38RbxZPJecfTsWFs+AU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RYOtC3yFEEMdsZgf534kpnqnqE5ayMhYzi0PUqWirS6Bfd4UEepD3NCfwqdCY1Augk7K0UwZrKmGjYiQgS10mcvqq1oddoUeT0L3XPfr7zc1zWF9kS6eB7LfbPMdxktCiUoHqfmZFW2ecIcPgxi4bLBoE22fSoafI/W2EywIM9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=drqpG0d7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="drqpG0d7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC00DC4CEEB;
	Sun, 27 Jul 2025 23:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753660098;
	bh=sRwE7YTGYu95qmZvfFcR8jto38RbxZPJecfTsWFs+AU=;
	h=Date:From:To:Cc:Subject:From;
	b=drqpG0d7ftvsAeLddg8IAzKJvaVKLaaa1wR3J/R+BRKPgXd9GANB/TpcaPKL7KV4g
	 f1by7GGfpoRrc5kl25BTk1NooxJkRH/wEQ3Hnh4rGEg67L1oZaa4Eb9tCLwgstrqv8
	 IA9OYX2GQFbWCnFuOETN9pqS7K8MqSgx4166klBC6aybbOGzxaKQB8Q/aCGoEqOuIg
	 uviFVWZwue742j55WMZe3fnrJ+LUv0jirbSmxENQnOPMiortshhX33b0YjNlgMy4cR
	 FSL7KYjB59wrGO4DzCfynZ6IHHV0+4TvrQKw3svOKxkmlDYhddSggxpQCmGPCWoOY/
	 Hg2OdLargjmkQ==
Date: Sun, 27 Jul 2025 16:47:27 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [GIT PULL] Crypto library tests for 6.17
Message-ID: <20250727234727.GD1261@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Note: this depends on the "Crypto library updates" pull request and
should be merged after it.

The following changes since commit c76ed8790b3018fe36647d9aae96e0373f321184:

  crypto: sha1 - Remove sha1_base.h (2025-07-14 11:28:38 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-tests-for-linus

for you to fetch changes up to 8cd876e7833758f8a924db2e39530d2a9afd2703:

  lib/crypto: tests: Annotate worker to be on stack (2025-07-21 20:10:36 -0700)

----------------------------------------------------------------

Add KUnit test suites for the Poly1305, SHA-1, SHA-224, SHA-256,
SHA-384, and SHA-512 library functions.

These are the first KUnit tests for lib/crypto/. So in addition to
being useful tests for these specific algorithms, they also establish
some conventions for lib/crypto/ testing going forwards.

The new tests are fairly comprehensive: more comprehensive than the
generic crypto infrastructure's tests. They use a variety of
techniques to check for the types of implementation bugs that tend to
occur in the real world, rather than just naively checking some test
vectors. (Interestingly, poly1305_kunit found a bug in QEMU.)

The core test logic is shared by all six algorithms, rather than being
duplicated for each algorithm.

Each algorithm's test suite also optionally includes a benchmark.

----------------------------------------------------------------
Eric Biggers (5):
      lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py
      lib/crypto: tests: Add KUnit tests for SHA-224 and SHA-256
      lib/crypto: tests: Add KUnit tests for SHA-384 and SHA-512
      lib/crypto: tests: Add KUnit tests for Poly1305
      lib/crypto: tests: Add KUnit tests for SHA-1 and HMAC-SHA1

Guenter Roeck (1):
      lib/crypto: tests: Annotate worker to be on stack

 lib/crypto/Kconfig                    |   2 +
 lib/crypto/Makefile                   |   2 +
 lib/crypto/tests/Kconfig              |  60 +++
 lib/crypto/tests/Makefile             |   6 +
 lib/crypto/tests/hash-test-template.h | 683 ++++++++++++++++++++++++++++++++++
 lib/crypto/tests/poly1305-testvecs.h  | 186 +++++++++
 lib/crypto/tests/poly1305_kunit.c     | 165 ++++++++
 lib/crypto/tests/sha1-testvecs.h      | 212 +++++++++++
 lib/crypto/tests/sha1_kunit.c         |  39 ++
 lib/crypto/tests/sha224-testvecs.h    | 238 ++++++++++++
 lib/crypto/tests/sha224_kunit.c       |  39 ++
 lib/crypto/tests/sha256-testvecs.h    | 238 ++++++++++++
 lib/crypto/tests/sha256_kunit.c       |  39 ++
 lib/crypto/tests/sha384-testvecs.h    | 290 +++++++++++++++
 lib/crypto/tests/sha384_kunit.c       |  39 ++
 lib/crypto/tests/sha512-testvecs.h    | 342 +++++++++++++++++
 lib/crypto/tests/sha512_kunit.c       |  39 ++
 scripts/crypto/gen-hash-testvecs.py   | 147 ++++++++
 18 files changed, 2766 insertions(+)
 create mode 100644 lib/crypto/tests/Kconfig
 create mode 100644 lib/crypto/tests/Makefile
 create mode 100644 lib/crypto/tests/hash-test-template.h
 create mode 100644 lib/crypto/tests/poly1305-testvecs.h
 create mode 100644 lib/crypto/tests/poly1305_kunit.c
 create mode 100644 lib/crypto/tests/sha1-testvecs.h
 create mode 100644 lib/crypto/tests/sha1_kunit.c
 create mode 100644 lib/crypto/tests/sha224-testvecs.h
 create mode 100644 lib/crypto/tests/sha224_kunit.c
 create mode 100644 lib/crypto/tests/sha256-testvecs.h
 create mode 100644 lib/crypto/tests/sha256_kunit.c
 create mode 100644 lib/crypto/tests/sha384-testvecs.h
 create mode 100644 lib/crypto/tests/sha384_kunit.c
 create mode 100644 lib/crypto/tests/sha512-testvecs.h
 create mode 100644 lib/crypto/tests/sha512_kunit.c
 create mode 100755 scripts/crypto/gen-hash-testvecs.py
