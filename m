Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8604919005E;
	Sun,  6 Jul 2025 23:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751844725; cv=none; b=N2pD8VLIFpvKcZ9jmvBA/w2WDkhjTaQcwKgoaDOGSW1iKUELn2aID+TGZSHB4vM9RoTcnNEqwY2xJx9FtULp4Cy3ZxGJ2X8xGUcz8TJEZgyKj7HKhkHYz6urcVYBPbtiYO43jcM/WvwnQTMYegJo4tyclng1wG12lPCizKVgBaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751844725; c=relaxed/simple;
	bh=0FWbnG7QyBNp1oI6at5H0KfJHP1RiWwGueRRH9I0rQA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hIsruB1m6VEfPB37Lij9pH4TlRO9rBjCdoEMjWabcLSwkQTSd/aoYyFqtJgAmEr+jqz+u3KLI1Iv2UqG7UO81BdpMwg3tVVh2Fh78j2mFeLc9itoxmhezMmwha3gng/gu8ko6YlumgIzLK33TxxukRkKaeVcO9cYSz+bQD9sJO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MReIxx3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MReIxx3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DF4C4CEED;
	Sun,  6 Jul 2025 23:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751844725;
	bh=0FWbnG7QyBNp1oI6at5H0KfJHP1RiWwGueRRH9I0rQA=;
	h=From:To:Cc:Subject:Date:From;
	b=MReIxx3c5U0V0PEN6qmIldU5ZLaa7fs7/P9TWin4tQB/xaxMlTuvOcyvk97KdrriR
	 036MrKhwraHyPzJNoXTl6OdsjNZTgl3NMVIplm3K9gylbKogoIV+im46/c9i5Gr8N+
	 mWuxKWQlyryHXtwwrP4LQsKCnqgDknwzUfLVwuAZ0pR3pQJ2HLpWVAW+LBCtRvqjjT
	 xpBD+DTD0c2CO4tdOwR29XG6qMMkIyg68pejp4Tg0aE7yclzAUCdyir0kvTU+VCxaG
	 4BCiVUdgHWRWcG8LTM9UzO4OoS+2cyq3pBLLnJ+HUtJiXgx+CQNsrWa77tlAwoiOml
	 PbqjAuyRQcqFA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v4 0/4] KUnit tests for SHA-2 and Poly1305
Date: Sun,  6 Jul 2025 16:28:13 -0700
Message-ID: <20250706232817.179500-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is also available at:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git libcrypto-kunit-v4

This series adds the first KUnit tests for lib/crypto/, including tests
for SHA-2 and Poly1305.

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
 lib/crypto/tests/Kconfig              |  46 ++
 lib/crypto/tests/Makefile             |   5 +
 lib/crypto/tests/hash-test-template.h | 680 ++++++++++++++++++++++++++
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
 scripts/crypto/gen-hash-testvecs.py   | 146 ++++++
 16 files changed, 2496 insertions(+)
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
2.50.0

