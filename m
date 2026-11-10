Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794346002;
	b=wqonFvqXZZ7QcmMi5bRU/Sv3grTWF8+ksNBnlHkrCQV4TAJNrLkj/ZwX7ETEX1eJUvHn
	 dW1MQ4YO1Ew+9UbS90FupWmySHOgWhwoiEp2RGV3heQWsftnACLm01yz9d4WAVN5800aI
	 D/X3RKjYZhuaAsNDRtvL1qm0DY5JrZLJbrpwvkxwdib4ztC3ME89smw2SRFgqMx1De5wz
	 iBzt7KzGiNIoiWVOh+B/Nsba67kxyTZWllb0a7tZSyTywAbPCd8jUZ4xgYminkknTIMji
	 v69pGPGhoEV64bl7E/D5dtDfmDMPMJzm2HhL+IEnUTnwRXbppSjQVVHcVPwo17J0YhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794346002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q9ZzFflVO7mgT/5vT9SxQ6PvIks03h4y+p5OjTXEzxM=;
	b=rhl8QEYeTxnbHPA3HQfe86uXJB0gudd4jKUf7U9NnpAs4RjfkH00a0HbFmXot6UtNoND
	 Twq2APAbcoKN9H1BHFuMOWw3gVlX38ThJqO0jIJQRpWvQ+qd+RIPpHHllW0loeBurY/+F
	 CBYO/T8+KyDd6K3lsMrZB4+unQfEYs4POw4+BElMFkGdk2r5ye7/YyoQXq2SYUWZydNdB
	 5DVvC4WriZ3QptuGfNyCab/Q1P/tDtdgzSI0Na6hVaort8PgJ9doccAKcZWaegIuTTJo8
	 L9+O5mT3dScZOW6vIt6wfMPwafWupcn56hFbznlQ+awKyi4hYgxc573k1lV8Y/g2Fyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0JSVBew;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D347A606A325;
	Tue, 10 Nov 2026 21:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X0JSVBew
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490371F0089F;
	Tue, 10 Nov 2026 21:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794346001;
	bh=Q9ZzFflVO7mgT/5vT9SxQ6PvIks03h4y+p5OjTXEzxM=;
	h=From:To:Cc:Subject:Date;
	b=X0JSVBewuufDvujfur89ffpeQiEPqUJfkO4ZJBR4LVARjd1Py/yrUp9xLfryC3yGT
	 2gnytcemgFmiJ8vGKYulzXL3x/Ndv3NSuyhOtFSjuCvgKje60aEYyuTLkCt78v6rPN
	 nW9iy1Pt5GZp3n4FOd5RGRlUlwShoRTzlalBmB4IroBvGM1+MYiChM4jhRYz4+wAYP
	 eUPh1JpB4LqhQWb+JlTrbxaRDLU/IgctVFZ9siV3upABhLRf38e9JlfVWZjUdmQbky
	 qC5vy/DnOjMCzGrtnAvYSWxoOJrQXyIRoRFqyIC43Q4EzJ0gqIx7YFBwXSdGwDWkIY
	 LPSdjqkUPkUTA==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-mips@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.18] lib/crypto: mips: Disable Octeon SHA code on little-endian kernels
Date: Tue, 10 Nov 2026 13:26:31 -0800
Message-ID: <20261110212631.36307-1-ebiggers@kernel.org>
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

commit dd2a4edb26e1c78823c50ba10c42f2d3de2e5ec4 upstream.

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
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://patch.msgid.link/20261022054450.20746-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index fa882108ba62c..2f2edeaf9de3e 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -142,7 +142,7 @@ config CRYPTO_LIB_SHA1_ARCH
 	depends on CRYPTO_LIB_SHA1 && !UML
 	default y if ARM
 	default y if ARM64 && KERNEL_MODE_NEON
-	default y if MIPS && CPU_CAVIUM_OCTEON
+	default y if MIPS && CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	default y if PPC
 	default y if S390
 	default y if SPARC64
@@ -160,7 +160,7 @@ config CRYPTO_LIB_SHA256_ARCH
 	depends on CRYPTO_LIB_SHA256 && !UML
 	default y if ARM && !CPU_V7M
 	default y if ARM64
-	default y if MIPS && CPU_CAVIUM_OCTEON
+	default y if MIPS && CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	default y if PPC && SPE
 	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
@@ -180,7 +180,7 @@ config CRYPTO_LIB_SHA512_ARCH
 	depends on CRYPTO_LIB_SHA512 && !UML
 	default y if ARM && !CPU_V7M
 	default y if ARM64
-	default y if MIPS && CPU_CAVIUM_OCTEON
+	default y if MIPS && CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	default y if RISCV && 64BIT && TOOLCHAIN_HAS_VECTOR_CRYPTO && \
 		     RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS
 	default y if S390

base-commit: 1cdda838e8475edf89b73ff0cc952005dd0b1fa7
-- 
2.56.0

