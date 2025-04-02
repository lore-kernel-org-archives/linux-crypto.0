Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F67367;
	Wed,  2 Apr 2025 00:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743553484; cv=none; b=qmBLgBMQH40oAhYQ/DVznc8G8eIBe7wOEBinn//RqPDmvt+7DzNPGV5rEyGD5iALeP/r0kqzbVcoL21MQQ1UyvM1ydgF+UjwiCBra0DQSYDUKKcgMwnIuxlsAxXqcTFc1J/DZ41fagC6EhXlI12DfiPZD8U2DiLQGkQsNyuIBqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743553484; c=relaxed/simple;
	bh=Qq2IWLnTJbBdF1oOpDt2PMmFkK3B7zoA+vSNiXoPCl0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uHSPCjyYE84ZL9rkevs7gQAAj6dGZ88kXSVWUmPeCTuEM/JW8ERGOMiD1ts2lqX5tGVZKsoT230bBDswmmVgXD6Yn1Wl6dJFJLIcGfXmNknrEmdoYMZ+OESl29iF2cyFnZCVJj5zh4+KZicBS8RUg5TjMUmQ3FlSbl7WTUG1KCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CXO4aaAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CXO4aaAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36758C4CEE4;
	Wed,  2 Apr 2025 00:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743553483;
	bh=Qq2IWLnTJbBdF1oOpDt2PMmFkK3B7zoA+vSNiXoPCl0=;
	h=From:To:Cc:Subject:Date:From;
	b=CXO4aaAYypGe1MAGEK5LqZkKHnSx0OplIHFJThwTiQlXSFo2ugrBhsoNv/B17CV10
	 eOOxOf50Pbg2z15i4DWW2LL/CX+2eV1+1WRBJ5JS0AvuoZvJ6kZpdhKWlRf99kxo7A
	 KIsknFKOu9qZ7bKRCR2FXT9H5fBG2Rb8JcB0xFKeB9R5KSkYmMu2mDk8U+gy22YlUY
	 Fj3SM4TR49TvCi+ob74jvqpEAt1noHw+9V70r6kZvHUGN5WaELT+o/UWfR5VwJhjFO
	 i3yEkW8Bek4tew+NENI+OEAii9FeOZ43j8p3pDbhb0Sdrcy/oqyHMSF7Pn7/CwAVUO
	 huvaMspETlrEA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 0/9] crypto: x86 - stop using the SIMD helper
Date: Tue,  1 Apr 2025 17:24:00 -0700
Message-ID: <20250402002420.89233-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Patches 2-9 are almost identical to
https://lore.kernel.org/r/20250220051325.340691-3-ebiggers@kernel.org/
but now split into multiple patches.  Patch 1 is just a resend of
https://lore.kernel.org/r/20250320220648.121990-1-ebiggers@kernel.org/
which is needed for the series to apply cleanly but is otherwise
unrelated.  Description of patches 2-9 follows:

Stop wrapping skcipher and aead algorithms with the crypto SIMD helper
(crypto/simd.c).  The only purpose of doing so was to work around x86
not always supporting kernel-mode FPU in softirqs.  Specifically, if a
hardirq interrupted a task context kernel-mode FPU section and then a
softirqs were run at the end of that hardirq, those softirqs could not
use kernel-mode FPU.  This has now been fixed.  In combination with the
fact that the skcipher and aead APIs only support task and softirq
contexts, these can now just use kernel-mode FPU unconditionally on x86.

This simplifies the code and improves performance.

En/decryption gets at least somewhat faster for everyone, since the
crypto API functions such as crypto_skcipher_encrypt() now go directly
to the underlying algorithm rather than taking a detour through
crypto/simd.c which involved an extra indirect call.  For example, on a
Ryzen 9 9950X desktop processor, AES-256-XTS is now 23% faster for
512-byte messages and 7% faster for 4096-byte messages (when accessed
through crypto_skcipher_encrypt() or crypto_skcipher_decrypt()).

There's also a much larger performance improvement for crypto API users
that only support synchronous algorithms.  These users will now actually
use the x86 SIMD (e.g. AES-NI or VAES) optimized en/decryption modes,
which they couldn't before because they were marked as asynchronous.

Eric Biggers (9):
  crypto: x86/aes - drop the avx10_256 AES-XTS and AES-CTR code
  crypto: x86/aegis - stop using the SIMD helper
  crypto: x86/aes - stop using the SIMD helper
  crypto: x86/aria - stop using the SIMD helper
  crypto: x86/camellia - stop using the SIMD helper
  crypto: x86/cast - stop using the SIMD helper
  crypto: x86/serpent - stop using the SIMD helper
  crypto: x86/sm4 - stop using the SIMD helper
  crypto: x86/twofish - stop using the SIMD helper

 arch/x86/crypto/Kconfig                    |  14 --
 arch/x86/crypto/aegis128-aesni-glue.c      |  13 +-
 arch/x86/crypto/aes-ctr-avx-x86_64.S       |  47 ++----
 arch/x86/crypto/aes-xts-avx-x86_64.S       | 118 ++++++--------
 arch/x86/crypto/aesni-intel_glue.c         | 174 ++++++++-------------
 arch/x86/crypto/aria_aesni_avx2_glue.c     |  22 +--
 arch/x86/crypto/aria_aesni_avx_glue.c      |  20 +--
 arch/x86/crypto/aria_gfni_avx512_glue.c    |  22 +--
 arch/x86/crypto/camellia_aesni_avx2_glue.c |  21 +--
 arch/x86/crypto/camellia_aesni_avx_glue.c  |  21 +--
 arch/x86/crypto/cast5_avx_glue.c           |  21 +--
 arch/x86/crypto/cast6_avx_glue.c           |  20 +--
 arch/x86/crypto/serpent_avx2_glue.c        |  21 +--
 arch/x86/crypto/serpent_avx_glue.c         |  21 +--
 arch/x86/crypto/serpent_sse2_glue.c        |  21 +--
 arch/x86/crypto/sm4_aesni_avx2_glue.c      |  31 ++--
 arch/x86/crypto/sm4_aesni_avx_glue.c       |  31 ++--
 arch/x86/crypto/twofish_avx_glue.c         |  21 +--
 18 files changed, 227 insertions(+), 432 deletions(-)


base-commit: 91e5bfe317d8f8471fbaa3e70cf66cae1314a516
-- 
2.49.0

