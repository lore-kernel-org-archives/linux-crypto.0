Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9B8A248F68;
	Mon, 15 Sep 2025 16:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757952552; cv=none; b=VP9KoWAH2sDIhz3rWkg5qpRUhRGbZtuo6QuZioGQsUxZzcw7IvZxiI9py/IAK50blUj5mZFKhX9j2+VBDlpOYva1Ri/sSZKWXDWBw8DP+x4sZ/9Gz/jYhu+3BpOM0kufZ7UU6r9n5iFCZMsgkx/5QmFM/+9ltINg1FWvSxaqo9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757952552; c=relaxed/simple;
	bh=2kwD057UDVqZKek/SB4FkUZbEOXrXs53qNd/kRtu9fI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iIuUIEPIn8z73LuuUS/GxP+DtNC+KyXfII//w7nV4tB2UW6+ncANIvv2lXornnudCdmAfiwdH4MpraR5GNvjsm0A9nlSiORJaRzvNeGj4/D9w2oT0DxWycuHn0wd8ChOYi8wDb1j92j5dmEpFOqqadwtEj2RIEAyObIQUaggrsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1eJrgHS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1eJrgHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B2DC4CEF1;
	Mon, 15 Sep 2025 16:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757952551;
	bh=2kwD057UDVqZKek/SB4FkUZbEOXrXs53qNd/kRtu9fI=;
	h=From:To:Cc:Subject:Date:From;
	b=A1eJrgHSDSoCFgRMCcpY1lhPLcxXCBJbstJDNVMAHCDPETpIIFCEhyuIZ3XMhzlSg
	 SzuOXgNl0q+HTBftEyyTm1KFQA9QuLp1xkWKicOFvhD5C5qynGI8PGhBe/1Vvhtzfh
	 eN5t7Vh93GEkq8280+VaE98UhxN2VOmGeje+PNyB+eKvchw9Xf/tkSN9okVMXRQoWq
	 xj3OWyTAew62N8YUndxfOhlkHK9HMH8aeKubZpVtr0G/nxFRZizt6uTiKlyGLqGHfZ
	 HLc07DPkIC7zXndV+80NYS6lgQVRnO6vJJE6gwLVFfFnitlaWd3GbOou0Ew2nW+GCF
	 Ipu7HjzCJNskA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 0/6] Optimize fsverity using 2-way interleaved SHA-256 hashing
Date: Mon, 15 Sep 2025 11:08:13 -0500
Message-ID: <20250915160819.140019-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is targeting libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git sha256_finup_2x-v2

This series adds support for 2-way interleaved SHA-256 hashing to
lib/crypto/, implements it for arm64 and x86_64, and makes fsverity use
it.  This significantly improves fsverity performance on many CPUs.

Later patches will make dm-verity use this optimization as well.

Changed in v2:
- Made the new arm64 assembly compatible with CONFIG_CPU_BIG_ENDIAN=y.
- Omitted sha256_finup_2x() from pre-boot environments.
- Made alloc_guarded_buf() assert that the allocation succeeded.
- Minor tweaks to comments and whitespace.

Eric Biggers (6):
  lib/crypto: sha256: Add support for 2-way interleaved hashing
  lib/crypto: arm64/sha256: Add support for 2-way interleaved hashing
  lib/crypto: x86/sha256: Add support for 2-way interleaved hashing
  lib/crypto: tests: Add tests and benchmark for sha256_finup_2x()
  fsverity: Remove inode parameter from fsverity_hash_block()
  fsverity: Use 2-way interleaved SHA-256 hashing when supported

 fs/verity/enable.c              |  12 +-
 fs/verity/fsverity_private.h    |   2 +-
 fs/verity/hash_algs.c           |   3 +-
 fs/verity/verify.c              | 175 ++++++++++++---
 include/crypto/sha2.h           |  28 +++
 lib/crypto/arm64/sha256-ce.S    | 284 +++++++++++++++++++++++-
 lib/crypto/arm64/sha256.h       |  37 ++++
 lib/crypto/sha256.c             |  71 +++++-
 lib/crypto/tests/sha256_kunit.c | 184 ++++++++++++++++
 lib/crypto/x86/sha256-ni-asm.S  | 368 ++++++++++++++++++++++++++++++++
 lib/crypto/x86/sha256.h         |  39 ++++
 11 files changed, 1147 insertions(+), 56 deletions(-)

base-commit: 54e7bb6ade8acd3fb1c486c9f3e2c0dfdc18f84e
-- 
2.51.0

