Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14084E4305;
	Wed, 30 Sep 2026 17:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788028; cv=none; b=fJSPEv/s6mHZ1W2KqCSy+eTlXOHdMba/htcFNRwcDTruEE8CDlIhIprjkkHkiYyzd3eVCFZMZTvzJX+yuHugQaee1oNFjbuqk8wC/NeBuA397Fj3k5cB15PB9CRvpxU9FtDv7IgMo9Pf8w8VLq4n1xwwRE/dxzFzvU56Sn/qFX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788028; c=relaxed/simple;
	bh=Ll15U5oTFGAETmmSNYy0t7V/jB8so5m0JMQs/ACqILo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiwurocPCTpmW3ElbhpAw3pintNXAL83HlJiA72ETtMrdohDSLSPqsZ6ppFG0sT0IP2sExq96flNuUu0dtaDglIXokzCUEgjE5U7EzvDqnzgjXpEU1hcavOHoeBFWC1VF1nTq7SGiA4hvwty85NUrLuf0yiH3+ubtNkjF7tMjjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VlA+OEWO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VlA+OEWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27351F00899;
	Wed, 30 Sep 2026 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790788026;
	bh=lJNNPU+h3y3yBzc4wvmuhZQC64m+gFHjjjDi0DSp/2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlA+OEWO93rJUg/FoMLbtCnqubVpiMLr7wQmhfkWxMFgll8DOJtzjWby0X8Zu8cul
	 gGyFw9OZkRf6Pq2MWiDYDnUeVDELeQ7un8lcyNZbNF6DhLhfFFdP/t1iiD/bwrd9ZB
	 9fkHpg3MeMN+nflc716WpHx13ynmxvXSqRC7OQy6KiMmfVfdeB+z8HSXPCRCQrj7u/
	 NKrNXMPv56ciLpLdVXFppPS+I7z+eclFYxLkb2JNVPmUzBfauT8/J9toENDEyMnF6o
	 LqqxMRMlQ7BJv3aro1HojYQCrfOOBtqVxDj70un7g9Y7/UEcabseg/EeH34+YwiwK/
	 k0egq2x4xO8ow==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	x86@kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 1/3] lib/crypto: x86/aes: Set RNDKEY in aes_cbc_encrypt_aesni()
Date: Wed, 30 Sep 2026 10:05:40 -0700
Message-ID: <20260930170542.140403-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930170542.140403-1-ebiggers@kernel.org>
References: <20260930170542.140403-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make aes_cbc_encrypt_aesni() set the RNDKEY register alias explicitly,
rather than reusing the alias left by the previous function (which
worked by chance).

Also consistently comment the register aliases needed by _do_aes.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 lib/crypto/x86/aes-aesni.S | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/lib/crypto/x86/aes-aesni.S b/lib/crypto/x86/aes-aesni.S
index cbc0cc23f63e..6795e82c34c8 100644
--- a/lib/crypto/x86/aes-aesni.S
+++ b/lib/crypto/x86/aes-aesni.S
@@ -444,13 +444,14 @@ SYM_FUNC_START(aes_cbc_encrypt_aesni)
 
 	// Other local variables
 #ifdef __x86_64__
-	.set	RNDKEY_PTR,	%r9
+	.set	RNDKEY_PTR,	%r9	// Temporary register for _do_aes
 #else
-	.set	RNDKEY_PTR,	IV_PTR // IV_PTR is clobbered and reloaded later
+	.set	RNDKEY_PTR,	IV_PTR	// IV_PTR is clobbered and reloaded later
 #endif
-	.set	NROUNDS,	TMP_32
+	.set	NROUNDS,	TMP_32	// Temporary register for _do_aes
 	.set	AESDATA0,	%xmm0
 	.set	PTEXT,		%xmm1
+	.set	RNDKEY,		%xmm2	// Temporary register for _do_aes
 	_prologue	uses_arg3=2, uses_arg4=2
 
 	movdqu		(IV_PTR), AESDATA0
@@ -484,16 +485,16 @@ SYM_FUNC_START(aes_cbc_decrypt_aesni)
 
 	// Other local variables
 #ifdef __x86_64__
-	.set	RNDKEY_PTR,	%r9
+	.set	RNDKEY_PTR,	%r9	// Temporary register for _do_aes
 #else
-	.set	RNDKEY_PTR,	IV_PTR // IV_PTR is clobbered and reloaded later
+	.set	RNDKEY_PTR,	IV_PTR	// IV_PTR is clobbered and reloaded later
 #endif
-	.set	NROUNDS,	TMP_32
+	.set	NROUNDS,	TMP_32	// Temporary register for _do_aes
 	.set	AESDATA0,	%xmm0
 	.set	AESDATA1,	%xmm1
 	.set	AESDATA2,	%xmm2
 	.set	AESDATA3,	%xmm3
-	.set	RNDKEY,		%xmm4
+	.set	RNDKEY,		%xmm4	// Temporary register for _do_aes
 	.set	IV,		%xmm5
 	.set	CTEXT0,		%xmm6
 	.set	CTEXT1,		%xmm7
@@ -575,7 +576,7 @@ SYM_FUNC_END(aes_cbc_decrypt_aesni)
 	.set	LSHIFT_MASK,	%xmm1 // [0x80, 0x80, ...] + range(PN_LEN)
 	.set	AESDATA0,	%xmm2
 	.set	AESDATA1,	%xmm3
-	.set	RNDKEY,		%xmm4 // Temporary register for _do_aes
+	.set	RNDKEY,		%xmm4	// Temporary register for _do_aes
 	.set	IV,		%xmm5
 
 	_prologue	uses_arg3=2, uses_arg4=2
@@ -674,7 +675,7 @@ SYM_FUNC_START(aes_ctr64_crypt_aesni)
 	.set	LE_CTR,		%xmm4	// Current 128-bit little endian counter
 	.set	LE_CTR_INC,	%xmm5	// Initialized to (u64[])[1, 0]
 	.set	BSWAP_MASK,	%xmm6
-	.set	RNDKEY,		%xmm7
+	.set	RNDKEY,		%xmm7	// Temporary register for _do_aes
 	.set	RNDKEY_PTR,	LE_CTR_PTR  // Temporary register for _do_aes
 	.set	NROUNDS,	TMP_32	// Temporary register for _do_aes
 
@@ -795,17 +796,17 @@ SYM_FUNC_END(aes_ctr64_crypt_aesni)
 
 	// Other local variables
 #ifdef __x86_64__
-	.set	RNDKEY_PTR,	%r9
+	.set	RNDKEY_PTR,	%r9	// Temporary register for _do_aes
 #else
 	.set	RNDKEY_PTR,	TWEAK_PTR // TWEAK_PTR is clobbered and reloaded later.
 #endif
-	.set	NROUNDS,	TMP_32
+	.set	NROUNDS,	TMP_32	// Temporary register for _do_aes
 	.set	AESDATA0,	%xmm0
 	.set	AESDATA1,	%xmm1
 	.set	AESDATA2,	%xmm2
 	.set	AESDATA3,	%xmm3
 	.set	GF_POLY,	%xmm4
-	.set	RNDKEY,		%xmm5
+	.set	RNDKEY,		%xmm5	// Temporary register for _do_aes
 	.set	TWEAK,		%xmm6
 	.set	SAVED_TWEAK0,	%xmm7
 #ifdef __x86_64__
-- 
2.55.0

