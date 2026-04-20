Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FBE93859E3;
	Mon, 20 Apr 2026 06:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776667024; cv=none; b=XC3F0Ld/4awWfYkJ5+aPa9ADJxobVZRjMeyRqu07f6hJskyWbRXQXwfcuVcCXjvz+N+kaBplcGiqzTrtAKGhCuNHqO3L+9uDeTTA583ZA5TK9HT+CXuOtLC4MQXKcLJIBybwM0b0Pa+KsH6G0ToRF6QjWO5/Mtg5n0bhi4rPmI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776667024; c=relaxed/simple;
	bh=kan79TYdNJ9OQVJz4ZzOBAXMBzxir5whqu11CtmLFoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvk9W9eJxfKhQDnxCNdoEoJ1yhsYoev9g1lNW/2TVFGVYdflcb5eHE2pgRRBdbHm0NobTV5ViWwSONoV44Zy7DEY+/kBJpdO4vJ5HZ3tK96YXqQ+8MBfrD66nIQIuJgeG6Dr46NWWEqQDVVA9hu1liagEfcr8om9tFsz3iUMnvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZHkwDjOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZHkwDjOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3184C2BCB3;
	Mon, 20 Apr 2026 06:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776667023;
	bh=kan79TYdNJ9OQVJz4ZzOBAXMBzxir5whqu11CtmLFoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHkwDjOYW9XhQQEsfDMo8ObiUwl8t1SCU7x9Tj2rpft2Vpq0Xj3yMLZYMvZrNgr6j
	 2I56DR6jmsT1o9OWgt0rOedg/syUrOGSkfzGy0L+VxPGMhFAe0CSoC8WKCCvgKMtmv
	 Z3jebWjHNplTpo61SixjfHVMUvSSrJIyjjVnKE7qzsCkW8SrGa5m3mCzSZSjcNyqlT
	 tcBJlOPqrRr5e1P3c66EWmNR1zrerU7RrVPxXKMsYIXfSuPh+M48WyYGBiMRbbXB0K
	 OVTA2ROVgXjnl4r6D0n3KAyb6vQ+0CRNhjwNJJxZxHacqtAw6jGCZ24GVeilx3TCjD
	 rb127OR6pYp3A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 14/38] crypto: drbg - Flatten the DRBG menu
Date: Sun, 19 Apr 2026 23:33:58 -0700
Message-ID: <20260420063422.324906-15-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420063422.324906-1-ebiggers@kernel.org>
References: <20260420063422.324906-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that the menuconfig CRYPTO_DRBG_MENU has no options in it other than
the hidden symbol CRYPTO_DRBG, remove it and move CRYPTO_DRBG to its
parent menu.  Give CRYPTO_DRBG an appropriate prompt and help text.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/Kconfig | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 14519474a67b..1abb3d356458 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1111,28 +1111,21 @@ config CRYPTO_ZSTD
 
 endmenu
 
 menu "Random number generation"
 
-menuconfig CRYPTO_DRBG_MENU
-	tristate "NIST SP800-90A DRBG (Deterministic Random Bit Generator)"
-	help
-	  DRBG (Deterministic Random Bit Generator) (NIST SP800-90A)
-
-	  In the following submenu, one or more of the DRBG types must be selected.
-
-if CRYPTO_DRBG_MENU
-
 config CRYPTO_DRBG
-	tristate
-	default CRYPTO_DRBG_MENU
+	tristate "NIST SP800-90A DRBG (Deterministic Random Bit Generator)"
 	select CRYPTO_HMAC
 	select CRYPTO_JITTERENTROPY
 	select CRYPTO_RNG
 	select CRYPTO_SHA512
+	help
+	  DRBG (Deterministic Random Bit Generator) (NIST SP800-90A)
 
-endif	# if CRYPTO_DRBG_MENU
+	  Enable this only if you need it for a FIPS 140 certification.
+	  It's otherwise redundant with the kernel's regular RNG.
 
 config CRYPTO_JITTERENTROPY
 	tristate "CPU Jitter Non-Deterministic RNG (Random Number Generator)"
 	select CRYPTO_LIB_SHA3
 	select CRYPTO_RNG
-- 
2.53.0

