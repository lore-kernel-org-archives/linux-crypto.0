Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793424112;
	b=p+++sjuBXmel2nPTfjGAX1DyV0ohN2jRTd4RqmRKRb7LqSTREV+XCNvftEu3N6+MatBt
	 aMwCNXlmIBK/Of0yErnIlHqmty1QQWcXf08NSyFmx4TC2baZfYKVSWhcvGVSI1dcWQ1Ek
	 fpz02I2O+LyKlAL+iwiiBnqe1843i0uz7W9H+rn7g/0/V77ZLPkUJx0BSgCGmM4K/DxUq
	 e84fJ94do9ajGhm+dkQh6nDUiNRLnAbP2ycQNKNZAfk6dzjU4DpvjKgSFiJUbKbG4cxKj
	 MaRSnu1qiQedkDs4vaYq/QYY514DLnWLzmMpm0b2QJnwqEQ2Aa2JTLe3QFXG9HTNHZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793424112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nhGj4WC9tvZroxN/qiQX69HHKRPAZK+8FvNdfCptljc=;
	b=f4O7EKUu5QtVsHx/6o4FoMPG6594ZtTRUUIM0mdnKLKcG/PHMFVfMbmS+0y47wa0LaX3
	 2noIBIHvg1AlfzE1zKLN0vrMMkydCA9Q4QfLo/6IketCyNV0ZZaOsxO/FrocWseSkl+6Z
	 gVY+wsqRcSTsrTgXvKDyYRdhIHeEMh5+OoVj/jA7oBC80QDqId/xQCHCSy79JwXcJWrWV
	 d5OnymZjxvbFEOKf3DRZvOk5NdHhd9Gnv8F2wcDHWqzEmCE4AVpNKkHoPb5cAG8X5UGkO
	 TFPphAW6QCkxOE+y3kza01uW5tVi5F8wqIkU8MP0fAWFleiaAVOsmUXCqsW5nFhJ04g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZwiaSdf8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C4A606A31F
	for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2026 05:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZwiaSdf8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 959811F00919;
	Sat, 31 Oct 2026 05:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793424111;
	bh=nhGj4WC9tvZroxN/qiQX69HHKRPAZK+8FvNdfCptljc=;
	h=From:To:Cc:Subject:Date;
	b=ZwiaSdf85FRcHDgNOjjH7z4OkOMtWg4vQ9BtWrOXarOblA79SJ0cdn5ujzRmp/wwW
	 TD4NFFDmVB+2opvolUKsPXCKmrb8HE9LGahv7yPsRVA+QZOee2rjIf9lQuRTS1SuUM
	 FAf6na1FC3uskpKBbx1jTAaq/6+Ld8wH18e8pLuPGS0umPThM0dvazyyhOzBUHVEfN
	 SLbNw7sVm3N4b/XCDh7b87S8G+sAV8vmFAam/tCpHEFfo5khHgspu3JzfEbSrbea+G
	 OSQ24oVc8W5Ba/ZO7PST6it558wKJOFFACM4BnqrVTSGX1F07icp4mpWIV22a0ytjL
	 iCaCGEzbhZdog==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: gf128hash: Hide selection mask values from compilers
Date: Fri, 30 Oct 2026 22:21:49 -0700
Message-ID: <20261031052149.201983-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.56.0
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

Hide selection mask values from compilers, so that they cannot see that
they are used to select between two values and potentially generate a
secret-dependent branch.  This is not known to be happening here, but we
might as well be extra careful.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/gf128hash.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/gf128hash.c b/lib/crypto/gf128hash.c
index 8dcdf5ec98be..5b8ae98cafed 100644
--- a/lib/crypto/gf128hash.c
+++ b/lib/crypto/gf128hash.c
@@ -88,10 +88,18 @@ static void clmul64(u64 a, u64 b, u64 *out_lo, u64 *out_hi)
 		  (a2 * (u128)b1) ^ (a3 * (u128)b0);
 
 	/* Multiply the low 4 bits of @a by @b. */
-	u64 e0 = -(a & 1) & b;
-	u64 e1 = -((a >> 1) & 1) & b;
-	u64 e2 = -((a >> 2) & 1) & b;
-	u64 e3 = -((a >> 3) & 1) & b;
+	u64 e0 = -(a & 1);
+	u64 e1 = -((a >> 1) & 1);
+	u64 e2 = -((a >> 2) & 1);
+	u64 e3 = -((a >> 3) & 1);
+	OPTIMIZER_HIDE_VAR(e0);
+	OPTIMIZER_HIDE_VAR(e1);
+	OPTIMIZER_HIDE_VAR(e2);
+	OPTIMIZER_HIDE_VAR(e3);
+	e0 &= b;
+	e1 &= b;
+	e2 &= b;
+	e3 &= b;
 	u64 extra_lo = e0 ^ (e1 << 1) ^ (e2 << 2) ^ (e3 << 3);
 	u64 extra_hi = (e1 >> 63) ^ (e2 >> 62) ^ (e3 >> 61);
 
@@ -245,6 +253,7 @@ static void __maybe_unused ghash_key_to_polyval(const u8 in[GHASH_BLOCK_SIZE],
 	u64 lo = get_unaligned_be64(&in[8]);
 	u64 mask = (s64)hi >> 63;
 
+	OPTIMIZER_HIDE_VAR(mask);
 	hi = (hi << 1) ^ (lo >> 63) ^ (mask & ((u64)0xc2 << 56));
 	lo = (lo << 1) ^ (mask & 1);
 	out->lo = cpu_to_le64(lo);

base-commit: 2a500a04d6f969318c05f46aedb6e73fc1963a00
-- 
2.56.0

