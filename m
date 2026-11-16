Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794810849;
	b=VRrm+we8HilH2AAUD8tD1fsOJmJEh++ztJa/vrC6zZ0XJ4Ccu0Nehl8PVHtdewy5nd6p
	 8JTLSRgb6+TQrOIPYDl8EWTjJjE3Svs5coWEmdOkEo3xbUj1oyAel6a4RhoS01ZILvPHF
	 UMJOdZ2J960mLgqef7rLMcGn/caDoRuTOKAnK7EBDPT4FbeppSUK7qpBjXYVSgU2Lnjl+
	 y4Mces6IOb/LGc/xRCsohuQuT5/OT1gWNqt9lYpj3OEHi8XfjenKcyCnxZaXao+X9BT3s
	 JRyZAGvWfGPcjASo9nNkRMG1A7c1Xw3r8rlLkgv9Jg79o/BvnOJORwQAdeqyESP2eeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794810849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3Iz2R5IC2knVv8D8jDr5uaacvb/CEa3oJZo2XHnTD4k=;
	b=XbDZelUkxK/cR1kMdBnCCbDzQMwfV3M+na6BL+zLlr2Mjsqmckj3WohsDsNuhho6u8ao
	 w+kAA2Sc2Ot917ADbpi/h5EoqBqWBmTXx5SUKrHKToyx9Tqzsm5cBesg5XK0nITq1mHp+
	 5lEoHYB1wzuCcT+9XfxqqcyXxza2PuuU1Gk/4TrpLOaISIxVX9IqPoD8ky9CGwg4GKy34
	 dLrGMOtapz5O6CsCaXYh/UAGH/YhzJ2kPKZLNPivTge8aPO/UJM8hTDK6y/1jstRRDZXe
	 SxMJTz7SseJ2iL+rEncPQ8AcGhhkJDPOmTEH1FxSZbG6uSw3m9YGCQX159yEcHqvsyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AnL29uOA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D37606A31C
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 06:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AnL29uOA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64CAD1F000C4;
	Mon, 16 Nov 2026 06:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794810848;
	bh=3Iz2R5IC2knVv8D8jDr5uaacvb/CEa3oJZo2XHnTD4k=;
	h=From:To:Cc:Subject:Date;
	b=AnL29uOAlpgoLUKHanytJkYr3Zb6NOk+YCoA7r5hzhYOrJR774Sy8pOgdNpz4t2iY
	 iDv2pVnyhujFcgGwbVfperGcihO+PPxeTpOyZJWaYbES+7Bc6K22OacgnV8uQX4oee
	 l7YzxXq1QvmNC7rIHGuEH/tAOqFi0+x5zR4OnqTBaLNs2iPKZ2we86bsy3QOkpy33g
	 v9IbvNaRucOHOj6egdFQhOJEFbTDrYjVa+JXLDY/HsLogfS50gLxihbCfNwFEZAOQu
	 ossBTp82Q6CbwKTVAXFI2z+LQMpxW4gEAq1ChlsiK22BX+4HNviLofLEC0Me4ec4mC
	 I/QsLIW5vlXow==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/7] lib/crypto: KUnit tests for unauthenticated AES modes
Date: Sun, 15 Nov 2026 22:28:42 -0800
Message-ID: <20261116062849.1071038-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series applies to libcrypto-next.  It can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git aes-kunit-v1

This series adds comprehensive KUnit test suites for the remaining AES
modes that got new library APIs in v7.3: AES-ECB, AES-CBC, AES-CBC-CTS,
AES-CTR, AES-XCTR, and AES-XTS.

Most of the test code is placed in a common header file, like it is in
many of the existing tests.

Eric Biggers (7):
  lib/crypto: tests: Add skcipher-test-template.h and
    gen-skcipher-testvecs.py
  lib/crypto: tests: Add KUnit test suite for AES-ECB
  lib/crypto: tests: Add KUnit test suite for AES-CBC
  lib/crypto: tests: Add KUnit test suite for AES-CBC-CTS
  lib/crypto: tests: Add KUnit test suite for AES-CTR
  lib/crypto: tests: Add KUnit test suite for AES-XCTR
  lib/crypto: tests: Add KUnit test suite for AES-XTS

 lib/crypto/.kunitconfig                   |    4 +
 lib/crypto/tests/Kconfig                  |   36 +
 lib/crypto/tests/Makefile                 |    4 +
 lib/crypto/tests/aead-test-template.h     |   67 +-
 lib/crypto/tests/aes_cbc_cts_kunit.c      |  239 ++++
 lib/crypto/tests/aes_cbc_kunit.c          |  137 +++
 lib/crypto/tests/aes_ctr_kunit.c          |  196 ++++
 lib/crypto/tests/aes_ecb_kunit.c          |  227 ++++
 lib/crypto/tests/aes_xctr_kunit.c         |  149 +++
 lib/crypto/tests/aes_xts_kunit.c          |  365 ++++++
 lib/crypto/tests/skcipher-test-template.h | 1241 +++++++++++++++++++++
 lib/crypto/tests/sp800-38a-data.h         |   36 +
 lib/crypto/tests/test-utils.h             |   25 +
 scripts/crypto/gen-skcipher-testvecs.py   |  167 +++
 14 files changed, 2846 insertions(+), 47 deletions(-)
 create mode 100644 lib/crypto/tests/aes_cbc_cts_kunit.c
 create mode 100644 lib/crypto/tests/aes_cbc_kunit.c
 create mode 100644 lib/crypto/tests/aes_ctr_kunit.c
 create mode 100644 lib/crypto/tests/aes_ecb_kunit.c
 create mode 100644 lib/crypto/tests/aes_xctr_kunit.c
 create mode 100644 lib/crypto/tests/aes_xts_kunit.c
 create mode 100644 lib/crypto/tests/skcipher-test-template.h
 create mode 100644 lib/crypto/tests/sp800-38a-data.h
 create mode 100755 scripts/crypto/gen-skcipher-testvecs.py


base-commit: 84abb955b1015477aa11a96e2f3ac1b938b77f48
-- 
2.56.1

