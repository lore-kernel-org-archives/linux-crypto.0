Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D860A24A046;
	Mon, 29 Dec 2025 22:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767047948; cv=none; b=pfvBH8gO5/k0v3jDyH/O/dm0rsRs1bdDs28X9rBX6NSi+3K8aVe2ItvsKj8vCjaJKXiwXfXy+UEApgwxAMdZflb5aAyXAXCRFjyhZsHKZkgBKDM8cTImKFNWzHZL6FNkVDKnKZVKBEB32Q6UL0d1AOM0qAw8QhU6a32Eqyotd/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767047948; c=relaxed/simple;
	bh=G9tQ0hkFSi73XXtRzgVQUNRUaxJUsQu73ITJfWZswWI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=j29lAkz+Az3shvnOqMJMqfJQrNg/mAiRGW+HBECxyzN4F3rwl10AtHzI2WnEM4d5MXZeNYwZoDTh51qMSqw1dPHI1cgCtlm932kC8ZLkqNKTCgISq6iHPBiE1ydDwMUxrkSKYRRAOmOCjeoihT0TLozoJYoVHodPKwHHKnbj/sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=loI30cCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="loI30cCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 338F1C4CEF7;
	Mon, 29 Dec 2025 22:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767047947;
	bh=G9tQ0hkFSi73XXtRzgVQUNRUaxJUsQu73ITJfWZswWI=;
	h=From:To:Cc:Subject:Date:From;
	b=loI30cCvRXDdija63qGpBf6jdiWTTQes9pMyumpng4P/dbw61ZpvjYJ4rq0RoZowf
	 Z6YAgMalwlkoYsR6R0/FbXBWJuUPejONQrm3vrdj/ZZgaivNDzFGER6WFXxnlxoJGT
	 Clo9JPNd6SpBGBKDiNtdGeItv1w3Z0S1aEVTTQHCESH9qB7Bp4s7sPJrurWuByP1HW
	 4xgXeh9XKUMu1YdJqzEm5Kg8UJfZthYrfX+IYrTJeW3Xa+MMweDAClNANJW491iy48
	 c9JB9Agz6ixnvqKv+cMEvWM+CM3UjEWaJXTZRbH8m0cCTQZM3R3vBY1eS8dS8t8uPQ
	 ggfweNn/n7Mng==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12] lib/crypto: riscv/chacha: Avoid s0/fp register
Date: Mon, 29 Dec 2025 14:37:29 -0800
Message-ID: <20251229223729.99861-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Vivian Wang <wangruikang@iscas.ac.cn>

commit 43169328c7b4623b54b7713ec68479cebda5465f upstream.

In chacha_zvkb, avoid using the s0 register, which is the frame pointer,
by reallocating KEY0 to t5. This makes stack traces available if e.g. a
crash happens in chacha_zvkb.

No frame pointer maintenance is otherwise required since this is a leaf
function.

Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
Fixes: bb54668837a0 ("crypto: riscv - add vector crypto accelerated ChaCha20")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20251202-riscv-chacha_zvkb-fp-v2-1-7bd00098c9dc@iscas.ac.cn
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 arch/riscv/crypto/chacha-riscv64-zvkb.S | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/crypto/chacha-riscv64-zvkb.S b/arch/riscv/crypto/chacha-riscv64-zvkb.S
index bf057737ac69..fbef93503571 100644
--- a/arch/riscv/crypto/chacha-riscv64-zvkb.S
+++ b/arch/riscv/crypto/chacha-riscv64-zvkb.S
@@ -58,11 +58,12 @@
 #define CONSTS3		t0
 #define TMP		t1
 #define VL		t2
 #define STRIDE		t3
 #define NROUNDS		t4
-#define KEY0		s0
+#define KEY0		t5
+// Avoid s0/fp to allow for unwinding
 #define KEY1		s1
 #define KEY2		s2
 #define KEY3		s3
 #define KEY4		s4
 #define KEY5		s5
@@ -139,11 +140,10 @@
 // The counter is treated as 32-bit, following the RFC7539 convention.
 SYM_FUNC_START(chacha20_zvkb)
 	srli		LEN, LEN, 6	// Bytes to blocks
 
 	addi		sp, sp, -96
-	sd		s0, 0(sp)
 	sd		s1, 8(sp)
 	sd		s2, 16(sp)
 	sd		s3, 24(sp)
 	sd		s4, 32(sp)
 	sd		s5, 40(sp)
@@ -275,11 +275,10 @@ SYM_FUNC_START(chacha20_zvkb)
 	slli		TMP, VL, 6
 	add		OUTP, OUTP, TMP
 	add		INP, INP, TMP
 	bnez		LEN, .Lblock_loop
 
-	ld		s0, 0(sp)
 	ld		s1, 8(sp)
 	ld		s2, 16(sp)
 	ld		s3, 24(sp)
 	ld		s4, 32(sp)
 	ld		s5, 40(sp)

base-commit: 567bd8cbc2fe6b28b78864cbbbc41b0d405eb83c
-- 
2.52.0

