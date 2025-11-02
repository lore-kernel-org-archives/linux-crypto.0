Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 313BA2F56;
	Sun,  2 Nov 2025 02:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762049774; cv=none; b=Z01AkSiJZA3YWi5Xl64lTz+qwQbv3QrkyMARj1X0QHiFfJdmBONFuoZTE5cHR1V36z5T1OPeeaaN9t5nx2fguQ15Oo07lpY80k0/wPaE+/gzk+OeGhVUWAVy6H+Zao/z2Zdg0hw9Jqh79et7QSB2U3FCinukK2xq66QNbsTpsFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762049774; c=relaxed/simple;
	bh=IhILa7q+QWjgRJMc9buThJ+9nju/E8F3i03bMj9qMLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bHYY3a1oQF8y8b5npnVI+izH5lJIkz6tMRE32whglgTEYGa73GX0Sepyddzsp1PtbEkc2ZsV5TKT2T+THCBit9rUhb8KGhc1Meh93PuJF56XulBYuOwtuLsmjd5BgqhjxyLOLFkjli9Eli06Zk99/jO7slKJ/U+5NS2QeefzUik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V6PakqWS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V6PakqWS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E5D7C4CEF1;
	Sun,  2 Nov 2025 02:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762049771;
	bh=IhILa7q+QWjgRJMc9buThJ+9nju/E8F3i03bMj9qMLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6PakqWSI/KghR9vn65BHgyqqTMuKoEJ0jocLVpwKYHFuFttm72p7gsfcvl5ITNsG
	 b0DfeKkxQTcgoHNfKg1cJDxa40dLeBtntdlL3bC3FPO/vMnYZi4YIThP8z1HE9RGsg
	 AZtMSWTBbqCgyHpKu289UEJT7+O1PGVdM8tEd3rxqCgC8alDuWHzXCg1Z3iThJDl/k
	 MyvGhJpgSO6Nrwpom5qaS2H841i1gemnHTN0JOw53uJh7nz75UlcqbL4Qd6SFsLyyq
	 Guvd9fEhjMN1QLMTx5RkY6RoveyOfBM+tao+VsMkONPtmN0nu3eCRuXVx+BerLYfG7
	 bMAzPH9nBdlsQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2] lib/crypto: arm/blake2s: Fix some comments
Date: Sat,  1 Nov 2025 19:15:53 -0700
Message-ID: <20251102021553.176587-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251102014541.170188-1-ebiggers@kernel.org>
References: <20251102014541.170188-1-ebiggers@kernel.org>
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

v2: Fixed the same mistake in another place.

This patch is targeting libcrypto-next

 lib/crypto/arm/blake2s-core.S | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/crypto/arm/blake2s-core.S b/lib/crypto/arm/blake2s-core.S
index 14eb7c18a836..933f0558b7cd 100644
--- a/lib/crypto/arm/blake2s-core.S
+++ b/lib/crypto/arm/blake2s-core.S
@@ -113,11 +113,11 @@
 	eor		\b1, \c1, \b1, ror#12
 .endm
 
 // Execute one round of BLAKE2s by updating the state matrix v[0..15].  v[0..9]
 // are in r0..r9.  The stack pointer points to 8 bytes of scratch space for
-// spilling v[8..9], then to v[9..15], then to the message block.  r10-r12 and
+// spilling v[8..9], then to v[10..15], then to the message block.  r10-r12 and
 // r14 are free to use.  The macro arguments s0-s15 give the order in which the
 // message words are used in this round.
 //
 // All rotates are performed using the implicit rotate operand accepted by the
 // 'add' and 'eor' instructions.  This is faster than using explicit rotate
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

