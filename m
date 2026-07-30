Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCB734DCE4;
	Thu, 30 Jul 2026 01:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785375319; cv=none; b=ap1R6GYOU+njzywcQnChQfGjn/OtGpLZtrNfYn/GFyDRlFN6zfTtt+ytWbCk5+6kEPnyZkpSBKZJYR4KuamwJM0tT4qtFWYWEJrVo5YfM34Gs/O/z/E1YkokyufW7r45YvJcM0hnYrCgxtuHhokKMB9Z0E2OU3i7Zx6dDmEj3AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785375319; c=relaxed/simple;
	bh=oSAvuk6XAnjzDvhOtKxFecXXZYHM/Y/XMr2jVvd7JcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=u3VCodUCWrEvDi04MgUfQtQJtIQxDVHSrNLJiu4tIVbINy3rnEAicW4vwmsODpXCOP99/RqrXHC0jbXuuDrnmN4hZulWBCd109B6vly8vuZ7i36LG7gKTvEFxLXVcha7u3Z1DRLY2zJozZrt7QL0toQ9slNlmUCQnYZQm8+IisU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mV9JM9kG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mV9JM9kG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF31D1F00A3A;
	Thu, 30 Jul 2026 01:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785375318;
	bh=lxmbBsD7EI9Fd72gCleG/k3i96DR7zE49wBeoZZybfk=;
	h=From:To:Cc:Subject:Date;
	b=mV9JM9kGWbtyNODHpp5+FiW9tknqz9y0IKVcLVMKlIz1vxnRld3q7jfC18x+KBzXs
	 HClabp3nBcrORssFBRDno0OHGKAgHehB23DSXXETOmWPC4oY3oeRHJSD85wZIkx1Yc
	 xH82czJhgssxOU9YzwQRBCdrHb1vaLamNyTCoaOti/YtKkG4XR88QxR5+ElHOOipga
	 lq8gOt+dowHfutA3d+633zP5OaUBybn8GvhrbOYAVGc7TwSllGijUsZd42ykZFoYby
	 k2SwCOIBOwEqpViVZ7ENmypc8l+eDCkJZ6NTO2WZkRmp9fLIfAlXLnolBL+ne89jX0
	 8LVuNb2ZkVV9g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/5] lib/crypto: KUnit tests for AES-CCM and AES-GCM
Date: Wed, 29 Jul 2026 18:32:55 -0700
Message-ID: <20260730013301.160203-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series applies to libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git gcm-ccm-kunit-v1

This series adds comprehensive KUnit test suites for the AES-CCM and
AES-GCM library APIs.

This is a follow-up to the series 
"[PATCH v2 00/13] Library APIs for AES encryption modes"
(https://lore.kernel.org/linux-crypto/20260715221153.246410-1-ebiggers@kernel.org/)

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
 lib/crypto/tests/aes_ccm_kunit.c          |  352 +++++++
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
 26 files changed, 2271 insertions(+), 340 deletions(-)
 create mode 100644 lib/crypto/tests/aead-test-template.h
 create mode 100644 lib/crypto/tests/aes_ccm_kunit.c
 create mode 100644 lib/crypto/tests/aes_gcm_kunit.c
 create mode 100644 lib/crypto/tests/test-utils.h
 create mode 100755 scripts/crypto/gen-aead-testvecs.py


base-commit: f70ad727d1d60a4dfcb1a22152d4169f9a205af9
-- 
2.55.0

