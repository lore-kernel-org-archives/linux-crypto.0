Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A83114B1E5F;
	Sat, 17 May 2025 02:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747448717; cv=none; b=dRBF6vesTFOHssJSY+YNNMzLuBjCIsfs1rKqd4QXKomg6p3GQOB9jwvVYrxIxyDsyk7NljGbrzxrw0QiOk9FnkIu0tLUktpBEzA78uSxx9rfitezsqUwfn1QFb5dmuEkS1aE1WmgDihFO9yeOYygknivQSaBTOoK3TItASJG7Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747448717; c=relaxed/simple;
	bh=5LJHcl18raozpnuXF8heGSJ9Ru8HE600KyleqFs0nAI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=InL4mFPsbIdAkGrjBQG+YrxKD+ghAY70Pko0KSFxnBwNb2h6GSg535BoVZG8J7UouPT78FH7ymOhef/9qxzVtiOqQqiRG140FKCz9qviipr/Q9n+sd6qHbu5yE4e8fi93U3tINzI2jPCIkZgtITk9fS5toeNc5N1Xz+gES1h718=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YPW1+8oz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YPW1+8oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D683AC4CEE4;
	Sat, 17 May 2025 02:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747448716;
	bh=5LJHcl18raozpnuXF8heGSJ9Ru8HE600KyleqFs0nAI=;
	h=From:To:Cc:Subject:Date:From;
	b=YPW1+8ozskYGd3FMybDfoa7N6Vu8YEj754nVsERm9U8KZZ6NO16tCuUh7JV6Rp+PJ
	 SBq82MKk39fsqcNcV7TGlWKo4ETwC9/75CJnpK8ccJbykyoSaw/MF15e6cMAS+L5g7
	 Wn10Jr3URTmnU2YYMSWzrfd4CWqS+h6r6d4ve6KtdkyWZphLt8z0Gxia/V+8JZ6Td/
	 M/xaTKyaJjV2Rjrox0FRLuavLUgPni0O/II1eAz+q/W3/3GEu/3ECyWWInQ34sQmKo
	 8aX0qQVspb9870jQ66P0l4lJlI0JQbg0STGq8Z+9uG5e6Vp1KXY1UqL53AbMCBZ5MA
	 8RPqc9XqLoaxA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] SHA-256 cleanup
Date: Fri, 16 May 2025 19:24:20 -0700
Message-ID: <20250517022428.401622-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series restores the SHA-256 code to have a clean design where the
crypto_shash API is implemented on top of the regular library API
instead of a special unsafe low-level API.  Diffstat is -41 lines.

Eric Biggers (8):
  Revert "crypto: sha256 - Use the partial block API"
  Revert "crypto: lib/sha256 - Use generic block helper"
  Revert "crypto: x86/sha256 - Add simd block function"
  Revert "crypto: riscv/sha256 - Add simd block function"
  Revert "crypto: arm64/sha256 - Add simd block function"
  Revert "crypto: arm/sha256 - Add simd block function"
  Revert "crypto: sha256 - Use the partial block API for generic"
  Revert "crypto: lib/sha256 - Add helpers for block-based shash"

 arch/arm/lib/crypto/Kconfig         |   1 -
 arch/arm/lib/crypto/sha256-armv4.pl |  20 ++--
 arch/arm/lib/crypto/sha256.c        |  14 +--
 arch/arm64/crypto/sha512-glue.c     |   6 +-
 arch/arm64/lib/crypto/Kconfig       |   1 -
 arch/arm64/lib/crypto/sha2-armv8.pl |   2 +-
 arch/arm64/lib/crypto/sha256.c      |  14 +--
 arch/riscv/lib/crypto/Kconfig       |   1 -
 arch/riscv/lib/crypto/sha256.c      |  13 +--
 arch/x86/lib/crypto/Kconfig         |   1 -
 arch/x86/lib/crypto/sha256.c        |  12 +--
 crypto/sha256.c                     | 142 ++++++++++------------------
 include/crypto/internal/sha2.h      |  52 ++--------
 include/crypto/sha2.h               |   7 +-
 lib/crypto/Kconfig                  |   8 --
 lib/crypto/sha256.c                 |  97 +++++++++++++++----
 16 files changed, 175 insertions(+), 216 deletions(-)


base-commit: 1bafd82d9a40cf09c6c40f1c09cc35b7050b1a9f
-- 
2.49.0

