Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7BE1E89A;
	Mon, 15 Apr 2024 21:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713217129; cv=none; b=qhm83+h0NcBQIREmpvE40AikVJoIxKrmi1K+dXU4NEdA6To0z1GQvxFxrY0j57I9gT1ovNfLYStKlfiYrr/CR2Yep2otxJKwrL34q13QMCsCMvOwJluS4BVTktCVA+XjWUmjrZ40pN/qxLbmhfRiIO0nsPHmVvDANsBx5L7tCQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713217129; c=relaxed/simple;
	bh=LdgSzKnyi2LWa7e/BgfjAMFoEXu5VqKaRa128bZAOp8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AL3UW5K4YxNtNkRr4Fpu1PXYn9rA0hL93Bsh4mruQhPtVBa1mBEJ1myQEEhmPwKO04cigYwtfwSW5tujLz+V0VFz5S5ySK/bnXAH64vRBiVsWLUFsAKg7PdWYjdhfEdcVdQ9b3z2GGjQhDTzCfio8DH68uTcl3naoCcSzpVkKS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYIF4/rv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYIF4/rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44054C113CC;
	Mon, 15 Apr 2024 21:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713217128;
	bh=LdgSzKnyi2LWa7e/BgfjAMFoEXu5VqKaRa128bZAOp8=;
	h=From:To:Cc:Subject:Date:From;
	b=EYIF4/rvgnLfiMR2HZGkvI551MKvMeaAR/vQxBnQ5XW3GsGPKwIn3OsHIbDBZWPc2
	 cb1hR4kA8L1bkTeoI+UTGiD2P2yzHigmynE+mzEAoIwWaVeE0Y44Ke/A3xpGC/fHyz
	 UfW5riqyKkwdCNsth7fWbWJx1UCFVa0MLS5YCInSFtBg7BqQpeI7SOxkUnlSGi/UOj
	 Km8ka2Hu1+am5WCkwOPXmV069RNxnCtewxPkbBNpFqn3S4b//3GAxJJIfht6Infaef
	 k/F5TcY1KCjH8QjO2ZUmYKOnI5yO6tGT1Sev2Orm4QEGXvJc1ME4s0Emiz7Q8U8VoU
	 tGfUAVPd+NBIQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev
Cc: x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: [RFC PATCH 0/8] Optimize dm-verity and fsverity using multibuffer hashing
Date: Mon, 15 Apr 2024 14:37:11 -0700
Message-ID: <20240415213719.120673-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.44.0
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
synchronous API for hashing two equal-length messages.

This works well for dm-verity and fsverity, which use Merkle trees and
therefore hash large numbers of equal-length messages.

This patchset is organized as follows:

- Patch 1-3 add crypto_shash_finup2x() and tests for it.
- Patch 4-5 implement finup2x on x86_64 and arm64.
- Patch 6-8 update fsverity and dm-verity to use crypto_shash_finup2x()
  to hash pairs of data blocks when possible.  Note: the patch
  "dm-verity: hash blocks with shash import+finup when possible" is
  revived from its original submission
  (https://lore.kernel.org/dm-devel/20231030023351.6041-1-ebiggers@kernel.org/)
  because this new work provides a new motivation for it.

On CPUs that support multiple concurrent SHA-256's (all arm64 CPUs I
tested, and AMD Zen CPUs), raw SHA-256 hashing throughput increases by
82-98%, and the throughput of cold-cache reads from dm-verity and
fsverity increases by very roughly 35%.

This is marked as RFC for now, as I'm soliciting feedback on the overall
concept, and some parts may need a bit more work.  The dm-verity and
fsverity patches are a bit large and I may try to split those up.

Eric Biggers (8):
  crypto: shash - add support for finup2x
  crypto: testmgr - generate power-of-2 lengths more often
  crypto: testmgr - add tests for finup2x
  crypto: x86/sha256-ni - add support for finup2x
  crypto: arm64/sha256-ce - add support for finup2x
  fsverity: improve performance by using multibuffer hashing
  dm-verity: hash blocks with shash import+finup when possible
  dm-verity: improve performance by using multibuffer hashing

 arch/arm64/crypto/sha2-ce-core.S    | 261 ++++++++++++-
 arch/arm64/crypto/sha2-ce-glue.c    |  40 ++
 arch/x86/crypto/sha256_ni_asm.S     | 352 +++++++++++++++++
 arch/x86/crypto/sha256_ssse3_glue.c |  40 ++
 crypto/testmgr.c                    |  59 ++-
 drivers/md/dm-verity-fec.c          |  31 +-
 drivers/md/dm-verity-fec.h          |   7 +-
 drivers/md/dm-verity-target.c       | 560 ++++++++++++++++++++--------
 drivers/md/dm-verity.h              |  43 +--
 fs/verity/fsverity_private.h        |   5 +
 fs/verity/hash_algs.c               |  31 +-
 fs/verity/open.c                    |   6 +
 fs/verity/verify.c                  | 177 +++++++--
 include/crypto/hash.h               |  34 ++
 14 files changed, 1403 insertions(+), 243 deletions(-)


base-commit: 0bbac3facb5d6cc0171c45c9873a2dc96bea9680
-- 
2.44.0

