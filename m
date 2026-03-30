Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFD6328635
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 14:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882009; cv=none; b=NyUNB0H7Kp9Sf8S5Uj4Vuf3wR27OYrXSybODg0QKIx1vVmEH619aBPxrGZJrEeMJ+Jsd+LvwadVHiHs0eIYzUO6Dt98ruf7D8ZlILrGMkjj74iPD1sOOHEfBIUXCtTwYbk+na0KGPOpOchU6yVGU9Zc2aXyHpTC/gAHH/o9ttlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882009; c=relaxed/simple;
	bh=a2bRJJV06pDUfar9AVIXf8mKBfCBb7ekOHr20b95eZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYDV1Eb8jvvUQX9OENOGqplWfPxBB0UOr5hQH80E+mkfQivfQsbrDG8xKXQsY6py1FtOWwMLlV3TaVermiV/R1f8eV9dwF6ooyOjJmuhdXL0rv10DtcGa1af52Eh6v+KDPYz37lcbc8p4oZ3OnIdduNgqYcY7f6rRgcQXPWuArA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=inwoVNV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="inwoVNV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F961C4CEF7;
	Mon, 30 Mar 2026 14:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882009;
	bh=a2bRJJV06pDUfar9AVIXf8mKBfCBb7ekOHr20b95eZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inwoVNV9Q1GkftBVGCxjJs9iVmztdDuqEN/OmLXP02ajSRTDySrGMzsugVDetN7Gg
	 PMcf/+bGoPaxOd7saE+Nyamb1qLgXaaJ/qyjPocT2OJmtraI15yt9eBwY8o1cwNKMc
	 zf0SH444+N0C93Cx+ZGh+g+TrfEp8qmG+emX+c1BStrPycYMy/c/E63dHYz+Eruwin
	 FQ6CVmpI4S84buVbQ7CEyhyHeP8EmuQ6O8McfAtqnfGOVQdNdNq3vS5voqByEE1Kd6
	 VAUH9Vj1Ic2jMfbaYBG6WDFNF4rQhG4juCzDFezB0ZtVZJ6kLwH8/Mc0WTcAFV+q2S
	 F9/0aC2cPIXoQ==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Demian Shulhan <demyansh@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 4/5] lib/crc: arm64: Simplify intrinsics implementation
Date: Mon, 30 Mar 2026 16:46:35 +0200
Message-ID: <20260330144630.33026-11-ardb@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260330144630.33026-7-ardb@kernel.org>
References: <20260330144630.33026-7-ardb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4877; i=ardb@kernel.org; h=from:subject; bh=a2bRJJV06pDUfar9AVIXf8mKBfCBb7ekOHr20b95eZc=; b=owGbwMvMwCn83sBh/rljoYmMp9WSGDJP9Zw4dP5E6R6nqSm+OyeVHrz113L1o00vZp/dEKzMt 5it/shf/o6pLAzCnAyyYoosO5Vzul+7iL7TV6jMgZnDygQyhIGLUwAmwnGfsc5eQuUS884F3jrn psacCss40Vjr5Glt1MikIjr7rQFvqHbL71bJd+2cV7Mzuq7WzZj5mbFhfk1wYD5btNmsqSXavbN W3e6aFxecO6ew94bGoq7+rc9Xt7os0eO53bZKtt1A0XHd3ZsA
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit

NEON intrinsics are useful because they remove the need for manual
register allocation, and the resulting code can be re-compiled and
optimized for different micro-architectures, and shared between arm64
and 32-bit ARM.

However, the strong typing of the vector variables can lead to
incomprehensible gibberish, as is the case with the new CRC64
implementation. To address this, let's repaint all variables as
uint64x2_t to minimize the number of vreinterpretq_xxx() calls, and to
be able to rely on the ^ operator for exclusive OR operations. This
makes the code much more concise and readable.

While at it, wrap the calls to vmull_p64() et al in order to have a more
consistent calling convention, and encapsulate any remaining
vreinterpret() calls that are still needed.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 lib/crc/arm64/crc64-neon-inner.c | 77 ++++++++------------
 1 file changed, 32 insertions(+), 45 deletions(-)

diff --git a/lib/crc/arm64/crc64-neon-inner.c b/lib/crc/arm64/crc64-neon-inner.c
index 881cdafadb37..28527e544ff6 100644
--- a/lib/crc/arm64/crc64-neon-inner.c
+++ b/lib/crc/arm64/crc64-neon-inner.c
@@ -8,9 +8,6 @@
 
 u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len);
 
-#define GET_P64_0(v) ((poly64_t)vgetq_lane_u64(vreinterpretq_u64_p64(v), 0))
-#define GET_P64_1(v) ((poly64_t)vgetq_lane_u64(vreinterpretq_u64_p64(v), 1))
-
 /* x^191 mod G, x^127 mod G */
 static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
 					0x21e9761e252621acULL };
@@ -18,61 +15,51 @@ static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
 static const u64 bconsts_val[2] = { 0x27ecfa329aef9f77ULL,
 				    0x34d926535897936aULL };
 
-u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len)
+static inline uint64x2_t pmull64(uint64x2_t a, uint64x2_t b)
 {
-	uint64x2_t v0_u64 = { crc, 0 };
-	poly64x2_t v0 = vreinterpretq_p64_u64(v0_u64);
-	poly64x2_t fold_consts =
-		vreinterpretq_p64_u64(vld1q_u64(fold_consts_val));
-	poly64x2_t v1 = vreinterpretq_p64_u8(vld1q_u8(p));
+	return vreinterpretq_u64_p128(vmull_p64(vgetq_lane_u64(a, 0),
+						vgetq_lane_u64(b, 0)));
+}
 
-	v0 = vreinterpretq_p64_u8(veorq_u8(vreinterpretq_u8_p64(v0),
-					   vreinterpretq_u8_p64(v1)));
-	p += 16;
-	len -= 16;
+static inline uint64x2_t pmull64_high(uint64x2_t a, uint64x2_t b)
+{
+	poly64x2_t l = vreinterpretq_p64_u64(a);
+	poly64x2_t m = vreinterpretq_p64_u64(b);
 
-	do {
-		v1 = vreinterpretq_p64_u8(vld1q_u8(p));
+	return vreinterpretq_u64_p128(vmull_high_p64(l, m));
+}
 
-		poly128_t v2 = vmull_high_p64(fold_consts, v0);
-		poly128_t v0_128 =
-			vmull_p64(GET_P64_0(fold_consts), GET_P64_0(v0));
+static inline uint64x2_t pmull64_hi_lo(uint64x2_t a, uint64x2_t b)
+{
+	return vreinterpretq_u64_p128(vmull_p64(vgetq_lane_u64(a, 1),
+						vgetq_lane_u64(b, 0)));
+}
 
-		uint8x16_t x0 = veorq_u8(vreinterpretq_u8_p128(v0_128),
-					 vreinterpretq_u8_p128(v2));
+u64 crc64_nvme_arm64_c(u64 crc, const u8 *p, size_t len)
+{
+	uint64x2_t fold_consts = vld1q_u64(fold_consts_val);
+	uint64x2_t v0 = { crc, 0 };
+	uint64x2_t zero = { };
 
-		x0 = veorq_u8(x0, vreinterpretq_u8_p64(v1));
-		v0 = vreinterpretq_p64_u8(x0);
+	for (;;) {
+		v0 ^= vreinterpretq_u64_u8(vld1q_u8(p));
 
 		p += 16;
 		len -= 16;
-	} while (len >= 16);
-
-	/* Multiply the 128-bit value by x^64 and reduce it back to 128 bits. */
-	poly64x2_t v7 = vreinterpretq_p64_u64((uint64x2_t){ 0, 0 });
-	poly128_t v1_128 = vmull_p64(GET_P64_1(fold_consts), GET_P64_0(v0));
+		if (len < 16)
+			break;
 
-	uint8x16_t ext_v0 =
-		vextq_u8(vreinterpretq_u8_p64(v0), vreinterpretq_u8_p64(v7), 8);
-	uint8x16_t x0 = veorq_u8(ext_v0, vreinterpretq_u8_p128(v1_128));
+		v0 = pmull64(fold_consts, v0) ^ pmull64_high(fold_consts, v0);
+	}
 
-	v0 = vreinterpretq_p64_u8(x0);
+	/* Multiply the 128-bit value by x^64 and reduce it back to 128 bits. */
+	v0 = vextq_u64(v0, zero, 1) ^ pmull64_hi_lo(fold_consts, v0);
 
 	/* Final Barrett reduction */
-	poly64x2_t bconsts = vreinterpretq_p64_u64(vld1q_u64(bconsts_val));
-
-	v1_128 = vmull_p64(GET_P64_0(bconsts), GET_P64_0(v0));
-
-	poly64x2_t v1_64 = vreinterpretq_p64_u8(vreinterpretq_u8_p128(v1_128));
-	poly128_t v3_128 = vmull_p64(GET_P64_1(bconsts), GET_P64_0(v1_64));
-
-	x0 = veorq_u8(vreinterpretq_u8_p64(v0), vreinterpretq_u8_p128(v3_128));
-
-	uint8x16_t ext_v2 = vextq_u8(vreinterpretq_u8_p64(v7),
-				     vreinterpretq_u8_p128(v1_128), 8);
+	uint64x2_t bconsts = vld1q_u64(bconsts_val);
+	uint64x2_t final = pmull64(bconsts, v0);
 
-	x0 = veorq_u8(x0, ext_v2);
+	v0 ^= vextq_u64(zero, final, 1) ^ pmull64_hi_lo(bconsts, final);
 
-	v0 = vreinterpretq_p64_u8(x0);
-	return vgetq_lane_u64(vreinterpretq_u64_p64(v0), 1);
+	return vgetq_lane_u64(v0, 1);
 }
-- 
2.53.0.1018.g2bb0e51243-goog

