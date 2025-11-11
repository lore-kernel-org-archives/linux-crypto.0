Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94612620FC;
	Tue, 11 Nov 2025 20:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762893083; cv=none; b=jBC1XqZfemx5yRW1VsaVRexuqk78ynD9/MsP1bJkxYtWJLRy/6aZw8V6QdQYYlREPCQc93G/jsXFVFLPq5G2uL4Ff4i2EtOCa5LJhkhuWUIo7it1QPerVRzcpojbHjXPoK7ogc3Qn494xHq42zj9YLuZMo0yr/3jOmVtNYwNim4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762893083; c=relaxed/simple;
	bh=rT77b2HCYaDvTU3abPqxbFu9KwVZ7Glvk+EqZXcz3ro=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E2XiJzcQN/Wfq9ZEBodJB9abYatiHpA3WJIH/pURXcxpnh008Og6fzlyaxSqsDHLYPxaG1mJn35xQyo2wqW8j4JMw+FPSTi9bwmBZeWPKGUcQV05v0Ru04oLb/z39hsFxEzdFzC8Y3e+IQpwI/FDapgXAW+6veQD8lsK9LPv9RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hVejOsfG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hVejOsfG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8654CC113D0;
	Tue, 11 Nov 2025 20:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762893082;
	bh=rT77b2HCYaDvTU3abPqxbFu9KwVZ7Glvk+EqZXcz3ro=;
	h=From:To:Cc:Subject:Date:From;
	b=hVejOsfGKcsbAuuyruGaXzWGTgnsPKfc64CZ0NEY05AuorQjA6RtkgLgId0BgSFzG
	 wmzA0fQgl6tpGVqrY+o8G3hrrvoIMQBkxc+DnDri7udraOWKAoarvRMCJWw7m3/pvf
	 gCwX2VRiVhpf6ihpKNbja7h0t4ZrfILmdh55t7ruEre+7MT0y9tJyNPPcrctSJj8l1
	 XtHjBbsHHvFjZvk/eSIk4ShyuaqKUeg4hsC1kZMvXFYeacgAdh4NO8qLQIsFismXul
	 K/j/sy2UIXu+x0UBixIiAkCOCbkQ18/zVhfXu8xTr+eui7vcmfrY3ajKxTbVSH7R9J
	 Uyn9ZwPS38f+w==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.6] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Tue, 11 Nov 2025 12:29:41 -0800
Message-ID: <20251111202941.242920-1-ebiggers@kernel.org>
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
index 847b7a003356..1f684e29cff2 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -2,11 +2,11 @@
 
 menu "Accelerated Cryptographic Algorithms for CPU (arm)"
 
 config CRYPTO_CURVE25519_NEON
 	tristate "Public key crypto: Curve25519 (NEON)"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
 	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	help
 	  Curve25519 algorithm
 

base-commit: 0a805b6ea8cda0caa268b396a2e5117f3772d849
-- 
2.51.2

