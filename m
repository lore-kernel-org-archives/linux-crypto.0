Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64929622;
	Tue,  7 May 2024 00:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715041516; cv=none; b=I/VPT+fidbITC8gjaT1WbVjopR4RE2xBCDGXSdGNrAdnGTd02Nm/oVS7oh64wizqT+685s/S4iDB2cz9679F+rz2pw3rX2ujGXJ4KqhXra4zRU89apS23XJ+bzG24Yn7663MMziu5tfyqmjN8/9AA/1lEjqYu5HYk6jYqpuAJ+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715041516; c=relaxed/simple;
	bh=s7eBMIDMnKUPCUXSt92sBihifomPay5rghqvBJKTjqk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Ta5mrlH5WXhZmsjp/azLgZhWNN6mSPCKV6eDRTw6PXwn3sQ2A0p72b98kGq/odTK567Lo9FGB6BQ28/vak7EZCf1Fc1FwuNRSnI/Yc/Vlu5pQ02rRoz3ptMXnbLCaG7wORXtEG+5GE5L7kMk0a6zvIv9bX6CmC350FFnRFGAL+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DKFHtSIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DKFHtSIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A76A4C116B1;
	Tue,  7 May 2024 00:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715041515;
	bh=s7eBMIDMnKUPCUXSt92sBihifomPay5rghqvBJKTjqk=;
	h=From:To:Cc:Subject:Date:From;
	b=DKFHtSIzwCtggFmwgVNyvFpYLdhnLcCxCQPuHNK4a5PxuijN0Tf6AHz/0noYtG9zT
	 Sep4DM7tMwaUOrbZ2Y0DXhUnEj9pEQrOiLsUgwYqbdqyy68jNRYkiXAUbEhA7xdlWK
	 87vSxjbRIGh8Dy4R9dJemz3OEvcFshe9IO1vvZhPdDFkLOA8ZLt1nETEcIU+4GR7vr
	 Se2KmaAfUIuXOKDb++oC/wCPx95eOeedCLoVNxISpFpggzYzqd1hvRfFMuUN8W76MX
	 uzr43qdjXmKCsMS0g9OvUD3bTNBsacI09UjVD+h8EbxupBl7M+NjbDEcXgYn5HP19C
	 pdKq/AIJhz7PA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/8] Optimize dm-verity and fsverity using multibuffer hashing
Date: Mon,  6 May 2024 17:23:35 -0700
Message-ID: <20240507002343.239552-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On many modern CPUs, it is possible to compute the SHA-256 hash of two
equal-length messages in about the same time as a single message, if all
the instructions are interleaved.  This is because each SHA-256 (and
also most other cryptographic hash functions) is inherently serialized
and therefore can't always take advantage of the CPU's full throughput.

An earlier attempt to support multibuffer hashing in Linux was based
around the ahash API.  That approach had some major issues.  This
patchset instead takes a much simpler approach of just adding a
synchronous API for hashing equal-length messages.

This works well for dm-verity and fsverity, which use Merkle trees and
therefore hash large numbers of equal-length messages.

This patchset is organized as follows:

- Patch 1-3 add crypto_shash_finup_mb() and tests for it.
- Patch 4-5 implement finup_mb on x86_64 and arm64, using an
  interleaving factor of 2.
- Patch 6-8 update fsverity and dm-verity to use crypto_shash_finup_mb()
  to hash pairs of data blocks when possible.  Note: the patch
  "dm-verity: hash blocks with shash import+finup when possible" is
  revived from its original submission
  (https://lore.kernel.org/dm-devel/20231030023351.6041-1-ebiggers@kernel.org/)
  because this new work provides a new motivation for it.

On CPUs that support multiple concurrent SHA-256's (all arm64 CPUs I
tested, and AMD Zen CPUs), raw SHA-256 hashing throughput increases by
70-98%, and the throughput of cold-cache reads from dm-verity and
fsverity increases by very roughly 35%.

Changed in v3:
  - Change API from finup2x to finup_mb.  It now takes arrays of data
    buffer and output buffers, avoiding hardcoding 2x in the API.

Changed in v2:
  - Rebase onto cryptodev/master
  - Add more comments to assembly
  - Reorganize some of the assembly slightly
  - Fix the claimed throughput improvement on arm64
  - Fix incorrect kunmap order in fs/verity/verify.c
  - Adjust testmgr generation logic slightly
  - Explicitly check for INT_MAX before casting unsigned int to int
  - Mention SHA3 based parallel hashes
  - Mention AVX512-based approach

Eric Biggers (8):
  crypto: shash - add support for finup_mb
  crypto: testmgr - generate power-of-2 lengths more often
  crypto: testmgr - add tests for finup_mb
  crypto: x86/sha256-ni - add support for finup_mb
  crypto: arm64/sha256-ce - add support for finup_mb
  fsverity: improve performance by using multibuffer hashing
  dm-verity: hash blocks with shash import+finup when possible
  dm-verity: improve performance by using multibuffer hashing

 arch/arm64/crypto/sha2-ce-core.S    | 281 +++++++++++++-
 arch/arm64/crypto/sha2-ce-glue.c    |  40 ++
 arch/x86/crypto/sha256_ni_asm.S     | 368 ++++++++++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c |  39 ++
 crypto/shash.c                      |  60 +++
 crypto/testmgr.c                    |  91 ++++-
 drivers/md/dm-verity-fec.c          |  31 +-
 drivers/md/dm-verity-fec.h          |   7 +-
 drivers/md/dm-verity-target.c       | 563 ++++++++++++++++++++--------
 drivers/md/dm-verity.h              |  43 +--
 fs/verity/fsverity_private.h        |   5 +
 fs/verity/hash_algs.c               |  32 +-
 fs/verity/open.c                    |   6 +
 fs/verity/verify.c                  | 177 +++++++--
 include/crypto/hash.h               |  45 ++-
 15 files changed, 1543 insertions(+), 245 deletions(-)


base-commit: ed265f7fd9a635d77c8022fc6d9a1b735dd4dfd7
-- 
2.45.0

