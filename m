Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A1030FC37;
	Wed, 25 Feb 2026 20:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772051412; cv=none; b=r4KxPqBFtBr4l7SprzSyScgAiGsxbjig3YIzGgcul6PokZnxfaqR/ooBejoJZPFJHzvPPiJvL0d7AeUAN4/34Tyb08i1pCAENbjnW1qedtF4Qlzru5rW9hG5SgOR7xVmc2zBzeBQYlj7+rfuz4jwXRWW01juznpTAiW1qh29PzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772051412; c=relaxed/simple;
	bh=4jnbcmael5qBgaF1gqxkO853WBkZDyaOLTkDkyFGMLA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A2dltvbgdj4If67HUVU7z7BySgnYotxjZ0gtuIPURIMarq+yDvDD0IrCF3EevEVFmUskfuLjW9j4WDysYDz8fR9ShQ3DYvoOuTaFXF+h0+npsYK/u/ed1ef+2xrw4avqPlCqVArH6e1MEdV9b6Pz+IF0fwbRmj9NJgmh1674EBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=Lxsmc7YD; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=jBPawLHR; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="Lxsmc7YD";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="jBPawLHR"
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1772051376; bh=My9u5birv1kH34rIhZEQUrP
	wuoM51T+G223wO8ZqYNs=; b=Lxsmc7YDX2A3i4xpr5PL8ZQ+c5pJlMNP8HRqzWLni9CjvbzoSt
	8Nn1VHcpAs08pSyMhoM2AisVRUGkQiWeMK3ovwdJgB01UnifCrtiGf4hUvtzdfoEXk1ReRtGzaI
	h+RwkIp1tl9D3acsuvazTNzv/rEmb2JnNNWnrkJFfbzYUn3av2mlEDRJPyTFgtBls1v+I189CE9
	5uR47P0xn1sh5o6WEo2nM5JOc6o2/wJeznnbWn/46NGoaHUAs8Qzkg1z6DqQQgH54fyIvfbsWD8
	wiPiQwP7zag+fnaowd7WRuNvzf6/lQvdguWc7vpTJLm2Gtcq0fe5qfkbm66CM3L0kXQ==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Date:Subject:To:From; t=1772051376; bh=My9u5birv1kH34rIhZEQUrP
	wuoM51T+G223wO8ZqYNs=; b=jBPawLHRybL34wukcf5AN8AQfTgFJwRCelnwp5fYh9LoTACZfG
	53TxW/fX0CtAd/xpAyLuw9R9WelHmdzWi5CA==;
From: Daniel Hodges <git@danielhodges.dev>
To: bpf@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: ast@kernel.org,
	andrii@kernel.org,
	daniel@iogearbox.net,
	vadim.fedorenko@linux.dev,
	song@kernel.org,
	yatsenko@meta.com,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	haoluo@google.com,
	jolsa@kernel.org,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	yonghong.song@linux.dev,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	Daniel Hodges <git@danielhodges.dev>
Subject: [PATCH bpf-next v8 0/4] Add cryptographic hash and signature verification kfuncs to BPF
Date: Wed, 25 Feb 2026 15:29:31 -0500
Message-ID: <20260225202935.31986-1-git@danielhodges.dev>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch series enhances BPF's cryptographic functionality by introducing
kernel functions for SHA hashing and ECDSA signature verification. The changes
enable BPF programs to verify data integrity and authenticity across
networking, security, and observability use cases.

The series addresses two gaps in BPF's cryptographic toolkit:

1. Cryptographic hashing - supports content verification and message digest
   preparation
2. Asymmetric signature verification - allows validation of signed data
   without requiring private keys in the datapath

Use cases include:
- Verifying signed network packets or application data in XDP/TC programs
- Integrity checks within tracing and security monitoring
- Zero-trust security models with BPF-based credential verification
- Content-addressed storage in BPF-based filesystems

The implementation leverages existing BPF patterns: it uses bpf_dynptr for
memory safety, reuses kernel crypto libraries (lib/crypto/sha256.c and
crypto/ecdsa.c) rather than reimplementing algorithms, and provides
context-based APIs supporting multiple program types.

v1: https://lore.kernel.org/bpf/20251117211413.1394-1-git@danielhodges.dev/

v2: https://lore.kernel.org/bpf/20251205173923.31740-1-git@danielhodges.dev/
- Fixed redundant __bpf_dynptr_is_rdonly() checks (Vadim)
- Added BPF hash algorithm type registration module in crypto/ subsystem
- Added CONFIG_CRYPTO_HASH2 guards around bpf_crypto_hash() kfunc and its
  BTF registration, matching the pattern used for CONFIG_CRYPTO_ECDSA
- Added mandatory digestsize validation for hash operations

v3: https://lore.kernel.org/bpf/20251208030117.18892-1-git@danielhodges.dev/
- Fixed patch ordering - header changes now in separate first commit before
  crypto module to ensure bisectability (bot+bpf-ci)
- Fixed type mismatch - changed u32 to u64 for dynptr sizes in
  bpf_crypto_hash() to match __bpf_dynptr_size() return type (Mykyta)
- Added CONFIG_CRYPTO_ECDSA to selftest config (Song)
- Refactored test code duplication with setup_skel() helper (Song)
- Added copyright notices to all new files

v4: https://lore.kernel.org/bpf/20260105173755.22515-1-git@danielhodges.dev/
- Reused common bpf_crypto_ctx structure for hash and signature operations
  instead of separate context types (Song)
- Fixed integer truncation in bpf_crypto_hash when data_len > UINT_MAX
- Corrected KF_RCU flags for ECDSA kfuncs (only bpf_ecdsa_verify needs KF_RCU)
- Updated MAINTAINERS file in test patches
- Refactored selftests to use crypto_common.h for kfunc declarations

v5: https://lore.kernel.org/bpf/20260120184701.23082-1-git@danielhodges.dev/
- Fixed bisectability: moved bpf_crypto_type_id enum and type_id field
  introduction to the hash module commit, before it's used by hash kfunc
- Renamed kfuncs from bpf_ecdsa_* to bpf_sig_* since signature verification
  is not ECDSA-specific (Vadim)
- Added NULL checks in bpf_crypto_sig wrapper functions for optional
  digest_size and max_size callbacks to prevent NULL pointer dereference
- Added extra validation in bpf_sig_digestsize/bpf_sig_maxsize kfuncs to
  return -EOPNOTSUPP when underlying algorithm returns 0
- Renamed test files from ecdsa_verify to sig_verify for consistency

v6: https://lore.kernel.org/bpf/20260124174349.16861-1-git@danielhodges.dev/
- Fixed bisectability issue flagged by CI: squash hash module and hash kfunc
  commits so NULL checks in bpf_crypto_ctx_create() are present before the
  hash type is registered (bot+bpf-ci)
- Squash signature module and signature kfunc commits for the same reason
- This reduces the series from 7 to 4 commits while preserving all functionality
- Added type_id checks to bpf_crypto_encrypt() and bpf_crypto_decrypt() to
  prevent NULL pointer dereference when called with non-skcipher contexts

v7: https://lore.kernel.org/bpf/20260202144749.22932-1-git@danielhodges.dev/
- Moved crypto/bpf_crypto_skcipher.c type_id assignment from signature patch
  to hash patch for better logical organization
- Added missing CONFIG_CRYPTO_SIG, CONFIG_CRYPTO_SIG2, CONFIG_CRYPTO_ECDSA,
  and CONFIG_CRYPTO_ECRDSA to selftest config to ensure signature verification
  tests can build properly

v8:
- Fixed bpf_sig_keysize() documentation to correctly state return value is
  in bits, not bytes, matching the underlying crypto_sig_keysize() API
  (bot+bpf-ci)

Daniel Hodges (4):
  bpf: Add hash kfunc for cryptographic hashing
  selftests/bpf: Add tests for bpf_crypto_hash kfunc
  bpf: Add signature verification kfuncs
  selftests/bpf: Add tests for signature verification kfuncs

 MAINTAINERS                                   |   6 +
 crypto/Makefile                               |   6 +
 crypto/bpf_crypto_shash.c                     |  96 ++++++
 crypto/bpf_crypto_sig.c                       |  89 ++++++
 crypto/bpf_crypto_skcipher.c                  |   1 +
 include/linux/bpf_crypto.h                    |  13 +
 kernel/bpf/crypto.c                           | 210 ++++++++++++-
 tools/testing/selftests/bpf/config            |   6 +
 .../selftests/bpf/prog_tests/crypto_hash.c    | 210 +++++++++++++
 .../selftests/bpf/prog_tests/sig_verify.c     | 163 ++++++++++
 .../selftests/bpf/progs/crypto_common.h       |   8 +
 .../testing/selftests/bpf/progs/crypto_hash.c | 231 ++++++++++++++
 .../testing/selftests/bpf/progs/sig_verify.c  | 286 ++++++++++++++++++
 13 files changed, 1316 insertions(+), 9 deletions(-)
 create mode 100644 crypto/bpf_crypto_shash.c
 create mode 100644 crypto/bpf_crypto_sig.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/crypto_hash.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sig_verify.c
 create mode 100644 tools/testing/selftests/bpf/progs/crypto_hash.c
 create mode 100644 tools/testing/selftests/bpf/progs/sig_verify.c

--
2.52.0

