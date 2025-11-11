Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B456533D6FD;
	Tue, 11 Nov 2025 20:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762893086; cv=none; b=lqsgFJOxS0tNodbPbrwzh2eBRgYca8WTQ5ClKa5KUbMkV3LImfcqhJfdazHF6w2pv/XwfDDOHINlPPPeGKV5msioY+hM1flEOWrRUzdE4qK0XIyK2yObK+WMvdqEgJ885xLRYtmJsQS6xi8cq248b71XRhWTNiT62jMhkOAauU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762893086; c=relaxed/simple;
	bh=bly4iXqvvGSqP2zva08xAO/t5sO1S1gbYfphuK+S/ec=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mM4FlIBaQmKzEXPUJI2iMXD9AIx94zo6jDmN3/7q28jpLIJd7ngYQg8vcoTxBz/TQ+Loq3w5dnFsy0a+FtVb0tzLKjnPSLjnFfvXiCVR5/syzuLH0YzLLRPYZpabXa90z9ikbAtkDXaKv/vRc5UeMVaWEcZcIXFP3K12R/EE0Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ei7Q/qk0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ei7Q/qk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B71FC19423;
	Tue, 11 Nov 2025 20:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762893085;
	bh=bly4iXqvvGSqP2zva08xAO/t5sO1S1gbYfphuK+S/ec=;
	h=From:To:Cc:Subject:Date:From;
	b=ei7Q/qk0R0mmpdaOxiO3omdVfpWKYUMSjz5LUacfFhMM4mJi7kpe4amn5MQNPXTYn
	 xDaWtx+TZ7FTiEbS5s28IyebSi0KIqcjcCEhn6D9UalV2ZDeKuJqeZpyek7LZrAdso
	 H8ZeX5f7x1Lxtkq6B03W0ujoGflYSLIoKGzmcwHAsGXz9gnFCQFgIoKoh64ynFI6H5
	 fnSv0FRuXlyqjjUraqoVYsOQrnafWbkzomlznPpv19I9LWJ6Hv0a+ycAee6z4T+/tC
	 upqyryOTt1yQThRueHua0AVcrCJugln5ZKjZrBt1GbnqlopRmNOvAsGpDynWyYO4IA
	 W1KtPPbosVFug==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Tue, 11 Nov 2025 12:29:44 -0800
Message-ID: <20251111202944.242946-1-ebiggers@kernel.org>
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
index 3858c4d4cb98..f6323b84631f 100644
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
 

base-commit: f6e38ae624cf7eb96fb444a8ca2d07caa8d9c8fe
-- 
2.51.2

