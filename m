Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9825187E2;
	Wed, 30 Sep 2026 17:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788029; cv=none; b=iLRcdji1L0iuxKaHOtl+4OGbXWf/tYf4pEJaBrjAWR7x2HkqZ1gIxqT13FsoM5qRRgv6u//q8aEp3DxRwAH9ww6djcWk5FMqmhZVcFls4Lc4bnj7JAvMdKvLlA0Ap2pTSVveAP84JKL5geFhyxTjeQhGcI9sl1GZJaDU8779flE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788029; c=relaxed/simple;
	bh=mgVE6ep2FR016jhAEo42p9ojflwFuqs99312Yz+DLAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nk0IYEoKfaJ0Lo9WKC/CqLHnu182shhq8I3lOHQBf2i/D860nf3847g2c9XEGlyYXrAdGXv9j/6CRnQgT9Bl+bvv/sQ4woH3w9Kmdx3Pi9BIN18QDvbGFkeZfbAcx9+Hm8mDoIdSJ6HivsC2NSbo0PLOwK8UPZdt6ran5TbzMuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i/3CZDDU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i/3CZDDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FF01F0089F;
	Wed, 30 Sep 2026 17:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790788027;
	bh=bxepJKkkWKFlvRd2GPJYEsd1J/8Y538mVw4QP8ulfw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i/3CZDDUXgdaaU2lFqI4tpA9Df+2Bp9h4lLDMAurfR9h6lg3iCNqEX1BcWOMfG8Uu
	 aPVmQ4Cahfy4Kq0Bg+Uk5hMMRjF8bXS5gfNwbA4w5K0Aniz8W64hNjKfINCP+9UrY3
	 VvP4KGGUA6eZpk+wm9whYSEEGyXsxJRHyTNuFrsFaZaSuI70MP7SuDh5WluYO2a18w
	 oVna2j4h33oWcvhY7Y55V2XRMRC9oEa8CyeaEPS8/e+89V3kuzeiWPj9tZQjqtvZPY
	 GzDw6bg7oes7tE0yYw+7JY+zKOTp24Q/1n1FdMLd4R9fgauzzOwcC/z6DdHMOAiORy
	 rIT0q5TkJmBjQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 3/3] crypto: x86/aesni-intel - Add transitional selections
Date: Wed, 30 Sep 2026 10:05:42 -0700
Message-ID: <20260930170542.140403-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930170542.140403-1-ebiggers@kernel.org>
References: <20260930170542.140403-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make CRYPTO_AES_NI_INTEL select CRYPTO_AES, CRYPTO_CBC, and CRYPTO_XTS
so that systems with CRYPTO_AES_NI_INTEL enabled are guaranteed to still
get the algorithm needed for their systems to boot with LUKS / dm-crypt.

(Later, when CRYPTO_AES_NI_INTEL is removed entirely, I plan to turn it
into a 'transitional' symbol with these selections.)

While compatibility selections haven't been used for previous migrations
of architecture-optimized code into lib/crypto/, I think it's worthwhile
in this particular case.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/x86/crypto/Kconfig | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/crypto/Kconfig b/arch/x86/crypto/Kconfig
index c1842c2d7055..20f5e2a17e45 100644
--- a/arch/x86/crypto/Kconfig
+++ b/arch/x86/crypto/Kconfig
@@ -9,6 +9,9 @@ config CRYPTO_AES_NI_INTEL
 	select CRYPTO_LIB_AES
 	select CRYPTO_LIB_GF128MUL
 	select CRYPTO_SKCIPHER
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_XTS
 	help
 	  AEAD cipher: AES with GCM
 
@@ -16,8 +19,13 @@ config CRYPTO_AES_NI_INTEL
 	  - AES-NI (AES new instructions)
 	  - VAES (Vector AES)
 
-	  Note: this option no longer provides the accelerated XTS, CBC, CTR,
-	  and ECB code.  For those just use CRYPTO_XTS, CRYPTO_CBC, etc.
+	  The module controlled by this option (aesni-intel.ko) no longer
+	  directly provides the accelerated ECB, CBC, CBC-CTS, CTR, XCTR, and
+	  XTS code.  Those are now provided by CRYPTO_AES (aes.ko) when the
+	  corresponding mode option (CRYPTO_XTS, CRYPTO_CBC, etc.) is enabled.
+
+	  To ensure dm-crypt continues to work in kconfigs with only this option
+	  set, this option selects CRYPTO_AES, CRYPTO_CBC, and CRYPTO_XTS.
 
 config CRYPTO_BLOWFISH_X86_64
 	tristate "Ciphers: Blowfish, modes: ECB, CBC"
-- 
2.55.0

