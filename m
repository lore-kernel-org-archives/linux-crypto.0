Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7451E325732;
	Mon,  5 Jan 2026 05:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767590094; cv=none; b=n030c8EqmhxJe3I+1AUJSMXszU1vpRPImZ7rWKA42B9fX7AsS8BE+Co20FNLlkaKxsZ7g36IrWF0WTADalmJz7pWKl9p4xpXaHr9mhxlEGqdV6OkwKTPeqHIosMrhMIAeBewHRYuw1D4moLdr+dZRQj9BAI1VY9krNYUi8oBti4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767590094; c=relaxed/simple;
	bh=NaJeCMt68rOEMjT7oGa1VxCfK2+6f9/LQJxPSOh0Gn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgcJss0UB7aMUwzgz4N94caezfQ0WJwRS9qs8RPlFq36s7Jb8JaBGZFwNiTBfROcAoKbPE7pywj9i1k8iAqaVf3CJeK4gRV/c8euiKwpgAaJOGRMbOUbNot1cX0sUTXha6PGSQ6gmMxHAucbGkR3IiciOOaV32bo7LWGtmR+gKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=igzB1iG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="igzB1iG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9360AC19424;
	Mon,  5 Jan 2026 05:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767590094;
	bh=NaJeCMt68rOEMjT7oGa1VxCfK2+6f9/LQJxPSOh0Gn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igzB1iG36I5ddwcCBE6IyNjLvWLYZddcUzh3vYUDSgjc80fDHOeJgz4Ttks7krqct
	 Xaj+2+Pd+DV44mOpYKoOdnjBs63BiWnHvapVzcjGu4Lueu2IvUOOJLTjDWT7qdeS+0
	 r2Wqpt2qb3tX0hWPzIB9Sl/T2zeTBmaSX2YRUxnTSWGcH7egQzFmEw1xenEG2kRiN3
	 sr1FQe6dnkZ70RTBR6ok0orcHW3XKrfBwnq7jWs/q9gtch1mvSPjAPzIUciiTs2LiM
	 vcQCl+yMtyokIL//1b7maM2ojnVhXhqx8Ol3cvyjugy8onEJpcWWz4iUR479Pbfeb4
	 c6dikBpXXTx7Q==
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
Subject: [PATCH 06/36] crypto: arm64/aes - Select CRYPTO_LIB_SHA256 from correct places
Date: Sun,  4 Jan 2026 21:12:39 -0800
Message-ID: <20260105051311.1607207-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260105051311.1607207-1-ebiggers@kernel.org>
References: <20260105051311.1607207-1-ebiggers@kernel.org>
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

