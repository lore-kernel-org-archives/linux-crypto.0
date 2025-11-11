Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD9017555;
	Tue, 11 Nov 2025 20:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762893091; cv=none; b=YPfBsc+zaWDRf3+Mkql5gmWLPIH7rXbW86E69kS+Gx0C2NmxoAUfcO9erUI5j0BLs2cY4z4NNV8M1Asr0R9hlxMWhto9R8g7ulj4nUxoA0haPv773ZqPwmg+wIbnaM0UtYlfJBccG6Jd3XO/EHpO+TYN6HtnvFAkqafdhMUrYM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762893091; c=relaxed/simple;
	bh=zHzBxlkGa6nv7WpmX7dVn82lvsoCbLYGAXnLZMG86fk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PODfJ06nuB+soRbtxJR6Dk5r2ZHIe/i3apg0fyEEh6QHvf+EaReFJ3sE1l6XW3X4l1/Y0a9Fc3Es5RrrmQiLo+riKvu2qBFA8cowLwD9IJ8EcvBHQ/SsPzeZs91pUkANpSRBBb0u8a9gfr0pshqdv38DEc/fW4mlC7r4udIfiVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZCXafII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZCXafII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EC2C113D0;
	Tue, 11 Nov 2025 20:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762893090;
	bh=zHzBxlkGa6nv7WpmX7dVn82lvsoCbLYGAXnLZMG86fk=;
	h=From:To:Cc:Subject:Date:From;
	b=CZCXafIIi6srVX6ENRsfpJtHYWt+jPl63auzeyYcXn+f2x5u9O5psc7dgKBaIZTVl
	 4WDovrqyQFudbYfC2sSlP9dVD37bZhBg6K8GWg3Jw1vwBf7xiR5YiQsmPMiwblJeW+
	 MckU5m0tHdE95gyj5wJMBLkyR+2xRID60wNdWAXgSn+eWiHog6UXyRP4P2DTX9O8gp
	 YCNG0Bmnqodyb4opgM8RECBBX75/0nnoDbnZJqrr1/EvVFnosKm3dHsXp5nYypAXsS
	 2UIAG4+AVpB61ZT6TDrYQw+4QjQCnpn28Ok0UsQDiLK6oehBhK9eOYddrGix+UGCpH
	 PYH0WVUMYFHJA==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Tue, 11 Nov 2025 12:29:49 -0800
Message-ID: <20251111202949.242994-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 44e8241c51f762aafa50ed116da68fd6ecdcc954 upstream.

On big endian arm kernels, the arm optimized Curve25519 code produces
incorrect outputs and fails the Curve25519 test.  This has been true
ever since this code was added.

It seems that hardly anyone (or even no one?) actually uses big endian
arm kernels.  But as long as they're ostensibly supported, we should
disable this code on them so that it's not accidentally used.

Note: for future-proofing, use !CPU_BIG_ENDIAN instead of
CPU_LITTLE_ENDIAN.  Both of these are arch-specific options that could
get removed in the future if big endian support gets dropped.

Fixes: d8f1308a025f ("crypto: arm/curve25519 - wire up NEON implementation")
Cc: stable@vger.kernel.org
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20251104054906.716914-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/arm/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index c46c05548080..c5d676e7f16b 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -145,10 +145,10 @@ config CRYPTO_NHPOLY1305_NEON
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_NHPOLY1305
 
 config CRYPTO_CURVE25519_NEON
 	tristate "NEON accelerated Curve25519 scalar multiplication library"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
 	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
 
 endif

base-commit: df70e44fa05b01476a78d0f6a210354784ff0992
-- 
2.51.2

