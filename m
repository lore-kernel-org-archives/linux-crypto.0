Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4061133D6F8;
	Tue, 11 Nov 2025 20:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762893075; cv=none; b=d03y6E53jsYL6QBO4VNoQD1Q4v6TJJozKqJGWOPFHDfUx1bP8Ffy1+PEepmS7zZ0FhHqAFWMkXiwtKJKaUC8jBqCjHVNPurP8hHTJme9vbQFN4uZP34eg67oRiC3P3XYp+vw7046E3A4m6+Q4kGNYXCexJ/yvqz25bhpaSn+a1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762893075; c=relaxed/simple;
	bh=ADQaa9sHdyu7ZOrKR4J4rnxR26WrlTbpv0rZh7Rvzs4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k2z7FNIG1IZMWvpCoLACf0/Rw4enOHZ87c8UJQA1KbvZon4356b0w6efxTcpwbRza21x34Yax6Enn1Vdv5bD5dmbtWMyS65r7CKiHCgcbG067TDq1Lei4PlqOSAxez/uj7hCpBcovW6fbBqsy7Vn82xNGDm+CNcaZp5C3V6rnTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Mu73vyL9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Mu73vyL9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1DFC4CEF5;
	Tue, 11 Nov 2025 20:31:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762893074;
	bh=ADQaa9sHdyu7ZOrKR4J4rnxR26WrlTbpv0rZh7Rvzs4=;
	h=From:To:Cc:Subject:Date:From;
	b=Mu73vyL98SfZbW0XLaL1lLDHzfv7CD2IRJog7hFqXanRFkE3u144BBpJ02Kq6DbZl
	 rcko2K3NWUxAJceXeZOLHAQ1Gg+RMtOsNrPrAIANiZYy9Bo+PBpvSLnBdxWXf0mKpr
	 CRpS6prtnd23Fm15F2aHyqe3gAYn2fJs4dS02MaliAdNz+2oL/9MiMq47YOqY9zMsF
	 zgPrAwGd/hObzqyDmK6vhyZmi9hfrbLgDJpi86KhYBmE1qt9GR5RFhDJrjYcuxmltE
	 BPlMEhYvxYOlb8Bxemv2UL/Cgfroe4VoMYWD8TvTS/RbS7091gjInmzPsAnKEHQDmi
	 I4BEWVVp0U06Q==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.17] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Tue, 11 Nov 2025 12:29:23 -0800
Message-ID: <20251111202923.242700-1-ebiggers@kernel.org>
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
index 1e5f3cdf691c..a00ab9265280 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -2,11 +2,11 @@
 
 menu "Accelerated Cryptographic Algorithms for CPU (arm)"
 
 config CRYPTO_CURVE25519_NEON
 	tristate
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
 	select CRYPTO_KPP
 	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	default CRYPTO_LIB_CURVE25519_INTERNAL
 	help

base-commit: 7660ce69123ea73b22930fcf20d995ad310049ef
-- 
2.51.2

