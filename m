Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4F1324B16;
	Mon, 12 Jan 2026 19:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768245801; cv=none; b=R8e6HZ+rbr5ai3WU+an2Whmu9lIhTEGOuWLvsPwYl3QzjZiki05GLuWXr4o7mWY1CZQGe1Bh+CWKykJ8eA4OX4xseNaSdQCRydm2+lYk5O4ZkxKfm092+5VqXE3qZIfhaRHTyWREFxrjiGUv8QHkoPNiabESN2TgetS03mryBeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768245801; c=relaxed/simple;
	bh=jF7KhWSZryEBB0FeZdUnAzVuxZQQQuTKuWy5tUR+OmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rax0PPtLjxyNq8jBPebjkD1GkZfX2309pNsbzfA0oaDUopPXbenS5PCFmK0+ngj2FtK6clTi6RRUC+i2LZDiC+GtE5hgNDbI4VdwQiQ6hJgNppWTRbZU2RvDchCu7VOBYPOAp7a45PwDfj5IxUKaEDy7DnhE/66PK6Ndw+fqF8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JXIHBvTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JXIHBvTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1EDDC4AF0B;
	Mon, 12 Jan 2026 19:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768245801;
	bh=jF7KhWSZryEBB0FeZdUnAzVuxZQQQuTKuWy5tUR+OmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXIHBvTpr+H6VX4tbUc+PGAH5U0i1qcPQ/D9pk3S5+zn6TPIK3c9zuSj62qZvCQsW
	 NezYfkOvYDjk8SDzcWZEm0pV/M/QtoIolJj7BCFE3jieqSwUy9Q8HoTjScWYkKXAIY
	 EGJyRspSX3ezX38NkMpCfd3FeywvkK6RPpye3nl+z71yk17w1EkE4n91YothPcu5ny
	 2eys2Ah0khcFVZzHoxmLLiTEmxNFK6hGDOrqjEqHXPvE3pTB/pDb94E0UZhl9nhGQt
	 fJ17HRRNKm26vQZTwyd3aV5KEua5phkd5XM/D6RbTU0GuDZSgjbkHy5JcvGhgAHnBi
	 9+Osz6DZLMkzg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org,
	Holger Dengler <dengler@linux.ibm.com>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 06/35] crypto: arm64/aes - Select CRYPTO_LIB_SHA256 from correct places
Date: Mon, 12 Jan 2026 11:20:04 -0800
Message-ID: <20260112192035.10427-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260112192035.10427-1-ebiggers@kernel.org>
References: <20260112192035.10427-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The call to sha256() occurs in code that is built when either
CRYPTO_AES_ARM64_CE_BLK or CRYPTO_AES_ARM64_NEON_BLK.  The option
CRYPTO_AES_ARM64 is unrelated, notwithstanding its documentation.  I'll
be removing CRYPTO_AES_ARM64 soon anyway, but before doing that, fix
where CRYPTO_LIB_SHA256 is selected from.

Fixes: 01834444d972 ("crypto: arm64/aes - use SHA-256 library instead of crypto_shash")
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm64/crypto/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index da1c9ea8ea83..4453dff8f0c1 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -38,11 +38,10 @@ config CRYPTO_SM3_ARM64_CE
 	  - ARMv8.2 Crypto Extensions
 
 config CRYPTO_AES_ARM64
 	tristate "Ciphers: AES, modes: ECB, CBC, CTR, CTS, XCTR, XTS"
 	select CRYPTO_AES
-	select CRYPTO_LIB_SHA256
 	help
 	  Block ciphers: AES cipher algorithms (FIPS-197)
 	  Length-preserving ciphers: AES with ECB, CBC, CTR, CTS,
 	    XCTR, and XTS modes
 	  AEAD cipher: AES with CBC, ESSIV, and SHA-256
@@ -64,10 +63,11 @@ config CRYPTO_AES_ARM64_CE
 config CRYPTO_AES_ARM64_CE_BLK
 	tristate "Ciphers: AES, modes: ECB/CBC/CTR/XTS (ARMv8 Crypto Extensions)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_AES_ARM64_CE
+	select CRYPTO_LIB_SHA256
 	help
 	  Length-preserving ciphers: AES cipher algorithms (FIPS-197)
 	  with block cipher modes:
 	  - ECB (Electronic Codebook) mode (NIST SP800-38A)
 	  - CBC (Cipher Block Chaining) mode (NIST SP800-38A)
@@ -81,10 +81,11 @@ config CRYPTO_AES_ARM64_CE_BLK
 config CRYPTO_AES_ARM64_NEON_BLK
 	tristate "Ciphers: AES, modes: ECB/CBC/CTR/XTS (NEON)"
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_SKCIPHER
 	select CRYPTO_LIB_AES
+	select CRYPTO_LIB_SHA256
 	help
 	  Length-preserving ciphers: AES cipher algorithms (FIPS-197)
 	  with block cipher modes:
 	  - ECB (Electronic Codebook) mode (NIST SP800-38A)
 	  - CBC (Cipher Block Chaining) mode (NIST SP800-38A)
-- 
2.52.0

