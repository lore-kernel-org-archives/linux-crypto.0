Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB9CA33D6FD;
	Tue, 11 Nov 2025 20:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762893080; cv=none; b=q9/Uns5fwORct21XKjnyEC9noJg5fcnOxD0DzNmQFq9WjMgSlVMOOg8lPQ+YV7SQQw/Yt0ew0cu8CPK8EDI9sBhgiStNeS6JKWO26wgHPdG+xAzDl86dtsAiVf57wmyzh4761zNCT2CgEW2Rm2U4hWwZhFUQiAAPJLOBExXmJQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762893080; c=relaxed/simple;
	bh=gCZM1PW6lB4y/ctI+DBLIH5T9x6I2f3q/IeDY5nP8NY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=douRg1c4fUYH+Sob+1Vh+CXZLI0K9QBvk02U/DxBOcfFrweAYfJi6UWdUY3TmwgC97AwqivA/nXl9eIbzRal3AIIuZQhNgPvdmBAY16tf/iU5RUMXHH4W0U674U5PH/2rnMIkW7+4MeNBTCwxSCgidIQLyohuTDGs//MjcT57fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMLdmCzg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMLdmCzg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D873C4CEFB;
	Tue, 11 Nov 2025 20:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762893080;
	bh=gCZM1PW6lB4y/ctI+DBLIH5T9x6I2f3q/IeDY5nP8NY=;
	h=From:To:Cc:Subject:Date:From;
	b=hMLdmCzg667o9JxB9QrDVqLmME6u/bikaDYs9dlbLlCwWEoFdB7co4vETD5hmDeeg
	 mF1uD4dOPy+N+TtUMyozFIr4D/cMnoKJYbSbaDjUfCpvBYBzROVMRD7xPf7pNVZ7qW
	 CcLo+KW+Rr1AZVUrSQBFYqlGuKo7rzzu+IjOkIkZ0BkcneZz9smixyPY5ul+AWfcvr
	 kucQcAdi8zyySb6fcXZSHCOIIwEQ3lG8pgND4zuOoSfV/7+EeAZEzGVM+at1odjJp5
	 ivFcGmJBLU/eOtbTEyQS9L1jCkrTIUNGI6BxRtPnuBRMMEg3yOfdXpWFQab6monUJK
	 hwmud04yL1PaQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Tue, 11 Nov 2025 12:29:36 -0800
Message-ID: <20251111202936.242896-1-ebiggers@kernel.org>
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
index f87e63b2212e..df2ae5c6af95 100644
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

base-commit: 8a243ecde1f6447b8e237f2c1c67c0bb67d16d67
-- 
2.51.2

