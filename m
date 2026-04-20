Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892D015746F;
	Mon, 20 Apr 2026 06:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667019; cv=none; b=NuWQzjumD4eFZ5KYUuzCFam/wuM+cTzTqyx5zoNyjcOiT84tgrApd6+WWGnnkbGAxj2Bmvomzlbv1mj8nHFArg6xveiOOis0MeJYqvDgP5q4vLy8ssnCb9r3yQLGjKQc8I65o2Qdx6ZMfkNF+YePnSXb8tba79XUu1dMvAJW3S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667019; c=relaxed/simple;
	bh=eZIwjHTsAauKCfGAhduPaCDbK+KjBCoZ4p7G23eZu6U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C3pXMkZ3LsbxF9qJQ8HhyB8dlQlUBhUdDkKbZ40DeYi+i0o0THt40aVKnIGjJrYF488tzaFOHHDKsZnfUqElpsbLL1K4HvrEi0x3o1V4TbFzL2kdMiW/3pn1JOxUv3SNj33RJ48IX/LYv0xXTaHiXuc15upiOnE1mhNYv2z8pp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FOsT7BQ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FOsT7BQ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50CCC19425;
	Mon, 20 Apr 2026 06:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667019;
	bh=eZIwjHTsAauKCfGAhduPaCDbK+KjBCoZ4p7G23eZu6U=;
	h=From:To:Cc:Subject:Date:From;
	b=FOsT7BQ+/9NUMGqg9/6JqpkxnT/Q1XKaySeK5Pe8olQPdvef+fLGKiAfbMUyqrlQm
	 yGGFnHsGhUD3TF+eHMuDCmafdMRLNu321Hj6xGelzfQ/7SQXQ+YkoCHKRIx1jqZ2Pb
	 eBRdg0Y5ytKW+j+zoNpq4qz5GKV1KP3QuU6/bJfogpDy79KBK935T2vHwJGD46dC/h
	 N5mMzyYvt39QeUmvsSsBHJueNzu1Zn2tg885787aOe74QMdfRi5g1rqrObRBNe82sw
	 1tx5P8eREy7Livk2M3RF4JgJBr/CEhsVcWN4ObwN7j4HASyOcbalIKVeoNJHXVtN1k
	 sVeIEMUh4mTlw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 00/38] Fix and simplify the NIST DRBG implementation
Date: Sun, 19 Apr 2026 23:33:44 -0700
Message-ID: <20260420063422.324906-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is intended to be taken through the cryptodev tree.  It can
also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git drbg-v1

This series fixes and greatly simplifies crypto/drbg.c, i.e. the
kernel's implementation of NIST SP800-90A.  This code isn't normally
used, but it's sometimes used by people doing FIPS 140-3 certifications.

Note: this series is *not* meant to encourage using this code over
random.c.  In fact, my recent commit 65b3c2f627851639 made "normal"
systems stop using this code.  It's just that the reality is that this
is in the kernel tree, it's been there for many years, and people are
using it to get FIPS 140-3 certifications.  As long as that's the case,
it might as well be fixed up and simplified.  Another reason to simplify
this as much as possible is that for historical reasons it's accessible
to unprivileged users via AF_ALG (even though it shouldn't be).  So I do
think this is a clear step forwards, regardless of level of enthusiasm
for FIPS, especially considering the massively negative diffstat.

Patches 1-5 begin with some bug fixes.  Fixes for CTR_DRBG and HASH_DRBG
are included, despite that code being removed later in the series, so
that they can be backported (though that is likely unused code anyway).

Patches 6-11 do some initial cleanups.

Patches 12-17 clean up the museum of DRBG variants to just support the
HMAC-SHA512 DRBG only, dropping support for the others.  This is already
the default variant, it makes sense that it's the default, and it's
probably the only one actually being used on current kernels.  In any
case, supporting more than one is pretty pointless.  See the patches for
more details about why it makes sense to keep using this one.

Patches 18-33 contain many more cleanups, including switching from the
crypto_shash API to the crypto library.

Patch 34 is a significant one: it starts adding 32 bytes from
get_random_bytes() to every additional input string.  This is to work
around the forward secrecy bug described in Woodage & Shumow (2018)
(https://eprint.iacr.org/2018/349.pdf), and to ensure that random.c
reseeds are actually reflected in drbg.c.  Of course, for FIPS 140-3
this is irrelevant, but this is the right thing to do in practice, and
it should make drbg.c quite a bit more robust in practice.  (This isn't
particularly novel, either; BoringSSL does essentially this same thing.)

Patches 35-38 are some further cleanups, including some tweaks to when
the formal reseeding happens.

Note: while the primary goal of this series is to fix and simplify this
code, this series is also intended to preserve the FIPS 140-3
"certifiable" property of crypto/drbg.c.  I.e. after this series, it
should still be possible to get a FIPS 140-3 certification that covers
it.  In fact it should become quite a bit easier, since there will be
only one DRBG variant to worry about and the code will be much more
straightforward.  If there's anything I missed, let me know.

Eric Biggers (38):
  crypto: drbg - Fix returning success on failure in CTR_DRBG
  crypto: drbg - Fix misaligned writes in CTR_DRBG and HASH_DRBG
  crypto: drbg - Fix ineffective sanity check
  crypto: drbg - Fix drbg_max_addtl() on 64-bit kernels
  crypto: drbg - Fix the fips_enabled priority boost
  crypto: drbg - Remove always-enabled symbol CRYPTO_DRBG_HMAC
  crypto: drbg - Remove broken commented-out code
  crypto: drbg - Remove unhelpful helper functions
  crypto: drbg - Remove obsolete FIPS 140-2 continuous test
  crypto: drbg - Fold include/crypto/drbg.h into crypto/drbg.c
  crypto: drbg - Remove import of crypto_cipher functions
  crypto: drbg - Remove support for CTR_DRBG
  crypto: drbg - Remove support for HASH_DRBG
  crypto: drbg - Flatten the DRBG menu
  crypto: testmgr - Add test for drbg_pr_hmac_sha512
  crypto: testmgr - Update test for drbg_nopr_hmac_sha512
  crypto: drbg - Remove support for HMAC-SHA256 and HMAC-SHA384
  crypto: drbg - Simplify algorithm registration
  crypto: drbg - De-virtualize drbg_state_ops
  crypto: drbg - Move fixed values into constants
  crypto: drbg - Embed V and C into struct drbg_state
  crypto: drbg - Use HMAC-SHA512 library API
  crypto: drbg - Remove drbg_core
  crypto: drbg - Install separate seed functions for pr and nopr
  crypto: drbg - Move module aliases to end of file
  crypto: drbg - Consolidate "instantiate" logic and remove
    drbg_state::C
  crypto: drbg - Eliminate use of 'drbg_string' and lists
  crypto: drbg - Simplify drbg_generate_long() and fold into caller
  crypto: drbg - Put rng_alg methods in logical order
  crypto: drbg - Fold drbg_instantiate() into drbg_kcapi_seed()
  crypto: drbg - Separate "reseed" case in drbg_kcapi_seed()
  crypto: drbg - Fold drbg_prepare_hrng() into drbg_kcapi_seed()
  crypto: drbg - Simplify "uninstantiate" logic
  crypto: drbg - Include get_random_bytes() output in additional input
  crypto: drbg - Change DRBG_MAX_REQUESTS to 4096
  crypto: drbg - Remove redundant reseeding based on random.c state
  crypto: drbg - Clean up generation code
  crypto: drbg - Clean up loop in drbg_hmac_update()

 Documentation/crypto/api-samples.rst          |    2 +-
 Documentation/crypto/userspace-if.rst         |    2 +-
 arch/m68k/configs/amiga_defconfig             |    2 -
 arch/m68k/configs/apollo_defconfig            |    2 -
 arch/m68k/configs/atari_defconfig             |    2 -
 arch/m68k/configs/bvme6000_defconfig          |    2 -
 arch/m68k/configs/hp300_defconfig             |    2 -
 arch/m68k/configs/mac_defconfig               |    2 -
 arch/m68k/configs/multi_defconfig             |    2 -
 arch/m68k/configs/mvme147_defconfig           |    2 -
 arch/m68k/configs/mvme16x_defconfig           |    2 -
 arch/m68k/configs/q40_defconfig               |    2 -
 arch/m68k/configs/sun3_defconfig              |    2 -
 arch/m68k/configs/sun3x_defconfig             |    2 -
 arch/mips/configs/decstation_64_defconfig     |    2 -
 arch/mips/configs/decstation_defconfig        |    2 -
 arch/mips/configs/decstation_r4k_defconfig    |    2 -
 crypto/Kconfig                                |   40 +-
 crypto/df_sp80090a.c                          |    8 +-
 crypto/drbg.c                                 | 1800 +++--------------
 crypto/testmgr.c                              |  143 +-
 crypto/testmgr.h                              | 1262 ++++--------
 drivers/crypto/xilinx/xilinx-trng.c           |    1 -
 include/crypto/df_sp80090a.h                  |   25 +
 include/crypto/drbg.h                         |  263 ---
 include/crypto/internal/drbg.h                |   54 -
 .../crypto/chacha20-s390/test-cipher.c        |    1 -
 27 files changed, 728 insertions(+), 2903 deletions(-)
 delete mode 100644 include/crypto/drbg.h
 delete mode 100644 include/crypto/internal/drbg.h


base-commit: c1f49dea2b8f335813d3b348fd39117fb8efb428
-- 
2.53.0

