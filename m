Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B53219F40A;
	Tue,  4 Nov 2025 05:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762235486; cv=none; b=CIgbRnrucMywrdzjkuxLPCKvqpHGdtbsM+dJjRngok3E3L1cIB1xFhFCsfqqxBWFcSwIEUpFrmuhEniUTc0+WU9/Av7EzVsDyHqWvCRVgeYx3nIt/oI8LXZhoxeOJk8Q3o7rY6jVfgLXzDpOxXMdNxzzP50u0ZvJe6LiEcYbFI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762235486; c=relaxed/simple;
	bh=+zIjCyngQqsvAfo8AR7dkJkLn9qM+SwI4b9HqY5K+Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eQs+mFkENarU2ob0kt7NjvhlOe+uvtsCqx9XYFKFmOD78mBDUyMrwWhfp8/YtlAKDI5PRdVcTFc7+Eqy8NAMTM7Qou5kXobwwxvb/tc9Drf2/wMZuCx/5nT2ZGK+R5hFvE5A3SSzyo78kwS2Vjwlb6Tr3VKKw6zKm6G7wdNwnoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eizjvtRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eizjvtRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEADC4CEF7;
	Tue,  4 Nov 2025 05:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762235486;
	bh=+zIjCyngQqsvAfo8AR7dkJkLn9qM+SwI4b9HqY5K+Pk=;
	h=From:To:Cc:Subject:Date:From;
	b=eizjvtRx6NsjrEsOsNhJcNTVKKLIsXJ7oUbIaV8aRsTgWT/p+J64taxBobqTFrZvY
	 6OIlp8zMqfHLB/gav3KITTRTtYI63qBODgUTue2maHNe6EmewqqPQN2zLfkiTuUb9Z
	 i0WzZNGKeOe3f4tblvcszGpEFUohXTeSz+X0cc5BMU8RfgtE5rEyxrOjabw+qvFhrR
	 hRFSmR9PvUgWUZ/bTcrOireJaKbCOzEqSMubsBnnNOibHcQYZnu5TKtJnRA+AELcoK
	 5mOFu2k/uVzb7MXQaTZ6XI6fD9OEpTLtHIE0RYkbAj7xmkJwcGQgYdb2qkcpso6T6W
	 fdqe9BM+8CmMQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Mon,  3 Nov 2025 21:49:06 -0800
Message-ID: <20251104054906.716914-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting libcrypto-fixes

 lib/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 8886055e938f..16859c6226dd 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -62,11 +62,11 @@ config CRYPTO_LIB_CURVE25519
 	  of the functions from <crypto/curve25519.h>.
 
 config CRYPTO_LIB_CURVE25519_ARCH
 	bool
 	depends on CRYPTO_LIB_CURVE25519 && !UML && !KMSAN
-	default y if ARM && KERNEL_MODE_NEON
+	default y if ARM && KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
 	default y if PPC64 && CPU_LITTLE_ENDIAN
 	default y if X86_64
 
 config CRYPTO_LIB_CURVE25519_GENERIC
 	bool

base-commit: 1af424b15401d2be789c4dc2279889514e7c5c94
-- 
2.51.2

