Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794348005;
	b=AUXqhzvqUkTlf6aRLxGCY+wvfg4JZPbXcpuEYTa3lj4UEIn2U5qLqm3f3GPf2vfAJ56q
	 WHnFkkiwsA1TQ7BEIbVQLrVibjN4ECG1GZvVhjmeStvCAX3B3XyviHuX2HKVvMWLgdrGj
	 XQP/I/cAenhg8dsmLCKNG4Bq/dNtnsNyGm/WOC3+Td/LHLhR/IGreYgx0CTAHzfkCSBUe
	 2I8vbwkET6sZaAmERvG36F0pqi49st2M03TQKCePirvx+bhA355UR66ocLWgdGzO+25H1
	 mZxRWFpU2+QEunS7cdYNEkIvtps9nwSqAIBnCbOJ6Ubptu8el+VWkUxIsOO+EasSAFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794348005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bP0PYjy5UHIUcYCgsHgni8Lrx9/nduv1+ncg/+mUhcY=;
	b=uFDUDLyRsLUwBC23JIH+ka7S0OlZxzenJBxNPw1GySAQy544UNI5UpcULUfbPnMIYTOo
	 Ewp8zGAAqm7Ef2XN5/42OPtLrPMMgb5nPdbnxEHK2ZDch5nhhtUoJP6pZk83aCki/6m3a
	 Gw2vPSyvQFfUpm51eqzDO51Ji9CrqDzQ6S992pUJAKqWsI+ckte/QABFw5YWrFSYrtQoQ
	 upfiMvhfIW9/tjo4U1PIsKHiVcep5iPX2LPLtRC7kmS13SDbslkpz6hLJP3i4hq8HNk2j
	 QZfkDp4zU9A2sqd3Ptdc7wl0aqfYHmReLQ/nDjoTHqUyFKr0ldSKVEap6pPNAO/LQxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fG1m79DG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A443606A327;
	Tue, 10 Nov 2026 22:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fG1m79DG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28BEE1F008A1;
	Tue, 10 Nov 2026 22:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794348005;
	bh=bP0PYjy5UHIUcYCgsHgni8Lrx9/nduv1+ncg/+mUhcY=;
	h=From:To:Cc:Subject:Date;
	b=fG1m79DGOncedhneDGG4/mIKZpB1vH8YoqM2wKZEtFujwabLrkQExfUSorlad+WCA
	 xlTjMdH9Ebndq/Ia1/f94RrciuAcydhFbs0iSuR9IERaif5IDvNzkLITOq2Z9HdJqg
	 AvE8uffRQnE3tmyJJOiZgJcEIYN2IgoeLzu2O/GxliwZ33p9C7OeYnnpCy8Ligr65i
	 kx0EZOud+LJSMVCpzKeLKnzRVvhAjp9+I31ERzQUr9nnWoE2BPFOxjJciFxUyyJj1c
	 yA9dWN3sysDDhfLQiL5XIQ+gG21/GM73aoR1jUFWvV08mEtvQvd+8f3t+Z3LZrxOjY
	 YrNxjBuTa3pPQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-mips@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.15,5.10] lib/crypto: mips: Disable Octeon SHA code on little-endian kernels
Date: Tue, 10 Nov 2026 13:59:45 -0800
Message-ID: <20261110215945.38544-1-ebiggers@kernel.org>
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
 crypto/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 126d4699f06f7..6cfd33de36c15 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -868,7 +868,7 @@ config CRYPTO_SHA512_SSSE3
 
 config CRYPTO_SHA1_OCTEON
 	tristate "SHA1 digest algorithm (OCTEON)"
-	depends on CPU_CAVIUM_OCTEON
+	depends on CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	select CRYPTO_SHA1
 	select CRYPTO_HASH
 	help
@@ -922,7 +922,7 @@ config CRYPTO_SHA256_PPC_SPE
 
 config CRYPTO_SHA256_OCTEON
 	tristate "SHA224 and SHA256 digest algorithm (OCTEON)"
-	depends on CPU_CAVIUM_OCTEON
+	depends on CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	select CRYPTO_SHA256
 	select CRYPTO_HASH
 	help
@@ -952,7 +952,7 @@ config CRYPTO_SHA512
 
 config CRYPTO_SHA512_OCTEON
 	tristate "SHA384 and SHA512 digest algorithms (OCTEON)"
-	depends on CPU_CAVIUM_OCTEON
+	depends on CPU_CAVIUM_OCTEON && CPU_BIG_ENDIAN
 	select CRYPTO_SHA512
 	select CRYPTO_HASH
 	help

base-commit: 29c6cdaac04a6989a7ed4ae4275ce4244e617f58
-- 
2.56.0

