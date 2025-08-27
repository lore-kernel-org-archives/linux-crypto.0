Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1996D29D28B;
	Wed, 27 Aug 2025 15:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756307701; cv=none; b=lvw7u+A3ad3TUs82g1Tn/xWRe/rR5a9yug3HP4Ch2xTee3Y7KaWGayMjuOFAEzzKx10NdALlhDMPQwJKVC9+RdCyoDHAOhWHjbyaxCueybf1rd/aZ2BVaJQ3aeqsY3ZMBonE9saeoVxidTWhYLMLuWabUEAcJ5p8Ji++Hra8v+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756307701; c=relaxed/simple;
	bh=/bCBdkNC8TXSkbBvU6E1D99TNf2kUrJ7+Uwzrv5HTbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSjy79QynwhXbOWYDMBZHzGZsHJCpQJYqjw8i0etPpsc6Q6k1ZcS0pbHG7fQ30xnjGaDxgTBPDDy9ySF62XXcOlzWphBAeMAVkhmHiiXKIvNE/VnPX5kFD+dRlq2efQbbmx6+8OH0N05JjL3z6Ak2ZYfNuBPWtKuCRq99NrF9zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U0+Mrc0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U0+Mrc0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BEBC4CEFA;
	Wed, 27 Aug 2025 15:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756307700;
	bh=/bCBdkNC8TXSkbBvU6E1D99TNf2kUrJ7+Uwzrv5HTbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U0+Mrc0GvdK47J+B9pHg7oS6KkzCJc+rHz0gATPkd06pRx+qBTm+5j+6ezuV4DAn5
	 3IEq+i3Nwts/qBGRXqaYGRa4BfVL/XrkHthWHsFIMTSaljOZs2NJumga+k1pdNvan9
	 IsctHfkMml8XmEL1m7sfvwUxX6OjxmAjvJaw+GJNvl4f+4sKYgWKkh6+DvfjZv7LYe
	 tRjt9fMhk54cROJd/kBpiHp0E0SS6uJmRUKUsDIgT1BLj7AfmfB46tW4PEEeRck9Ff
	 R+2Qlv+J8cj/odJYvH9XboqSmusDiSu0piCQMVegVR0EzzCH3CJ8cNv7XLt9uoHyDH
	 6C3AclQJBLyIA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 09/12] lib/crypto: blake2s: Always enable arch-optimized BLAKE2s code
Date: Wed, 27 Aug 2025 08:11:28 -0700
Message-ID: <20250827151131.27733-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250827151131.27733-1-ebiggers@kernel.org>
References: <20250827151131.27733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When support for a crypto algorithm is enabled, the arch-optimized
implementation of that algorithm should be enabled too.  We've learned
this the hard way many times over the years: people regularly forget to
enable the arch-optimized implementations of the crypto algorithms,
resulting in significant performance being left on the table.

Currently, BLAKE2s support is always enabled ('obj-y'), since random.c
uses it.  Therefore, the arch-optimized BLAKE2s code, which exists for
ARM and x86_64, should be always enabled too.  Let's do that.

Note that the effect on kernel image size is very small and should not
be a concern.  On ARM, enabling CRYPTO_BLAKE2S_ARM actually *shrinks*
the kernel size by about 1200 bytes, since the ARM-optimized
blake2s_compress() completely replaces the generic blake2s_compress().
On x86_64, enabling CRYPTO_BLAKE2S_X86 increases the kernel size by
about 1400 bytes, as the generic blake2s_compress() is still included as
a fallback; however, for context, that is only about a quarter the size
of the generic blake2s_compress().  The x86_64 optimized BLAKE2s code
uses much less icache at runtime than the generic code.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/arm/Kconfig | 2 +-
 lib/crypto/x86/Kconfig | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/crypto/arm/Kconfig b/lib/crypto/arm/Kconfig
index 740341aa35d21..a5607ad079c4f 100644
--- a/lib/crypto/arm/Kconfig
+++ b/lib/crypto/arm/Kconfig
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 config CRYPTO_BLAKE2S_ARM
-	bool "Hash functions: BLAKE2s"
+	def_bool y
 	select CRYPTO_ARCH_HAVE_LIB_BLAKE2S
 	help
 	  BLAKE2s cryptographic hash function (RFC 7693)
 
 	  Architecture: arm
diff --git a/lib/crypto/x86/Kconfig b/lib/crypto/x86/Kconfig
index eb47da71aa6b6..ffa718321369f 100644
--- a/lib/crypto/x86/Kconfig
+++ b/lib/crypto/x86/Kconfig
@@ -1,9 +1,9 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 config CRYPTO_BLAKE2S_X86
-	bool "Hash functions: BLAKE2s (SSSE3/AVX-512)"
+	def_bool y
 	depends on 64BIT
 	select CRYPTO_LIB_BLAKE2S_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_BLAKE2S
 	help
 	  BLAKE2s cryptographic hash function (RFC 7693)
-- 
2.50.1

