Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C5E5478D;
	Mon,  5 Jan 2026 05:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767591492; cv=none; b=QCDEOhdEPOgf0jjzFMVif5ruUieBE4MGIcZGTRh7DDOAMDYYWoCDYeY+COQff9y+PnO7ZKPVeQqG1YO/5Cqk3JyL0AZizmWtKUjjQPnIt1qQZMt9fZzK82PgyU5+IRWuUqicpOXQbGiIlY3HaVGUs59qXwpTzD1ehW8JhtKb+F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767591492; c=relaxed/simple;
	bh=1RFylk7SIc2mD8RyGcNH8hUjcC5BGX4F5pw5Xgo7+gs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gULsTBwB9zuG3g0VD/1CehUnhaAvCUJMsOTQ7usw3hWD/kQDNSFPSdoOGBiV/BZRg/QckTBrGtDjNGi6I8okilNdLYE3OJLhu7M1IfDciQdRiXkv73YI47oIu+SyoTOBmtJH1FcPbaMJOVYmvdQ9ay2+Fs7+b7MxbWhzrhLHYVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kFKthb4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFKthb4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BF1C116D0;
	Mon,  5 Jan 2026 05:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767591491;
	bh=1RFylk7SIc2mD8RyGcNH8hUjcC5BGX4F5pw5Xgo7+gs=;
	h=From:To:Cc:Subject:Date:From;
	b=kFKthb4xw7c+5XV5TduusjAmmMMHkABFPexFyqfJi9vGl5Co+XYb9ZO1tmm2CRdV3
	 FcalPVqy+X6uT8gNdWqpqpvFl6MNfEcmebfLLYHkJKVvm8T+4rLgOgoGY29d6frwpw
	 kQjp9/VJwJlqedXBHWvLoSybHoEosbsAox7ONxrp0wIvODqI/qauqg32Jtnd9jvEwM
	 omfOy1DDeevDReSO5l7rJ8qrs+HseZh3fumjl9DEnOIywgh4YXDckhDE+tnuX0XjMh
	 FgoGRIRgpKzi02MJ4KGyGe/J1EmWUFonM52vjKBgPPpdF9P36fMZSU+jqX5qTybgxR
	 ADoTNDw50CFoA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: nh: Restore dependency of arch code on !KMSAN
Date: Sun,  4 Jan 2026 21:36:52 -0800
Message-ID: <20260105053652.1708299-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since the architecture-specific implementations of NH initialize memory
in assembly code, they aren't compatible with KMSAN as-is.

Fixes: 382de740759a ("lib/crypto: nh: Add NH library")
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 33cf46bbadc8..781a42c5c572 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -114,11 +114,11 @@ config CRYPTO_LIB_NH
 	  Implementation of the NH almost-universal hash function, specifically
 	  the variant of NH used in Adiantum.
 
 config CRYPTO_LIB_NH_ARCH
 	bool
-	depends on CRYPTO_LIB_NH && !UML
+	depends on CRYPTO_LIB_NH && !UML && !KMSAN
 	default y if ARM && KERNEL_MODE_NEON
 	default y if ARM64 && KERNEL_MODE_NEON
 	default y if X86_64
 
 config CRYPTO_LIB_POLY1305

base-commit: e78a3142fa5875126e477fdfe329b0aeb1b0693f
-- 
2.52.0

