Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1842A24501B;
	Wed,  9 Jul 2025 20:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752091486; cv=none; b=VAR30ormGk568EaWGsRevHxEJCD7ONKj34W83fUGOLQa+zZrMYf1sdjoMy1eiahyV2V8vlAynsJ6Em0vmvaHXrfcdA5bWKSUufuOq/WCpyxtP5UCUme+9/XRFKiPvRRaHF7NcHviLeJD7O9sLk1AiSnNvDi8gCXRHqj0cKTls0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752091486; c=relaxed/simple;
	bh=0NJERX4km1ihHYR1feEIlLuY/ZLgfdKUXk/dQ3OI0g0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f4N5thYNxHdWNo3LSPGaClQ2fRy6IlWyEEIAo/SFVAIbbDWYDU7Be/RfNyAIFGxGTmgpa7ekLcXVxCWnTmMfJCFbW3L5KARIFaJNJzSTfZeMBtjgFquv6ctGllHiCp7KG7AHyIeYD3URFgBs7GQpGmA2HwTg1S0DIeccRxj11Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p4WoHZa5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p4WoHZa5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605B9C4CEEF;
	Wed,  9 Jul 2025 20:04:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752091485;
	bh=0NJERX4km1ihHYR1feEIlLuY/ZLgfdKUXk/dQ3OI0g0=;
	h=From:To:Cc:Subject:Date:From;
	b=p4WoHZa5UC0MsN/SeCSzFr75TE/n9xB3aybvUA11e3nKSEnkXyFrtAvwbMWtpfuqu
	 Uji53J/KSwGtVggCIzSiMK3G8Ex/PK/ZgMznebBmfIANaEksX2FBQuI/f3EzMgGI4a
	 rHrXkSJnOPqSULrHMZIpUw1PGGuADw3yIzXnWUmJFhY+KmmD4vsjexykteRF2AYqMR
	 e1jQLVf3kDYq0izhLrIjqa8B1+QZIwnE43wMMsJXOoXOY4hxgVLn4RHb07MjvvDwA7
	 w1/ViaGCLxFdHuA6Ys8OYE9tyXilJdN8KIiT0/L/1EzRqF1aBZ6eMegOWQAA7umDEU
	 1qBDa5Y+1DoMw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v5 0/4] KUnit tests for SHA-2 and Poly1305
Date: Wed,  9 Jul 2025 13:01:08 -0700
Message-ID: <20250709200112.258500-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is also available at:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-kunit-v5

This series adds the first KUnit tests for lib/crypto/, including tests
for SHA-2 and Poly1305.

Changed in v5:
- Moved hash_irq_test2_state from stack to heap
  (fixes https://lore.kernel.org/r/202507081257.9sV2D0Ys-lkp@intel.com)
- Replaced HRTIMER_MODE_REL with HRTIMER_MODE_REL_HARD to make hardirq
  context be used on CONFIG_PREEMPT_RT (fixes a WARN_ON_ONCE).
- Removed an unnecessary initialization in hash_irq_test2_func()
- Added comments that explain kconfig option naming
- Added link to Poly1305 paper

Changed in v4:
- Added Poly1305 tests.
- Split the addition of hash-test-template.h and gen-hash-testvecs.py
  into a separate patch.
- Added two more test cases to hash-test-template.h
  (test_hash_all_lens_up_to_4096 and test_hash_interrupt_context_2).
- Simplified test_hmac to use a single consolidated test vector.
- Lots of other cleanups.

Changed in v3:
- Split from SHA-512 and SHA-256 series, as per the request from Linus
  that the tests be kept last on the branch.

Eric Biggers (4):
  lib/crypto: tests: Add hash-test-template.h and gen-hash-testvecs.py
  lib/crypto: tests: Add KUnit tests for SHA-224 and SHA-256
  lib/crypto: tests: Add KUnit tests for SHA-384 and SHA-512
  lib/crypto: tests: Add KUnit tests for Poly1305

 lib/crypto/Kconfig                    |   2 +
 lib/crypto/Makefile                   |   2 +
 lib/crypto/tests/Kconfig              |  50 ++
 lib/crypto/tests/Makefile             |   5 +
 lib/crypto/tests/hash-test-template.h | 683 ++++++++++++++++++++++++++
 lib/crypto/tests/poly1305-testvecs.h  | 186 +++++++
 lib/crypto/tests/poly1305_kunit.c     | 165 +++++++
 lib/crypto/tests/sha224-testvecs.h    | 238 +++++++++
 lib/crypto/tests/sha224_kunit.c       |  39 ++
 lib/crypto/tests/sha256-testvecs.h    | 238 +++++++++
 lib/crypto/tests/sha256_kunit.c       |  39 ++
 lib/crypto/tests/sha384-testvecs.h    | 290 +++++++++++
 lib/crypto/tests/sha384_kunit.c       |  39 ++
 lib/crypto/tests/sha512-testvecs.h    | 342 +++++++++++++
 lib/crypto/tests/sha512_kunit.c       |  39 ++
 scripts/crypto/gen-hash-testvecs.py   | 147 ++++++
 16 files changed, 2504 insertions(+)
 create mode 100644 lib/crypto/tests/Kconfig
 create mode 100644 lib/crypto/tests/Makefile
 create mode 100644 lib/crypto/tests/hash-test-template.h
 create mode 100644 lib/crypto/tests/poly1305-testvecs.h
 create mode 100644 lib/crypto/tests/poly1305_kunit.c
 create mode 100644 lib/crypto/tests/sha224-testvecs.h
 create mode 100644 lib/crypto/tests/sha224_kunit.c
 create mode 100644 lib/crypto/tests/sha256-testvecs.h
 create mode 100644 lib/crypto/tests/sha256_kunit.c
 create mode 100644 lib/crypto/tests/sha384-testvecs.h
 create mode 100644 lib/crypto/tests/sha384_kunit.c
 create mode 100644 lib/crypto/tests/sha512-testvecs.h
 create mode 100644 lib/crypto/tests/sha512_kunit.c
 create mode 100755 scripts/crypto/gen-hash-testvecs.py

-- 
2.50.1

