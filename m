Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B743BF665;
	Wed, 15 Jul 2026 22:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784153563; cv=none; b=QH9FHHQORsyANfFnb9NpgKp/KY0IPYbzM/Qlz+65vNNP/Xu4ghZJajNUN5N6BDmSgQfknpru/Unwik0I/JDWyMd/7Ma+Lx3xWwG05/SWwEXINMSOqc7Sycns1lPgWWHZEWVoWk6lzZgUoNlW+qjk8AdvNQtBO9u75fjIBdAUnSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784153563; c=relaxed/simple;
	bh=n4BMDwtNJWHLs7n1sOrIocBZ+k5sxvGhDqWr8n0Aotw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SrB9dCtsWhVcslE5S6dsKIRG0xNUpGAkmFtCG5PnOPF6gEg8TLr/M+JUwJXQgNU2CXA3O7O7l0se5yTdBXehlEXXxnOyI31evVz9t/EIoTrjtVYanixJnpRSsLK4toYDbc2NWSDZQyD7ZESuzFyKftd/nfd2Ha2to8rHkYnDouc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gayPpzJH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gayPpzJH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388A51F000E9;
	Wed, 15 Jul 2026 22:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784153561;
	bh=KxXE+c5U5U0qqWASEEaSDSK8VSknZep3vDUaYvBeqZo=;
	h=From:To:Cc:Subject:Date;
	b=gayPpzJHKQEadNF2miAheryTiT3bRkcfoGdB2E1m0hbt/Nj9XTwTb5ACpcQjXUxVo
	 Hx0Xl63UWmDEqsan8liS4+d35CCcG6elVseRH5/tNytBUJJMWVge84pjiVWUfyRlsd
	 sGJ1rDQlnMVGqFLgFxpNoseqRXf5edwIqjlQ68gTx/uzc3k4DiilvtjBDBsShRElLn
	 ImFNI8DIlhOIaD4U2ZGyiv2al4Y7HLIQ1I++j0bB9013TkVaiBZBKtiHvefRu555ko
	 MQIadcTBw+bpduxt99uAnEZFOEyw+zeB7GjBC3N2/H5ZH7f0MSfJDv7MnDc24t53uP
	 eDeTLZA1ZKgow==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Thomas Huth <thuth@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 00/13] Library APIs for AES encryption modes
Date: Wed, 15 Jul 2026 15:11:40 -0700
Message-ID: <20260715221153.246410-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series can also be retrieved from:

    git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git aes-modes-v2

This series adds library APIs for almost all AES encryption modes that
are used in the kernel, both authenticated and unauthenticated: AES-ECB,
AES-CBC, AES-CBC-CTS, AES-CTR, AES-XCTR, AES-XTS, AES-GCM, and AES-CCM.

Patches 2-7 add the library APIs, and patches 8-13 wire them up to the
traditional crypto API (with just priority 110 for now).  I'm planning
to take these through libcrypto-next for 7.3.

Proof-of-concept patches that convert users of the traditional crypto
API to use the new library APIs can be found in patches 14-33 of the v1
series
(https://lore.kernel.org/linux-crypto/20260707053503.209874-1-ebiggers@kernel.org/).
Those additional patches are intended for 7.4 or later.

Apologies for the large patch series, but it ended up being easiest to
handle all the AES modes at once rather than try to do them one by one.
This ensures a consistent design for them, which is really important.
Additionally, the arch-optimized AES code tends to intermingle different
modes, and many depend on each other anyway.

But as a result, to keep this series manageable it doesn't include the
usual KUnit tests or the integration of the architecture-optimized code.
Those will be sent separately in follow-up series.

Changed in v2:
- Reduced the series to just the patches targeting 7.3.
- Made lots of documentation and comment improvements.
- Made CRYPTO_AES select the library kconfig options correctly.
- Adjusted the parameter order of some functions for better consistency:
  aes_ccm_init(), aes_{ccm,gcm}_encrypt(), aes_{ccm,gcm}_decrypt().
- Made the CCM implementation support ad_len up to 2^64 - 1, as per the
  spec, instead of artifically capping it at 2^32.
- Made the CCM implementation check for incorrect call order, making it
  consistent with the GCM implementation.
- Optimized how aes_ccm_init() validates data_len.
- Made the GCM implementation check for the maximum ad_len.
- Made aes_{gcm,ccm}_decrypt_final() return an error code if either of
  the lengths was incorrect, instead of just warning.
- Shared more code between encryption and decryption for GCM and CCM in
  crypto/aes.c.
- Removed unnecessary casts in inc_be128_ctr().
- Avoided memset() with dst == NULL.
- Lots of other small cleanups.

Eric Biggers (13):
  crypto: xts - Split out __xts_verify_key() helper
  lib/crypto: aes: Add ECB support
  lib/crypto: aes: Add CBC and CBC-CTS support
  lib/crypto: aes: Add CTR and XCTR support
  lib/crypto: aes: Add XTS support
  lib/crypto: aes: Add GCM support
  lib/crypto: aes: Add CCM support
  crypto: aes - Add ECB support using library
  crypto: aes - Add CBC and CBC-CTS support using library
  crypto: aes - Add CTR and XCTR support using library
  crypto: aes - Add XTS support using library
  crypto: aes - Add GCM support using library
  crypto: aes - Add CCM support using library

 .../crypto/libcrypto-auth-encryption.rst      |   20 +
 .../crypto/libcrypto-unauth-encryption.rst    |   49 +
 Documentation/crypto/libcrypto.rst            |    2 +
 crypto/Kconfig                                |   11 +
 crypto/aes.c                                  |  892 ++++++++++++-
 include/crypto/aes-cbc.h                      |   77 ++
 include/crypto/aes-ccm.h                      |  266 ++++
 include/crypto/aes-ctr.h                      |   65 +
 include/crypto/aes-ecb.h                      |   49 +
 include/crypto/aes-gcm.h                      |  260 ++++
 include/crypto/aes-xts.h                      |   94 ++
 include/crypto/gcm.h                          |    4 +-
 include/crypto/xts.h                          |   18 +-
 lib/crypto/Kconfig                            |   40 +
 lib/crypto/aes.c                              | 1163 +++++++++++++++++
 lib/crypto/tests/Kconfig                      |    6 +
 16 files changed, 3009 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/crypto/libcrypto-auth-encryption.rst
 create mode 100644 Documentation/crypto/libcrypto-unauth-encryption.rst
 create mode 100644 include/crypto/aes-cbc.h
 create mode 100644 include/crypto/aes-ccm.h
 create mode 100644 include/crypto/aes-ctr.h
 create mode 100644 include/crypto/aes-ecb.h
 create mode 100644 include/crypto/aes-gcm.h
 create mode 100644 include/crypto/aes-xts.h


base-commit: e073f1238ecaea366f53e98724c40b31856da56a
-- 
2.55.0

