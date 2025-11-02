Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9901234D3B4;
	Sun,  2 Nov 2025 01:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762047955; cv=none; b=cYaVrW/COXQ/3I3sKVfD231kKJOUBCv0moXXqK0qaHPXsjQBQx5yHIBKeRuL0K/R2w/LxgRXr2fGTex7m4Ob+sCjtjV9RclbmpNC1iZ584dAWsoWNG+vWoUDP8vJ4YV8K+C56EpBWIX96vQG0wBm7+g2H2TXsNbg0BnRkw9RlOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762047955; c=relaxed/simple;
	bh=tgrI+I420JUQeKcc5dPb2Ro4SGq5TSKXKMzO89hc6bc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VgYRyQ25KvzKWtURpYy0oBx73ioipRNqj+FH5l6/gLUWCcHNjan79f6lj3VVDjZPJbFYcANal0Ujb/7qxlrz7EkFQTJqeIMRuQxzRIZ6dZuE/MEeiOIkUgn2sjLpa00YghEQ2EuSFmEnssu/aC79NGNDDNUUuNiv8vnNc46+7og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MqoUtjxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MqoUtjxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBA8C4CEF1;
	Sun,  2 Nov 2025 01:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762047955;
	bh=tgrI+I420JUQeKcc5dPb2Ro4SGq5TSKXKMzO89hc6bc=;
	h=From:To:Cc:Subject:Date:From;
	b=MqoUtjxJ+qrE85r6Gthd8zh3RSUYuz1fZVlGCHAfvsw5ggPHzspx9716sTbdvaW6P
	 KHWc/VjdgpM7bElDP29w/wQmQZLZw28LEa4iLWfdJM3Wo+R4xUVGFRApG56z2pczcm
	 /h+OV7nrNEpeyFCAU4A0fgg1tpwU9MXf1zj3Y4rh/M37WGj/+HAyA8eUxrU85yB4Ob
	 T4BCCh2mTQOMPvPiAxobTJZvHq1efKkLL9HFJoM4VGTySsX6b+JF54+uxBDADzSex0
	 WbgydKZOZK9CwMX+9BPYBNz9AHa7J9QmJrQVq6+u30dK4QMIcF8pz+sSVbFB/5W/Io
	 NMo3t3B1jKk0Q==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] lib/crypto: arm/blake2s: Fix some comments
Date: Sat,  1 Nov 2025 18:45:41 -0700
Message-ID: <20251102014541.170188-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Fix the indices in some comments in blake2s-core.S.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This is targeting libcrypto-next

 lib/crypto/arm/blake2s-core.S | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/crypto/arm/blake2s-core.S b/lib/crypto/arm/blake2s-core.S
index 14eb7c18a836..5553e473f131 100644
--- a/lib/crypto/arm/blake2s-core.S
+++ b/lib/crypto/arm/blake2s-core.S
@@ -207,22 +207,22 @@ ENTRY(blake2s_compress)
 	_le32_bswap_8x	r2, r3, r4, r5, r6, r7, r8, r9,  r14
 	stmia		r12, {r2-r9}
 .Lcopy_block_done:
 	str		r1, [sp, #68]		// Update message pointer
 
-	// Calculate v[8..15].  Push v[9..15] onto the stack, and leave space
+	// Calculate v[8..15].  Push v[10..15] onto the stack, and leave space
 	// for spilling v[8..9].  Leave v[8..9] in r8-r9.
 	mov		r14, r0			// r14 = ctx
 	adr		r12, .Lblake2s_IV
 	ldmia		r12!, {r8-r9}		// load IV[0..1]
 	__ldrd		r0, r1, r14, 40		// load f[0..1]
-	ldm		r12, {r2-r7}		// load IV[3..7]
+	ldm		r12, {r2-r7}		// load IV[2..7]
 	eor		r4, r4, r10		// v[12] = IV[4] ^ t[0]
 	eor		r5, r5, r11		// v[13] = IV[5] ^ t[1]
 	eor		r6, r6, r0		// v[14] = IV[6] ^ f[0]
 	eor		r7, r7, r1		// v[15] = IV[7] ^ f[1]
-	push		{r2-r7}			// push v[9..15]
+	push		{r2-r7}			// push v[10..15]
 	sub		sp, sp, #8		// leave space for v[8..9]
 
 	// Load h[0..7] == v[0..7].
 	ldm		r14, {r0-r7}
 

base-commit: 5a2a5e62a5216ba05d4481cf90d915f4de0bfde9
-- 
2.51.2

