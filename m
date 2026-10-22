Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792647957;
	b=Y0GkYt/nRShdUk+eai7ewQc3huQJkHEjsNhX345aLmSRuUigmFG556xCFeKyIkj7h1bc
	 Lec+mVEqur+cPypsI+G8AlitubzxY4knsGSjWKEjxUNUy+wXJLRl0Z71H9cdD1X/5eFTC
	 FPQjVjE0mGM6TZ9xSMyt5TeAFOMPs/eEZZo0ItdSiBemyLIDBynP8Ay1dIIhqwoYpKAsP
	 uySyjsbiCH+omVS5At7Lcin0IBkFhNRyPDpEVkJ+rgMm4TpT6a+VIjKx6LleVorwD7Vg1
	 UbV21yrDrg9DLpJ8wWBHXCaU0SvCbWbzlXhLI6FO3CcprUv9S73aRZKgxsFE0iRkz4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792647957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+DEgi/8NrTUM8tcUILyBiIkZL/IAs9wdlvFiHXOeDbE=;
	b=BWbAH6hYkPhk+yVHwQK3l5Mncy8y8iVXTa9ZlP9NFXrvvW92Sae/DBd1YEKChwW+Z6O8
	 7Xq0i0L7fu6b7lZWC4E/zZ/ZB2GHEC6WJkqrZxUdxX1RWOOFXZI8RKB5FuRiHGCwL4wj+
	 LlWeEYb5CgBiSzcQ1Z1sHGQAJ0g6Jn+APdzH7MEKpQqYIh24YiUMvc2yG/FqUPRmISK49
	 PWga2RtEMi7RdtWfsOWFKfJQSZxGMqJv1abJeBHu334TcNqwuNRi6c4A7w0kvc1H0A9Oh
	 hxJRSicqMGYbYBoLaD2rKHDMrTPCQL6Jq+hPDcvcr1EzzZPbvbxlccLbZ18eYiPwFpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=byntnXkd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2348606A31A;
	Thu, 22 Oct 2026 05:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=byntnXkd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321F41F000C1;
	Thu, 22 Oct 2026 05:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792647956;
	bh=+DEgi/8NrTUM8tcUILyBiIkZL/IAs9wdlvFiHXOeDbE=;
	h=From:To:Cc:Subject:Date;
	b=byntnXkd2/OOaj8g+9r1MFRzXa8JRqoR3YbHK9gX3Q/E6LV1ksbBTx5bcwIlaPScV
	 qvpwDrp1yEs3Wl2XxysQJqQYVt/6zkNPHGr0/16LxDUE4dSr0I50qxBYak1rYzb/9W
	 6OmghZwwlM96UmMhYvC1fj8+sh5rBT9zs5REfJE5hvC/hjs9LkezBrJ1V7r01P8/jg
	 kMPYr7UK1ilMR+1HQ0oiQt5cPcVIDHsiCwE+/kRyanFBmVyKwzHuwBDC4+P/Sik8mh
	 o8n/aOpM+tAzukPM4Io+PIoyBU1yp8eBnju3lxXKsKwj4Cs2QzcivhOQud2G6xZscc
	 8x64QvTQIUz7Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-mips@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Aaro Koskinen <aaro.koskinen@iki.fi>,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] lib/crypto: mips: Disable Octeon SHA code on little-endian kernels
Date: Wed, 21 Oct 2026 22:44:50 -0700
Message-ID: <20261022054450.20746-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
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

Kernels built for the MIPS64-based Cavium Octeon SoCs are normally
big-endian, but little-endian builds are also supported.  Currently, the
SHA-1, SHA-256, and SHA-512 code using the Octeon crypto co-processor is
enabled in both builds.

This code is untestable without the hardware.  However, based on the
code itself, it is implausible that it computes hash values correctly in
little-endian builds.  Such builds write many incorrect values to COP2:

  - SHA-1 and SHA-256: The 64-bit integer that contains the last two
    32-bit message words of each block is written to COP2 entirely
    byte-reflected, due to missing endianness conversion in
    octeon_sha1_start() and octeon_sha256_start() to compensate for
    using native 64-bit loads from the message bytes.  This differs from
    all the earlier message words which are written correctly.

    Furthermore, the state is written to COP2 with each 32-bit word
    byte-reflected within each 64-bit integer, due to incorrect use of
    64-bit endianness conversion in write_octeon_64bit_hash_dword() when
    the state is kept in memory in native-endian 32-bit words.

  - SHA-512: All the 64-bit message words are written to COP2
    byte-reflected, due to missing endianness conversion in
    write_octeon_64bit_block_sha512() and octeon_sha512_start().  The
    SHA-512 state words seem to be written correctly.

Big-endian kernels aren't affected by these bugs.  These bugs also
aren't new; this code has been broken on little-endian ever since it and
Octeon little-endian support were first added in v4.1.

Commit d2a948d2db68 ("MIPS: Octeon: Make octeon-md5 driver
endian-agnostic") made the MD5 code work on little-endian kernels by
adding 64-bit endianness conversions to the COP2 macros used by MD5
(some of which are shared by SHA-1 and SHA-256, despite those algorithms
keeping the state words in native-endian instead of MD5's little-endian,
causing some of the strange behavior described above).  However, SHA-1,
SHA-256, and SHA-512 were never fixed to work on little-endian kernels.

Therefore, disable the Octeon SHA-1, SHA-256, and SHA-512 code in
little-endian kernels.  This causes the generic code that actually
computes hash values correctly to be used instead.

Fixes: 82be2dcfa6a1 ("crypto: octeon - add SHA1 module")
Fixes: c3d0def62001 ("crypto: octeon - add SHA256 module")
Fixes: fbaa4dfd51a0 ("crypto: octeon - add SHA512 module")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is intended to be taken through libcrypto-fixes.

 lib/crypto/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 56f308dd02731..83b4a211c15d6 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -237,7 +237,7 @@ config CRYPTO_LIB_SHA1_ARCH
 	depends on CRYPTO_LIB_SHA1 && !UML
 	default y if ARM
 	default y if ARM64
-	default y if MIPS && CPU_CAVIUM_OCTEON
+	default y if MIPS && CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	default y if PPC
 	default y if S390
 	default y if SPARC64
@@ -255,7 +255,7 @@ config CRYPTO_LIB_SHA256_ARCH
 	depends on CRYPTO_LIB_SHA256 && !UML
 	default y if ARM && !CPU_V7M
 	default y if ARM64
-	default y if MIPS && CPU_CAVIUM_OCTEON
+	default y if MIPS && CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	default y if PPC && SPE
 	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
@@ -275,7 +275,7 @@ config CRYPTO_LIB_SHA512_ARCH
 	depends on CRYPTO_LIB_SHA512 && !UML
 	default y if ARM && !CPU_V7M
 	default y if ARM64
-	default y if MIPS && CPU_CAVIUM_OCTEON
+	default y if MIPS && CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	default y if S390

base-commit: 4403278e4ea2f654f8130a5c03eb8b4516a0f201
-- 
2.56.0

