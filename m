Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230BF48989D;
	Sun,  2 Aug 2026 23:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785713437; cv=none; b=XeXlsHbTtz6cPopuGa38AGXm2LkF8tLEL2b+fM4fz/FUQf2hwz4ycCMv8/8fOcD7Zbgux785JEZSsHOQ+62CfH0UK7N/a34ZLJyTILPpmjsO9igoXWPD8rHD6Ukl0Co2lEgzuNJT0Uq/+OcSBI5lR0EEKHBcF4IZ3YtiEy0VpgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785713437; c=relaxed/simple;
	bh=FkA01cKGY+2xNejz2ROPlzZ/ne7uTwtJMoMlbLVZM+g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z+q1AV0+wyT4tX/H7aAyPKyT123fTUg7ZklZ4icWoHGAkNdcOIWT2uDF63b96Pj/XFnkrdmgttyQ4ELtCwJoI0yDNO+LgnGfMKdN+ohprX6udhXrKrNWUsNttDqZ2odkXZqM6nOKqu0r7Lsrq9ACWQQ4wBtQYFbgjbmPQOj26iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TV3yWYVu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TV3yWYVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2AE1F000E9;
	Sun,  2 Aug 2026 23:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785713435;
	bh=meck29DXuQAEURnyRRfrAQR20NbX70/2RNkNvR+NYE0=;
	h=From:To:Cc:Subject:Date;
	b=TV3yWYVub2IxNMQTkwIdYUgGBHK2bUk2YvqW/kuRIeX55It9rDfTEDZbdgLtbv4h4
	 tMb9nbIQPf69oMuTpPKDSTEmSznngXCuPI+5fJvlrUlxSEAg55Defm1ix2hZVNMKEo
	 7m+7kta57htaTBSL9+R0Z2GE9/ctowJwd0/rtdHvlzlPrHUtMj2Sg5VR/ugOR+9yjr
	 9VSWbjFWbr0yV8VDKv6TtBw/gEJ+PZrsd+gqR4LG2O7Cqb868EwU93MfvSI7aNho7j
	 O6q/Brgx/jCw6e5cLwWpmMql4WUAfvIRsF9KrYrvpdvtkOBEgVSuAtKc5ZKJdPepkO
	 THwgklr3Q8y/Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 0/5] lib/crypto: KUnit tests for AES-CCM and AES-GCM
Date: Sun,  2 Aug 2026 16:30:00 -0700
Message-ID: <20260802233005.161467-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series applies to libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git gcm-ccm-kunit-v2

This series adds comprehensive KUnit test suites for the AES-CCM and
AES-GCM library APIs.

This is a follow-up to the series
"[PATCH v2 00/13] Library APIs for AES encryption modes"
(https://lore.kernel.org/linux-crypto/20260715221153.246410-1-ebiggers@kernel.org/)

Changed in v2:
  - Fixed crash in test_aes_ccm_data_len_too_large() on 32-bit kernels.

Eric Biggers (5):
  lib/crypto: tests: Create test-utils.h
  lib/crypto: tests: Use per-test-case buffers in hash tests
  lib/crypto: tests: Add aead-test-template.h
  lib/crypto: tests: Add KUnit test suite for AES-CCM
  lib/crypto: tests: Add KUnit test suite for AES-GCM

 lib/crypto/.kunitconfig                   |    2 +
 lib/crypto/tests/Kconfig                  |   18 +
 lib/crypto/tests/Makefile                 |    2 +
 lib/crypto/tests/aead-test-template.h     | 1039 +++++++++++++++++++++
 lib/crypto/tests/aes_cbc_macs_kunit.c     |   12 +-
 lib/crypto/tests/aes_ccm_kunit.c          |  356 +++++++
 lib/crypto/tests/aes_gcm_kunit.c          |  472 ++++++++++
 lib/crypto/tests/blake2b_kunit.c          |   33 +-
 lib/crypto/tests/blake2s_kunit.c          |   33 +-
 lib/crypto/tests/chacha20poly1305_kunit.c |    9 +-
 lib/crypto/tests/ghash_kunit.c            |   37 +-
 lib/crypto/tests/hash-test-template.h     |  249 ++---
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
 26 files changed, 2275 insertions(+), 340 deletions(-)
 create mode 100644 lib/crypto/tests/aead-test-template.h
 create mode 100644 lib/crypto/tests/aes_ccm_kunit.c
 create mode 100644 lib/crypto/tests/aes_gcm_kunit.c
 create mode 100644 lib/crypto/tests/test-utils.h
 create mode 100755 scripts/crypto/gen-aead-testvecs.py


base-commit: 6d22ec26295c1412d765e3d687e46224fc332928
-- 
2.55.0

