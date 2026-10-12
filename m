Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8B73D3CEF;
	Mon, 12 Oct 2026 21:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791840685; cv=none; b=VaFYYRkgjndDS3gMMSw/cFlFM7zS5D92VngNOrjvNNdh3Sv1F9p7Bp4/tfQ9SC78PcFI3uPf3TxPbOouYQelC7EM98+IusJhzXARMCuUTiAq7exlMz7mjLQrL4of/LMLV8hG8GjcyGs7wsDmnPjo4Qco4c/sP9Nx1TLrHTM4pcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791840685; c=relaxed/simple;
	bh=GcFzL4ELL+nj+IyYHX4ybTeXBADFAD0vifTNK3LDVpE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=C9O6Tp4w10XLGPT5I6Vp3dAssk1APBRRph4wu2OkcKiJkzf13p+6j09Tb5qprUonaB+bUUTOAaIo1i4dIuQFhhzpo3eVstL8HqG5qypWZ2Pi0WJyOEqdyXarqVfEkX+Vph+uXbVD3gc092YvebmPMaPfYjGn79HJoOy0sUpsngA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JUujQ7gZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JUujQ7gZ"
Received: by smtp.kernel.org (Postfix) with ESMTPS id D85E6C2BD00;
	Mon, 12 Oct 2026 21:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791840684;
	bh=GcFzL4ELL+nj+IyYHX4ybTeXBADFAD0vifTNK3LDVpE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=JUujQ7gZEryMLbfpU/+xwAy//VOL6BczdfDYLGKRwdHOSdNvpoLCoG8vt5Lmp5Q5w
	 oLaLn6ZexYSve4umd/bGAvbhRayPc3yNmTyMOzrhQUL/mpTPy7lUgPBUBj1h+n/VP+
	 UjzZ50WC/1a3cQFWJEO3J2eIfGDBiJs09wSQmXC2cyQ/TePeIxWctwdP6/HhnQyLcI
	 xZP3jyoqCILgAARdAYjm1E6hWskNEbRt5RJYVBeqonGetbxQZ/8TUm0tt+WwEh81He
	 IIc11sRBcFXoUo3RTg4s7fa1Rfg8pZApkGlZvEzr2QbpBsWgLhJpLeh+7o+o8YRC64
	 S8j9HE3M4YMpA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD458CA9EC5;
	Mon, 12 Oct 2026 21:31:24 +0000 (UTC)
From: Vladimir Kukharenko via B4 Relay <devnull+vladimir.genproof.com@kernel.org>
Date: Mon, 12 Oct 2026 21:31:19 +0000
Subject: [PATCH 2/5] lib/crypto: mips/poly1305: Fix 32-bit length treated
 as 64-bit
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261012-libcrypto-4gib-lengths-v1-2-ea566c129a2e@genproof.com>
References: <20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com>
In-Reply-To: <20261012-libcrypto-4gib-lengths-v1-0-ea566c129a2e@genproof.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>, 
 "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard Biesheuvel <ardb@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-mips@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, 
 Vladimir Kukharenko <vladimir@genproof.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791840683; l=2076;
 i=vladimir@genproof.com; s=20261012; h=from:subject:message-id;
 bh=fo5zvO7UGWzgKX7Y6Cw4E2/Klsa+sRLhgZA+i34R0sg=;
 b=qNZ/9YoLUTr8vXw0bDqkJZS43lC7EbywsG6X/i3+sSaB8XXjEggmfsTbfNvgZUWX0Tu6pxc7B
 To4AbqoJXZaAUjuzCKv2HtNnM2a74xvrwkGl+SRB1gqKqFv4A28EdkB
X-Developer-Key: i=vladimir@genproof.com; a=ed25519;
 pk=EqOzBSKBgFn7ExzKj5f9T8u+1yTrGVlLBwf3fj/sdHM=
X-Endpoint-Received: by B4 Relay for vladimir@genproof.com/20261012 with
 auth_id=1169
X-Original-From: Vladimir Kukharenko <vladimir@genproof.com>
Reply-To: vladimir@genproof.com

From: Vladimir Kukharenko <vladimir@genproof.com>

The C code declares the length argument of the assembly function
poly1305_blocks() as u32.  The assembly comes from OpenSSL/CRYPTOGAMS,
which declares the length as size_t, and its 64-bit flavour uses all
64 bits of the register.  However, the MIPS n64 ABI keeps 32-bit values,
including unsigned ones, sign-extended in 64-bit registers.  So for a
length of 2 GiB or more, the assembly computes an end pointer 4 GiB
lower than the correct one, below the start of the input, and the loop
reads past the input until it faults.  poly1305_update() passes all
complete blocks to poly1305_blocks() in one call, so a single
poly1305_update() of 2 GiB to 4 GiB triggers this on 64-bit kernels.

Declare the length as size_t, as OpenSSL and the x86_64 code do, rather
than changing the imported assembly.  32-bit kernels use the o32 flavour
of the assembly, and size_t is 32 bits wide there, so nothing changes
for them.

This bug was introduced by commit a11d055e7a64 ("crypto: mips/poly1305 -
incorporate OpenSSL/CRYPTOGAMS optimized implementation").  No in-tree
caller passes 2 GiB or more in one call, so this is an ABI robustness
improvement.

I reproduced the fault on mips64 in QEMU with a single 2 GiB
poly1305_update(), and this patch fixes it.

Assisted-by: LLM
Signed-off-by: Vladimir Kukharenko <vladimir@genproof.com>
---
 lib/crypto/mips/poly1305.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/crypto/mips/poly1305.h b/lib/crypto/mips/poly1305.h
index 85de450f1a93..9e9147f40d17 100644
--- a/lib/crypto/mips/poly1305.h
+++ b/lib/crypto/mips/poly1305.h
@@ -8,7 +8,7 @@
 asmlinkage void poly1305_block_init(struct poly1305_block_state *state,
 				    const u8 raw_key[POLY1305_BLOCK_SIZE]);
 asmlinkage void poly1305_blocks(struct poly1305_block_state *state,
-				const u8 *src, u32 len, u32 hibit);
+				const u8 *src, size_t len, u32 hibit);
 asmlinkage void poly1305_emit(const struct poly1305_state *state,
 			      u8 digest[POLY1305_DIGEST_SIZE],
 			      const u32 nonce[4]);

-- 
2.43.0


