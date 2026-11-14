Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794690666;
	b=Zk1z2pjI9TOjJ0dlYwwMRKV5CrwqaRX23zlsikh4WUFvpvZX5R16xkV8GvEwWrswWnJe
	 ND/huxu48Os6WpPVTNRhJy9D5tCanou+/7duZD8b7Ex2znS4hfEuoxQFGAVb6HJbBTE1u
	 edBZRS/E+fiCxMKjbFvLhTOZOv/rZFEL1dOdkKjMoEb6ox2Df6qottXVJ4OUp0ca+5LU1
	 yoSIRDES9EG05ITdpeoHbAFRGAFp7Y55QwLN4iedvFhFlY4XKtv4bZz7B11kDC6hrgLSp
	 H8/P8eaEWxmnAg6hy823thOeEMN9tK9wAlzJf5SX1m0NlomxExyuIwdqk3XtLTqc6iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794690666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PWySbDG6gTOOgHtX0X2Egn1jbX/EYKXSYGg78Rt2ZiU=;
	b=aEhwquTNJHaUunWsNkuqCQ7C3F488l98bGFFAAmYeVdFerW1AzbUvUPk2tqgf3XUPTG8
	 AOMcIxeKw7fHcEKKASz6pWcscS1QhAfZgjjaWCSW62/4Bv8H7OTVe/h/0aj/g3Rz3gKSr
	 ox4q6KzeZ6YN2JaavdLF2l30XyH5NAInFGTkPpxEmMF1M+VtQqmnZECGP5c+Ipmcb8q3u
	 FUhUlu2GkAhwTyZFs87EmvHKvaZPuxJXwgt8eomt4M8eigfLWvGrPD244KOSdJXX29r7T
	 /qqhhKFWL+Tdjpvo/eG8OKR8njSSjmwNLsZFj7gnSqzN7vmItlpOGnfChV6zCV2XEgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Or9yRx1k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A142606A329
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 21:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Or9yRx1k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6FFA1F000C4;
	Sat, 14 Nov 2026 21:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794690666;
	bh=PWySbDG6gTOOgHtX0X2Egn1jbX/EYKXSYGg78Rt2ZiU=;
	h=From:To:Cc:Subject:Date;
	b=Or9yRx1k8yAjmkMKC5SLTIhH2rKDeTiRNH7mB9HVU7mkKdAqlYV/wcHOnZiLrK+Js
	 iTi+angU0P+umzgB+0Wsr85H5WjM7M6f0IzZjLbkoa2oNHVl+lkvAV2ZNDG6nuimGt
	 EOw0fH0tcwJE5iBfejQhAvLkLRC8LYRxomTsiGhmCpVmx9lQ+UwFBza/CaeZCS1zbR
	 /ydQkmdQDDymATE9LoRV9RHGfaE8PbeWBxhIJxRCPNWzHx7xJqyFwC+dLmimdIvKKl
	 ii2z5D08FJapCQ/zpy9QnfRTqfJqqo9hf7h6S25/woGHkx4JabwX4SapEEo6qQmfSz
	 2C+21g7PerA7g==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-arm-kernel@lists.infradead.org,
	Emanuele Rocca <emanuele.rocca@arm.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: arm64/sm3: Use assembler for sm3 instructions
Date: Sat, 14 Nov 2026 13:10:19 -0800
Message-ID: <20261114211019.80609-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All supported assemblers (binutils 2.30 and later, and clang 17.0.1 and
later) support the sm3 instructions now.

Therefore, drop the use of '.inst' in sm3-ce-core.S and just have the
assembler generate the instructions.

This requires adding '.arch armv8.2-a+sm4'.  (Yes, the assemblers want
sm4, not sm3.)  I also tried just '.arch_extension sm4', but that
doesn't work with binutils 2.40 and earlier because they consider sm3 to
depend on armv8.2-a or later (and this file isn't built with
-march=armv8.2-a or later).  This was fixed in binutils 2.41 commit
205e4380c800, but the kernel currently supports binutils 2.30 and later.

No change in the resulting .text section with either binutils or clang.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is intended to be taken through libcrypto-next

 lib/crypto/arm64/sm3-ce-core.S | 41 +++++++---------------------------
 1 file changed, 8 insertions(+), 33 deletions(-)

diff --git a/lib/crypto/arm64/sm3-ce-core.S b/lib/crypto/arm64/sm3-ce-core.S
index ee7f900d7cff7..91eee7d760f93 100644
--- a/lib/crypto/arm64/sm3-ce-core.S
+++ b/lib/crypto/arm64/sm3-ce-core.S
@@ -8,44 +8,19 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
-	.irp		b, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
-	.set		.Lv\b\().4s, \b
-	.endr
-
-	.macro		sm3partw1, rd, rn, rm
-	.inst		0xce60c000 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
-	.endm
-
-	.macro		sm3partw2, rd, rn, rm
-	.inst		0xce60c400 | .L\rd | (.L\rn << 5) | (.L\rm << 16)
-	.endm
-
-	.macro		sm3ss1, rd, rn, rm, ra
-	.inst		0xce400000 | .L\rd | (.L\rn << 5) | (.L\ra << 10) | (.L\rm << 16)
-	.endm
-
-	.macro		sm3tt1a, rd, rn, rm, imm2
-	.inst		0xce408000 | .L\rd | (.L\rn << 5) | ((\imm2) << 12) | (.L\rm << 16)
-	.endm
-
-	.macro		sm3tt1b, rd, rn, rm, imm2
-	.inst		0xce408400 | .L\rd | (.L\rn << 5) | ((\imm2) << 12) | (.L\rm << 16)
-	.endm
-
-	.macro		sm3tt2a, rd, rn, rm, imm2
-	.inst		0xce408800 | .L\rd | (.L\rn << 5) | ((\imm2) << 12) | (.L\rm << 16)
-	.endm
-
-	.macro		sm3tt2b, rd, rn, rm, imm2
-	.inst		0xce408c00 | .L\rd | (.L\rn << 5) | ((\imm2) << 12) | (.L\rm << 16)
-	.endm
+	/*
+	 * The assemblers group the sm3 and sm4 instructions under the sm4
+	 * feature.  So we need to request sm4, despite this file being sm3.
+	 * In binutils 2.40 and earlier, armv8.2 or later is also required.
+	 */
+	.arch		armv8.2-a+sm4
 
 	.macro		round, ab, s0, t0, t1, i
 	sm3ss1		v5.4s, v8.4s, \t0\().4s, v9.4s
 	shl		\t1\().4s, \t0\().4s, #1
 	sri		\t1\().4s, \t0\().4s, #31
-	sm3tt1\ab	v8.4s, v5.4s, v10.4s, \i
-	sm3tt2\ab	v9.4s, v5.4s, \s0\().4s, \i
+	sm3tt1\ab	v8.4s, v5.4s, v10.s[\i]
+	sm3tt2\ab	v9.4s, v5.4s, \s0\().s[\i]
 	.endm
 
 	.macro		qround, ab, s0, s1, s2, s3, s4

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
-- 
2.56.1

