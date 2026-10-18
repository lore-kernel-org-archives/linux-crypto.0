Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD6B392C2E
	for <linux-crypto@vger.kernel.org>; Sun, 18 Oct 2026 20:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792356565; cv=none; b=iG6MnWYAQpf3zv/xLhLuwFJNX0T5hId7uB6JuuzgYOEJzoViYz/zlAlPzaFTwxpqmcs5dca3JhOYD1jh7N29+E5p6qc/0cFYfeBGg+omeDpB6U1upiHYHm5m7GufujLykBS90eRyxExJTs+E91MDSdEadL2iGB7wvyW1z9htMn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792356565; c=relaxed/simple;
	bh=wHou9x6UiGBErwPyGkxPntMNQ2woKE9EZKybRLGqdjE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gS/JYn+0EN+S39W2AkmgLWIv/Fi8sW8NckVOin3KYHZai0unuRFccqM9iwC94dlKiPwSDtl5hhIBVjsZM7FFmxX5VT0t1zWm0bYPlHtapsJdGgBZOIo8/VSsB7iGK4bHK0pz8vZXm4DFTX4bWUSVaQSEc9AF8/KJBZ5q7fegggY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UApwDGg5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UApwDGg5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436471F000C4;
	Sun, 18 Oct 2026 20:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792356564;
	bh=gM+DuyzkQcAHHoVFl/TL6uA6ipp/O3iEnHwVJxZtAb0=;
	h=From:To:Cc:Subject:Date;
	b=UApwDGg5LPrarZ5WWWxjdQ52rEr2fyhBk5Vgtc1gPTPbWh5pjgl75S63yzzdSJAj9
	 pkDZOWIdk0xlqFxxZJpJNtRlNSJMtu5jPwMZ+TYq+6te8xr8Ld9TpL/mPlVAcj5jG6
	 5a1EVhKBl/M3WUEjaiXA7r/DTcZz6q1YMThsta2H1Tg82xIaTFL1YY2LGxVKeV+uoe
	 c3j2PgMRpLqE2fHW1UJCxuxEYhJuY965n89cLfhxiMkQppR4QRRyLENjUM17l247sy
	 xOa2NGY8i/2w4H+RV3dU6icZSEFC1h/ouVzNIzNsJatnKBhxyqIdfkDLUXChumKhwN
	 Lu8oKeaXjuheQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 00/14] crypto: Remove the unnecessary crypto_rng API
Date: Sun, 18 Oct 2026 13:46:04 -0700
Message-ID: <20261018204618.104876-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series applies to cryptodev/master commit 666d66df25253

The crypto_rng abstraction layer was designed as a generic interface for
random number generators.  However, it's now exclusively used to
implement a "NIST approved" RNG and the "jitterentropy" entropy
collector that supports it (for certification reasons).

Previously some hardware RNG drivers supported crypto_rng.  However,
that functionality was unused and just caused confusion, as it existed
alongside hw_random which is the interface that is actually used.

Reflecting this reality, this series removes crypto_rng and makes the
drbg and jitterentropy modules provide dedicated APIs directly.  This
simplifies the code, improves performance, and ensures that people don't
waste time implementing unused crypto_rng algorithms in drivers.

To make this work, update the users of crypto_rng accordingly:

- drbg.c now calls the jitterentropy API directly.

- __crypto_stdrng_get_bytes() now calls the DRBG API directly.

- algif_rng.c now calls the DRBG and jitterentropy APIs directly.

- The DRBG self-tests are moved from the testmgr to drbg.c itself, and
  the DRBG APIs are used directly.

The new implementation should comply with all the same certification
requirements it did before (which is the only reason this stuff exists
in the first place).  This includes, for example, running self-tests
before anything is used, and continuing to support CAVP testing via
AF_ALG when af_alg_restrict=0 (though a different UAPI should be defined
for that at some point).  If I missed anything, let me know.

Eric Biggers (14):
  crypto: drbg - Don't use uninitialized stack data
  crypto: rng - Remove unnecessary inclusions of internal/rng.h
  crypto: jitterentropy - Move health check to first use
  crypto: jitterentropy - Add library API
  crypto: drbg - Use jitterentropy library API
  crypto: drbg - Add library API
  crypto: drbg - Add self-test for library API
  crypto: algif_rng - Use DRBG and jitterentropy library APIs
  crypto: stdrng - Reimplement "stdrng" using direct DRBG calls
  crypto: drbg - Remove crypto_rng support
  crypto: jitterentropy - Remove crypto_rng support
  crypto: jitterentropy - Remove the kconfig prompt
  crypto: rng - Remove the rng algorithm type
  crypto: stdrng - Make crypto_stdrng_get_bytes() take size_t

 Documentation/crypto/api-rng.rst       |  17 --
 Documentation/crypto/api-samples.rst   |  37 ---
 Documentation/crypto/api.rst           |   1 -
 Documentation/crypto/architecture.rst  |   8 -
 crypto/Kconfig                         |  19 +-
 crypto/Makefile                        |   1 -
 crypto/algif_rng.c                     | 109 ++++++---
 crypto/crypto_user.c                   |   2 +-
 crypto/drbg-testvecs.h                 | 228 +++++++++++++++++
 crypto/drbg.c                          | 323 +++++++++++++++++--------
 crypto/drbg.h                          |  20 ++
 crypto/geniv.c                         |   2 +-
 crypto/jitterentropy-kcapi.c           | 158 ++++++------
 crypto/jitterentropy-kcapi.h           |  17 ++
 crypto/rng.c                           | 245 -------------------
 crypto/testmgr.c                       | 102 --------
 crypto/testmgr.h                       | 218 -----------------
 drivers/crypto/gemini/sl3516-ce-core.c |   1 -
 include/crypto/internal/rng.h          |  40 ---
 include/crypto/rng.h                   | 194 +--------------
 include/linux/crypto.h                 |   3 +-
 include/uapi/linux/cryptouser.h        |   3 +-
 22 files changed, 661 insertions(+), 1087 deletions(-)
 delete mode 100644 Documentation/crypto/api-rng.rst
 create mode 100644 crypto/drbg-testvecs.h
 create mode 100644 crypto/drbg.h
 create mode 100644 crypto/jitterentropy-kcapi.h
 delete mode 100644 crypto/rng.c
 delete mode 100644 include/crypto/internal/rng.h


base-commit: 666d66df25253070cb297cb920b0bcfcfe5eb871
-- 
2.56.0

