Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF2D323416;
	Mon, 17 Aug 2026 17:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786988735; cv=none; b=GUFsJNxSnAbWnCyW9GyyQTbga++fafPTsYqIDXkclDAk3Fm6uhIFvauKwtfXOYizPmtaLq8GwlUrdDtSv68U/TLMs06mB3mkTCWnIlmvS3E6ebvPaF9Xmb4mbg1GLuJoJtogmv1g5qyIRBVl0zm8yWmHWkb1HgN0gjh82bxJPXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786988735; c=relaxed/simple;
	bh=4DZxNytINUTwgXO5OUyZWTlhF+k/3lYsv3KZMOlcmO4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cKF27auDhNNr4IaHk5Is31SMn0YH2KUVSxqJ2rw0a7wQaPih19twcNDz7u9gZ2jwro3ogo6trMEVpEDdrTh3sZYYIB80sj87Swdf2e/ybr2UF+X0N2NtKIWLU1TJbOZGh+81UFn6DkL/x8zN9k5D3/RG02YZnK9ka08qKbfU15o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OVaNzCMt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OVaNzCMt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 076B31F00A3A;
	Mon, 17 Aug 2026 17:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786988734;
	bh=Rd3rMnoT9xgnHTAESNJAuFcPLNQF4nwoN3Bm2bzr5Bg=;
	h=Date:From:To:Cc:Subject;
	b=OVaNzCMt8IlRh2KLBB2w+kjTumdoXjEmH+ECe9bWYJEphL0qeKsbTqYrgPbkPcd46
	 aTjsjr1T61lUM2b5G3lHV+CHne4ZggFU2drXfmhBH/fuZ6jc9lImEngH3HMl723zrR
	 Yh/Q/sHpZylirJMEDgMnFHT/Ybc326W4Cw5V4WG5AACrWY2hQUQFYymmBZgZCrO0pq
	 7iXN8KtlgpeWEbWIPQX17lbdKXKYbnA/n7379vwOl1tmXQGSyL/RPwRLmNTfrrfu0Y
	 37ZTDjO07qJvkNvJ+Y3CdvkRv4IPRzuKK30HMCxkEkMrB8J8YO5wczdXNf5O10JBGh
	 fPXfzeBW4c22w==
Date: Mon, 17 Aug 2026 10:45:32 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Gow <david@davidgow.net>, Thomas Huth <thuth@redhat.com>
Subject: [GIT PULL] Crypto library tests for 7.3
Message-ID: <20260817174532.GD8327@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit adbc4db2c0f0251e5a5a20edd8d8444ce854d80f:

  lib/crypto: aes-cmac: Add zeroization functions (2026-08-10 20:13:41 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git tags/libcrypto-tests-for-linus

for you to fetch changes up to 561131a27f5533e6e63520b4bc43d9c832a27c09:

  lib/crypto: aes-cmac: Use __cleanup() instead of memzero_explicit() (2026-08-10 20:17:56 -0700)

----------------------------------------------------------------

(This depends on the "Crypto library updates for 7.3" pull request.)

- Add comprehensive KUnit test suites for the new AES-GCM and AES-CCM
  library APIs.

- Add FIPS self-tests for all the AES encryption modes. This is needed
  for parity with the traditional crypto API.

- Fix a couple more issues in the IRQ test helper.

----------------------------------------------------------------
Eric Biggers (10):
      lib/crypto: fips: Split fips.h into fips-aes.h and fips-sha.h
      lib/crypto: aes: Add FIPS self-tests for unauthenticated modes
      lib/crypto: aes: Add FIPS self-tests for GCM and CCM
      lib/crypto: tests: Create test-utils.h
      lib/crypto: tests: Use per-test-case buffers in hash tests
      lib/crypto: tests: Add aead-test-template.h
      lib/crypto: tests: Add KUnit test suite for AES-CCM
      lib/crypto: tests: Add KUnit test suite for AES-GCM
      kunit: irq: Continue increasing hrtimer interval for longer
      kunit: irq: Unregister on-stack timer and work from debugobjects

Thomas Huth (1):
      lib/crypto: aes-cmac: Use __cleanup() instead of memzero_explicit()

 include/kunit/run-in-irq-context.h        |   12 +-
 lib/crypto/.kunitconfig                   |    2 +
 lib/crypto/aes.c                          |  262 +++++++-
 lib/crypto/fips-aes.h                     |   78 +++
 lib/crypto/{fips.h => fips-sha.h}         |    6 +-
 lib/crypto/sha1.c                         |    2 +-
 lib/crypto/sha256.c                       |    2 +-
 lib/crypto/sha3.c                         |    2 +-
 lib/crypto/sha512.c                       |    2 +-
 lib/crypto/tests/Kconfig                  |   18 +
 lib/crypto/tests/Makefile                 |    2 +
 lib/crypto/tests/aead-test-template.h     | 1039 +++++++++++++++++++++++++++++
 lib/crypto/tests/aes_cbc_macs_kunit.c     |   12 +-
 lib/crypto/tests/aes_ccm_kunit.c          |  356 ++++++++++
 lib/crypto/tests/aes_gcm_kunit.c          |  472 +++++++++++++
 lib/crypto/tests/blake2b_kunit.c          |   33 +-
 lib/crypto/tests/blake2s_kunit.c          |   33 +-
 lib/crypto/tests/chacha20poly1305_kunit.c |    9 +-
 lib/crypto/tests/ghash_kunit.c            |   37 +-
 lib/crypto/tests/hash-test-template.h     |  249 +++----
 lib/crypto/tests/md5_kunit.c              |    2 -
 lib/crypto/tests/mldsa_kunit.c            |   19 +-
 lib/crypto/tests/nh_kunit.c               |    5 +-
 lib/crypto/tests/poly1305_kunit.c         |   21 +-
 lib/crypto/tests/polyval_kunit.c          |   38 +-
 lib/crypto/tests/sha1_kunit.c             |    2 -
 lib/crypto/tests/sha224_kunit.c           |    2 -
 lib/crypto/tests/sha256_kunit.c           |   48 +-
 lib/crypto/tests/sha384_kunit.c           |    2 -
 lib/crypto/tests/sha3_kunit.c             |   30 +-
 lib/crypto/tests/sha512_kunit.c           |    2 -
 lib/crypto/tests/sm3_kunit.c              |    2 -
 lib/crypto/tests/test-utils.h             |  111 +++
 scripts/crypto/gen-aead-testvecs.py       |   69 ++
 scripts/crypto/gen-fips-testvecs.py       |  164 ++++-
 35 files changed, 2743 insertions(+), 402 deletions(-)
 create mode 100644 lib/crypto/fips-aes.h
 rename lib/crypto/{fips.h => fips-sha.h} (90%)
 create mode 100644 lib/crypto/tests/aead-test-template.h
 create mode 100644 lib/crypto/tests/aes_ccm_kunit.c
 create mode 100644 lib/crypto/tests/aes_gcm_kunit.c
 create mode 100644 lib/crypto/tests/test-utils.h
 create mode 100755 scripts/crypto/gen-aead-testvecs.py
