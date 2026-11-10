Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347669;
	b=wFTqfFxA2/CFVMqR12RKYbvKUKsiAPVe1hkxIO++w/oGKVj7nOskrOY6NX1QGSH0kdsc
	 7hS0s/QDt4ZJHS3nHAH7xLeC/LSmDSLBCTykNVFiHAJZz0xI2iI1iz6ZVgzOTSHSfD+CC
	 O6HogwcxnmDyiw/b5IjlGahNCwHIH6jFPs5NK8b8fdOSohYSvv0DGGLFntuYSG7KkHTP+
	 Ajza3a6qulGCEh3yfKiNxY6FrZy0b+GDXaRxP8YIvDzwqTl2eZYL9U49eIZkCO3ewIA1V
	 YjlZua5jXPmoEHSXCaorJtPdSuywTLVUVrERqdeSHBlM10wtH9IDvDXrromyv1TdSeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L4BLHG89Bgd/xsayo1sYfbzCzsfL+BMr8SFXjVahQG0=;
	b=1BmtmGIoMsyfyQ8skt6IQpawTeYS3o998ivfe3vAA+nkMFL6XF7CkXbTCHUjPMJXO1Y7
	 DjBpclc15ZotOsvU2Fzx9ZV+pAn1bvT/1rAcu4bpYISSo368usvnAIhl/N7ruF6rKVNQ4
	 Hc6I87H3auovEwaYs+UJneiHT00XiqeBs9BJHet8WBe6kSgJ8eANrdPaLgKC9DDt69wxO
	 MeLMgxv4RAgc94bY6XQE728QfucL1e/2aODxbU+mVTOLcrfFQqYtFn/nyG/oyKcVsMONo
	 rQw0gLteQRw4ZuycUMqGOIDITfKNTIv550E7b7z1+2e0LBGtcIQ8czRZOkh3U6/e8xA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e5pGqm1z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79738606A32A;
	Tue, 10 Nov 2026 21:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e5pGqm1z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B21F1F0089F;
	Tue, 10 Nov 2026 21:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794347669;
	bh=L4BLHG89Bgd/xsayo1sYfbzCzsfL+BMr8SFXjVahQG0=;
	h=From:To:Cc:Subject:Date;
	b=e5pGqm1z4Ywft2fbXZc6HGmYLlV8iXItXj9IBDaJrchRoYXTkvs3T2w9frNvXQs2n
	 uEJJYM7zEuV8w0CkoIGkQlVuexLIDkWm9jkmIZCP1GSCY5BABdykm2jbssiSxCvAHK
	 wR8yXCkcqaroOzrgxP3hbUjx791bm8vq2drBYn5RMz8MvY3NnjN38jndWHNImvI5KG
	 2uVPCNSnTMkFJwR2rkUneHgz2ayA3F0NCM0YUjH2kSwotBNojPB4ocoBpTWAuQBeml
	 WfrjGeXDYljWXBXlNmCLXwHeon3H7t8efOCJVfOuMxsyPt+RasTbHp3yEbYsvO4i6g
	 TM4dKeNHX3Ayg==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-mips@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.12,6.6,6.1] lib/crypto: mips: Disable Octeon SHA code on little-endian kernels
Date: Tue, 10 Nov 2026 13:54:04 -0800
Message-ID: <20261110215404.37415-1-ebiggers@kernel.org>
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
 arch/mips/crypto/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/mips/crypto/Kconfig b/arch/mips/crypto/Kconfig
index ee9604fd20372..f951a75dfef32 100644
--- a/arch/mips/crypto/Kconfig
+++ b/arch/mips/crypto/Kconfig
@@ -34,7 +34,7 @@ config CRYPTO_MD5_OCTEON
 
 config CRYPTO_SHA1_OCTEON
 	tristate "Hash functions: SHA-1 (OCTEON)"
-	depends on CPU_CAVIUM_OCTEON
+	depends on CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	select CRYPTO_SHA1
 	select CRYPTO_HASH
 	help
@@ -44,7 +44,7 @@ config CRYPTO_SHA1_OCTEON
 
 config CRYPTO_SHA256_OCTEON
 	tristate "Hash functions: SHA-224 and SHA-256 (OCTEON)"
-	depends on CPU_CAVIUM_OCTEON
+	depends on CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	select CRYPTO_SHA256
 	select CRYPTO_HASH
 	help
@@ -54,7 +54,7 @@ config CRYPTO_SHA256_OCTEON
 
 config CRYPTO_SHA512_OCTEON
 	tristate "Hash functions: SHA-384 and SHA-512 (OCTEON)"
-	depends on CPU_CAVIUM_OCTEON
+	depends on CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	select CRYPTO_SHA512
 	select CRYPTO_HASH
 	help

base-commit: d3417611a3b40b7f04a29e558cebac2bf69889d7
-- 
2.56.0

