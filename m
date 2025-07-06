Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E721D293C4F;
	Sun,  6 Jul 2025 23:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751843504; cv=none; b=l0Y7yT3+TQufEFeHKJABSCqCpO2flEyRLiuvVPhw9/O9aahvMIBaopwzmRKbY5V0iuH7aw3cvLzgdbp00EX8onotu12vmnhuJcTZ2DhvuKKpaU59n2EuMLipbH/wZZlEaOh4Nz1ynZBbhdaakMoYaih/OnA9kV+V59IwUVmZCCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751843504; c=relaxed/simple;
	bh=teoV448S0gcMOu8C5WoirpthEs9NO+TdMk4xuLOATJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3MlUQVpVVgbIkheU9rAZfC+2OKH0Lo87z9xTfv7BGMV1QXmQPPmBfuYE8IU4ZjxqrcZDouaftwSYPxLe9j77DVMzxyHHDKJwoZOAhb0Mi3Yfz0fXm0eGTo+nRNgROsdb/osXkxMoSGQ3Y2ZN6QjdtAmcRyYs95NeqCftEMC1bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f3a7W0of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f3a7W0of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51AFC4CEF3;
	Sun,  6 Jul 2025 23:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751843503;
	bh=teoV448S0gcMOu8C5WoirpthEs9NO+TdMk4xuLOATJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f3a7W0of7/Jn47K34fx9xqgeSmDmpq/O5gMCPuremhPnhrR8nwudK87rOYh6nUYqd
	 OLWLwRYYw2X37+u+56dtHC/AQTkEIjrXb+ZSc7XGDYjHMLfn8D9FSa0Ia+B0+F1S0f
	 nVJKmv8qJw0qtGzW50Lw+T1S5O1aKhKjvXSvGkGyg+ntLDKkmeiPvRLoF4NhTTitdP
	 OJ1n/3J0FSbQEL9n1uI1Xb27QBA9uF8IbpUdbePaW6x7BpBlVDWqGkBUHo1NCtSEdG
	 quNoqEUTbkT2B68MKYjFZGb8+AczHW119pYGvbGi0SgC0eMj9I5feNFdJ7fnEk6ObS
	 0aqVgphHrc6NA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/5] lib/crypto: arm/poly1305: Remove unneeded empty weak function
Date: Sun,  6 Jul 2025 16:10:56 -0700
Message-ID: <20250706231100.176113-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250706231100.176113-1-ebiggers@kernel.org>
References: <20250706231100.176113-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The __weak and empty definition of poly1305_blocks_neon() was a
workaround to prevent link errors when CONFIG_KERNEL_MODE_NEON=n, as
compilers didn't always optimize out the call.

This call is now guarded by IS_ENABLED(CONFIG_KERNEL_MODE_NEON).  That
guarantees the call is removed at compile time when NEON support is
disabled.  Therefore, the workaround is no longer needed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm/poly1305-glue.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/lib/crypto/arm/poly1305-glue.c b/lib/crypto/arm/poly1305-glue.c
index 2603b0771f2c..5b65b840c166 100644
--- a/lib/crypto/arm/poly1305-glue.c
+++ b/lib/crypto/arm/poly1305-glue.c
@@ -25,15 +25,10 @@ asmlinkage void poly1305_blocks_neon(struct poly1305_block_state *state,
 asmlinkage void poly1305_emit_arch(const struct poly1305_state *state,
 				   u8 digest[POLY1305_DIGEST_SIZE],
 				   const u32 nonce[4]);
 EXPORT_SYMBOL_GPL(poly1305_emit_arch);
 
-void __weak poly1305_blocks_neon(struct poly1305_block_state *state,
-				 const u8 *src, u32 len, u32 hibit)
-{
-}
-
 static __ro_after_init DEFINE_STATIC_KEY_FALSE(have_neon);
 
 void poly1305_blocks_arch(struct poly1305_block_state *state, const u8 *src,
 			  unsigned int len, u32 padbit)
 {
-- 
2.50.0

