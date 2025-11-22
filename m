Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9CE2C158E;
	Sat, 22 Nov 2025 19:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763840566; cv=none; b=Q3JOz2FEsbn8NYLba3y1mswNNRbKzBlauLI6WSh2Yjo2TYlVM7FeXQkmEhfCF0soo7XXsJzN8Ww7T7rkyspXDXuSB5vfXElEsQoH37YGFnDAe3/kG2diQU4a3c1LppGJKFgo8Fdhw+2pk6kpMR2ppVZbpo/zFLV0ulYjg7/4UqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763840566; c=relaxed/simple;
	bh=xpoNH4kgspUwPe1f6Y50HDV93L8GACvKyr/04iKSWdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+h/N1fdW6FEDsbApBrWm5Bq32YduCj8Wh8xuOHOFH7L3ltvIOaT/wrCTAwA6juW4GJNGDK3M6Qs1nXMR8pORNsOJiX/WSROzets20ypJn9pOWucoqCALJN4w9wIcoKNMOHPVTlKyCaSJ1yranmRIxqPe4ALc+lIbhcSw2PNpWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WpGZnv+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WpGZnv+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049E6C19425;
	Sat, 22 Nov 2025 19:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763840565;
	bh=xpoNH4kgspUwPe1f6Y50HDV93L8GACvKyr/04iKSWdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WpGZnv+F+k2ve49gIwlvlJyas8dB989YMRzs+ISBFMte5p86OC95Mo5KD4rp3ugtb
	 3SynOG7/VBP0tYPOoQRf1BxzB3zHn5fMEuhFIzFUfnl4EjczRvQbDHFz2jdaMULZt1
	 Oft1MphBTtyZrCQvPIAaoSEh27i7GZylJfROU0ANzpZDrvbVT7YEwdQ0+mtZ4DEDut
	 9oecUyKF2l4PJFEi/yYOFZ7/pfGNyhHOTvbqe7GMzNM6z0+hAHwmQJu+UUinNMxVtX
	 VZPILtSJojMWkOD1Dzl/iB4KSNt1PcXxeHLJ5sM+7WC2kSCe8qN3n/6oaOw+hIkfD1
	 6VruZDBdADDeQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/6] lib/crypto: curve25519: Add at_least decoration to fixed-size array params
Date: Sat, 22 Nov 2025 11:42:02 -0800
Message-ID: <20251122194206.31822-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251122194206.31822-1-ebiggers@kernel.org>
References: <20251122194206.31822-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the at_least (i.e. 'static') decoration to the fixed-size array
parameters of the curve25519 library functions.  This causes clang to
warn when a too-small array of known size is passed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/curve25519.h | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/crypto/curve25519.h b/include/crypto/curve25519.h
index db63a5577c00..2362b48f8741 100644
--- a/include/crypto/curve25519.h
+++ b/include/crypto/curve25519.h
@@ -11,28 +11,32 @@
 
 enum curve25519_lengths {
 	CURVE25519_KEY_SIZE = 32
 };
 
-void curve25519_generic(u8 out[CURVE25519_KEY_SIZE],
-			const u8 scalar[CURVE25519_KEY_SIZE],
-			const u8 point[CURVE25519_KEY_SIZE]);
+void curve25519_generic(u8 out[at_least CURVE25519_KEY_SIZE],
+			const u8 scalar[at_least CURVE25519_KEY_SIZE],
+			const u8 point[at_least CURVE25519_KEY_SIZE]);
 
-bool __must_check curve25519(u8 mypublic[CURVE25519_KEY_SIZE],
-			     const u8 secret[CURVE25519_KEY_SIZE],
-			     const u8 basepoint[CURVE25519_KEY_SIZE]);
+bool __must_check
+curve25519(u8 mypublic[at_least CURVE25519_KEY_SIZE],
+	   const u8 secret[at_least CURVE25519_KEY_SIZE],
+	   const u8 basepoint[at_least CURVE25519_KEY_SIZE]);
 
-bool __must_check curve25519_generate_public(u8 pub[CURVE25519_KEY_SIZE],
-					     const u8 secret[CURVE25519_KEY_SIZE]);
+bool __must_check
+curve25519_generate_public(u8 pub[at_least CURVE25519_KEY_SIZE],
+			   const u8 secret[at_least CURVE25519_KEY_SIZE]);
 
-static inline void curve25519_clamp_secret(u8 secret[CURVE25519_KEY_SIZE])
+static inline void
+curve25519_clamp_secret(u8 secret[at_least CURVE25519_KEY_SIZE])
 {
 	secret[0] &= 248;
 	secret[31] = (secret[31] & 127) | 64;
 }
 
-static inline void curve25519_generate_secret(u8 secret[CURVE25519_KEY_SIZE])
+static inline void
+curve25519_generate_secret(u8 secret[at_least CURVE25519_KEY_SIZE])
 {
 	get_random_bytes_wait(secret, CURVE25519_KEY_SIZE);
 	curve25519_clamp_secret(secret);
 }
 
-- 
2.51.2

