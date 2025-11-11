Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3589D33D6CC;
	Tue, 11 Nov 2025 20:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762893088; cv=none; b=Z9hwR6wW+S9ClyETRykgoaOleL0rbT0hLvC9n6PmxMmfb49XlPKenTvz8roIA525rRqB5Ex5RmwWXlYx70tmTShaVaifPckpfu1qSKnOXKaiL8uZx5jUJZxLAtMGKswqoDOUYsnFtZRX4jlXh3vdKDUDI7l2g8QLiHZNjzuDLuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762893088; c=relaxed/simple;
	bh=dXiCaWUGSa4Z/KJc4JAWLqIkBPTGwgLMrgbnWFFzsrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rg9yMRFGtpJ/9ARVj63iVC8AWaJfOmXZ6NJd2QrFLvQKIPoPOIldh0JyUWHkiEkjrnVLZ/zi7kkjY+UaARfz17+JC1NeDO1Yo4lOxVVJgLChqS9i7M+sWjfpMdpLFkffARrfCZCK0Rw040JrHoXr5VpxYqVGpLEvkyt2NN9ODKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cw3v8poC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cw3v8poC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 942EFC4CEFB;
	Tue, 11 Nov 2025 20:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762893087;
	bh=dXiCaWUGSa4Z/KJc4JAWLqIkBPTGwgLMrgbnWFFzsrQ=;
	h=From:To:Cc:Subject:Date:From;
	b=cw3v8poCuJW0u4V7p7iwqOGspyGNT5oSTMzwy/nMmaCcBowIU83xm/H+W7af7Nyfp
	 YSuHyCrX0tCJ/zREliCtYzsfDGDHOB6FogxqTtRKaNG6lt2gtFbBef/C7WHtgqti4T
	 y8FXZqFa1gpqiVCi1LtBSkvRPYcZvbNLZD43EI9F89rSQm/9efegLqyMILYAqYn843
	 6evTfnKe/24grZfiQI0VXC/cfDiznNFL5yzboj9dGXq+J0xN+qckfBTK66uHnD/P5U
	 aQ2Mr3uFQW5o4qlI85OZp+e8MjQWVaPkpBXsh+sfvvz9y8zFnOsHAaRt43Lg+YQDSk
	 Cd/v3yBXxX7Cg==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Tue, 11 Nov 2025 12:29:46 -0800
Message-ID: <20251111202946.242970-1-ebiggers@kernel.org>
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
index 149a5bd6b88c..d3d318df0e38 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -164,10 +164,10 @@ config CRYPTO_NHPOLY1305_NEON
 	depends on KERNEL_MODE_NEON
 	select CRYPTO_NHPOLY1305
 
 config CRYPTO_CURVE25519_NEON
 	tristate "NEON accelerated Curve25519 scalar multiplication library"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
 	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
 
 endif

base-commit: cc5ec87693063acebb60f587e8a019ba9b94ae0e
-- 
2.51.2

