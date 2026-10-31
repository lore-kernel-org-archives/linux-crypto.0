Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793424117;
	b=AbHNxaWRi44KUTj5ZZ0J1tGEqXdYd0jXAxqIoQ3T3xU17UHO7B97Z85XyN25RzaaR+Yx
	 4Kkf0orMmmV04/WOsio2Q/YpJqAMmcQePhyJ0VkGcS6tBHPKqqArjGjKcRhSqk8Tmxn7C
	 u28YCYKW+9pa1OTBehfr8AmF7uWCfq0mZTunIjbd1mjdMEyL3I2S95soaWIlM9KjjFG3F
	 muRcGzh/+qzmYOeWeDLWoBFL9he9Pc7SrtlE/5tIDEYksTo2l6L/iRlxsZWctxOd8Bswt
	 1MzuqR7DkWkxMXo7uyU8b5yeAeG4iMR9/PgvYd/w7MQDOFmzLhnEaS/9LiuPaZoMCPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793424117;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vmLjm7YF5xeLN8ZgiTJ2ofDl5xqbiOhdga1bujEtVsE=;
	b=3Dk5yTItXvMhannCxp9NFCyE0r8vAR4fRP0z2cTeL5x/xo17ObMJxhx06wWJNKybTc/I
	 /Jd35qCDLLvmATwWBoQxwZ8X9BNPhLGGWDSsRs589Ud6QByVnKAQl4fWNB7Iw5r566V0Z
	 /LFGH5qXzSqYBRngDZ4hkdfC4SJmX/DvONVZI9yAwd56ILqTyKrh5d2dmyqjtCfUPaqQE
	 m3hnlVPLi2v0EQeO7S3Qgnfe7hniXKSAvJva/5+T5E/YMMeNrk8w1qkQlRobLC1/y1BKw
	 +sX09BkcJkCE8hEl2w1dQ5/FCCnPmR1gAGBF9cM0HVJoKXwbsbEKMJEWM6ODLQQmI/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yk9M1qqX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A702606A320
	for <linux-crypto@vger.kernel.org>; Sat, 31 Oct 2026 05:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yk9M1qqX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C475A1F00919;
	Sat, 31 Oct 2026 05:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793424117;
	bh=vmLjm7YF5xeLN8ZgiTJ2ofDl5xqbiOhdga1bujEtVsE=;
	h=From:To:Cc:Subject:Date;
	b=Yk9M1qqXJNVj53IHx0Ei43em2jk6UMe/zdQcKiRFH9tkbzFANbfKEScYOEkMOy+A2
	 g40zpxcVF3GUY3JcZIE3SNW5/N9VlbXIfgWvncmqi71Is1BBVUV0/2E1eOJS581zWc
	 6AdGEZzs88AnMsoQBTxh3eNbCvXL6LfGnxR//0iQJPqWnINuIJZN3kXek0G7/SmAY2
	 KiE7LiFmMI4XZFT7Es3dKFcfVaBFD6Y9a1jBCgyZhlU8GaeC9zOBACB6yDXXeJ1U05
	 JKk68u5YAcTt1EsxKRCEMjXrV68KZMjg/cmMXCruouljT8joyX2ekGqGvKP8E1NDVk
	 3OzCtMX/Vxm8w==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: gf128mul: Hide selection mask values from compilers
Date: Fri, 30 Oct 2026 22:21:54 -0700
Message-ID: <20261031052154.202008-1-ebiggers@kernel.org>
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

For the cases where the selected values are only 0x87 and 0, change the
type of the mask to 'unsigned long' so that the compiler is not forced
to materialize it in a register pair on 32-bit architectures.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 include/crypto/gf128mul.h | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/include/crypto/gf128mul.h b/include/crypto/gf128mul.h
index 6ed2a8351902..8fb6f8dbbfa9 100644
--- a/include/crypto/gf128mul.h
+++ b/include/crypto/gf128mul.h
@@ -171,35 +171,28 @@ void gf128mul_lle(be128 *a, const be128 *b);
  * They are defined here for performance.
  */
 
-static inline u64 gf128mul_mask_from_bit(u64 x, int which)
-{
-	/* a constant-time version of 'x & ((u64)1 << which) ? (u64)-1 : 0' */
-	return ((s64)(x << (63 - which)) >> 63);
-}
-
 static inline void gf128mul_x_lle(be128 *r, const be128 *x)
 {
 	u64 a = be64_to_cpu(x->a);
 	u64 b = be64_to_cpu(x->b);
+	u64 mask = -(b & 1);
 
-	/* equivalent to gf128mul_table_le[(b << 7) & 0xff] << 48
-	 * (see crypto/gf128mul.c): */
-	u64 _tt = gf128mul_mask_from_bit(b, 0) & ((u64)0xe1 << 56);
+	OPTIMIZER_HIDE_VAR(mask);
 
 	r->b = cpu_to_be64((b >> 1) | (a << 63));
-	r->a = cpu_to_be64((a >> 1) ^ _tt);
+	r->a = cpu_to_be64((a >> 1) ^ (mask & ((u64)0xe1 << 56)));
 }
 
 static inline void gf128mul_x_bbe(be128 *r, const be128 *x)
 {
 	u64 a = be64_to_cpu(x->a);
 	u64 b = be64_to_cpu(x->b);
+	unsigned long mask = (s64)a >> 63;
 
-	/* equivalent to gf128mul_table_be[a >> 63] (see crypto/gf128mul.c): */
-	u64 _tt = gf128mul_mask_from_bit(a, 63) & 0x87;
+	OPTIMIZER_HIDE_VAR(mask);
 
 	r->a = cpu_to_be64((a << 1) | (b >> 63));
-	r->b = cpu_to_be64((b << 1) ^ _tt);
+	r->b = cpu_to_be64((b << 1) ^ (mask & 0x87));
 }
 
 /* needed by XTS */
@@ -207,12 +200,12 @@ static inline void gf128mul_x_ble(le128 *r, const le128 *x)
 {
 	u64 a = le64_to_cpu(x->a);
 	u64 b = le64_to_cpu(x->b);
+	unsigned long mask = (s64)a >> 63;
 
-	/* equivalent to gf128mul_table_be[b >> 63] (see crypto/gf128mul.c): */
-	u64 _tt = gf128mul_mask_from_bit(a, 63) & 0x87;
+	OPTIMIZER_HIDE_VAR(mask);
 
 	r->a = cpu_to_le64((a << 1) | (b >> 63));
-	r->b = cpu_to_le64((b << 1) ^ _tt);
+	r->b = cpu_to_le64((b << 1) ^ (mask & 0x87));
 }
 
 void gf128mul_x8_ble(le128 *r, const le128 *x);

base-commit: 2a500a04d6f969318c05f46aedb6e73fc1963a00
-- 
2.56.0

